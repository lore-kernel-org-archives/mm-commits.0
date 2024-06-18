Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BF1158DBA
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718739409; cv=none; b=PFAAACSokb2nkInFl5o6RKik3NFMjtbzMWsQYFwz762JI9wo8PJ4NS/tvm/5eq+IBL4ENIXX43qQwo53lVPUQb47WrWi0UWq/ePPPO+qP5CgHmgjA2+3YZkLAD+OBiPWi2g7jXGuv21XNnDeeVja/hDbfNuhDEgqPlxPKraAO4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718739409; c=relaxed/simple;
	bh=Qd7qC3b+/cwcTT+BV4giyRek2JSz6O4nTW7XR2jGP9M=;
	h=Date:To:From:Subject:Message-Id; b=EqbQoVVRom2sbri+wT6Zi/PW+V2W2GJNJ/w0OwdF0DOTESf4Tl9f9O+D1trXjzoyrplde5ttAK/nJdMYBnbOJTofNWQrbz5LDtnax86K66yXjXt7DPqM4eYbyaqR3P1KKwZaWo4Mf6S1dCSWnb8aGO9kajfbKZc/QYUWxttK7E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OfXUzvJn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OfXUzvJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9711C3277B;
	Tue, 18 Jun 2024 19:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718739409;
	bh=Qd7qC3b+/cwcTT+BV4giyRek2JSz6O4nTW7XR2jGP9M=;
	h=Date:To:From:Subject:From;
	b=OfXUzvJntyfsPm1GsPhjkbJ1+iHT9qpvqiMbadn4iqAmcl07sTYuDQNJpYANYumZ4
	 j3xbM6rCXWmkGGBr8SnoICGySTAaNG17Fzy8YAyOICbs3kDgOuutqyz0lQmsa8xVg7
	 c2vy4WjDv+B1VrwOwY0M3LqmtRkZ7Ts7zLFBQSXg=
Date: Tue, 18 Jun 2024 12:36:49 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch added to mm-unstable branch
Message-Id: <20240618193649.A9711C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: remove unnecessary online tuning handling code
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch

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

