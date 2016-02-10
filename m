From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages.patch removed from
 -mm tree
Date: Wed, 10 Feb 2016 11:35:50 -0800
Message-ID: <56bb9116.L3kqe62N+LuRo32j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbcBJTfv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 14:35:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, dave@stgolabs.net, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, kirill.shutemov@linux.intel.com, lcapitulino@redhat.com, mgorman@techsingularity.net, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: don't require CMA for runtime gigantic pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, hugetlb: don't require CMA for runtime gigantic pages

Commit 944d9fec8d7a ("hugetlb: add support for gigantic page allocation at
runtime") has added the runtime gigantic page allocation via
alloc_contig_range(), making this support available only when CONFIG_CMA
is enabled.  Because it doesn't depend on MIGRATE_CMA pageblocks and the
associated infrastructure, it is possible with few simple adjustments to
require only CONFIG_MEMORY_ISOLATION instead of full CONFIG_CMA.

After this patch, alloc_contig_range() and related functions are available
and used for gigantic pages with just CONFIG_MEMORY_ISOLATION enabled. 
Note CONFIG_CMA selects CONFIG_MEMORY_ISOLATION.  This allows supporting
runtime gigantic pages without the CMA-specific checks in page allocator
fastpaths.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |    4 ++--
 include/linux/gfp.h       |    6 +++---
 mm/hugetlb.c              |    2 +-
 mm/page_alloc.c           |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/x86/mm/hugetlbpage.c~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages
+++ a/arch/x86/mm/hugetlbpage.c
@@ -173,10 +173,10 @@ static __init int setup_hugepagesz(char
 }
 __setup("hugepagesz=", setup_hugepagesz);
 
-#ifdef CONFIG_CMA
+#if (defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_COMPACTION)) || defined(CONFIG_CMA)
 static __init int gigantic_pages_init(void)
 {
-	/* With CMA we can allocate gigantic pages at runtime */
+	/* With compaction or CMA we can allocate gigantic pages at runtime */
 	if (cpu_has_gbpages && !size_to_hstate(1UL << PUD_SHIFT))
 		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
 	return 0;
diff -puN include/linux/gfp.h~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages include/linux/gfp.h
--- a/include/linux/gfp.h~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages
+++ a/include/linux/gfp.h
@@ -547,16 +547,16 @@ static inline bool pm_suspended_storage(
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_CMA
-
+#if (defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_COMPACTION)) || defined(CONFIG_CMA)
 /* The below functions must be run on a range from a single zone. */
 extern int alloc_contig_range(unsigned long start, unsigned long end,
 			      unsigned migratetype);
 extern void free_contig_range(unsigned long pfn, unsigned nr_pages);
+#endif
 
+#ifdef CONFIG_CMA
 /* CMA stuff */
 extern void init_cma_reserved_pageblock(struct page *page);
-
 #endif
 
 #endif /* __LINUX_GFP_H */
diff -puN mm/hugetlb.c~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages
+++ a/mm/hugetlb.c
@@ -1001,7 +1001,7 @@ static int hstate_next_node_to_free(stru
 		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
 		nr_nodes--)
 
-#if defined(CONFIG_CMA) && defined(CONFIG_X86_64)
+#if defined(CONFIG_X86_64) && ((defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_COMPACTION)) || defined(CONFIG_CMA))
 static void destroy_compound_gigantic_page(struct page *page,
 					unsigned int order)
 {
diff -puN mm/page_alloc.c~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages
+++ a/mm/page_alloc.c
@@ -6620,7 +6620,7 @@ bool is_pageblock_removable_nolock(struc
 	return !has_unmovable_pages(zone, page, 0, true);
 }
 
-#ifdef CONFIG_CMA
+#if (defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_COMPACTION)) || defined(CONFIG_CMA)
 
 static unsigned long pfn_max_align_down(unsigned long pfn)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are

tracepoints-move-trace_print_flags-definitions-to-tracepoint-defsh.patch
mm-tracing-make-show_gfp_flags-up-to-date.patch
tools-perf-make-gfp_compact_table-up-to-date.patch
mm-tracing-unify-mm-flags-handling-in-tracepoints-and-printk.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-printk-introduce-new-format-string-for-flags-fix.patch
mm-debug-replace-dump_flags-with-the-new-printk-formats.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-page_owner-print-migratetype-of-page-and-pageblock-symbolic-flags.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch
mm-kswapd-remove-bogus-check-of-balance_classzone_idx.patch
mm-compaction-introduce-kcompactd.patch
mm-memory-hotplug-small-cleanup-in-online_pages.patch
mm-kswapd-replace-kswapd-compaction-with-waking-up-kcompactd.patch
mm-compaction-adapt-isolation_suitable-flushing-to-kcompactd.patch
mm-use-radix_tree_iter_retry-fix.patch

