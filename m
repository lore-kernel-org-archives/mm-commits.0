Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F2879F4
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739422; cv=none; b=nWlGlIzcMprT/nBam+2K1Uqw4o8JX8a3Nc/qHW3BOwH/tYgFKBs+oTRTm2bSEpNErTe2ZgfbYec5ayvZ3fjg33SK1UVNxWeafw8wlwB6fHo02sD6mJpsOlJXGT5fFdaySfF14zJVYGJjuG8kr1kpOEhhGCnvViuw0Km6NXihsMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739422; c=relaxed/simple;
	bh=hxZ8H9OIjpBNk8KK25XYNvce+uVFYFb+Cxu7ycuoZ14=;
	h=Date:To:From:Subject:Message-Id; b=SSHuTE042lk2hsPVBxq8+E/qPy2gPaJHk14bqAVclaZpgSH3322Ys0N6hAYMfR0GZT616KJAWSYiOEc15ojD9v9l7g7h7YEsCs1EoWs4HWHLKmVnFgAdUjVjKgjg8OVMDuT62S3KxHi/Jw8PbQCJ+wQ7Yt+zTWGJvHrBRhxnMmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vy3CRxmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vy3CRxmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB018C433F1;
	Sat, 24 Feb 2024 01:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739422;
	bh=hxZ8H9OIjpBNk8KK25XYNvce+uVFYFb+Cxu7ycuoZ14=;
	h=Date:To:From:Subject:From;
	b=vy3CRxmpFwNcuhwAfIJUxp/qeIOd56kn0iDWPJLj+NNwN7q+bfhLimLXhke5aCzJd
	 18vXBkvhuCh+P3Ef7d3xNdNp+l87KIUXt+tUpuZeJAi9UPDBK1GHyCTQZuSI4NkJBP
	 lgg5FW+w56W3/9m5071O9GwvKnUzzsoT0sQkQ0bk=
Date: Fri, 23 Feb 2024 17:50:21 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-support-multiple-metrics-for-quota-goal.patch removed from -mm tree
Message-Id: <20240224015021.EB018C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: support multiple metrics for quota goal
has been removed from the -mm tree.  Its filename was
     mm-damon-core-support-multiple-metrics-for-quota-goal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: support multiple metrics for quota goal
Date: Mon, 19 Feb 2024 11:44:23 -0800

DAMOS quota auto-tuning asks users to assess the current tuned quota and
provide the feedback in a manual and repeated way.  It allows users
generate the feedback from a source that the kernel cannot access, and
writing a script or a function for doing the manual and repeated feeding
is not a big deal.  However, additional works are additional works, and it
could be more efficient if DAMOS could do the fetch itself, especially in
case of DAMON sysfs interface use case, since it can avoid the context
switches between the user-space and the kernel-space, though the overhead
would be only trivial in most cases.  Also in many cases, feedbacks could
be made from kernel-accessible sources, such as PSI, CPU usage, etc.  Make
the quota goal to support multiple types of metrics including such ones.

Link: https://lkml.kernel.org/r/20240219194431.159606-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h    |   26 +++++++++++++++++++++++---
 mm/damon/core.c          |   22 +++++++++++++++++++---
 mm/damon/sysfs-schemes.c |    5 +++--
 3 files changed, 45 insertions(+), 8 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-support-multiple-metrics-for-quota-goal
+++ a/include/linux/damon.h
@@ -127,17 +127,36 @@ enum damos_action {
 };
 
 /**
+ * enum damos_quota_goal_metric - Represents the metric to be used as the goal
+ *
+ * @DAMOS_QUOTA_USER_INPUT:	User-input value.
+ * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
+ *
+ * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
+ */
+enum damos_quota_goal_metric {
+	DAMOS_QUOTA_USER_INPUT,
+	NR_DAMOS_QUOTA_GOAL_METRICS,
+};
+
+/**
  * struct damos_quota_goal - DAMOS scheme quota auto-tuning goal.
- * @target_value:	Target value to achieve with the tuning.
- * @current_value:	Current value that achieving with the tuning.
+ * @metric:		Metric to be used for representing the goal.
+ * @target_value:	Target value of @metric to achieve with the tuning.
+ * @current_value:	Current value of @metric.
  * @list:		List head for siblings.
  *
  * Data structure for getting the current score of the quota tuning goal.  The
  * score is calculated by how close @current_value and @target_value are.  Then
  * the score is entered to DAMON's internal feedback loop mechanism to get the
  * auto-tuned quota.
+ *
+ * If @metric is DAMOS_QUOTA_USER_INPUT, @current_value should be manually
+ * entered by the user, probably inside the kdamond callbacks.  Otherwise,
+ * DAMON sets @current_value with self-measured value of @metric.
  */
 struct damos_quota_goal {
+	enum damos_quota_goal_metric metric;
 	unsigned long target_value;
 	unsigned long current_value;
 	struct list_head list;
@@ -689,7 +708,8 @@ void damos_add_filter(struct damos *s, s
 void damos_destroy_filter(struct damos_filter *f);
 
 struct damos_quota_goal *damos_new_quota_goal(
-		unsigned long target_value, unsigned long current_value);
+		enum damos_quota_goal_metric metric,
+		unsigned long target_value);
 void damos_add_quota_goal(struct damos_quota *q, struct damos_quota_goal *g);
 void damos_destroy_quota_goal(struct damos_quota_goal *goal);
 
--- a/mm/damon/core.c~mm-damon-core-support-multiple-metrics-for-quota-goal
+++ a/mm/damon/core.c
@@ -300,15 +300,16 @@ void damos_destroy_filter(struct damos_f
 }
 
 struct damos_quota_goal *damos_new_quota_goal(
-		unsigned long target_value, unsigned long current_value)
+		enum damos_quota_goal_metric metric,
+		unsigned long target_value)
 {
 	struct damos_quota_goal *goal;
 
 	goal = kmalloc(sizeof(*goal), GFP_KERNEL);
 	if (!goal)
 		return NULL;
+	goal->metric = metric;
 	goal->target_value = target_value;
-	goal->current_value = current_value;
 	INIT_LIST_HEAD(&goal->list);
 	return goal;
 }
@@ -1124,16 +1125,31 @@ static unsigned long damon_feed_loop_nex
 	return min_input;
 }
 
+static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
+{
+	u64 now_psi_total;
+
+	switch (goal->metric) {
+	case DAMOS_QUOTA_USER_INPUT:
+		/* User should already set goal->current_value */
+		break;
+	default:
+		break;
+	}
+}
+
 /* Return the highest score since it makes schemes least aggressive */
 static unsigned long damos_quota_score(struct damos_quota *quota)
 {
 	struct damos_quota_goal *goal;
 	unsigned long highest_score = 0;
 
-	damos_for_each_quota_goal(goal, quota)
+	damos_for_each_quota_goal(goal, quota) {
+		damos_set_quota_goal_current_value(goal);
 		highest_score = max(highest_score,
 				goal->current_value * 10000 /
 				goal->target_value);
+	}
 
 	return highest_score;
 }
--- a/mm/damon/sysfs-schemes.c~mm-damon-core-support-multiple-metrics-for-quota-goal
+++ a/mm/damon/sysfs-schemes.c
@@ -1899,10 +1899,11 @@ static int damos_sysfs_set_quota_score(
 		if (!sysfs_goal->target_value)
 			continue;
 
-		goal = damos_new_quota_goal(sysfs_goal->target_value,
-				sysfs_goal->current_value);
+		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT,
+				sysfs_goal->target_value);
 		if (!goal)
 			return -ENOMEM;
+		goal->current_value = sysfs_goal->current_value;
 		damos_add_quota_goal(quota, goal);
 	}
 	return 0;
_

Patches currently in -mm which might be from sj@kernel.org are


