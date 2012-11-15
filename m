From: akpm@linux-foundation.org
Subject: + revert-mm-fix-up-zone-present-pages.patch added to -mm tree
Date: Thu, 15 Nov 2012 11:26:04 -0800
Message-ID: <20121115192605.79F0220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:57711 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768812Ab2KOT0J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 14:26:09 -0500
Received: by mail-ea0-f202.google.com with SMTP id f11so134304eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 11:26:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, jiang.liu@huawei.com, mel@csn.ul.ie, minchan.kim@gmail.com, ptesarik@suse.cz, rientjes@google.com, tony.luck@intel.com, torvalds@linux-foundation.org, wujianguo@huawei.com, yinghai@kernel.org


The patch titled
     Subject: revert "mm: fix-up zone present pages"
has been added to the -mm tree.  Its filename is
     revert-mm-fix-up-zone-present-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "mm: fix-up zone present pages"

Revert

commit 7f1290f2f2a4d2c3f1b7ce8e87256e052ca23125
Author:     Jianguo Wu <wujianguo@huawei.com>
AuthorDate: Mon Oct 8 16:33:06 2012 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Tue Oct 9 16:22:54 2012 +0900

    mm: fix-up zone present pages


That patch tried to fix a issue when calculating zone->present_pages, but
it caused a regression on 32bit systems with HIGHMEM.  With that
changeset, reset_zone_present_pages() resets all zone->present_pages to
zero, and fixup_zone_present_pages() is called to recalculate
zone->present_pages when the boot allocator frees core memory pages into
buddy allocator.  Because highmem pages are not freed by bootmem
allocator, all highmem zones' present_pages becomes zero.

Various options for improving the situation are being discussed but for
now, let's return to the 3.6 code.

Cc: Jianguo Wu <wujianguo@huawei.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Petr Tesarik <ptesarik@suse.cz>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |    1 -
 include/linux/mm.h  |    4 ----
 mm/bootmem.c        |   10 +---------
 mm/memory_hotplug.c |    7 -------
 mm/nobootmem.c      |    3 ---
 mm/page_alloc.c     |   34 ----------------------------------
 6 files changed, 1 insertion(+), 58 deletions(-)

diff -puN arch/ia64/mm/init.c~revert-mm-fix-up-zone-present-pages arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~revert-mm-fix-up-zone-present-pages
+++ a/arch/ia64/mm/init.c
@@ -637,7 +637,6 @@ mem_init (void)
 
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
 
-	reset_zone_present_pages();
 	for_each_online_pgdat(pgdat)
 		if (pgdat->bdata->node_bootmem_map)
 			totalram_pages += free_all_bootmem_node(pgdat);
diff -puN include/linux/mm.h~revert-mm-fix-up-zone-present-pages include/linux/mm.h
--- a/include/linux/mm.h~revert-mm-fix-up-zone-present-pages
+++ a/include/linux/mm.h
@@ -1724,9 +1724,5 @@ static inline unsigned int debug_guardpa
 static inline bool page_is_guard(struct page *page) { return false; }
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
-extern void reset_zone_present_pages(void);
-extern void fixup_zone_present_pages(int nid, unsigned long start_pfn,
-				unsigned long end_pfn);
-
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff -puN mm/bootmem.c~revert-mm-fix-up-zone-present-pages mm/bootmem.c
--- a/mm/bootmem.c~revert-mm-fix-up-zone-present-pages
+++ a/mm/bootmem.c
@@ -198,8 +198,6 @@ static unsigned long __init free_all_boo
 			int order = ilog2(BITS_PER_LONG);
 
 			__free_pages_bootmem(pfn_to_page(start), order);
-			fixup_zone_present_pages(page_to_nid(pfn_to_page(start)),
-					start, start + BITS_PER_LONG);
 			count += BITS_PER_LONG;
 			start += BITS_PER_LONG;
 		} else {
@@ -210,9 +208,6 @@ static unsigned long __init free_all_boo
 				if (vec & 1) {
 					page = pfn_to_page(start + off);
 					__free_pages_bootmem(page, 0);
-					fixup_zone_present_pages(
-						page_to_nid(page),
-						start + off, start + off + 1);
 					count++;
 				}
 				vec >>= 1;
@@ -226,11 +221,8 @@ static unsigned long __init free_all_boo
 	pages = bdata->node_low_pfn - bdata->node_min_pfn;
 	pages = bootmem_bootmap_pages(pages);
 	count += pages;
-	while (pages--) {
-		fixup_zone_present_pages(page_to_nid(page),
-				page_to_pfn(page), page_to_pfn(page) + 1);
+	while (pages--)
 		__free_pages_bootmem(page++, 0);
-	}
 
 	bdebug("nid=%td released=%lx\n", bdata - bootmem_node_data, count);
 
diff -puN mm/memory_hotplug.c~revert-mm-fix-up-zone-present-pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~revert-mm-fix-up-zone-present-pages
+++ a/mm/memory_hotplug.c
@@ -106,7 +106,6 @@ static void get_page_bootmem(unsigned lo
 void __ref put_page_bootmem(struct page *page)
 {
 	unsigned long type;
-	struct zone *zone;
 
 	type = (unsigned long) page->lru.next;
 	BUG_ON(type < MEMORY_HOTPLUG_MIN_BOOTMEM_TYPE ||
@@ -117,12 +116,6 @@ void __ref put_page_bootmem(struct page 
 		set_page_private(page, 0);
 		INIT_LIST_HEAD(&page->lru);
 		__free_pages_bootmem(page, 0);
-
-		zone = page_zone(page);
-		zone_span_writelock(zone);
-		zone->present_pages++;
-		zone_span_writeunlock(zone);
-		totalram_pages++;
 	}
 
 }
diff -puN mm/nobootmem.c~revert-mm-fix-up-zone-present-pages mm/nobootmem.c
--- a/mm/nobootmem.c~revert-mm-fix-up-zone-present-pages
+++ a/mm/nobootmem.c
@@ -116,8 +116,6 @@ static unsigned long __init __free_memor
 		return 0;
 
 	__free_pages_memory(start_pfn, end_pfn);
-	fixup_zone_present_pages(pfn_to_nid(start >> PAGE_SHIFT),
-			start_pfn, end_pfn);
 
 	return end_pfn - start_pfn;
 }
@@ -128,7 +126,6 @@ unsigned long __init free_low_memory_cor
 	phys_addr_t start, end, size;
 	u64 i;
 
-	reset_zone_present_pages();
 	for_each_free_mem_range(i, MAX_NUMNODES, &start, &end, NULL)
 		count += __free_memory_core(start, end);
 
diff -puN mm/page_alloc.c~revert-mm-fix-up-zone-present-pages mm/page_alloc.c
--- a/mm/page_alloc.c~revert-mm-fix-up-zone-present-pages
+++ a/mm/page_alloc.c
@@ -6098,37 +6098,3 @@ void dump_page(struct page *page)
 	dump_page_flags(page->flags);
 	mem_cgroup_print_bad_page(page);
 }
-
-/* reset zone->present_pages */
-void reset_zone_present_pages(void)
-{
-	struct zone *z;
-	int i, nid;
-
-	for_each_node_state(nid, N_HIGH_MEMORY) {
-		for (i = 0; i < MAX_NR_ZONES; i++) {
-			z = NODE_DATA(nid)->node_zones + i;
-			z->present_pages = 0;
-		}
-	}
-}
-
-/* calculate zone's present pages in buddy system */
-void fixup_zone_present_pages(int nid, unsigned long start_pfn,
-				unsigned long end_pfn)
-{
-	struct zone *z;
-	unsigned long zone_start_pfn, zone_end_pfn;
-	int i;
-
-	for (i = 0; i < MAX_NR_ZONES; i++) {
-		z = NODE_DATA(nid)->node_zones + i;
-		zone_start_pfn = z->zone_start_pfn;
-		zone_end_pfn = zone_start_pfn + z->spanned_pages;
-
-		/* if the two regions intersect */
-		if (!(zone_start_pfn >= end_pfn	|| zone_end_pfn <= start_pfn))
-			z->present_pages += min(end_pfn, zone_end_pfn) -
-					    max(start_pfn, zone_start_pfn);
-	}
-}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

swapfile-fix-name-leak-in-swapoff-fix.patch
linux-next.patch
linux-next-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
revert-mm-fix-up-zone-present-pages.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
irq-tsk-comm-is-an-array.patch
drivers-tty-serial-serial_corec-fix-uart_get_attr_port-shift.patch
mm.patch
mm-introduce-mm_find_pmd-fix.patch
memory-hotplug-update-mce_bad_pages-when-removing-the-memory-fix.patch
slub-hotplug-ignore-unrelated-nodes-hot-adding-and-hot-removing.patch
mmvmscan-only-evict-file-pages-when-we-have-plenty-fix.patch
slub-slub-specific-propagation-changes-fix.patch
dmapool-make-dmapool_debug-detect-corruption-of-free-marker-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix.patch
mm-support-more-pagesizes-for-map_hugetlb-shm_hugetlb-v7-fix-fix-fix-fix-checkpatch-fixes.patch
mm-check-rb_subtree_gap-correctness-fix.patch
mm-rearrange-vm_area_struct-for-fewer-cache-misses-checkpatch-fixes.patch
mm-vm_unmapped_area-lookup-function-checkpatch-fixes.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-i386-architecture-fix.patch
mm-use-vm_unmapped_area-on-mips-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix.patch
mm-use-vm_unmapped_area-on-arm-architecture-fix-fix.patch
mm-use-vm_unmapped_area-on-sh-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc32-architecture-fix-fix.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-tile-architecture-fix.patch
mm-use-vm_unmapped_area-on-sparc64-architecture-fix.patch
arch-sparc-kernel-sys_sparc_64c-s-colour-color.patch
mm-adjust-address_space_operationsmigratepage-return-code-fix.patch
mm-introduce-a-common-interface-for-balloon-pages-mobility-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix.patch
virtio_balloon-introduce-migration-primitives-to-balloon-pages-fix-fix-fix.patch
bootmem-fix-wrong-call-parameter-for-free_bootmem-fix.patch
mm-export-a-function-to-get-vm-committed-memory-fix.patch
mm-memory-hotplug-dynamic-configure-movable-memory-and-portion-memory-fix.patch
drop_caches-add-some-documentation-and-info-messsge-checkpatch-fixes.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
maintainers-add-joe-to-checkpatch-maintainers.patch
binfmt_elf-fix-corner-case-kfree-of-uninitialized-data-checkpatch-fixes.patch
rtc-avoid-calling-platform_device_put-twice-in-test_init-fix.patch
hfsplus-add-support-of-manipulation-by-attributes-file-checkpatch-fixes.patch
procfs-add-vmflags-field-in-smaps-output-v4.patch
procfs-add-vmflags-field-in-smaps-output-v4-fix.patch
ipc-add-sysctl-to-specify-desired-next-object-id-checkpatch-fixes.patch
ipc-message-queue-receive-cleanup-checkpatch-fixes.patch
ipc-convert-prepare_copy-from-macro-to-function-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
scatterlist-dont-bug-when-we-can-trivially-return-a-proper-error-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

