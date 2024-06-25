Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA75C14373B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291738; cv=none; b=VtgnZ0o6120GioklcxAMjM0r9OMxrz/vRbVHp2Z4tcIvimmaUbJbUvrddW9+JFQ3OR4y8lMzF3elhtg38cZzWuxSAzoJE/WsiKUODjqJdVBnNxb1kLVubeySdWfiZJcTyfVCnn5ab4JMoVt0Y09U9j5sXdAkeTF8QrWJCpACMlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291738; c=relaxed/simple;
	bh=NECsFcBMfwVWvvSh9ZRdxHYVeq/elnJJB8g67ptTEvo=;
	h=Date:To:From:Subject:Message-Id; b=H2CAiG5lE2hmL+o2EZy2RcGdi2wYoTV6tyhJn26WU4054mg+S9dDnvNW9TjYtQcnzOmokaEmyZ0c3DviuSTsOH9mr8rHZrS+hdVz4kW0rRAeJt7Y+0f7xmPmnixVxf/CbrnlszHWmaEfHwEyc7uXx3IgqHGI5IRrP15NjEkmfyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r9RsgDgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r9RsgDgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77093C32782;
	Tue, 25 Jun 2024 05:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291738;
	bh=NECsFcBMfwVWvvSh9ZRdxHYVeq/elnJJB8g67ptTEvo=;
	h=Date:To:From:Subject:From;
	b=r9RsgDgn8DZ5h+keVjEkOZAUQ//k3dMnys6EDjw7mULCcs2OuCkMlHJPIv4JxXTcQ
	 1cq670XYpBxsP8F04kuqDukPmd6Z2qBAuTlIosqBOPaTOtGy5PUVWLzNe/Hv8exQPb
	 txzAUNv/lYvytFlY9aBNp6wjNRIomgZLDVvjiAhQ=
Date: Mon, 24 Jun 2024 22:02:17 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch removed from -mm tree
Message-Id: <20240625050218.77093C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: remove unnecessary online tuning handling code
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

