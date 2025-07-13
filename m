Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B063021C9F5
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450119; cv=none; b=BDoHRZc30OyoIc+hqZKHLC0SUoFs+baDsrY6jWijVcs2ttSgczDmNsVz5fofs78UtgcYam8BC24r7Rlyml8Zec5+hJRTOMyBbyU7H8crfIkspiqUkH/B/W8JiGi+kLqwb9HCQx40qofCHj5WEUhMpGrx9QrevX72zGTuWJQ7pE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450119; c=relaxed/simple;
	bh=YEwCMdiPAzOmkD4MW+OdZCU+PTQo7yUNnnDPn2PHm04=;
	h=Date:To:From:Subject:Message-Id; b=PJQjUImFiLrTpSDb1xjUDojF88oWvsTyCNnnmrehY49PIaaIaxP7/jkyUyn1Omgd1lYNtb7T8jNcYtRe9Eb60hh92MtuspTCuGeT8p8Pw80oFSjrUkehj+Wbdor+ndu2R8z1jNJwgDRy2J0zST8DGGNzpyTG+tTVABVcz36znOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=enKc+yJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="enKc+yJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88436C4CEE3;
	Sun, 13 Jul 2025 23:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450119;
	bh=YEwCMdiPAzOmkD4MW+OdZCU+PTQo7yUNnnDPn2PHm04=;
	h=Date:To:From:Subject:From;
	b=enKc+yJYNjYX4MlijdJmy0YyvVd9C9YrsPjGNLIJ0qBBJHbUZWACXl3HWUd/RfTRO
	 SOq0GVnpaPqUaejR9kyseYDxhd+a6hIt8RCwwHOcpZFX8j0ktoHdftdq3LiOL1sMHu
	 H3sp7iElQjpOFA4sTxzfSBFqt0qtDBm+xyhMoBHY=
Date: Sun, 13 Jul 2025 16:41:59 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch removed from -mm tree
Message-Id: <20250713234159.88436C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: reset enabled when DAMON start failed
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: reset enabled when DAMON start failed
Date: Sun, 6 Jul 2025 12:32:05 -0700

When the startup fails, 'enabled' parameter is not reset.  As a result,
users show the parameter 'Y' while it is not really working.  Fix it by
resetting 'enabled' to 'false' when the work is failed.

Link: https://lkml.kernel.org/r/20250706193207.39810-5-sj@kernel.org
Fixes: 04e98764befa ("mm/damon/reclaim: enable and disable synchronously")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-reset-enabled-when-damon-start-failed
+++ a/mm/damon/reclaim.c
@@ -329,7 +329,7 @@ static int __init damon_reclaim_init(voi
 	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
 
 	if (err)
-		return err;
+		goto out;
 
 	ctx->callback.after_wmarks_check = damon_reclaim_after_wmarks_check;
 	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
@@ -338,6 +338,9 @@ static int __init damon_reclaim_init(voi
 	if (enabled)
 		err = damon_reclaim_turn(true);
 
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

