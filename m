Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C66330C629;
	Tue, 13 Jan 2026 05:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280977; cv=none; b=tVoJVFj4NCi80s607mQdkaU3xiqtYl4PPlJ7wiTomGiOQGSFw6zCCFPeHmM+Nhd5X1A2ZkBYafm+W4g1nwvCNCz5hCMSSKkv5F36SuTyz1/yPjqpJEuOfoTFlM881qjXxrKnDMTKL9ZA65OKg/4ze2jMo28azlJfPxd0AD4Hcpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280977; c=relaxed/simple;
	bh=n7TTQzdIVb4oX1+8R2PpD1ZhZgMhSDPH9yY9FmNfsmw=;
	h=Date:To:From:Subject:Message-Id; b=n69MYdQktSB4d1ojSChnmxOQimYpZLWtq60zNJ3pPOUT6R6jtm3tLLKZEgJr93SGNByMcn/aWPsOvjW0fGW33ppgnB/kajzxu09oA7GuuU8tD7fKOzeaCaliproxLdPJ8r4NVs96Dd/tY1TJB1YjjRXlSSMnWBhJJ/prffeynEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PEIrVm4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PEIrVm4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26097C116C6;
	Tue, 13 Jan 2026 05:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280977;
	bh=n7TTQzdIVb4oX1+8R2PpD1ZhZgMhSDPH9yY9FmNfsmw=;
	h=Date:To:From:Subject:From;
	b=PEIrVm4GXSU3AtI9SwZz/AAHajMYyBardXe4xRok4k63x0IyahWcVASC39x/8grJs
	 hPPCVk15DPrDDN+9Xf+SijTktkdQMRksnpwmYYX74MqlmeI+iHc/pHKo8hoxzff1rU
	 2jXryE0Ucwj6UiKThR02nJFHBO5cdNUzP+cHBMIg=
Date: Mon, 12 Jan 2026 21:09:36 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rgbi3307@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-core-remove-call_control-in-inactive-contexts.patch removed from -mm tree
Message-Id: <20260113050937.26097C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove call_control in inactive contexts
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-call_control-in-inactive-contexts.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: remove call_control in inactive contexts
Date: Tue, 30 Dec 2025 17:23:13 -0800

If damon_call() is executed against a DAMON context that is not running,
the function returns error while keeping the damon_call_control object
linked to the context's call_controls list.  Let's suppose the object is
deallocated after the damon_call(), and yet another damon_call() is
executed against the same context.  The function tries to add the new
damon_call_control object to the call_controls list, which still has the
pointer to the previous damon_call_control object, which is deallocated. 
As a result, use-after-free happens.

This can actually be triggered using the DAMON sysfs interface.  It is not
easily exploitable since it requires the sysfs write permission and making
a definitely weird file writes, though.  Please refer to the report for
more details about the issue reproduction steps.

Fix the issue by making two changes.  Firstly, move the final
kdamond_call() for cancelling all existing damon_call() requests from
terminating DAMON context to be done before the ctx->kdamond reset.  This
makes any code that sees NULL ctx->kdamond can safely assume the context
may not access damon_call() requests anymore.  Secondly, let damon_call()
to cleanup the damon_call_control objects that were added to the
already-terminated DAMON context, before returning the error.

Link: https://lkml.kernel.org/r/20251231012315.75835-1-sj@kernel.org
Fixes: 004ded6bee11 ("mm/damon: accept parallel damon_call() requests")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: JaeJoon Jung <rgbi3307@gmail.com>
Closes: https://lore.kernel.org/20251224094401.20384-1-rgbi3307@gmail.com
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-remove-call_control-in-inactive-contexts
+++ a/mm/damon/core.c
@@ -1431,6 +1431,35 @@ bool damon_is_running(struct damon_ctx *
 	return running;
 }
 
+/*
+ * damon_call_handle_inactive_ctx() - handle DAMON call request that added to
+ *				      an inactive context.
+ * @ctx:	The inactive DAMON context.
+ * @control:	Control variable of the call request.
+ *
+ * This function is called in a case that @control is added to @ctx but @ctx is
+ * not running (inactive).  See if @ctx handled @control or not, and cleanup
+ * @control if it was not handled.
+ *
+ * Returns 0 if @control was handled by @ctx, negative error code otherwise.
+ */
+static int damon_call_handle_inactive_ctx(
+		struct damon_ctx *ctx, struct damon_call_control *control)
+{
+	struct damon_call_control *c;
+
+	mutex_lock(&ctx->call_controls_lock);
+	list_for_each_entry(c, &ctx->call_controls, list) {
+		if (c == control) {
+			list_del(&control->list);
+			mutex_unlock(&ctx->call_controls_lock);
+			return -EINVAL;
+		}
+	}
+	mutex_unlock(&ctx->call_controls_lock);
+	return 0;
+}
+
 /**
  * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
  * @ctx:	DAMON context to call the function for.
@@ -1461,7 +1490,7 @@ int damon_call(struct damon_ctx *ctx, st
 	list_add_tail(&control->list, &ctx->call_controls);
 	mutex_unlock(&ctx->call_controls_lock);
 	if (!damon_is_running(ctx))
-		return -EINVAL;
+		return damon_call_handle_inactive_ctx(ctx, control);
 	if (control->repeat)
 		return 0;
 	wait_for_completion(&control->completion);
@@ -2755,13 +2784,13 @@ done:
 	if (ctx->ops.cleanup)
 		ctx->ops.cleanup(ctx);
 	kfree(ctx->regions_score_histogram);
+	kdamond_call(ctx, true);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
 
-	kdamond_call(ctx, true);
 	damos_walk_cancel(ctx);
 
 	mutex_lock(&damon_lock);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch

