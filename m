From: akpm@linux-foundation.org
Subject: +
 mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map.patch added to -mm tree
Date: Tue, 14 Nov 2017 15:21:51 -0800
Message-ID: <5a0b7a8f.xpBDAfPIj5oE/YHc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44508 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756510AbdKNXVx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2017 18:21:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: osalvador@techadventures.net, mgorman@techsingularity.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make alloc_node_mem_map a voidcall if we don't have CONFIG_FLAT_NODE_MEM_MAP
has been added to the -mm tree.  Its filename is
     mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@techadventures.net>
Subject: mm: make alloc_node_mem_map a voidcall if we don't have CONFIG_FLAT_NODE_MEM_MAP

free_area_init_node() calls alloc_node_mem_map(), but this function does
nothing unless we have CONFIG_FLAT_NODE_MEM_MAP.

As a cleanup, we can move the "#ifdef CONFIG_FLAT_NODE_MEM_MAP" within
alloc_node_mem_map() out of the function, and define a
alloc_node_mem_map() { } when CONFIG_FLAT_NODE_MEM_MAP is not present.

This also moves the printk that lays within the "#ifdef
CONFIG_FLAT_NODE_MEM_MAP" block from free_area_init_node() to
alloc_node_mem_map(), getting rid of the "#ifdef CONFIG_FLAT_NODE_MEM_MAP"
in free_area_init_node().

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
@@ -6147,6 +6147,7 @@ static void __paginginit free_area_init_
 	}
 }
 
+#ifdef CONFIG_FLAT_NODE_MEM_MAP
 static void __ref alloc_node_mem_map(struct pglist_data *pgdat)
 {
 	unsigned long __maybe_unused start = 0;
@@ -6156,7 +6157,6 @@ static void __ref alloc_node_mem_map(str
 	if (!pgdat->node_spanned_pages)
 		return;
 
-#ifdef CONFIG_FLAT_NODE_MEM_MAP
 	start = pgdat->node_start_pfn & ~(MAX_ORDER_NR_PAGES - 1);
 	offset = pgdat->node_start_pfn - start;
 	/* ia64 gets its own node_mem_map, before this, without bootmem */
@@ -6178,6 +6178,9 @@ static void __ref alloc_node_mem_map(str
 							       pgdat->node_id);
 		pgdat->node_mem_map = map + offset;
 	}
+	printk(KERN_DEBUG "alloc_node_mem_map: node %d, pgdat %08lx, node_mem_map %08lx\n",
+							pgdat->node_id, (unsigned long)pgdat,
+							(unsigned long)pgdat->node_mem_map);
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 	/*
 	 * With no DISCONTIG, the global mem_map is just set as node 0's
@@ -6190,8 +6193,10 @@ static void __ref alloc_node_mem_map(str
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
@@ -6218,11 +6223,6 @@ void __paginginit free_area_init_node(in
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

Patches currently in -mm which might be from osalvador@techadventures.net are

mm-make-alloc_node_mem_map-a-voidcall-if-we-dont-have-config_flat_node_mem_map.patch

