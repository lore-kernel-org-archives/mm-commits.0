Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23A314D2B7
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976947; cv=none; b=PzWlIYQTtv8uWhpKflfvdEQPLnFHrGFqTcZSRJshq5BXFlouVND3Cxz/ZRLecU1IzfLs982QgXJH8/h/0Py5BXwT5jWV762PsfnM3xBw5tKZh9aW1ggxTNEytIr8VlJkro0byjIWXRK3wjCdV+wYpgxZgLh5TC5II6WUbred2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976947; c=relaxed/simple;
	bh=xSt53BE+8TvDLN8c40RQewK5eYfSGb0IdL9CpILGKvI=;
	h=Date:To:From:Subject:Message-Id; b=SX7wUivm8LGTJegfIZ6Z8RAPsbyM+VRA8sp38G++bJvYvm99loYchormRvmJfJfTnTTCQPNDwlx4VYLys9PZva7kzBlVfWunlxhfbundzq4md5rCsO1LkjNaWtu5n42njfucAtt6k3SX7AtduHSDo4lUxf9B9NsaEPY5lh2c8Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GjpqWysZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GjpqWysZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F46C4CEE3;
	Sun, 20 Jul 2025 02:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976946;
	bh=xSt53BE+8TvDLN8c40RQewK5eYfSGb0IdL9CpILGKvI=;
	h=Date:To:From:Subject:From;
	b=GjpqWysZ2oI529z2/uFG42XjPq45AbEYsUnWnrenY8gs8hjxXafoueANAeh29ci5N
	 8Y25rO45ttt9ni69RsywpWuDFW/nm7Imbu1j6l6NI9Qc5aRTzNMDzImn/qdWkty+5b
	 Bc4+Se2zfSnwLyUHdGk1HN+klphmPNcfrqjBiqr4=
Date: Sat, 19 Jul 2025 19:02:26 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-damon_callback.patch removed from -mm tree
Message-Id: <20250720020226.B4F46C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove damon_callback
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-damon_callback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: remove damon_callback
Date: Sat, 12 Jul 2025 12:50:16 -0700

All damon_callback usages are replicated by damon_call() and damos_walk().
Time to say goodbye.  Remove damon_callback.

Link: https://lkml.kernel.org/r/20250712195016.151108-15-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   31 +------------------------------
 mm/damon/core.c       |   26 +++++++-------------------
 2 files changed, 8 insertions(+), 49 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-remove-damon_callback
+++ a/include/linux/damon.h
@@ -629,34 +629,6 @@ struct damon_operations {
 	void (*cleanup)(struct damon_ctx *context);
 };
 
-/**
- * struct damon_callback - Monitoring events notification callbacks.
- *
- * @after_wmarks_check:	Called after each schemes' watermarks check.
- * @after_aggregation:	Called after each aggregation.
- * @before_terminate:	Called before terminating the monitoring.
- *
- * The monitoring thread (&damon_ctx.kdamond) calls @before_terminate just
- * before finishing the monitoring.
- *
- * The monitoring thread calls @after_wmarks_check after each DAMON-based
- * operation schemes' watermarks check.  If users need to make changes to the
- * attributes of the monitoring context while it's deactivated due to the
- * watermarks, this is the good place to do.
- *
- * The monitoring thread calls @after_aggregation for each of the aggregation
- * intervals.  Therefore, users can safely access the monitoring results
- * without additional protection.  For the reason, users are recommended to use
- * these callback for the accesses to the results.
- *
- * If any callback returns non-zero, monitoring stops.
- */
-struct damon_callback {
-	int (*after_wmarks_check)(struct damon_ctx *context);
-	int (*after_aggregation)(struct damon_ctx *context);
-	void (*before_terminate)(struct damon_ctx *context);
-};
-
 /*
  * struct damon_call_control - Control damon_call().
  *
@@ -727,7 +699,7 @@ struct damon_intervals_goal {
  * ``mmap()`` calls from the application, in case of virtual memory monitoring)
  * and applies the changes for each @ops_update_interval.  All time intervals
  * are in micro-seconds.  Please refer to &struct damon_operations and &struct
- * damon_callback for more detail.
+ * damon_call_control for more detail.
  */
 struct damon_attrs {
 	unsigned long sample_interval;
@@ -816,7 +788,6 @@ struct damon_ctx {
 	struct mutex kdamond_lock;
 
 	struct damon_operations ops;
-	struct damon_callback callback;
 
 	struct list_head adaptive_targets;
 	struct list_head schemes;
--- a/mm/damon/core.c~mm-damon-core-remove-damon_callback
+++ a/mm/damon/core.c
@@ -680,9 +680,7 @@ static bool damon_valid_intervals_goal(s
  * @attrs:		monitoring attributes
  *
  * This function should be called while the kdamond is not running, an access
- * check results aggregation is not ongoing (e.g., from &struct
- * damon_callback->after_aggregation or &struct
- * damon_callback->after_wmarks_check callbacks), or from damon_call().
+ * check results aggregation is not ongoing (e.g., from damon_call().
  *
  * Every time interval is in micro-seconds.
  *
@@ -778,7 +776,7 @@ static void damos_commit_quota_goal(
  * DAMON contexts, instead of manual in-place updates.
  *
  * This function should be called from parameters-update safe context, like
- * DAMON callbacks.
+ * damon_call().
  */
 int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src)
 {
@@ -1177,7 +1175,7 @@ static int damon_commit_targets(
  * in-place updates.
  *
  * This function should be called from parameters-update safe context, like
- * DAMON callbacks.
+ * damon_call().
  */
 int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 {
@@ -2484,9 +2482,6 @@ static int kdamond_wait_activation(struc
 
 		kdamond_usleep(min_wait_time);
 
-		if (ctx->callback.after_wmarks_check &&
-				ctx->callback.after_wmarks_check(ctx))
-			break;
 		kdamond_call(ctx, false);
 		damos_walk_cancel(ctx);
 	}
@@ -2543,10 +2538,9 @@ static int kdamond_fn(void *data)
 	while (!kdamond_need_stop(ctx)) {
 		/*
 		 * ctx->attrs and ctx->next_{aggregation,ops_update}_sis could
-		 * be changed from after_wmarks_check() or after_aggregation()
-		 * callbacks.  Read the values here, and use those for this
-		 * iteration.  That is, damon_set_attrs() updated new values
-		 * are respected from next iteration.
+		 * be changed from kdamond_call().  Read the values here, and
+		 * use those for this iteration.  That is, damon_set_attrs()
+		 * updated new values are respected from next iteration.
 		 */
 		unsigned long next_aggregation_sis = ctx->next_aggregation_sis;
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
@@ -2564,14 +2558,10 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
-		if (ctx->passed_sample_intervals >= next_aggregation_sis) {
+		if (ctx->passed_sample_intervals >= next_aggregation_sis)
 			kdamond_merge_regions(ctx,
 					max_nr_accesses / 10,
 					sz_limit);
-			if (ctx->callback.after_aggregation &&
-					ctx->callback.after_aggregation(ctx))
-				break;
-		}
 
 		/*
 		 * do kdamond_call() and kdamond_apply_schemes() after
@@ -2637,8 +2627,6 @@ done:
 			damon_destroy_region(r, t);
 	}
 
-	if (ctx->callback.before_terminate)
-		ctx->callback.before_terminate(ctx);
 	if (ctx->ops.cleanup)
 		ctx->ops.cleanup(ctx);
 	kfree(ctx->regions_score_histogram);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

