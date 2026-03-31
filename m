Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904262DC32E;
	Tue, 31 Mar 2026 23:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774999613; cv=none; b=eTdilz+pxbvq8kGncKepxZL98U1+wN0wi9JQpN0zPB4HhZXYCnEJLsVoq5w25k3wxwclRVT/ewYJObi4AvBvYG43Bu2qBHFxg+bNTSwTBAbHYT7TAhEVR4gbFu33+paTP5M0JeXRb+W+89xiK4gaa/IXlNYM3oJeDxk1ekkryFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774999613; c=relaxed/simple;
	bh=WrwAul0cYFQxTwgO6mUBtQ+cwWDF9WYhoT9zS3qubAQ=;
	h=Date:To:From:Subject:Message-Id; b=cSWkkJRAA9sUKfLf2SG2a1nE05bfBTXiPL4mXXcO2XKsXATZ5JgfAnGHtzo18VPnBsP0StLFYlHAPzIyMI8IpdqZuTr1gZhQo+CUAfx0HSOJyciKh/g7UyMyZ60kFoh7oeYdO30mUQGwF48g4jGrWfiT/jWSRkMCMFpSIEvxYLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sunxof9n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sunxof9n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294D8C19423;
	Tue, 31 Mar 2026 23:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774999613;
	bh=WrwAul0cYFQxTwgO6mUBtQ+cwWDF9WYhoT9zS3qubAQ=;
	h=Date:To:From:Subject:From;
	b=sunxof9nyxZf9K8bTi1jxiu6wTpO/U5SOsxiPN7BX+k8M+6KI4xoYwODA2/tqhL/f
	 K78NL/dk0MjzM+hpORdcd/SAE200H88nm7qaciKGy9nIpP0gznz3sOnQGwapAxnGfL
	 sJme9mdFbblY9FrpXRhNKn1rnm2UGghWoVyYweyQ=
Date: Tue, 31 Mar 2026 16:26:52 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch added to mm-hotfixes-unstable branch
Message-Id: <20260331232653.294D8C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix damos_walk() vs kdamond_fn() exit race
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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


Link: https://lkml.kernel.org/r/20260327233319.3528-3-sj@kernel.org
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
@@ -809,6 +809,7 @@ struct damon_ctx {
 	struct mutex call_controls_lock;
 
 	struct damos_walk_control *walk_control;
+	bool walk_control_obsolete;
 	struct mutex walk_control_lock;
 
 	/*
--- a/mm/damon/core.c~mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race
+++ a/mm/damon/core.c
@@ -1528,6 +1528,10 @@ int damon_call(struct damon_ctx *ctx, st
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
@@ -1535,19 +1539,16 @@ int damos_walk(struct damon_ctx *ctx, st
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
@@ -2731,6 +2732,9 @@ static int kdamond_fn(void *data)
 	mutex_lock(&ctx->call_controls_lock);
 	ctx->call_controls_obsolete = false;
 	mutex_unlock(&ctx->call_controls_lock);
+	mutex_lock(&ctx->walk_control_lock);
+	ctx->walk_control_obsolete = false;
+	mutex_unlock(&ctx->walk_control_lock);
 	complete(&ctx->kdamond_started);
 	kdamond_init_ctx(ctx);
 
@@ -2839,6 +2843,9 @@ done:
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

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch
mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch
mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch

