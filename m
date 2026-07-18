Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B11E23536B;
	Sat, 18 Jul 2026 04:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784349292; cv=none; b=QS81bgeCeqRAHWb8vuG8LKGWI9otROSr8tHNl0e6DFwlcj5eN1iRd+AqXbG2oUw4t9JxTs+gpTo7aMLE+x/XqqWHupJi4+pfPPyzQxpQSuctU0xRdkN/i4xZ3tX6O9lpjYzPJQSYu+Twvs0QMOeGvVLf8uXK61yNQRGadzwKJDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784349292; c=relaxed/simple;
	bh=shTFCAS6FdUiZzgBip7qFyVL9/pi27UI+zRmUXtxOHw=;
	h=Date:To:From:Subject:Message-Id; b=Zk2+MIOkKktsTN+L4mcRaH76Pj67eqWB3h3C/H34ResqbmH1pE/GUlBWv5hRYuqziEIKodQKTHnuDX0Q/4BWN7xt3uh6s7OtuwcpsakgH29Frwn++VXF8/j4CYxsTqAwGOqMPv98zyQpTJ1WaUVB1x+kOudrxKqY8Nl+PLPf0H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tqi+cGIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tqi+cGIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45601F000E9;
	Sat, 18 Jul 2026 04:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784349289;
	bh=KLAEa36S2JTe6mwTmKN1dr0yr6OccKvtao+MeBCKTns=;
	h=Date:To:From:Subject;
	b=Tqi+cGILG16M1TDMmirch+OT8Z1lRR4wNSX5ts3N4NvWuhviUwMidNJD6YNmAFVs2
	 t+fOz1n4bHJatVRQYxGm9TirGTjyeA4cbVK3FvR66cFVEbWRrVhW6rG8qCYXTQ2PCK
	 3SbEATuMkSIwclUhdeoo9dS5uq7kLxeU2mlHJZ9c=
Date: Fri, 17 Jul 2026 21:34:49 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-initialize-damos-last_applied.patch added to mm-new branch
Message-Id: <20260718043449.B45601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: initialize damos->last_applied
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-initialize-damos-last_applied.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-initialize-damos-last_applied.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: initialize damos->last_applied
Date: Fri, 17 Jul 2026 17:14:35 -0700

Patch series "mm/damon: fix uninitialized DAMOS field and kunit exec
expectation bugs".

Fix a few Sashiko-found unurgent bugs.  Patch 1 fixes use of uninitialized
damos->last_applied field.  Patches 2-7 fix DAMON kunit tests that do
invalid memory access under test failures.

The bugs are better to be fixed and eventually merged into stable@ kernel.
That said, the fixes are arguably not urgent.  Patch 1 only introduces
negligible DAMOS efficiency degradation in occasional cases.  Kunit fixes
could introduce quite bad consequences but those are test code that affect
only test run setups.


This patch (of 7):

Multiple DAMON regions could exist across a folio.  If they fulfill the
condition to apply a DAMOS scheme, the scheme could be applied multiple
times to the folio.  To avoid this, each DAMOS scheme stores the folio
that the scheme was applied to last time in the damos->last_applied field
and skips repeatedly applying the same scheme to the same folio.

The field is being used without initialization, though.  Hence, the
mechanism could wrongly skip applying a scheme to a folio at the very
first time of DAMOS run.

The user impact is trivial.  DAMON might unexpectedly skip applying DAMOS
action for one folio for the first time per scheme.  In the DAMON's
best-effort world, this is never a real problem.  No critical consequences
such as kernel panic or memory corruption happen.

It is a clear bug, though, and the fix is straightforward.  Fix the issue
by initializing the field in DAMOS scheme creation function,
damon_new_scheme().

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260718001442.87129-1-sj@kernel.org
Link: https://lore.kernel.org/20260718001442.87129-2-sj@kernel.org
Link: https://lore.kernel.org/20260714055436.120034-1-sj@kernel.org [1]
Fixes: 94ba17adaba0 ("mm/damon: avoid applying DAMOS action to same entity multiple times")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-initialize-damos-last_applied
+++ a/mm/damon/core.c
@@ -705,6 +705,7 @@ struct damos *damon_new_scheme(struct da
 	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
 	scheme->max_nr_snapshots = 0;
+	scheme->last_applied = NULL;
 	INIT_LIST_HEAD(&scheme->list);
 
 	scheme->quota = *(damos_quota_init(quota));
_

Patches currently in -mm which might be from sj@kernel.org are

samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch
docs-mm-damon-design-update-for-damos_quota_node_eligible_mem_bp.patch
docs-abi-damon-document-probe-files.patch
mm-damon-tests-core-kunit-test-damon_rand.patch
selftests-damon-sysfssh-test-multiple-probe-dirs-creation.patch
selftests-damon-sysfssh-test-coreops_filters-directories.patch
selftests-damon-sysfssh-test-dests-dir.patch
selftests-damon-sysfssh-test-all-files-in-quota-goal-dir.patch
mm-damon-core-reduce-range-setup-in-damon_commit_target_regions.patch
mm-damon-sysfs-split-probe-setup-function-out.patch
mm-damon-sysfs-split-out-filters-setup-function.patch
mm-damon-sysfs-fix-typos-in-probe_addrm_dirs-s-attr-probe.patch
mm-damon-core-introduce-damon_nr_accesses_mvsum.patch
mm-damon-tests-core-kunit-test-damon_mvsum.patch
mm-damon-core-always-update-last_nr_accesses-for-intervals-change.patch
mm-damon-core-handle-unreset-nr_accesses-in-damon_nr_accesses_mvsum.patch
mm-damon-core-use-damon_nr_accesses_mvsum-in-__damos_valid_target.patch
mm-damon-core-use-damon_nr_accesses_mvsum-for-damos-region-tracing.patch
mm-damon-sysfs-schemes-use-damon_nr_accesses_mvsum-for-damo-regions.patch
mm-damon-core-remove-damon_warn_fix_nr_accesses_corruption.patch
mm-damon-core-remove-damon_verify_reset_aggregated.patch
mm-damon-core-remove-damon_verify_merge_regions_of.patch
mm-damon-tests-core-kunit-remove-nr_accesses_bp-setup-and-tests.patch
selftests-damon-drgn_dump_damon_status-do-not-dump-nr_accesses_bp.patch
mm-damon-core-remove-nr_accesses_bp-setups-and-updates.patch
mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate.patch
mm-damon-paddr-remove-attrs-param-from-__damon_pa_check_access.patch
mm-damon-vaddr-remove-attrs-param-from-__damon_va_check_access.patch
mm-damon-core-remove-damon_moving_sum-and-its-unit-test.patch
mm-damon-core-remove-damon_region-nr_accesses_bp.patch
mm-damon-add-damon_region-last_probe_hits.patch
mm-damon-core-introduce-damon_probe_hits_mvsum.patch
mm-damon-sysfs-schemes-set-probe-hits-as-pseudo-moving-sums.patch
mm-damon-core-safely-validate-src-on-damon_commit_ctx.patch
mm-damon-core-do-parameter-testing-commit-on-damon_start.patch
mm-damon-sysfs-remove-duplicated-commit-input-validity-check.patch
mm-damon-reclaim-remove-duplicated-min_region_sz-power-of-2-check.patch
mm-damon-lru_sort-remove-duplicated-min_region_sz-power_of_2-check.patch
mm-damon-document-region-size-validation-in-damon_set_regions.patch
mm-damon-core-remove-start-end-check-in-damon_set_region_system_rams.patch
mm-damon-sysfs-remove-region-size-validation.patch
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

