From: akpm@linux-foundation.org
Subject: + mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages.patch
 added to -mm tree
Date: Wed, 03 Feb 2016 13:57:53 -0800
Message-ID: <56b277e1.rqMP7o3Z0N3O2BL7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42493 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815AbcBCV5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:57:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, dave@stgolabs.net, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, isimatu.yasuaki@jp.fujitsu.com, kirill.shutemov@linux.intel.com, lcapitulino@redhat.com, mgorman@techsingularity.net, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: don't require CMA for runtime gigantic pages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

 include/linux/gfp.h |    6 +++---
 mm/hugetlb.c        |    2 +-
 mm/page_alloc.c     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/gfp.h~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages include/linux/gfp.h
--- a/include/linux/gfp.h~mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages
+++ a/include/linux/gfp.h
@@ -547,16 +547,16 @@ static inline bool pm_suspended_storage(
 }
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_CMA
-
+#ifdef CONFIG_MEMORY_ISOLATION
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
+#if defined(CONFIG_MEMORY_ISOLATION) && defined(CONFIG_X86_64)
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
+#ifdef CONFIG_MEMORY_ISOLATION
 
 static unsigned long pfn_max_align_down(unsigned long pfn)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-kconfig-correct-description-of-deferred_struct_page_init.patch
mm-hugetlb-dont-require-cma-for-runtime-gigantic-pages.patch
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

