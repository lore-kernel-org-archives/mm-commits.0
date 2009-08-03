From: akpm@linux-foundation.org
Subject: + futex-futex_wait_requeue_pi-commentary-corrections.patch added to -mm tree
Date: Mon, 03 Aug 2009 14:58:26 -0700
Message-ID: <200908032158.n73LwQVk005552@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32995 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414AbZHCV6z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Aug 2009 17:58:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dvhltc@us.ibm.com, mingo@elte.hu, peterz@infradead.org, rostedt@goodmis.org, tglx@linutronix.de


The patch titled
     futex: futex_wait_requeue_pi commentary corrections
has been added to the -mm tree.  Its filename is
     futex-futex_wait_requeue_pi-commentary-corrections.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: futex: futex_wait_requeue_pi commentary corrections
From: Darren Hart <dvhltc@us.ibm.com>

The state machine described in the comments wasn't updated with a
follow-on fix.  Address that and cleanup the corresponding commentary in
the function.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff -puN kernel/futex.c~futex-futex_wait_requeue_pi-commentary-corrections kernel/futex.c
--- a/kernel/futex.c~futex-futex_wait_requeue_pi-commentary-corrections
+++ a/kernel/futex.c
@@ -2102,11 +2102,11 @@ int handle_early_requeue_pi_wakeup(struc
  * We call schedule in futex_wait_queue_me() when we enqueue and return there
  * via the following:
  * 1) wakeup on uaddr2 after an atomic lock acquisition by futex_requeue()
- * 2) wakeup on uaddr2 after a requeue and subsequent unlock
- * 3) signal (before or after requeue)
- * 4) timeout (before or after requeue)
+ * 2) wakeup on uaddr2 after a requeue
+ * 3) signal
+ * 4) timeout
  *
- * If 3, we setup a restart_block with futex_wait_requeue_pi() as the function.
+ * If 3, cleanup and return -ERESTARTNOINTR.
  *
  * If 2, we may then block on trying to take the rt_mutex and return via:
  * 5) successful lock
@@ -2114,7 +2114,7 @@ int handle_early_requeue_pi_wakeup(struc
  * 7) timeout
  * 8) other lock acquisition failure
  *
- * If 6, we setup a restart_block with futex_lock_pi() as the function.
+ * If 6, return -EWOULDBLOCK (restarting the syscall would do the same).
  *
  * If 4 or 7, we cleanup and return with -ETIMEDOUT.
  *
@@ -2232,14 +2232,11 @@ static int futex_wait_requeue_pi(u32 __u
 			rt_mutex_unlock(pi_mutex);
 	} else if (ret == -EINTR) {
 		/*
-		 * We've already been requeued, but we have no way to
-		 * restart by calling futex_lock_pi() directly. We
-		 * could restart the syscall, but that will look at
-		 * the user space value and return right away. So we
-		 * drop back with EWOULDBLOCK to tell user space that
-		 * "val" has been changed. That's the same what the
-		 * restart of the syscall would do in
-		 * futex_wait_setup().
+		 * We've already been requeued, but cannot restart by calling
+		 * futex_lock_pi() directly. We could restart this syscall, but
+		 * it would detect that the user space "val" changed and return
+		 * -EWOULDBLOCK.  Save the overhead of the restart and return
+		 * -EWOULDBLOCK directly.
 		 */
 		ret = -EWOULDBLOCK;
 	}
_

Patches currently in -mm which might be from dvhltc@us.ibm.com are

linux-next.patch
futex-futex_wait_requeue_pi-commentary-corrections.patch

