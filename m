Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A992B13B298
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976870; cv=none; b=kv7k6VdXQMJA/4gbbqXbmbFlHH1UmzhkZSgRL8T/xeHhpondhJD/VfAAgCtIYBMF2yvO2ImjPwxZMniHtw4e0cS6+h5H9TkNQr3Ev3XVn6rQoEEEuayD8fogfyPd4ghbb0Znad+SZY+tFKbduD0BpxHwckXaEqTqQsBU9qzlEms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976870; c=relaxed/simple;
	bh=swwlArOgsPbUXcmAsSlRAVAgRimBxTH2TZCgIF1ItSo=;
	h=Date:To:From:Subject:Message-Id; b=u9Mn7qbN/1qOr4J3aGPcmyaK/f83cyIFMw0Bxlc67Ul8UEcmRr9DA7PbEMKuegbF2EAxMg2KXUIjqzThwVmAdlmMl6aycVwvfyAS+xvztN3q5f8y558h+QDPcznZNkhm7jxcKb9h9oDWQpgZy1asfAb001P925fR2MgVfeEk4YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kxucFCZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kxucFCZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AD39C4CEF4;
	Sun, 20 Jul 2025 02:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976870;
	bh=swwlArOgsPbUXcmAsSlRAVAgRimBxTH2TZCgIF1ItSo=;
	h=Date:To:From:Subject:From;
	b=kxucFCZifxBUWqc+5QYVzKmBkD3uCu575NeAQV5Pg8gUCAWU3kJLVZp+P8s4gQB2h
	 jaUxsKRPrsImLnWMeXZ88lY4WszvWJfxGJGZao8m9YTNXMAi8FwX1/br86vjLiAEEn
	 scTJCC0eyK7WDMF5zLy4Zrum2ESaQCQG5NMI1IBQ=
Date: Sat, 19 Jul 2025 19:01:09 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-use-damon-core-api-damon_is_running.patch removed from -mm tree
Message-Id: <20250720020110.7AD39C4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: use DAMON core API damon_is_running()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-use-damon-core-api-damon_is_running.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: use DAMON core API damon_is_running()
Date: Sat, 5 Jul 2025 10:49:58 -0700

DAMON core implements a static function to see if a given DAMON context is
running.  DAMON sysfs interface is implementing the same one on its own. 
Make the core function non-static and reuse it from the DAMON sysfs
interface.

Link: https://lkml.kernel.org/r/20250705175000.56259-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 mm/damon/core.c       |    8 +++++++-
 mm/damon/sysfs.c      |   14 ++------------
 3 files changed, 10 insertions(+), 13 deletions(-)

--- a/include/linux/damon.h~mm-damon-sysfs-use-damon-core-api-damon_is_running
+++ a/include/linux/damon.h
@@ -934,6 +934,7 @@ static inline unsigned int damon_max_nr_
 
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
+bool damon_is_running(struct damon_ctx *ctx);
 
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
--- a/mm/damon/core.c~mm-damon-sysfs-use-damon-core-api-damon_is_running
+++ a/mm/damon/core.c
@@ -1311,7 +1311,13 @@ int damon_stop(struct damon_ctx **ctxs,
 	return err;
 }
 
-static bool damon_is_running(struct damon_ctx *ctx)
+/**
+ * damon_is_running() - Returns if a given DAMON context is running.
+ * @ctx:	The DAMON context to see if running.
+ *
+ * Return: true if @ctx is running, false otherwise.
+ */
+bool damon_is_running(struct damon_ctx *ctx)
 {
 	bool running;
 
--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-damon-core-api-damon_is_running
+++ a/mm/damon/sysfs.c
@@ -1189,16 +1189,6 @@ static void damon_sysfs_kdamond_rm_dirs(
 	kobject_put(&kdamond->contexts->kobj);
 }
 
-static bool damon_sysfs_ctx_running(struct damon_ctx *ctx)
-{
-	bool running;
-
-	mutex_lock(&ctx->kdamond_lock);
-	running = ctx->kdamond != NULL;
-	mutex_unlock(&ctx->kdamond_lock);
-	return running;
-}
-
 /*
  * enum damon_sysfs_cmd - Commands for a specific kdamond.
  */
@@ -1275,7 +1265,7 @@ static ssize_t state_show(struct kobject
 	if (!ctx)
 		running = false;
 	else
-		running = damon_sysfs_ctx_running(ctx);
+		running = damon_is_running(ctx);
 
 	return sysfs_emit(buf, "%s\n", running ?
 			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_ON] :
@@ -1429,7 +1419,7 @@ static inline bool damon_sysfs_kdamond_r
 		struct damon_sysfs_kdamond *kdamond)
 {
 	return kdamond->damon_ctx &&
-		damon_sysfs_ctx_running(kdamond->damon_ctx);
+		damon_is_running(kdamond->damon_ctx);
 }
 
 static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

