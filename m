Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F438F6F
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739417; cv=none; b=PKghXSsL2A0EqpePrZk05Zb4FR/NI0ACV+iWSagKGOpE+p1M7vqs5Crpz0zQk32pJ7HKfyna4E1qPtCpfbmCh7OknFFyYJqBaQLBH1pl7pEtqvAZtb6y/I4BX+jfKnDHFejNWeSpAKHuAFs9Gn2Zp7gYlV3Z1X9bcmCJrBL0jvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739417; c=relaxed/simple;
	bh=NmLNGqosR9DXPmskVppWLE+Z/9VBhLmLP25GbI+5qJY=;
	h=Date:To:From:Subject:Message-Id; b=VzxXXZG6crJVxEkp0cOTa5MomMxnH8VyA/8HoP16m6h6dWJLnlKmhjlmigvM1yszU44YlzQjhOLorfbXpEtgR5gebG14JjMpsKmUDmDRrrRMMVpmNmErsFLpMRY5VhprDgglQgeK9mMFsz7b0etJsncQ3pUkaeb9x8msCJSFO1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vcB4OsKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vcB4OsKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DD7C433C7;
	Sat, 24 Feb 2024 01:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739417;
	bh=NmLNGqosR9DXPmskVppWLE+Z/9VBhLmLP25GbI+5qJY=;
	h=Date:To:From:Subject:From;
	b=vcB4OsKA+46bE4xfcsz4EJUwiBcpcOQmIfwiLJ+LAlvdur0bR0y87Qz0QjKqkLHhv
	 y7ksrQbj6l+trm4Stuxw/Zs8XQFF9oMe/jlHCliUBJnGORlAybJmeza+DkUzDeUuyl
	 YTrJ8LjmZJrpxhNdVIDDIw7iiwtD4350IEKdO5Uo=
Date: Fri, 23 Feb 2024 17:50:16 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch removed from -mm tree
Message-Id: <20240224015017.50DD7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: split out quota goal related fields to a struct
has been removed from the -mm tree.  Its filename was
     mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: split out quota goal related fields to a struct
Date: Mon, 19 Feb 2024 11:44:18 -0800

'struct damos_quota' is not small now.  Split out fields for quota goal to
a separate struct for easier reading.

Link: https://lkml.kernel.org/r/20240219194431.159606-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h    |   36 ++++++++++++++++++++++--------------
 mm/damon/core.c          |   13 +++++++------
 mm/damon/sysfs-schemes.c |   10 +++++-----
 3 files changed, 34 insertions(+), 25 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-split-out-quota-goal-related-fields-to-a-struct
+++ a/include/linux/damon.h
@@ -127,12 +127,27 @@ enum damos_action {
 };
 
 /**
+ * struct damos_quota_goal - DAMOS scheme quota auto-tuning goal.
+ * @get_score:		Function for getting current score of the goal.
+ * @get_score_arg:	Parameter for @get_score
+ *
+ * Data structure for getting the current score of the quota tuning goal.
+ * Calling @get_score with @get_score_arg as the parameter should return the
+ * current score.  Then the score is entered to DAMON's internal feedback loop
+ * mechanism to get the auto-tuned quota.  The goal of the tuning is getting
+ * the feedback score value of 10,000.
+ */
+struct damos_quota_goal {
+	unsigned long (*get_score)(void *arg);
+	void *get_score_arg;
+};
+
+/**
  * struct damos_quota - Controls the aggressiveness of the given scheme.
  * @reset_interval:	Charge reset interval in milliseconds.
  * @ms:			Maximum milliseconds that the scheme can use.
  * @sz:			Maximum bytes of memory that the action can be applied.
- * @get_score:		Feedback function for self-tuning quota.
- * @get_score_arg:	Parameter for @get_score
+ * @goal:		Quota auto-tuning goal.
  * @esz:		Effective size quota in bytes.
  *
  * @weight_sz:		Weight of the region's size for prioritization.
@@ -151,16 +166,10 @@ enum damos_action {
  * throughput of the scheme's action.  DAMON then compares it against &sz and
  * uses smaller one as the effective quota.
  *
- * If @get_score function pointer is set, DAMON calls it back with
- * @get_score_arg and get the return value of it for every @reset_interval.
- * Then, DAMON adjusts the effective quota using the return value as a feedback
- * score to the current quota, using its internal feedback loop algorithm.
- *
- * The feedback loop algorithem assumes the quota input and the feedback score
- * output are in a positive proportional relationship, and the goal of the
- * tuning is getting the feedback screo value of 10,000.  If @ms and/or @sz are
- * set together, those work as a hard limit quota.  If neither @ms nor @sz are
- * set, the mechanism starts from the quota of one byte.
+ * If ->get_score field of @goal is set, DAMON calculates yet another size
+ * quota based on the goal using its internal feedback loop algorithm, for
+ * every @reset_interval.  Then, if the new size quota is smaller than the
+ * effective quota, it uses the new size quota as the effective quota.
  *
  * The resulting effective size quota in bytes is set to @esz.
  *
@@ -174,8 +183,7 @@ struct damos_quota {
 	unsigned long reset_interval;
 	unsigned long ms;
 	unsigned long sz;
-	unsigned long (*get_score)(void *arg);
-	void *get_score_arg;
+	struct damos_quota_goal goal;
 	unsigned long esz;
 
 	unsigned int weight_sz;
--- a/mm/damon/core.c~mm-damon-core-split-out-quota-goal-related-fields-to-a-struct
+++ a/mm/damon/core.c
@@ -1083,21 +1083,22 @@ static unsigned long damon_feed_loop_nex
 	return min_input;
 }
 
-/* Shouldn't be called if quota->ms, quota->sz, and quota->get_score unset */
+/* Called only if quota->ms, quota->sz, or quota->goal.get_score are set */
 static void damos_set_effective_quota(struct damos_quota *quota)
 {
 	unsigned long throughput;
 	unsigned long esz;
 
-	if (!quota->ms && !quota->get_score) {
+	if (!quota->ms && !quota->goal.get_score) {
 		quota->esz = quota->sz;
 		return;
 	}
 
-	if (quota->get_score) {
+	if (quota->goal.get_score) {
 		quota->esz_bp = damon_feed_loop_next_input(
 				max(quota->esz_bp, 10000UL),
-				quota->get_score(quota->get_score_arg));
+				quota->goal.get_score(
+					quota->goal.get_score_arg));
 		esz = quota->esz_bp / 10000;
 	}
 
@@ -1107,7 +1108,7 @@ static void damos_set_effective_quota(st
 				quota->total_charged_ns;
 		else
 			throughput = PAGE_SIZE * 1024;
-		if (quota->get_score)
+		if (quota->goal.get_score)
 			esz = min(throughput * quota->ms, esz);
 		else
 			esz = throughput * quota->ms;
@@ -1127,7 +1128,7 @@ static void damos_adjust_quota(struct da
 	unsigned long cumulated_sz;
 	unsigned int score, max_score = 0;
 
-	if (!quota->ms && !quota->sz && !quota->get_score)
+	if (!quota->ms && !quota->sz && !quota->goal.get_score)
 		return;
 
 	/* New charge window starts */
--- a/mm/damon/sysfs-schemes.c~mm-damon-core-split-out-quota-goal-related-fields-to-a-struct
+++ a/mm/damon/sysfs-schemes.c
@@ -1894,19 +1894,19 @@ static void damos_sysfs_set_quota_score(
 	struct damos_sysfs_quota_goal *sysfs_goal;
 	int i;
 
-	quota->get_score = NULL;
-	quota->get_score_arg = (void *)0;
+	quota->goal.get_score = NULL;
+	quota->goal.get_score_arg = (void *)0;
 	for (i = 0; i < sysfs_goals->nr; i++) {
 		sysfs_goal = sysfs_goals->goals_arr[i];
 		if (!sysfs_goal->target_value)
 			continue;
 
 		/* Higher score makes scheme less aggressive */
-		quota->get_score_arg = (void *)max(
-				(unsigned long)quota->get_score_arg,
+		quota->goal.get_score_arg = (void *)max(
+				(unsigned long)quota->goal.get_score_arg,
 				sysfs_goal->current_value * 10000 /
 				sysfs_goal->target_value);
-		quota->get_score = damos_sysfs_get_quota_score;
+		quota->goal.get_score = damos_sysfs_get_quota_score;
 	}
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are


