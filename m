Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A2F326D51;
	Sat, 18 Apr 2026 07:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498867; cv=none; b=jDbde1Kal2l7cl2DQZ3vv0N2nGDF4YLFdwLyGcPfDkmhMOPqvXSmam9pOIJV2qKf5DH7CEyE3IAM0jJ9dv98gfpf3t6SCxx0/qVS33LF4pRHrM9N+ZYxE+UxAhqUIDMSKws/aiRYNkC7gf/8G0NRbbSO8BmhvIANnMfVN9cKHEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498867; c=relaxed/simple;
	bh=wFvCoqWhYgGGcuqJtrlS88sFlh8e2qjgtOLd9JjBhHY=;
	h=Date:To:From:Subject:Message-Id; b=ov5KLVPY7OzCwFyfdBzGjmvUi34irvDKt6YVotkTxo4S6MyHht25JUJNU01cPml1N1fsRs0cjiUXdjECLMZzD/50MQYe7QWwWqFPm4vqToiimsZPydH7Vj3O1GvaQ9LZjX6ALRMl6Z1z7u47ArrGK+Z4+fBXZwXTKSwyha4Uz8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZgmZuzrW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZgmZuzrW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911FBC19424;
	Sat, 18 Apr 2026 07:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498867;
	bh=wFvCoqWhYgGGcuqJtrlS88sFlh8e2qjgtOLd9JjBhHY=;
	h=Date:To:From:Subject:From;
	b=ZgmZuzrWy4+BVO6MsE4TyCMq3ePZWwOiRP/MtLJIlKAW+S+2gq8DT0bTkzMofw7U4
	 7sG1XfXrif7pxmck8m73NTWEWq5pbwaMaY+d4C69qU+9a0Rzo3WYW2MZRGrr6MbfqB
	 s394u8yh6H41J5R/rG0abYTfe3JbHrokK0nu4uUA=
Date: Sat, 18 Apr 2026 00:54:21 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch removed from -mm tree
Message-Id: <20260418075426.911FBC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix damos_walk() vs kdamond_fn() exit race
has been removed from the -mm tree.  Its filename was
     mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix damos_walk() vs kdamond_fn() exit race
Date: Fri, 27 Mar 2026 16:33:15 -0700

When kdamond_fn() main loop is finished, the function cancels remaining
damos_walk() request and unset the damon_ctx->kdamond so that API callers
and API functions themselves can show the context is terminated. 
damos_walk() adds the caller's request to the queue first.  After that, it
shows if the kdamond of the damon_ctx is still running (damon_ctx->kdamond
is set).  Only if the kdamond is running, damos_walk() starts waiting for
the kdamond's handling of the newly added request.

The damos_walk() requests registration and damon_ctx->kdamond unset are
protected by different mutexes, though.  Hence, damos_walk() could race
with damon_ctx->kdamond unset, and result in deadlocks.

For example, let's suppose kdamond successfully finished the damow_walk()
request cancelling.  Right after that, damos_walk() is called for the
context.  It registers the new request, and shows the context is still
running, because damon_ctx->kdamond unset is not yet done.  Hence the
damos_walk() caller starts waiting for the handling of the request. 
However, the kdamond is already on the termination steps, so it never
handles the new request.  As a result, the damos_walk() caller thread
infinitely waits.

Fix this by introducing another damon_ctx field, namely
walk_control_obsolete.  It is protected by the
damon_ctx->walk_control_lock, which protects damos_walk() request
registration.  Initialize (unset) it in kdamond_fn() before letting
damon_start() returns and set it just before the cancelling of the
remaining damos_walk() request is executed.  damos_walk() reads the
obsolete field under the lock and avoids adding a new request.

After this change, only requests that are guaranteed to be handled or
cancelled are registered.  Hence the after-registration DAMON context
termination check is no longer needed.  Remove it together.

The issue is found by sashiko [1].


Link: https://lore.kernel.org/20260327233319.3528-3-sj@kernel.org
Link: https://lore.kernel.org/20260325141956.87144-1-sj@kernel.org [1]
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 mm/damon/core.c       |   21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race
+++ a/include/linux/damon.h
@@ -822,6 +822,7 @@ struct damon_ctx {
 	struct mutex call_controls_lock;
 
 	struct damos_walk_control *walk_control;
+	bool walk_control_obsolete;
 	struct mutex walk_control_lock;
 
 	/*
--- a/mm/damon/core.c~mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race
+++ a/mm/damon/core.c
@@ -1637,6 +1637,10 @@ int damon_call(struct damon_ctx *ctx, st
  * passed at least one &damos->apply_interval_us, kdamond marks the request as
  * completed so that damos_walk() can wakeup and return.
  *
+ * Note that this function should be called only after damon_start() with the
+ * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
+ * wait.
+ *
  * Return: 0 on success, negative error code otherwise.
  */
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
@@ -1644,19 +1648,16 @@ int damos_walk(struct damon_ctx *ctx, st
 	init_completion(&control->completion);
 	control->canceled = false;
 	mutex_lock(&ctx->walk_control_lock);
+	if (ctx->walk_control_obsolete) {
+		mutex_unlock(&ctx->walk_control_lock);
+		return -ECANCELED;
+	}
 	if (ctx->walk_control) {
 		mutex_unlock(&ctx->walk_control_lock);
 		return -EBUSY;
 	}
 	ctx->walk_control = control;
 	mutex_unlock(&ctx->walk_control_lock);
-	if (!damon_is_running(ctx)) {
-		mutex_lock(&ctx->walk_control_lock);
-		if (ctx->walk_control == control)
-			ctx->walk_control = NULL;
-		mutex_unlock(&ctx->walk_control_lock);
-		return -EINVAL;
-	}
 	wait_for_completion(&control->completion);
 	if (control->canceled)
 		return -ECANCELED;
@@ -2932,6 +2933,9 @@ static int kdamond_fn(void *data)
 	mutex_lock(&ctx->call_controls_lock);
 	ctx->call_controls_obsolete = false;
 	mutex_unlock(&ctx->call_controls_lock);
+	mutex_lock(&ctx->walk_control_lock);
+	ctx->walk_control_obsolete = false;
+	mutex_unlock(&ctx->walk_control_lock);
 	complete(&ctx->kdamond_started);
 	kdamond_init_ctx(ctx);
 
@@ -3046,6 +3050,9 @@ done:
 	ctx->call_controls_obsolete = true;
 	mutex_unlock(&ctx->call_controls_lock);
 	kdamond_call(ctx, true);
+	mutex_lock(&ctx->walk_control_lock);
+	ctx->walk_control_obsolete = true;
+	mutex_unlock(&ctx->walk_control_lock);
 	damos_walk_cancel(ctx);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-disallow-time-quota-setting-zero-esz.patch
mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch

