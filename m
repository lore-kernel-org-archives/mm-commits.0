Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC21326D51;
	Sat, 18 Apr 2026 07:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498860; cv=none; b=efx2w81WCDhKf/cDkNvhn0ISP7ba0Y+3gMaRIZtjsVCUoIg8oP0/FyliSPlSdzO9p/drYkPgGR24smk4oFoywdvFuo3QewmSEzoOVP6G7FdvpZ2HR/yadUV21prbiU57y4vzLVYuBNWtTYD4oB4t/JPfKZjmmfRCFHR95SNwfK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498860; c=relaxed/simple;
	bh=uiKJncK9OkYNOSTzDmmu7tREL6tuyK37da8k4Otak70=;
	h=Date:To:From:Subject:Message-Id; b=vGo5Pn4Vckk80WdDMBvGnl+diCY7YZ3p380s7JSSN0WbBuKozqzz808KPGNdQ6610UR4aNF2EHiRiVZJgf5Ok3uoHlycKakgrY+tXAaIdNL87hdCLlk2g0NA26pcnB1ehWcDJkMQzYe3UQGJ+JbioBB//cq34kx8ibrfgvxb3ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I2L5T4IO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I2L5T4IO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0721C19424;
	Sat, 18 Apr 2026 07:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498860;
	bh=uiKJncK9OkYNOSTzDmmu7tREL6tuyK37da8k4Otak70=;
	h=Date:To:From:Subject:From;
	b=I2L5T4IOBrY6q4AaI9abbyPHirD90UlY0pW2/GbEzxwRro/pwZxddrzYr87CfeEWC
	 qQWxlXACt5nTqg4pcJPvPHAtP9LyKzSaYDR6sRI8i/Cx7eOl3pxuKVsaqy0/4/t7Xt
	 pHpJ81R+BrV3OSN6bdDYkfN14WvrmOxPJAI91bZQ=
Date: Sat, 18 Apr 2026 00:54:14 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch removed from -mm tree
Message-Id: <20260418075418.C0721C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix damon_call() vs kdamond_fn() exit race
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix damon_call() vs kdamond_fn() exit race
Date: Fri, 27 Mar 2026 16:33:14 -0700

Patch series "mm/damon/core: fix damon_call()/damos_walk() vs kdmond exit
race".

damon_call() and damos_walk() can leak memory and/or deadlock when they
race with kdamond terminations.  Fix those.


This patch (of 2);

When kdamond_fn() main loop is finished, the function cancels all
remaining damon_call() requests and unset the damon_ctx->kdamond so that
API callers and API functions themselves can know the context is
terminated.  damon_call() adds the caller's request to the queue first. 
After that, it shows if the kdamond of the damon_ctx is still running
(damon_ctx->kdamond is set).  Only if the kdamond is running, damon_call()
starts waiting for the kdamond's handling of the newly added request.

The damon_call() requests registration and damon_ctx->kdamond unset are
protected by different mutexes, though.  Hence, damon_call() could race
with damon_ctx->kdamond unset, and result in deadlocks.

For example, let's suppose kdamond successfully finished the damon_call()
requests cancelling.  Right after that, damon_call() is called for the
context.  It registers the new request, and shows the context is still
running, because damon_ctx->kdamond unset is not yet done.  Hence the
damon_call() caller starts waiting for the handling of the request. 
However, the kdamond is already on the termination steps, so it never
handles the new request.  As a result, the damon_call() caller threads
infinitely waits.

Fix this by introducing another damon_ctx field, namely
call_controls_obsolete.  It is protected by the
damon_ctx->call_controls_lock, which protects damon_call() requests
registration.  Initialize (unset) it in kdamond_fn() before letting
damon_start() returns and set it just before the cancelling of remaining
damon_call() requests is executed.  damon_call() reads the obsolete field
under the lock and avoids adding a new request.

After this change, only requests that are guaranteed to be handled or
cancelled are registered.  Hence the after-registration DAMON context
termination check is no longer needed.  Remove it together.

Note that the deadlock will not happen when damon_call() is called for
repeat mode request.  In tis case, damon_call() returns instead of waiting
for the handling when the request registration succeeds and it shows the
kdamond is running.  However, if the request also has dealloc_on_cancel,
the request memory would be leaked.

The issue is found by sashiko [1].

Link: https://lore.kernel.org/20260327233319.3528-1-sj@kernel.org
Link: https://lore.kernel.org/20260327233319.3528-2-sj@kernel.org
Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org [1]
Fixes: 42b7491af14c ("mm/damon/core: introduce damon_call()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 
 mm/damon/core.c       |   45 ++++++++++++----------------------------
 2 files changed, 15 insertions(+), 31 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race
+++ a/include/linux/damon.h
@@ -818,6 +818,7 @@ struct damon_ctx {
 
 	/* lists of &struct damon_call_control */
 	struct list_head call_controls;
+	bool call_controls_obsolete;
 	struct mutex call_controls_lock;
 
 	struct damos_walk_control *walk_control;
--- a/mm/damon/core.c~mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race
+++ a/mm/damon/core.c
@@ -1573,35 +1573,6 @@ int damon_kdamond_pid(struct damon_ctx *
 	return pid;
 }
 
-/*
- * damon_call_handle_inactive_ctx() - handle DAMON call request that added to
- *				      an inactive context.
- * @ctx:	The inactive DAMON context.
- * @control:	Control variable of the call request.
- *
- * This function is called in a case that @control is added to @ctx but @ctx is
- * not running (inactive).  See if @ctx handled @control or not, and cleanup
- * @control if it was not handled.
- *
- * Returns 0 if @control was handled by @ctx, negative error code otherwise.
- */
-static int damon_call_handle_inactive_ctx(
-		struct damon_ctx *ctx, struct damon_call_control *control)
-{
-	struct damon_call_control *c;
-
-	mutex_lock(&ctx->call_controls_lock);
-	list_for_each_entry(c, &ctx->call_controls, list) {
-		if (c == control) {
-			list_del(&control->list);
-			mutex_unlock(&ctx->call_controls_lock);
-			return -EINVAL;
-		}
-	}
-	mutex_unlock(&ctx->call_controls_lock);
-	return 0;
-}
-
 /**
  * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
  * @ctx:	DAMON context to call the function for.
@@ -1619,6 +1590,10 @@ static int damon_call_handle_inactive_ct
  * synchronization.  The return value of the function will be saved in
  * &damon_call_control->return_code.
  *
+ * Note that this function should be called only after damon_start() with the
+ * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
+ * wait.
+ *
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
@@ -1629,10 +1604,12 @@ int damon_call(struct damon_ctx *ctx, st
 	INIT_LIST_HEAD(&control->list);
 
 	mutex_lock(&ctx->call_controls_lock);
+	if (ctx->call_controls_obsolete) {
+		mutex_unlock(&ctx->call_controls_lock);
+		return -ECANCELED;
+	}
 	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
-	if (!damon_is_running(ctx))
-		return damon_call_handle_inactive_ctx(ctx, control);
 	if (control->repeat)
 		return 0;
 	wait_for_completion(&control->completion);
@@ -2952,6 +2929,9 @@ static int kdamond_fn(void *data)
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
 
+	mutex_lock(&ctx->call_controls_lock);
+	ctx->call_controls_obsolete = false;
+	mutex_unlock(&ctx->call_controls_lock);
 	complete(&ctx->kdamond_started);
 	kdamond_init_ctx(ctx);
 
@@ -3062,6 +3042,9 @@ done:
 	damon_destroy_targets(ctx);
 
 	kfree(ctx->regions_score_histogram);
+	mutex_lock(&ctx->call_controls_lock);
+	ctx->call_controls_obsolete = true;
+	mutex_unlock(&ctx->call_controls_lock);
 	kdamond_call(ctx, true);
 	damos_walk_cancel(ctx);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-disallow-time-quota-setting-zero-esz.patch
mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch

