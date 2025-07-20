Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1F672601
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976929; cv=none; b=gPYQgIuDrYh1eXo8g53bmO3MBGGl9dGWHRz8oMQPkL4JdQ75qmjO3bOoDgcwLCcIVoY51Da1YX/ZcOvz2O9RZwrHxox1tOrw3WWTwR+cblbxI2MPX6E+l0YaIxwXTcIfoPbHXICtHy0G3wOYhD+vFx66+zt3Bs9csCpasdqBQnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976929; c=relaxed/simple;
	bh=qa/cyEFB399Ecv3SfJ4TzYhCUJwJ8KhHouQdMFGhv3A=;
	h=Date:To:From:Subject:Message-Id; b=BV56chTVyke9BRoKvuFKBSjanQYPfPwR4zy0zOMTIt0uNpMqxGSoCN3GBwPidYS5KnTnvhN2vrCGhoXmIpKTz5nH+vNBBxqPFErfyi17EE0/7xvbVM/4Oxl1dA8J6nwZMZqI7NIALz+VBAbd0h29rUaTBr+Y1JNNLHCCO6vkmqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=we+lydi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="we+lydi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0138AC4CEE3;
	Sun, 20 Jul 2025 02:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976929;
	bh=qa/cyEFB399Ecv3SfJ4TzYhCUJwJ8KhHouQdMFGhv3A=;
	h=Date:To:From:Subject:From;
	b=we+lydi+UzPQluTb+sUsm3L3XS2YFCU8gd/3TYJEIwoxm+P/Z9lFfeM9n4ya2+9Yz
	 rna4NiXOmQQm36LdI6q7bDZLbH30xzTrpow5M9+avlhxJvXBeWAYdzjND+KXk5OzFM
	 sf8YDWGjqOFhNGp/zm6pX6AoolQJnCzHW5Use04Q=
Date: Sat, 19 Jul 2025 19:02:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-repeat-mode-damon_call.patch removed from -mm tree
Message-Id: <20250720020209.0138AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce repeat mode damon_call()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-repeat-mode-damon_call.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce repeat mode damon_call()
Date: Sat, 12 Jul 2025 12:50:04 -0700

damon_call() can be useful for reading or writing DAMON internal data for
one time.  A common pattern of DAMON core usage from DAMON modules is
doing such reads and writes repeatedly, for example, to periodically
update the DAMOS stats.  To do that with damon_call(), callers should call
damon_call() repeatedly, with their own delay loop.  Each caller doing
that is repetitive.  Introduce a repeat mode damon_call().  Callers can
use the mode by setting a new field in damon_call_control.  If the mode is
turned on, damon_call() returns success immediately, and DAMON repeats
invoking the callback function inside the kdamond main loop.

Link: https://lkml.kernel.org/r/20250712195016.151108-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |   25 ++++++++++++++++++++-----
 2 files changed, 22 insertions(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-introduce-repeat-mode-damon_call
+++ a/include/linux/damon.h
@@ -659,6 +659,7 @@ struct damon_callback {
  *
  * @fn:			Function to be called back.
  * @data:		Data that will be passed to @fn.
+ * @repeat:		Repeat invocations.
  * @return_code:	Return code from @fn invocation.
  *
  * Control damon_call(), which requests specific kdamond to invoke a given
@@ -667,6 +668,7 @@ struct damon_callback {
 struct damon_call_control {
 	int (*fn)(void *data);
 	void *data;
+	bool repeat;
 	int return_code;
 /* private: internal use only */
 	/* informs if the kdamond finished handling of the request */
--- a/mm/damon/core.c~mm-damon-core-introduce-repeat-mode-damon_call
+++ a/mm/damon/core.c
@@ -1379,8 +1379,9 @@ bool damon_is_running(struct damon_ctx *
  *
  * Ask DAMON worker thread (kdamond) of @ctx to call a function with an
  * argument data that respectively passed via &damon_call_control->fn and
- * &damon_call_control->data of @control, and wait until the kdamond finishes
- * handling of the request.
+ * &damon_call_control->data of @control.  If &damon_call_control->repeat of
+ * @control is set, further wait until the kdamond finishes handling of the
+ * request.  Otherwise, return as soon as the request is made.
  *
  * The kdamond executes the function with the argument in the main loop, just
  * after a sampling of the iteration is finished.  The function can hence
@@ -1392,7 +1393,8 @@ bool damon_is_running(struct damon_ctx *
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 {
-	init_completion(&control->completion);
+	if (!control->repeat)
+		init_completion(&control->completion);
 	control->canceled = false;
 	INIT_LIST_HEAD(&control->list);
 
@@ -1401,6 +1403,8 @@ int damon_call(struct damon_ctx *ctx, st
 	mutex_unlock(&ctx->call_controls_lock);
 	if (!damon_is_running(ctx))
 		return -EINVAL;
+	if (control->repeat)
+		return 0;
 	wait_for_completion(&control->completion);
 	if (control->canceled)
 		return -ECANCELED;
@@ -2429,6 +2433,7 @@ static void kdamond_usleep(unsigned long
 static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 {
 	struct damon_call_control *control;
+	LIST_HEAD(repeat_controls);
 	int ret = 0;
 
 	while (true) {
@@ -2437,7 +2442,7 @@ static void kdamond_call(struct damon_ct
 				struct damon_call_control, list);
 		mutex_unlock(&ctx->call_controls_lock);
 		if (!control)
-			return;
+			break;
 		if (cancel) {
 			control->canceled = true;
 		} else {
@@ -2447,8 +2452,18 @@ static void kdamond_call(struct damon_ct
 		mutex_lock(&ctx->call_controls_lock);
 		list_del(&control->list);
 		mutex_unlock(&ctx->call_controls_lock);
-		complete(&control->completion);
+		if (!control->repeat)
+			complete(&control->completion);
+		else
+			list_add(&control->list, &repeat_controls);
 	}
+	control = list_first_entry_or_null(&repeat_controls,
+			struct damon_call_control, list);
+	if (!control || cancel)
+		return;
+	mutex_lock(&ctx->call_controls_lock);
+	list_add_tail(&control->list, &ctx->call_controls);
+	mutex_unlock(&ctx->call_controls_lock);
 }
 
 /* Returns negative error code if it's not activated but should return */
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

