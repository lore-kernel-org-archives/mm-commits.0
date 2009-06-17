From: akpm@linux-foundation.org
Subject: [merged] page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:29 -0700
Message-ID: <200906171834.n5HIYTkl000470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56446 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758341AbZFQS5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux.com, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi


The patch titled
     page allocator: slab: use nr_online_nodes to check for a NUMA platform
has been removed from the -mm tree.  Its filename was
     page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: slab: use nr_online_nodes to check for a NUMA platform
From: Mel Gorman <mel@csn.ul.ie>

SLAB currently avoids checking a bitmap repeatedly by checking once and
storing a flag.  When the addition of nr_online_nodes as a cheaper version
of num_online_nodes(), this check can be replaced by nr_online_nodes.

(Christoph did a patch that this is lifted almost verbatim from)

Signed-off-by: Christoph Lameter <cl@linux.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN mm/slab.c~page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform mm/slab.c
--- a/mm/slab.c~page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform
+++ a/mm/slab.c
@@ -898,7 +898,6 @@ static void __slab_error(const char *fun
   */
 
 static int use_alien_caches __read_mostly = 1;
-static int numa_platform __read_mostly = 1;
 static int __init noaliencache_setup(char *s)
 {
 	use_alien_caches = 0;
@@ -1457,10 +1456,8 @@ void __init kmem_cache_init(void)
 	int order;
 	int node;
 
-	if (num_possible_nodes() == 1) {
+	if (num_possible_nodes() == 1)
 		use_alien_caches = 0;
-		numa_platform = 0;
-	}
 
 	for (i = 0; i < NUM_INIT_LISTS; i++) {
 		kmem_list3_init(&initkmem_list3[i]);
@@ -3590,7 +3587,7 @@ static inline void __cache_free(struct k
 	 * variable to skip the call, which is mostly likely to be present in
 	 * the cache.
 	 */
-	if (numa_platform && cache_free_alien(cachep, objp))
+	if (nr_online_nodes > 1 && cache_free_alien(cachep, objp))
 		return;
 
 	if (likely(ac->avail < ac->limit)) {
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

