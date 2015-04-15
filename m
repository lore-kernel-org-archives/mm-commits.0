From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
 removed from -mm tree
Date: Wed, 15 Apr 2015 15:36:10 -0700
Message-ID: <552ee7da.P1XbLTe3xZbPr4tr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbbDOWgL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 18:36:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.cz, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix
has been removed from the -mm tree.  Its filename was
     mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch

This patch was dropped because it was folded into mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix

fix weird code layout while we're there

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN mm/huge_memory.c~mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix mm/huge_memory.c
--- a/mm/huge_memory.c~mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix
+++ a/mm/huge_memory.c
@@ -1129,8 +1129,7 @@ alloc:
 		goto out;
 	}
 
-	if (unlikely(mem_cgroup_try_charge(new_page, mm,
-					   huge_gfp, &memcg))) {
+	if (unlikely(mem_cgroup_try_charge(new_page, mm, huge_gfp, &memcg))) {
 		put_page(new_page);
 		if (page) {
 			split_huge_page(page);
@@ -2322,8 +2321,8 @@ static bool khugepaged_prealloc_page(str
 	return true;
 }
 
-static struct page
-*khugepaged_alloc_page(struct page **hpage, gfp_t *gfp, struct mm_struct *mm,
+static struct page *
+khugepaged_alloc_page(struct page **hpage, gfp_t *gfp, struct mm_struct *mm,
 		       struct vm_area_struct *vma, unsigned long address,
 		       int node)
 {
@@ -2394,8 +2393,8 @@ static bool khugepaged_prealloc_page(str
 	return true;
 }
 
-static struct page
-*khugepaged_alloc_page(struct page **hpage, gfp_t *gfp, struct mm_struct *mm,
+static struct page *
+khugepaged_alloc_page(struct page **hpage, gfp_t *gfp, struct mm_struct *mm,
 		       struct vm_area_struct *vma, unsigned long address,
 		       int node)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place.patch
document-interaction-between-compaction-and-the-unevictable-lru.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-mmapc-use-while-instead-of-ifgoto-fix.patch
mm-hugetlb-introduce-pagehugeactive-flag-fix.patch
mm-hugetlb-cleanup-using-pagehugeactive-flag-fix.patch
mm-memblock-add-debug-output-for-the-memblock_add-fix.patch
mm-uninline-and-cleanup-page-mapping-related-helpers-checkpatch-fixes.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
mm-memory-print-also-a_ops-readpage-in-print_bad_pte-fix.patch
mm-compactionc-fix-suitable_migration_target-unused-warning.patch
zsmalloc-support-compaction-fix.patch
proc-pid-status-show-all-sets-of-pid-according-to-ns-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch

