Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A0D3090D9;
	Mon, 27 Apr 2026 12:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777294523; cv=none; b=K1cuSNjmrV7vuklgaw5YNc6fZJUTiYnVAigeizQz8sWqmdBfearjgLeJ5M40sc+5U8wEx+qhc5NcejE0rt49QZJPMGwnn70IAk1VbeSWrXHS0ql/ewEz4CYXIJ6SoONWwM33B5FgDFkOZ8R9wZRyTx0SZSit84P/Dpy8UN6bLCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777294523; c=relaxed/simple;
	bh=0RWEOLl/btn5pzdjfXslBvF5CfVkB0NYOSWgq4wnmIs=;
	h=Date:To:From:Subject:Message-Id; b=jAwOC1SScxvhkXFLwxjbRStSVX1L8GB1/S7RCDDaX4hAi0cfR7y7bWhJj5E4+/+Z35N9Le6CoMDqkwcHd6f7jRsQtuKyf92DRkTDM4thEO9nqWSgp5yu8L8hdPk0ENa+ZX0qzgLejSfoi7y/Ksy5tp9JHWXwZ+qa17pdAKvBAvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gNHMwSu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gNHMwSu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53BCC19425;
	Mon, 27 Apr 2026 12:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777294522;
	bh=0RWEOLl/btn5pzdjfXslBvF5CfVkB0NYOSWgq4wnmIs=;
	h=Date:To:From:Subject:From;
	b=gNHMwSu8LufCZ3IdoXOo2K+0LvuIyvjRhhkrHIqjg67epNIFWBicJNPP7qyCK9d2b
	 7KTWhovqepcpKFaGIDT8pnua9yet/pIZc4CvDWL0ZK3k4B0EBsECpIk6wWM4/oDl74
	 YfjCNNV3AYFYPay3xDDfgdcVINSd75aJLsWnTRFU=
Date: Mon, 27 Apr 2026 05:55:22 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,aethernet65535@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-stat-detect-and-use-fresh-enabled-value.patch removed from -mm tree
Message-Id: <20260427125522.C53BCC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: detect and use fresh enabled value
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-detect-and-use-fresh-enabled-value.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/stat: detect and use fresh enabled value
Date: Sun, 19 Apr 2026 09:10:02 -0700

DAMON_STAT updates 'enabled' parameter value, which represents the running
status of its kdamond, when the user explicitly requests start/stop of the
kdamond.  The kdamond can, however, be stopped even if the user explicitly
requested the stop, if ctx->regions_score_histogram allocation failure at
beginning of the execution of the kdamond.  Hence, if the kdamond is
stopped by the allocation failure, the value of the parameter can be
stale.

Users could show the stale value and be confused.  The problem will only
rarely happen in real and common setups because the allocation is arguably
too small to fail.  Also, unlike the similar bugs that are now fixed in
DAMON_RECLAIM and DAMON_LRU_SORT, kdamond can be restarted in this case,
because DAMON_STAT force-updates the enabled parameter value for user
inputs.  The bug is a bug, though.

The issue stems from the fact that there are multiple events that can
change the status, and following all the events is challenging. 
Dynamically detect and use the fresh status for the parameters when those
are requested.

The issue was dicovered [1] by Sashiko.

Link: https://lore.kernel.org/20260419161003.79176-4-sj@kernel.org
Link: https://lore.kernel.org/20260416040602.88665-1-sj@kernel.org [1]
Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-detect-and-use-fresh-enabled-value
+++ a/mm/damon/stat.c
@@ -19,14 +19,17 @@
 static int damon_stat_enabled_store(
 		const char *val, const struct kernel_param *kp);
 
+static int damon_stat_enabled_load(char *buffer,
+		const struct kernel_param *kp);
+
 static const struct kernel_param_ops enabled_param_ops = {
 	.set = damon_stat_enabled_store,
-	.get = param_get_bool,
+	.get = damon_stat_enabled_load,
 };
 
 static bool enabled __read_mostly = IS_ENABLED(
 	CONFIG_DAMON_STAT_ENABLED_DEFAULT);
-module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
+module_param_cb(enabled, &enabled_param_ops, NULL, 0600);
 MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
 
 static unsigned long estimated_memory_bandwidth __read_mostly;
@@ -273,17 +276,23 @@ static void damon_stat_stop(void)
 	damon_stat_context = NULL;
 }
 
+static bool damon_stat_enabled(void)
+{
+	if (!damon_stat_context)
+		return false;
+	return damon_is_running(damon_stat_context);
+}
+
 static int damon_stat_enabled_store(
 		const char *val, const struct kernel_param *kp)
 {
-	bool is_enabled = enabled;
 	int err;
 
 	err = kstrtobool(val, &enabled);
 	if (err)
 		return err;
 
-	if (is_enabled == enabled)
+	if (damon_stat_enabled() == enabled)
 		return 0;
 
 	if (!damon_initialized())
@@ -293,16 +302,17 @@ static int damon_stat_enabled_store(
 		 */
 		return 0;
 
-	if (enabled) {
-		err = damon_stat_start();
-		if (err)
-			enabled = false;
-		return err;
-	}
+	if (enabled)
+		return damon_stat_start();
 	damon_stat_stop();
 	return 0;
 }
 
+static int damon_stat_enabled_load(char *buffer, const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%c\n", damon_stat_enabled() ? 'Y' : 'N');
+}
+
 static int __init damon_stat_init(void)
 {
 	int err = 0;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch

