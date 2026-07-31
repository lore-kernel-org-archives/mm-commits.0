Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF06E335BB4
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465765; cv=none; b=dGpf39qtdx+oa+cnX9LBWdQRwKOOB+6U8QofZR7uqwcZbvGH5pW74xO50eAwGB+kiKRxSQkZ64lwQchRQfke5lfJV1ZY6lMLJzpEYUOIJG+TBK12rb4LNGwyDFP0xHPKNMhcVkrTmqJlXGU2tqrMNpZX1QP63/FI8ENW1rAytCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465765; c=relaxed/simple;
	bh=6YieEryPFxh+qHcw+I92sMowaoS1t6y0NoJWw0UGHuw=;
	h=Date:To:From:Subject:Message-Id; b=iN9fMmND2iAjWwuI48ANbD1Zyfqon+CKGFrvsljxA2LyjTHuHLBgmVs4YQajpYtRU1R2Vxf1xsPnmEVb28ko2c4qcTkbmFZ1GJKXsbAKP+DisHUzLazG+teiHsu7an6xv51J272nLVjsMwl93/T6GGx6axJ24/KTMCCN2AqJGKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k9D4CRcn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k9D4CRcn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0FB1F00A3A;
	Fri, 31 Jul 2026 02:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465763;
	bh=zIQ6KmPOl7zrybp1zdjGN1sjpino6NPvaGL0qGWestA=;
	h=Date:To:From:Subject;
	b=k9D4CRcnsAIgilawkhdCie3FnPKTM6gQF7XQN+EpTyYXJLveV1aDp3Wx7G+C/XGbJ
	 C4Os/FIRpGMJXYyiaVydTY+v4GSgk7r9DsZKuR5xLnaJdB7J7YGrWPY53iVwwPMaOs
	 vFKQroMXjwVBl9mjLsfIZn8eJYTX4oZNH+OHx1MA=
Date: Thu, 30 Jul 2026 19:42:43 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-damon_nr_accesses_mvsum-for-damos-region-tracing.patch removed from -mm tree
Message-Id: <20260731024243.AE0FB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: use damon_nr_accesses_mvsum() for damos region tracing
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-damon_nr_accesses_mvsum-for-damos-region-tracing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: use damon_nr_accesses_mvsum() for damos region tracing
Date: Mon, 29 Jun 2026 21:07:59 -0700

damon_nr_accesses_mvsum() returns a value same to nr_accesses_bp.  Also
the function is more simple and therefore more tolerant to errors. 
Execution of the function would be more expensive than the simple read of
the field, but because the function is quite simple, the overhead should
be negligible.  Use it in the DAMON region exporting trace points instead
of the nr_accesses_bp.

Link: https://lore.kernel.org/20260630040812.149729-7-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |    8 +++++---
 mm/damon/core.c              |    5 +++--
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/include/trace/events/damon.h~mm-damon-core-use-damon_nr_accesses_mvsum-for-damos-region-tracing
+++ a/include/trace/events/damon.h
@@ -78,9 +78,11 @@ TRACE_EVENT_CONDITION(damos_before_apply
 
 	TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
 		unsigned int target_idx, struct damon_region *r,
-		unsigned int nr_regions, bool do_trace),
+		unsigned int nr_accesses, unsigned int nr_regions,
+		bool do_trace),
 
-	TP_ARGS(context_idx, scheme_idx, target_idx, r, nr_regions, do_trace),
+	TP_ARGS(context_idx, scheme_idx, target_idx, r, nr_accesses,
+		nr_regions, do_trace),
 
 	TP_CONDITION(do_trace),
 
@@ -101,7 +103,7 @@ TRACE_EVENT_CONDITION(damos_before_apply
 		__entry->target_idx = target_idx;
 		__entry->start = r->ar.start;
 		__entry->end = r->ar.end;
-		__entry->nr_accesses = r->nr_accesses_bp / 10000;
+		__entry->nr_accesses = nr_accesses;
 		__entry->age = r->age;
 		__entry->nr_regions = nr_regions;
 	),
--- a/mm/damon/core.c~mm-damon-core-use-damon_nr_accesses_mvsum-for-damos-region-tracing
+++ a/mm/damon/core.c
@@ -2465,7 +2465,7 @@ static void damos_apply_scheme(struct da
 	struct damos *siter;		/* schemes iterator */
 	unsigned int sidx = 0;
 	struct damon_target *titer;	/* targets iterator */
-	unsigned int tidx = 0;
+	unsigned int tidx = 0, nr_accesses = 0;
 	bool do_trace = false;
 
 	/* get indices for trace_damos_before_apply() */
@@ -2480,6 +2480,7 @@ static void damos_apply_scheme(struct da
 				break;
 			tidx++;
 		}
+		nr_accesses = damon_nr_accesses_mvsum(r, c);
 		do_trace = true;
 	}
 
@@ -2495,7 +2496,7 @@ static void damos_apply_scheme(struct da
 		if (damos_core_filter_out(c, t, r, s))
 			return;
 		ktime_get_coarse_ts64(&begin);
-		trace_damos_before_apply(cidx, sidx, tidx, r,
+		trace_damos_before_apply(cidx, sidx, tidx, r, nr_accesses,
 				damon_nr_regions(t), do_trace);
 		sz_applied = c->ops.apply_scheme(c, t, r, s,
 				&sz_ops_filter_passed);
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

