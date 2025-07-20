Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7D0155C87
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976943; cv=none; b=sGBEH3Vgf5bz4BR+V+BUimuybUD0ztxPYzZP50GKO9e12dTmf95cw2yAqM3WCM5HpPyHCCDD5TNMnVLOuH/a85iSqNSVyf4FpdcrZ0hPycHs+6TnmoCFhikCO4xvLeZhJwOu9nYFJYuVzmwktc/+vcx9VCbQvrRSrGpZ4846Ouo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976943; c=relaxed/simple;
	bh=TMPJ5vIVE7NakMfRtn4xkbeWOp9L3BbXZF1jm2YF4b8=;
	h=Date:To:From:Subject:Message-Id; b=E8cGTf7K6s2f5DVFT1mx+tfOV0XyVKOYfm1WcvDYSq4q/JrqBRPLi9C0pSIRzXWMi0+txHIguA6LGVofit7oN+RCvfXV5usIfqEgKIOzXY1asmkvds10kkN03pVhArv9UzZxYzECEUnoZSmeHtocKHJnHFvd16qepL0pAx+4/6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kYg6a/za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kYg6a/za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB304C4CEE3;
	Sun, 20 Jul 2025 02:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976942;
	bh=TMPJ5vIVE7NakMfRtn4xkbeWOp9L3BbXZF1jm2YF4b8=;
	h=Date:To:From:Subject:From;
	b=kYg6a/zanYdvvOaFGPU2gWmZG0AsF6ffMhnQ7lbTKAwqnhK9hTaXle5kOjDmqneo7
	 Es7clYgXXXs62/5Wc9/9fR2BEhHm6TkrF/qi1pNaIOoceypAqDDdmJjWvjMn8mcprI
	 8F98Xu0+vBP+yVSczxYhzavImLfQWe1oJVvQ77Rw=
Date: Sat, 19 Jul 2025 19:02:22 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch removed from -mm tree
Message-Id: <20250720020222.AB304C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: remove damon_sysfs_destroy_targets()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

