Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BFB14373B
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291740; cv=none; b=AyL1XmiNglZ7d4NcjOQ9Yp9GxtVjp7dijkmcYRxDhvT2whARasF2phxW9x6vrWwzCKP/FNBKRvz2isV4vWCbkoHrTOO21tjvqX4B/z4ul+OKYh5EDBLm3ZfObOPbVHAYw/4HvMkUu/0mP19XvWHD5kF6GcQvl4ZlC0d9GU8SgY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291740; c=relaxed/simple;
	bh=ETJFpsg16QrfKCJpotG/xmhRy3zLI0Qa2rjH9wzqWRo=;
	h=Date:To:From:Subject:Message-Id; b=GK2MjbHL6zsyV3QNlMoAKZldmjbQNbxEk1clfHwQlgb4qcVVjjY3DGuRv95kr9MP9QjFB5RTVm2ITys14fBnk1KaYtd9iM6S9lPLtasP9YqF5XFCQbwyvMwK+XhgLiY7cZ4Zws7bGEUQ2NDaiKBLHD+tZlySAoYJ7gb3nU8N/VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bxOfY9MN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bxOfY9MN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7779DC32782;
	Tue, 25 Jun 2024 05:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291740;
	bh=ETJFpsg16QrfKCJpotG/xmhRy3zLI0Qa2rjH9wzqWRo=;
	h=Date:To:From:Subject:From;
	b=bxOfY9MNtYWfv0Ao1hhn7S8kOFE5pLLfroJI0sv91lul9R8wFv60JPUjBuJS5dhmS
	 wZdHx9cp/lBP/ThtYWTjjXwX6XZWe0vmlctAQmmPf98K64TNqW0IKxqtr6nSjpYCwG
	 SlX1YTWPrIZfTAJ6rFndpZP7EOvOzQHCNdQWwhGs=
Date: Mon, 24 Jun 2024 22:02:19 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code.patch removed from -mm tree
Message-Id: <20240625050220.7779DC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: remove unnecessary online tuning handling code
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: remove unnecessary online tuning handling code
Date: Tue, 18 Jun 2024 11:18:04 -0700

damon/sysfs-schemes.c contains code for handling of online DAMON
parameters update edge cases.  The logics are no more necessary since
damon_commit_ctx() and damon_commit_quota_goals() takes care of the cases.
Remove the unnecessary code.

Link: https://lkml.kernel.org/r/20240618181809.82078-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   68 +------------------------------------
 1 file changed, 3 insertions(+), 65 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code
+++ a/mm/damon/sysfs-schemes.c
@@ -1912,10 +1912,6 @@ static int damon_sysfs_set_scheme_filter
 		struct damon_sysfs_scheme_filters *sysfs_filters)
 {
 	int i;
-	struct damos_filter *filter, *next;
-
-	damos_for_each_filter_safe(filter, next, scheme)
-		damos_destroy_filter(filter);
 
 	for (i = 0; i < sysfs_filters->nr; i++) {
 		struct damon_sysfs_scheme_filter *sysfs_filter =
@@ -1955,12 +1951,9 @@ static int damos_sysfs_set_quota_score(
 		struct damos_sysfs_quota_goals *sysfs_goals,
 		struct damos_quota *quota)
 {
-	struct damos_quota_goal *goal, *next;
+	struct damos_quota_goal *goal;
 	int i;
 
-	damos_for_each_quota_goal_safe(goal, next, quota)
-		damos_destroy_quota_goal(goal);
-
 	for (i = 0; i < sysfs_goals->nr; i++) {
 		struct damos_sysfs_quota_goal *sysfs_goal =
 			sysfs_goals->goals_arr[i];
@@ -2091,67 +2084,12 @@ static struct damos *damon_sysfs_mk_sche
 	return scheme;
 }
 
-static void damon_sysfs_update_scheme(struct damos *scheme,
-		struct damon_sysfs_scheme *sysfs_scheme)
-{
-	struct damon_sysfs_access_pattern *access_pattern =
-		sysfs_scheme->access_pattern;
-	struct damon_sysfs_quotas *sysfs_quotas = sysfs_scheme->quotas;
-	struct damon_sysfs_weights *sysfs_weights = sysfs_quotas->weights;
-	struct damon_sysfs_watermarks *sysfs_wmarks = sysfs_scheme->watermarks;
-	int err;
-
-	scheme->pattern.min_sz_region = access_pattern->sz->min;
-	scheme->pattern.max_sz_region = access_pattern->sz->max;
-	scheme->pattern.min_nr_accesses = access_pattern->nr_accesses->min;
-	scheme->pattern.max_nr_accesses = access_pattern->nr_accesses->max;
-	scheme->pattern.min_age_region = access_pattern->age->min;
-	scheme->pattern.max_age_region = access_pattern->age->max;
-
-	scheme->action = sysfs_scheme->action;
-	scheme->apply_interval_us = sysfs_scheme->apply_interval_us;
-	scheme->target_nid = sysfs_scheme->target_nid;
-
-	scheme->quota.ms = sysfs_quotas->ms;
-	scheme->quota.sz = sysfs_quotas->sz;
-	scheme->quota.reset_interval = sysfs_quotas->reset_interval_ms;
-	scheme->quota.weight_sz = sysfs_weights->sz;
-	scheme->quota.weight_nr_accesses = sysfs_weights->nr_accesses;
-	scheme->quota.weight_age = sysfs_weights->age;
-
-	err = damos_sysfs_set_quota_score(sysfs_quotas->goals, &scheme->quota);
-	if (err) {
-		damon_destroy_scheme(scheme);
-		return;
-	}
-
-	scheme->wmarks.metric = sysfs_wmarks->metric;
-	scheme->wmarks.interval = sysfs_wmarks->interval_us;
-	scheme->wmarks.high = sysfs_wmarks->high;
-	scheme->wmarks.mid = sysfs_wmarks->mid;
-	scheme->wmarks.low = sysfs_wmarks->low;
-
-	err = damon_sysfs_set_scheme_filters(scheme, sysfs_scheme->filters);
-	if (err)
-		damon_destroy_scheme(scheme);
-}
-
 int damon_sysfs_set_schemes(struct damon_ctx *ctx,
 		struct damon_sysfs_schemes *sysfs_schemes)
 {
-	struct damos *scheme, *next;
-	int i = 0;
-
-	damon_for_each_scheme_safe(scheme, next, ctx) {
-		if (i < sysfs_schemes->nr)
-			damon_sysfs_update_scheme(scheme,
-					sysfs_schemes->schemes_arr[i]);
-		else
-			damon_destroy_scheme(scheme);
-		i++;
-	}
+	int i;
 
-	for (; i < sysfs_schemes->nr; i++) {
+	for (i = 0; i < sysfs_schemes->nr; i++) {
 		struct damos *scheme, *next;
 
 		scheme = damon_sysfs_mk_scheme(sysfs_schemes->schemes_arr[i]);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

