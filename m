Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3188B8F6F
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739421; cv=none; b=hoXXHvBGCvXnBF9ojGhQD8D68MaZY8QQGx2pT2SAz1agkt7masXRtWeNxCLvKUd77efKvQ5cq4RPdGx0BNjlaBs3ErkXSq4+yOxlVcKJkwt20rkoQVpAVRxqCWiYL+6MZrnOxfpnY9Xjodf14mVo84pKQyxzvZlUVzXwD/rra38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739421; c=relaxed/simple;
	bh=jwFA1FV/X4yc46DIikEmnuEWwjtokvcyfPsLJr0ytR0=;
	h=Date:To:From:Subject:Message-Id; b=ZxturnE0xPtVWyOGxF4hLQgzBU1/Er18LwZxJHeZj1qJL8ugcJ8B7laBGYfSFqRQN7XrOIKk2rHuydrSoWzizHoFdmtqJEeHUelxrQ8rrtIy5PhGFnKGUr+LNbrIH+XjORsxMAAfhuFFwje4ekqjy2fn5x2PD0ix5ye5m4q3mdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pzc4Aytw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pzc4Aytw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06425C433C7;
	Sat, 24 Feb 2024 01:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739421;
	bh=jwFA1FV/X4yc46DIikEmnuEWwjtokvcyfPsLJr0ytR0=;
	h=Date:To:From:Subject:From;
	b=pzc4Aytw/hK4nWfOh492S2LFS/UShDr/CFqqhifxBueY98vaEQ31o0QdTIl3MqAFK
	 hk0pAdX48pNO6oYjrtok6r5c6f1YtXH0W+pB312QL4Zt+powCdsDN1R8Pe5Vdsvtl+
	 yFw6mHiYvQmXRK6UoAdzsfVXR2iYTawEmT+aqrkg=
Date: Fri, 23 Feb 2024 17:50:20 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch removed from -mm tree
Message-Id: <20240224015021.06425C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: let goal specified with only target and current values
has been removed from the -mm tree.  Its filename was
     mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: let goal specified with only target and current values
Date: Mon, 19 Feb 2024 11:44:22 -0800

DAMOS quota auto-tuning feature let users to set the goal by providing a
function for getting the current score of the tuned quota.  It allows
flexible goal setup, but only simple user-set quota is currently being
used.  As a result, the only user of the DAMOS quota auto-tuning is using
a silly void pointer casting based score value passing function.  Simplify
the interface and the user code by letting user directly set the target
and the current value.

Link: https://lkml.kernel.org/r/20240219194431.159606-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h    |   19 +++++++++----------
 mm/damon/core.c          |    9 +++++----
 mm/damon/sysfs-schemes.c |   10 ++--------
 3 files changed, 16 insertions(+), 22 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-let-goal-specified-with-only-target-and-current-values
+++ a/include/linux/damon.h
@@ -128,19 +128,18 @@ enum damos_action {
 
 /**
  * struct damos_quota_goal - DAMOS scheme quota auto-tuning goal.
- * @get_score:		Function for getting current score of the goal.
- * @get_score_arg:	Parameter for @get_score
+ * @target_value:	Target value to achieve with the tuning.
+ * @current_value:	Current value that achieving with the tuning.
  * @list:		List head for siblings.
  *
- * Data structure for getting the current score of the quota tuning goal.
- * Calling @get_score with @get_score_arg as the parameter should return the
- * current score.  Then the score is entered to DAMON's internal feedback loop
- * mechanism to get the auto-tuned quota.  The goal of the tuning is getting
- * the feedback score value of 10,000.
+ * Data structure for getting the current score of the quota tuning goal.  The
+ * score is calculated by how close @current_value and @target_value are.  Then
+ * the score is entered to DAMON's internal feedback loop mechanism to get the
+ * auto-tuned quota.
  */
 struct damos_quota_goal {
-	unsigned long (*get_score)(void *arg);
-	void *get_score_arg;
+	unsigned long target_value;
+	unsigned long current_value;
 	struct list_head list;
 };
 
@@ -690,7 +689,7 @@ void damos_add_filter(struct damos *s, s
 void damos_destroy_filter(struct damos_filter *f);
 
 struct damos_quota_goal *damos_new_quota_goal(
-		unsigned long (*get_score)(void *), void *get_score_arg);
+		unsigned long target_value, unsigned long current_value);
 void damos_add_quota_goal(struct damos_quota *q, struct damos_quota_goal *g);
 void damos_destroy_quota_goal(struct damos_quota_goal *goal);
 
--- a/mm/damon/core.c~mm-damon-core-let-goal-specified-with-only-target-and-current-values
+++ a/mm/damon/core.c
@@ -300,15 +300,15 @@ void damos_destroy_filter(struct damos_f
 }
 
 struct damos_quota_goal *damos_new_quota_goal(
-		unsigned long (*get_score)(void *), void *get_score_arg)
+		unsigned long target_value, unsigned long current_value)
 {
 	struct damos_quota_goal *goal;
 
 	goal = kmalloc(sizeof(*goal), GFP_KERNEL);
 	if (!goal)
 		return NULL;
-	goal->get_score = get_score;
-	goal->get_score_arg = get_score_arg;
+	goal->target_value = target_value;
+	goal->current_value = current_value;
 	INIT_LIST_HEAD(&goal->list);
 	return goal;
 }
@@ -1132,7 +1132,8 @@ static unsigned long damos_quota_score(s
 
 	damos_for_each_quota_goal(goal, quota)
 		highest_score = max(highest_score,
-				goal->get_score(goal->get_score_arg));
+				goal->current_value * 10000 /
+				goal->target_value);
 
 	return highest_score;
 }
--- a/mm/damon/sysfs-schemes.c~mm-damon-core-let-goal-specified-with-only-target-and-current-values
+++ a/mm/damon/sysfs-schemes.c
@@ -1882,11 +1882,6 @@ static int damon_sysfs_set_scheme_filter
 	return 0;
 }
 
-static unsigned long damos_sysfs_get_quota_score(void *arg)
-{
-	return (unsigned long)arg;
-}
-
 static int damos_sysfs_set_quota_score(
 		struct damos_sysfs_quota_goals *sysfs_goals,
 		struct damos_quota *quota)
@@ -1904,9 +1899,8 @@ static int damos_sysfs_set_quota_score(
 		if (!sysfs_goal->target_value)
 			continue;
 
-		goal = damos_new_quota_goal(damos_sysfs_get_quota_score,
-				(void *)(sysfs_goal->current_value * 10000 /
-				sysfs_goal->target_value));
+		goal = damos_new_quota_goal(sysfs_goal->target_value,
+				sysfs_goal->current_value);
 		if (!goal)
 			return -ENOMEM;
 		damos_add_quota_goal(quota, goal);
_

Patches currently in -mm which might be from sj@kernel.org are


