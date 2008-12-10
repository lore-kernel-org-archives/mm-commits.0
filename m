From: akpm@linux-foundation.org
Subject: - atomic-fix-a-typo-in-atomic_long_xchg.patch removed from -mm tree
Date: Wed, 10 Dec 2008 11:29:09 -0800
Message-ID: <200812101929.mBAJT961021665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754894AbYLJT3S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Dec 2008 14:29:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     atomic: fix a typo in atomic_long_xchg()
has been removed from the -mm tree.  Its filename was
     atomic-fix-a-typo-in-atomic_long_xchg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch
percpu_counter-fbc_batch-should-be-a-variable.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

