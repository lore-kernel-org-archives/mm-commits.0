Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7C042AB7;
	Mon,  3 Aug 2026 18:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785783285; cv=none; b=av0x1eA5mTFKabtZLJzbrqjxD0nIpTy43fPSPUQ9wuaiWHUwx7KWIkPBMM3KVbTKqF75+xqdheLcCAIKR2Mgx7o9nIrWJduw1X04kvWwhFyXgLP5/V9KU7snaMQuuphohVcrVSmDm4eBDXU6IqPIqXuNfp7RqumurluHc0a2FZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785783285; c=relaxed/simple;
	bh=ajcC3EguYpWR3TmAfqjhRHcCgbpeBJ3ey24hx6DbDog=;
	h=Date:To:From:Subject:Message-Id; b=h0jInauErynj57CXCTOwjg85iXeZNon4jQE9yk3GgtkMXBHV4pOrYjTvS8yfybMucxxz4Xzs1t8x5b1XpDi6K9Jl2rX9vxTCtLvmO4i7je7mKhodVbaEBkLxvzMuaWj5r9l8NTPGSEd1MDisyVnIBwx1EeRxXu61MlS6tcCQO/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NAjQ/dNb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NAjQ/dNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3F01F000E9;
	Mon,  3 Aug 2026 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785783283;
	bh=51bYj7AE4Sj3DswAIP6q+IvE/DHnM4Af0YH+mj9/avM=;
	h=Date:To:From:Subject;
	b=NAjQ/dNbtUwXifqL4/1JruJZFHAl6dp+Fsem8gPusSmU35wPHcmsU+ixC1FjtDHta
	 DW5e+BXwEdCD9Lu8/ZqvfzCYaM39QQbWCqMa9vaf8wMcO4xQ2EATRx/K6yTxl1NVE/
	 vFlSbMe+L7SVawEGNc8zGSdxY4QBoCixnDnFd6kE=
Date: Mon, 03 Aug 2026 11:54:42 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,aethernet65535@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch added to mm-hotfixes-unstable branch
Message-Id: <20260803185443.2D3F01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: skip damon_call() if ctx has not started
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/reclaim: skip damon_call() if ctx has not started
Date: Mon, 3 Aug 2026 06:46:44 -0700

Patch series "mm/damon/{reclaim,lru_sort}: fix commit_inputs infinite
hang".

Writing 'Y' to commit_inputs parameters of DAMON_RECLAIM and
DAMON_LRU_SORT before the modules were ever turned on causes infinite
hang.  Fix those.

The issue was discovered [1] by Sashiko.


This patch (of 2):

DAMON_RECLAIM calls damon_call() for commit_inputs parameter user input if
the DAMON context is initialized.  The context could be initialized, but
not yet successfully started.  In the case, damon_call() could
indefinitely hang.  Read the comment on damon_call() for more detail.  Fix
the problem by memorizing if the DAMON context has ever successfully
started, and skip damon_call() if it has not.

This issue can easily be reproduced by writing Y to commit_inputs on a
system that DAMON_RECLAIM was not turned on before.

Link: https://lore.kernel.org/20260803134646.16640-1-sj@kernel.org
Link: https://lore.kernel.org/20260803134646.16640-2-sj@kernel.org
Link: https://lore.kernel.org/20260802173021.762-1-sj@kernel.org [1]
Fixes: de3c60e1c831 ("mm/damon: add synchronous commit for commit_inputs")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: <stable@vger.kernel.org> # 7.2.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started
+++ a/mm/damon/reclaim.c
@@ -276,6 +276,8 @@ static int damon_reclaim_commit_inputs_f
 	return damon_reclaim_apply_parameters();
 }
 
+static bool damon_reclaim_damon_has_started;
+
 static int damon_reclaim_commit_inputs_store(const char *val,
 					     const struct kernel_param *kp)
 {
@@ -296,11 +298,8 @@ static int damon_reclaim_commit_inputs_s
 	if (!commit_inputs_request)
 		return 0;
 
-	/*
-	 * Skip damon_call() if ctx is not initialized to avoid
-	 * NULL pointer dereference.
-	 */
-	if (!ctx)
+	/* Skip damon_call() if ctx has not successfully started. */
+	if (!damon_reclaim_damon_has_started)
 		return -EINVAL;
 
 	err = damon_call(ctx, &control);
@@ -347,6 +346,8 @@ static int damon_reclaim_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
+	if (!damon_reclaim_damon_has_started)
+		damon_reclaim_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
mm-damon-reclaim-skip-damon_call-if-ctx-has-not-started.patch
mm-damon-lru_sort-skip-damon_call-if-ctx-has-not-started.patch
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

