Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2BA30D419;
	Wed,  7 Oct 2026 00:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334336; cv=none; b=gKrFVLYAOnte4LMJC2xDr30fxtoO9TmkH3ggQGjDtC87xPV3nncp7eKAwuQUDRfcDfiNyqcVW9fN+q4GRjUtUw84AtZsyT9X3G0xTIQsAlvY0Nsi6y4b6zT6y0B9LQk7p/vMSNHhzoM5xfuQy1rGmoRG6dnGJcffbi6zvIKFR6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334336; c=relaxed/simple;
	bh=Xzpenz2JO56Q6jybIleQQ0436UD50Nfoo2r6uBJZkzc=;
	h=Date:To:From:Subject:Message-Id; b=jcUXvHjtP+WfPueGeb7xpDfCKaL+Vuzap93FZa8DxymtfMEQHp6YPkT9kyEq9WJCr1LEj9+bOQv51G7K3uATuq0y6a+X/vIr/n1pSWz1ba78sWntV4684XzMdbnhsybaASLGPBrYTvMXB+6khtdDS4n88i4dFC8g3CeWOlvejvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MhF3pY0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MhF3pY0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E821F0089C;
	Wed,  7 Oct 2026 00:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334334;
	bh=tV9673NcL8i+Vs0Bxa68GE0mD8NRyR2ONZQp+DpElCU=;
	h=Date:To:From:Subject;
	b=MhF3pY0omFEB4dB/oHkYSkYY0ZNebmT61wPdDxSfsNACNqdKgjPrEprTgeQzi+s0Z
	 hOrCZOJHSx9376Nf79Dp665f0uGF2+KxI4iy4qGbDkipC7jJjrr4B/X6zeFYvSSxC7
	 vQmjnfKldT+Y4Ux/U83zsS7C/Nl7YomclOOuBhwk=
Date: Tue, 06 Oct 2026 17:52:14 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch removed from -mm tree
Message-Id: <20261007005214.C3E821F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: handle extreme memory state in get_in_active_mem_bp()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: handle extreme memory state in get_in_active_mem_bp()
Date: Tue, 1 Sep 2026 06:18:49 -0700

damos_get_in_active_mem_bp() uses the sum of the active and inactive
memory amount as a denominator.  In an extreme and unlikely environment,
active and inactive memory might be zero.  In this case, hence, it results
in a divide by zero problem.  Avoid it by changing the denominator to one
if it is zero, before it is being used.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-9-sj@kernel.org
Link: https://lore.kernel.org/20260721034756.147011-1-sj@kernel.org [1]
Fixes: 4835e2871321 ("mm/damon/core: introduce [in]active memory ratio damos quota goal metric")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 7.0.x
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp
+++ a/mm/damon/core.c
@@ -3009,7 +3009,7 @@ static unsigned int damos_get_in_active_
 		global_node_page_state(NR_LRU_BASE + LRU_ACTIVE_FILE);
 	inactive = global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_ANON) +
 		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
-	total = active + inactive;
+	total = max(active + inactive, 1);
 	if (active_ratio)
 		return mult_frac(active, 10000, total);
 	return mult_frac(inactive, 10000, total);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold.patch
mm-damon-core-remove-debug-messages.patch
mm-damon-core-remove-debug-messages-fix.patch
mm-damon-vaddr-remove-a-debug-message.patch
mm-damon-core-validate-number-of-probes-in-valid_probe_params.patch
mm-damon-sysfs-remove-probes-number-validation.patch
mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case.patch
mm-damon-tests-core-kunit-test-=0-size-damon_set_regions-inputs.patch
mm-damon-tests-core-kunit-test-overlapping-ranges-for-set_regions.patch
mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch
selftests-damon-sysfssh-test-hugepage_mem_bp-quota-goal.patch
docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies.patch
docs-abi-damon-recommend-subsystem-doc-instead-of-admin-guide.patch
mm-damon-core-error-damos_commit_quota_goal-for-zero-target_value.patch
revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
revert-samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch
mm-damon-core-set-ctx-call_controls_obsolete-in-damon_new_ctx.patch
mm-damon-reclaim-remove-unnecessary-damon_call-param-validation.patch
mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch
mm-damon-vaddr-support-prep_probes.patch
mm-damon-paddr-move-probe-filter-handling-to-ops-common.patch
mm-damon-vaddr-support-apply_probe.patch
mm-damon-vaddr-extend-apply_probes-for-hugetlb.patch
mm-damon-vaddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-api-introduce-damon_filter_type_pgidle_set.patch
mm-damon-paddr-support-damon_filter_type_pgidle_set.patch
mm-damon-vaddr-support-damon_filter_type_pgidle_set.patch
mm-damon-sysfs-support-damon_filter_type_pgidle_set.patch
docs-mm-damon-design-update-for-pgidle_set-probe-filter.patch
mm-damon-api-introduce-damos_filter_type_probe_hits_wsum.patch
mm-damon-api-introduce-damos_filter_type_probe_hits_wsum-fix.patch
mm-damon-core-extend-probe_hits_wsum-for-moving-sum-based-calculation.patch
mm-damon-core-support-probe_hits_wsum-damos-core-filter.patch
mm-damon-sysfs-schemes-rename-sysfs_filter-sz_range-to-range_minmax.patch
mm-damon-sysfs-schemes-support-probe_hits_wsum-damos-core-filter.patch
docs-mm-damon-design-update-for-probe_hits_wsum-damos-core-filter.patch
docs-admin-guide-mm-damon-usage-update-for-probe_hits_wsum-damos-filter.patch
mm-damon-sysfs-schemes-read-sysfs_filter-addr_range-only-once.patch
mm-damon-sysfs-schemes-read-sysfs_filter-sz_range-only-once.patch
mm-damon-core-return-an-error-from-damos_commit_filter_arg.patch
mm-damon-core-disallow-max-min-damos-filter-range-arguments-commit.patch
mm-damon-sysfs-schemes-drop-centralized-filter-range-arg-validations.patch
mm-damon-sysfs-schemes-use-switch-case-in-add_scheme_filters.patch
mm-damon-core-kunit-extend-damos_commit_filter_for-for-wrong-input.patch
mm-damon-core-kunit-test-invalid-damos-filter-commits.patch
mm-damon-api-introduce-damon_filter_type_hugepage_size.patch
mm-damon-core-commit-hugepage_size-type-damon-filter.patch
mm-damon-ops-common-support-hugepage_size-damon-filter-matching.patch
mm-damon-sysfs-add-minmax-files-under-probe-filter-directory.patch
mm-damon-sysfs-support-hugepage_size-probe-filter.patch
docs-mm-damon-design-update-for-hugepage_size-probe-filter.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch
docs-abi-damon-update-for-hugepage_size-probe-filter.patch
mm-damon-api-remove-nr_damos_filter_types.patch
mm-damon-core-use-abs_diff-in-damon_feed_loop_next_input.patch
mm-damon-core-use-mult_frac-in-damon_feed_loop_next_input.patch
mm-damon-core-set-damon_ctx-walk_control_obsolete-in-damon_new_ctx.patch
mm-damon-core-document-damon_call-damon_start-race-hang-issue.patch
mm-damon-paddr-remove-pa-parameter-from-damon_pa_filter_pass.patch
mm-damon-tests-core-kunit-test-eligible_mem_bp-commitment.patch
mm-damon-tests-core-kunit-add-probe_hits_wsum-damos-filter-commit-test.patch
selftests-damon-sysfs_memcg_path_leak-fail-only-for-real-damon-leak.patch
docs-mm-damon-design-clarify-bp-is-basis-point.patch
mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

