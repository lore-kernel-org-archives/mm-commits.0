Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAF010EF
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387724; cv=none; b=aKL+3E4FUYlDpI1/6KcKfudPHzM8OsCQQyNP/GkJ23Q9ogbPkl5RSD23PsYv5kD6FsWeKBTOilcXAy5VIT5iHhHc9gMiP7pSGJpdQoDBua0easQDkYI41sDink2P0lwOtdHhEghQOk1uQKjSnHKNTdfeGg8i7xcbPZdySvwKX3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387724; c=relaxed/simple;
	bh=zonR69wk3dbmlx+oaygQW/+A0/dHLHCHbtOa0/LxGC8=;
	h=Date:To:From:Subject:Message-Id; b=C/1QBGHkrpzytW0XRjy917d4asjDLd3zpY9+rl+ncGC42AnL6vcHHrtgvyVttbPF7hMg2hoqcKmI58uWPc6iWcljHSZ599CqJvP5D0Jk9AaLP5OVpf8m9C/dXpxWdyZz+r6hl+gJ69DJSULWgkBZ4g1ksdY4y3FA/HIEF3VHOzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1HPOiZS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1HPOiZS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31583C433C7;
	Tue, 20 Feb 2024 00:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387724;
	bh=zonR69wk3dbmlx+oaygQW/+A0/dHLHCHbtOa0/LxGC8=;
	h=Date:To:From:Subject:From;
	b=1HPOiZS8uTBPgxNgXlXDkxL+sfHf3OOQhAshbxK63HluluY6+oUrv/rWKSJrfkLIM
	 Y3ipKoJpYpvHdmCAPzkaDPVlaNTEDHiwql6awtKpNZP6tkWb1llsZlGd4iWmgl+nGw
	 Q+4BeAdJ1MzwB+thvanrwapM4A5SI9oyxv/xFULo=
Date: Mon, 19 Feb 2024 16:08:43 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-support-multiple-metrics-for-quota-goal.patch added to mm-unstable branch
Message-Id: <20240220000844.31583C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: support multiple metrics for quota goal
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-support-multiple-metrics-for-quota-goal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-support-multiple-metrics-for-quota-goal.patch

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

mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals.patch
mm-damon-reclaim-fix-quota-stauts-loss-due-to-online-tunings.patch
mm-damon-lru_sort-fix-quota-status-loss-due-to-online-tunings.patch
docs-admin-guide-mm-damon-usage-use-sysfs-interface-for-tracepoints-example.patch
mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch
mm-damon-dbgfs-implement-deprecation-notice-file.patch
mm-damon-dbgfs-make-debugfs-interface-deprecation-message-a-macro.patch
docs-admin-guide-mm-damon-usage-document-deprecated-file-of-damon-debugfs-interface.patch
selftets-damon-prepare-for-monitor_on-file-renaming.patch
mm-damon-dbgfs-rename-monitor_on-file-to-monitor_on_deprecated.patch
docs-admin-guide-mm-damon-usage-update-for-monitor_on-renaming.patch
docs-translations-damon-usage-update-for-monitor_on-renaming.patch
mm-damon-sysfs-handle-state-file-inputs-for-every-sampling-interval-if-possible.patch
selftests-damon-_damon_sysfs-support-damos-quota.patch
selftests-damon-_damon_sysfs-support-damos-stats.patch
selftests-damon-_damon_sysfs-support-damos-apply-interval.patch
selftests-damon-add-a-test-for-damos-quota.patch
selftests-damon-add-a-test-for-damos-apply-intervals.patch
selftests-damon-add-a-test-for-a-race-between-target_ids_read-and-dbgfs_before_terminate.patch
selftests-damon-add-a-test-for-the-pid-leak-of-dbgfs_target_ids_write.patch
selftests-damon-_chk_dependency-get-debugfs-mount-point-from-proc-mounts.patch
docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch
docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch
docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch
docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch
mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch
mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch
mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch
docs-abi-damon-document-effective_bytes-sysfs-file.patch
docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch
mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch
mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch
mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch
mm-damon-sysfs-use-only-quota-goals.patch
mm-damon-core-remove-goal-field-of-damos_quota.patch
mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch
mm-damon-core-support-multiple-metrics-for-quota-goal.patch
mm-damon-core-implement-psi-metric-damos-quota-goal.patch
mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch
docs-mm-damon-design-document-quota-goal-self-tuning.patch
docs-abi-damon-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch

