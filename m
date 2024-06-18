Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0597E158DBA
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 19:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718739408; cv=none; b=Ny6M+hEecDsyfXlgYlGhloykdDPZig1PjWU0H4vB75OKi1gdnJ+Sv6pDDaM5Gjy7wU3FHewlEdW8Sj9vk1wk1JINjrPqaVzcEKGEvni761/uUW+SBsk3pskfiacPCSjO7xCWfMPOHWk8o6pq7E5t7B0Hv2UQ1lxLlZyvdSC3a2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718739408; c=relaxed/simple;
	bh=HnRdKosl7nc75NI71kqNvjbpY5F546Xt2MU/3VxjuvE=;
	h=Date:To:From:Subject:Message-Id; b=lHDgtrNBUdCPo5K7LWcdvXcyoW+IYDclNJFM9J90OKTlDau7luil93S6HU2FsCpP5BYXk0+EY4+uZEZxVK7q9MT+XSePmliMe6uIajNDRrDeQc0KKGhL1onjf8aeSv8mCsO3kvJH0+6sImAvSKugB68SSZdOWqmCezk0fPcRPLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1SOq2biK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1SOq2biK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEBDFC3277B;
	Tue, 18 Jun 2024 19:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718739407;
	bh=HnRdKosl7nc75NI71kqNvjbpY5F546Xt2MU/3VxjuvE=;
	h=Date:To:From:Subject:From;
	b=1SOq2biKtAjqECbuVNoSba7KV0peYcSgJpmyaR8Ce6JuEsM4UqJjWeHcZ7Q7f2KCV
	 8Gn+3kNq3oU09BB1vEZzjOBhylYj2vYlu45OmOB6Jo5c7ZxxvSF3USz2gGMaKB4SBP
	 lXDMnPJnXA4OHUFYEPXHvbJriBLN5wPd0CLJZ4n0=
Date: Tue, 18 Jun 2024 12:36:47 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-use-damon_commit_ctx.patch added to mm-unstable branch
Message-Id: <20240618193647.CEBDFC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: use damon_commit_ctx()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-lru_sort-use-damon_commit_ctx.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-use-damon_commit_ctx.patch

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

