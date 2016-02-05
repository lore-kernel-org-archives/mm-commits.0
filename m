From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-v2.patch removed
 from -mm tree
Date: Fri, 05 Feb 2016 15:32:43 -0800
Message-ID: <56b5311b.1AgvQ3OlYDfTst8U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbcBEXco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2016 18:32:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mhocko@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-v2
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-v2.patch

This patch was dropped because it was folded into mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-v2

fix !CONFIG_COMPACTION && CONFIG_MEMORY_ISOLATION=y build

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    2 +-
 mm/hugetlb.c        |    2 +-
 mm/page_alloc.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/gfp.h~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-v2 include/linux/gfp.h
--- a/include/linux/gfp.h~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-v2
+++ a/include/linux/gfp.h
@@ -547,7 +547,7 @@ static inline bool pm_suspended_storage(
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_MEMORY_ISOLATION
+#if (defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_COMPACTION)) || defined(CONFIG_CMA)
 /* The below functions must be run on a range from a single zone. */
 extern int alloc_contig_range(unsigned long start, unsigned long end,
 			      unsigned migratetype);
diff -puN mm/hugetlb.c~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-v2 mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-v2
+++ a/mm/hugetlb.c
@@ -1001,7 +1001,7 @@ static int hstate_next_node_to_free(stru
 		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
 		nr_nodes--)
 
-#if defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_X86_64)
+#if defined(CONFIG_X86_64) && ((defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_COMPACTION)) || defined(CONFIG_CMA))
 static void destroy_compound_gigantic_page(struct page *page,
 					unsigned int order)
 {
diff -puN mm/page_alloc.c~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-v2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-v2
+++ a/mm/page_alloc.c
@@ -6620,7 +6620,7 @@ bool is_pageblock_removable_nolock(struc
 	return !has_unmovable_pages(zone, page, 0, true);
 }
 
-#ifdef CONFIG_MEMORY_ISOLATION
+#if (defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_COMPACTION)) || defined(CONFIG_CMA)
 
 static unsigned long pfn_max_align_down(unsigned long pfn)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-kconfig-correct-description-of-deferred_struct_page_init.patch
mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages.patch
mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages-fix2.patch
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
mm-use-radix_tree_iter_retry-fix.patch

