From: akpm@linux-foundation.org
Subject: + atomic-only-take-lock-when-the-counter-drops-to-zero-on-up-as-well.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:37:11 -0700
Message-ID: <200904232337.n3NNbCN0024562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698AbZDWXjj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:39:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, npiggin@suse.de, paulmck@linux.vnet.ibm.com


The patch titled
     atomic: only take lock when the counter drops to zero on UP as well
has been added to the -mm tree.  Its filename is
     atomic-only-take-lock-when-the-counter-drops-to-zero-on-up-as-well.patch

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
Subject: atomic: only take lock when the counter drops to zero on UP as well
From: Jan Blunck <jblunck@suse.de>

_atomic_dec_and_lock() should not unconditionally take the lock before
calling atomic_dec_and_test() in the UP case.  For consistency reasons it
should behave exactly like in the SMP case.

Besides that this works around the problem that with CONFIG_DEBUG_SPINLOCK
this spins in __spin_lock_debug() if the lock is already taken even if the
counter doesn't drop to 0.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dec_and_lock.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/dec_and_lock.c~atomic-only-take-lock-when-the-counter-drops-to-zero-on-up-as-well lib/dec_and_lock.c
--- a/lib/dec_and_lock.c~atomic-only-take-lock-when-the-counter-drops-to-zero-on-up-as-well
+++ a/lib/dec_and_lock.c
@@ -19,11 +19,10 @@
  */
 int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock)
 {
-#ifdef CONFIG_SMP
 	/* Subtract 1 from counter unless that drops it to 0 (ie. it was 1) */
 	if (atomic_add_unless(atomic, -1, 1))
 		return 0;
-#endif
+
 	/* Otherwise do it the slow way */
 	spin_lock(lock);
 	if (atomic_dec_and_test(atomic))
_

Patches currently in -mm which might be from jblunck@suse.de are

atomic-only-take-lock-when-the-counter-drops-to-zero-on-up-as-well.patch

