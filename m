Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14EB343D6A
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 18:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972395; cv=none; b=lbknq30EjRGy67nA5MmvJQUlP+QmY/j+nORdR94s8HGAN5BqkHEYFIRwfNgWBsowUX0MEBjtUYFEpleiYi53G+ZANoxzcck6tSqi+cLIJxRhcbssDHnZTh78SKzRZz//CDDc9q0qI/p/lCw2CMd9TwpfzQLo5BctkIl450gQGsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972395; c=relaxed/simple;
	bh=otZs0Fh7EI/Laa/M5TOt9m2JkYS9ZjPFxcChBt/dUXM=;
	h=Date:To:From:Subject:Message-Id; b=Daw+if5dPsHphH0d0TAr1bgPp04X8b1XE21/47sHS84LjyEwrlqXpPyFrfupM/g7koFOAtKIk9+tmK7A8ls3g2Ts0ECRJobW9cXGnWuTggjpBZJOk69SeWL6tq8S5sPO08n9BxkkJ2652g1kIeECECKqI1hdYeNjt7oxCiEgvAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hm2eApco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hm2eApco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352E9C113D0;
	Wed, 12 Nov 2025 18:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762972395;
	bh=otZs0Fh7EI/Laa/M5TOt9m2JkYS9ZjPFxcChBt/dUXM=;
	h=Date:To:From:Subject:From;
	b=hm2eApco4ChjM4ypyHd6Bxa2/7K3ABxR7qY4zQV70N5qPvlQFXS4dmJGe+uaI2yuu
	 q7fbenb2VKxVVTTpXqPWLzQBTHctxm+jjKxrj/9469ucRC7GGKLOsuXNq+CQ5vB/by
	 rlpru6srNo1LtxFQMUg8WucCH0USRRKNfHWUP8fs=
Date: Wed, 12 Nov 2025 10:33:14 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch added to mm-new branch
Message-Id: <20251112183315.352E9C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: cleanup using pmd_trans_huge_lock()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: cleanup using pmd_trans_huge_lock()
Date: Wed, 12 Nov 2025 07:41:06 -0800

Three pmd walk functions in vaddr.c are using pmd_trans_huge() and
pmd_lock() to handle THPs.  Simplify the code by replacing the two
function calls with a single pmd_trans_huge_lock() call.

Note that this cleanup is not only reducing the lines of code, but also
simplifies code execution flows for migration entries case, as kindly
explained [1] by Hugh, who suggested this cleanup.

Link: https://lkml.kernel.org/r/20251112154114.66053-4-sj@kernel.org
Link: https://lore.kernel.org/296c2b3f-6748-158f-b85d-2952165c0588@google.com [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: Hugh Dickins <hughd@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   48 +++++++++++----------------------------------
 1 file changed, 12 insertions(+), 36 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock
+++ a/mm/damon/vaddr.c
@@ -307,24 +307,14 @@ static int damon_mkold_pmd_entry(pmd_t *
 		unsigned long next, struct mm_walk *walk)
 {
 	pte_t *pte;
-	pmd_t pmde;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge(pmdp_get(pmd))) {
-		ptl = pmd_lock(walk->mm, pmd);
-		pmde = pmdp_get(pmd);
-
-		if (!pmd_present(pmde)) {
-			spin_unlock(ptl);
-			return 0;
-		}
-
-		if (pmd_trans_huge(pmde)) {
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (ptl) {
+		if (pmd_present(pmdp_get(pmd)))
 			damon_pmdp_mkold(pmd, walk->vma, addr);
-			spin_unlock(ptl);
-			return 0;
-		}
 		spin_unlock(ptl);
+		return 0;
 	}
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
@@ -446,21 +436,12 @@ static int damon_young_pmd_entry(pmd_t *
 	struct damon_young_walk_private *priv = walk->private;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge(pmdp_get(pmd))) {
-		pmd_t pmde;
-
-		ptl = pmd_lock(walk->mm, pmd);
-		pmde = pmdp_get(pmd);
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (ptl) {
+		pmd_t pmde = pmdp_get(pmd);
 
-		if (!pmd_present(pmde)) {
-			spin_unlock(ptl);
-			return 0;
-		}
-
-		if (!pmd_trans_huge(pmde)) {
-			spin_unlock(ptl);
-			goto regular_page;
-		}
+		if (!pmd_present(pmde))
+			goto huge_out;
 		folio = damon_get_folio(pmd_pfn(pmde));
 		if (!folio)
 			goto huge_out;
@@ -474,8 +455,6 @@ huge_out:
 		spin_unlock(ptl);
 		return 0;
 	}
-
-regular_page:
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
@@ -910,13 +889,10 @@ static int damos_va_stat_pmd_entry(pmd_t
 	int nr;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge(*pmd)) {
-		pmd_t pmde;
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
+		pmd_t pmde = pmdp_get(pmd);
 
-		ptl = pmd_trans_huge_lock(pmd, vma);
-		if (!ptl)
-			return 0;
-		pmde = pmdp_get(pmd);
 		if (!pmd_present(pmde))
 			goto huge_unlock;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch
mm-damon-core-fix-wrong-comment-of-damon_call-return-timing.patch
docs-mm-damon-design-fix-wrong-link-to-intervals-goal-section.patch
docs-admin-guide-mm-damon-stat-fix-a-typo-s-sampling-events-sampling-interval.patch
docs-admin-guide-mm-damon-usage-document-empty-target-regions-commit-behavior.patch
docs-admin-guide-mm-damon-reclaim-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-addr_unit-parameter.patch
docs-admin-guide-mm-damon-stat-document-aggr_interval_us-parameter.patch
docs-admin-guide-mm-damon-stat-document-negative-idle-time.patch
mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch
mm-damon-sysfs-test-commit-input-against-realistic-destination.patch
mm-damon-sysfs-implement-obsolete_target-file.patch
docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch
docs-abi-damon-document-obsolete_target-sysfs-file.patch
selftests-damon-_damon_sysfs-support-obsolete_target-file.patch
drgn_dump_damon_status-dump-damon_target-obsolete.patch
sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch
selftests-damon-sysfs-add-obsolete_target-test.patch
mm-damon-tests-core-kunit-fix-memory-leak-in-damon_test_set_filters_default_reject.patch
mm-damon-tests-core-kunit-handle-allocation-failures-in-damon_test_regions.patch
mm-damon-tests-core-kunit-handle-memory-failure-from-damon_test_target.patch
mm-damon-tests-core-kunit-handle-memory-alloc-failure-from-damon_test_aggregate.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_split_at.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_merge_two.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-dasmon_test_merge_regions_of.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_split_regions_of.patch
mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_ops_registration.patch
mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_set_regions.patch
mm-damon-tests-core-kunit-handle-alloc-failures-in-damon_test_update_monitoring_result.patch
mm-damon-tests-core-kunit-handle-alloc-failure-on-damon_test_set_attrs.patch
mm-damon-tests-core-kunit-handle-alloc-failres-in-damon_test_new_filter.patch
mm-damon-tests-core-kunit-handle-alloc-failure-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damos_test_filter_out.patch
mm-damon-tests-core-kunit-handle-alloc-failures-on-damon_test_set_filters_default_reject.patch
mm-damon-tests-vaddr-kunit-handle-alloc-failures-on-damon_do_test_apply_three_regions.patch
mm-damon-tests-vaddr-kunit-handle-alloc-failures-in-damon_test_split_evenly_fail.patch
mm-damon-tests-vaddr-kunit-handle-alloc-failures-on-damon_test_split_evenly_succ.patch
mm-damon-tests-sysfs-kunit-handle-alloc-failures-on-damon_sysfs_test_add_targets.patch
mm-damon-tests-core-kunit-remove-unnecessary-damon_ctx-variable-on-damon_test_split_at.patch
mm-damon-tests-core-kunit-remove-unused-ctx-in-damon_test_split_regions_of.patch
mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

