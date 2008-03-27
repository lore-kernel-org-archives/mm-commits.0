From: akpm@linux-foundation.org
Subject: - slab-fix-cache_cache-bootstrap-in-kmem_cache_init.patch removed from -mm tree
Date: Thu, 27 Mar 2008 00:42:16 -0700
Message-ID: <200803270742.m2R7gGh2024011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755072AbYC0HnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Mar 2008 03:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.yeisley@unisys.com, clameter@sgi.com, mel@csn.ul.ie, olaf@aepfle.de, penberg@cs.helsinki.fi, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     slab: fix cache_cache bootstrap in kmem_cache_init()
has been removed from the -mm tree.  Its filename was
     slab-fix-cache_cache-bootstrap-in-kmem_cache_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slab: fix cache_cache bootstrap in kmem_cache_init()
From: Daniel Yeisley <dan.yeisley@unisys.com>

Commit 556a169dab38b5100df6f4a45b655dddd3db94c1 ("slab: fix bootstrap on
memoryless node") introduced bootstrap-time cache_cache list3s for all nodes
but forgot that initkmem_list3 needs to be accessed by [somevalue + node]. 
This patch fixes list_add() corruption in mm/slab.c seen on the ES7000.

Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Dan Yeisley <dan.yeisley@unisys.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-fix-cache_cache-bootstrap-in-kmem_cache_init mm/slab.c
--- a/mm/slab.c~slab-fix-cache_cache-bootstrap-in-kmem_cache_init
+++ a/mm/slab.c
@@ -1481,7 +1481,7 @@ void __init kmem_cache_init(void)
 	list_add(&cache_cache.next, &cache_chain);
 	cache_cache.colour_off = cache_line_size();
 	cache_cache.array[smp_processor_id()] = &initarray_cache.cache;
-	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE];
+	cache_cache.nodelists[node] = &initkmem_list3[CACHE_CACHE + node];
 
 	/*
 	 * struct kmem_cache size depends on nr_node_ids, which
@@ -1602,7 +1602,7 @@ void __init kmem_cache_init(void)
 		int nid;
 
 		for_each_online_node(nid) {
-			init_list(&cache_cache, &initkmem_list3[CACHE_CACHE], nid);
+			init_list(&cache_cache, &initkmem_list3[CACHE_CACHE + nid], nid);
 
 			init_list(malloc_sizes[INDEX_AC].cs_cachep,
 				  &initkmem_list3[SIZE_AC + nid], nid);
_

Patches currently in -mm which might be from dan.yeisley@unisys.com are

origin.patch

