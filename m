Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E102023355D
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837149; cv=none; b=mTqr4QwoSzRR6yCNlaD4JCaf2mFErWJdGMaDm3xsqwhVjbvnIf8Js6L98rQhkM3o20pEWJKD9+eQZ5B+049n9ZMCEqd6/j/GAkJIKwdDWgagew7k22QYnoFzzYraZ7+X5TFCYrcbskyx84wyHyu1kyJBNUCaHnhsrtX76TlNmCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837149; c=relaxed/simple;
	bh=fkhCbl7OupuoqZ22gkKWtES7eBkRkKHLMSbZpQPgovU=;
	h=Date:To:From:Subject:Message-Id; b=YW8mbXrrCBt/SgPxO6ezOuguz6kXy307wTDMJvHUF2mxEOJncT4C25+Jwa4u7Zir2/2aQegJ8XNKEAJGVt2K4OMVwm8a1b7EgRw2anZg2vY+WxNRHMgvDfhIVplm6knhhR1LK89EpSJsLKBsRF2qX6M7SkruTq1GuaWvQvJ6ldE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mcFbKTBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mcFbKTBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FD1C4CEDF;
	Tue, 14 Jan 2025 06:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837148;
	bh=fkhCbl7OupuoqZ22gkKWtES7eBkRkKHLMSbZpQPgovU=;
	h=Date:To:From:Subject:From;
	b=mcFbKTBVIjdRkN+5wLAFcVvmrc34VPdv4GxkoHa714br/2xCEUe6KI2NI3RflQTim
	 sQV26HdgR6edQmA0jsFidDKD12t+h0RaN+t/rMUkFDw+fm7b18ycnjcOeMkON46Sye
	 RW9K4IadjiJEbCwaV8iaxRB1fwgHTpvt9i56A8x0=
Date: Mon, 13 Jan 2025 22:45:47 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-introduce-damon_call.patch removed from -mm tree
Message-Id: <20250114064548.53FD1C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: introduce damon_call()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-damon_call.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce damon_call()
Date: Fri, 3 Jan 2025 09:43:53 -0800

Introduce a new DAMON core API function, damon_call().  It aims to replace
some damon_callback usages that access damon_ctx of ongoing kdamond with
additional synchronizations.  It receives a function pointer, let the
parallel kdamond invokes the function, and returns after the invocation is
finished, or canceled due to some races.

kdamond invokes the function inside the main loop after sampling is done. 
If it is deactivated by DAMOS watermarks or already out of the main loop,
mark the request as canceled so that damon_call() can wakeup and return.

Link: https://lkml.kernel.org/r/20250103174400.54890-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   26 ++++++++++++
 mm/damon/core.c       |   86 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damon_call
+++ a/include/linux/damon.h
@@ -552,6 +552,27 @@ struct damon_callback {
 	void (*before_terminate)(struct damon_ctx *context);
 };
 
+/*
+ * struct damon_call_control - Control damon_call().
+ *
+ * @fn:			Function to be called back.
+ * @data:		Data that will be passed to @fn.
+ * @return_code:	Return code from @fn invocation.
+ *
+ * Control damon_call(), which requests specific kdamond to invoke a given
+ * function.  Refer to damon_call() for more details.
+ */
+struct damon_call_control {
+	int (*fn)(void *data);
+	void *data;
+	int return_code;
+/* private: internal use only */
+	/* informs if the kdamond finished handling of the request */
+	struct completion completion;
+	/* informs if the kdamond canceled @fn infocation */
+	bool canceled;
+};
+
 /**
  * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
@@ -632,6 +653,9 @@ struct damon_ctx {
 	/* for scheme quotas prioritization */
 	unsigned long *regions_score_histogram;
 
+	struct damon_call_control *call_control;
+	struct mutex call_control_lock;
+
 /* public: */
 	struct task_struct *kdamond;
 	struct mutex kdamond_lock;
@@ -779,6 +803,8 @@ static inline unsigned int damon_max_nr_
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 
+int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
+
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end);
 
--- a/mm/damon/core.c~mm-damon-core-introduce-damon_call
+++ a/mm/damon/core.c
@@ -504,6 +504,7 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->next_ops_update_sis = 0;
 
 	mutex_init(&ctx->kdamond_lock);
+	mutex_init(&ctx->call_control_lock);
 
 	ctx->attrs.min_nr_regions = 10;
 	ctx->attrs.max_nr_regions = 1000;
@@ -1162,6 +1163,54 @@ int damon_stop(struct damon_ctx **ctxs,
 	return err;
 }
 
+static bool damon_is_running(struct damon_ctx *ctx)
+{
+	bool running;
+
+	mutex_lock(&ctx->kdamond_lock);
+	running = ctx->kdamond != NULL;
+	mutex_unlock(&ctx->kdamond_lock);
+	return running;
+}
+
+/**
+ * damon_call() - Invoke a given function on DAMON worker thread (kdamond).
+ * @ctx:	DAMON context to call the function for.
+ * @control:	Control variable of the call request.
+ *
+ * Ask DAMON worker thread (kdamond) of @ctx to call a function with an
+ * argument data that respectively passed via &damon_call_control->fn and
+ * &damon_call_control->data of @control, and wait until the kdamond finishes
+ * handling of the request.
+ *
+ * The kdamond executes the function with the argument in the main loop, just
+ * after a sampling of the iteration is finished.  The function can hence
+ * safely access the internal data of the &struct damon_ctx without additional
+ * synchronization.  The return value of the function will be saved in
+ * &damon_call_control->return_code.
+ *
+ * Return: 0 on success, negative error code otherwise.
+ */
+int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
+{
+	init_completion(&control->completion);
+	control->canceled = false;
+
+	mutex_lock(&ctx->call_control_lock);
+	if (ctx->call_control) {
+		mutex_unlock(&ctx->call_control_lock);
+		return -EBUSY;
+	}
+	ctx->call_control = control;
+	mutex_unlock(&ctx->call_control_lock);
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
@@ -1917,6 +1966,39 @@ static void kdamond_usleep(unsigned long
 		usleep_range_idle(usecs, usecs + 1);
 }
 
+/*
+ * kdamond_call() - handle damon_call_control.
+ * @ctx:	The &struct damon_ctx of the kdamond.
+ * @cancel:	Whether to cancel the invocation of the function.
+ *
+ * If there is a &struct damon_call_control request that registered via
+ * &damon_call() on @ctx, do or cancel the invocation of the function depending
+ * on @cancel.  @cancel is set when the kdamond is deactivated by DAMOS
+ * watermarks, or the kdamond is already out of the main loop and therefore
+ * will be terminated.
+ */
+static void kdamond_call(struct damon_ctx *ctx, bool cancel)
+{
+	struct damon_call_control *control;
+	int ret = 0;
+
+	mutex_lock(&ctx->call_control_lock);
+	control = ctx->call_control;
+	mutex_unlock(&ctx->call_control_lock);
+	if (!control)
+		return;
+	if (cancel) {
+		control->canceled = true;
+	} else {
+		ret = control->fn(control->data);
+		control->return_code = ret;
+	}
+	complete(&control->completion);
+	mutex_lock(&ctx->call_control_lock);
+	ctx->call_control = NULL;
+	mutex_unlock(&ctx->call_control_lock);
+}
+
 /* Returns negative error code if it's not activated but should return */
 static int kdamond_wait_activation(struct damon_ctx *ctx)
 {
@@ -1941,6 +2023,7 @@ static int kdamond_wait_activation(struc
 		if (ctx->callback.after_wmarks_check &&
 				ctx->callback.after_wmarks_check(ctx))
 			break;
+		kdamond_call(ctx, true);
 	}
 	return -EBUSY;
 }
@@ -2011,6 +2094,7 @@ static int kdamond_fn(void *data)
 		if (ctx->callback.after_sampling &&
 				ctx->callback.after_sampling(ctx))
 			break;
+		kdamond_call(ctx, false);
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
@@ -2072,6 +2156,8 @@ done:
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
 
+	kdamond_call(ctx, true);
+
 	mutex_lock(&damon_lock);
 	nr_running_ctxs--;
 	if (!nr_running_ctxs && running_exclusive_ctxs)
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

