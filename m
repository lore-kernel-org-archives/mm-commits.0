Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BC61E0DE8
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752357980; cv=none; b=t5pEmlhgf6FSjIqA+g/ZQypxFdvtw3sXCvyCRZ0dg8Or/EetLCH9EhUiiVIPNgjo+/NLjw8f17uU6Uz0FzJ3anXqXyjHCJWVHXgxJ+kMQX/xsyTeZXboE7WZl+cbgK27iHfvuDPAenjObJwWe22HVJPqu/CW1HPWSkdI/nqDFx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752357980; c=relaxed/simple;
	bh=LTV2qOdtO35F90w9XJhpuZpjb+izxJGgw3QgA2Ongbw=;
	h=Date:To:From:Subject:Message-Id; b=kXNXlJ3TpHbs7ZgTG0j9N89i/fptRkiVkpTIpSujsJ4xXXltc+px7YtbO0ZsOBSLymi/8e/jVoD7//SgBytUla8rf9lDCjomCWup5pIw1pRdMgluTmtKpAGPuGdscOtGkbNsoeWgTaL2+BIjyV8jFBpA0p8xnlAP4e36mrIW0Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pV4CaBPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pV4CaBPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EE6C4CEEF;
	Sat, 12 Jul 2025 22:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752357980;
	bh=LTV2qOdtO35F90w9XJhpuZpjb+izxJGgw3QgA2Ongbw=;
	h=Date:To:From:Subject:From;
	b=pV4CaBPyTOMKuhawXkJYxYg+CfMVrTdJjoKF25fPwH3JifuC9MyyN1YKVv+NJAHM7
	 oByR/QxXBIJjE25kS0npDT8wv1osNBzv0Kd7H/15gkQ8vHhgZkZUuYoVN3QUcuUMMm
	 fzNu1IqU8u2jlHBcJonbBtV5GdaUP0vqucAIjJIM=
Date: Sat, 12 Jul 2025 15:06:19 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-repeat-mode-damon_call.patch added to mm-new branch
Message-Id: <20250712220619.E8EE6C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce repeat mode damon_call()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-repeat-mode-damon_call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-repeat-mode-damon_call.patch

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

