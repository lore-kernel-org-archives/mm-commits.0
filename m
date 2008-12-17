From: akpm@linux-foundation.org
Subject: + mm-remove-config_out_of_line_pfn_to_page.patch added to -mm tree
Date: Wed, 17 Dec 2008 14:56:26 -0800
Message-ID: <200812172256.mBHMuQdJ028815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751226AbYLQW4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Dec 2008 17:56:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mm: remove CONFIG_OUT_OF_LINE_PFN_TO_PAGE
has been added to the -mm tree.  Its filename is
     mm-remove-config_out_of_line_pfn_to_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
proc-enclose-desc-variable-of-show_stat-in-config_sparse_irq.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
mm-make-init_section_page_cgroup-static.patch
mm-make-maddr-__iomem.patch
mm-make-mem_cgroup_resize_limit-static.patch
mm-make-scan_all_zones_unevictable_pages-static.patch
mm-make-scan_zone_unevictable_pages-static.patch
mm-make-setup_per_zone_inactive_ratio-static.patch
mm-make-vread-and-vwrite-declaration.patch
vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch
vmscan-improve-reclaim-throughput-to-bail-out-patch.patch
mm-kill-zone_is_near_oom.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
introduce-get_mm_hiwater_xxx-fix-taskstats-hiwater_xxx-accounting.patch
mm-remove-config_out_of_line_pfn_to_page.patch
remove-linux-hardirqh-from-asm-generic-localh-add-include-linux-irqflagsh-to-acpi-processor_idlec.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
irq-remove-unnecessary-ifdef.patch
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

