Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF9E33556D
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465762; cv=none; b=EBIYGz9WRKNUrQpbbRwf05GByyXg9xNGa3xLSxN4sCTuv5t9dr7aTXezLhieGeTO3GBPkEXQWdQArWCseKJPFarZUTR961RZFhqvdd12IvTlh1VFTMehEnBBPTCHnr4n7EltDymGQhpJCmmhb5hEf18Pk7lAPIXG7niXb5rB80c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465762; c=relaxed/simple;
	bh=1WnEh/gl4H37sE0fJr2zNYbaDbNikHiROu3qNL6kT8A=;
	h=Date:To:From:Subject:Message-Id; b=N6KWcSTI7rb/4JOmoLtu97s1v3Ypqes/7dtuL7NYaHAX4wiMquw/1zYCafQbGcAsr/JPWXH7MpDc9xPmVJ4WltbXt1t8R72buty+WhxGuqYdwrr5CRNhZtRUm/U3IFG7wLGZprjuqT6G4aG2hk3yvVnH4EY9kO+i85v5UUZfA3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c8iHlaHA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c8iHlaHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4242A1F00A3A;
	Fri, 31 Jul 2026 02:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465760;
	bh=6UwuyJtvpTchDl6Vly9ZcYjgJ/0iW+2FaQ1gd7mgHA4=;
	h=Date:To:From:Subject;
	b=c8iHlaHAQBqeODVTgruMsckW0oXWR9yvDym4Z6uP4xVzidlOPoFLF97KjWdZ751Ae
	 87duWHnmrStjwrmBN0mmOylzKckIL6z0Y6ka5FY5ZbUmarZg9RJtbM5Kj25WG1WuJk
	 UEam7oZUJQzloLq3gz8MZiEq1DqCH8SMmX13GYu0=
Date: Thu, 30 Jul 2026 19:42:39 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-always-update-last_nr_accesses-for-intervals-change.patch removed from -mm tree
Message-Id: <20260731024240.4242A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: always update ->last_nr_accesses for intervals change
has been removed from the -mm tree.  Its filename was
     mm-damon-core-always-update-last_nr_accesses-for-intervals-change.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: always update ->last_nr_accesses for intervals change
Date: Mon, 29 Jun 2026 21:07:56 -0700

Each iteration of kdamond_fn() main loop caches and use the next
aggregation time (next_aggregation_sis) because it can be updated in the
middle, inside kdamond_call().  If that happens,
damon_update_monitoring_result() is called for scaling the access
frequency information of each region according to the changed intervals. 
The function does not update damon_region->last_nr_accesses when it is at
the end of the aggregation, because it will anyway be reset after the
function is executed, in kdamond_reset_aggregated().

Let's suppose damon_nr_accesses_mvsum() is called with the not yet updated
last_nr_accesses.  It will use the fresh next_aggregation_sis in the
context instead of the cached one, unlike kdamond_fn().  As a result, use
of not updated last_nr_acceses with the updated next_aggregation_sis
result in returning wrong value.

There is no such damon_nr_accesses_nvsum() call at the moment, so this is
no problem.  It is planned to add such calls, though.  Prevent the issue
by updating last_nr_accesses always.  This adds overhead, but that's fine
because the overhead is not big, and it is anyway not a fast path.

Link: https://lore.kernel.org/20260630040812.149729-4-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-always-update-last_nr_accesses-for-intervals-change
+++ a/mm/damon/core.c
@@ -884,6 +884,8 @@ static void damon_update_monitoring_resu
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
 		bool aggregating)
 {
+	r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
+			r->last_nr_accesses, old_attrs, new_attrs);
 	if (!aggregating) {
 		r->nr_accesses = damon_nr_accesses_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
@@ -895,8 +897,6 @@ static void damon_update_monitoring_resu
 		 * interval.  In other words, make the status like
 		 * kdamond_reset_aggregated() is called.
 		 */
-		r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
-				r->last_nr_accesses, old_attrs, new_attrs);
 		r->nr_accesses_bp = r->last_nr_accesses * 10000;
 		r->nr_accesses = 0;
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

