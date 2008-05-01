From: akpm@linux-foundation.org
Subject: - signals-s390-renumber-tif_restore_sigmask.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:20 -0700
Message-ID: <200805010927.m419RKdB030405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825AbYEAJ2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, heiko.carstens@de.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     signals: s390: renumber TIF_RESTORE_SIGMASK
has been removed from the -mm tree.  Its filename was
     signals-s390-renumber-tif_restore_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: s390: renumber TIF_RESTORE_SIGMASK
From: Roland McGrath <roland@redhat.com>

TIF_RESTORE_SIGMASK no longer needs to be in the _TIF_WORK_* masks.  Those low
bits are scarce, and are all used up now.  Renumber TIF_RESTORE_SIGMASK to
free one up.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/entry.S       |   14 +++++++-------
 arch/s390/kernel/entry64.S     |   12 ++++++------
 include/asm-s390/thread_info.h |    2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff -puN arch/s390/kernel/entry.S~signals-s390-renumber-tif_restore_sigmask arch/s390/kernel/entry.S
--- a/arch/s390/kernel/entry.S~signals-s390-renumber-tif_restore_sigmask
+++ a/arch/s390/kernel/entry.S
@@ -49,9 +49,9 @@ SP_ILC	     =	STACK_FRAME_OVERHEAD + __P
 SP_TRAP      =	STACK_FRAME_OVERHEAD + __PT_TRAP
 SP_SIZE      =	STACK_FRAME_OVERHEAD + __PT_SIZE
 
-_TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NEED_RESCHED | \
+_TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING | _TIF_RESTART_SVC | _TIF_SINGLE_STEP )
-_TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NEED_RESCHED | \
+_TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING)
 
 STACK_SHIFT = PAGE_SHIFT + THREAD_ORDER
@@ -316,7 +316,7 @@ sysc_work:
 	bo	BASED(sysc_mcck_pending)
 	tm	__TI_flags+3(%r9),_TIF_NEED_RESCHED
 	bo	BASED(sysc_reschedule)
-	tm	__TI_flags+3(%r9),(_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK)
+	tm	__TI_flags+3(%r9),_TIF_SIGPENDING
 	bnz	BASED(sysc_sigpending)
 	tm	__TI_flags+3(%r9),_TIF_RESTART_SVC
 	bo	BASED(sysc_restart)
@@ -342,7 +342,7 @@ sysc_mcck_pending:
 	br	%r1			# TIF bit will be cleared by handler
 
 #
-# _TIF_SIGPENDING or _TIF_RESTORE_SIGMASK is set, call do_signal
+# _TIF_SIGPENDING is set, call do_signal
 #
 sysc_sigpending:
 	ni	__TI_flags+3(%r9),255-_TIF_SINGLE_STEP # clear TIF_SINGLE_STEP
@@ -657,7 +657,7 @@ io_work:
 	lr	%r15,%r1
 #
 # One of the work bits is on. Find out which one.
-# Checked are: _TIF_SIGPENDING, _TIF_RESTORE_SIGMASK, _TIF_NEED_RESCHED
+# Checked are: _TIF_SIGPENDING, _TIF_NEED_RESCHED
 #		and _TIF_MCCK_PENDING
 #
 io_work_loop:
@@ -665,7 +665,7 @@ io_work_loop:
 	bo	BASED(io_mcck_pending)
 	tm	__TI_flags+3(%r9),_TIF_NEED_RESCHED
 	bo	BASED(io_reschedule)
-	tm	__TI_flags+3(%r9),(_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK)
+	tm	__TI_flags+3(%r9),_TIF_SIGPENDING
 	bnz	BASED(io_sigpending)
 	b	BASED(io_restore)
 io_work_done:
@@ -693,7 +693,7 @@ io_reschedule:
 	b	BASED(io_work_loop)
 
 #
-# _TIF_SIGPENDING or _TIF_RESTORE_SIGMASK is set, call do_signal
+# _TIF_SIGPENDING is set, call do_signal
 #
 io_sigpending:
 	TRACE_IRQS_ON
diff -puN arch/s390/kernel/entry64.S~signals-s390-renumber-tif_restore_sigmask arch/s390/kernel/entry64.S
--- a/arch/s390/kernel/entry64.S~signals-s390-renumber-tif_restore_sigmask
+++ a/arch/s390/kernel/entry64.S
@@ -52,9 +52,9 @@ SP_SIZE      =	STACK_FRAME_OVERHEAD + __
 STACK_SHIFT = PAGE_SHIFT + THREAD_ORDER
 STACK_SIZE  = 1 << STACK_SHIFT
 
-_TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NEED_RESCHED | \
+_TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING | _TIF_RESTART_SVC | _TIF_SINGLE_STEP )
-_TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NEED_RESCHED | \
+_TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_NEED_RESCHED | \
 		 _TIF_MCCK_PENDING)
 
 #define BASED(name) name-system_call(%r13)
@@ -308,7 +308,7 @@ sysc_work:
 	jo	sysc_mcck_pending
 	tm	__TI_flags+7(%r9),_TIF_NEED_RESCHED
 	jo	sysc_reschedule
-	tm	__TI_flags+7(%r9),(_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK)
+	tm	__TI_flags+7(%r9),_TIF_SIGPENDING
 	jnz	sysc_sigpending
 	tm	__TI_flags+7(%r9),_TIF_RESTART_SVC
 	jo	sysc_restart
@@ -332,7 +332,7 @@ sysc_mcck_pending:
 	jg	s390_handle_mcck	# TIF bit will be cleared by handler
 
 #
-# _TIF_SIGPENDING or _TIF_RESTORE_SIGMASK is set, call do_signal
+# _TIF_SIGPENDING is set, call do_signal
 #
 sysc_sigpending:
 	ni	__TI_flags+7(%r9),255-_TIF_SINGLE_STEP # clear TIF_SINGLE_STEP
@@ -648,7 +648,7 @@ io_work_loop:
 	jo	io_mcck_pending
 	tm	__TI_flags+7(%r9),_TIF_NEED_RESCHED
 	jo	io_reschedule
-	tm	__TI_flags+7(%r9),(_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK)
+	tm	__TI_flags+7(%r9),_TIF_SIGPENDING
 	jnz	io_sigpending
 	j	io_restore
 io_work_done:
@@ -674,7 +674,7 @@ io_reschedule:
 	j	io_work_loop
 
 #
-# _TIF_SIGPENDING or _TIF_RESTORE_SIGMASK is set, call do_signal
+# _TIF_SIGPENDING or is set, call do_signal
 #
 io_sigpending:
 	TRACE_IRQS_ON
diff -puN include/asm-s390/thread_info.h~signals-s390-renumber-tif_restore_sigmask include/asm-s390/thread_info.h
--- a/include/asm-s390/thread_info.h~signals-s390-renumber-tif_restore_sigmask
+++ a/include/asm-s390/thread_info.h
@@ -89,7 +89,6 @@ static inline struct thread_info *curren
  * thread information flags bit numbers
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_RESTORE_SIGMASK	1	/* restore signal mask in do_signal() */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_RESTART_SVC		4	/* restart svc with new svc number */
@@ -101,6 +100,7 @@ static inline struct thread_info *curren
 					   TIF_NEED_RESCHED */
 #define TIF_31BIT		18	/* 32bit process */ 
 #define TIF_MEMDIE		19
+#define TIF_RESTORE_SIGMASK	20	/* restore signal mask in do_signal() */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

