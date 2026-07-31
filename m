Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C117633AD8A
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465829; cv=none; b=cyIn2Hd/BfynUSgAH9ZKLeDwrMl64JYS+HAkX/D3xYiHANFIz+7cuZQWxmHqa2ca090khekn33W0IyWH7L5eh0ANJRmdLh32aZPxBTtXu4EUmH1+U3YpfeeLJqy+dBynQef3bTR+P9eU5S/nVfiABpZCOAiGSN3nXCMEN9nHgXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465829; c=relaxed/simple;
	bh=msdYVotVgLStUUgxnJoxdQBf9f18u/Dnk7BdwrDjMf0=;
	h=Date:To:From:Subject:Message-Id; b=kmTyenjummjKr6QHj0ZnCYnN7GjHZibr6Pfxw0VsB4ETxhM0g5YVb0KsJ2qBoiRqR4krXw9zXCzurp9VFm/93Tr0RV0VDrkmiOpQCy7VXDM+dK03ionSnCzEWqyz7y4jxrkgrpT6ABl01QhIB348xauk/gBRUEthb1ZqO3JmHTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YYLFBxBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YYLFBxBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FB71F00A3A;
	Fri, 31 Jul 2026 02:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465827;
	bh=/dDqb60DuBwMo9xiQRRFGJveEumaC7+v/8pigZ9eMD4=;
	h=Date:To:From:Subject;
	b=YYLFBxBCpJUxiJH9fsh3RUMv5jTcL4aQTzmQ2T5YSjkuRxepDRIgn1zY1b3q9PZAq
	 8R1TmNkYr0c+nO3GE6Cro1UGfegiBMf0W0hbXrAH5O42tx+1y0M1SsybBVRxpPzIhK
	 RvjPCgn+sypBro6yQxGH/eYe0sEzCPr3Ten5KAMk=
Date: Thu, 30 Jul 2026 19:43:47 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-remove-duplicated-commit-input-validity-check.patch removed from -mm tree
Message-Id: <20260731024347.96FB71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: remove duplicated commit input validity check
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-remove-duplicated-commit-input-validity-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: remove duplicated commit input validity check
Date: Sun, 5 Jul 2026 08:55:54 -0700

DAMON sysfs interface does parameters validation-purpose
damon_commit_ctx() calls for parameters update.  Now the same logic is
embedded inside damon_commit_ctx() itself.  Hence, the validation in DAMON
sysfs interface is just an unnecessary duplicate.  Remove it.

Link: https://lore.kernel.org/20260705155600.96555-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   32 +-------------------------------
 1 file changed, 1 insertion(+), 31 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-duplicated-commit-input-validity-check
+++ a/mm/damon/sysfs.c
@@ -2099,26 +2099,6 @@ static struct damon_ctx *damon_sysfs_bui
 		struct damon_sysfs_context *sys_ctx);
 
 /*
- * Return a new damon_ctx for testing new parameters to commit.
- */
-static struct damon_ctx *damon_sysfs_new_test_ctx(
-		struct damon_ctx *running_ctx)
-{
-	struct damon_ctx *test_ctx;
-	int err;
-
-	test_ctx = damon_new_ctx();
-	if (!test_ctx)
-		return NULL;
-	err = damon_commit_ctx(test_ctx, running_ctx);
-	if (err) {
-		damon_destroy_ctx(test_ctx);
-		return NULL;
-	}
-	return test_ctx;
-}
-
-/*
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
  * @kdamond:	The kobject wrapper for the associated kdamond.
  *
@@ -2127,7 +2107,7 @@ static struct damon_ctx *damon_sysfs_new
 static int damon_sysfs_commit_input(void *data)
 {
 	struct damon_sysfs_kdamond *kdamond = data;
-	struct damon_ctx *param_ctx, *test_ctx;
+	struct damon_ctx *param_ctx;
 	int err;
 
 	if (!damon_sysfs_kdamond_running(kdamond))
@@ -2139,17 +2119,7 @@ static int damon_sysfs_commit_input(void
 	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
-	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
-	if (!test_ctx) {
-		damon_destroy_ctx(param_ctx);
-		return -ENOMEM;
-	}
-	err = damon_commit_ctx(test_ctx, param_ctx);
-	if (err)
-		goto out;
 	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
-out:
-	damon_destroy_ctx(test_ctx);
 	damon_destroy_ctx(param_ctx);
 	return err;
 }
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

