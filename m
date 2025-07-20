Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3CC1537A7
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976945; cv=none; b=pbltarRIfFoAOd/E4AQq8AUz55ekDOLrJfiTzH85CoSYcOaFMYIhGP2CBTvALDRFN1TFB8PBbmZEAHHVhWX35fWw6t9oylOetjeNje0+5aOyG8lV3NabGQmU0uPpGUm9VkedwKlPbbunL+KCqXj6rJ6IDKy/h1jfaDO0da+OyZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976945; c=relaxed/simple;
	bh=Ve4rccE03rYz7qNtDrr03JhqLteB034zl2DWgMBRoGU=;
	h=Date:To:From:Subject:Message-Id; b=Vqw8/SWh++xQZhOEbHjlWiLH3HHSuf5GyLWuyxcwcjtCYWqUMfJAZaMVDm8BfbG/CdbPN7TyzUZUidGJ6YJ5bi+PUZtb9vACjAhf5q070sY1vTGRL2+8qnqv+OpRieLvkaFuLPrrPz/ld6wunOP4eE4qhRu98R+97zes9ClWrao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vdxO6qKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vdxO6qKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A11C4CEE3;
	Sun, 20 Jul 2025 02:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976945;
	bh=Ve4rccE03rYz7qNtDrr03JhqLteB034zl2DWgMBRoGU=;
	h=Date:To:From:Subject:From;
	b=vdxO6qKhxZIghPVVMoqpvpj4U5jgxOCgNQHXXDPfgkJJCrMEywYsl0fPkVHuMlYOP
	 MIyFwnfQyEWKKh31kmXT3vLTaFWX5/LE1dvsZ9SV40aN20ZosYBI/mnOC8S5bPwrKc
	 d0xwpj3ptvfaJGGXJcPyzcxtemGEMOPNnLY8OgIQ=
Date: Sat, 19 Jul 2025 19:02:25 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch removed from -mm tree
Message-Id: <20250720020225.A3A11C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: remove damon_sysfs_before_terminate()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: remove damon_sysfs_before_terminate()
Date: Sat, 12 Jul 2025 12:50:15 -0700

DAMON core layer does target cleanup on its own.  Remove duplicated and
unnecessarily selective cleanup attempts in DAMON sysfs interface.

Link: https://lkml.kernel.org/r/20250712195016.151108-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-damon_sysfs_before_terminate
+++ a/mm/damon/sysfs.c
@@ -1361,17 +1361,6 @@ static int damon_sysfs_add_targets(struc
 	return 0;
 }
 
-static void damon_sysfs_before_terminate(struct damon_ctx *ctx)
-{
-	struct damon_target *t, *next;
-
-	if (!damon_target_has_pid(ctx))
-		return;
-
-	damon_for_each_target_safe(t, next, ctx)
-		damon_destroy_target(t, ctx);
-}
-
 /*
  * damon_sysfs_upd_schemes_stats() - Update schemes stats sysfs files.
  * @data:	The kobject wrapper that associated to the kdamond thread.
@@ -1516,7 +1505,6 @@ static struct damon_ctx *damon_sysfs_bui
 		return ERR_PTR(err);
 	}
 
-	ctx->callback.before_terminate = damon_sysfs_before_terminate;
 	return ctx;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

