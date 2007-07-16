From: akpm@linux-foundation.org
Subject: - make-seccomp-zerocost-in-schedule.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:58:18 -0700
Message-ID: <200707162058.l6GKwIg3002337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760722AbXGPVP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrea@cpushare.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     make seccomp zerocost in schedule
has been removed from the -mm tree.  Its filename was
     make-seccomp-zerocost-in-schedule.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make seccomp zerocost in schedule
From: Andrea Arcangeli <andrea@cpushare.com>

This follows a suggestion from Chuck Ebbert on how to make seccomp
absolutely zerocost in schedule too.  The only remaining footprint of
seccomp is in terms of the bzImage size that becomes a few bytes (perhaps
even a few kbytes) larger, measure it if you care in the embedded.

Signed-off-by: Andrea Arcangeli <andrea@cpushare.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/process.c     |   73 ++++++++++++++++---------------
 include/asm-i386/processor.h   |    4 +
 include/asm-i386/thread_info.h |    5 +-
 include/linux/seccomp.h        |   10 ----
 kernel/seccomp.c               |    3 +
 5 files changed, 50 insertions(+), 45 deletions(-)

diff -puN arch/i386/kernel/process.c~make-seccomp-zerocost-in-schedule arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c~make-seccomp-zerocost-in-schedule
+++ a/arch/i386/kernel/process.c
@@ -538,8 +538,31 @@ int dump_task_regs(struct task_struct *t
 	return 1;
 }
 
-static noinline void __switch_to_xtra(struct task_struct *next_p,
-				    struct tss_struct *tss)
+#ifdef CONFIG_SECCOMP
+void hard_disable_TSC(void)
+{
+	write_cr4(read_cr4() | X86_CR4_TSD);
+}
+void disable_TSC(void)
+{
+	preempt_disable();
+	if (!test_and_set_thread_flag(TIF_NOTSC))
+		/*
+		 * Must flip the CPU state synchronously with
+		 * TIF_NOTSC in the current running context.
+		 */
+		hard_disable_TSC();
+	preempt_enable();
+}
+void hard_enable_TSC(void)
+{
+	write_cr4(read_cr4() & ~X86_CR4_TSD);
+}
+#endif /* CONFIG_SECCOMP */
+
+static noinline void
+__switch_to_xtra(struct task_struct *prev_p, struct task_struct *next_p,
+		 struct tss_struct *tss)
 {
 	struct thread_struct *next;
 
@@ -555,6 +578,17 @@ static noinline void __switch_to_xtra(st
 		set_debugreg(next->debugreg[7], 7);
 	}
 
+#ifdef CONFIG_SECCOMP
+	if (test_tsk_thread_flag(prev_p, TIF_NOTSC) ^
+	    test_tsk_thread_flag(next_p, TIF_NOTSC)) {
+		/* prev and next are different */
+		if (test_tsk_thread_flag(next_p, TIF_NOTSC))
+			hard_disable_TSC();
+		else
+			hard_enable_TSC();
+	}
+#endif
+
 	if (!test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
 		/*
 		 * Disable the bitmap via an invalid offset. We still cache
@@ -586,33 +620,6 @@ static noinline void __switch_to_xtra(st
 }
 
 /*
- * This function selects if the context switch from prev to next
- * has to tweak the TSC disable bit in the cr4.
- */
-static inline void disable_tsc(struct task_struct *prev_p,
-			       struct task_struct *next_p)
-{
-	struct thread_info *prev, *next;
-
-	/*
-	 * gcc should eliminate the ->thread_info dereference if
-	 * has_secure_computing returns 0 at compile time (SECCOMP=n).
-	 */
-	prev = task_thread_info(prev_p);
-	next = task_thread_info(next_p);
-
-	if (has_secure_computing(prev) || has_secure_computing(next)) {
-		/* slow path here */
-		if (has_secure_computing(prev) &&
-		    !has_secure_computing(next)) {
-			write_cr4(read_cr4() & ~X86_CR4_TSD);
-		} else if (!has_secure_computing(prev) &&
-			   has_secure_computing(next))
-			write_cr4(read_cr4() | X86_CR4_TSD);
-	}
-}
-
-/*
  *	switch_to(x,yn) should switch tasks from x to y.
  *
  * We fsave/fwait so that an exception goes off at the right time
@@ -689,11 +696,9 @@ struct task_struct fastcall * __switch_t
 	/*
 	 * Now maybe handle debug registers and/or IO bitmaps
 	 */
-	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW)
-	    || test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)))
-		__switch_to_xtra(next_p, tss);
-
-	disable_tsc(prev_p, next_p);
+	if (unlikely(task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV ||
+		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
+		__switch_to_xtra(prev_p, next_p, tss);
 
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
diff -puN include/asm-i386/processor.h~make-seccomp-zerocost-in-schedule include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~make-seccomp-zerocost-in-schedule
+++ a/include/asm-i386/processor.h
@@ -228,6 +228,10 @@ extern int bootloader_type;
 
 #define HAVE_ARCH_PICK_MMAP_LAYOUT
 
+extern void hard_disable_TSC(void);
+extern void disable_TSC(void);
+extern void hard_enable_TSC(void);
+
 /*
  * Size of io_bitmap.
  */
diff -puN include/asm-i386/thread_info.h~make-seccomp-zerocost-in-schedule include/asm-i386/thread_info.h
--- a/include/asm-i386/thread_info.h~make-seccomp-zerocost-in-schedule
+++ a/include/asm-i386/thread_info.h
@@ -137,6 +137,7 @@ static inline struct thread_info *curren
 #define TIF_DEBUG		17	/* uses debug registers */
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
 #define TIF_FREEZE		19	/* is freezing for suspend */
+#define TIF_NOTSC		20	/* TSC is not accessible in userland */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -151,6 +152,7 @@ static inline struct thread_info *curren
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_NOTSC		(1<<TIF_NOTSC)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
@@ -160,7 +162,8 @@ static inline struct thread_info *curren
 #define _TIF_ALLWORK_MASK	(0x0000FFFF & ~_TIF_SECCOMP)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW (_TIF_DEBUG|_TIF_IO_BITMAP)
+#define _TIF_WORK_CTXSW_NEXT (_TIF_IO_BITMAP | _TIF_NOTSC | _TIF_DEBUG)
+#define _TIF_WORK_CTXSW_PREV (_TIF_IO_BITMAP | _TIF_NOTSC)
 
 /*
  * Thread-synchronous status.
diff -puN include/linux/seccomp.h~make-seccomp-zerocost-in-schedule include/linux/seccomp.h
--- a/include/linux/seccomp.h~make-seccomp-zerocost-in-schedule
+++ a/include/linux/seccomp.h
@@ -16,11 +16,6 @@ static inline void secure_computing(int 
 		__secure_computing(this_syscall);
 }
 
-static inline int has_secure_computing(struct thread_info *ti)
-{
-	return unlikely(test_ti_thread_flag(ti, TIF_SECCOMP));
-}
-
 extern long prctl_get_seccomp(void);
 extern long prctl_set_seccomp(unsigned long);
 
@@ -29,11 +24,6 @@ extern long prctl_set_seccomp(unsigned l
 typedef struct { } seccomp_t;
 
 #define secure_computing(x) do { } while (0)
-/* static inline to preserve typechecking */
-static inline int has_secure_computing(struct thread_info *ti)
-{
-	return 0;
-}
 
 static inline long prctl_get_seccomp(void)
 {
diff -puN kernel/seccomp.c~make-seccomp-zerocost-in-schedule kernel/seccomp.c
--- a/kernel/seccomp.c~make-seccomp-zerocost-in-schedule
+++ a/kernel/seccomp.c
@@ -74,6 +74,9 @@ long prctl_set_seccomp(unsigned long sec
 	if (seccomp_mode && seccomp_mode <= NR_SECCOMP_MODES) {
 		current->seccomp.mode = seccomp_mode;
 		set_thread_flag(TIF_SECCOMP);
+#ifdef TIF_NOTSC
+		disable_TSC();
+#endif
 		ret = 0;
 	}
 
_

Patches currently in -mm which might be from andrea@cpushare.com are

origin.patch
