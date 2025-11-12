Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC994352FBF
	for <mm-commits@vger.kernel.org>; Wed, 12 Nov 2025 18:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972401; cv=none; b=IjUZqEPj7j8fBtDJdbC795u12I3OFk4sj3qcNQJieM3cMnozGDBsqECLswL8iNWBrizMgjlyGt7pTCsuFS+bFxd8nzuxvlg5b5TONvZSkpwMagVdZghuK6E/V/sEYnphlnQc0af2ZWBH1zmS/yG8tf/hC9+AVwH9uCnEEGwC6Cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972401; c=relaxed/simple;
	bh=byj1ThY2wUAo5mAfgxa/CoMIR121/45GCU20ltL/klo=;
	h=Date:To:From:Subject:Message-Id; b=NNIoMGZyRLPdZCJChdGigXcRaKgQJuizYb4yC2DCnmE+9/Odw9PmhNKAHenv+LS/WzoGm9IiA4HqNQrQrDIFAXZ/yb9jFIcCpq1OEIpfZlOPOTI3bITkDx11NS/Im0T8nHvNZu1o5CMldbUI/Yvue+ao+8epaJzVORA8Snzr1q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wp1/h7z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wp1/h7z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC8AC4CEF5;
	Wed, 12 Nov 2025 18:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762972400;
	bh=byj1ThY2wUAo5mAfgxa/CoMIR121/45GCU20ltL/klo=;
	h=Date:To:From:Subject:From;
	b=Wp1/h7z3K5cMNQ+4T6Ukbq1nxer4l8K8o/Ss5uWmqb02XAO4l0tqYrmcETSJi68uY
	 5bXFWrUHLJn2S2CTa9+irR8IV29eK9ks5DUadMEg9Tu2nMXrPUzjEOgWc1Ps9ZYspW
	 XJHJuczrqNsa3WrdWxGwUxDysAyF4YWZmEk2O854=
Date: Wed, 12 Nov 2025 10:33:16 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,ojeda@kernel.org,nathan@kernel.org,morbo@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,justinstitt@google.com,hughd@google.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch added to mm-new branch
Message-Id: <20251112183320.3AC8AC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: use vm_normal_folio{,_pmd}() instead of damon_get_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch

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
Subject: mm/damon/vaddr: use vm_normal_folio{,_pmd}() instead of damon_get_folio()
Date: Wed, 12 Nov 2025 07:41:07 -0800

A few page table walk entry callback functions in vaddr.c uses
damon_get_folio() with p{te,md}_pfn() to get the folio, and then
put_folio().  Simplify and drop unnecessary folio get/put by using
vm_normal_folio() and its friends instead.

Note that this cleanup was suggested by David Hildenbrand during a review
of another patch series [1] and the patch was updated following the
suggestion.  This patch further applies the cleanup to DAMON code that
merged before the patch.

Link: https://lkml.kernel.org/r/20251112154114.66053-5-sj@kernel.org
Link: https://lore.kernel.org/0cb3d5a5-683b-4dba-90a8-b45ab83eec53@redhat.com [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Hugh Dickins <hughd@google.com>
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

 mm/damon/vaddr.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio
+++ a/mm/damon/vaddr.c
@@ -442,7 +442,7 @@ static int damon_young_pmd_entry(pmd_t *
 
 		if (!pmd_present(pmde))
 			goto huge_out;
-		folio = damon_get_folio(pmd_pfn(pmde));
+		folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
 		if (!folio)
 			goto huge_out;
 		if (pmd_young(pmde) || !folio_test_idle(folio) ||
@@ -450,7 +450,6 @@ static int damon_young_pmd_entry(pmd_t *
 						addr))
 			priv->young = true;
 		*priv->folio_sz = HPAGE_PMD_SIZE;
-		folio_put(folio);
 huge_out:
 		spin_unlock(ptl);
 		return 0;
@@ -463,14 +462,13 @@ huge_out:
 	ptent = ptep_get(pte);
 	if (!pte_present(ptent))
 		goto out;
-	folio = damon_get_folio(pte_pfn(ptent));
+	folio = vm_normal_folio(walk->vma, addr, ptent);
 	if (!folio)
 		goto out;
 	if (pte_young(ptent) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
 	*priv->folio_sz = folio_size(folio);
-	folio_put(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
 	return 0;
@@ -718,18 +716,16 @@ static int damos_va_migrate_pmd_entry(pm
 	/* Tell page walk code to not split the PMD */
 	walk->action = ACTION_CONTINUE;
 
-	folio = damon_get_folio(pmd_pfn(pmde));
+	folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
 	if (!folio)
 		goto unlock;
 
 	if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
-		goto put_folio;
+		goto unlock;
 
 	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 		migration_lists);
 
-put_folio:
-	folio_put(folio);
 unlock:
 	spin_unlock(ptl);
 	return 0;
@@ -752,18 +748,15 @@ static int damos_va_migrate_pte_entry(pt
 	if (pte_none(ptent) || !pte_present(ptent))
 		return 0;
 
-	folio = damon_get_folio(pte_pfn(ptent));
+	folio = vm_normal_folio(walk->vma, addr, ptent);
 	if (!folio)
 		return 0;
 
 	if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
-		goto put_folio;
+		return 0;
 
 	damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 		migration_lists);
-
-put_folio:
-	folio_put(folio);
 	return 0;
 }
 
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

