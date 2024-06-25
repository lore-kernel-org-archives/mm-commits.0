Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA4C1442F4
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291745; cv=none; b=bQ/HR7Ch4fe+GI5ixIwqz5Vxb6nJlMBVrVCvvSHioU1oKmts88Pu/AY2fxWakWuv+1TthlBpVMOU+qWo6dU0ezFsSSzR9txV8IQJsmTL1h7oXZk4e1uNmCg61bnlOEUs7EYUZQIFLQ2goHD7J7ewyX8GnscPZ8RgGCosODSEQrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291745; c=relaxed/simple;
	bh=gATj3HmTKZobIMNb5DmM4f9C3q7Sz1zHC02/basYLQw=;
	h=Date:To:From:Subject:Message-Id; b=o01d6k9RTNprr86FTc72CvTaJ5UWL3PkK22F17t6Sp0aKrRTbrZ+XgEwBBxbnFvS4wQN2FiEtRfPZIEeZfl1iQDBCUMT/0soc8FVXP/+ysFFlobXszKLZ/DcqfLc2FqGAHkSRRXQ0H6WS5DYWefKeeDIL/+bo+58Q4EhJxBHvEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c9/xKq6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c9/xKq6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6446CC32782;
	Tue, 25 Jun 2024 05:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291745;
	bh=gATj3HmTKZobIMNb5DmM4f9C3q7Sz1zHC02/basYLQw=;
	h=Date:To:From:Subject:From;
	b=c9/xKq6FQUVAhI6J3UzEW7Z8iGtvw46EHRpiU8LXGhUWHcdPyZGwPpzpV3DMrUJoS
	 XuwiudztQ7Ayyq79p5pMm5TY9bN47MOkW8L3hIuT3hTLjBsGxnEbE12w3XxGph74EN
	 uvxT9dJ+EfzGfCba2wqEYeCzPNgYQTQ8inIIhBBE=
Date: Mon, 24 Jun 2024 22:02:24 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch removed from -mm tree
Message-Id: <20240625050225.6446CC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: remove unnecessary online tuning handling code
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: remove unnecessary online tuning handling code
Date: Tue, 18 Jun 2024 11:18:09 -0700

DAMON_LRU_SORT contains code for handling of online DAMON parameters
update edge cases.  It is no more necessary since damon_commit_ctx() takes
care of the cases.  Remove the unnecessary code.

Link: https://lkml.kernel.org/r/20240618181809.82078-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   28 +---------------------------
 1 file changed, 1 insertion(+), 27 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code
+++ a/mm/damon/lru_sort.c
@@ -186,23 +186,11 @@ static struct damos *damon_lru_sort_new_
 	return damon_lru_sort_new_scheme(&pattern, DAMOS_LRU_DEPRIO);
 }
 
-static void damon_lru_sort_copy_quota_status(struct damos_quota *dst,
-		struct damos_quota *src)
-{
-	dst->total_charged_sz = src->total_charged_sz;
-	dst->total_charged_ns = src->total_charged_ns;
-	dst->charged_sz = src->charged_sz;
-	dst->charged_from = src->charged_from;
-	dst->charge_target_from = src->charge_target_from;
-	dst->charge_addr_from = src->charge_addr_from;
-}
-
 static int damon_lru_sort_apply_parameters(void)
 {
 	struct damon_ctx *param_ctx;
 	struct damon_target *param_target;
-	struct damos *scheme, *hot_scheme, *cold_scheme;
-	struct damos *old_hot_scheme = NULL, *old_cold_scheme = NULL;
+	struct damos *hot_scheme, *cold_scheme;
 	unsigned int hot_thres, cold_thres;
 	int err;
 
@@ -215,22 +203,11 @@ static int damon_lru_sort_apply_paramete
 		goto out;
 
 	err = -ENOMEM;
-	damon_for_each_scheme(scheme, ctx) {
-		if (!old_hot_scheme) {
-			old_hot_scheme = scheme;
-			continue;
-		}
-		old_cold_scheme = scheme;
-	}
-
 	hot_thres = damon_max_nr_accesses(&damon_lru_sort_mon_attrs) *
 		hot_thres_access_freq / 1000;
 	hot_scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!hot_scheme)
 		goto out;
-	if (old_hot_scheme)
-		damon_lru_sort_copy_quota_status(&hot_scheme->quota,
-				&old_hot_scheme->quota);
 
 	cold_thres = cold_min_age / damon_lru_sort_mon_attrs.aggr_interval;
 	cold_scheme = damon_lru_sort_new_cold_scheme(cold_thres);
@@ -238,9 +215,6 @@ static int damon_lru_sort_apply_paramete
 		damon_destroy_scheme(hot_scheme);
 		goto out;
 	}
-	if (old_cold_scheme)
-		damon_lru_sort_copy_quota_status(&cold_scheme->quota,
-				&old_cold_scheme->quota);
 
 	damon_set_schemes(param_ctx, &hot_scheme, 1);
 	damon_add_scheme(param_ctx, cold_scheme);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

