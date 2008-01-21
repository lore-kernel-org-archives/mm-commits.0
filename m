From: akpm@linux-foundation.org
Subject: + add-debugging-aid-for-memory-initialisation-problems.patch added to -mm tree
Date: Mon, 21 Jan 2008 15:13:06 -0800
Message-ID: <200801212313.m0LND6pU024883@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755257AbYAUXNP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:13:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Add debugging aid for memory initialisation problems
has been added to the -mm tree.  Its filename is
     add-debugging-aid-for-memory-initialisation-problems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add debugging aid for memory initialisation problems
From: Mel Gorman <mel@csn.ul.ie>

A number of bug reports have been submitted related to memory initialisation
that would have been easier to debug if the PFN of page addresses were
available.  The dmesg output is often insufficient to find that information so
debugging patches need to be sent to the reporting user.

This patch prints out information on the memmap when it is being allocated and
the sizeof(struct page) when loglevel is set high enough.  In most
architectures, this output is produced in generic code.  x86_64 and ia64 both
setup node_mem_map in an architecture-specific manner requiring arch-specfic
changes.  Th memmap information can be used to translate any valid page
address into a PFN.  page_to_pfn() cannot be used directly in bad_page()
because there is no guarantee that the address pointer is valid in any way and
the translation can produce garbage.

Information on memmap is not printed out for the SPARSEMEM memory model.  This
only applies to FLATMEM and DISCONTIG configurations.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/contig.c    |    3 +++
 arch/ia64/mm/discontig.c |    3 +++
 mm/page_alloc.c          |    6 ++++++
 3 files changed, 12 insertions(+)

diff -puN arch/ia64/mm/contig.c~add-debugging-aid-for-memory-initialisation-problems arch/ia64/mm/contig.c
--- a/arch/ia64/mm/contig.c~add-debugging-aid-for-memory-initialisation-problems
+++ a/arch/ia64/mm/contig.c
@@ -277,6 +277,9 @@ paging_init (void)
 		 */
 		NODE_DATA(0)->node_mem_map = vmem_map +
 			find_min_pfn_with_active_regions();
+		printk(KERN_DEBUG
+			"Node %d memmap at 0x%p size %lu first pfn 0x%p\n",
+			0, vmem_map, map_size, NODE_DATA(0)->node_mem_map);
 		free_area_init_nodes(max_zone_pfns);
 
 		printk("Virtual mem_map starts at 0x%p\n", mem_map);
diff -puN arch/ia64/mm/discontig.c~add-debugging-aid-for-memory-initialisation-problems arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~add-debugging-aid-for-memory-initialisation-problems
+++ a/arch/ia64/mm/discontig.c
@@ -681,6 +681,9 @@ void __init paging_init(void)
 
 #ifdef CONFIG_VIRTUAL_MEM_MAP
 		NODE_DATA(node)->node_mem_map = vmem_map + pfn_offset;
+		printk(KERN_DEBUG
+			"Node %d memmap at 0x%p size %u first pfn 0x%p\n",
+			node, vmem_map, 0, NODE_DATA(node)->node_mem_map);
 #endif
 		if (mem_data[node].max_pfn > max_pfn)
 			max_pfn = mem_data[node].max_pfn;
diff -puN arch/x86/mm/numa_64.c~add-debugging-aid-for-memory-initialisation-problems arch/x86/mm/numa_64.c
diff -puN mm/page_alloc.c~add-debugging-aid-for-memory-initialisation-problems mm/page_alloc.c
--- a/mm/page_alloc.c~add-debugging-aid-for-memory-initialisation-problems
+++ a/mm/page_alloc.c
@@ -3503,6 +3503,9 @@ static void __init_refok alloc_node_mem_
 		if (!map)
 			map = alloc_bootmem_node(pgdat, size);
 		pgdat->node_mem_map = map + (pgdat->node_start_pfn - start);
+		printk(KERN_DEBUG
+			"Node %d memmap at 0x%p size %lu first pfn 0x%p\n",
+			pgdat->node_id, map, size, pgdat->node_mem_map);
 	}
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 	/*
@@ -3940,6 +3943,9 @@ void __init free_area_init_nodes(unsigne
 	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
 	find_zone_movable_pfns_for_nodes(zone_movable_pfn);
 
+	/* Print out the page size for debugging meminit problems */
+	printk(KERN_DEBUG "sizeof(struct page) = %zd\n", sizeof(struct page));
+
 	/* Print out the zone ranges */
 	printk("Zone PFN ranges:\n");
 	for (i = 0; i < MAX_NR_ZONES; i++) {
_

Patches currently in -mm which might be from mel@csn.ul.ie are

slab-partially-revert-list3-changes.patch
git-x86.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
page-allocator-clean-up-pcp-draining-functions.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
