From: akpm@linux-foundation.org
Subject: - mm-remove-config_out_of_line_pfn_to_page.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:14:51 -0800
Message-ID: <200901072214.n07MEp3f014726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761820AbZAGWOz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:14:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove CONFIG_OUT_OF_LINE_PFN_TO_PAGE
has been removed from the -mm tree.  Its filename was
     mm-remove-config_out_of_line_pfn_to_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove CONFIG_OUT_OF_LINE_PFN_TO_PAGE
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

No architectures use CONFIG_OUT_OF_LINE_PFN_TO_PAGE - it can be removed.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |    7 -------
 mm/page_alloc.c                    |   13 -------------
 2 files changed, 20 deletions(-)

diff -puN include/asm-generic/memory_model.h~mm-remove-config_out_of_line_pfn_to_page include/asm-generic/memory_model.h
--- a/include/asm-generic/memory_model.h~mm-remove-config_out_of_line_pfn_to_page
+++ a/include/asm-generic/memory_model.h
@@ -69,15 +69,8 @@
 })
 #endif /* CONFIG_FLATMEM/DISCONTIGMEM/SPARSEMEM */
 
-#ifdef CONFIG_OUT_OF_LINE_PFN_TO_PAGE
-struct page;
-/* this is useful when inlined pfn_to_page is too big */
-extern struct page *pfn_to_page(unsigned long pfn);
-extern unsigned long page_to_pfn(struct page *page);
-#else
 #define page_to_pfn __page_to_pfn
 #define pfn_to_page __pfn_to_page
-#endif /* CONFIG_OUT_OF_LINE_PFN_TO_PAGE */
 
 #endif /* __ASSEMBLY__ */
 
diff -puN mm/page_alloc.c~mm-remove-config_out_of_line_pfn_to_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-config_out_of_line_pfn_to_page
+++ a/mm/page_alloc.c
@@ -4587,19 +4587,6 @@ void *__init alloc_large_system_hash(con
 	return table;
 }
 
-#ifdef CONFIG_OUT_OF_LINE_PFN_TO_PAGE
-struct page *pfn_to_page(unsigned long pfn)
-{
-	return __pfn_to_page(pfn);
-}
-unsigned long page_to_pfn(struct page *page)
-{
-	return __page_to_pfn(page);
-}
-EXPORT_SYMBOL(pfn_to_page);
-EXPORT_SYMBOL(page_to_pfn);
-#endif /* CONFIG_OUT_OF_LINE_PFN_TO_PAGE */
-
 /* Return a pointer to the bitmap storing bits affecting a block of pages */
 static inline unsigned long *get_pageblock_bitmap(struct zone *zone,
 							unsigned long pfn)
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
devices-cgroup-allow-mkfifo.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

