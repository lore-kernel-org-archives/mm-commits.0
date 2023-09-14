Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D46EEAA65
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 19:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjINTHH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 15:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjINTHG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 15:07:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98CC1FD5
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 12:07:02 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3414BC433C7;
        Thu, 14 Sep 2023 19:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694718422;
        bh=fulb4XL6//o7EQ/NphV5pkW3980dnBv8Ocy6VwwmWsc=;
        h=Date:To:From:Subject:From;
        b=kLUE7jbyj/YQtZUCgmJPXvz0RIeHdUenvmlVDhas1ksGa6IPflS9EiG8oxzxKvifH
         NGqgNKyHLDi7PmnAsFSA6gtMCsXBsxSwOwL9qs6zZliWMiDr3jr8UqSwb8axUDRM49
         TuI7m9az475+JQ9zL9T6kcho2r5JKsOHRNj8A4ls=
Date:   Thu, 14 Sep 2023 12:07:01 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-use-number-of-passed-access-sampling-as-a-timer.patch added to mm-unstable branch
Message-Id: <20230914190702.3414BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: use number of passed access sampling as a timer
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-use-number-of-passed-access-sampling-as-a-timer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-use-number-of-passed-access-sampling-as-a-timer.patch

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
Subject: mm/damon/core: use number of passed access sampling as a timer
Date: Thu, 14 Sep 2023 02:15:23 +0000

DAMON sleeps for sampling interval after each sampling, and check if the
aggregation interval and the ops update interval have passed using
ktime_get_coarse_ts64() and baseline timestamps for the intervals.  That
design is for making the operations occur at deterministic timing
regardless of the time that spend for each work.  However, it turned out
it is not that useful, and incur not-that-intuitive results.

After all, timer functions, and especially sleep functions that DAMON uses
to wait for specific timing, are not necessarily strictly accurate.  It is
legal design, so no problem.  However, depending on such inaccuracies, the
nr_accesses can be larger than aggregation interval divided by sampling
interval.  For example, with the default setting (5 ms sampling interval
and 100 ms aggregation interval) we frequently show regions having
nr_accesses larger than 20.  Also, if the execution of a DAMOS scheme
takes a long time, next aggregation could happen before enough number of
samples are collected.  This is not what usual users would intuitively
expect.

Since access check sampling is the smallest unit work of DAMON, using the
number of passed sampling intervals as the DAMON-internal timer can easily
avoid these problems.  That is, convert aggregation and ops update
intervals to numbers of sampling intervals that need to be passed before
those operations be executed, count the number of passed sampling
intervals, and invoke the operations as soon as the specific amount of
sampling intervals passed.  Make the change.

Note that this could make a behavioral change to settings that using
intervals that not aligned by the sampling interval.  For example, if the
sampling interval is 5 ms and the aggregation interval is 12 ms, DAMON
effectively uses 15 ms as its aggregation interval, because it checks
whether the aggregation interval after sleeping the sampling interval. 
This change will make DAMON to effectively use 10 ms as aggregation
interval, since it uses 'aggregation interval / sampling interval *
sampling interval' as the effective aggregation interval, and we don't use
floating point types.  Usual users would have used aligned intervals, so
this behavioral change is not expected to make any meaningful impact, so
just make this change.

Link: https://lkml.kernel.org/r/20230914021523.60649-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   14 +++++
 mm/damon/core.c       |   96 +++++++++++++++++++---------------------
 2 files changed, 59 insertions(+), 51 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-use-number-of-passed-access-sampling-as-a-timer
+++ a/include/linux/damon.h
@@ -524,8 +524,18 @@ struct damon_ctx {
 	struct damon_attrs attrs;
 
 /* private: internal use only */
-	struct timespec64 last_aggregation;
-	struct timespec64 last_ops_update;
+	/* number of sample intervals that passed since this context started */
+	unsigned long passed_sample_intervals;
+	/*
+	 * number of sample intervals that should be passed before next
+	 * aggregation
+	 */
+	unsigned long next_aggregation_sis;
+	/*
+	 * number of sample intervals that should be passed before next ops
+	 * update
+	 */
+	unsigned long next_ops_update_sis;
 
 /* public: */
 	struct task_struct *kdamond;
--- a/mm/damon/core.c~mm-damon-core-use-number-of-passed-access-sampling-as-a-timer
+++ a/mm/damon/core.c
@@ -427,8 +427,10 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.aggr_interval = 100 * 1000;
 	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
 
-	ktime_get_coarse_ts64(&ctx->last_aggregation);
-	ctx->last_ops_update = ctx->last_aggregation;
+	ctx->passed_sample_intervals = 0;
+	/* These will be set from kdamond_init_intervals_sis() */
+	ctx->next_aggregation_sis = 0;
+	ctx->next_ops_update_sis = 0;
 
 	mutex_init(&ctx->kdamond_lock);
 
@@ -552,6 +554,9 @@ static void damon_update_monitoring_resu
  */
 int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs)
 {
+	unsigned long sample_interval = attrs->sample_interval ?
+		attrs->sample_interval : 1;
+
 	if (attrs->min_nr_regions < 3)
 		return -EINVAL;
 	if (attrs->min_nr_regions > attrs->max_nr_regions)
@@ -559,6 +564,11 @@ int damon_set_attrs(struct damon_ctx *ct
 	if (attrs->sample_interval > attrs->aggr_interval)
 		return -EINVAL;
 
+	ctx->next_aggregation_sis = ctx->passed_sample_intervals +
+		attrs->aggr_interval / sample_interval;
+	ctx->next_ops_update_sis = ctx->passed_sample_intervals +
+		attrs->ops_update_interval / sample_interval;
+
 	damon_update_monitoring_results(ctx, attrs);
 	ctx->attrs = *attrs;
 	return 0;
@@ -733,38 +743,6 @@ int damon_stop(struct damon_ctx **ctxs,
 }
 
 /*
- * damon_check_reset_time_interval() - Check if a time interval is elapsed.
- * @baseline:	the time to check whether the interval has elapsed since
- * @interval:	the time interval (microseconds)
- *
- * See whether the given time interval has passed since the given baseline
- * time.  If so, it also updates the baseline to current time for next check.
- *
- * Return:	true if the time interval has passed, or false otherwise.
- */
-static bool damon_check_reset_time_interval(struct timespec64 *baseline,
-		unsigned long interval)
-{
-	struct timespec64 now;
-
-	ktime_get_coarse_ts64(&now);
-	if ((timespec64_to_ns(&now) - timespec64_to_ns(baseline)) <
-			interval * 1000)
-		return false;
-	*baseline = now;
-	return true;
-}
-
-/*
- * Check whether it is time to flush the aggregated information
- */
-static bool kdamond_aggregate_interval_passed(struct damon_ctx *ctx)
-{
-	return damon_check_reset_time_interval(&ctx->last_aggregation,
-			ctx->attrs.aggr_interval);
-}
-
-/*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
 static void kdamond_reset_aggregated(struct damon_ctx *c)
@@ -1275,18 +1253,6 @@ static void kdamond_split_regions(struct
 }
 
 /*
- * Check whether it is time to check and apply the operations-related data
- * structures.
- *
- * Returns true if it is.
- */
-static bool kdamond_need_update_operations(struct damon_ctx *ctx)
-{
-	return damon_check_reset_time_interval(&ctx->last_ops_update,
-			ctx->attrs.ops_update_interval);
-}
-
-/*
  * Check whether current monitoring should be stopped
  *
  * The monitoring is stopped when either the user requested to stop, or all
@@ -1397,6 +1363,17 @@ static int kdamond_wait_activation(struc
 	return -EBUSY;
 }
 
+static void kdamond_init_intervals_sis(struct damon_ctx *ctx)
+{
+	unsigned long sample_interval = ctx->attrs.sample_interval ?
+		ctx->attrs.sample_interval : 1;
+
+	ctx->passed_sample_intervals = 0;
+	ctx->next_aggregation_sis = ctx->attrs.aggr_interval / sample_interval;
+	ctx->next_ops_update_sis = ctx->attrs.ops_update_interval /
+		sample_interval;
+}
+
 /*
  * The monitoring daemon that runs as a kernel thread
  */
@@ -1410,6 +1387,8 @@ static int kdamond_fn(void *data)
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
 
+	kdamond_init_intervals_sis(ctx);
+
 	if (ctx->ops.init)
 		ctx->ops.init(ctx);
 	if (ctx->callback.before_start && ctx->callback.before_start(ctx))
@@ -1418,6 +1397,17 @@ static int kdamond_fn(void *data)
 	sz_limit = damon_region_sz_limit(ctx);
 
 	while (!kdamond_need_stop(ctx)) {
+		/*
+		 * ctx->attrs and ctx->next_{aggregation,ops_update}_sis could
+		 * be changed from after_wmarks_check() or after_aggregation()
+		 * callbacks.  Read the values here, and use those for this
+		 * iteration.  That is, damon_set_attrs() updated new values
+		 * are respected from next iteration.
+		 */
+		unsigned long next_aggregation_sis = ctx->next_aggregation_sis;
+		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
+		unsigned long sample_interval = ctx->attrs.sample_interval;
+
 		if (kdamond_wait_activation(ctx))
 			break;
 
@@ -1427,12 +1417,17 @@ static int kdamond_fn(void *data)
 				ctx->callback.after_sampling(ctx))
 			break;
 
-		kdamond_usleep(ctx->attrs.sample_interval);
+		kdamond_usleep(sample_interval);
+		ctx->passed_sample_intervals++;
 
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
-		if (kdamond_aggregate_interval_passed(ctx)) {
+		sample_interval = ctx->attrs.sample_interval ?
+			ctx->attrs.sample_interval : 1;
+		if (ctx->passed_sample_intervals == next_aggregation_sis) {
+			ctx->next_aggregation_sis = next_aggregation_sis +
+				ctx->attrs.aggr_interval / sample_interval;
 			kdamond_merge_regions(ctx,
 					max_nr_accesses / 10,
 					sz_limit);
@@ -1447,7 +1442,10 @@ static int kdamond_fn(void *data)
 				ctx->ops.reset_aggregated(ctx);
 		}
 
-		if (kdamond_need_update_operations(ctx)) {
+		if (ctx->passed_sample_intervals == next_ops_update_sis) {
+			ctx->next_ops_update_sis = next_ops_update_sis +
+				ctx->attrs.ops_update_interval /
+				sample_interval;
 			if (ctx->ops.update)
 				ctx->ops.update(ctx);
 			sz_limit = damon_region_sz_limit(ctx);
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-fixup-missed-ref-keyword.patch
docs-admin-guide-mm-damon-usage-place-debugfs-usage-at-the-bottom.patch
docs-admin-guide-mm-damon-usage-move-debugfs-intro-to-the-bottom-of-the-section.patch
docs-mm-damon-design-explicitly-introduce-nr_accesses.patch
docs-admin-guide-mm-damon-usage-explain-the-format-of-damon_aggregate-tracepoint.patch
docs-mm-damon-design-add-a-section-for-kdamond-and-damon-context.patch
docs-admin-guide-mm-damon-usage-link-design-doc-for-details-of-kdamond-and-context.patch
mm-damon-core-fix-a-comment-about-damon_set_attrs-call-timings.patch
mm-damon-core-add-more-comments-for-nr_accesses.patch
mm-damon-core-remove-duplicated-comment-for-watermarks-based-deactivation.patch
mm-damon-core-remove-struct-target-parameter-from-damon_aggregated-tracepoint.patch
mm-damon-core-add-a-tracepoint-for-damos-apply-target-regions.patch
docs-admin-guide-mm-damon-usage-document-damos_before_apply-tracepoint.patch
mm-damon-core-use-number-of-passed-access-sampling-as-a-timer.patch

