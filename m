From: akpm@osdl.org
Subject: + pm-fix-smp-races-in-the-freezer.patch added to -mm tree
Date: Sun, 10 Dec 2006 13:22:51 -0800
Message-ID: <200612102122.kBALMpAN003594@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:35749 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933336AbWLJVYI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 16:24:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ak@muc.de, benh@kernel.crashing.org, dhowells@redhat.com, lethal@linux-sh.org, paulus@samba.org, pavel@ucw.cz, rmk@arm.linux.org.uk, tony.luck@intel.com


The patch titled
     PM: Fix SMP races in the freezer
has been added to the -mm tree.  Its filename is
     pm-fix-smp-races-in-the-freezer.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PM: Fix SMP races in the freezer
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Currently, to tell a task that it should go to the refrigerator, we set the
PF_FREEZE flag for it and send a fake signal to it.  Unfortunately there
are two SMP-related problems with this approach.  First, a task running on
another CPU may be updating its flags while the freezer attempts to set
PF_FREEZE for it and this may leave the task's flags in an inconsistent
state.  Second, there is a potential race between freeze_process() and
refrigerator() in which freeze_process() running on one CPU is reading a
task's PF_FREEZE flag while refrigerator() running on another CPU has just
set PF_FROZEN for the same task and attempts to reset PF_FREEZE for it.  If
the refrigerator wins the race, freeze_process() will state that PF_FREEZE
hasn't been set for the task and will set it unnecessarily, so the task
will go to the refrigerator once again after it's been thawed.

To solve first of these problems we need to stop using PF_FREEZE to tell
tasks that they should go to the refrigerator.  Instead, we can introduce a
special TIF_*** flag and use it for this purpose, since it is allowed to
change the other tasks' TIF_*** flags and there are special calls for it.

To avoid the freeze_process()-refrigerator() race we can make
freeze_process() to always check the task's PF_FROZEN flag after it's read
its "freeze" flag.  We should also make sure that refrigerator() will
always reset the task's "freeze" flag after it's set PF_FROZEN for it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>
Cc: Andi Kleen <ak@muc.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-arm/thread_info.h     |    2 ++
 include/asm-frv/thread_info.h     |    2 ++
 include/asm-i386/thread_info.h    |    2 ++
 include/asm-ia64/thread_info.h    |    2 ++
 include/asm-powerpc/thread_info.h |    2 ++
 include/asm-sh/thread_info.h      |    2 ++
 include/asm-x86_64/thread_info.h  |    2 ++
 include/linux/freezer.h           |   11 ++++++-----
 include/linux/sched.h             |    1 -
 kernel/power/process.c            |   17 ++++++++++-------
 10 files changed, 30 insertions(+), 13 deletions(-)

diff -puN include/asm-arm/thread_info.h~pm-fix-smp-races-in-the-freezer include/asm-arm/thread_info.h
--- a/include/asm-arm/thread_info.h~pm-fix-smp-races-in-the-freezer
+++ a/include/asm-arm/thread_info.h
@@ -147,6 +147,7 @@ extern void iwmmxt_task_switch(struct th
 #define TIF_POLLING_NRFLAG	16
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18
+#define TIF_FREEZE		19
 
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -154,6 +155,7 @@ extern void iwmmxt_task_switch(struct th
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 /*
  * Change these and you break ASM code in entry-common.S
diff -puN include/asm-frv/thread_info.h~pm-fix-smp-races-in-the-freezer include/asm-frv/thread_info.h
--- a/include/asm-frv/thread_info.h~pm-fix-smp-races-in-the-freezer
+++ a/include/asm-frv/thread_info.h
@@ -116,6 +116,7 @@ register struct thread_info *__current_t
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* OOM killer killed process */
+#define TIF_FREEZE		18	/* freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -125,6 +126,7 @@ register struct thread_info *__current_t
 #define _TIF_IRET		(1 << TIF_IRET)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
diff -puN include/asm-i386/thread_info.h~pm-fix-smp-races-in-the-freezer include/asm-i386/thread_info.h
--- a/include/asm-i386/thread_info.h~pm-fix-smp-races-in-the-freezer
+++ a/include/asm-i386/thread_info.h
@@ -134,6 +134,7 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE		16
 #define TIF_DEBUG		17	/* uses debug registers */
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
+#define TIF_FREEZE		19	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -147,6 +148,7 @@ static inline struct thread_info *curren
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
diff -puN include/asm-ia64/thread_info.h~pm-fix-smp-races-in-the-freezer include/asm-ia64/thread_info.h
--- a/include/asm-ia64/thread_info.h~pm-fix-smp-races-in-the-freezer
+++ a/include/asm-ia64/thread_info.h
@@ -88,6 +88,7 @@ struct thread_info {
 #define TIF_MEMDIE		17
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
 #define TIF_DB_DISABLED		19	/* debug trap disabled for fsyscall */
+#define TIF_FREEZE		20	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
@@ -98,6 +99,7 @@ struct thread_info {
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_MCA_INIT		(1 << TIF_MCA_INIT)
 #define _TIF_DB_DISABLED	(1 << TIF_DB_DISABLED)
+#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 /* "work to do on user-return" bits */
 #define TIF_ALLWORK_MASK	(_TIF_NOTIFY_RESUME|_TIF_SIGPENDING|_TIF_NEED_RESCHED|_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
diff -puN include/asm-powerpc/thread_info.h~pm-fix-smp-races-in-the-freezer include/asm-powerpc/thread_info.h
--- a/include/asm-powerpc/thread_info.h~pm-fix-smp-races-in-the-freezer
+++ a/include/asm-powerpc/thread_info.h
@@ -122,6 +122,7 @@ static inline struct thread_info *curren
 #define TIF_RESTOREALL		12	/* Restore all regs (implies NOERROR) */
 #define TIF_NOERROR		14	/* Force successful syscall return */
 #define TIF_RESTORE_SIGMASK	15	/* Restore signal mask in do_signal */
+#define TIF_FREEZE		16	/* Freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -138,6 +139,7 @@ static inline struct thread_info *curren
 #define _TIF_RESTOREALL		(1<<TIF_RESTOREALL)
 #define _TIF_NOERROR		(1<<TIF_NOERROR)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
 
 #define _TIF_USER_WORK_MASK	(_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | \
diff -puN include/asm-sh/thread_info.h~pm-fix-smp-races-in-the-freezer include/asm-sh/thread_info.h
--- a/include/asm-sh/thread_info.h~pm-fix-smp-races-in-the-freezer
+++ a/include/asm-sh/thread_info.h
@@ -106,6 +106,7 @@ static inline struct thread_info *curren
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18
+#define TIF_FREEZE		19
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -114,6 +115,7 @@ static inline struct thread_info *curren
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x000000FE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x000000FF	/* work to do on any return to u-space */
diff -puN include/asm-x86_64/thread_info.h~pm-fix-smp-races-in-the-freezer include/asm-x86_64/thread_info.h
--- a/include/asm-x86_64/thread_info.h~pm-fix-smp-races-in-the-freezer
+++ a/include/asm-x86_64/thread_info.h
@@ -122,6 +122,7 @@ static inline struct thread_info *stack_
 #define TIF_MEMDIE		20
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
+#define TIF_FREEZE		23	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -137,6 +138,7 @@ static inline struct thread_info *stack_
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
+#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
diff -puN include/linux/freezer.h~pm-fix-smp-races-in-the-freezer include/linux/freezer.h
--- a/include/linux/freezer.h~pm-fix-smp-races-in-the-freezer
+++ a/include/linux/freezer.h
@@ -16,16 +16,15 @@ static inline int frozen(struct task_str
  */
 static inline int freezing(struct task_struct *p)
 {
-	return p->flags & PF_FREEZE;
+	return test_tsk_thread_flag(p, TIF_FREEZE);
 }
 
 /*
  * Request that a process be frozen
- * FIXME: SMP problem. We may not modify other process' flags!
  */
 static inline void freeze(struct task_struct *p)
 {
-	p->flags |= PF_FREEZE;
+	set_tsk_thread_flag(p, TIF_FREEZE);
 }
 
 /*
@@ -33,7 +32,7 @@ static inline void freeze(struct task_st
  */
 static inline void do_not_freeze(struct task_struct *p)
 {
-	p->flags &= ~PF_FREEZE;
+	clear_tsk_thread_flag(p, TIF_FREEZE);
 }
 
 /*
@@ -54,7 +53,9 @@ static inline int thaw_process(struct ta
  */
 static inline void frozen_process(struct task_struct *p)
 {
-	p->flags = (p->flags & ~PF_FREEZE) | PF_FROZEN;
+	p->flags |= PF_FROZEN;
+	wmb();
+	clear_tsk_thread_flag(p, TIF_FREEZE);
 }
 
 extern void refrigerator(void);
diff -puN include/linux/sched.h~pm-fix-smp-races-in-the-freezer include/linux/sched.h
--- a/include/linux/sched.h~pm-fix-smp-races-in-the-freezer
+++ a/include/linux/sched.h
@@ -1144,7 +1144,6 @@ static inline void put_task_struct(struc
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
 #define PF_FLUSHER	0x00001000	/* responsible for disk writeback */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
-#define PF_FREEZE	0x00004000	/* this task is being frozen for suspend now */
 #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
diff -puN kernel/power/process.c~pm-fix-smp-races-in-the-freezer kernel/power/process.c
--- a/kernel/power/process.c~pm-fix-smp-races-in-the-freezer
+++ a/kernel/power/process.c
@@ -60,13 +60,16 @@ static inline void freeze_process(struct
 	unsigned long flags;
 
 	if (!freezing(p)) {
-		if (p->state == TASK_STOPPED)
-			force_sig_specific(SIGSTOP, p);
-
-		freeze(p);
-		spin_lock_irqsave(&p->sighand->siglock, flags);
-		signal_wake_up(p, p->state == TASK_STOPPED);
-		spin_unlock_irqrestore(&p->sighand->siglock, flags);
+		rmb();
+		if (!frozen(p)) {
+			if (p->state == TASK_STOPPED)
+				force_sig_specific(SIGSTOP, p);
+
+			freeze(p);
+			spin_lock_irqsave(&p->sighand->siglock, flags);
+			signal_wake_up(p, p->state == TASK_STOPPED);
+			spin_unlock_irqrestore(&p->sighand->siglock, flags);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
pm-fix-freezing-of-stopped-tasks.patch
pm-fix-smp-races-in-the-freezer.patch
md-change-lifetime-rules-for-md-devices.patch

