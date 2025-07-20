Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C6314AD2D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752976931; cv=none; b=ks0gyLKIAgxpAY8GsafOry1G5LrWbkz28v+xoIeyWlGXUfIgvx7m8PzLpqZxPWh+Cmp9w3Akde4/kWbO7DSsOFNF1lH1K6dkwyu8SvyULZjqszuHQmph/CfI+O0XX9nXpMwm6I3aMfKrvNpJuY2VfWDcCnfKV1U+fBLypt/dL0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752976931; c=relaxed/simple;
	bh=a7wI9qdeoMc6JTmO6CIOqhSD0CAfyxLIB+1YQYQiOw8=;
	h=Date:To:From:Subject:Message-Id; b=ab8zXhuTj2dzR9nWcpZ27WqOtyql57LeISzhskRDcCgSm0w9mkta8en4KNSXpCjP9htQvh91/ez06/q7PuUSRNMN8ZHnBlWRn3Sjqv3pJr6yC5kTFzbM6Lh+xBTJerhb5r/WQIgK09hxgq+HIUImcIljLw2Zjn135SIy87hFDRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yQXXwbXm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yQXXwbXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F2EC4CEE3;
	Sun, 20 Jul 2025 02:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752976931;
	bh=a7wI9qdeoMc6JTmO6CIOqhSD0CAfyxLIB+1YQYQiOw8=;
	h=Date:To:From:Subject:From;
	b=yQXXwbXm4fiWssPIAIZoFnAaSaGr90mMW+ZP2jLGWCSJhdVA0ONwkhrB9bS0cuNau
	 FeCtqCqOil0uBNNYO2rBBbx//Ty3W23a/U/xYQLTig1IcAGQglaxG+vhT4VTiEnEOX
	 fE64+rozgyvushRQDUGjO+Rbdwzq7dW0gJm39gYY=
Date: Sat, 19 Jul 2025 19:02:10 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch removed from -mm tree
Message-Id: <20250720020211.95F2EC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: use damon_call() repeat mode instead of damon_callback
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-commit-damos_quota_goal-nid.patch
mm-damon-sysfs-implement-refresh_ms-file-under-kdamond-directory.patch
mm-damon-sysfs-implement-refresh_ms-file-internal-work.patch
docs-admin-guide-mm-damon-usage-document-refresh_ms-file.patch
docs-abi-damon-update-for-refresh_ms.patch

