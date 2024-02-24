Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BC48F6F
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739420; cv=none; b=j9hDoBdvRsG3vOUA6DoWwrjzZ4LscDBev8qds6i92cUcQhg1P60M5IzYFQDrzHJ0pz+nBYFowuz9o4YiKRTvY1YhAOvMtqhXp0WOHZj2DNA3bQxCg6KtpZcjbzcYj76FliU+X13lcuLAQy0hk3TvFkb1t8a0BLrjdX2FdVaVJaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739420; c=relaxed/simple;
	bh=14HV3NrH+1/XIImpxYfe7qjrimqS8h4xPBeD6xJ2W+U=;
	h=Date:To:From:Subject:Message-Id; b=GOYNk1cLgyJmWXSMfa2mojG3SKTg6zce5vU+Co9KfxvGpJCCmwN0LwIRPIFgUiTtmNWqveuqud/4zLHcrMokWMrPrzxhi15Y3ASJAFNdj7jE4QJl7PzQ3fvNUFhDVM8FHXBwiQ93rmQLVYltQ+3odyoe95NAhyXOdnc7j4AC550=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HDE6ceOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HDE6ceOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C6CC43390;
	Sat, 24 Feb 2024 01:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739420;
	bh=14HV3NrH+1/XIImpxYfe7qjrimqS8h4xPBeD6xJ2W+U=;
	h=Date:To:From:Subject:From;
	b=HDE6ceOZEyefThLWvd4XgWnMRQV4BoJZ2wJKefSvMKuSSQp60QYcpc4r65thzQxlF
	 w1fPsLXJ8y4E0cV2LQcNoDeQ65uLFoMdOxjDmmB3LdOVE8A+WPxeBP/scj+4KI9s9v
	 lT60D0rPWU2F7BnGCtku3EakIKyJhugw+EVuDnwM=
Date: Fri, 23 Feb 2024 17:50:19 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-remove-goal-field-of-damos_quota.patch removed from -mm tree
Message-Id: <20240224015020.17C6CC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: remove ->goal field of damos_quota
has been removed from the -mm tree.  Its filename was
     mm-damon-core-remove-goal-field-of-damos_quota.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: remove ->goal field of damos_quota
Date: Mon, 19 Feb 2024 11:44:21 -0800

DAMOS quota auto-tuning feature supports static signle goal and dynamic
multiple goals via DAMON kernel API, specifically via ->goal and ->goals
fields of damos_quota struct, respectively.  All in-tree DAMOS kernel API
users are using only the dynamic multiple goals now.  Remove the unsued
static single goal interface.

Link: https://lkml.kernel.org/r/20240219194431.159606-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   12 ++++--------
 mm/damon/core.c       |   17 +++++------------
 2 files changed, 9 insertions(+), 20 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-remove-goal-field-of-damos_quota
+++ a/include/linux/damon.h
@@ -149,7 +149,6 @@ struct damos_quota_goal {
  * @reset_interval:	Charge reset interval in milliseconds.
  * @ms:			Maximum milliseconds that the scheme can use.
  * @sz:			Maximum bytes of memory that the action can be applied.
- * @goal:		Quota auto-tuning goal.
  * @goals:		Head of quota tuning goals (&damos_quota_goal) list.
  * @esz:		Effective size quota in bytes.
  *
@@ -169,12 +168,10 @@ struct damos_quota_goal {
  * throughput of the scheme's action.  DAMON then compares it against &sz and
  * uses smaller one as the effective quota.
  *
- * If ->get_score field of @goal is set, DAMON calculates yet another size
- * quota based on the goal using its internal feedback loop algorithm, for
- * every @reset_interval.  Then, if the new size quota is smaller than the
- * effective quota, it uses the new size quota as the effective quota.
- *
- * If @goals is not empty, same action is taken for each goal of the list.
+ * If @goals is not empt, DAMON calculates yet another size quota based on the
+ * goals using its internal feedback loop algorithm, for every @reset_interval.
+ * Then, if the new size quota is smaller than the effective quota, it uses the
+ * new size quota as the effective quota.
  *
  * The resulting effective size quota in bytes is set to @esz.
  *
@@ -188,7 +185,6 @@ struct damos_quota {
 	unsigned long reset_interval;
 	unsigned long ms;
 	unsigned long sz;
-	struct damos_quota_goal goal;
 	struct list_head goals;
 	unsigned long esz;
 
--- a/mm/damon/core.c~mm-damon-core-remove-goal-field-of-damos_quota
+++ a/mm/damon/core.c
@@ -1130,10 +1130,6 @@ static unsigned long damos_quota_score(s
 	struct damos_quota_goal *goal;
 	unsigned long highest_score = 0;
 
-	if (quota->goal.get_score)
-		highest_score = quota->goal.get_score(
-				quota->goal.get_score_arg);
-
 	damos_for_each_quota_goal(goal, quota)
 		highest_score = max(highest_score,
 				goal->get_score(goal->get_score_arg));
@@ -1142,21 +1138,19 @@ static unsigned long damos_quota_score(s
 }
 
 /*
- * Called only if quota->ms, quota->sz, or quota->goal.get_score are set, or
- * quota->goals is not empty
+ * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
 static void damos_set_effective_quota(struct damos_quota *quota)
 {
 	unsigned long throughput;
 	unsigned long esz;
 
-	if (!quota->ms && !quota->goal.get_score &&
-			list_empty(&quota->goals)) {
+	if (!quota->ms && list_empty(&quota->goals)) {
 		quota->esz = quota->sz;
 		return;
 	}
 
-	if (quota->goal.get_score || !list_empty(&quota->goals)) {
+	if (!list_empty(&quota->goals)) {
 		unsigned long score = damos_quota_score(quota);
 
 		quota->esz_bp = damon_feed_loop_next_input(
@@ -1171,7 +1165,7 @@ static void damos_set_effective_quota(st
 				quota->total_charged_ns;
 		else
 			throughput = PAGE_SIZE * 1024;
-		if (quota->goal.get_score || !list_empty(&quota->goals))
+		if (!list_empty(&quota->goals))
 			esz = min(throughput * quota->ms, esz);
 		else
 			esz = throughput * quota->ms;
@@ -1191,8 +1185,7 @@ static void damos_adjust_quota(struct da
 	unsigned long cumulated_sz;
 	unsigned int score, max_score = 0;
 
-	if (!quota->ms && !quota->sz && !quota->goal.get_score &&
-			list_empty(&quota->goals))
+	if (!quota->ms && !quota->sz && list_empty(&quota->goals))
 		return;
 
 	/* New charge window starts */
_

Patches currently in -mm which might be from sj@kernel.org are


