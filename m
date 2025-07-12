Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D702522B8CF
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752357982; cv=none; b=s9FZoBwjOfLyrEE+QtHBHbbbGJ/qxvjsMpTT/HBuNOGRyGaiLfzNxWfV9yqxOCZ4EyDmR9dhNUY7LTxc7XX8njypUd2QBY+mt4fepj43FVZbEazawFBI+Fj3BIMJeeMufZA3qu+m3Xep9YIEYQ5JjL2mYLW8wVXh2SbzHzZqvao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752357982; c=relaxed/simple;
	bh=NYHrK8Y7CUzMkIat3/UWs41voDWegkKSJyeVnRghSws=;
	h=Date:To:From:Subject:Message-Id; b=YzVgX+vGcBlP6gOqmUmze8Dbjnlgy327LtEQ6xGoQd/Tw9gqCQx60HphMri0sxRpji2vxMRDjY6DxqP1URI6aBu/ku6VvS7FhJImlM2bhjfFHuHtEjjwRDeTVCANdiQzF1i9b3fSWx//fnoDMiauL2ZhGr1kapwbK19J3+XzJcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k56qONl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k56qONl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56659C4CEEF;
	Sat, 12 Jul 2025 22:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752357982;
	bh=NYHrK8Y7CUzMkIat3/UWs41voDWegkKSJyeVnRghSws=;
	h=Date:To:From:Subject:From;
	b=k56qONl31NSUSu7RKkhe+IVdibqsw9g/KxELMhWvf9Fk3jkwhV2gxtgVmFQe1MY1h
	 lMFUoafJV0gdQAJzMyMjKjblu7/16WsvF4On/zCcUcQyoS+X8Xsb3svpSBl6nV5iFo
	 +RZ2ul6YKjs6tN8Bs+ZMYR+HdWFEkeO8CF3rhnPk=
Date: Sat, 12 Jul 2025 15:06:21 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch added to mm-new branch
Message-Id: <20250712220622.56659C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: use damon_call() repeat mode instead of damon_callback
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch

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
Subject: mm/damon/stat: use damon_call() repeat mode instead of damon_callback
Date: Sat, 12 Jul 2025 12:50:05 -0700

DAMON_STAT uses damon_callback for periodically reading DAMON internal
data.  Use its alternative, damon_call() repeat mode.

Link: https://lkml.kernel.org/r/20250712195016.151108-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback
+++ a/mm/damon/stat.c
@@ -122,8 +122,9 @@ static void damon_stat_set_idletime_perc
 	kfree(sorted_regions);
 }
 
-static int damon_stat_after_aggregation(struct damon_ctx *c)
+static int damon_stat_damon_call_fn(void *data)
 {
+	struct damon_ctx *c = data;
 	static unsigned long last_refresh_jiffies;
 
 	/* avoid unnecessarily frequent stat update */
@@ -182,19 +183,29 @@ static struct damon_ctx *damon_stat_buil
 	damon_add_target(ctx, target);
 	if (damon_set_region_biggest_system_ram_default(target, &start, &end))
 		goto free_out;
-	ctx->callback.after_aggregation = damon_stat_after_aggregation;
 	return ctx;
 free_out:
 	damon_destroy_ctx(ctx);
 	return NULL;
 }
 
+static struct damon_call_control call_control = {
+	.fn = damon_stat_damon_call_fn,
+	.repeat = true,
+};
+
 static int damon_stat_start(void)
 {
+	int err;
+
 	damon_stat_context = damon_stat_build_ctx();
 	if (!damon_stat_context)
 		return -ENOMEM;
-	return damon_start(&damon_stat_context, 1, true);
+	err = damon_start(&damon_stat_context, 1, true);
+	if (err)
+		return err;
+	call_control.data = damon_stat_context;
+	return damon_call(damon_stat_context, &call_control);
 }
 
 static void damon_stat_stop(void)
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

