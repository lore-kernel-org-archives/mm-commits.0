Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591BB140E30
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735958714; cv=none; b=K0X5fFpI5OiRc07m9ZQLxpDhwQ8Xx0w+AThwqbICC1Offdt57tVdZPJhxTvqbxE/bpbG9KlmKwSczwk+90A4HLwlNBtpgRNs0qbEyv/c2ZT7oqxgGQK1oxH3H5oWhrFx7sIU0elbUnqgpCYwDvz9vAUfZd8UhjhOrMSm5W/YBpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735958714; c=relaxed/simple;
	bh=npFCZ1KC+GpHHHZU0anPhDKaYQM0gXkaUr9PyfjxwW4=;
	h=Date:To:From:Subject:Message-Id; b=WAPoMbd1N7Txxc3cGbuB9lKnmfy9VPNhip2g7bN+04EcjfhBZ/xkiThkXMv3FuhY9kfBKbN3NEWBAaf/AlySKn9jCppPTsNzSyn9Ttm5BbuJ0EYR9yLfNdCWKKqpRjeTEGd+N30lXwJOHmpv3DPHTMHbXdMuwUP6SBXqImfqJf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GUkX71qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GUkX71qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275B2C4CEDD;
	Sat,  4 Jan 2025 02:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735958714;
	bh=npFCZ1KC+GpHHHZU0anPhDKaYQM0gXkaUr9PyfjxwW4=;
	h=Date:To:From:Subject:From;
	b=GUkX71qyET8XPRVCEhUFioCdAHj73nkk8gJ2Xt5C7SnvdPpQykFSGOpyade7PO2xJ
	 GJMEGI13LA7SNXke9xUF9K8TIWKhPFfXTOWznB61tR+bqcmzZfmI1qxzGC3n0GfGr+
	 njIEfdOhDj8ObxBICHMJ/B3wzMmlfoewepU83vrg=
Date: Fri, 03 Jan 2025 18:45:13 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-damon_call.patch added to mm-unstable branch
Message-Id: <20250104024514.275B2C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce damon_call()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-introduce-damon_call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damon_call.patch

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

