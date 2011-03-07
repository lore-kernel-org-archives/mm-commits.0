From: akpm@linux-foundation.org
Subject: + futex-update-futex_wait_setup-comments-about-locking.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:17:09 -0800
Message-ID: <201103072217.p27MH9g3030542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755982Ab1CGWSH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 17:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dvhltc@us.ibm.com, mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de


The patch titled
     futex: update futex_wait_setup() comments about locking
has been added to the -mm tree.  Its filename is
     futex-update-futex_wait_setup-comments-about-locking.patch

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
Subject: futex: update futex_wait_setup() comments about locking
From: Michel Lespinasse <walken@google.com>

Reviving a cleanup I had done about a year ago as part of a larger
futex_set_wait proposal.  Over the years, the locking of the hashed futex
queue got improved, so that some of the "rare but normal" race conditions
described in comments can't actually happen anymore.

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/futex.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN kernel/futex.c~futex-update-futex_wait_setup-comments-about-locking kernel/futex.c
--- a/kernel/futex.c~futex-update-futex_wait_setup-comments-about-locking
+++ a/kernel/futex.c
@@ -1783,13 +1783,14 @@ static int futex_wait_setup(u32 __user *
 	 *
 	 * The basic logical guarantee of a futex is that it blocks ONLY
 	 * if cond(var) is known to be true at the time of blocking, for
-	 * any cond.  If we queued after testing *uaddr, that would open
-	 * a race condition where we could block indefinitely with
+	 * any cond.  If we locked the hash-bucket after testing *uaddr, that
+	 * would open a race condition where we could block indefinitely with
 	 * cond(var) false, which would violate the guarantee.
 	 *
-	 * A consequence is that futex_wait() can return zero and absorb
-	 * a wakeup when *uaddr != val on entry to the syscall.  This is
-	 * rare, but normal.
+	 * On the other hand, we insert q and release the hash-bucket only
+	 * after testing *uaddr.  This guarantees that futex_wait() will NOT
+	 * absorb a wakeup if *uaddr does not match the desired values
+	 * while the syscall executes.
 	 */
 retry:
 	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-remove-unused-testsetpagelocked-interface.patch
futex-update-futex_wait_setup-comments-about-locking.patch

