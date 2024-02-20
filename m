Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E3210EF
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387722; cv=none; b=P3yYLDcyIheJq28wl3mL+KS4E1ezUH3AL3Utoug8rYI5JOH7FR4i3aCldBGwmPuyw1lKJu2nPB63qZzn+Mcf5nM4J52PupzDJT+IsmOTDRmIRAHN/nPxMVlfKdiJWNCfgsM8E65doNGtRVKzvbGH+HYIFVhrysgX9PF3zBnDlqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387722; c=relaxed/simple;
	bh=mxKsJC/wd4wkdE3q5O70gAOY2UIfsrei8rOaqQ92tW4=;
	h=Date:To:From:Subject:Message-Id; b=VcqfCYlndmVrEeKem1RrsVSNqFb6DL9ONqg7OoLVvyoe3cw8gQp814QwOpMLKxvriEEj9jj+FLuyJjReHCYMqOFhu/giW8d2AHAM1OjNatqmsZbYsA9aPoXKAtqewfm1Q3ruIsK2n3kpS2/6Ng1IqwZutU9rDCnaJnC1buHwgs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2gtpL9Ac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2gtpL9Ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C84C433F1;
	Tue, 20 Feb 2024 00:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387721;
	bh=mxKsJC/wd4wkdE3q5O70gAOY2UIfsrei8rOaqQ92tW4=;
	h=Date:To:From:Subject:From;
	b=2gtpL9Ac0RR8AwXmuLQvy1phEiysMxQdXvC4gGuhowFjh4d0gWkEOplUm1yVfLDR/
	 CgqwMy+bzTQcP/j44NJp3XX0AeV+Wgqu/WOPmRQzxjcFCvZSoc8OrkzuUIqKmBhWOe
	 z3Ov/hM9xIi1nsFklPgYlDZL4re94fedT3+9eLWM=
Date: Mon, 19 Feb 2024 16:08:41 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch added to mm-unstable branch
Message-Id: <20240220000841.B5C84C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: let goal specified with only target and current values
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch

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

