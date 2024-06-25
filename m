Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919C5748F
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291744; cv=none; b=qCUYIEi1Hu06LN2/XNkTv+KRsjLI1ZTmughT89bfeiuMgKwrm5KbPyNJn2XA+CqAbYXopc96RqeHf8HPmQAXUINhDNm0U4Q1hsTSwWbzsoAeWd6No5FJdj/oRZN3A/WS/oPPX7ppyoqwrDEjS9ACW8ag2EaN29g8LCULotfGGEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291744; c=relaxed/simple;
	bh=b44pZ10PD1NKXskmRGFWrJW94mpqjvnrfTQVHkYrGs8=;
	h=Date:To:From:Subject:Message-Id; b=ccFRYaTJEhDNl/UCNiBjAUcmr2QbXXa+qKnTKta8ppWPwwvNVPG1EGg2QsfIK9iHqzJhI5yQianG0eRdLgjHZq+ehCj2vESd+Vk6Z/8HA/NH9SeaWFkdAqT6Smg4Viz4aGdhyfMjwGu2UfQsNcZf3iWIbLAKZZpkoJ7vv5dPU4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pofqFiPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pofqFiPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B9DC32782;
	Tue, 25 Jun 2024 05:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291744;
	bh=b44pZ10PD1NKXskmRGFWrJW94mpqjvnrfTQVHkYrGs8=;
	h=Date:To:From:Subject:From;
	b=pofqFiPDoihmlGHCWHuGbbC+0JruL6ZH0jeshAZWAp+cHCtV+PDb4+i/rYb4VLnnJ
	 Hz6ZS1zqkP7l6lH55Xvn3SICe2/kcZw032xKaZ1oc2TN50kUwc6P9WI0x4GKGGRl5g
	 pgwXLgCqFxYi2KQqr+MSzOQMbhUvRuTo8DP6B57I=
Date: Mon, 24 Jun 2024 22:02:23 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-use-damon_commit_ctx.patch removed from -mm tree
Message-Id: <20240625050224.67B9DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: use damon_commit_ctx()
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-use-damon_commit_ctx.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: use damon_commit_ctx()
Date: Tue, 18 Jun 2024 11:18:08 -0700

DAMON_LRU_SORT manually manipulates the DAMON context struct for online
parameters update.  Since the struct contains not only input parameters
but also internal status and operation results, it is not that simple. 
Indeed, we found and fixed a few bugs in the code.  Now DAMON core layer
provides a function for the usage, namely damon_commit_ctx().  Replace the
manual manipulation logic with the function.  The core layer function
could have its own bugs, but this change removes a source of bugs.

Link: https://lkml.kernel.org/r/20240618181809.82078-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-damon_commit_ctx
+++ a/mm/damon/lru_sort.c
@@ -199,15 +199,22 @@ static void damon_lru_sort_copy_quota_st
 
 static int damon_lru_sort_apply_parameters(void)
 {
+	struct damon_ctx *param_ctx;
+	struct damon_target *param_target;
 	struct damos *scheme, *hot_scheme, *cold_scheme;
 	struct damos *old_hot_scheme = NULL, *old_cold_scheme = NULL;
 	unsigned int hot_thres, cold_thres;
-	int err = 0;
+	int err;
 
-	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
+	err = damon_modules_new_paddr_ctx_target(&param_ctx, &param_target);
 	if (err)
 		return err;
 
+	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
+	if (err)
+		goto out;
+
+	err = -ENOMEM;
 	damon_for_each_scheme(scheme, ctx) {
 		if (!old_hot_scheme) {
 			old_hot_scheme = scheme;
@@ -220,7 +227,7 @@ static int damon_lru_sort_apply_paramete
 		hot_thres_access_freq / 1000;
 	hot_scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!hot_scheme)
-		return -ENOMEM;
+		goto out;
 	if (old_hot_scheme)
 		damon_lru_sort_copy_quota_status(&hot_scheme->quota,
 				&old_hot_scheme->quota);
@@ -229,18 +236,24 @@ static int damon_lru_sort_apply_paramete
 	cold_scheme = damon_lru_sort_new_cold_scheme(cold_thres);
 	if (!cold_scheme) {
 		damon_destroy_scheme(hot_scheme);
-		return -ENOMEM;
+		goto out;
 	}
 	if (old_cold_scheme)
 		damon_lru_sort_copy_quota_status(&cold_scheme->quota,
 				&old_cold_scheme->quota);
 
-	damon_set_schemes(ctx, &hot_scheme, 1);
-	damon_add_scheme(ctx, cold_scheme);
+	damon_set_schemes(param_ctx, &hot_scheme, 1);
+	damon_add_scheme(param_ctx, cold_scheme);
 
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
 
 static int damon_lru_sort_turn(bool on)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

