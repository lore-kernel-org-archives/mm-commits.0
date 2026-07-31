Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F85D335BB4
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465767; cv=none; b=ceYQdfCD8Y2coiOJOGXSJms7oidTfjsWwtt7r0gkS4FXwzO88ns47Jlky/Lfs0HZvMx1x5+MQJk6dqv+yV1iV3nxMRzj4cK3TMtJk8wPj9uJHwrVWgWgvFEnohmR5JyfTqzPSXcGA7A9xoBI9kdtEkKm9xmMCO2RF3Xpb+gBqG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465767; c=relaxed/simple;
	bh=sby988opIo3Gd5sE7E6o7UEnZts18WYHjX53TrSDo2k=;
	h=Date:To:From:Subject:Message-Id; b=kcX1C+lLCw9MY3d0tkifA2soP5UKptTqD1thiIC/hSIU7qHQc2HgLfMaN7772Pnk89s86uodzQZFBSejECHXx6C9HVP/4QVNTAoUUyOocKUWMNLvzasqGVumFl2GpzJz7EBKv60jM4RN1plldBU4Kcyd0/cT9wx0AJeEawTLmaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0eK/LdkJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0eK/LdkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB46A1F00A3A;
	Fri, 31 Jul 2026 02:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465766;
	bh=qhyWET8Mikkmi2fa3XAE3KhAhwYihPMWUPmqGEx1LPQ=;
	h=Date:To:From:Subject;
	b=0eK/LdkJswp0IYXQ6Wc2sr/jrCpDz/SUzDFIIosHfU4uyVG/zt8Vo+9NoM1ALI0/7
	 R6FCQSBeTXrZIcgA82V//Plan73aIyyd0hq7BUk8ntYhrytGdUvx0mO/Ek/yz+HItB
	 hsL4bk69DGrasNXTqWrnxUkZwY/6SbJBxTrD+cP8=
Date: Thu, 30 Jul 2026 19:42:45 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-damon_warn_fix_nr_accesses_corruption.patch removed from -mm tree
Message-Id: <20260731024245.EB46A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove damon_warn_fix_nr_accesses_corruption()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-damon_warn_fix_nr_accesses_corruption.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: remove damon_warn_fix_nr_accesses_corruption()
Date: Mon, 29 Jun 2026 21:08:01 -0700

nr_accesses_bp is delicate.  Once it is corrupted, the consequence is the
bad madness of DAMON monitoring results.  From developments of features of
size, we historically found nr_accesses_bp can be corrupted by complicated
bugs that are not easy to debug.  Hence we added a function for finding
the corruption and fixing it right away.

There are no more uses of nr_accesses_bp.  Hence the function for
corruption detection and fix is no more needed.  Rip it out.

Link: https://lore.kernel.org/20260630040812.149729-9-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   14 --------------
 1 file changed, 14 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-damon_warn_fix_nr_accesses_corruption
+++ a/mm/damon/core.c
@@ -2025,19 +2025,6 @@ int damos_walk(struct damon_ctx *ctx, st
 	return 0;
 }
 
-/*
- * Warn and fix corrupted ->nr_accesses[_bp] for investigations and preventing
- * the problem being propagated.
- */
-static void damon_warn_fix_nr_accesses_corruption(struct damon_region *r)
-{
-	if (r->nr_accesses_bp == r->nr_accesses * 10000)
-		return;
-	WARN_ONCE(true, "invalid nr_accesses_bp at reset: %u %u\n",
-			r->nr_accesses_bp, r->nr_accesses);
-	r->nr_accesses_bp = r->nr_accesses * 10000;
-}
-
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_reset_aggregated(struct damon_region *r,
 		struct damon_ctx *c)
@@ -2079,7 +2066,6 @@ static void kdamond_reset_aggregated(str
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			trace_damon_region_aggregated(ti, r,
 					damon_nr_regions(t), nr_probes);
-			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
 			for (i = 0; i < DAMON_MAX_PROBES; i++)
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

