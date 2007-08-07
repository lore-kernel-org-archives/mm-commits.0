From: akpm@linux-foundation.org
Subject: + allow-rcutorture-to-handle-synchronize_sched.patch added to -mm tree
Date: Tue, 07 Aug 2007 12:41:23 -0700
Message-ID: <200708071941.l77JfNbC000688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50429 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448AbXHGTmP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 15:42:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, josh@kernel.org


The patch titled
     Allow rcutorture to handle synchronize_sched()
has been added to the -mm tree.  Its filename is
     allow-rcutorture-to-handle-synchronize_sched.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Allow rcutorture to handle synchronize_sched()
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcutorture module uses a random-number generator that periodically
calls get_random_bytes() to add entropy.  This random-number generator is
invoked from within the RCU read-side critical section, which, in the case
of the synchronize_sched() variant of RCU, has preeemption disabled. 
Unfortunately, get_random_bytes() ends up acquiring normal spinlocks, which
can block in -rt, resulting in very large numbers of "scheduling while
atomic" messages.

This patch takes a very crude approach, simply substituting the time
of day for get_random_bytes().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Josh Triplett <josh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcutorture.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff -puN kernel/rcutorture.c~allow-rcutorture-to-handle-synchronize_sched kernel/rcutorture.c
--- a/kernel/rcutorture.c~allow-rcutorture-to-handle-synchronize_sched
+++ a/kernel/rcutorture.c
@@ -165,16 +165,13 @@ struct rcu_random_state {
 
 /*
  * Crude but fast random-number generator.  Uses a linear congruential
- * generator, with occasional help from get_random_bytes().
+ * generator, with occasional help from the time-of-day clock.
  */
 static unsigned long
 rcu_random(struct rcu_random_state *rrsp)
 {
-	long refresh;
-
 	if (--rrsp->rrs_count < 0) {
-		get_random_bytes(&refresh, sizeof(refresh));
-		rrsp->rrs_state += refresh;
+		rrsp->rrs_state += xtime.tv_nsec;
 		rrsp->rrs_count = RCU_RANDOM_REFRESH;
 	}
 	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
_

Patches currently in -mm which might be from paulmck@linux.vnet.ibm.com are

allow-rcutorture-to-handle-synchronize_sched.patch
fib_trie-cleanup-fix.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
clean-up-duplicate-includes-in-kernel.patch
