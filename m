Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D27225A47
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752357979; cv=none; b=VBFwPmEdNoxmVTiqCd995bPblcZWLRl7rd5E3MQjhklaIcSJ/udhg1dKQkwHVRJcYxPFTDZECXOe0/+G2t1m5QEWj1tZsVScR+ISnzhh35EPliXe0rfK5XX9RExfPCrotp+w/Ghm88eCwIxLpc6bsaWR7R5tU2XAmEqaOJ2vT+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752357979; c=relaxed/simple;
	bh=r4StPr+ViPib2lLAOo18JbpLRemX25tMa+Dv6LJEd74=;
	h=Date:To:From:Subject:Message-Id; b=HyoMjT4hogmw64/q/NK+8fYTJEInfuN7jPU/VsAy9zG1jClPXSiZYDiZPsZxTbb1TXYkf1MFzgvm2i19aC/nugSC2CJVr865ky8dYfkNROQiSUQRLBe14jo0CCiaP7EK8XnJa98smZvBziytPY74GCHaPUHexhEuSa4PrUnaPDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M0K2qOdV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M0K2qOdV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F0EC4CEEF;
	Sat, 12 Jul 2025 22:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752357977;
	bh=r4StPr+ViPib2lLAOo18JbpLRemX25tMa+Dv6LJEd74=;
	h=Date:To:From:Subject:From;
	b=M0K2qOdVsJfqUkZ2l5K6xY6xHxK/1JDzzXAfJmYaPzgnN3ppkkfmgjHRSFkCVn2TD
	 8JjWTrq78ZB0VoIRxLG0vXBIxNgL0P8gyhixw5kSLBTguH164RIV3W5klekLZgtMSe
	 D0yyArEVBKbsIfq6SPKJ7RLdzQZKsTdzBE3w34Qc=
Date: Sat, 12 Jul 2025 15:06:16 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-accept-parallel-damon_call-requests.patch added to mm-new branch
Message-Id: <20250712220617.76F0EC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: accept parallel damon_call() requests
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-accept-parallel-damon_call-requests.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-accept-parallel-damon_call-requests.patch

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

