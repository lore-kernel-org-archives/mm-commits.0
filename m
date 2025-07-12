Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF1CB225771
	for <mm-commits@vger.kernel.org>; Sat, 12 Jul 2025 22:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752358000; cv=none; b=N778IM+WPEkw3Jy8GWpZjsx3NPvcoi1h/+A0etliDSmDVcKh/GbRAJtdN9BOuV4bhxxXFUmejWqo7CtC3YKJyacm689WHNuKEgcM5/xO333m4OvtimGn4/5JRyubipb2Lei83NmX9iJTWOAQa9Kye1CQ0bZaIILlZsrGJpq5SFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752358000; c=relaxed/simple;
	bh=XxGp5oIUuBRioVK6iCw6eV2EUTdL5dWgf6z8v1AM72Q=;
	h=Date:To:From:Subject:Message-Id; b=jvA0byvEcRYnPvf1/sZ5daD+Tva5/mnc7jmxlO1nOZiwHCTDS3Fao8B+lG29kos4t/Git5jP4nYRSo7Gwj+8Nspcf63urLVj9X2UpQMl5uC04Yo3vISTM9Jv5CagyzNiOBMpGOkkhX6MbP7oslV60GqhDv6tIV62ZioIvclU4Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NgcTF5FX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NgcTF5FX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EE4C4CEEF;
	Sat, 12 Jul 2025 22:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752358000;
	bh=XxGp5oIUuBRioVK6iCw6eV2EUTdL5dWgf6z8v1AM72Q=;
	h=Date:To:From:Subject:From;
	b=NgcTF5FXpnSLfraHSTeCq1PsFdusxnvqRWWNfCpwbsHBzcaftaJN50NhSxnzKA6Jz
	 WeAeg8ar2Fkb0EyJFC7npKm+LGeCBMVOB9N8b0IllVrqiJjUj394+ZI6aChUkev/H5
	 p8rrBMJZFYD/OGr3KsLYZcWysJuN2rRC5wLaD4l4=
Date: Sat, 12 Jul 2025 15:06:40 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch added to mm-new branch
Message-Id: <20250712220640.A2EE4C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: remove damon_sysfs_destroy_targets()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch

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
Subject: mm/damon/sysfs: remove damon_sysfs_destroy_targets()
Date: Sat, 12 Jul 2025 12:50:13 -0700

The function was introduced for putting pids and deallocating unnecessary
targets.  Hence it is called before damon_destroy_ctx().  Now vaddr puts
pid for each target destruction (cleanup_target()).  damon_destroy_ctx()
deallocates the targets anyway.  So damon_sysfs_destroy_targets() has no
reason to exist.  Remove it.

Link: https://lkml.kernel.org/r/20250712195016.151108-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-damon_sysfs_destroy_targets
+++ a/mm/damon/sysfs.c
@@ -1295,14 +1295,6 @@ static int damon_sysfs_set_attrs(struct
 	return damon_set_attrs(ctx, &attrs);
 }
 
-static void damon_sysfs_destroy_targets(struct damon_ctx *ctx)
-{
-	struct damon_target *t, *next;
-
-	damon_for_each_target_safe(t, next, ctx)
-		damon_destroy_target(t, ctx);
-}
-
 static int damon_sysfs_set_regions(struct damon_target *t,
 		struct damon_sysfs_regions *sysfs_regions)
 {
@@ -1337,7 +1329,6 @@ static int damon_sysfs_add_target(struct
 		struct damon_ctx *ctx)
 {
 	struct damon_target *t = damon_new_target();
-	int err = -EINVAL;
 
 	if (!t)
 		return -ENOMEM;
@@ -1345,16 +1336,10 @@ static int damon_sysfs_add_target(struct
 	if (damon_target_has_pid(ctx)) {
 		t->pid = find_get_pid(sys_target->pid);
 		if (!t->pid)
-			goto destroy_targets_out;
+			/* caller will destroy targets */
+			return -EINVAL;
 	}
-	err = damon_sysfs_set_regions(t, sys_target->regions);
-	if (err)
-		goto destroy_targets_out;
-	return 0;
-
-destroy_targets_out:
-	damon_sysfs_destroy_targets(ctx);
-	return err;
+	return damon_sysfs_set_regions(t, sys_target->regions);
 }
 
 static int damon_sysfs_add_targets(struct damon_ctx *ctx,
@@ -1458,13 +1443,11 @@ static int damon_sysfs_commit_input(void
 	test_ctx = damon_new_ctx();
 	err = damon_commit_ctx(test_ctx, param_ctx);
 	if (err) {
-		damon_sysfs_destroy_targets(test_ctx);
 		damon_destroy_ctx(test_ctx);
 		goto out;
 	}
 	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
 out:
-	damon_sysfs_destroy_targets(param_ctx);
 	damon_destroy_ctx(param_ctx);
 	return err;
 }
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

