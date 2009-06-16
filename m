From: akpm@linux-foundation.org
Subject: [folded] mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch removed from -mm tree
Date: Tue, 16 Jun 2009 14:57:17 -0700
Message-ID: <200906162157.n5GLvHnA026592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48078 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752047AbZFPV6j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 17:58:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, adobriyan@gmail.com, andi@firstfloor.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     mm-introduce-pagehuge-for-testing-huge-gigantic-pages update
has been removed from the -mm tree.  Its filename was
     mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch

This patch was dropped because it was folded into mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-introduce-pagehuge-for-testing-huge-gigantic-pages update
From: Wu Fengguang <fengguang.wu@intel.com>

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c          |    1 +
 include/linux/hugetlb.h |    7 +++++++
 include/linux/mm.h      |    9 ---------
 mm/hugetlb.c            |   10 ++--------
 mm/internal.h           |    1 -
 mm/page_alloc.c         |    4 +++-
 6 files changed, 13 insertions(+), 19 deletions(-)

diff -puN fs/proc/page.c~mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update fs/proc/page.c
--- a/fs/proc/page.c~mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update
+++ a/fs/proc/page.c
@@ -6,6 +6,7 @@
 #include <linux/mmzone.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/hugetlb.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
diff -puN include/linux/hugetlb.h~mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update
+++ a/include/linux/hugetlb.h
@@ -11,6 +11,8 @@
 
 struct ctl_table;
 
+int PageHuge(struct page *page);
+
 static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
 {
 	return vma->vm_flags & VM_HUGETLB;
@@ -61,6 +63,11 @@ void hugetlb_change_protection(struct vm
 
 #else /* !CONFIG_HUGETLB_PAGE */
 
+static inline int PageHuge(struct page *page)
+{
+	return 0;
+}
+
 static inline int is_vm_hugetlb_page(struct vm_area_struct *vma)
 {
 	return 0;
diff -puN include/linux/mm.h~mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update
+++ a/include/linux/mm.h
@@ -355,15 +355,6 @@ static inline void set_compound_order(st
 	page[1].lru.prev = (void *)order;
 }
 
-#ifdef CONFIG_HUGETLBFS
-int PageHuge(struct page *page);
-#else
-static inline int PageHuge(struct page *page)
-{
-	return 0;
-}
-#endif
-
 /*
  * Multiple processes may "see" the same page. E.g. for untouched
  * mappings of /dev/null, all processes see the same page full of
diff -puN mm/hugetlb.c~mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update mm/hugetlb.c
--- a/mm/hugetlb.c~mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update
+++ a/mm/hugetlb.c
@@ -578,11 +578,6 @@ static void free_huge_page(struct page *
 		hugetlb_put_quota(mapping, 1);
 }
 
-static void free_gigantic_page(struct page *page)
-{
-	__free_pages_ok(page, compound_order(page));
-}
-
 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
 {
 	set_compound_page_dtor(page, free_huge_page);
@@ -599,7 +594,7 @@ static void prep_compound_gigantic_page(
 	int nr_pages = 1 << order;
 	struct page *p = page + 1;
 
-	set_compound_page_dtor(page, free_gigantic_page);
+	/* we rely on prep_new_huge_page to set the destructor */
 	set_compound_order(page, order);
 	__SetPageHead(page);
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
@@ -618,8 +613,7 @@ int PageHuge(struct page *page)
 	page = compound_head(page);
 	dtor = get_compound_page_dtor(page);
 
-	return  dtor == free_huge_page ||
-		dtor == free_gigantic_page;
+	return dtor == free_huge_page;
 }
 
 static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
diff -puN mm/internal.h~mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update mm/internal.h
--- a/mm/internal.h~mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update
+++ a/mm/internal.h
@@ -48,7 +48,6 @@ extern void putback_lru_page(struct page
  */
 extern unsigned long highest_memmap_pfn;
 extern void __free_pages_bootmem(struct page *page, unsigned int order);
-extern void __free_pages_ok(struct page *page, unsigned int order);
 extern void prep_compound_page(struct page *page, unsigned long order);
 
 
diff -puN mm/page_alloc.c~mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update
+++ a/mm/page_alloc.c
@@ -78,6 +78,8 @@ int percpu_pagelist_fraction;
 int pageblock_order __read_mostly;
 #endif
 
+static void __free_pages_ok(struct page *page, unsigned int order);
+
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
  *	1G machine -> (16M dma, 800M-16M normal, 1G-800M high)
@@ -552,7 +554,7 @@ static void free_one_page(struct zone *z
 	spin_unlock(&zone->lock);
 }
 
-void __free_pages_ok(struct page *page, unsigned int order)
+static void __free_pages_ok(struct page *page, unsigned int order)
 {
 	unsigned long flags;
 	int i;
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
pagemap-document-clarifications.patch
pagemap-document-9-more-exported-page-flags.patch
pagemap-add-page-types-tool.patch
pagemap-add-page-types-tool-fix.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch
mm-remove-__invalidate_mapping_pages-variant.patch
vmscan-report-vm_flags-in-page_referenced.patch
vmscan-make-mapped-executable-pages-the-first-class-citizen.patch
vmscan-merge-duplicate-code-in-shrink_active_list.patch
writeback-skip-new-or-to-be-freed-inodes.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim-vmscan-fix-use-of-delta-in-zone_pagecache_reclaimable.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim-mm-fix-documentation-of-min_unmapped_ratio.patch
vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix.patch

