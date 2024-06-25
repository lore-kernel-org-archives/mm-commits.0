Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977B114388D
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291742; cv=none; b=pHovIQIkxIE6JGv63Yn01B9Qc7Yu4Wwv/T+ded1l0dsD70ZtcYns0IezqadVbrIINhwho1p/TKBgXtuWsKBzPFDkvYAa2W1pvBscBdSmOACC4n2vDJyYSZVyPcNUahGTDL27/iXTdGS701J1DiOxK0l/STd1bju8U0zQg7qmrT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291742; c=relaxed/simple;
	bh=6Z+h3xpgVy7pQA2qcS53PqOGGF1YiHEX3vlN04bmUdE=;
	h=Date:To:From:Subject:Message-Id; b=CPxLYTH5YX3btAj0+/dFOuMWpdcnIebgWAvv6wG0QQrHndIAy+kmcZtRjYLIl0NesevTVEeTEevWZZfaB63adUHRPpf+7rmM46iE+jkxEKR2VGiHIpz7ItzdGslcHcme2B0YpJgtZtpnLM4eombWCqdf78h5v3nLkfke8nPBwLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YFXvD5My; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YFXvD5My"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABD7C32782;
	Tue, 25 Jun 2024 05:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291742;
	bh=6Z+h3xpgVy7pQA2qcS53PqOGGF1YiHEX3vlN04bmUdE=;
	h=Date:To:From:Subject:From;
	b=YFXvD5Myw0rgS/e6arYjroHBV6h/knWBi6yc8lvI02K9kAfY5CWHvC4On3bwIa2Xq
	 jSaHCzXjFOuijxCJloByDUO4OEkyqi5PaISQwnGfihwXnkTy+qSvcrwBG//x4FYcIS
	 zAxh3uILUdqL5aV1Lvy//MIwYwVulJxurD0c5Pek=
Date: Mon, 24 Jun 2024 22:02:21 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-use-damon_commit_ctx.patch removed from -mm tree
Message-Id: <20240625050222.6ABD7C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: use damon_commit_ctx()
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-use-damon_commit_ctx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

