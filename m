Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A42B225771
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752357990; cv=none; b=aEtOh1nQvUZo0dlLdPqQvlIbRMwWC+2dDeZW/YBvmGbYWT2JhIN1AwP33ld+oHIhE/cxC+WXXNHqqvrffK4Cm6jC1C1C6aWxS/TTudTaxk8DTICqCZ6u1FjyPFN9BDyoW926n40BGONKG9tIpIEw89uQYt0x8AxAFdrxI9Wjx7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752357990; c=relaxed/simple;
	bh=PNfjIDX9CyQ2QwNuSw0V1dFkfA1n7kw1Mfm/jjy/aQ4=;
	h=Date:To:From:Subject:Message-Id; b=hlA64LoyRymBG/2bBW9T6lXzF6KQrdtgwBRqLta2MigJCK2s3z9vP109FpdW38CSwVg/13mdiSoITo04NwXG5EBTnHHqbiK3fShwiZSdEzYr5sgVEAZZeCdlQa4J5HJMxEYTqZnsDbC1pydPeem8M990THgifk9efKU4jNCMK7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JQrJZEEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JQrJZEEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F81C4CEEF;
	Sat, 12 Jul 2025 22:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752357990;
	bh=PNfjIDX9CyQ2QwNuSw0V1dFkfA1n7kw1Mfm/jjy/aQ4=;
	h=Date:To:From:Subject:From;
	b=JQrJZEEAkn/nSURLUnQID3teqGiRKqqqr26UT5oxVRBJ0uYGaduavJr5iOux4tRd5
	 xZTBlgUZR8IlFun8nLrV4gy8NUGO+Xqp+IolSab5A/EH/WQ9hzrm296k7WDi/yG0W3
	 5WdC0fEDt2vSseEHB1SznwlcHt76oYzE2GzSxsO4=
Date: Sat, 12 Jul 2025 15:06:29 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch added to mm-new branch
Message-Id: <20250712220630.09F81C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/wsse: use damon_call() repeat mode instead of damon_callback
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch

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
Subject: samples/damon/wsse: use damon_call() repeat mode instead of damon_callback
Date: Sat, 12 Jul 2025 12:50:09 -0700

wsse uses damon_callback for periodically reading DAMON internal data. 
Use its alternative, damon_call() repeat mode.

Link: https://lkml.kernel.org/r/20250712195016.151108-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/wsse.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/samples/damon/wsse.c~samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback
+++ a/samples/damon/wsse.c
@@ -35,8 +35,9 @@ MODULE_PARM_DESC(enabled, "Enable or dis
 static struct damon_ctx *ctx;
 static struct pid *target_pidp;
 
-static int damon_sample_wsse_after_aggregate(struct damon_ctx *c)
+static int damon_sample_wsse_repeat_call_fn(void *data)
 {
+	struct damon_ctx *c = data;
 	struct damon_target *t;
 
 	damon_for_each_target(t, c) {
@@ -52,9 +53,15 @@ static int damon_sample_wsse_after_aggre
 	return 0;
 }
 
+static struct damon_call_control repeat_call_control = {
+	.fn = damon_sample_wsse_repeat_call_fn,
+	.repeat = true,
+};
+
 static int damon_sample_wsse_start(void)
 {
 	struct damon_target *target;
+	int err;
 
 	pr_info("start\n");
 
@@ -79,8 +86,11 @@ static int damon_sample_wsse_start(void)
 	}
 	target->pid = target_pidp;
 
-	ctx->callback.after_aggregation = damon_sample_wsse_after_aggregate;
-	return damon_start(&ctx, 1, true);
+	err = damon_start(&ctx, 1, true);
+	if (err)
+		return err;
+	repeat_call_control.data = ctx;
+	return damon_call(ctx, &repeat_call_control);
 }
 
 static void damon_sample_wsse_stop(void)
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

