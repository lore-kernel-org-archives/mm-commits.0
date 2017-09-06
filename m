From: akpm@linux-foundation.org
Subject: [patch 038/119] mm, sparse, page_ext: drop ugly
 N_HIGH_MEMORY branches for allocations
Date: Wed, 06 Sep 2017 16:20:41 -0700
Message-ID: <20170906232041.IJFCuXmbk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49674 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754029AbdIFXUm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:20:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, js1304@gmail.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org, shaohua.li@intel.com, torvalds@linux-foundation.org, toshi.kani@hpe.com, vbabka@suse.cz

From: Michal Hocko <mhocko@suse.com>
Subject: mm, sparse, page_ext: drop ugly N_HIGH_MEMORY branches for allocations

f52407ce2dea ("memory hotplug: alloc page from other node in memory
online") has introduced N_HIGH_MEMORY checks to only use NUMA aware
allocations when there is some memory present because the respective node
might not have any memory yet at the time and so it could fail or even
OOM.  Things have changed since then though.  Zonelists are now always
initialized before we do any allocations even for hotplug (see
959ecc48fc75 ("mm/memory_hotplug.c: fix building of node hotplug
zonelist")).  Therefore these checks are not really needed.  In fact
caller of the allocator should never care about whether the node is
populated because that might change at any time.

Link: http://lkml.kernel.org/r/20170721143915.14161-10-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Toshi Kani <toshi.kani@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_ext.c       |    5 +----
 mm/sparse-vmemmap.c |   11 +++--------
 mm/sparse.c         |   10 +++-------
 3 files changed, 7 insertions(+), 19 deletions(-)

diff -puN mm/page_ext.c~mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations mm/page_ext.c
--- a/mm/page_ext.c~mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations
+++ a/mm/page_ext.c
@@ -222,10 +222,7 @@ static void *__meminit alloc_page_ext(si
 		return addr;
 	}
 
-	if (node_state(nid, N_HIGH_MEMORY))
-		addr = vzalloc_node(size, nid);
-	else
-		addr = vzalloc(size);
+	addr = vzalloc_node(size, nid);
 
 	return addr;
 }
diff -puN mm/sparse-vmemmap.c~mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations
+++ a/mm/sparse-vmemmap.c
@@ -54,14 +54,9 @@ void * __meminit vmemmap_alloc_block(uns
 	if (slab_is_available()) {
 		struct page *page;
 
-		if (node_state(node, N_HIGH_MEMORY))
-			page = alloc_pages_node(
-				node, GFP_KERNEL | __GFP_ZERO | __GFP_RETRY_MAYFAIL,
-				get_order(size));
-		else
-			page = alloc_pages(
-				GFP_KERNEL | __GFP_ZERO | __GFP_RETRY_MAYFAIL,
-				get_order(size));
+		page = alloc_pages_node(node,
+			GFP_KERNEL | __GFP_ZERO | __GFP_RETRY_MAYFAIL,
+			get_order(size));
 		if (page)
 			return page_address(page);
 		return NULL;
diff -puN mm/sparse.c~mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations mm/sparse.c
--- a/mm/sparse.c~mm-sparse-page_ext-drop-ugly-n_high_memory-branches-for-allocations
+++ a/mm/sparse.c
@@ -65,14 +65,10 @@ static noinline struct mem_section __ref
 	unsigned long array_size = SECTIONS_PER_ROOT *
 				   sizeof(struct mem_section);
 
-	if (slab_is_available()) {
-		if (node_state(nid, N_HIGH_MEMORY))
-			section = kzalloc_node(array_size, GFP_KERNEL, nid);
-		else
-			section = kzalloc(array_size, GFP_KERNEL);
-	} else {
+	if (slab_is_available())
+		section = kzalloc_node(array_size, GFP_KERNEL, nid);
+	else
 		section = memblock_virt_alloc_node(array_size, nid);
-	}
 
 	return section;
 }
_
