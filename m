Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AB4336892
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465760; cv=none; b=Si+0ebuKtuH9sV8bnYRnem80+VyXky8KVcHkHHPQaoZNIw3YY28YzQRatoSFW4JIXoEjZfDNlWDapEu61a+5yoOOVchOQWZoO2Tv3gipoe1qUDzNvVBJ7e9QNWUTXFWbK84zgomRCxVCZeMs/7b7Bl3htB6YmCndn0kcZtn97rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465760; c=relaxed/simple;
	bh=kMNagwRXvqFVeaCb3MLjfXvcmHJSsd6ILBeJMdoU2xc=;
	h=Date:To:From:Subject:Message-Id; b=r5/MFSSWU2oI9NqLGoB9v4nTpAekv0BGN7UiFzvmjgM4CW4wYYT8Ug2mXiX0gdItqdyL6pM5G1mAlcC2stWTYliD3TwmeKR2skLYJItcT4Qe6d9ZMn7yjdJWB6eScq5S/SrysbfSO4XKI1uXxSteTvHaZnbJnw3nfiYzER7qM6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mR4mOlCH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mR4mOlCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8D91F00A3A;
	Fri, 31 Jul 2026 02:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465758;
	bh=SPrxAWWAPcDzjxHtfu5unAtRxFCE7PK5/y7OhrstGZY=;
	h=Date:To:From:Subject;
	b=mR4mOlCHdvE4tJ33ihxRh1CqhLWo0WmVrXB2SuBU3AN2PR6fv+UQI5vPjKZ++Kv3n
	 4FDNjj9EmnRTwxqhZC78eAF5R3DYwoQRz0oRez2TCvMPPBTcv/h0TaXBKTbuJV3g4Q
	 JNxZmYByzEDtaJ7ghEDG4+GAR9LX/TDzXOaTBiMg=
Date: Thu, 30 Jul 2026 19:42:37 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damon_nr_accesses_mvsum.patch removed from -mm tree
Message-Id: <20260731024237.EA8D91F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce damon_nr_accesses_mvsum()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damon_nr_accesses_mvsum.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: introduce damon_nr_accesses_mvsum()
Date: Mon, 29 Jun 2026 21:07:54 -0700

Patch series "mm/damon: optimize out nr_accesses_bp".

TLDR: Replace damon_region->nr_accesses_bp, which is easy to be wrong,
with a simpler on-demand moving sum function, damon_nr_accesses_mvsum().

Background
==========

DAMON's monitoring output (access pattern snapshot, or more technically
speaking, damon_region->nr_accesses) is completed once per aggregation
interval, which is 100 ms by default.  Users can arbitrarily increase the
interval for demand.  Under the suggested intervals auto-tuning setup, it
can span up to 200 seconds.  If the aggregation interval is too long, the
snapshot users cannot use it in reasonable time.  To mitigate this, we
introduced a new field of damon_region, namely nr_accesses_bp.  It
contains a pseudo moving sum of nr_accesses in bp units and is updated for
each sampling interval.

It turned out keeping it correctly updated every sampling interval is not
that easy.  From online parameter update feature development and more
experimental hacks, we found it is easy to be corrupted.  Once it is
corrupted, DAMON's monitoring outputs become quite insane.  Hence we added
a few validation checks.  It is easy to be corrupted because it requires
every update per sampling interval to be correct.

Solution
========

There is no real reason to keep it updated every sampling interval.  Due
to the simple pseudo-moving sum mechanism and existing helper field
(last_nr_accesses), we can also calculate the pseudo moving sum on demand
in a much simpler way.

Implement a function for getting the pseudo moving sum on demand, and
replace nr_accessses_bp uses with the new function.  Also remove no more
needed tests for nr_accesses_bp and the per-sampling interval update
functions.  Finally, remove the nr_accesses_bp.  The new function is quite
simple.

Discussion
==========

Depending on the use case, multiple nr_accesses readers could be executed
in the same kdamond_fn() main loop iteration, which is executed once per
sampling interval.  Such readers include DAMON region exporting
tracepoints (damon_[region_]aggregated and damos_before_apply), DAMOS, and
DAMON sysfs interface logic for update_schemes_tried_regions command.  In
this case, the new function will be called multiple times and this could
be overhead compared to the old logic, which simply reads the field
without any additional work.  Nonetheless, the new function is quite
simple.  And the new approach does nothing while there is no need to read.
The old approach had to execute its update function for each region for
every sampling interval.  Hence the new approach is believed to be even
more lightweight in common case, and the overhead is anyway negligible.

One more advantage of this change is that one field from the damon_region
struct is removed.  On setups that uses a high number of DAMON regions,
this could be a potential memory space benefit.

Patches Sequence
================

Patch 1 introduces the new function for getting the pseudo moving sum of
nr_accesses on demands.  Patch 2 implements a unit test for the new
function's internal logic.  Patch 3 and 4 update monitoring logic and the
new function to ready for safe use on the existing logic.  Patches 5-7
replace uses of nr_accesses_bp in DAMOS, tracepoints and DAMON sysfs
interface with the new function, respectively.  Patches 8-10 removes
nr_accesses_bp validation functions in DAMON core, one by one.  Patches 11
and 12 further remove tests and test helper for nr_accesses_bp,
respectively.  Patches 13 removes the setups and updates or nr_accesses_bp
field.  Patches 14-16 cleans up function parameters that are no more being
used due to the previous patch.  Patch 17 removes the function that was
used for updating nr_accesses_bp field with its unit test, which is the
single remaining caller of the function.  Finally, patch 18 removes
damon_region->nr_accesses_bp field.


This patch (of 18):

Introduce a new DAMON core function, damon_nr_accesses_mvsum().  It
returns a pseudo moving sum value of a given region's nr_accesses for the
last aggregation interval.  The internal logic is the same to
nr_accesses_bp.  The difference is that nr_accesses_bp is updated for each
sampling interval, while the new function needs to be executed only when
requested.  Hence the function's return value is the same as the value of
nr_accesses_bp.

Link: https://lore.kernel.org/20260630040812.149729-1-sj@kernel.org
Link: https://lore.kernel.org/20260630040812.149729-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +
 mm/damon/core.c       |   62 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_nr_accesses_mvsum
+++ a/include/linux/damon.h
@@ -1011,6 +1011,8 @@ struct damon_probe *damon_new_probe(void
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
+unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
+		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_nr_accesses_mvsum
+++ a/mm/damon/core.c
@@ -208,6 +208,68 @@ static struct damon_probe *damon_nth_pro
 	return NULL;
 }
 
+/*
+ * damon_mvsum() - Returns pseudo moving sum value for a time window.
+ * @current_nr:		The value of the current aggregation window.
+ * @last_nr:		The value of the last aggregation window.
+ * @left_window_bp:	Left time of the current aggregation window.
+ *
+ * This function calculates a pseudo moving sum value of a counter that is
+ * aggregated for each time window.  @current_nr is the value of the counter
+ * that aggregated so far (maybe not yet complete), from the beginning of the
+ * current aggregation time window.  @last_nr is the value of the counter that
+ * has completely aggregated in the last aggregation time window.
+ * @left_window_bp represents how much time is left for the current aggregation
+ * time window in bp (1/10,000).  For example, the aggregation time window is
+ * for every 10 seconds and 7 seconds has passed since the beginning of the
+ * current window, this parameter will be 3000 ((10 - 7) / 10 * 10000).
+ *
+ * The logic assumes the aggregation in the last phase was made in a single
+ * speed.  Based on the assumption, the value from the last window that needs
+ * to be added to the current value is calculated as a portion of the last
+ * value based on the remaining time window.
+ */
+static unsigned long damon_mvsum(unsigned long current_nr,
+		unsigned long last_nr, unsigned long left_window_bp)
+{
+	return current_nr + mult_frac(last_nr, left_window_bp, 10000);
+}
+
+/**
+ * damon_nr_accesses_mvsum() - Returns moving sum access frequency score.
+ * @r:		Region to get the access frequency of.
+ * @ctx:	DAMON context of @r.
+ *
+ * This function returns for how many sampling iterations in the last
+ * aggregation interval (&damon_attrs->aggr_interval) the region was found to
+ * be accessed.  Hence the value can be interpreted as the relative access
+ * frequency score of the region (@r).  The value is calculated as a pseudo
+ * moving sum, and hence it is not an exact value but just a best-effort
+ * reasonable estimation.
+ *
+ * Return: the pseudo moving sum access frequency score.
+ */
+unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
+		struct damon_ctx *ctx)
+{
+	unsigned long sample_interval, aggr_interval;
+	unsigned long window_len, left_window, left_window_bp;
+
+	sample_interval = ctx->attrs.sample_interval ? : 1;
+	aggr_interval = ctx->attrs.aggr_interval ? : 1;
+	window_len = aggr_interval / sample_interval;
+	if (time_after_eq(ctx->passed_sample_intervals,
+				ctx->next_aggregation_sis))
+		left_window = 0;
+	else
+		left_window = ctx->next_aggregation_sis -
+			ctx->passed_sample_intervals;
+	left_window_bp = mult_frac(left_window, 10000, window_len);
+
+	return damon_mvsum(r->nr_accesses, r->last_nr_accesses,
+			left_window_bp);
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
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

