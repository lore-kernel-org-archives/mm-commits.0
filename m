Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FB6225771
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752358007; cv=none; b=Y19SQJnzuj4OCQxvTwLos5LkhMXE6y+5b5UiLPKsp7yi6h7WnI8PbHZ9EVz3h+U56lhWhy4fgQbqOWszbDF9VNy5TtScC8WNpOTd60M1qCjtIkl468yXFoGNgrn7fmCuCYYNK2p+KncOlXHehsF+6VFlrYxvgDl8FD+ORbXRMjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752358007; c=relaxed/simple;
	bh=W9mOcr4Gi9oqbyLgW5cWkzbmWEeXj6zN/owCmrISGo8=;
	h=Date:To:From:Subject:Message-Id; b=AX6l2aJ3pzmS/oc56kOyRSvXaxWUHB8WsN1anQDTI7n39EeJOr8Vt25gqMj6hBw7niXryz6Bror3PYCCDriM2lqCUfSgiz+pvWJIKVPvgO22bUygfRLYPH7sIC3uc2oMijg4hgdyT0rcd8/2AM7mgIkXZtorKuy9i17HPBar0GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SljRv3o2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SljRv3o2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B39CC4CEEF;
	Sat, 12 Jul 2025 22:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752358007;
	bh=W9mOcr4Gi9oqbyLgW5cWkzbmWEeXj6zN/owCmrISGo8=;
	h=Date:To:From:Subject:From;
	b=SljRv3o2R+RH+ZULShyaaSz1RASYYYn1Ed/NvTWKSeI9iUAzVS1wlBYM1zGNcEUUC
	 BnKkd3j/oG18GEcvD269iGUGBChICriHagsfeNTEMQPjpw/w+Jx7T0moeu93ArVfgW
	 fCM/Iq0Y58fhUjYA6fawN8OWb9Rz14FzDIhUggqg=
Date: Sat, 12 Jul 2025 15:06:46 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-damon_callback.patch added to mm-new branch
Message-Id: <20250712220647.1B39CC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: remove damon_callback
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-remove-damon_callback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-damon_callback.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
@@ -628,34 +628,6 @@ struct damon_operations {
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
@@ -726,7 +698,7 @@ struct damon_intervals_goal {
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

selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
mm-damon-add-trace-event-for-effective-size-quota-fix-2.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch

