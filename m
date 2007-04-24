From: akpm@linux-foundation.org
Subject: - kthread-enhance-kthread_stop-to-abort-interruptible-sleeps.patch removed from -mm tree
Date: Tue, 24 Apr 2007 03:09:44 -0700
Message-ID: <200704241009.l3OA9iM7005990@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161540AbXDXKKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Apr 2007 06:10:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, hch@lst.de, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     kthread: enhance kthread_stop to abort interruptible sleeps
has been removed from the -mm tree.  Its filename was
     kthread-enhance-kthread_stop-to-abort-interruptible-sleeps.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: kthread: enhance kthread_stop to abort interruptible sleeps
From: Eric W. Biederman <ebiederm@xmission.com>

This patch reworks kthread_stop so it is more flexible and it causes the
target kthread to abort interruptible sleeps.  Allowing a larger class of
kernel threads to use to the kthread API.

The changes start by defining TIF_KTHREAD_STOP on all architectures. 
TIF_KTHREAD_STOP is a per process flag that I can set from another process
to indicate that a kernel thread should stop.

wake_up_process in kthread_stop has been replaced by signal_wake_up
ensuring that the kernel thread if sleeping is woken up in a timely manner
and with TIF_SIGNAL_PENDING set, which causes us to break out of
interruptible sleeps.

recalc_signal_pending was modified to keep TIF_SIGNAL_PENDING set for as
long as TIF_KTHREAD_STOP is set.

Arbitrary paths to do_exit are now allowed.  I have placed a completion on
the thread stack and pointed vfork_done at it, when the mm_release is
called from do_exit the completion will be called.  Since the completion is
stored on the stack it is important that kthread() now calls do_exit
ensuring the stack frame that holds the completion is never released, and
so that our exit_code is certain to make it unchanged all the way to
do_exit.

To allow kthread_stop to read the process exit code when exit_mm wakes it
up I have moved the setting of exit_code to the beginning of do_exit.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/thread_info.h     |    1 
 include/asm-arm/thread_info.h       |    1 
 include/asm-arm26/thread_info.h     |    1 
 include/asm-avr32/thread_info.h     |    1 
 include/asm-cris/thread_info.h      |    1 
 include/asm-frv/thread_info.h       |    1 
 include/asm-h8300/thread_info.h     |    1 
 include/asm-i386/thread_info.h      |    1 
 include/asm-ia64/thread_info.h      |    1 
 include/asm-m32r/thread_info.h      |    1 
 include/asm-m68k/thread_info.h      |    1 
 include/asm-m68knommu/thread_info.h |    1 
 include/asm-mips/thread_info.h      |    1 
 include/asm-parisc/thread_info.h    |    1 
 include/asm-powerpc/thread_info.h   |    1 
 include/asm-s390/thread_info.h      |    1 
 include/asm-sh/thread_info.h        |    1 
 include/asm-sh64/thread_info.h      |    1 
 include/asm-sparc/thread_info.h     |    1 
 include/asm-sparc64/thread_info.h   |    1 
 include/asm-um/thread_info.h        |    1 
 include/asm-v850/thread_info.h      |    1 
 include/asm-x86_64/thread_info.h    |    1 
 include/asm-xtensa/thread_info.h    |    1 
 include/linux/kthread.h             |   20 +++++-
 kernel/exit.c                       |    2 
 kernel/kthread.c                    |   83 ++++++++------------------
 kernel/signal.c                     |    3 
 28 files changed, 73 insertions(+), 59 deletions(-)

diff -puN include/asm-alpha/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-alpha/thread_info.h
--- a/include/asm-alpha/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-alpha/thread_info.h
@@ -76,6 +76,7 @@ register struct thread_info *__current_t
 #define TIF_UAC_NOFIX		7
 #define TIF_UAC_SIGBUS		8
 #define TIF_MEMDIE		9
+#define TIF_KTHREAD_STOP	10
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff -puN include/asm-arm/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-arm/thread_info.h
--- a/include/asm-arm/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-arm/thread_info.h
@@ -148,6 +148,7 @@ extern void iwmmxt_task_switch(struct th
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18
 #define TIF_FREEZE		19
+#define TIF_KTHREAD_STOP	20
 
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
diff -puN include/asm-arm26/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-arm26/thread_info.h
--- a/include/asm-arm26/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-arm26/thread_info.h
@@ -123,6 +123,7 @@ extern void free_thread_info(struct thre
 #define TIF_USED_FPU		16
 #define TIF_POLLING_NRFLAG	17
 #define TIF_MEMDIE		18
+#define TIF_KTHREAD_STOP	19
 
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
diff -puN include/asm-avr32/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-avr32/thread_info.h
--- a/include/asm-avr32/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-avr32/thread_info.h
@@ -84,6 +84,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE		7
 #define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal */
 #define TIF_CPU_GOING_TO_SLEEP	9	/* CPU is entering sleep 0 mode */
+#define TIF_KTHREAD_STOP	10
 #define TIF_USERSPACE		31      /* true if FS sets userspace */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
diff -puN include/asm-cris/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-cris/thread_info.h
--- a/include/asm-cris/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-cris/thread_info.h
@@ -84,6 +84,7 @@ struct thread_info {
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
+#define TIF_KTHREAD_STOP	18
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff -puN include/asm-frv/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-frv/thread_info.h
--- a/include/asm-frv/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-frv/thread_info.h
@@ -117,6 +117,7 @@ register struct thread_info *__current_t
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* OOM killer killed process */
 #define TIF_FREEZE		18	/* freezing for suspend */
+#define TIF_KTHREAD_STOP	19
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
diff -puN include/asm-h8300/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-h8300/thread_info.h
--- a/include/asm-h8300/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-h8300/thread_info.h
@@ -92,6 +92,7 @@ static inline struct thread_info *curren
 #define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		5
+#define TIF_KTHREAD_STOP	6
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff -puN include/asm-i386/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-i386/thread_info.h
--- a/include/asm-i386/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-i386/thread_info.h
@@ -137,6 +137,7 @@ static inline struct thread_info *curren
 #define TIF_DEBUG		17	/* uses debug registers */
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
 #define TIF_FREEZE		19	/* is freezing for suspend */
+#define TIF_KTHREAD_STOP	20
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff -puN include/asm-ia64/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-ia64/thread_info.h
--- a/include/asm-ia64/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-ia64/thread_info.h
@@ -90,6 +90,7 @@ struct thread_info {
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
 #define TIF_DB_DISABLED		19	/* debug trap disabled for fsyscall */
 #define TIF_FREEZE		20	/* is freezing for suspend */
+#define TIF_KTHREAD_STOP	21
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
diff -puN include/asm-m32r/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-m32r/thread_info.h
--- a/include/asm-m32r/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-m32r/thread_info.h
@@ -154,6 +154,7 @@ static inline unsigned int get_thread_fa
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 					/* 31..28 fault code */
 #define TIF_MEMDIE		17
+#define TIF_KTHREAD_STOP	18
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff -puN include/asm-m68k/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-m68k/thread_info.h
--- a/include/asm-m68k/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-m68k/thread_info.h
@@ -58,5 +58,6 @@ struct thread_info {
 #define TIF_DELAYED_TRACE	14	/* single step a syscall */
 #define TIF_SYSCALL_TRACE	15	/* syscall trace active */
 #define TIF_MEMDIE		16
+#define TIF_KTHREAD_STOP	17
 
 #endif	/* _ASM_M68K_THREAD_INFO_H */
diff -puN include/asm-m68knommu/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-m68knommu/thread_info.h
--- a/include/asm-m68knommu/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-m68knommu/thread_info.h
@@ -89,6 +89,7 @@ static inline struct thread_info *curren
 #define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		5
+#define TIF_KTHREAD_STOP	6
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff -puN include/asm-mips/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-mips/thread_info.h
--- a/include/asm-mips/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-mips/thread_info.h
@@ -119,6 +119,7 @@ register struct thread_info *__current_t
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18
 #define TIF_FREEZE		19
+#define TIF_KTHREAD_STOP	20
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff -puN include/asm-parisc/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-parisc/thread_info.h
--- a/include/asm-parisc/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-parisc/thread_info.h
@@ -63,6 +63,7 @@ struct thread_info {
 #define TIF_32BIT               5       /* 32 bit binary */
 #define TIF_MEMDIE		6
 #define TIF_RESTORE_SIGMASK	7	/* restore saved signal mask */
+#define TIF_KTHREAD_STOP	8
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
diff -puN include/asm-powerpc/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-powerpc/thread_info.h
--- a/include/asm-powerpc/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-powerpc/thread_info.h
@@ -123,6 +123,7 @@ static inline struct thread_info *curren
 #define TIF_NOERROR		14	/* Force successful syscall return */
 #define TIF_RESTORE_SIGMASK	15	/* Restore signal mask in do_signal */
 #define TIF_FREEZE		16	/* Freezing for suspend */
+#define TIF_KTHREAD_STOP	17
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff -puN include/asm-s390/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-s390/thread_info.h
--- a/include/asm-s390/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-s390/thread_info.h
@@ -101,6 +101,7 @@ static inline struct thread_info *curren
 					   TIF_NEED_RESCHED */
 #define TIF_31BIT		18	/* 32bit process */ 
 #define TIF_MEMDIE		19
+#define TIF_KTHREAD_STOP	20
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
diff -puN include/asm-sh/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-sh/thread_info.h
--- a/include/asm-sh/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-sh/thread_info.h
@@ -116,6 +116,7 @@ static inline struct thread_info *curren
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18
 #define TIF_FREEZE		19
+#define TIF_KTHREAD_STOP	20
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff -puN include/asm-sh64/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-sh64/thread_info.h
--- a/include/asm-sh64/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-sh64/thread_info.h
@@ -78,6 +78,7 @@ static inline struct thread_info *curren
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_MEMDIE		4
+#define TIF_KTHREAD_STOP	5
 
 
 #endif /* __KERNEL__ */
diff -puN include/asm-sparc/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-sparc/thread_info.h
--- a/include/asm-sparc/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-sparc/thread_info.h
@@ -137,6 +137,7 @@ BTFIXUPDEF_CALL(void, free_thread_info, 
 #define TIF_POLLING_NRFLAG	9	/* true if poll_idle() is polling
 					 * TIF_NEED_RESCHED */
 #define TIF_MEMDIE		10
+#define TIF_KTHREAD_STOP	11
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff -puN include/asm-sparc64/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-sparc64/thread_info.h
--- a/include/asm-sparc64/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-sparc64/thread_info.h
@@ -236,6 +236,7 @@ register struct thread_info *current_thr
 #define TIF_ABI_PENDING		12
 #define TIF_MEMDIE		13
 #define TIF_POLLING_NRFLAG	14
+#define TIF_KTHREAD_STOP	15
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
diff -puN include/asm-um/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-um/thread_info.h
--- a/include/asm-um/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-um/thread_info.h
@@ -69,6 +69,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE	 	5
 #define TIF_SYSCALL_AUDIT	6
 #define TIF_RESTORE_SIGMASK	7
+#define TIF_KTHREAD_STOP	8
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
diff -puN include/asm-v850/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-v850/thread_info.h
--- a/include/asm-v850/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-v850/thread_info.h
@@ -83,6 +83,7 @@ struct thread_info {
 #define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE		5
+#define TIF_KTHREAD_STOP	6
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
diff -puN include/asm-x86_64/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-x86_64/thread_info.h
--- a/include/asm-x86_64/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-x86_64/thread_info.h
@@ -123,6 +123,7 @@ static inline struct thread_info *stack_
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FREEZE		23	/* is freezing for suspend */
+#define TIF_KTHREAD_STOP	24
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff -puN include/asm-xtensa/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/asm-xtensa/thread_info.h
--- a/include/asm-xtensa/thread_info.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/asm-xtensa/thread_info.h
@@ -117,6 +117,7 @@ static inline struct thread_info *curren
 #define TIF_IRET		5	/* return with iret */
 #define TIF_MEMDIE		6
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_KTHREAD_STOP	17
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
diff -puN include/linux/kthread.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps include/linux/kthread.h
--- a/include/linux/kthread.h~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/include/linux/kthread.h
@@ -10,7 +10,7 @@ struct task_struct *kthread_create(int (
 
 /**
  * kthread_run - create and wake a thread.
- * @threadfn: the function to run until signal_pending(current).
+ * @threadfn: the function to run until kthread_should_stop().
  * @data: data ptr for @threadfn.
  * @namefmt: printf-style name for the thread.
  *
@@ -28,7 +28,23 @@ struct task_struct *kthread_create(int (
 
 void kthread_bind(struct task_struct *k, unsigned int cpu);
 int kthread_stop(struct task_struct *k);
-int kthread_should_stop(void);
+
+static inline int __kthread_should_stop(struct task_struct *tsk)
+{
+	return test_tsk_thread_flag(tsk, TIF_KTHREAD_STOP);
+}
+
+/**
+ * kthread_should_stop - should this kthread return now?
+ *
+ * When someone calls kthread_stop() on your kthread, it will be woken
+ * and this will return true.  You should then return, and your return
+ * value will be passed through to kthread_stop().
+ */
+static inline int kthread_should_stop(void)
+{
+	return __kthread_should_stop(current);
+}
 
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
diff -puN kernel/exit.c~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps kernel/exit.c
--- a/kernel/exit.c~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/kernel/exit.c
@@ -893,6 +893,7 @@ fastcall NORET_TYPE void do_exit(long co
 	}
 
 	tsk->flags |= PF_EXITING;
+	tsk->exit_code = code;
 
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
@@ -939,7 +940,6 @@ fastcall NORET_TYPE void do_exit(long co
 	if (tsk->binfmt)
 		module_put(tsk->binfmt->module);
 
-	tsk->exit_code = code;
 	proc_exit_connector(tsk);
 	exit_task_namespaces(tsk);
 	exit_notify(tsk);
diff -puN kernel/kthread.c~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps kernel/kthread.c
--- a/kernel/kthread.c~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/kernel/kthread.c
@@ -33,38 +33,18 @@ struct kthread_create_info
 	struct list_head list;
 };
 
-struct kthread_stop_info
-{
-	struct task_struct *k;
-	int err;
-	struct completion done;
-};
-
-/* Thread stopping is done by setthing this var: lock serializes
- * multiple kthread_stop calls. */
-static DEFINE_MUTEX(kthread_stop_lock);
-static struct kthread_stop_info kthread_stop_info;
-
-/**
- * kthread_should_stop - should this kthread return now?
- *
- * When someone calls kthread_stop() on your kthread, it will be woken
- * and this will return true.  You should then return, and your return
- * value will be passed through to kthread_stop().
- */
-int kthread_should_stop(void)
-{
-	return (kthread_stop_info.k == current);
-}
-EXPORT_SYMBOL(kthread_should_stop);
-
 static int kthread(void *_create)
 {
 	struct kthread_create_info *create = _create;
+	struct completion done;
 	int (*threadfn)(void *data);
 	void *data;
 	int ret = -EINTR;
 
+	/* Setup a completion on this thread's stack */
+	init_completion(&done);
+	current->vfork_done = &done;
+
 	/* Copy data: it's on kthread's stack */
 	threadfn = create->threadfn;
 	data = create->data;
@@ -77,12 +57,7 @@ static int kthread(void *_create)
 	if (!kthread_should_stop())
 		ret = threadfn(data);
 
-	/* It might have exited on its own, w/o kthread_stop.  Check. */
-	if (kthread_should_stop()) {
-		kthread_stop_info.err = ret;
-		complete(&kthread_stop_info.done);
-	}
-	return 0;
+	do_exit(ret);
 }
 
 static void create_kthread(struct kthread_create_info *create)
@@ -104,7 +79,7 @@ static void create_kthread(struct kthrea
 
 /**
  * kthread_create - create a kthread.
- * @threadfn: the function to run until signal_pending(current).
+ * @threadfn: the function to run until kthread_should_stop().
  * @data: data ptr for @threadfn.
  * @namefmt: printf-style name for the thread.
  *
@@ -174,38 +149,36 @@ EXPORT_SYMBOL(kthread_bind);
  * kthread_stop - stop a thread created by kthread_create().
  * @k: thread created by kthread_create().
  *
- * Sets kthread_should_stop() for @k to return true, wakes it, and
- * waits for it to exit.  Your threadfn() must not call do_exit()
- * itself if you use this function!  This can also be called after
- * kthread_create() instead of calling wake_up_process(): the thread
- * will exit without calling threadfn().
+ * Sets TIF_KTHREAD_STOP for @k, wakes it and waits for it to exit.
+ *
+ * kthread_stop should be called exactly once on @k.
+ *
+ * This can also be called after kthread_create() instead of calling
+ * wake_up_process(): the thread  will exit without calling threadfn().
+ *
+ * If your threadfn may terminate before you call kthread_stop
+ * you should call get_task_struct on @k so it is valid when you call
+ * kthread_stop.
  *
  * Returns the result of threadfn(), or %-EINTR if wake_up_process()
  * was never called.
  */
-int kthread_stop(struct task_struct *k)
+int kthread_stop(struct task_struct *tsk)
 {
 	int ret;
 
-	mutex_lock(&kthread_stop_lock);
+	/* Ensure the task struct persists until I read the exit code. */
+	get_task_struct(tsk);
+
+	set_tsk_thread_flag(tsk, TIF_KTHREAD_STOP);
+	spin_lock_irq(&tsk->sighand->siglock);
+	signal_wake_up(tsk, 1);
+	spin_unlock_irq(&tsk->sighand->siglock);
 
-	/* It could exit after stop_info.k set, but before wake_up_process. */
-	get_task_struct(k);
+	wait_for_completion(tsk->vfork_done);
+	ret = tsk->exit_code;
 
-	/* Must init completion *before* thread sees kthread_stop_info.k */
-	init_completion(&kthread_stop_info.done);
-	smp_wmb();
-
-	/* Now set kthread_should_stop() to true, and wake it up. */
-	kthread_stop_info.k = k;
-	wake_up_process(k);
-	put_task_struct(k);
-
-	/* Once it dies, reset stop ptr, gather result and we're done. */
-	wait_for_completion(&kthread_stop_info.done);
-	kthread_stop_info.k = NULL;
-	ret = kthread_stop_info.err;
-	mutex_unlock(&kthread_stop_lock);
+	put_task_struct(tsk);
 
 	return ret;
 }
diff -puN kernel/signal.c~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps kernel/signal.c
--- a/kernel/signal.c~kthread-enhance-kthread_stop-to-abort-interruptible-sleeps
+++ a/kernel/signal.c
@@ -25,6 +25,7 @@
 #include <linux/freezer.h>
 #include <linux/pid_namespace.h>
 #include <linux/nsproxy.h>
+#include <linux/kthread.h>
 
 #include <asm/param.h>
 #include <asm/uaccess.h>
@@ -217,7 +218,7 @@ static inline int has_pending_signals(si
 fastcall void recalc_sigpending_tsk(struct task_struct *t)
 {
 	if (t->signal->group_stop_count > 0 ||
-	    (freezing(t)) ||
+	    (freezing(t)) || __kthread_should_stop(t) ||
 	    PENDING(&t->pending, &t->blocked) ||
 	    PENDING(&t->signal->shared_pending, &t->blocked))
 		set_tsk_thread_flag(t, TIF_SIGPENDING);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

arm-ecard-convert-to-use-the-kthread-api.patch
powerpc-rtas-msi-support.patch
macintosh-mediabay-convert-to-kthread-api.patch
macintosh-adb-convert-to-the-kthread-api.patch
macintosh-therm_pm72c-partially-convert-to-kthread-api.patch
powerpc-pseries-rtasd-convert-to-kthread-api.patch
powerpc-pseries-eeh-convert-to-kthread-api.patch
dvb_en_50221-convert-to-kthread-api.patch
mm-only-saa7134-tvaudio-convert-to-kthread-api.patch
ia64-sn-xpc-convert-to-use-kthread-api.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
git-mtd.patch
fix-i-oat-for-kexec.patch
cpqphp-partially-convert-to-use-the-kthread-api.patch
ibmphp-partially-convert-to-use-the-kthreads-api.patch
cpci_hotplug-partially-convert-to-use-the-kthread-api.patch
s390-scsi-zfcp_erp-partially-convert-to-use-the-kthread-api.patch
s390-qeth-convert-to-use-the-kthread-api.patch
s390-net-lcs-convert-to-the-kthread-api.patch
sas_scsi_host-partially-convert-to-use-the-kthread-api.patch
sparc64-powerc-convert-to-use-the-kthread-api.patch
i386-irq-kill-irq-compression.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
i386-voyager-convert-the-monitor-thread-to-use-the-kthread-api.patch
i386-balance_irq-convert-to-the-kthread-api.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
allow-access-to-proc-pid-fd-after-setuid.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
fix-race-between-proc_get_inode-and-remove_proc_entry.patch
fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-reorder-struct-pid_dentry-to-save-space-on-64bit-archs-and-constify-them.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up-fix.patch
clean-up-elf-note-generation.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
use-the-apic-to-determine-the-hardware-processor-id-i386.patch
use-the-apic-to-determine-the-hardware-processor-id-x86_64.patch
always-ask-the-hardware-to-obtain-hardware-processor-id-ia64.patch
proc-cleanup-use-seq_release_private-where-appropriate.patch
smbfs-remove-unnecessary-allow_signal.patch
pnpbios-conert-to-use-the-kthread-api.patch
kthread-dont-depend-on-work-queues-take-2.patch
kthread-dont-depend-on-work-queues-take-2-fix.patch
change-reparent_to_init-to-reparent_to_kthreadd.patch
kthread-enhance-kthread_stop-to-abort-interruptible-sleeps.patch
kthread-simplify-kthread_create.patch
wait_for_helper-remove-unneeded-do_sigaction.patch
worker_thread-dont-play-with-sigchld-and-numa-policy.patch
change-kernel-threads-to-ignore-signals-instead-of-blocking-them.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
edac-k8-driver-coding-tidy.patch
nfsd-nfs4state-remove-unnecessary-daemonize-call.patch
statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-and-sid-of-init-process.patch
use-struct-pid-parameter-in-copy_process.patch
use-task_pgrp-task_session-in-copy_process.patch
kill-unused-sesssion-and-group-values-in-rocket-driver.patch
fix-some-coding-style-errors-in-autofs.patch
replace-pid_t-in-autofs-with-struct-pid-reference.patch
dont-init-pgrp-and-__session-in-init_signals.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-account-user-mounts-fix.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt-fix.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-bind-mounts-fix.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
md-remove-broken-sigkill-support.patch
mutex-subsystem-synchro-test-module-convert-to-the-kthread-api.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
