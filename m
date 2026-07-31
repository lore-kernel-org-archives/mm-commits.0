Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132E633A717
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465834; cv=none; b=giNP3p8Dcik00mNFSKaONnAayZESwEq/ahPlzdAFnWtBhdg6GKa7m1dVgSOVTbFLJikVBFDmA52Ms8SIj1Gnj4pseXPFxDnObdyzGa+SndN1D2chzFRlDHjaUw1bz/QAhxaOQI4wHHpt9OzvVcs/Tf0FLUqdtwdD3TPY5Y4g8DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465834; c=relaxed/simple;
	bh=ldrFi/Dd6H9a2kVbQ1BPeb3bBRs01iJbXRmaAyjNSyY=;
	h=Date:To:From:Subject:Message-Id; b=c0zBpRN4q//5OcthFpeO0+qF16geMTVu/AJAYm1cguNls+g4ikzRm6kULSgEl5Z9LpEc8z9mk2C6ttxS9eAceoFs0d4yJWX3KAiXLjgMEgvsBWqwBehh9Lxzb5ScCwpcc28g3ZhSzuePhbBFZ6y+kp4Glifa/4MrWqujqQ80m/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RknvTOyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RknvTOyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05311F000E9;
	Fri, 31 Jul 2026 02:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465831;
	bh=pu2SezgdKFl7oAIzFcRdbWSldCb10xJ2nzVawXBQMqs=;
	h=Date:To:From:Subject;
	b=RknvTOypoNd+Q0xLTR5OF0NcfGDbVdI3AhIKI5tof/9MPqb0a41Pwg99+mHj4ti7+
	 ljLMLwm64GsitOabHQUomtjW0pPRUnv3sIjRwmaoJ32SrqZv0r7d7Ts3hvzMfN4ple
	 YRsPUQDjayBz5JKec4LtjWtwaKHnNdI10L6Ovbck=
Date: Thu, 30 Jul 2026 19:43:51 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-start-end-check-in-damon_set_region_system_rams.patch removed from -mm tree
Message-Id: <20260731024351.D05311F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove start, end check in damon_set_region_system_rams()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-start-end-check-in-damon_set_region_system_rams.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: remove start, end check in damon_set_region_system_rams()
Date: Sun, 5 Jul 2026 08:55:58 -0700

damon_set_region_system_rams() validates user inputs to avoid creating a
negative size region.  But DAMON core avoids zero size, too.  The check is
incomplete.  The complete check is done inside damon_set_regions(), which
is eventually called from damon_set_region_system_rams_default().  Drop
the incomplete and unnecessary check.

Link: https://lore.kernel.org/20260705155600.96555-8-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-start-end-check-in-damon_set_region_system_rams
+++ a/mm/damon/core.c
@@ -3846,9 +3846,6 @@ int damon_set_region_system_rams_default
 {
 	struct damon_addr_range addr_range;
 
-	if (*start > *end)
-		return -EINVAL;
-
 	if (!*start && !*end &&
 		!damon_find_system_rams_range(start, end, addr_unit))
 		return -EINVAL;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
mm-damon-core-stop-ctxs-in-damon_start-before-returning-an-error.patch
samples-damon-mtier-do-not-stop-first-context-for-damon_start-failure.patch
mm-damon-core-make-damon_stop-never-fails.patch
mm-damon-sysfs-ignore-damon_stop-return-value.patch
mm-damon-reclaaim-ignore-damon_stop-return-value.patch
mm-damon-lru_sort-ignore-damon_stop-return-value.patch
mm-damon-core-change-damon_stop-return-type-to-void.patch
samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call.patch
mm-damon-core-wait-ctx-stop-in-damon_call-before-reruning-an-error.patch
samples-damon-wsse-do-not-stop-ctx-for-damon_call-failure.patch
samples-damon-prcl-do-not-stop-damon-for-damon_call-failure.patch
mm-damon-core-remove-comment-and-test-for-nr_to_bp-divide-by-zero.patch
mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr.patch
mm-damon-core-s-accesses_bp_to_nr_accesses-sample_bp_to_count.patch
mm-damon-core-s-nr_accesses_to_accesses_bp-sample_count_to_bp.patch
mm-damon-core-s-nr_accesses_for_new_attrs-nr_samples_for_new_attrs.patch
mm-damon-core-update-probe-hits-for-new-parameter-commit.patch
mm-damon-core-handle-unreset-probe_hits-in-probe_hits_mvsum.patch
mm-damon-core-introduce-damon_probe-weight.patch
mm-damon-core-ask-apply_probes-ops-callback-to-set-sampling-address.patch
mm-damon-paddr-set-samples-in-apply_probes-if-requested.patch
mm-damon-core-ask-apply_probe-to-return-max-probe-hits-weighted-sum.patch
mm-damon-core-implement-damon_probe_hits_wsum.patch
mm-damon-paddr-respect-return_max_wsum.patch
mm-damon-core-use-abs_diff-instead-of-abs.patch
mm-damon-core-extend-merge-function-to-work-with-probe-hits.patch
mm-damon-core-disallow-probe_hits-overflow-on-attrs-only-monitoring.patch
mm-damon-core-validate-params-for-probe-hits-weighted-sum-overflow.patch
mm-damon-core-disable-access-monitoring-when-probe-weights-are-set.patch
mm-damon-core-set-samples-in-apply_probes-if-probe-weights-are-set.patch
mm-damon-core-s-max_nr_accesses-max_merge_score-in-kdamond_fn.patch
mm-damon-core-get-merge-threshold-from-probe-hits-when-weights-are-set.patch
mm-damon-core-implement-damon_has_probe_weight.patch
mm-damon-sysfs-implement-probe-weight-file.patch
docs-mm-damon-design-document-attrs-only-monitoring.patch
docs-admin-guide-mm-damon-usage-document-weight-sysfs-file.patch
docs-abi-damon-document-probe-weight-file.patch
mm-damon-core-skip-aging-from-repeated-aggressive-merging.patch
mm-damon-core-hide-private-damon_region-fields.patch
mm-damon-core-hide-private-damon_target-fields.patch
mm-damon-core-hide-private-damos_quota_goal-fields.patch
mm-damon-core-hide-private-damos_quota-fields.patch
mm-damon-core-hide-private-damos_filter-fields.patch
mm-damon-core-hide-private-damos-fields.patch
mm-damon-core-hide-private-damon_filter-fields.patch
mm-damon-core-hide-private-damon_probe-fields.patch
mm-damon-sysfs-do-not-directly-access-damon_ctx-ops.patch
mm-damon-core-hide-core-private-damon_ctx-fields.patch
mm-damon-core-avoid-infinite-kdamond_merge_regions-internal-loop.patch
mm-damon-tests-core-kunit-catch-test-failure-in-test_merge_regions_of.patch
mm-damon-vaddr-drop-last-same-folio-access-check-optimization.patch
mm-damon-paddr-drop-last-same-folio-access-check-reuse-optimization.patch
mm-damon-sysfs-read-addr_unit-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-sysfs-read-ops_id-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-core-initialize-damos-last_applied.patch
mm-damon-core-kunit-check-region-count-before-testing-in-split_at.patch
mm-damon-vaddr-kunit-check-region-count-in-three_regions-test.patch
mm-damon-core-kunit-handle-region-split-failure-in-filter_out.patch
mm-damon-core-kunit-skip-wrong-dest-walk-in-commit_dests_for.patch
mm-damon-core-kunit-skip-wrong-quota-goal-walk-in-commit_quota_goals.patch
mm-damon-core-kunit-skip-wrong-region-walk-in-commit_target_regions.patch
mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score.patch
mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions.patch

