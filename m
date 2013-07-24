From: akpm@linux-foundation.org
Subject: + mm-page_allocc-fix-coding-style-and-spelling.patch added to -mm tree
Date: Wed, 24 Jul 2013 14:46:59 -0700
Message-ID: <51f04b53.CkqwHP5wrw+6+alk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXVrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Jul 2013 17:47:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, pintu.k@samsung.com

Subject: + mm-page_allocc-fix-coding-style-and-spelling.patch added to -mm tree
To: pintu.k@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 24 Jul 2013 14:46:59 -0700


The patch titled
     Subject: mm/page_alloc.c: fix coding style and spelling
has been added to the -mm tree.  Its filename is
     mm-page_allocc-fix-coding-style-and-spelling.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-fix-coding-style-and-spelling.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-fix-coding-style-and-spelling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pintu Kumar <pintu.k@samsung.com>
Subject: mm/page_alloc.c: fix coding style and spelling

Fix all errors reported by checkpatch and some small spelling mistakes.

Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-fix-coding-style-and-spelling mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-fix-coding-style-and-spelling
+++ a/mm/page_alloc.c
@@ -721,7 +721,8 @@ static bool free_pages_prepare(struct pa
 		return false;
 
 	if (!PageHighMem(page)) {
-		debug_check_no_locks_freed(page_address(page),PAGE_SIZE<<order);
+		debug_check_no_locks_freed(page_address(page),
+					   PAGE_SIZE << order);
 		debug_check_no_obj_freed(page_address(page),
 					   PAGE_SIZE << order);
 	}
@@ -885,7 +886,7 @@ struct page *__rmqueue_smallest(struct z
 						int migratetype)
 {
 	unsigned int current_order;
-	struct free_area * area;
+	struct free_area *area;
 	struct page *page;
 
 	/* Find a page of the appropriate size in the preferred list */
@@ -1011,7 +1012,7 @@ static void change_pageblock_range(struc
 static inline struct page *
 __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
 {
-	struct free_area * area;
+	struct free_area *area;
 	int current_order;
 	struct page *page;
 	int migratetype, i;
@@ -3104,7 +3105,7 @@ void show_free_areas(unsigned int filter
 	}
 
 	for_each_populated_zone(zone) {
- 		unsigned long nr[MAX_ORDER], flags, order, total = 0;
+		unsigned long nr[MAX_ORDER], flags, order, total = 0;
 		unsigned char types[MAX_ORDER];
 
 		if (skip_free_areas_node(filter, zone_to_nid(zone)))
@@ -3416,11 +3417,11 @@ static void build_zonelists_in_zone_orde
 static int default_zonelist_order(void)
 {
 	int nid, zone_type;
-	unsigned long low_kmem_size,total_size;
+	unsigned long low_kmem_size, total_size;
 	struct zone *z;
 	int average_size;
 	/*
-         * ZONE_DMA and ZONE_DMA32 can be very small area in the system.
+	 * ZONE_DMA and ZONE_DMA32 can be very small area in the system.
 	 * If they are really small and used heavily, the system can fall
 	 * into OOM very easily.
 	 * This function detect ZONE_DMA/DMA32 size and configures zone order.
@@ -3452,9 +3453,9 @@ static int default_zonelist_order(void)
 		return ZONELIST_ORDER_NODE;
 	/*
 	 * look into each node's config.
-  	 * If there is a node whose DMA/DMA32 memory is very big area on
- 	 * local memory, NODE_ORDER may be suitable.
-         */
+	 * If there is a node whose DMA/DMA32 memory is very big area on
+	 * local memory, NODE_ORDER may be suitable.
+	 */
 	average_size = total_size /
 				(nodes_weight(node_states[N_MEMORY]) + 1);
 	for_each_online_node(nid) {
@@ -4180,7 +4181,7 @@ int zone_wait_table_init(struct zone *zo
 	if (!zone->wait_table)
 		return -ENOMEM;
 
-	for(i = 0; i < zone->wait_table_hash_nr_entries; ++i)
+	for (i = 0; i < zone->wait_table_hash_nr_entries; ++i)
 		init_waitqueue_head(zone->wait_table + i);
 
 	return 0;
@@ -4930,7 +4931,7 @@ static unsigned long __init early_calcul
 		if (pages)
 			node_set_state(nid, N_MEMORY);
 	}
-  	return totalpages;
+	return totalpages;
 }
 
 /*
@@ -5047,7 +5048,7 @@ restart:
 			/*
 			 * Some kernelcore has been met, update counts and
 			 * break if the kernelcore for this node has been
-			 * satisified
+			 * satisfied
 			 */
 			required_kernelcore -= min(required_kernelcore,
 								size_pages);
@@ -5061,7 +5062,7 @@ restart:
 	 * If there is still required_kernelcore, we do another pass with one
 	 * less node in the count. This will push zone_movable_pfn[nid] further
 	 * along on the nodes that still have memory until kernelcore is
-	 * satisified
+	 * satisfied
 	 */
 	usable_nodes--;
 	if (usable_nodes && required_kernelcore > usable_nodes)
@@ -5286,8 +5287,10 @@ void __init mem_init_print_info(const ch
 	 * 3) .rodata.* may be embedded into .text or .data sections.
 	 */
 #define adj_init_size(start, end, size, pos, adj) \
-	if (start <= pos && pos < end && size > adj) \
-		size -= adj;
+	do { \
+		if (start <= pos && pos < end && size > adj) \
+			size -= adj; \
+	} while (0)
 
 	adj_init_size(__init_begin, __init_end, init_data_size,
 		     _sinittext, init_code_size);
@@ -5570,7 +5573,7 @@ static void __meminit setup_per_zone_ina
  * we want it large (64MB max).  But it is not linear, because network
  * bandwidth does not increase linearly with machine size.  We use
  *
- * 	min_free_kbytes = 4 * sqrt(lowmem_kbytes), for better accuracy:
+ *	min_free_kbytes = 4 * sqrt(lowmem_kbytes), for better accuracy:
  *	min_free_kbytes = sqrt(lowmem_kbytes * 16)
  *
  * which yields
@@ -5614,11 +5617,11 @@ int __meminit init_per_zone_wmark_min(vo
 module_init(init_per_zone_wmark_min)
 
 /*
- * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so 
+ * min_free_kbytes_sysctl_handler - just a wrapper around proc_dointvec() so
  *	that we can call two helper functions whenever min_free_kbytes
  *	changes.
  */
-int min_free_kbytes_sysctl_handler(ctl_table *table, int write, 
+int min_free_kbytes_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
 {
 	proc_dointvec(table, write, buffer, length, ppos);
@@ -5682,8 +5685,8 @@ int lowmem_reserve_ratio_sysctl_handler(
 
 /*
  * percpu_pagelist_fraction - changes the pcp->high for each zone on each
- * cpu.  It is the fraction of total pages in each zone that a hot per cpu pagelist
- * can have before it gets flushed back to buddy allocator.
+ * cpu.  It is the fraction of total pages in each zone that a hot per cpu
+ * pagelist can have before it gets flushed back to buddy allocator.
  */
 int percpu_pagelist_fraction_sysctl_handler(ctl_table *table, int write,
 	void __user *buffer, size_t *length, loff_t *ppos)
@@ -5901,7 +5904,7 @@ void set_pageblock_flags_group(struct pa
  * This function checks whether pageblock includes unmovable pages or not.
  * If @count is not zero, it is okay to include less @count unmovable pages
  *
- * PageLRU check wihtout isolation or lru_lock could race so that
+ * PageLRU check without isolation or lru_lock could race so that
  * MIGRATE_MOVABLE block might include unmovable pages. It means you can't
  * expect this function should be exact.
  */
_

Patches currently in -mm which might be from pintu.k@samsung.com are

mm-page_allocc-fix-coding-style-and-spelling.patch

