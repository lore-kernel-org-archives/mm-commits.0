Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCFF56B78;
	Mon, 19 Feb 2024 23:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387122; cv=none; b=mENajYcs9ua49v6PIc3vVJUCQM16Dy8oBLruZsAucYJmG0wGm63qpMyMO+o/L5HbSi3AgtuQRx7PJLw8HCxTVk2MFwYSGHjYwjSfS4EXjv/41hstHHjqzhXOi+VsECN5JWdwNrHPuuCpucK+yMtAvr4Upk32JU1hFCtSiQawkA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387122; c=relaxed/simple;
	bh=pcnn6Ai8zD3F4L6k3eEsYZcHoyL58N5lEFnQpFiwYQ8=;
	h=Date:To:From:Subject:Message-Id; b=B6hhyp56slkUXEjQrqBAUAsyGmEH0g5MR3342xzTaf/5KVkvbCIjVike2cPd7cLPS0J+jmI2Elmw6B855HKCerhJFeyescz2ZR14lqicEuiGnITPLUuwE7qy5JCM5EGmBvNW8DIP/TSJG01W+mqZOQVfX1pTJlqqowBzXCiluVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2QGZq/V0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2QGZq/V0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F78C433F1;
	Mon, 19 Feb 2024 23:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387121;
	bh=pcnn6Ai8zD3F4L6k3eEsYZcHoyL58N5lEFnQpFiwYQ8=;
	h=Date:To:From:Subject:From;
	b=2QGZq/V06i7TjT6bujbR8mgZhUHsgyOQ3viWWx1NjZcfbRLXkPFQbWpsm8RHUaY7c
	 MmUhaD5JRb3CTJWGMxSGWaZD/f3D7i0Iqd5SYgon+yJQ4ZvvQAMctQhOVeET+sLiOY
	 20ZhJV52pMfczI8nOW3fFhCqrdX+M1B25tT+60Ew=
Date: Mon, 19 Feb 2024 15:58:41 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-fix-quota-status-loss-due-to-online-tunings.patch added to mm-hotfixes-unstable branch
Message-Id: <20240219235841.C3F78C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: fix quota status loss due to online tunings
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-lru_sort-fix-quota-status-loss-due-to-online-tunings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-fix-quota-status-loss-due-to-online-tunings.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm/damon/lru_sort: fix quota status loss due to online tunings
Date: Fri, 16 Feb 2024 11:40:25 -0800

For online parameters change, DAMON_LRU_SORT creates new schemes based on
latest values of the parameters and replaces the old schemes with the new
one.  When creating it, the internal status of the quotas of the old
schemes is not preserved.  As a result, charging of the quota starts from
zero after the online tuning.  The data that collected to estimate the
throughput of the scheme's action is also reset, and therefore the
estimation should start from the scratch again.  Because the throughput
estimation is being used to convert the time quota to the effective size
quota, this could result in temporal time quota inaccuracy.  It would be
recovered over time, though.  In short, the quota accuracy could be
temporarily degraded after online parameters update.

Fix the problem by checking the case and copying the internal fields for
the status.

Link: https://lkml.kernel.org/r/20240216194025.9207-3-sj@kernel.org
Fixes: 40e983cca927 ("mm/damon: introduce DAMON-based LRU-lists Sorting")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   43 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-fix-quota-status-loss-due-to-online-tunings
+++ a/mm/damon/lru_sort.c
@@ -185,9 +185,21 @@ static struct damos *damon_lru_sort_new_
 	return damon_lru_sort_new_scheme(&pattern, DAMOS_LRU_DEPRIO);
 }
 
+static void damon_lru_sort_copy_quota_status(struct damos_quota *dst,
+		struct damos_quota *src)
+{
+	dst->total_charged_sz = src->total_charged_sz;
+	dst->total_charged_ns = src->total_charged_ns;
+	dst->charged_sz = src->charged_sz;
+	dst->charged_from = src->charged_from;
+	dst->charge_target_from = src->charge_target_from;
+	dst->charge_addr_from = src->charge_addr_from;
+}
+
 static int damon_lru_sort_apply_parameters(void)
 {
-	struct damos *scheme;
+	struct damos *scheme, *hot_scheme, *cold_scheme;
+	struct damos *old_hot_scheme = NULL, *old_cold_scheme = NULL;
 	unsigned int hot_thres, cold_thres;
 	int err = 0;
 
@@ -195,18 +207,35 @@ static int damon_lru_sort_apply_paramete
 	if (err)
 		return err;
 
+	damon_for_each_scheme(scheme, ctx) {
+		if (!old_hot_scheme) {
+			old_hot_scheme = scheme;
+			continue;
+		}
+		old_cold_scheme = scheme;
+	}
+
 	hot_thres = damon_max_nr_accesses(&damon_lru_sort_mon_attrs) *
 		hot_thres_access_freq / 1000;
-	scheme = damon_lru_sort_new_hot_scheme(hot_thres);
-	if (!scheme)
+	hot_scheme = damon_lru_sort_new_hot_scheme(hot_thres);
+	if (!hot_scheme)
 		return -ENOMEM;
-	damon_set_schemes(ctx, &scheme, 1);
+	if (old_hot_scheme)
+		damon_lru_sort_copy_quota_status(&hot_scheme->quota,
+				&old_hot_scheme->quota);
 
 	cold_thres = cold_min_age / damon_lru_sort_mon_attrs.aggr_interval;
-	scheme = damon_lru_sort_new_cold_scheme(cold_thres);
-	if (!scheme)
+	cold_scheme = damon_lru_sort_new_cold_scheme(cold_thres);
+	if (!cold_scheme) {
+		damon_destroy_scheme(hot_scheme);
 		return -ENOMEM;
-	damon_add_scheme(ctx, scheme);
+	}
+	if (old_cold_scheme)
+		damon_lru_sort_copy_quota_status(&cold_scheme->quota,
+				&old_cold_scheme->quota);
+
+	damon_set_schemes(ctx, &hot_scheme, 1);
+	damon_add_scheme(ctx, cold_scheme);
 
 	return damon_set_region_biggest_system_ram_default(target,
 					&monitor_region_start,
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

