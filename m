Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A6A158DBA
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718739404; cv=none; b=Bv3+7B9YGh8AkB40ah9LYTiWu2Y6PhB//ycRxhWCT/lXRd297rvxlSq0HUIA5EqAe9TSw3Oo9Db5DNapDAjX3PB7ISDPTTWqgYj2OmsvGoQ79gjcwlnLnCB9vGFb+LsLw/pDynm/sH7T6CZkTGDnUjWyI86GZ20wVhzzMX+IEAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718739404; c=relaxed/simple;
	bh=dLEt4Ynn+/W286NxL/GyNDW2RKHNchgigP+ECDIecvk=;
	h=Date:To:From:Subject:Message-Id; b=a8bs9WJ1SloeYWch7kkdNsfBwq1QIMAseXv9iK0wVOaGG6s4zBQS8CFlwG6qU7HMs09q1sIuaY9Aia5OItEAmuH5fYos5qq76/abDa4YuFLod+FVPTpyHD/mPZf/BoDRYnTg7+UAJRE71u5XDze1VtxhJ22Wa+E/PqEVkra7Evk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EKjzc0Rq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EKjzc0Rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32853C3277B;
	Tue, 18 Jun 2024 19:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718739404;
	bh=dLEt4Ynn+/W286NxL/GyNDW2RKHNchgigP+ECDIecvk=;
	h=Date:To:From:Subject:From;
	b=EKjzc0RqToWDj8ybmIB+Sr7JJLxhTnFTLhur/fCQvomXe2RPrsbqn1OQG+iCoFz2E
	 yhebZfxIIh31Hg7My3q3J6/AOo2WdWCkb7DThlRCbBM/CHWd5koZQZNB/glLEgDn4F
	 sgBYh+e3B4+JfRIOfInNdYqUNxmmh34yxYVVJ/Q4=
Date: Tue, 18 Jun 2024 12:36:43 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-use-damon_commit_ctx.patch added to mm-unstable branch
Message-Id: <20240618193644.32853C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: use damon_commit_ctx()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-use-damon_commit_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-use-damon_commit_ctx.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: use damon_commit_ctx()
Date: Tue, 18 Jun 2024 11:18:06 -0700

DAMON_RECLAIM manually manipulates the DAMON context struct for online
parameters update.  Since the struct contains not only input parameters
but also internal status and operation results, it is not that simple. 
Indeed, we found and fixed a few bugs in the code.  Now DAMON core layer
provides a function for the usage, namely damon_commit_ctx().  Replace the
manual manipulation logic with the function.  The core layer function
could have its own bugs, but this change removes a source of bugs.

Link: https://lkml.kernel.org/r/20240618181809.82078-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-damon_commit_ctx
+++ a/mm/damon/reclaim.c
@@ -195,59 +195,64 @@ static void damon_reclaim_copy_quota_sta
 
 static int damon_reclaim_apply_parameters(void)
 {
+	struct damon_ctx *param_ctx;
+	struct damon_target *param_target;
 	struct damos *scheme, *old_scheme;
 	struct damos_quota_goal *goal;
 	struct damos_filter *filter;
-	int err = 0;
+	int err;
 
-	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
+	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
 	if (err)
 		return err;
 
-	/* Will be freed by next 'damon_set_schemes()' below */
+	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
+	if (err)
+		goto out;
+
+	err = -ENOMEM;
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
-		return -ENOMEM;
+		goto out;
 	if (!list_empty(&ctx->schemes)) {
 		damon_for_each_scheme(old_scheme, ctx)
 			damon_reclaim_copy_quota_status(&scheme->quota,
 					&old_scheme->quota);
 	}
+	damon_set_schemes(ctx, &scheme, 1);
 
 	if (quota_mem_pressure_us) {
 		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,
 				quota_mem_pressure_us);
-		if (!goal) {
-			damon_destroy_scheme(scheme);
-			return -ENOMEM;
-		}
+		if (!goal)
+			goto out;
 		damos_add_quota_goal(&scheme->quota, goal);
 	}
 
 	if (quota_autotune_feedback) {
 		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
-		if (!goal) {
-			damon_destroy_scheme(scheme);
-			return -ENOMEM;
-		}
+		if (!goal)
+			goto out;
 		goal->current_value = quota_autotune_feedback;
 		damos_add_quota_goal(&scheme->quota, goal);
 	}
 
 	if (skip_anon) {
 		filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
-		if (!filter) {
-			/* Will be freed by next 'damon_set_schemes()' below */
-			damon_destroy_scheme(scheme);
-			return -ENOMEM;
-		}
+		if (!filter)
+			goto out;
 		damos_add_filter(scheme, filter);
 	}
-	damon_set_schemes(ctx, &scheme, 1);
 
-	return damon_set_region_biggest_system_ram_default(target,
+	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end);
+	if (err)
+		goto out;
+	err = damon_commit_ctx(ctx, param_ctx);
+out:
+	damon_destroy_ctx(param_ctx);
+	return err;
 }
 
 static int damon_reclaim_turn(bool on)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-implement-damos-quota-goals-online-commit-function.patch
mm-damon-core-implement-damon-context-commit-function.patch
mm-damon-sysfs-use-damon_commit_ctx.patch
mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch
mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets.patch
mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch
mm-damon-reclaim-use-damon_commit_ctx.patch
mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch
mm-damon-lru_sort-use-damon_commit_ctx.patch
mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch

