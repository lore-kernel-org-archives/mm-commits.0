Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39D17FE
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387729; cv=none; b=gTmOTS+s6yNSBL/bnY0JrDq94PTwOpCL/BX4w4efmAqZWSzkP7PsWD1WIWQG0EvjbrwJGpLSMa7CpAzmUvngtHUgMn9RRJ1PFil0PLYH4MHR+RguV6soYWaBZ5MN8UfH5RwfIL68YKvQcDtmByvNVUOGcBSwbTYVl4kmHnzSVcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387729; c=relaxed/simple;
	bh=b5gun78jXpHY+IN03rBsk09MPRzP1hoiDQXV1mpMhqQ=;
	h=Date:To:From:Subject:Message-Id; b=LLG8/tZsHj4dUtPdwRPxvkEgxXH+x5SL5YXqD81ICAupCZkN3V37CEsANU1itxlXx5v2gHWomKSvY1QuXWymINcj4YGGy6WF6sAZNUeEdG4RywfwIEW+/WEq1s/Aaj/Sxw0wr4EdBmMHNEg7e3m1dZWUZmDcBQ56MKtCM6jwi8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NxDncZni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NxDncZni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58C4C433F1;
	Tue, 20 Feb 2024 00:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387728;
	bh=b5gun78jXpHY+IN03rBsk09MPRzP1hoiDQXV1mpMhqQ=;
	h=Date:To:From:Subject:From;
	b=NxDncZniWHdJCLnIn0kWcNgvQN+KHFsd7weTeJGzxS4S37/nfVLCQYh1crQ2cNZHW
	 AuQkHIFXZY/Faj9byReTZMbWXAW3sGUUwV5GbJZ1uIvsdlxVHEeFX0wU4H8CL9YYtU
	 yGsVyAu+AbQEPRw95iIXhaR7JvQ9VhFeSCSLAnGc=
Date: Mon, 19 Feb 2024 16:08:48 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch added to mm-unstable branch
Message-Id: <20240220000848.B58C4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: support PSI-based quota auto-tune
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch

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
Subject: mm/damon/sysfs-schemes: support PSI-based quota auto-tune
Date: Mon, 19 Feb 2024 11:44:25 -0800

Extend DAMON sysfs interface to support the PSI-based quota auto-tuning by
adding a new file, 'target_metric' under the quota goal directory.  Old
users don't get any behavioral changes since the default value of the
metric is 'user input'.

Link: https://lkml.kernel.org/r/20240219194431.159606-15-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   42 +++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune
+++ a/mm/damon/sysfs-schemes.c
@@ -826,15 +826,48 @@ static const struct kobj_type damon_sysf
 
 struct damos_sysfs_quota_goal {
 	struct kobject kobj;
+	enum damos_quota_goal_metric metric;
 	unsigned long target_value;
 	unsigned long current_value;
 };
 
+/* This should match with enum damos_action */
+static const char * const damos_sysfs_quota_goal_metric_strs[] = {
+	"user_input",
+	"some_mem_psi_us",
+};
+
 static struct damos_sysfs_quota_goal *damos_sysfs_quota_goal_alloc(void)
 {
 	return kzalloc(sizeof(struct damos_sysfs_quota_goal), GFP_KERNEL);
 }
 
+static ssize_t target_metric_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+
+	return sysfs_emit(buf, "%s\n",
+			damos_sysfs_quota_goal_metric_strs[goal->metric]);
+}
+
+static ssize_t target_metric_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj,
+			struct damos_sysfs_quota_goal, kobj);
+	enum damos_quota_goal_metric m;
+
+	for (m = 0; m < NR_DAMOS_QUOTA_GOAL_METRICS; m++) {
+		if (sysfs_streq(buf, damos_sysfs_quota_goal_metric_strs[m])) {
+			goal->metric = m;
+			return count;
+		}
+	}
+	return -EINVAL;
+}
+
 static ssize_t target_value_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
 {
@@ -880,6 +913,9 @@ static void damos_sysfs_quota_goal_relea
 	kfree(container_of(kobj, struct damos_sysfs_quota_goal, kobj));
 }
 
+static struct kobj_attribute damos_sysfs_quota_goal_target_metric_attr =
+		__ATTR_RW_MODE(target_metric, 0600);
+
 static struct kobj_attribute damos_sysfs_quota_goal_target_value_attr =
 		__ATTR_RW_MODE(target_value, 0600);
 
@@ -887,6 +923,7 @@ static struct kobj_attribute damos_sysfs
 		__ATTR_RW_MODE(current_value, 0600);
 
 static struct attribute *damos_sysfs_quota_goal_attrs[] = {
+	&damos_sysfs_quota_goal_target_metric_attr.attr,
 	&damos_sysfs_quota_goal_target_value_attr.attr,
 	&damos_sysfs_quota_goal_current_value_attr.attr,
 	NULL,
@@ -1899,11 +1936,12 @@ static int damos_sysfs_set_quota_score(
 		if (!sysfs_goal->target_value)
 			continue;
 
-		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT,
+		goal = damos_new_quota_goal(sysfs_goal->metric,
 				sysfs_goal->target_value);
 		if (!goal)
 			return -ENOMEM;
-		goal->current_value = sysfs_goal->current_value;
+		if (sysfs_goal->metric == DAMOS_QUOTA_USER_INPUT)
+			goal->current_value = sysfs_goal->current_value;
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

