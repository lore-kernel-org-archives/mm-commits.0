Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E714812
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387717; cv=none; b=Ieo3c1NmUeO6WsFbEJjrDMgWLv0QOm03sbKBU4O/SK4DQt6g5pGKIwfYOqhKjRiN8YCEmjzSbefUk+oWio2docqNd/P5iLDsLipWQboXUTSbRb1bnZKsnil8xTmpCbTvW2KE8qdhKsThVjJAqbgdeK6YcXYxdQiIhbrgCJKSyJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387717; c=relaxed/simple;
	bh=yhQhdImhzhev1mrNEdqFgi5kmr3lnGvsKDGjHhfXdss=;
	h=Date:To:From:Subject:Message-Id; b=kkKn16xpepwtxAIVkLK+4CroJi2p5EHl9CA2Wf/SIip7MNt7gqecFli8YQg0qU5nRAKvS3HuYdMpXlpMVeDFTKsCE6a8wK+Ifk8Uws8orzRphPgIuSYXT5/zr0X3f2FE6etELyrdgESm6Xs7wpWbgt633PcXiUAQpDMWyC90YzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MO0irQcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MO0irQcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB8EC433C7;
	Tue, 20 Feb 2024 00:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387717;
	bh=yhQhdImhzhev1mrNEdqFgi5kmr3lnGvsKDGjHhfXdss=;
	h=Date:To:From:Subject:From;
	b=MO0irQcfZXoIK67uFb06MBaW5P40hSSOUtLZW8de+kK0zcwQSz69GFzx2oTVH+Puv
	 NcnHxOPcc0TXrupO2o3zAAxY6w7zgzExB+CRFO5NYHq66utWxMpLf9KqZ0PZsW0rPd
	 brU/VDaSsxM8AgtKL29AiXEBk9J004hDX9GFG044=
Date: Mon, 19 Feb 2024 16:08:36 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-use-only-quota-goals.patch added to mm-unstable branch
Message-Id: <20240220000837.0AB8EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: use only quota->goals
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-use-only-quota-goals.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-use-only-quota-goals.patch

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
Subject: mm/damon/sysfs: use only quota->goals
Date: Mon, 19 Feb 2024 11:44:20 -0800

DAMON sysfs interface implements multiple quota auto-tuning goals on its
level since the DAMOS core logic was supporting only single goal.  Now the
core logic supports multiple goals on its level.  Update DAMON sysfs
interface to reuse the core logic and drop unnecessary duplicated multiple
goals implementation.

Link: https://lkml.kernel.org/r/20240219194431.159606-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-common.h  |    2 -
 mm/damon/sysfs-schemes.c |   49 ++++++++++++++++++++++++-------------
 mm/damon/sysfs.c         |    3 --
 3 files changed, 35 insertions(+), 19 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-use-only-quota-goals
+++ a/mm/damon/sysfs.c
@@ -1377,8 +1377,7 @@ static int damon_sysfs_commit_schemes_qu
 
 	ctx = sysfs_kdamond->damon_ctx;
 	sysfs_ctx = sysfs_kdamond->contexts->contexts_arr[0];
-	damos_sysfs_set_quota_scores(sysfs_ctx->schemes, ctx);
-	return 0;
+	return damos_sysfs_set_quota_scores(sysfs_ctx->schemes, ctx);
 }
 
 /*
--- a/mm/damon/sysfs-common.h~mm-damon-sysfs-use-only-quota-goals
+++ a/mm/damon/sysfs-common.h
@@ -59,7 +59,7 @@ int damon_sysfs_schemes_clear_regions(
 		struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
 
-void damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
+int damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx);
 
 void damos_sysfs_update_effective_quotas(
--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-use-only-quota-goals
+++ a/mm/damon/sysfs-schemes.c
@@ -1887,30 +1887,34 @@ static unsigned long damos_sysfs_get_quo
 	return (unsigned long)arg;
 }
 
-static void damos_sysfs_set_quota_score(
+static int damos_sysfs_set_quota_score(
 		struct damos_sysfs_quota_goals *sysfs_goals,
 		struct damos_quota *quota)
 {
-	struct damos_sysfs_quota_goal *sysfs_goal;
+	struct damos_quota_goal *goal, *next;
 	int i;
 
-	quota->goal.get_score = NULL;
-	quota->goal.get_score_arg = (void *)0;
+	damos_for_each_quota_goal_safe(goal, next, quota)
+		damos_destroy_quota_goal(goal);
+
 	for (i = 0; i < sysfs_goals->nr; i++) {
-		sysfs_goal = sysfs_goals->goals_arr[i];
+		struct damos_sysfs_quota_goal *sysfs_goal =
+			sysfs_goals->goals_arr[i];
+
 		if (!sysfs_goal->target_value)
 			continue;
 
-		/* Higher score makes scheme less aggressive */
-		quota->goal.get_score_arg = (void *)max(
-				(unsigned long)quota->goal.get_score_arg,
-				sysfs_goal->current_value * 10000 /
-				sysfs_goal->target_value);
-		quota->goal.get_score = damos_sysfs_get_quota_score;
+		goal = damos_new_quota_goal(damos_sysfs_get_quota_score,
+				(void *)(sysfs_goal->current_value * 10000 /
+				sysfs_goal->target_value));
+		if (!goal)
+			return -ENOMEM;
+		damos_add_quota_goal(quota, goal);
 	}
+	return 0;
 }
 
-void damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
+int damos_sysfs_set_quota_scores(struct damon_sysfs_schemes *sysfs_schemes,
 		struct damon_ctx *ctx)
 {
 	struct damos *scheme;
@@ -1918,16 +1922,21 @@ void damos_sysfs_set_quota_scores(struct
 
 	damon_for_each_scheme(scheme, ctx) {
 		struct damon_sysfs_scheme *sysfs_scheme;
+		int err;
 
 		/* user could have removed the scheme sysfs dir */
 		if (i >= sysfs_schemes->nr)
 			break;
 
 		sysfs_scheme = sysfs_schemes->schemes_arr[i];
-		damos_sysfs_set_quota_score(sysfs_scheme->quotas->goals,
+		err = damos_sysfs_set_quota_score(sysfs_scheme->quotas->goals,
 				&scheme->quota);
+		if (err)
+			/* kdamond will clean up schemes and terminated */
+			return err;
 		i++;
 	}
+	return 0;
 }
 
 void damos_sysfs_update_effective_quotas(
@@ -1987,13 +1996,17 @@ static struct damos *damon_sysfs_mk_sche
 		.low = sysfs_wmarks->low,
 	};
 
-	damos_sysfs_set_quota_score(sysfs_quotas->goals, &quota);
-
 	scheme = damon_new_scheme(&pattern, sysfs_scheme->action,
 			sysfs_scheme->apply_interval_us, &quota, &wmarks);
 	if (!scheme)
 		return NULL;
 
+	err = damos_sysfs_set_quota_score(sysfs_quotas->goals, &scheme->quota);
+	if (err) {
+		damon_destroy_scheme(scheme);
+		return NULL;
+	}
+
 	err = damon_sysfs_set_scheme_filters(scheme, sysfs_filters);
 	if (err) {
 		damon_destroy_scheme(scheme);
@@ -2029,7 +2042,11 @@ static void damon_sysfs_update_scheme(st
 	scheme->quota.weight_nr_accesses = sysfs_weights->nr_accesses;
 	scheme->quota.weight_age = sysfs_weights->age;
 
-	damos_sysfs_set_quota_score(sysfs_quotas->goals, &scheme->quota);
+	err = damos_sysfs_set_quota_score(sysfs_quotas->goals, &scheme->quota);
+	if (err) {
+		damon_destroy_scheme(scheme);
+		return;
+	}
 
 	scheme->wmarks.metric = sysfs_wmarks->metric;
 	scheme->wmarks.interval = sysfs_wmarks->interval_us;
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

