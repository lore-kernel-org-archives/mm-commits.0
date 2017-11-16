From: akpm@linux-foundation.org
Subject: [patch 130/131] mm: make alloc_node_mem_map a void call if
 we don't have CONFIG_FLAT_NODE_MEM_MAP
Date: Wed, 15 Nov 2017 17:39:18 -0800
Message-ID: <20171116013918.qY6CofbWZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40788 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933297AbdKPBjT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:39:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@techadventures.net, torvalds@linux-foundation.org, vbabka@suse.cz

From: Oscar Salvador <osalvador@techadventures.net>
Subject: mm: make alloc_node_mem_map a void call if we don't have CONFIG_FLAT_NODE_MEM_MAP

free_area_init_node() calls alloc_node_mem_map(), but this function does
nothing unless we have CONFIG_FLAT_NODE_MEM_MAP.

As a cleanup, we can move the "#ifdef CONFIG_FLAT_NODE_MEM_MAP" within
alloc_node_mem_map() out of the function, and define a
alloc_node_mem_map() { } when CONFIG_FLAT_NODE_MEM_MAP is not present.

This also moves the printk that lays within the "#ifdef
CONFIG_FLAT_NODE_MEM_MAP" block from free_area_init_node() to
alloc_node_mem_map(), getting rid of the "#ifdef CONFIG_FLAT_NODE_MEM_MAP"
in free_area_init_node().

[akpm@linux-foundation.org: clean up the printk while we're there]
Link: http://lkml.kernel.org/r/20171114111935.GA11758@techadventures.net
Signed-off-by: Oscar Salvador <osalvador@techadventures.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map mm/page_alloc.c
--- a/mm/page_alloc.c~mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map
+++ a/mm/page_alloc.c
@@ -6151,6 +6151,7 @@ static void __paginginit free_area_init_
 	}
 }
 
+#ifdef CONFIG_FLAT_NODE_MEM_MAP
 static void __ref alloc_node_mem_map(struct pglist_data *pgdat)
 {
 	unsigned long __maybe_unused start = 0;
@@ -6160,7 +6161,6 @@ static void __ref alloc_node_mem_map(str
 	if (!pgdat->node_spanned_pages)
 		return;
 
-#ifdef CONFIG_FLAT_NODE_MEM_MAP
 	start = pgdat->node_start_pfn & ~(MAX_ORDER_NR_PAGES - 1);
 	offset = pgdat->node_start_pfn - start;
 	/* ia64 gets its own node_mem_map, before this, without bootmem */
@@ -6182,6 +6182,9 @@ static void __ref alloc_node_mem_map(str
 							       pgdat->node_id);
 		pgdat->node_mem_map = map + offset;
 	}
+	pr_debug("%s: node %d, pgdat %08lx, node_mem_map %08lx\n",
+				__func__, pgdat->node_id, (unsigned long)pgdat,
+				(unsigned long)pgdat->node_mem_map);
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 	/*
 	 * With no DISCONTIG, the global mem_map is just set as node 0's
@@ -6194,8 +6197,10 @@ static void __ref alloc_node_mem_map(str
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 	}
 #endif
-#endif /* CONFIG_FLAT_NODE_MEM_MAP */
 }
+#else
+static void __ref alloc_node_mem_map(struct pglist_data *pgdat) { }
+#endif /* CONFIG_FLAT_NODE_MEM_MAP */
 
 void __paginginit free_area_init_node(int nid, unsigned long *zones_size,
 		unsigned long node_start_pfn, unsigned long *zholes_size)
@@ -6222,11 +6227,6 @@ void __paginginit free_area_init_node(in
 				  zones_size, zholes_size);
 
 	alloc_node_mem_map(pgdat);
-#ifdef CONFIG_FLAT_NODE_MEM_MAP
-	printk(KERN_DEBUG "free_area_init_node: node %d, pgdat %08lx, node_mem_map %08lx\n",
-		nid, (unsigned long)pgdat,
-		(unsigned long)pgdat->node_mem_map);
-#endif
 
 	reset_deferred_meminit(pgdat);
 	free_area_init_core(pgdat);
_
