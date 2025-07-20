Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48CA14AD2D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976932; cv=none; b=cp51lzHmntUh8sOKNuw1eImbBsVygj7CppgCcEVEyilv3C+qs9zkneOyZ5ddpG9wfRkkyAMuaXx19fZAARNL/mVSpQALe1+hXHGl/YPgGTO4P6bYWkk1P8hcHYG+W/FNSx5gpiy49bVpqtmioEn1EffHfQc8A8BixLM2AC5fzDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976932; c=relaxed/simple;
	bh=9KDy9XhKCfcd3iER7B1ltnrzbLDKyf8Qw+lKxbmRkeU=;
	h=Date:To:From:Subject:Message-Id; b=f1BjI6ij5EbbQrC+FqskbzUBj5TRDLQNw/4hS/N2lprkjYT3C9HTaRQB1RxdB0J1kd9DcyAMFwroyEslvamCshe/xGGaGp+4gVvPr291RAdVPfZbZQOfuSstR/N638BA9ujFy6E2OFaqzuKBx8FbwU5XkHtxcILiOiINl1M12ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OoiE4OOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OoiE4OOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85D7C4CEE3;
	Sun, 20 Jul 2025 02:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976932;
	bh=9KDy9XhKCfcd3iER7B1ltnrzbLDKyf8Qw+lKxbmRkeU=;
	h=Date:To:From:Subject:From;
	b=OoiE4OOpU5lmB2HURCWJeVnnG1fSAmahhsVpCzza7p8XIZnlTkZFQtvxaHkvNMcPd
	 JumSR1rnmK3DsHx/rgmBw3nYM4foMrem2TBDs1jIKPkndO0YirjaRWnYtYWTNY6T/0
	 jPgA7OI7o1DbNbWjnMS5hFDgIRBeN2gnMW3Se2UQ=
Date: Sat, 19 Jul 2025 19:02:12 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch removed from -mm tree
Message-Id: <20250720020212.A85D7C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: use damon_call() repeat mode instead of damon_callback
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: use damon_call() repeat mode instead of damon_callback
Date: Sat, 12 Jul 2025 12:50:06 -0700

DAMON_RECLAIM uses damon_callback for periodically reading and writing
DAMON internal data and parameters.  Use its alternative, damon_call()
repeat mode.

Link: https://lkml.kernel.org/r/20250712195016.151108-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   62 +++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback
+++ a/mm/damon/reclaim.c
@@ -238,6 +238,35 @@ out:
 	return err;
 }
 
+static int damon_reclaim_handle_commit_inputs(void)
+{
+	int err;
+
+	if (!commit_inputs)
+		return 0;
+
+	err = damon_reclaim_apply_parameters();
+	commit_inputs = false;
+	return err;
+}
+
+static int damon_reclaim_damon_call_fn(void *arg)
+{
+	struct damon_ctx *c = arg;
+	struct damos *s;
+
+	/* update the stats parameter */
+	damon_for_each_scheme(s, c)
+		damon_reclaim_stat = s->stat;
+
+	return damon_reclaim_handle_commit_inputs();
+}
+
+static struct damon_call_control call_control = {
+	.fn = damon_reclaim_damon_call_fn,
+	.repeat = true,
+};
+
 static int damon_reclaim_turn(bool on)
 {
 	int err;
@@ -257,7 +286,7 @@ static int damon_reclaim_turn(bool on)
 	if (err)
 		return err;
 	kdamond_pid = ctx->kdamond->pid;
-	return 0;
+	return damon_call(ctx, &call_control);
 }
 
 static int damon_reclaim_enabled_store(const char *val,
@@ -296,34 +325,6 @@ module_param_cb(enabled, &enabled_param_
 MODULE_PARM_DESC(enabled,
 	"Enable or disable DAMON_RECLAIM (default: disabled)");
 
-static int damon_reclaim_handle_commit_inputs(void)
-{
-	int err;
-
-	if (!commit_inputs)
-		return 0;
-
-	err = damon_reclaim_apply_parameters();
-	commit_inputs = false;
-	return err;
-}
-
-static int damon_reclaim_after_aggregation(struct damon_ctx *c)
-{
-	struct damos *s;
-
-	/* update the stats parameter */
-	damon_for_each_scheme(s, c)
-		damon_reclaim_stat = s->stat;
-
-	return damon_reclaim_handle_commit_inputs();
-}
-
-static int damon_reclaim_after_wmarks_check(struct damon_ctx *c)
-{
-	return damon_reclaim_handle_commit_inputs();
-}
-
 static int __init damon_reclaim_init(void)
 {
 	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
@@ -331,8 +332,7 @@ static int __init damon_reclaim_init(voi
 	if (err)
 		goto out;
 
-	ctx->callback.after_wmarks_check = damon_reclaim_after_wmarks_check;
-	ctx->callback.after_aggregation = damon_reclaim_after_aggregation;
+	call_control.data = ctx;
 
 	/* 'enabled' has set before this function, probably via command line */
 	if (enabled)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

