From: akpm@linux-foundation.org
Subject: - signals-set_restore_sigmask-tif_sigpending.patch removed from -mm tree
Date: Thu, 01 May 2008 02:27:17 -0700
Message-ID: <200805010927.m419RHYT030402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757783AbYEAJ2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, heiko.carstens@de.ibm.com, mingo@elte.hu, oleg@tv-sign.ru, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     signals: set_restore_sigmask TIF_SIGPENDING
has been removed from the -mm tree.  Its filename was
     signals-set_restore_sigmask-tif_sigpending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: set_restore_sigmask TIF_SIGPENDING
From: Roland McGrath <roland@redhat.com>

Set TIF_SIGPENDING in set_restore_sigmask.  This lets arch code take
TIF_RESTORE_SIGMASK out of the set of bits that will be noticed on return to
user mode.  On some machines those bits are scarce, and we can free this
unneeded one up for other uses.

It is probably the case that TIF_SIGPENDING is always set anyway everywhere
set_restore_sigmask() is used.  But this is some cheap paranoia in case there
is an arcane case where it might not be.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/thread_info.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/thread_info.h~signals-set_restore_sigmask-tif_sigpending include/linux/thread_info.h
--- a/include/linux/thread_info.h~signals-set_restore_sigmask-tif_sigpending
+++ a/include/linux/thread_info.h
@@ -97,11 +97,17 @@ static inline int test_ti_thread_flag(st
  * set_restore_sigmask() - make sure saved_sigmask processing gets done
  *
  * This sets TIF_RESTORE_SIGMASK and ensures that the arch signal code
- * will run before returning to user mode, to process the flag.
+ * will run before returning to user mode, to process the flag.  For
+ * all callers, TIF_SIGPENDING is already set or it's no harm to set
+ * it.  TIF_RESTORE_SIGMASK need not be in the set of bits that the
+ * arch code will notice on return to user mode, in case those bits
+ * are scarce.  We set TIF_SIGPENDING here to ensure that the arch
+ * signal code always gets run when TIF_RESTORE_SIGMASK is set.
  */
 static inline void set_restore_sigmask(void)
 {
 	set_thread_flag(TIF_RESTORE_SIGMASK);
+	set_thread_flag(TIF_SIGPENDING);
 }
 #endif	/* TIF_RESTORE_SIGMASK */
 
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
posix-timers-bug-10460-discard-the-pending-signal-when-the-timer-is-destroyed.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

