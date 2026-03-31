Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154AF2DC32E;
	Tue, 31 Mar 2026 23:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774999611; cv=none; b=Zu5/MzWAAme6eleQmEJHg16iH2fiIsjpYHEIHB+pPeRYyCibf3fr+/sZhQx9RDQ6oF+Oq/a8HkfV2L1YVM+cIQ7T+YuyY1NQRLO6hwL/mZiD6pDNHFoZQDbk9mkmHWRPLE4whGXcFsiazPRtojSUQ9EOZPZ7DekRUZAhH9AhM24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774999611; c=relaxed/simple;
	bh=qKSTGBvcGt1AKdvYAuMJ7w8mY9p6t/8penwt2t9bnq4=;
	h=Date:To:From:Subject:Message-Id; b=RUKEhByFdNifjSy3sER8iA6mPaKhlr9POaY6hd5gptJPeo6zRFgqzLUgjXE5VHB/fHLQXhpi46J9HcvF2xhWz2o2q60DITYjw3llpFRNwZmmGiZtELQ5h4ijbreRRxWL46epcCriNIkmNJufCqBGKVcSly8PGridXpyvPWp4za8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ci4OdQBR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ci4OdQBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF32C19423;
	Tue, 31 Mar 2026 23:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774999610;
	bh=qKSTGBvcGt1AKdvYAuMJ7w8mY9p6t/8penwt2t9bnq4=;
	h=Date:To:From:Subject:From;
	b=Ci4OdQBRzHVNpBiMkMPmB+XAD2nc7oNPJVLPWABtqgxE1evVBaTEF7p8orvPrHI5p
	 BK5nEuy0GhVekTFLP0XeKaT2NPXxMNB5mKb+/5Ida85dgXtQmy1Vu8En7KmEn+waYZ
	 zYyXFP+GHImbULzRoo4i3QIu9DAASfQ5qe5ogNU4=
Date: Tue, 31 Mar 2026 16:26:49 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch added to mm-hotfixes-unstable branch
Message-Id: <20260331232650.8EF32C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix damon_call() vs kdamond_fn() exit race
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch

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

Link: https://lkml.kernel.org/r/20260327233319.3528-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260327233319.3528-2-sj@kernel.org
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
@@ -805,6 +805,7 @@ struct damon_ctx {
 
 	/* lists of &struct damon_call_control */
 	struct list_head call_controls;
+	bool call_controls_obsolete;
 	struct mutex call_controls_lock;
 
 	struct damos_walk_control *walk_control;
--- a/mm/damon/core.c~mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race
+++ a/mm/damon/core.c
@@ -1464,35 +1464,6 @@ int damon_kdamond_pid(struct damon_ctx *
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
@@ -1510,6 +1481,10 @@ static int damon_call_handle_inactive_ct
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
@@ -1520,10 +1495,12 @@ int damon_call(struct damon_ctx *ctx, st
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
@@ -2751,6 +2728,9 @@ static int kdamond_fn(void *data)
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
 
+	mutex_lock(&ctx->call_controls_lock);
+	ctx->call_controls_obsolete = false;
+	mutex_unlock(&ctx->call_controls_lock);
 	complete(&ctx->kdamond_started);
 	kdamond_init_ctx(ctx);
 
@@ -2855,6 +2835,9 @@ done:
 	damon_destroy_targets(ctx);
 
 	kfree(ctx->regions_score_histogram);
+	mutex_lock(&ctx->call_controls_lock);
+	ctx->call_controls_obsolete = true;
+	mutex_unlock(&ctx->call_controls_lock);
 	kdamond_call(ctx, true);
 	damos_walk_cancel(ctx);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-dealloc-repeat_call_control-if-damon_call-fails.patch
mm-damon-core-fix-damon_call-vs-kdamond_fn-exit-race.patch
mm-damon-core-fix-damos_walk-vs-kdamond_fn-exit-race.patch

