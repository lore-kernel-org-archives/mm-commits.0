From: akpm@linux-foundation.org
Subject: - signals-ia64-renumber-tif_restore_sigmask.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:22 -0700
Message-ID: <200805010927.m419RMEh030411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757671AbYEAJ22 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, heiko.carstens@de.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     signals: ia64 renumber TIF_RESTORE_SIGMASK
has been removed from the -mm tree.  Its filename was
     signals-ia64-renumber-tif_restore_sigmask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: ia64 renumber TIF_RESTORE_SIGMASK

DESC
signals: ia64 renumber TIF_RESTORE_SIGMASK

TIF_RESTORE_SIGMASK no longer needs to be in the _TIF_WORK_* masks.
Those low bits are scarce.  Renumber TIF_RESTORE_SIGMASK to free one up.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/process.c     |    2 +-
 include/asm-ia64/thread_info.h |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/ia64/kernel/process.c~signals-ia64-renumber-tif_restore_sigmask arch/ia64/kernel/process.c
--- a/arch/ia64/kernel/process.c~signals-ia64-renumber-tif_restore_sigmask
+++ a/arch/ia64/kernel/process.c
@@ -183,7 +183,7 @@ do_notify_resume_user (sigset_t *unused,
 #endif
 
 	/* deal with pending signal delivery */
-	if (test_thread_flag(TIF_SIGPENDING)||test_thread_flag(TIF_RESTORE_SIGMASK))
+	if (test_thread_flag(TIF_SIGPENDING))
 		ia64_do_signal(scr, in_syscall);
 
 	/* copy user rbs to kernel rbs */
diff -puN include/asm-ia64/thread_info.h~signals-ia64-renumber-tif_restore_sigmask include/asm-ia64/thread_info.h
--- a/include/asm-ia64/thread_info.h~signals-ia64-renumber-tif_restore_sigmask
+++ a/include/asm-ia64/thread_info.h
@@ -101,7 +101,6 @@ extern void tsk_clear_notify_resume(stru
 #define TIF_SYSCALL_TRACE	2	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	3	/* syscall auditing active */
 #define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
-#define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_NOTIFY_RESUME	6	/* resumption notification requested */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
@@ -109,6 +108,7 @@ extern void tsk_clear_notify_resume(stru
 #define TIF_DB_DISABLED		19	/* debug trap disabled for fsyscall */
 #define TIF_FREEZE		20	/* is freezing for suspend */
 #define TIF_RESTORE_RSE		21	/* user RBS is newer than kernel RBS */
+#define TIF_RESTORE_SIGMASK	22	/* restore signal mask in do_signal() */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
@@ -126,8 +126,7 @@ extern void tsk_clear_notify_resume(stru
 
 /* "work to do on user-return" bits */
 #define TIF_ALLWORK_MASK	(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME|_TIF_SYSCALL_AUDIT|\
-				 _TIF_NEED_RESCHED| _TIF_SYSCALL_TRACE|\
-				 _TIF_RESTORE_SIGMASK)
+				 _TIF_NEED_RESCHED|_TIF_SYSCALL_TRACE)
 /* like TIF_ALLWORK_BITS but sans TIF_SYSCALL_TRACE or TIF_SYSCALL_AUDIT */
 #define TIF_WORK_MASK		(TIF_ALLWORK_MASK&~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT))
 
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

