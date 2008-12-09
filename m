From: akpm@linux-foundation.org
Subject: + atomic-fix-a-typo-in-atomic_long_xchg.patch added to -mm tree
Date: Mon, 08 Dec 2008 16:07:50 -0800
Message-ID: <200812090007.mB907of1000649@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497AbYLIAIJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 19:08:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, mathieu.desnoyers@polymtl.ca


The patch titled
     atomic: fix a typo in atomic_long_xchg()
has been added to the -mm tree.  Its filename is
     atomic-fix-a-typo-in-atomic_long_xchg.patch

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
Subject: atomic: fix a typo in atomic_long_xchg()
From: Eric Dumazet <dada1@cosmosbay.com>

atomic_long_xchg() is not correctly defined for 32bit arches.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/atomic.h~atomic-fix-a-typo-in-atomic_long_xchg include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~atomic-fix-a-typo-in-atomic_long_xchg
+++ a/include/asm-generic/atomic.h
@@ -251,7 +251,7 @@ static inline long atomic_long_add_unles
 #define atomic_long_cmpxchg(l, old, new) \
 	(atomic_cmpxchg((atomic_t *)(l), (old), (new)))
 #define atomic_long_xchg(v, new) \
-	(atomic_xchg((atomic_t *)(l), (new)))
+	(atomic_xchg((atomic_t *)(v), (new)))
 
 #endif  /*  BITS_PER_LONG == 64  */
 
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
percpu_counter-fix-cpu-unplug-race-in-percpu_counter_destroy.patch
revert-percpu-counter-clean-up-percpu_counter_sum_and_set.patch
revert-percpu_counter-new-function-percpu_counter_sum_and_set.patch
atomic-fix-a-typo-in-atomic_long_xchg.patch
linux-next.patch
percpu_counter-fbc_batch-should-be-a-variable.patch
smp-uninline-num_online_cpus-num_possible_cpus.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

