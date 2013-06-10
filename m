From: akpm@linux-foundation.org
Subject: + mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch added
 to -mm tree
Date: Mon, 10 Jun 2013 15:28:23 -0700
Message-ID: <51b65307.OFQhaa5mIKsun1dx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab3FJW2Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 18:28:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com

Subject: + mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch added to -mm tree
To: zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 15:28:23 -0700


The patch titled
     Subject: mm: Remove duplicated call of get_pfn_range_for_nid
has been added to the -mm tree.  Its filename is
     mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm: Remove duplicated call of get_pfn_range_for_nid

When calculating pages in a node, for each zone in that node, we will have

  zone_spanned_pages_in_node
    --> get_pfn_range_for_nid
  zone_absent_pages_in_node
    --> get_pfn_range_for_nid

That is to say, we call the get_pfn_range_for_nid to get start_pfn and
end_pfn of the node for MAX_NR_ZONES * 2 times.  And this is totally
unnecessary if we call the get_pfn_range_for_nid before
zone_*_pages_in_node add two extra arguments node_start_pfn and
node_end_pfn for zone_*_pages_in_node, then we can remove the
get_pfn_range_in_node in zone_*_pages_in_node.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-duplicated-call-of-get_pfn_range_for_nid mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-duplicated-call-of-get_pfn_range_for_nid
+++ a/mm/page_alloc.c
@@ -4415,13 +4415,13 @@ static void __meminit adjust_zone_range_
  */
 static unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
+					unsigned long node_start_pfn,
+					unsigned long node_end_pfn,
 					unsigned long *ignored)
 {
-	unsigned long node_start_pfn, node_end_pfn;
 	unsigned long zone_start_pfn, zone_end_pfn;
 
-	/* Get the start and end of the node and zone */
-	get_pfn_range_for_nid(nid, &node_start_pfn, &node_end_pfn);
+	/* Get the start and end of the zone */
 	zone_start_pfn = arch_zone_lowest_possible_pfn[zone_type];
 	zone_end_pfn = arch_zone_highest_possible_pfn[zone_type];
 	adjust_zone_range_for_zone_movable(nid, zone_type,
@@ -4476,14 +4476,14 @@ unsigned long __init absent_pages_in_ran
 /* Return the number of page frames in holes in a zone on a node */
 static unsigned long __meminit zone_absent_pages_in_node(int nid,
 					unsigned long zone_type,
+					unsigned long node_start_pfn,
+					unsigned long node_end_pfn,
 					unsigned long *ignored)
 {
 	unsigned long zone_low = arch_zone_lowest_possible_pfn[zone_type];
 	unsigned long zone_high = arch_zone_highest_possible_pfn[zone_type];
-	unsigned long node_start_pfn, node_end_pfn;
 	unsigned long zone_start_pfn, zone_end_pfn;
 
-	get_pfn_range_for_nid(nid, &node_start_pfn, &node_end_pfn);
 	zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high);
 	zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high);
 
@@ -4496,6 +4496,8 @@ static unsigned long __meminit zone_abse
 #else /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 static inline unsigned long __meminit zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
+					unsigned long node_start_pfn,
+					unsigned long node_end_pfn,
 					unsigned long *zones_size)
 {
 	return zones_size[zone_type];
@@ -4503,6 +4505,8 @@ static inline unsigned long __meminit zo
 
 static inline unsigned long __meminit zone_absent_pages_in_node(int nid,
 						unsigned long zone_type,
+						unsigned long node_start_pfn,
+						unsigned long node_end_pfn,
 						unsigned long *zholes_size)
 {
 	if (!zholes_size)
@@ -4514,21 +4518,27 @@ static inline unsigned long __meminit zo
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
 static void __meminit calculate_node_totalpages(struct pglist_data *pgdat,
-		unsigned long *zones_size, unsigned long *zholes_size)
+						unsigned long node_start_pfn,
+						unsigned long node_end_pfn,
+						unsigned long *zones_size,
+						unsigned long *zholes_size)
 {
 	unsigned long realtotalpages, totalpages = 0;
 	enum zone_type i;
 
 	for (i = 0; i < MAX_NR_ZONES; i++)
 		totalpages += zone_spanned_pages_in_node(pgdat->node_id, i,
-								zones_size);
+							 node_start_pfn,
+							 node_end_pfn,
+							 zones_size);
 	pgdat->node_spanned_pages = totalpages;
 
 	realtotalpages = totalpages;
 	for (i = 0; i < MAX_NR_ZONES; i++)
 		realtotalpages -=
 			zone_absent_pages_in_node(pgdat->node_id, i,
-								zholes_size);
+						  node_start_pfn, node_end_pfn,
+						  zholes_size);
 	pgdat->node_present_pages = realtotalpages;
 	printk(KERN_DEBUG "On node %d totalpages: %lu\n", pgdat->node_id,
 							realtotalpages);
@@ -4637,6 +4647,7 @@ static unsigned long __paginginit calc_m
  * NOTE: pgdat should get zeroed by caller.
  */
 static void __paginginit free_area_init_core(struct pglist_data *pgdat,
+		unsigned long node_start_pfn, unsigned long node_end_pfn,
 		unsigned long *zones_size, unsigned long *zholes_size)
 {
 	enum zone_type j;
@@ -4658,8 +4669,11 @@ static void __paginginit free_area_init_
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, freesize, memmap_pages;
 
-		size = zone_spanned_pages_in_node(nid, j, zones_size);
+		size = zone_spanned_pages_in_node(nid, j, node_start_pfn,
+						  node_end_pfn, zones_size);
 		realsize = freesize = size - zone_absent_pages_in_node(nid, j,
+								node_start_pfn,
+								node_end_pfn,
 								zholes_size);
 
 		/*
@@ -4773,6 +4787,7 @@ void __paginginit free_area_init_node(in
 		unsigned long node_start_pfn, unsigned long *zholes_size)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
+	unsigned long start_pfn, end_pfn;
 
 	/* pg_data_t should be reset to zero when it's allocated */
 	WARN_ON(pgdat->nr_zones || pgdat->classzone_idx);
@@ -4780,7 +4795,11 @@ void __paginginit free_area_init_node(in
 	pgdat->node_id = nid;
 	pgdat->node_start_pfn = node_start_pfn;
 	init_zone_allows_reclaim(nid);
-	calculate_node_totalpages(pgdat, zones_size, zholes_size);
+#ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
+	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+#endif
+	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
+				  zones_size, zholes_size);
 
 	alloc_node_mem_map(pgdat);
 #ifdef CONFIG_FLAT_NODE_MEM_MAP
@@ -4789,7 +4808,8 @@ void __paginginit free_area_init_node(in
 		(unsigned long)pgdat->node_mem_map);
 #endif
 
-	free_area_init_core(pgdat, zones_size, zholes_size);
+	free_area_init_core(pgdat, start_pfn, end_pfn,
+			    zones_size, zholes_size);
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
_

Patches currently in -mm which might be from zhangyanfei@cn.fujitsu.com are

linux-next.patch
vmcore-clean-up-read_vmcore.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment-fix.patch
vmcore-treat-memory-chunks-referenced-by-pt_load-program-header-entries-in-page-size-boundary-in-vmcore_list.patch
vmalloc-make-find_vm_area-check-in-range.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmalloc-introduce-remap_vmalloc_range_partial-fix.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory-fix.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer-fix.patch
vmcore-calculate-vmcore-file-size-from-buffer-size-and-total-size-of-vmcore-objects.patch
vmcore-support-mmap-on-proc-vmcore.patch
vmcore-support-mmap-on-proc-vmcore-fix.patch
mm-ia64-prepare-for-removing-num_physpages-and-simplify-mem_init.patch
mm-vmalloc-only-call-setup_vmalloc_vm-only-in-__get_vm_area_node.patch
mm-vmalloc-call-setup_vmalloc_vm-instead-of-insert_vmalloc_vm.patch
mm-vmalloc-remove-insert_vmalloc_vm.patch
mm-vmalloc-use-clamp-to-simplify-code.patch
mm-remove-duplicated-call-of-get_pfn_range_for_nid.patch
dev-oldmem-remove-the-interface.patch
dev-oldmem-remove-the-interface-fix.patch
documentation-kdump-kdumptxt-remove-dev-oldmem-description.patch
mips-remove-savemaxmem-parameter-setup.patch
powerpc-remove-savemaxmem-parameter-setup.patch
ia64-remove-setting-for-saved_max_pfn.patch
s390-remove-setting-for-saved_max_pfn.patch

