Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A18715BB
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387720; cv=none; b=lGgY5cwJqX/SqHzs66Rru0k8eNe4NZ5uiEhz/NpcCskfwAOaC9ftpVfw59HQte4+zZHdFTx35mtz6STCVxjt5PnP8vh9NWmYpcckmEkcnZDZ+Gs1IG0fUHD8A1oItVcka5oqcwUnIXb7kyyks4HS6SEQKb7a9bo/KADvez87Wk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387720; c=relaxed/simple;
	bh=xAFxiA3AYhW3NIWrTuT4dfV2qH31aRU9Sh8xTTD7l1w=;
	h=Date:To:From:Subject:Message-Id; b=KOVefhAHD/mPaOHvNyz49rPPnPvy+IhnYN/CEVcb8dAgXDL7qYdZXwsENrA3myJB+j6aqAAQJvEIMRzy+Qdr65Ds9Fvw+U5Ue3/7XFgb0e3Ko830gcAXUfMGuTbbKBvMoVdTwvaeTrg50D2ht+oWWoMQnMxD+LI+bY9atZalMRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ihscUD4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ihscUD4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871E9C433C7;
	Tue, 20 Feb 2024 00:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387719;
	bh=xAFxiA3AYhW3NIWrTuT4dfV2qH31aRU9Sh8xTTD7l1w=;
	h=Date:To:From:Subject:From;
	b=ihscUD4+oTWErkFKdf4QEyAthufAeWjL3/PQF0AFPGjTLQvNLhfDjO2b7RCbjL6jj
	 TiFoS4coR0YLnQSZiqHp/wnl9EM4YFuN0o4uo7AnBGXdigF9lIclKJXKdVVrjnW3jD
	 xmzd7DSWuJkf0qlDjp1nre8vneQmfXvnOTJX25kM=
Date: Mon, 19 Feb 2024 16:08:39 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-goal-field-of-damos_quota.patch added to mm-unstable branch
Message-Id: <20240220000839.871E9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: remove ->goal field of damos_quota
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-remove-goal-field-of-damos_quota.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-goal-field-of-damos_quota.patch

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

