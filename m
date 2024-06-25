Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98AE1748F
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291743; cv=none; b=mizeseuIXASjGeNWe1Z6CoEVKsCKCNyO8xcheludJc08Bmk0NMO153VQMf9iVtKmg4hXiXFAzSPvmt7JUbkZaYMV2wAKPpDASz91Z7Fjkkj1ZAxwqYBKSDJn/k7+SAT2MocInNzf89U05sejtbvyWFMTc/1zmjA8agRa0vn3WEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291743; c=relaxed/simple;
	bh=Iqr+nwBzvsRoRdSZ6c9IG9U5PVRmJwKu4vFe2L9Cvpw=;
	h=Date:To:From:Subject:Message-Id; b=PtbgwHvlN3QOd/t2T+Z1fArWvkB4trmMDr884DAF/5fZbj+1c1PUugXNP2B3AwU1eWi95Igoldp6/ZirI6o3LRfn/P+ECveh0Oav9RtfAF70QNuiuSdZPVVZW3P4zfdWnDQWCQbQdYl1Syb0wDtzlTdExB7jj2q6RbXbq/wlzXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EoeRnNMt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EoeRnNMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E07DC32782;
	Tue, 25 Jun 2024 05:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291743;
	bh=Iqr+nwBzvsRoRdSZ6c9IG9U5PVRmJwKu4vFe2L9Cvpw=;
	h=Date:To:From:Subject:From;
	b=EoeRnNMtFLj3YIkB3iJb78WnF5j0WPp+xC1EaYvA76k/5aZ5Sk1Q0pTkShX+JKeAs
	 5g2qO/DtvFDXg7dURGbldd2Cye3K3dRdq0SHE6T0+70WSwYcMzOOtWpYOD/dcXHXXl
	 nZTv4y7+HBkUBfrYcQER6NqjsEnfnGQ9D4zmu7to=
Date: Mon, 24 Jun 2024 22:02:22 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch removed from -mm tree
Message-Id: <20240625050223.6E07DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: remove unnecessary code for online tuning
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: remove unnecessary code for online tuning
Date: Tue, 18 Jun 2024 11:18:07 -0700

DAMON_RECLAIM contains code for handling of online DAMON parameters update
edge cases.  It is no more necessary since damon_commit_ctx() takes care
of the cases.  Remove the unnecessary code.

Link: https://lkml.kernel.org/r/20240618181809.82078-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-remove-unnecessary-code-for-online-tuning
+++ a/mm/damon/reclaim.c
@@ -181,23 +181,11 @@ static struct damos *damon_reclaim_new_s
 			NUMA_NO_NODE);
 }
 
-static void damon_reclaim_copy_quota_status(struct damos_quota *dst,
-		struct damos_quota *src)
-{
-	dst->total_charged_sz = src->total_charged_sz;
-	dst->total_charged_ns = src->total_charged_ns;
-	dst->charged_sz = src->charged_sz;
-	dst->charged_from = src->charged_from;
-	dst->charge_target_from = src->charge_target_from;
-	dst->charge_addr_from = src->charge_addr_from;
-	dst->esz_bp = src->esz_bp;
-}
-
 static int damon_reclaim_apply_parameters(void)
 {
 	struct damon_ctx *param_ctx;
 	struct damon_target *param_target;
-	struct damos *scheme, *old_scheme;
+	struct damos *scheme;
 	struct damos_quota_goal *goal;
 	struct damos_filter *filter;
 	int err;
@@ -214,11 +202,6 @@ static int damon_reclaim_apply_parameter
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
 		goto out;
-	if (!list_empty(&ctx->schemes)) {
-		damon_for_each_scheme(old_scheme, ctx)
-			damon_reclaim_copy_quota_status(&scheme->quota,
-					&old_scheme->quota);
-	}
 	damon_set_schemes(ctx, &scheme, 1);
 
 	if (quota_mem_pressure_us) {
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

