From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch
 removed from -mm tree
Date: Mon, 16 Mar 2015 11:02:38 -0700
Message-ID: <55071abe.vS/tAN4CX9DBHt0p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944AbbCPSCj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 14:02:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@stgolabs.net, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, lcapitulino@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: close race when setting PageTail for gigantic pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, hugetlb: close race when setting PageTail for gigantic pages

Now that gigantic pages are dynamically allocatable, care must be taken to
ensure that p->first_page is valid before setting PageTail.

If this isn't done, then it is possible to race and have compound_head()
return NULL.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-close-race-when-setting-pagetail-for-gigantic-pages
+++ a/mm/hugetlb.c
@@ -917,7 +917,6 @@ static void prep_compound_gigantic_page(
 	__SetPageHead(page);
 	__ClearPageReserved(page);
 	for (i = 1; i < nr_pages; i++, p = mem_map_next(p, page, i)) {
-		__SetPageTail(p);
 		/*
 		 * For gigantic hugepages allocated through bootmem at
 		 * boot, it's safer to be consistent with the not-gigantic
@@ -933,6 +932,9 @@ static void prep_compound_gigantic_page(
 		__ClearPageReserved(p);
 		set_page_count(p, 0);
 		p->first_page = page;
+		/* Make sure p->first_page is always valid for PageTail() */
+		smp_wmb();
+		__SetPageTail(p);
 	}
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention-v2.patch
mm-pagewalk-prevent-positive-return-value-of-walk_page_test-from-being-passed-to-callers.patch
cxgb4-drop-__gfp_nofail-allocation.patch
sh-dwarf-destroy-mempools-on-cleanup.patch
sh-dwarf-use-mempool_create_slab_pool.patch
jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail.patch
mm-slub-parse-slub_debug-o-option-in-switch-statement.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
mm-cma-change-fallback-behaviour-for-cma-freepage.patch
mm-page_alloc-factor-out-fallback-freepage-checking.patch
mm-compaction-enhance-compaction-finish-condition.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
mm-completely-remove-dumping-per-cpu-lists-from-show_mem.patch
mm-mempolicy-migrate_to_node-should-only-migrate-to-node.patch
mm-remove-gfp_thisnode.patch
mm-thp-really-limit-transparent-hugepage-allocation-to-local-node.patch
kernel-cpuset-remove-exception-for-__gfp_thisnode.patch
mm-clarify-__gfp_nofail-deprecation-status.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
sparc-clarify-__gfp_nofail-allocation.patch
mm-mempool-do-not-allow-atomic-resizing.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
mm-hugetlb-abort-__get_user_pages-if-current-has-been-oom-killed.patch
mm-refactor-zone_movable_is_highmem.patch
mm-utilc-add-kstrimdup.patch

