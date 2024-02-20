Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2107110EF
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387727; cv=none; b=GfIpYstNhCuhN8dINvsZ2ucTPLT7LLSrWjTydJBZ93GTPR41NXQhg1fNYyuNkCKX7uD7PtzHkYwzS5l7rHq29sMNvgMgE/swJmUG72OcvOK9YJPDiQawPkWvWlzFn9pgET99WHsD3/6V7/rNx2l3V1gj1YFlxGWnbqnucahxkes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387727; c=relaxed/simple;
	bh=xq8J3Aenzb1FcrZ254yWKsY1Zf/khJSDHwpsHa4SawU=;
	h=Date:To:From:Subject:Message-Id; b=ok0NviInWWsOHnYielSc7llS0PP9QsTFk7nzF0+mj6f2ds3MqcvrChiIDTNKavxKOVr8E1zax4xMb6Jv+gkqbZjA4xcD27OvSOQFguzjjB46yLb1UuQc6Q59LUEd9xtgioGE4Th1gC9TcndlOIh/AJKhv84dDGYLO/bguiIQEoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qz5pMetj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qz5pMetj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70AFC433C7;
	Tue, 20 Feb 2024 00:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387726;
	bh=xq8J3Aenzb1FcrZ254yWKsY1Zf/khJSDHwpsHa4SawU=;
	h=Date:To:From:Subject:From;
	b=Qz5pMetjDN3dszLFhWakTrjRAl4r/cuMnn+qy9FKEknDZNd/suLykIFoqlw/X7kka
	 89VGavKC1lsaCnDFQHu3Hc3WJNePu1+iXtR1OWL+E2c05tgfyMKJ5aQ/HeU9GqLBM/
	 QIvwE0PiRkNCRVyU1MCLsdZrXyeMDF24nNKcl3sI=
Date: Mon, 19 Feb 2024 16:08:46 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-implement-psi-metric-damos-quota-goal.patch added to mm-unstable branch
Message-Id: <20240220000846.A70AFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: implement PSI metric DAMOS quota goal
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-implement-psi-metric-damos-quota-goal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-implement-psi-metric-damos-quota-goal.patch

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
Subject: mm/damon/core: implement PSI metric DAMOS quota goal
Date: Mon, 19 Feb 2024 11:44:24 -0800

Extend DAMOS quota goal metric with system wide memory pressure stall
time.  Specifically, the system level 'some' PSI for memory is used.  The
target value can be set in microseconds.  DAMOS measures the increased
amount of the PSI metric in last quota_reset_interval and use the ratio of
it versus the user-specified target PSI value as the score for the
auto-tuning feedback loop.

Link: https://lkml.kernel.org/r/20240219194431.159606-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    7 +++++++
 mm/damon/core.c       |   25 +++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-implement-psi-metric-damos-quota-goal
+++ a/include/linux/damon.h
@@ -130,12 +130,14 @@ enum damos_action {
  * enum damos_quota_goal_metric - Represents the metric to be used as the goal
  *
  * @DAMOS_QUOTA_USER_INPUT:	User-input value.
+ * @DAMOS_QUOTA_SOME_MEM_PSI_US:	System level some memory PSI in us.
  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
  *
  * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
  */
 enum damos_quota_goal_metric {
 	DAMOS_QUOTA_USER_INPUT,
+	DAMOS_QUOTA_SOME_MEM_PSI_US,
 	NR_DAMOS_QUOTA_GOAL_METRICS,
 };
 
@@ -144,6 +146,7 @@ enum damos_quota_goal_metric {
  * @metric:		Metric to be used for representing the goal.
  * @target_value:	Target value of @metric to achieve with the tuning.
  * @current_value:	Current value of @metric.
+ * @last_psi_total:	Last measured total PSI
  * @list:		List head for siblings.
  *
  * Data structure for getting the current score of the quota tuning goal.  The
@@ -159,6 +162,10 @@ struct damos_quota_goal {
 	enum damos_quota_goal_metric metric;
 	unsigned long target_value;
 	unsigned long current_value;
+	/* metric-dependent fields */
+	union {
+		u64 last_psi_total;
+	};
 	struct list_head list;
 };
 
--- a/mm/damon/core.c~mm-damon-core-implement-psi-metric-damos-quota-goal
+++ a/mm/damon/core.c
@@ -11,6 +11,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/mm.h>
+#include <linux/psi.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 
@@ -1125,6 +1126,25 @@ static unsigned long damon_feed_loop_nex
 	return min_input;
 }
 
+#ifdef CONFIG_PSI
+
+static u64 damos_get_some_mem_psi_total(void)
+{
+	if (static_branch_likely(&psi_disabled))
+		return 0;
+	return div_u64(psi_system.total[PSI_AVGS][PSI_MEM * 2],
+			NSEC_PER_USEC);
+}
+
+#else	/* CONFIG_PSI */
+
+static inline u64 damos_get_some_mem_psi_total(void)
+{
+	return 0;
+};
+
+#endif	/* CONFIG_PSI */
+
 static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
 {
 	u64 now_psi_total;
@@ -1133,6 +1153,11 @@ static void damos_set_quota_goal_current
 	case DAMOS_QUOTA_USER_INPUT:
 		/* User should already set goal->current_value */
 		break;
+	case DAMOS_QUOTA_SOME_MEM_PSI_US:
+		now_psi_total = damos_get_some_mem_psi_total();
+		goal->current_value = now_psi_total - goal->last_psi_total;
+		goal->last_psi_total = now_psi_total;
+		break;
 	default:
 		break;
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

