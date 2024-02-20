Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7756A28
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387712; cv=none; b=EBJo6Gwq2A+VI+9CVTs0cZ6vF7MVBmGsyKGxYwHNFNkdrVY0JYEa/XMzYNCEu1xb7WZXZkwKtpY6kVlged3idGd7icINZUcvsvMeGZWK/66hOszLpvkvo5uzX3p5olkJVTE+RWUBdvlIYWc7QE3+4YW9xsU0rQgW8JxwV0lQfNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387712; c=relaxed/simple;
	bh=A+5YYSg4aNvJ1JOXLpcO926PZ7ONBaRb+e3y2rI7OpA=;
	h=Date:To:From:Subject:Message-Id; b=VUxiHjtlsZjmWscIBAhfSt9NP4Bko+5JQhFTXSYKYu+MNzUbkZOAgLdwST6wT2exUYnwT0IGUb688FvXqmAw9BvfWJcmHKYFsfCOWeIWm4hQv70f/A5EMaeNurjFnQhQ1NE0xMPY9UIsXNcc3CyunqK51uG8vcBizd3mYzRtUb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jJ/+jQnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jJ/+jQnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B19C433C7;
	Tue, 20 Feb 2024 00:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387712;
	bh=A+5YYSg4aNvJ1JOXLpcO926PZ7ONBaRb+e3y2rI7OpA=;
	h=Date:To:From:Subject:From;
	b=jJ/+jQnk1USjrqvtylmJnPVdFfc3D6cvBfvQyGWjVVylkIeAZ4RmOE5uELhtTJQNR
	 BNyEjYchWgQqQRiKj8FuhwiurmmQzsMBZRy2r6/jhBkHtiaVrhEKo/iX9V75YibUym
	 MnJmWCJU4idGMG9xQDZKynbUKyrInO79md3MesMU=
Date: Mon, 19 Feb 2024 16:08:31 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch added to mm-unstable branch
Message-Id: <20240220000832.48B19C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: split out quota goal related fields to a struct
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch

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

