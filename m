Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8A914600D
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735958722; cv=none; b=rTr+t/s7PE3gaRtGdaErRfFlMtgd4IjRm1hlYVA8Q632gOro3MKXGuIb3l6bz3alufSlx473HeMZiKS7Sn3jbw8aKkWqDqlAarbriOKSJ7Gw12P2SK0pm7XNQQVcd47Lv/Ykel+OW40MRn9XWPozNWOKVFeLZgGcsd4tEIcxlEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735958722; c=relaxed/simple;
	bh=Bpy55XzD/BmuPpFcThgMF4ZDPZS2cSF5fltvkT129LU=;
	h=Date:To:From:Subject:Message-Id; b=aGJOVncNlHPzR7W7x9n3TUoI6k6jytpoc6NW/k3ogpxf36eqlpVzxudymI095zkki5V4jinJI+YPU/xSxyZktkvAz6KXuRtzUJzhJ69m91fDpX1yDz6qJrDaqNqGq6N2pA49piRNK0GBkAIuh+zjNNvc31huVSfKwu8ShHX+CYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oM10fFU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oM10fFU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4E6C4CED6;
	Sat,  4 Jan 2025 02:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735958722;
	bh=Bpy55XzD/BmuPpFcThgMF4ZDPZS2cSF5fltvkT129LU=;
	h=Date:To:From:Subject:From;
	b=oM10fFU6Hv79IEJehIEcE22VUWCPpUVbsD5VKxkqq+++kiHeEwgUf9Po/XxZvcHxC
	 Rx8/tklMor8GoK7Hath8m32HklR48AFMgI1sD6ZrZCG/h8scHrZ3p34obDivZ31pYf
	 xeui4bVZ6J51WgrYuZmsqClVCQ3IZGvQNKrDTJKM=
Date: Fri, 03 Jan 2025 18:45:21 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-implement-damos_walk.patch added to mm-unstable branch
Message-Id: <20250104024522.2D4E6C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: implement damos_walk()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-implement-damos_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-implement-damos_walk.patch

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
Subject: mm/damon/core: implement damos_walk()
Date: Fri, 3 Jan 2025 09:43:57 -0800

Introduce a new core layer interface, damos_walk().  It aims to replace
some damon_callback usages that access DAMOS schemes applied regions of
ongoing kdamond with additional synchronizations.  It receives a function
pointer and asks kdamond to invoke it for any region that it tried to
apply any DAMOS action within one scheme apply interval for every scheme
of it.  The function further waits until the kdamond finishes the
invocations for every scheme, or cancels the request, and returns.

The kdamond invokes the function as requested within the main loop.  If it
is deactivated by DAMOS watermarks or going out of the main loop, it marks
the request as canceled, so that damos_walk() can wakeup and return.

Link: https://lkml.kernel.org/r/20250103174400.54890-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   33 +++++++++-
 mm/damon/core.c       |  132 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 163 insertions(+), 2 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-implement-damos_walk
+++ a/include/linux/damon.h
@@ -352,6 +352,31 @@ struct damos_filter {
 	struct list_head list;
 };
 
+struct damon_ctx;
+struct damos;
+
+/**
+ * struct damos_walk_control - Control damos_walk().
+ *
+ * @walk_fn:	Function to be called back for each region.
+ * @data:	Data that will be passed to walk functions.
+ *
+ * Control damos_walk(), which requests specific kdamond to invoke the given
+ * function to each region that eligible to apply actions of the kdamond's
+ * schemes.  Refer to damos_walk() for more details.
+ */
+struct damos_walk_control {
+	void (*walk_fn)(void *data, struct damon_ctx *ctx,
+			struct damon_target *t, struct damon_region *r,
+			struct damos *s);
+	void *data;
+/* private: internal use only */
+	/* informs if the kdamond finished handling of the walk request */
+	struct completion completion;
+	/* informs if the walk is canceled. */
+	bool canceled;
+};
+
 /**
  * struct damos_access_pattern - Target access pattern of the given scheme.
  * @min_sz_region:	Minimum size of target regions.
@@ -415,6 +440,8 @@ struct damos {
 	 * @action
 	 */
 	unsigned long next_apply_sis;
+	/* informs if ongoing DAMOS walk for this scheme is finished */
+	bool walk_completed;
 /* public: */
 	struct damos_quota quota;
 	struct damos_watermarks wmarks;
@@ -442,8 +469,6 @@ enum damon_ops_id {
 	NR_DAMON_OPS,
 };
 
-struct damon_ctx;
-
 /**
  * struct damon_operations - Monitoring operations for given use cases.
  *
@@ -656,6 +681,9 @@ struct damon_ctx {
 	struct damon_call_control *call_control;
 	struct mutex call_control_lock;
 
+	struct damos_walk_control *walk_control;
+	struct mutex walk_control_lock;
+
 /* public: */
 	struct task_struct *kdamond;
 	struct mutex kdamond_lock;
@@ -804,6 +832,7 @@ int damon_start(struct damon_ctx **ctxs,
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
+int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end);
--- a/mm/damon/core.c~mm-damon-core-implement-damos_walk
+++ a/mm/damon/core.c
@@ -505,6 +505,7 @@ struct damon_ctx *damon_new_ctx(void)
 
 	mutex_init(&ctx->kdamond_lock);
 	mutex_init(&ctx->call_control_lock);
+	mutex_init(&ctx->walk_control_lock);
 
 	ctx->attrs.min_nr_regions = 10;
 	ctx->attrs.max_nr_regions = 1000;
@@ -1211,6 +1212,46 @@ int damon_call(struct damon_ctx *ctx, st
 	return 0;
 }
 
+/**
+ * damos_walk() - Invoke a given functions while DAMOS walk regions.
+ * @ctx:	DAMON context to call the functions for.
+ * @control:	Control variable of the walk request.
+ *
+ * Ask DAMON worker thread (kdamond) of @ctx to call a function for each region
+ * that the kdamond will apply DAMOS action to, and wait until the kdamond
+ * finishes handling of the request.
+ *
+ * The kdamond executes the given function in the main loop, for each region
+ * just after it applied any DAMOS actions of @ctx to it.  The invocation is
+ * made only within one &damos->apply_interval_us since damos_walk()
+ * invocation, for each scheme.  The given callback function can hence safely
+ * access the internal data of &struct damon_ctx and &struct damon_region that
+ * each of the scheme will apply the action for next interval, without
+ * additional synchronizations against the kdamond.  If every scheme of @ctx
+ * passed at least one &damos->apply_interval_us, kdamond marks the request as
+ * completed so that damos_walk() can wakeup and return.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
+{
+	init_completion(&control->completion);
+	control->canceled = false;
+	mutex_lock(&ctx->walk_control_lock);
+	if (ctx->walk_control) {
+		mutex_unlock(&ctx->walk_control_lock);
+		return -EBUSY;
+	}
+	ctx->walk_control = control;
+	mutex_unlock(&ctx->walk_control_lock);
+	if (!damon_is_running(ctx))
+		return -EINVAL;
+	wait_for_completion(&control->completion);
+	if (control->canceled)
+		return -ECANCELED;
+	return 0;
+}
+
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -1390,6 +1431,91 @@ static bool damos_filter_out(struct damo
 	return false;
 }
 
+/*
+ * damos_walk_call_walk() - Call &damos_walk_control->walk_fn.
+ * @ctx:	The context of &damon_ctx->walk_control.
+ * @t:		The monitoring target of @r that @s will be applied.
+ * @r:		The region of @t that @s will be applied.
+ * @s:		The scheme of @ctx that will be applied to @r.
+ *
+ * This function is called from kdamond whenever it asked the operation set to
+ * apply a DAMOS scheme action to a region.  If a DAMOS walk request is
+ * installed by damos_walk() and not yet uninstalled, invoke it.
+ */
+static void damos_walk_call_walk(struct damon_ctx *ctx, struct damon_target *t,
+		struct damon_region *r, struct damos *s)
+{
+	struct damos_walk_control *control;
+
+	mutex_lock(&ctx->walk_control_lock);
+	control = ctx->walk_control;
+	mutex_unlock(&ctx->walk_control_lock);
+	if (!control)
+		return;
+	control->walk_fn(control->data, ctx, t, r, s);
+}
+
+/*
+ * damos_walk_complete() - Complete DAMOS walk request if all walks are done.
+ * @ctx:	The context of &damon_ctx->walk_control.
+ * @s:		A scheme of @ctx that all walks are now done.
+ *
+ * This function is called when kdamond finished applying the action of a DAMOS
+ * scheme to all regions that eligible for the given &damos->apply_interval_us.
+ * If every scheme of @ctx including @s now finished walking for at least one
+ * &damos->apply_interval_us, this function makrs the handling of the given
+ * DAMOS walk request is done, so that damos_walk() can wake up and return.
+ */
+static void damos_walk_complete(struct damon_ctx *ctx, struct damos *s)
+{
+	struct damos *siter;
+	struct damos_walk_control *control;
+
+	mutex_lock(&ctx->walk_control_lock);
+	control = ctx->walk_control;
+	mutex_unlock(&ctx->walk_control_lock);
+	if (!control)
+		return;
+
+	s->walk_completed = true;
+	/* if all schemes completed, signal completion to walker */
+	damon_for_each_scheme(siter, ctx) {
+		if (!siter->walk_completed)
+			return;
+	}
+	complete(&control->completion);
+	mutex_lock(&ctx->walk_control_lock);
+	ctx->walk_control = NULL;
+	mutex_unlock(&ctx->walk_control_lock);
+}
+
+/*
+ * damos_walk_cancel() - Cancel the current DAMOS walk request.
+ * @ctx:	The context of &damon_ctx->walk_control.
+ *
+ * This function is called when @ctx is deactivated by DAMOS watermarks, DAMOS
+ * walk is requested but there is no DAMOS scheme to walk for, or the kdamond
+ * is already out of the main loop and therefore gonna be terminated, and hence
+ * cannot continue the walks.  This function therefore marks the walk request
+ * as canceled, so that damos_walk() can wake up and return.
+ */
+static void damos_walk_cancel(struct damon_ctx *ctx)
+{
+	struct damos_walk_control *control;
+
+	mutex_lock(&ctx->walk_control_lock);
+	control = ctx->walk_control;
+	mutex_unlock(&ctx->walk_control_lock);
+
+	if (!control)
+		return;
+	control->canceled = true;
+	complete(&control->completion);
+	mutex_lock(&ctx->walk_control_lock);
+	ctx->walk_control = NULL;
+	mutex_unlock(&ctx->walk_control_lock);
+}
+
 static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
@@ -1444,6 +1570,7 @@ static void damos_apply_scheme(struct da
 					damon_nr_regions(t), do_trace);
 			sz_applied = c->ops.apply_scheme(c, t, r, s);
 		}
+		damos_walk_call_walk(c, t, r, s);
 		ktime_get_coarse_ts64(&end);
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
@@ -1712,6 +1839,7 @@ static void kdamond_apply_schemes(struct
 	damon_for_each_scheme(s, c) {
 		if (c->passed_sample_intervals < s->next_apply_sis)
 			continue;
+		damos_walk_complete(c, s);
 		s->next_apply_sis = c->passed_sample_intervals +
 			(s->apply_interval_us ? s->apply_interval_us :
 			 c->attrs.aggr_interval) / sample_interval;
@@ -2024,6 +2152,7 @@ static int kdamond_wait_activation(struc
 				ctx->callback.after_wmarks_check(ctx))
 			break;
 		kdamond_call(ctx, true);
+		damos_walk_cancel(ctx);
 	}
 	return -EBUSY;
 }
@@ -2117,6 +2246,8 @@ static int kdamond_fn(void *data)
 		 */
 		if (!list_empty(&ctx->schemes))
 			kdamond_apply_schemes(ctx);
+		else
+			damos_walk_cancel(ctx);
 
 		sample_interval = ctx->attrs.sample_interval ?
 			ctx->attrs.sample_interval : 1;
@@ -2157,6 +2288,7 @@ done:
 	mutex_unlock(&ctx->kdamond_lock);
 
 	kdamond_call(ctx, true);
+	damos_walk_cancel(ctx);
 
 	mutex_lock(&damon_lock);
 	nr_running_ctxs--;
_

Patches currently in -mm which might be from sj@kernel.org are

samples-add-a-skeleton-of-a-sample-damon-module-for-working-set-size-estimation.patch
samples-damon-wsse-start-and-stop-damon-as-the-user-requests.patch
samples-damon-wsse-implement-working-set-size-estimation-and-logging.patch
samples-damon-introduce-a-skeleton-of-a-smaple-damon-module-for-proactive-reclamation.patch
samples-damon-prcl-implement-schemes-setup.patch
replace-free-hugepage-folios-after-migration-fix-2.patch
docs-admin-guide-mm-damon-usage-remove-damon-debugfs-interface-documentation.patch
docs-mm-damon-design-update-for-removal-of-damon-debugfs-interface.patch
selftests-damon-config-remove-configs-for-damon-debugfs-interface-selftests.patch
selftests-damon-remove-tests-for-damon-debugfs-interface.patch
kunit-configs-remove-configs-for-damon-debugfs-interface-tests.patch
mm-damon-remove-damon-debugfs-interface-kunit-tests.patch
mm-damon-remove-damon-debugfs-interface.patch
mm-damon-sysfs-schemes-remove-unnecessary-schemes-existence-check-in-damon_sysfs_schemes_clear_regions.patch
mm-damon-sysfs-handle-clear_schemes_tried_regions-from-damon-sysfs-context.patch
mm-damon-core-introduce-damon_call.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_stats.patch
mm-damon-sysfs-use-damon_call-for-commit_schemes_quota_goals.patch
mm-damon-sysfs-use-damon_call-for-update_schemes_effective_quotas.patch
mm-damon-core-implement-damos_walk.patch
docs-mm-damon-design-document-damos-regions-walking.patch
mm-damon-sysfs-use-damos_walk-for-update_schemes_tried_bytesregions.patch
mm-damon-sysfs-remove-unused-code-for-schemes-tried-regions-update.patch

