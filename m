Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421DF30D41D;
	Wed, 29 Jul 2026 04:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298518; cv=none; b=bdokIoZL3erPCMCFNY1RG9k/dq6qJVO9FpoT6cZf3w0ul9kEiHSdCbdjkYWsHTgDdlO+eyxFC5eEZ+7ufMkcacuvSm015bXddmb0ICmmZBKIpeQtVkkwllMEr6/qQaMPfMIznXjgMblK25Xp86DsDGyJRKyQ893rLvPxxLFNPLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298518; c=relaxed/simple;
	bh=cXaMpqb/PpsdDXrfKIaPIg2zZ+nYgWDoDeECDgx2BqQ=;
	h=Date:To:From:Subject:Message-Id; b=imtvUPgrB5t7Dt/KNkHmAZ0SgeCn0dYcfaC5v/bms74ymzpX2xWpnQdHatdepoqQwvyLciPkiphyYLeRLVPFlTWZXQSJWY3TkjPDEVb98K9lJJ/n2VTv78+xH063Dg96AdZHt2gVxpeL551JiELBn7F8HVZVnFfVIvkHXfuqZfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t+itcU+q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t+itcU+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154E21F000E9;
	Wed, 29 Jul 2026 04:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298514;
	bh=t6wxgisNNHAskks76xOX7Los/ry5afU4xQb+ksR9Cig=;
	h=Date:To:From:Subject;
	b=t+itcU+qnB5P+mdVX+wnftY1KK0ZV4YStkSVkPDfp7sRSB4kGVexB6hQURPutAZej
	 Qw7qGZuiOZfPJ7PqpZy66L51eG45WCgca6Q0P051e9d1CSzh7mUf7IOXi0Dc57FKWm
	 NQbxmnyeUFiyk56vUoGTQbQywEZqmnb6uUtddEaI=
Date: Tue, 28 Jul 2026 21:15:13 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch removed from -mm tree
Message-Id: <20260729041514.154E21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: samples/damon/wsse: stop and free damon ctx when damon_call() fails
has been removed from the -mm tree.  Its filename was
     samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: samples/damon/wsse: stop and free damon ctx when damon_call() fails
Date: Sun, 28 Jun 2026 14:54:44 -0700

damon_sample_wsse_start() calls damon_call() right after damon_start() is
succeeded.  The kdamond that has started by the damon_start() could be
terminated by itself before or in the middle of the damon_call()
execution.  There could be multiple reasons for such a stop including
monitoring target process termination and kdamond_fn() internal memory
allocation failures.  In the case, damon_call() will fail and return an
error without cleaning up the DAMON context object.  The
damon_sample_wsse_start() caller assumes it would clean up the object,
though.  When the user requests to start DAMON again,
damon_sample_wsse_start() is called again, allocates a new DAMON context
object and overwrites the pointer for the previous object.  As a result,
the previous context object is leaked.

Safely stop the kdamond and deallocate the context object when the failure
is returned.  Note that the kdamond should be stopped first, because
damon_call() failure means not complete termination of the kdamond but
only the fact that the termination process has started.

The user impact shouldn't be that significant because the race is not easy
to happen, and only up to one DAMON context object can be leaked per race.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260628215447.96166-6-sj@kernel.org
Link: https://lore.kernel.org/20260610034828.4632-1-sj@kernel.org [1]
Fixes: cc9c1b8c205b ("samples/damon/wsse: use damon_call() repeat mode instead of damon_callback")
Signed-off-by: SJ Park <sj@kernel.org>
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/samples/damon/wsse.c~samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails
+++ a/samples/damon/wsse.c
@@ -92,7 +92,12 @@ static int damon_sample_wsse_start(void)
 		return err;
 	}
 	repeat_call_control.data = ctx;
-	return damon_call(ctx, &repeat_call_control);
+	err = damon_call(ctx, &repeat_call_control);
+	if (err) {
+		damon_stop(&ctx, 1);
+		damon_destroy_ctx(ctx);
+	}
+	return err;
 }
 
 static void damon_sample_wsse_stop(void)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
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
mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score.patch
mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions.patch

