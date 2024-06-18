Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C98158DBA
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718739396; cv=none; b=TGK/NaOQdKq94NtFHochSJjSv8MUU8pRuiq5rbltYi75MEDTx/u3lByuhGY8n1/HU8oEWQzS3Bfdt4KJ3VXMzHGOjtc33oEkrWRSbxqnPDgIgcSvh841sClaI6zdXgP+gJXmtknTAY6GqWWxJ4dO6YhdgMyNgtxz1Q7Fd0epWis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718739396; c=relaxed/simple;
	bh=z60YUHVSMA5yWFEKp1IAKSczCvYkkt0raL7ZZc743j8=;
	h=Date:To:From:Subject:Message-Id; b=QrhoHUs6ZRQbJdLD7t1vnG2tBjLVRExVeOje2UTgBKEEgM2YL7w3OWX84989RcPMSHqKFQzcxhW1P60B28rAe9AicBx3HRsWYk8k2bkfiM+AfmQI3OrnIHeaXcx1fxXHjztwth2FolVXOCkL0WS096qcrSx6jppvhe0El9ahmYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IWMJi28o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IWMJi28o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96ADDC3277B;
	Tue, 18 Jun 2024 19:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718739395;
	bh=z60YUHVSMA5yWFEKp1IAKSczCvYkkt0raL7ZZc743j8=;
	h=Date:To:From:Subject:From;
	b=IWMJi28oEVjmIILXMm47cdvD1wc7zYIh+ZslEA99R/gXQUJuxVARdx2vKO/KF2Siy
	 A5oLEf54uWg16m3jOIoDKeLfcnefe4fJHsSPhi8hb/kbn10bXEnSmsf8WCR0OSCQ3E
	 FwxC40GH2ztSy2tBlikRpMuWkiG5wU+9C2JEOkus=
Date: Tue, 18 Jun 2024 12:36:35 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch added to mm-unstable branch
Message-Id: <20240618193635.96ADDC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: remove unnecessary online tuning handling code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch

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
Subject: mm/damon/sysfs: remove unnecessary online tuning handling code
Date: Tue, 18 Jun 2024 11:18:02 -0700

damon/sysfs.c contains code for handling of online DAMON parameters update
edge cases.  It is no more necessary since damon_commit_ctx() takes care
of the cases.  Remove the unnecessary code.

Link: https://lkml.kernel.org/r/20240618181809.82078-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-test.h |    2 -
 mm/damon/sysfs.c      |   60 +---------------------------------------
 2 files changed, 3 insertions(+), 59 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code
+++ a/mm/damon/sysfs.c
@@ -1162,72 +1162,16 @@ destroy_targets_out:
 	return err;
 }
 
-static int damon_sysfs_update_target_pid(struct damon_target *target, int pid)
-{
-	struct pid *pid_new;
-
-	pid_new = find_get_pid(pid);
-	if (!pid_new)
-		return -EINVAL;
-
-	if (pid_new == target->pid) {
-		put_pid(pid_new);
-		return 0;
-	}
-
-	put_pid(target->pid);
-	target->pid = pid_new;
-	return 0;
-}
-
-static int damon_sysfs_update_target(struct damon_target *target,
-		struct damon_ctx *ctx,
-		struct damon_sysfs_target *sys_target)
-{
-	int err = 0;
-
-	if (damon_target_has_pid(ctx)) {
-		err = damon_sysfs_update_target_pid(target, sys_target->pid);
-		if (err)
-			return err;
-	}
-
-	/*
-	 * Do monitoring target region boundary update only if one or more
-	 * regions are set by the user.  This is for keeping current monitoring
-	 * target results and range easier, especially for dynamic monitoring
-	 * target regions update ops like 'vaddr'.
-	 */
-	if (sys_target->regions->nr)
-		err = damon_sysfs_set_regions(target, sys_target->regions);
-	return err;
-}
-
 static int damon_sysfs_set_targets(struct damon_ctx *ctx,
 		struct damon_sysfs_targets *sysfs_targets)
 {
-	struct damon_target *t, *next;
-	int i = 0, err;
+	int i, err;
 
 	/* Multiple physical address space monitoring targets makes no sense */
 	if (ctx->ops.id == DAMON_OPS_PADDR && sysfs_targets->nr > 1)
 		return -EINVAL;
 
-	damon_for_each_target_safe(t, next, ctx) {
-		if (i < sysfs_targets->nr) {
-			err = damon_sysfs_update_target(t, ctx,
-					sysfs_targets->targets_arr[i]);
-			if (err)
-				return err;
-		} else {
-			if (damon_target_has_pid(ctx))
-				put_pid(t->pid);
-			damon_destroy_target(t);
-		}
-		i++;
-	}
-
-	for (; i < sysfs_targets->nr; i++) {
+	for (i = 0; i < sysfs_targets->nr; i++) {
 		struct damon_sysfs_target *st = sysfs_targets->targets_arr[i];
 
 		err = damon_sysfs_add_target(st, ctx);
--- a/mm/damon/sysfs-test.h~mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code
+++ a/mm/damon/sysfs-test.h
@@ -62,7 +62,7 @@ static void damon_sysfs_test_set_targets
 	sysfs_target->pid = __damon_sysfs_test_get_any_pid(
 			sysfs_target->pid + 1, 200);
 	damon_sysfs_set_targets(ctx, sysfs_targets);
-	KUNIT_EXPECT_EQ(test, 1u, nr_damon_targets(ctx));
+	KUNIT_EXPECT_EQ(test, 2u, nr_damon_targets(ctx));
 
 	damon_destroy_ctx(ctx);
 	kfree(sysfs_targets->targets_arr);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-quota-goals-online-commit-function.patch
mm-damon-core-implement-damon-context-commit-function.patch
mm-damon-sysfs-use-damon_commit_ctx.patch
mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch
mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets.patch
mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch
mm-damon-reclaim-use-damon_commit_ctx.patch
mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch
mm-damon-lru_sort-use-damon_commit_ctx.patch
mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch

