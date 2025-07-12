Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D25225771
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752357988; cv=none; b=EF/m/H7OVAu0exbVNYeWQpNgYY3u1GbDWl1Zslc7taWidmeoWUESjb50EuDZhlqEW/f16B/ZGJQJkrjONE3IOXN9K4Bi7a735wFcMKobdpAWoLe4ULe58tQQc3l6yGhNJQo5ik9RthbtTWkUjgWnxsU1cQYWgdk5wXDQpncW0oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752357988; c=relaxed/simple;
	bh=CeztcWIlrcr3MBOovGVRdNDkhdfbc6A2IlU/Ot6TIhM=;
	h=Date:To:From:Subject:Message-Id; b=dLKUBH28lNlwnrFNI9kQsjgYrPFha1efup7fi/28/1Sb3/PH11IM7U3V2B38gP2bEaTaYNrYRfUxfY/WIKhL2dYHHcgZqWtn1qdBQ9sTaCdtTP08IZ7N16+JaaqDziObJuop0YWnrA0zMvs3ijbR0jgEGuxyVq78knfLRE5d2fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UgUoxlu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UgUoxlu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19551C4CEEF;
	Sat, 12 Jul 2025 22:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752357988;
	bh=CeztcWIlrcr3MBOovGVRdNDkhdfbc6A2IlU/Ot6TIhM=;
	h=Date:To:From:Subject:From;
	b=UgUoxlu6AX8kjkweOxeOKqr+Rcz6jNV0Vv0AB6gyj6acOZ9D5qhNst8lMBgPrnnhF
	 mwRr+/7LzAwue9k9xTzE0dn51GZosmbm8kz79PGSyjr9Yd5nvyxZq4ChXEEN++FfUr
	 z8U3qOjptDcML+Ao3dV8pM2lPIyc52IHpE8LTP7k=
Date: Sat, 12 Jul 2025 15:06:27 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch added to mm-new branch
Message-Id: <20250712220628.19551C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/prcl: use damon_call() repeat mode instead of damon_callback
has been added to the -mm mm-new branch.  Its filename is
     samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch

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
Subject: samples/damon/prcl: use damon_call() repeat mode instead of damon_callback
Date: Sat, 12 Jul 2025 12:50:08 -0700

prcl uses damon_callback for periodically reading DAMON internal data. 
Use its alternative, damon_call() repeat mode.

Link: https://lkml.kernel.org/r/20250712195016.151108-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/samples/damon/prcl.c~samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback
+++ a/samples/damon/prcl.c
@@ -34,8 +34,9 @@ MODULE_PARM_DESC(enabled, "Enable or dis
 static struct damon_ctx *ctx;
 static struct pid *target_pidp;
 
-static int damon_sample_prcl_after_aggregate(struct damon_ctx *c)
+static int damon_sample_prcl_repeat_call_fn(void *data)
 {
+	struct damon_ctx *c = data;
 	struct damon_target *t;
 
 	damon_for_each_target(t, c) {
@@ -51,10 +52,16 @@ static int damon_sample_prcl_after_aggre
 	return 0;
 }
 
+static struct damon_call_control repeat_call_control = {
+	.fn = damon_sample_prcl_repeat_call_fn,
+	.repeat = true,
+};
+
 static int damon_sample_prcl_start(void)
 {
 	struct damon_target *target;
 	struct damos *scheme;
+	int err;
 
 	pr_info("start\n");
 
@@ -79,8 +86,6 @@ static int damon_sample_prcl_start(void)
 	}
 	target->pid = target_pidp;
 
-	ctx->callback.after_aggregation = damon_sample_prcl_after_aggregate;
-
 	scheme = damon_new_scheme(
 			&(struct damos_access_pattern) {
 			.min_sz_region = PAGE_SIZE,
@@ -100,7 +105,12 @@ static int damon_sample_prcl_start(void)
 	}
 	damon_set_schemes(ctx, &scheme, 1);
 
-	return damon_start(&ctx, 1, true);
+	err = damon_start(&ctx, 1, true);
+	if (err)
+		return err;
+
+	repeat_call_control.data = ctx;
+	return damon_call(ctx, &repeat_call_control);
 }
 
 static void damon_sample_prcl_stop(void)
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

