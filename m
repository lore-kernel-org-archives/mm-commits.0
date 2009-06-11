From: akpm@linux-foundation.org
Subject: [merged] frv-implement-tif_notify_resume.patch removed from -mm tree
Date: Thu, 11 Jun 2009 14:25:10 -0700
Message-ID: <200906112125.n5BLPAbA018154@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766AbZFKV0R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Jun 2009 17:26:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: implement TIF_NOTIFY_RESUME
has been removed from the -mm tree.  Its filename was
     frv-implement-tif_notify_resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: implement TIF_NOTIFY_RESUME
From: David Howells <dhowells@redhat.com>

Implement the TIF_NOTIFY_RESUME thread flag, making it call
do_notify_resume() which then clears it.  This will be made use of later
by tracehooks in the new-style ptrace implementation

Also discard TIF_IRET as that's not used by FRV.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/thread_info.h |   10 +++++-----
 arch/frv/kernel/signal.c           |    5 +++++
 2 files changed, 10 insertions(+), 5 deletions(-)

diff -puN arch/frv/include/asm/thread_info.h~frv-implement-tif_notify_resume arch/frv/include/asm/thread_info.h
--- a/arch/frv/include/asm/thread_info.h~frv-implement-tif_notify_resume
+++ a/arch/frv/include/asm/thread_info.h
@@ -109,20 +109,20 @@ register struct thread_info *__current_t
  * - other flags in MSW
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_SIGPENDING		1	/* signal pending */
-#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
-#define TIF_IRET		4	/* return with iret */
+#define TIF_NOTIFY_RESUME	1	/* callback before returning to user */
+#define TIF_SIGPENDING		2	/* signal pending */
+#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* OOM killer killed process */
 #define TIF_FREEZE		18	/* freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
+#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
-#define _TIF_IRET		(1 << TIF_IRET)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
diff -puN arch/frv/kernel/signal.c~frv-implement-tif_notify_resume arch/frv/kernel/signal.c
--- a/arch/frv/kernel/signal.c~frv-implement-tif_notify_resume
+++ a/arch/frv/kernel/signal.c
@@ -564,4 +564,9 @@ asmlinkage void do_notify_resume(__u32 t
 	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
 		do_signal();
 
+	/* deal with notification on about to resume userspace execution */
+	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
+		clear_thread_flag(TIF_NOTIFY_RESUME);
+	}
+
 } /* end do_notify_resume() */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-duplicate-output_buffer-of-e03.patch
rework-fix-is_single_threaded.patch
use-round_jiffies-for-slow-work-thread-pools-cull-and-oom-timers.patch
kmap_types-make-most-arches-use-generic-header-file.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
mutex-subsystem-synchro-test-module.patch

