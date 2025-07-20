Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BDD14AD0D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976927; cv=none; b=o/6ooU/CMxflRe0RJ5AYztglHHC8eTw96rwYaBO6qpxwe3NNxhaiDtRhNbgo+BsPajjJUzofPspRpQgpC7uii2jbI3fL2oF4rZL9n7SL/jiRzDIzOkkRaNeg9RmPMvMdSpzY9Y9diC1X04YZe5bEqKknhCgFF2zV8Fu3yqxXoeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976927; c=relaxed/simple;
	bh=3geI3qePBESLcqY92anaK6pevJ+ty67xtVOtbtqVgZQ=;
	h=Date:To:From:Subject:Message-Id; b=K+hI+WtJXRv2BGo7EcXXfVW0/4MnEU1WQEIm9/EHM2ORmNasENSfJu6kQIK6n1tE/aFjyc8q6UBm1g519lxmTVi7geG5mTCItFVg2pPKasriRKYCOFnxw/3Gfbsh3Ogx1CAnIAsUyylNWQ/k7HoDQbln/do0XAmSoepHY/y7Ggg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lsF9gLmk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lsF9gLmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4B2C4CEE3;
	Sun, 20 Jul 2025 02:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976927;
	bh=3geI3qePBESLcqY92anaK6pevJ+ty67xtVOtbtqVgZQ=;
	h=Date:To:From:Subject:From;
	b=lsF9gLmkgFNbmC+5KI7rtTcbzkrRJ+6NUEqpt1x80tJ77S2rXU3nZwbYPkgaypNp0
	 yQxrEw7wrKQt1hvp8tdPXQrFMx/8tCLE7Y5DnHqmMUmJiet1IvQ01TaKce8du9M34C
	 C6DIdlyOfipr89LBz4R4gssPKE1kPkxtlJoMXXd4=
Date: Sat, 19 Jul 2025 19:02:06 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-accept-parallel-damon_call-requests.patch removed from -mm tree
Message-Id: <20250720020207.1D4B2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: accept parallel damon_call() requests
has been removed from the -mm tree.  Its filename was
     mm-damon-accept-parallel-damon_call-requests.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: accept parallel damon_call() requests
Date: Sat, 12 Jul 2025 12:50:03 -0700

Patch series "mm/damon: remove damon_callback".

damon_callback was the only way for communicating with DAMON for contexts
running on its worker thread.  The interface is flexible and simple.  But
as DAMON evolves with more features, damon_callback has become somewhat
too old.  With runtime parameters update, for example, its lack of
synchronization support was found to be inconvenient.  Arguably it is also
not easy to use correctly since the callers should understand when each
callback is called, and implication of the return values from the
callbacks.

To replace it, damon_call() and damos_walk() are introduced.  And those
replaced a few damon_callback use cases.  Some use cases of damon_callback
such as parallel or repetitive DAMON internal data reading and additional
cleanups cannot simply be replaced by damon_call() and damos_walk(),
though.

To allow those replaceable, extend damon_call() for parallel and/or
repeated callbacks and modify the core/ops layers for additional resources
cleanup.  With the updates, replace the remaining damon_callback usages
and finally say goodbye to damon_callback.


This patch (of 14):

Calling damon_call() while it is serving for another parallel thread
immediately fails with -EBUSY.  The caller should call it again, later. 
Each caller implementing such retry logic would be redundant.  Accept
parallel damon_call() requests and do the wait instead of the caller.

Link: https://lkml.kernel.org/r/20250712195016.151108-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250712195016.151108-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    7 ++++-
 mm/damon/core.c       |   49 ++++++++++++++++++++--------------------
 2 files changed, 30 insertions(+), 26 deletions(-)

--- a/include/linux/damon.h~mm-damon-accept-parallel-damon_call-requests
+++ a/include/linux/damon.h
@@ -673,6 +673,8 @@ struct damon_call_control {
 	struct completion completion;
 	/* informs if the kdamond canceled @fn infocation */
 	bool canceled;
+	/* List head for siblings. */
+	struct list_head list;
 };
 
 /**
@@ -798,8 +800,9 @@ struct damon_ctx {
 	/* for scheme quotas prioritization */
 	unsigned long *regions_score_histogram;
 
-	struct damon_call_control *call_control;
-	struct mutex call_control_lock;
+	/* lists of &struct damon_call_control */
+	struct list_head call_controls;
+	struct mutex call_controls_lock;
 
 	struct damos_walk_control *walk_control;
 	struct mutex walk_control_lock;
--- a/mm/damon/core.c~mm-damon-accept-parallel-damon_call-requests
+++ a/mm/damon/core.c
@@ -533,7 +533,8 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->next_ops_update_sis = 0;
 
 	mutex_init(&ctx->kdamond_lock);
-	mutex_init(&ctx->call_control_lock);
+	INIT_LIST_HEAD(&ctx->call_controls);
+	mutex_init(&ctx->call_controls_lock);
 	mutex_init(&ctx->walk_control_lock);
 
 	ctx->attrs.min_nr_regions = 10;
@@ -1393,14 +1394,11 @@ int damon_call(struct damon_ctx *ctx, st
 {
 	init_completion(&control->completion);
 	control->canceled = false;
+	INIT_LIST_HEAD(&control->list);
 
-	mutex_lock(&ctx->call_control_lock);
-	if (ctx->call_control) {
-		mutex_unlock(&ctx->call_control_lock);
-		return -EBUSY;
-	}
-	ctx->call_control = control;
-	mutex_unlock(&ctx->call_control_lock);
+	mutex_lock(&ctx->call_controls_lock);
+	list_add_tail(&ctx->call_controls, &control->list);
+	mutex_unlock(&ctx->call_controls_lock);
 	if (!damon_is_running(ctx))
 		return -EINVAL;
 	wait_for_completion(&control->completion);
@@ -2419,11 +2417,11 @@ static void kdamond_usleep(unsigned long
 }
 
 /*
- * kdamond_call() - handle damon_call_control.
+ * kdamond_call() - handle damon_call_control objects.
  * @ctx:	The &struct damon_ctx of the kdamond.
  * @cancel:	Whether to cancel the invocation of the function.
  *
- * If there is a &struct damon_call_control request that registered via
+ * If there are &struct damon_call_control requests that registered via
  * &damon_call() on @ctx, do or cancel the invocation of the function depending
  * on @cancel.  @cancel is set when the kdamond is already out of the main loop
  * and therefore will be terminated.
@@ -2433,21 +2431,24 @@ static void kdamond_call(struct damon_ct
 	struct damon_call_control *control;
 	int ret = 0;
 
-	mutex_lock(&ctx->call_control_lock);
-	control = ctx->call_control;
-	mutex_unlock(&ctx->call_control_lock);
-	if (!control)
-		return;
-	if (cancel) {
-		control->canceled = true;
-	} else {
-		ret = control->fn(control->data);
-		control->return_code = ret;
+	while (true) {
+		mutex_lock(&ctx->call_controls_lock);
+		control = list_first_entry_or_null(&ctx->call_controls,
+				struct damon_call_control, list);
+		mutex_unlock(&ctx->call_controls_lock);
+		if (!control)
+			return;
+		if (cancel) {
+			control->canceled = true;
+		} else {
+			ret = control->fn(control->data);
+			control->return_code = ret;
+		}
+		mutex_lock(&ctx->call_controls_lock);
+		list_del(&control->list);
+		mutex_unlock(&ctx->call_controls_lock);
+		complete(&control->completion);
 	}
-	complete(&control->completion);
-	mutex_lock(&ctx->call_control_lock);
-	ctx->call_control = NULL;
-	mutex_unlock(&ctx->call_control_lock);
 }
 
 /* Returns negative error code if it's not activated but should return */
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

