Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D576F198A2F
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741041114; cv=none; b=kymb3nGox1jVwQuM57v3AqDev2BoBbBKhv63p+iQ0NKj/hlfS/EbsYrpYXsM9vA8/VVSBxjj0sn1hYhRTWdvhsDDZQTNFw/3CIQ7EyV/Gk/pYwvuE4DwRlBDh70SXDf+1JWj1NqD30mFcpOazIGN6R5bkpBBf2akS881HqWEPhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741041114; c=relaxed/simple;
	bh=S0KLg3IUlU8cZZpVs70EAJTpHEGp83Qzi0vit3UU5WI=;
	h=Date:To:From:Subject:Message-Id; b=lpcYZzl736yCuXpB0/3Gr7qUPkEnUsnjd3D6Gs5/dxDsZIAj3rYYBPjzPbVrvSCUMNjJuyxnPkJv348XRBGwc17X/fOED9lce1JjS1lyiNvIp0BTMypiD57HchOZaMhUTXQqHFq9qGAqov5jAXxi3kobuqQDFF8zHF+1812EGro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wLDozUmX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wLDozUmX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37689C4CED6;
	Mon,  3 Mar 2025 22:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741041114;
	bh=S0KLg3IUlU8cZZpVs70EAJTpHEGp83Qzi0vit3UU5WI=;
	h=Date:To:From:Subject:From;
	b=wLDozUmX9/E5s7ddhe0N7LsW7t+NJFcAVH/HoUMRdQb+WYuLn15nDBRtatOfRTehb
	 GnCNF0ydofi3kRaCoCwvL9xDOp3PzsEOz7ZFFLVY+e47qssRkYIMFKoYhf2G8f+2al
	 p9a0/8eXgkRztdGVdgtQRwgYsi38PDxzVywuV+Xk=
Date: Mon, 03 Mar 2025 14:31:53 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-implement-intervals-auto-tuning.patch added to mm-unstable branch
Message-Id: <20250303223154.37689C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: implement intervals auto-tuning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-implement-intervals-auto-tuning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-implement-intervals-auto-tuning.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -708,6 +708,17 @@ struct damon_attrs {
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
@@ -756,6 +767,11 @@ struct damon_ctx {
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
@@ -663,6 +663,10 @@ int damon_set_attrs(struct damon_ctx *ct
 	if (attrs->sample_interval > attrs->aggr_interval)
 		return -EINVAL;
 
+	/* calls from core-external doesn't set this. */
+	if (!attrs->aggr_samples)
+		attrs->aggr_samples = attrs->aggr_interval / sample_interval;
+
 	ctx->next_aggregation_sis = ctx->passed_sample_intervals +
 		attrs->aggr_interval / sample_interval;
 	ctx->next_ops_update_sis = ctx->passed_sample_intervals +
@@ -1300,6 +1304,65 @@ static void kdamond_reset_aggregated(str
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
 
@@ -2204,6 +2267,8 @@ static void kdamond_init_intervals_sis(s
 	ctx->next_aggregation_sis = ctx->attrs.aggr_interval / sample_interval;
 	ctx->next_ops_update_sis = ctx->attrs.ops_update_interval /
 		sample_interval;
+	ctx->next_intervals_tune_sis = ctx->next_aggregation_sis *
+		ctx->attrs.intervals_goal.aggrs;
 
 	damon_for_each_scheme(scheme, ctx) {
 		apply_interval = scheme->apply_interval_us ?
@@ -2288,6 +2353,17 @@ static int kdamond_fn(void *data)
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

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch
mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch
docs-mm-damon-design-document-unmapped-damos-filter-type.patch
mm-damon-add-data-structure-for-monitoring-intervals-auto-tuning.patch
mm-damon-core-implement-intervals-auto-tuning.patch
mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch
mm-damon-sysfs-commit-intervals-tuning-goal.patch
mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch
docs-mm-damon-design-document-for-intervals-auto-tuning.patch
docs-abi-damon-document-intervals-auto-tuning-abi.patch
docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch

