Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C029225771
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752357986; cv=none; b=Lp5eDWcdbOjBgiJd6pbmQn+QVGJv3mvZTKI4Z/u754C1LyJlLxec08P7MkmIaXQiDuTVo/+63tbCqEsUc9XIBl8LWNOHk5ST2HQU+yCxr1mThMtmtONvINwzmDjpaHtNlz0q/uyX5LjjXsk3UEKhvQvZL3QwCg3rImaM86c8KSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752357986; c=relaxed/simple;
	bh=56sCSPSKDaVF20B4aHZWIg6/u2E8RqI/uWkL8YmGaCI=;
	h=Date:To:From:Subject:Message-Id; b=Q/ZzQ/X8L/PDtMfjXo6ZrcPJdQhutDcy+RjM2gPObmTIUlEOpXe6GyJy8UmtFQRglK4Iehw25fvypfN7p/F61uJfPwo4QwJ6AKdTWxHo4W2nYUjHff28h/aCYBA1guXFhCURu1g0sY4WHoqYWHfmMiL2wuHfZ1AvBSWF9U/X6EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D7Ad1tSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D7Ad1tSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3DCC4CEEF;
	Sat, 12 Jul 2025 22:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752357986;
	bh=56sCSPSKDaVF20B4aHZWIg6/u2E8RqI/uWkL8YmGaCI=;
	h=Date:To:From:Subject:From;
	b=D7Ad1tSF6JHxsfS0b78a7RyenyqVxWJlwHwBNIkVnp078vaB55SNrMcEocNYZMF7P
	 y0FVm1CGby5QWw+M90HpyJLSlpFwAaKQ8td42MCeFDhockxPKnJ/RMH9K5l19cmQgp
	 qM3bPqkEJr67hxXHiKchbR+iIMLzKzDZ+LWWVB8A=
Date: Sat, 12 Jul 2025 15:06:25 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch added to mm-new branch
Message-Id: <20250712220626.2E3DCC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: use damon_call() repeat mode instead of damon_callback
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch

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
Subject: mm/damon/lru_sort: use damon_call() repeat mode instead of damon_callback
Date: Sat, 12 Jul 2025 12:50:07 -0700

DAMON_LRU_SORT uses damon_callback for periodically reading and writing
DAMON internal data and parameters.  Use its alternative, damon_call()
repeat mode.

Link: https://lkml.kernel.org/r/20250712195016.151108-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   70 +++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback
+++ a/mm/damon/lru_sort.c
@@ -230,6 +230,39 @@ out:
 	return err;
 }
 
+static int damon_lru_sort_handle_commit_inputs(void)
+{
+	int err;
+
+	if (!commit_inputs)
+		return 0;
+
+	err = damon_lru_sort_apply_parameters();
+	commit_inputs = false;
+	return err;
+}
+
+static int damon_lru_sort_damon_call_fn(void *arg)
+{
+	struct damon_ctx *c = arg;
+	struct damos *s;
+
+	/* update the stats parameter */
+	damon_for_each_scheme(s, c) {
+		if (s->action == DAMOS_LRU_PRIO)
+			damon_lru_sort_hot_stat = s->stat;
+		else if (s->action == DAMOS_LRU_DEPRIO)
+			damon_lru_sort_cold_stat = s->stat;
+	}
+
+	return damon_lru_sort_handle_commit_inputs();
+}
+
+static struct damon_call_control call_control = {
+	.fn = damon_lru_sort_damon_call_fn,
+	.repeat = true,
+};
+
 static int damon_lru_sort_turn(bool on)
 {
 	int err;
@@ -249,7 +282,7 @@ static int damon_lru_sort_turn(bool on)
 	if (err)
 		return err;
 	kdamond_pid = ctx->kdamond->pid;
-	return 0;
+	return damon_call(ctx, &call_control);
 }
 
 static int damon_lru_sort_enabled_store(const char *val,
@@ -288,38 +321,6 @@ module_param_cb(enabled, &enabled_param_
 MODULE_PARM_DESC(enabled,
 	"Enable or disable DAMON_LRU_SORT (default: disabled)");
 
-static int damon_lru_sort_handle_commit_inputs(void)
-{
-	int err;
-
-	if (!commit_inputs)
-		return 0;
-
-	err = damon_lru_sort_apply_parameters();
-	commit_inputs = false;
-	return err;
-}
-
-static int damon_lru_sort_after_aggregation(struct damon_ctx *c)
-{
-	struct damos *s;
-
-	/* update the stats parameter */
-	damon_for_each_scheme(s, c) {
-		if (s->action == DAMOS_LRU_PRIO)
-			damon_lru_sort_hot_stat = s->stat;
-		else if (s->action == DAMOS_LRU_DEPRIO)
-			damon_lru_sort_cold_stat = s->stat;
-	}
-
-	return damon_lru_sort_handle_commit_inputs();
-}
-
-static int damon_lru_sort_after_wmarks_check(struct damon_ctx *c)
-{
-	return damon_lru_sort_handle_commit_inputs();
-}
-
 static int __init damon_lru_sort_init(void)
 {
 	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
@@ -327,8 +328,7 @@ static int __init damon_lru_sort_init(vo
 	if (err)
 		goto out;
 
-	ctx->callback.after_wmarks_check = damon_lru_sort_after_wmarks_check;
-	ctx->callback.after_aggregation = damon_lru_sort_after_aggregation;
+	call_control.data = ctx;
 
 	/* 'enabled' has set before this function, probably via command line */
 	if (enabled)
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

