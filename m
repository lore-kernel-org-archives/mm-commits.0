Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B662185BD
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188500; cv=none; b=NXAXqtAflokm96zl5bBQhlQmxoWvOBIgUDsrbyLkXKCDZ51Eh/k/ZkUIY6UvKvNaeR4L+eCeCQxpy7NhVQKS9PIdIU3ZaRNTzkCQIkU69/Tih/FT2OEIczzmRKgpx69a4rv1gn+pjFCRdffOV6DVTRu95avFl5AX7Yk4GHHTP18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188500; c=relaxed/simple;
	bh=m3tEkWRGyd0i1SY+0vtyXw+aGm1zLqOfG2KvP7xaaSI=;
	h=Date:To:From:Subject:Message-Id; b=LXpLVF5u2XVDJ2QKO0WI7l9mCuM4FyMxkMntXdzs3obEpNOtn55dFEj5g0RHs16ZNk9cDrJGK27gwxDUVEcvWpCVyhbXeej+qO0IRpM1LTZb3nxeySvmByOGO36teuk+vSAdl2zuyvRa+GpKVCWrk61iDPXfzDZx9CRs7KGasjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dpqqmhyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dpqqmhyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A269C4CEED;
	Mon, 17 Mar 2025 05:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188500;
	bh=m3tEkWRGyd0i1SY+0vtyXw+aGm1zLqOfG2KvP7xaaSI=;
	h=Date:To:From:Subject:From;
	b=dpqqmhyDJWg3ZS/XJkZAgmyXS33eN7yr16SzZJ9KfS3apqn9gFpa9TJD+4i5cqQq2
	 7QUnMjyPs074Kb1XSfH7PDELF9YadjQxX0nTqydUAwkBH06dGyhH9VuEI/daeLg5PU
	 Vqwc/C+2weq5a23+qvURsZ+cbCbHgLdXDvnYr2y8=
Date: Sun, 16 Mar 2025 22:14:59 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-implement-intervals-auto-tuning.patch removed from -mm tree
Message-Id: <20250317051500.5A269C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: implement intervals auto-tuning
has been removed from the -mm tree.  Its filename was
     mm-damon-core-implement-intervals-auto-tuning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: implement intervals auto-tuning
Date: Mon, 3 Mar 2025 14:17:20 -0800

Implement the DAMON sampling and aggregation intervals auto-tuning
mechanism as briefly described on 'struct damon_intervals_goal'.  The core
part for deciding the direction and amount of the changes is implemented
reusing the feedback loop function which is being used for DAMOS quotas
auto-tuning.  Unlike the DAMOS quotas auto-tuning use case, limit the
maximum decreasing amount after the adjustment to 50% of the current
value, though.  This is because the intervals have no good merits at rapid
reductions since it could unnecessarily increase the monitoring overhead.

Link: https://lkml.kernel.org/r/20250303221726.484227-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   16 ++++++++
 mm/damon/core.c       |   76 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 92 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-implement-intervals-auto-tuning
+++ a/include/linux/damon.h
@@ -713,6 +713,17 @@ struct damon_attrs {
 	struct damon_intervals_goal intervals_goal;
 	unsigned long min_nr_regions;
 	unsigned long max_nr_regions;
+/* private: internal use only */
+	/*
+	 * @aggr_interval to @sample_interval ratio.
+	 * Core-external components call damon_set_attrs() with &damon_attrs
+	 * that this field is unset.  In the case, damon_set_attrs() sets this
+	 * field of resulting &damon_attrs.  Core-internal components such as
+	 * kdamond_tune_intervals() calls damon_set_attrs() with &damon_attrs
+	 * that this field is set.  In the case, damon_set_attrs() just keep
+	 * it.
+	 */
+	unsigned long aggr_samples;
 };
 
 /**
@@ -761,6 +772,11 @@ struct damon_ctx {
 	 * update
 	 */
 	unsigned long next_ops_update_sis;
+	/*
+	 * number of sample intervals that should be passed before next
+	 * intervals tuning
+	 */
+	unsigned long next_intervals_tune_sis;
 	/* for waiting until the execution of the kdamond_fn is started */
 	struct completion kdamond_started;
 	/* for scheme quotas prioritization */
--- a/mm/damon/core.c~mm-damon-core-implement-intervals-auto-tuning
+++ a/mm/damon/core.c
@@ -664,6 +664,10 @@ int damon_set_attrs(struct damon_ctx *ct
 	if (attrs->sample_interval > attrs->aggr_interval)
 		return -EINVAL;
 
+	/* calls from core-external doesn't set this. */
+	if (!attrs->aggr_samples)
+		attrs->aggr_samples = attrs->aggr_interval / sample_interval;
+
 	ctx->next_aggregation_sis = ctx->passed_sample_intervals +
 		attrs->aggr_interval / sample_interval;
 	ctx->next_ops_update_sis = ctx->passed_sample_intervals +
@@ -1301,6 +1305,65 @@ static void kdamond_reset_aggregated(str
 	}
 }
 
+static unsigned long damon_get_intervals_score(struct damon_ctx *c)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long sz_region, max_access_events = 0, access_events = 0;
+	unsigned long target_access_events;
+	unsigned long goal_bp = c->attrs.intervals_goal.access_bp;
+
+	damon_for_each_target(t, c) {
+		damon_for_each_region(r, t) {
+			sz_region = damon_sz_region(r);
+			max_access_events += sz_region * c->attrs.aggr_samples;
+			access_events += sz_region * r->nr_accesses;
+		}
+	}
+	target_access_events = max_access_events * goal_bp / 10000;
+	return access_events * 10000 / target_access_events;
+}
+
+static unsigned long damon_feed_loop_next_input(unsigned long last_input,
+		unsigned long score);
+
+static unsigned long damon_get_intervals_adaptation_bp(struct damon_ctx *c)
+{
+	unsigned long score_bp, adaptation_bp;
+
+	score_bp = damon_get_intervals_score(c);
+	adaptation_bp = damon_feed_loop_next_input(100000000, score_bp) /
+		10000;
+	/*
+	 * adaptaion_bp ranges from 1 to 20,000.  Avoid too rapid reduction of
+	 * the intervals by rescaling [1,10,000] to [5000, 10,000].
+	 */
+	if (adaptation_bp <= 10000)
+		adaptation_bp = 5000 + adaptation_bp / 2;
+	return adaptation_bp;
+}
+
+static void kdamond_tune_intervals(struct damon_ctx *c)
+{
+	unsigned long adaptation_bp;
+	struct damon_attrs new_attrs;
+	struct damon_intervals_goal *goal;
+
+	adaptation_bp = damon_get_intervals_adaptation_bp(c);
+	if (adaptation_bp == 10000)
+		return;
+
+	new_attrs = c->attrs;
+	goal = &c->attrs.intervals_goal;
+	new_attrs.sample_interval = min(goal->max_sample_us,
+			c->attrs.sample_interval * adaptation_bp / 10000);
+	new_attrs.sample_interval = max(goal->min_sample_us,
+			new_attrs.sample_interval);
+	new_attrs.aggr_interval = new_attrs.sample_interval *
+		c->attrs.aggr_samples;
+	damon_set_attrs(c, &new_attrs);
+}
+
 static void damon_split_region_at(struct damon_target *t,
 				  struct damon_region *r, unsigned long sz_r);
 
@@ -2209,6 +2272,8 @@ static void kdamond_init_intervals_sis(s
 	ctx->next_aggregation_sis = ctx->attrs.aggr_interval / sample_interval;
 	ctx->next_ops_update_sis = ctx->attrs.ops_update_interval /
 		sample_interval;
+	ctx->next_intervals_tune_sis = ctx->next_aggregation_sis *
+		ctx->attrs.intervals_goal.aggrs;
 
 	damon_for_each_scheme(scheme, ctx) {
 		apply_interval = scheme->apply_interval_us ?
@@ -2293,6 +2358,17 @@ static int kdamond_fn(void *data)
 		sample_interval = ctx->attrs.sample_interval ?
 			ctx->attrs.sample_interval : 1;
 		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
+			if (ctx->attrs.intervals_goal.aggrs &&
+					ctx->passed_sample_intervals >=
+					ctx->next_intervals_tune_sis) {
+				ctx->next_intervals_tune_sis +=
+					ctx->attrs.aggr_samples *
+					ctx->attrs.intervals_goal.aggrs;
+				kdamond_tune_intervals(ctx);
+				sample_interval = ctx->attrs.sample_interval ?
+					ctx->attrs.sample_interval : 1;
+
+			}
 			ctx->next_aggregation_sis = next_aggregation_sis +
 				ctx->attrs.aggr_interval / sample_interval;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

