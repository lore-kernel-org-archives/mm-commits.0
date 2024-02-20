Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 243561534E5
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 22:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467754; cv=none; b=GWM2Z9uPk/fIRQl+KwCBVqdLe0FoqjoUespAx2rxd+wYWfRiZ5F9WFsGEm4qN1qhD/IYwD/kTvjZ4tK0yYiVvE2blDZu0a+CuRL1okmUTPQSX6wtKzqLAJLb67EVPNEdBMWcLyqAnuSkV2MSXhMObtE3k4TrZL7AtjJEE2DrktI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467754; c=relaxed/simple;
	bh=sBuwsGJPdAKBLqCJt91JjGp25TkGSIH/3/SFok5loC0=;
	h=Date:To:From:Subject:Message-Id; b=K4jB686d8KL67vv4S7dXfWAppyZCKz43eCchqsynScQ72QENpA8+Eg+JYXPjIjrEu5Vpm6Ro9a15cn+R0Zt69CsshZ0b8n+fMyFI2MC1GEynWLy4QaA7rB1MfxWWR9tCbw/Kp1VITDXqjV+8hkHp60L4Pfz1sMihO6DX8H0XxC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VIABCBjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VIABCBjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64DEC43390;
	Tue, 20 Feb 2024 22:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467753;
	bh=sBuwsGJPdAKBLqCJt91JjGp25TkGSIH/3/SFok5loC0=;
	h=Date:To:From:Subject:From;
	b=VIABCBjkeoHwgzzhitvJezhrrjo1rycjrkzBDsOwsgAm/WpjM/PvHB1XqCnOnZhss
	 jCrpuamc1xUne4V7vVKB3bzMzkCrV6sfGi/5aCc/i8IMNIj6+V/54OnREnEad0XKXW
	 W0LCWhDx+vsNp6gWohIxZU5Q4N1iFkfkoLRvhqlI=
Date: Tue, 20 Feb 2024 14:22:33 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals.patch removed from -mm tree
Message-Id: <20240220222233.A64DEC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: handle schemes sysfs dir removal before commit_schemes_quota_goals
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: handle schemes sysfs dir removal before commit_schemes_quota_goals
Date: Mon, 12 Feb 2024 18:36:32 -0800

'commit_schemes_quota_goals' command handler,
damos_sysfs_set_quota_scores() assumes the number of schemes sysfs
directory will be same to the number of schemes of the DAMON context.  The
assumption is wrong since users can remove schemes sysfs directories while
DAMON is running.  In the case, illegal memory accesses can happen.  Fix
it by checking the case.

Link: https://lkml.kernel.org/r/20240213023633.124928-1-sj@kernel.org
Fixes: d91beaa505a0 ("mm/damon/sysfs-schemes: implement a command for scheme quota goals only commit")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals
+++ a/mm/damon/sysfs-schemes.c
@@ -1905,6 +1905,10 @@ void damos_sysfs_set_quota_scores(struct
 	damon_for_each_scheme(scheme, ctx) {
 		struct damon_sysfs_scheme *sysfs_scheme;
 
+		/* user could have removed the scheme sysfs dir */
+		if (i >= sysfs_schemes->nr)
+			break;
+
 		sysfs_scheme = sysfs_schemes->schemes_arr[i];
 		damos_sysfs_set_quota_score(sysfs_scheme->quotas->goals,
 				&scheme->quota);
_

Patches currently in -mm which might be from sj@kernel.org are

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

