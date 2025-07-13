Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D018621C9F5
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450120; cv=none; b=GSvU3vHNqvPxnaTwmih+juYeMsbwyF3zIVZY/u/wRpCUWMtyYrHAluHWBq45S3pf8fX/LqRox1/KZzmJT6ki1e0Yy/LsRwmEmttSDF5xhtSPe8vPw0x+VeBgQ4bYQ8DS6WzoJRTIYp/jcnb3MXVbYzpEufLQQZuVxAhiUdIGEiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450120; c=relaxed/simple;
	bh=Ix9ivIpN2wS4oY0ZEIITSv3rNK/bx4cZX22AfY1JweM=;
	h=Date:To:From:Subject:Message-Id; b=C8Ua1278Ze9bPrB0++9hnY20tkfX6rpwBFSkKmaj/9z2misRYLPo2LDrmJ50XzAJF20mnudldVS6oZV3SCCCX9cXctQ0x5dD3cQwMGVjH0xAMflbTXmN5uxpzTF4AYoobvcd2u7DPcfiCZF+pADG3/Q0NzVtYI/aQnLvFCkUDQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MoJQNm6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MoJQNm6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7015C4CEE3;
	Sun, 13 Jul 2025 23:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450120;
	bh=Ix9ivIpN2wS4oY0ZEIITSv3rNK/bx4cZX22AfY1JweM=;
	h=Date:To:From:Subject:From;
	b=MoJQNm6mjOrlDWAddJG0senHuEK6km+tE24wdUUxm0ApqyfhjX5tZDsHWGgMQVJfK
	 d8Greb0upU0jgGZvUrjh1CVL4v0a6/tDTfeopFDfT3KkoIQS4QbsVK8YR8KNtCi5zY
	 Y0GIbgVax2r0RcCNljMKvuo2eXdvu/yCzrtHiuSs=
Date: Sun, 13 Jul 2025 16:42:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch removed from -mm tree
Message-Id: <20250713234200.A7015C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: reset enabled when DAMON start failed
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: reset enabled when DAMON start failed
Date: Sun, 6 Jul 2025 12:32:06 -0700

When the startup fails, 'enabled' parameter is not reset.  As a result,
users show the parameter 'Y' while it is not really working.  Fix it by
resetting 'enabled' to 'false' when the work is failed.

Link: https://lkml.kernel.org/r/20250706193207.39810-6-sj@kernel.org
Fixes: 7a034fbba336 ("mm/damon/lru_sort: enable and disable synchronously")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-reset-enabled-when-damon-start-failed
+++ a/mm/damon/lru_sort.c
@@ -325,7 +325,7 @@ static int __init damon_lru_sort_init(vo
 	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
 
 	if (err)
-		return err;
+		goto out;
 
 	ctx->callback.after_wmarks_check = damon_lru_sort_after_wmarks_check;
 	ctx->callback.after_aggregation = damon_lru_sort_after_aggregation;
@@ -334,6 +334,9 @@ static int __init damon_lru_sort_init(vo
 	if (enabled)
 		err = damon_lru_sort_turn(true);
 
+out:
+	if (err && enabled)
+		enabled = false;
 	return err;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

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

