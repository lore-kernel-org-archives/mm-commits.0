Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE4A15B1
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387735; cv=none; b=kBYPaY3MhvoDqaNppENTNaRuhfdGj5f8FUedEY7u0+WXDLt6KlqCIfQUYGwZX3/fWdehS5eZyf0qToNgiPcGgoV6DCZw5pFTaL1M9KBl5gaX0BR8Uv6eBQDnicP56SqJFRPVqO1/lUFdiF819A/Fo+duO724wuconrSZ8R3D+JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387735; c=relaxed/simple;
	bh=owfQed3Fl83mrGe8Gx2bKnr0dMzD3pphpjUZmbfCgcE=;
	h=Date:To:From:Subject:Message-Id; b=g7KAg6xO828dYvTyCyXTz1DwJz7siqUMjJ2h2fjkRbJ//ZVc4h4DZKuiRRFYJbczr6jITE11QJ5MbknTed7Ebkrn6S5cTTDNuW5u0mP+Vsp3nmofpq+PRGGfck94sTCLrKEKZ3x19IDnCVLE/Mz1PVsnWJdCELeMqIKWRHNoa2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GhSiVtY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GhSiVtY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9F2C433F1;
	Tue, 20 Feb 2024 00:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387735;
	bh=owfQed3Fl83mrGe8Gx2bKnr0dMzD3pphpjUZmbfCgcE=;
	h=Date:To:From:Subject:From;
	b=GhSiVtY5xp1FQDB6bMj0yEODh5LDrwd8cqQCI0xF5k8/Irw8QbiMLAOQQix8d4i+f
	 f5O+mmd0UePrWMvj6hYGRGMKgZnKgg8oaXK57b7biJgI7HXM2VpKuyX7Yhr2F2T5Vb
	 WSMuCsKFFXizGJ+mKfapmW3UHzGsJoc7L0Nyv+sE=
Date: Mon, 19 Feb 2024 16:08:54 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch added to mm-unstable branch
Message-Id: <20240220000855.4E9F2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: implement user-feedback driven quota auto-tuning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch

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
Subject: mm/damon/reclaim: implement user-feedback driven quota auto-tuning
Date: Mon, 19 Feb 2024 11:44:29 -0800

DAMOS supports user-feedback driven quota auto-tuning, but only DAMON
sysfs interface is using it.  Add support of the feature on DAMON_RECLAIM
by adding one more input parameter, namely 'quota_autotune_feedback', for
providing the user feedback to DAMON_RECLAIM.  It assumes the target value
of the feedback is 10,000.

Link: https://lkml.kernel.org/r/20240219194431.159606-19-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning
+++ a/mm/damon/reclaim.c
@@ -62,6 +62,21 @@ static struct damos_quota damon_reclaim_
 };
 DEFINE_DAMON_MODULES_DAMOS_QUOTAS(damon_reclaim_quota);
 
+/*
+ * User-specifiable feedback for auto-tuning of the effective quota.
+ *
+ * While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
+ * increases and decreases the effective level of the quota aiming receiving this
+ * feedback of value ``10,000`` from the user.  DAMON_RECLAIM assumes the feedback
+ * value and the quota are positively proportional.  Value zero means disabling
+ * this auto-tuning feature.
+ *
+ * Disabled by default.
+ *
+ */
+static unsigned long quota_autotune_feedback __read_mostly;
+module_param(quota_autotune_feedback, ulong, 0600);
+
 static struct damos_watermarks damon_reclaim_wmarks = {
 	.metric = DAMOS_WMARK_FREE_MEM_RATE,
 	.interval = 5000000,	/* 5 seconds */
@@ -159,11 +174,13 @@ static void damon_reclaim_copy_quota_sta
 	dst->charged_from = src->charged_from;
 	dst->charge_target_from = src->charge_target_from;
 	dst->charge_addr_from = src->charge_addr_from;
+	dst->esz_bp = src->esz_bp;
 }
 
 static int damon_reclaim_apply_parameters(void)
 {
 	struct damos *scheme, *old_scheme;
+	struct damos_quota_goal *goal;
 	struct damos_filter *filter;
 	int err = 0;
 
@@ -180,6 +197,17 @@ static int damon_reclaim_apply_parameter
 			damon_reclaim_copy_quota_status(&scheme->quota,
 					&old_scheme->quota);
 	}
+
+	if (quota_autotune_feedback) {
+		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
+		if (!goal) {
+			damon_destroy_scheme(scheme);
+			return -ENOMEM;
+		}
+		goal->current_value = quota_autotune_feedback;
+		damos_add_quota_goal(&scheme->quota, goal);
+	}
+
 	if (skip_anon) {
 		filter = damos_new_filter(DAMOS_FILTER_TYPE_ANON, true);
 		if (!filter) {
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

