Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4810F8F6F
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739419; cv=none; b=QLecTvgyD/10EcG2rI4fzXxyR+36Il5iD6kl7wLrShh3LSo9/RdwOZoQzQFyrMc0vZTirgfX4xyNCmaVEvG5Q8B5A9A2wSn8gdAqxeZoQDRhlp4SXFJbgDHgyp8qwrxaJIBgmN1IGRq1rFQjs0+r6N3DJZvZ1WCDytTGTMGwH38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739419; c=relaxed/simple;
	bh=e6O9cgDAj/+vc9d1PTkAIbwz6Lrs3ZUvIR6FzmHMjFc=;
	h=Date:To:From:Subject:Message-Id; b=Zev/ub1ky2AaCY3mApkStShfFU4EBo2KI5+8Rs7dicTx3HW503QvTMw1sDfGIMLqeLOQoV9fbf5aYT2uC4Nq5GkSNqvKT/8nkq+lC3z6c41hJvNn7Cz9SnPv6gaHuntuY25YpW1kNe7dHUnPKahf1okHEgBNy9ytCfqslRn4o4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XyUDutSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XyUDutSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4EBC433C7;
	Sat, 24 Feb 2024 01:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739419;
	bh=e6O9cgDAj/+vc9d1PTkAIbwz6Lrs3ZUvIR6FzmHMjFc=;
	h=Date:To:From:Subject:From;
	b=XyUDutSgUixDtycbFiR4RRM4u9C1FDgBvt4NbauNKaCwJalSk1X5B2XBpwrRp/DMA
	 W8QuFff1L8+ClgAyaAFnY5n77dCYD7jBNX3Vq0BacoIExo0Fg6rN8EYBvVcqltovD9
	 SOmHxXDVo/UlACOCVQLAmWPH5dGimhb/VQWGoHwU=
Date: Fri, 23 Feb 2024 17:50:18 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-use-only-quota-goals.patch removed from -mm tree
Message-Id: <20240224015019.1D4EBC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: use only quota->goals
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-use-only-quota-goals.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: use only quota->goals
Date: Mon, 19 Feb 2024 11:44:20 -0800

DAMON sysfs interface implements multiple quota auto-tuning goals on its
level since the DAMOS core logic was supporting only single goal.  Now the
core logic supports multiple goals on its level.  Update DAMON sysfs
interface to reuse the core logic and drop unnecessary duplicated multiple
goals implementation.

Link: https://lkml.kernel.org/r/20240219194431.159606-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    2 -
 mm/damon/sysfs-schemes.c |   49 ++++++++++++++++++++++++-------------
 mm/damon/sysfs.c         |    3 --
 3 files changed, 35 insertions(+), 19 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-only-quota-goals
+++ a/mm/damon/sysfs.c
@@ -1377,8 +1377,7 @@ static int damon_sysfs_commit_schemes_qu
 
 	ctx = sysfs_kdamond->damon_ctx;
 	sysfs_ctx = sysfs_kdamond->contexts->contexts_arr[0];
-	damos_sysfs_set_quota_scores(sysfs_ctx->schemes, ctx);
-	return 0;
+	return damos_sysfs_set_quota_scores(sysfs_ctx->schemes, ctx);
 }
 
 /*
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-use-only-quota-goals
+++ a/mm/damon/sysfs-common.h
@@ -59,7 +59,7 @@ int damon_sysfs_schemes_clear_regions(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
 
-void damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
+int damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
 
 void damos_sysfs_update_effective_quotas(
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-use-only-quota-goals
+++ a/mm/damon/sysfs-schemes.c
@@ -1887,30 +1887,34 @@ static unsigned long damos_sysfs_get_quo
 	return (unsigned long)arg;
 }
 
-static void damos_sysfs_set_quota_score(
+static int damos_sysfs_set_quota_score(
 		struct damos_sysfs_quota_goals *sysfs_goals,
 		struct damos_quota *quota)
 {
-	struct damos_sysfs_quota_goal *sysfs_goal;
+	struct damos_quota_goal *goal, *next;
 	int i;
 
-	quota->goal.get_score = NULL;
-	quota->goal.get_score_arg = (void *)0;
+	damos_for_each_quota_goal_safe(goal, next, quota)
+		damos_destroy_quota_goal(goal);
+
 	for (i = 0; i < sysfs_goals->nr; i++) {
-		sysfs_goal = sysfs_goals->goals_arr[i];
+		struct damos_sysfs_quota_goal *sysfs_goal =
+			sysfs_goals->goals_arr[i];
+
 		if (!sysfs_goal->target_value)
 			continue;
 
-		/* Higher score makes scheme less aggressive */
-		quota->goal.get_score_arg = (void *)max(
-				(unsigned long)quota->goal.get_score_arg,
-				sysfs_goal->current_value * 10000 /
-				sysfs_goal->target_value);
-		quota->goal.get_score = damos_sysfs_get_quota_score;
+		goal = damos_new_quota_goal(damos_sysfs_get_quota_score,
+				(void *)(sysfs_goal->current_value * 10000 /
+				sysfs_goal->target_value));
+		if (!goal)
+			return -ENOMEM;
+		damos_add_quota_goal(quota, goal);
 	}
+	return 0;
 }
 
-void damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
+int damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx)
 {
 	struct damos *scheme;
@@ -1918,16 +1922,21 @@ void damos_sysfs_set_quota_scores(struct
 
 	damon_for_each_scheme(scheme, ctx) {
 		struct damon_sysfs_scheme *sysfs_scheme;
+		int err;
 
 		/* user could have removed the scheme sysfs dir */
 		if (i >= sysfs_schemes->nr)
 			break;
 
 		sysfs_scheme = sysfs_schemes->schemes_arr[i];
-		damos_sysfs_set_quota_score(sysfs_scheme->quotas->goals,
+		err = damos_sysfs_set_quota_score(sysfs_scheme->quotas->goals,
 				&scheme->quota);
+		if (err)
+			/* kdamond will clean up schemes and terminated */
+			return err;
 		i++;
 	}
+	return 0;
 }
 
 void damos_sysfs_update_effective_quotas(
@@ -1987,13 +1996,17 @@ static struct damos *damon_sysfs_mk_sche
 		.low = sysfs_wmarks->low,
 	};
 
-	damos_sysfs_set_quota_score(sysfs_quotas->goals, &quota);
-
 	scheme = damon_new_scheme(&pattern, sysfs_scheme->action,
 			sysfs_scheme->apply_interval_us, &quota, &wmarks);
 	if (!scheme)
 		return NULL;
 
+	err = damos_sysfs_set_quota_score(sysfs_quotas->goals, &scheme->quota);
+	if (err) {
+		damon_destroy_scheme(scheme);
+		return NULL;
+	}
+
 	err = damon_sysfs_set_scheme_filters(scheme, sysfs_filters);
 	if (err) {
 		damon_destroy_scheme(scheme);
@@ -2029,7 +2042,11 @@ static void damon_sysfs_update_scheme(st
 	scheme->quota.weight_nr_accesses = sysfs_weights->nr_accesses;
 	scheme->quota.weight_age = sysfs_weights->age;
 
-	damos_sysfs_set_quota_score(sysfs_quotas->goals, &scheme->quota);
+	err = damos_sysfs_set_quota_score(sysfs_quotas->goals, &scheme->quota);
+	if (err) {
+		damon_destroy_scheme(scheme);
+		return;
+	}
 
 	scheme->wmarks.metric = sysfs_wmarks->metric;
 	scheme->wmarks.interval = sysfs_wmarks->interval_us;
_

Patches currently in -mm which might be from sj@kernel.org are


