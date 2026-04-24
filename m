Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862BB394493;
	Fri, 24 Apr 2026 11:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777028758; cv=none; b=ElWqFTsY7ARgZMQWmUGcESthYcfNURxqSj2x7Inzn8p+C9NsgYdu2tK2ABNiyhCwusbWrcdY78yyOHs+4hEVP5iEKJquHS63j8Bl5Ej0+zw59FqlrGMjtJJecetAftzfp01/HwSAHeGKW8aUcTNiz2KBt9vMM0c0U5FqmmJTJHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777028758; c=relaxed/simple;
	bh=tkKPwvWKneALXnLdqge9aDnZgxf4mj9AtcVGsebu/7M=;
	h=Date:To:From:Subject:Message-Id; b=Om+7XvmP6vbHM0aWY2xCN5V4POzhfiqA1Ga/y6jJx/xJ9y66NkTcJcxj548d01HkStdyUonl65+0PV8wvpM/AEZ6fNque85Z+563R1V25VFXNoK9UpxcpQOtnZ9eqVFxG9F6NCY8nUGMvMmouZSne+/i9pW+fDRwIZpSWBWqLnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M3JaRYSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M3JaRYSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228BCC19425;
	Fri, 24 Apr 2026 11:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777028758;
	bh=tkKPwvWKneALXnLdqge9aDnZgxf4mj9AtcVGsebu/7M=;
	h=Date:To:From:Subject:From;
	b=M3JaRYSKhwvQI2NrnNcZTLeQIf0afPa3H71AhucfA4sUSlXSrp3JCPpHNjI81zgnx
	 Z89gckiqPChEKUrCT91TEiw5hItpAfjI+RYxC3+4ZJBmd6OY3us+fod2dUZ8NisV0b
	 SnTXxE3hPMU+B40EinCs0YhBKB5zKlY1AHxYVbrY=
Date: Fri, 24 Apr 2026 04:05:57 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,aethernet65535@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-detect-and-use-fresh-enabled-value.patch added to mm-hotfixes-unstable branch
Message-Id: <20260424110558.228BCC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: detect and use fresh enabled value
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-stat-detect-and-use-fresh-enabled-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-detect-and-use-fresh-enabled-value.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-damon-sysfs-schemes-protect-memcg_path-kfree-with-damon_sysfs_lock.patch
mm-damon-sysfs-schemes-protect-path-kfree-with-damon_sysfs_lock.patch
mm-damon-reclaim-detect-and-use-fresh-enabled-and-kdamond_pid-values.patch
mm-damon-lru_sort-detect-and-use-fresh-enabled-and-kdamond_pid-values.patch
mm-damon-stat-detect-and-use-fresh-enabled-value.patch

