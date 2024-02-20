Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F317FE
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387737; cv=none; b=MezPnipXs76pwCMrMD7HDaN4VOnfWeBvUShWbuts6ag4rP6x/3i1cSu15/cUslE0U7ctE0w73uVYFDl4egh205SG1kbavvpQ9CcfKb0upmuz7w6tuHgOZ8JK2CMLMeVc2nD7YBTtUPipThUP40PKSaNNTfbU2eBJX21WACRlehQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387737; c=relaxed/simple;
	bh=Iv3SmJURW4uO5YpmU+3Qf31uYYUt5mi/H9KB5YUUtI8=;
	h=Date:To:From:Subject:Message-Id; b=j8di7krNggtCRtywC+q+9/iT0A4aeBu75grHOFO9vatNHPRWAj6gmpF/x6PiwdGfbHqARHp6D8KTrl0YSqXIzCqco32M7OlgpnGWzRmqhS4fqYtCkg0BYpWAYbKiAU8HEtHaiVH2qnIBW9vDNXJC08UDaX93Qpr/cZkBDVN/DbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SMwmRbGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SMwmRbGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266ACC433C7;
	Tue, 20 Feb 2024 00:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387737;
	bh=Iv3SmJURW4uO5YpmU+3Qf31uYYUt5mi/H9KB5YUUtI8=;
	h=Date:To:From:Subject:From;
	b=SMwmRbGYwcAlI8hhBhJtyNCXguvaRoCJRtJPdD/YI8ET13IqNf7D/wTSVUCR4qgQ2
	 PxaamWAAWVlo9N3ieM/1fRcAcy1FQfwUoBtCaiwVkGOhm6Zyor7QxND25cm/8A2vBm
	 niN2uEbRNOJwbpdsNu7IaKoMqY83i095li8qwrzY=
Date: Mon, 19 Feb 2024 16:08:56 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch added to mm-unstable branch
Message-Id: <20240220000857.266ACC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: implement memory PSI-driven quota self-tuning
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch

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
Subject: mm/damon/reclaim: implement memory PSI-driven quota self-tuning
Date: Mon, 19 Feb 2024 11:44:30 -0800

Support the PSI-driven quota self-tuning from DAMON_RECLAIM by introducing
yet another parameter, 'quota_mem_pressure_us'.  Users can set the desired
amount of memory pressure stall time per each quota reset interval using
the parameter.  Then DAMON_RECLAIM monitor the memory pressure stall time,
specifically system-wide memory 'some' PSI value that increased during the
given time interval, and self-tune the quota using the DAMOS core logic.

Link: https://lkml.kernel.org/r/20240219194431.159606-20-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning
+++ a/mm/damon/reclaim.c
@@ -63,6 +63,21 @@ static struct damos_quota damon_reclaim_
 DEFINE_DAMON_MODULES_DAMOS_QUOTAS(damon_reclaim_quota);
 
 /*
+ * Desired level of memory pressure-stall time in microseconds.
+ *
+ * While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
+ * increases and decreases the effective level of the quota aiming this level of
+ * memory pressure is incurred.  System-wide ``some`` memory PSI in microseconds
+ * per quota reset interval (``quota_reset_interval_ms``) is collected and
+ * compared to this value to see if the aim is satisfied.  Value zero means
+ * disabling this auto-tuning feature.
+ *
+ * Disabled by default.
+ */
+static unsigned long quota_mem_pressure_us __read_mostly;
+module_param(quota_mem_pressure_us, ulong, 0600);
+
+/*
  * User-specifiable feedback for auto-tuning of the effective quota.
  *
  * While keeping the caps that set by other quotas, DAMON_RECLAIM automatically
@@ -198,6 +213,16 @@ static int damon_reclaim_apply_parameter
 					&old_scheme->quota);
 	}
 
+	if (quota_mem_pressure_us) {
+		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,
+				quota_mem_pressure_us);
+		if (!goal) {
+			damon_destroy_scheme(scheme);
+			return -ENOMEM;
+		}
+		damos_add_quota_goal(&scheme->quota, goal);
+	}
+
 	if (quota_autotune_feedback) {
 		goal = damos_new_quota_goal(DAMOS_QUOTA_USER_INPUT, 10000);
 		if (!goal) {
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

