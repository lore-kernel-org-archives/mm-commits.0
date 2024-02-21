Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F7486632
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708546489; cv=none; b=pLnO6N26oSztyLpTJAH3XEhzRDcstNgSPd1Cz+vNHcCqSPnl+mqT22V9hF1w6qBA3F3oeBVZsLHfApDSfti9OHSVWm8nnFC4/kNtOxeIloQ8BbpgkpVGt1AxVlfehQxkOf+0//0VUIs7MjgVkvOwvGQ7TeemoBcMRC9/jJg0/6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708546489; c=relaxed/simple;
	bh=sLnf7yidkeL2zr2hxMYlXUgTkHWpAjQTzOJzdqjDzIY=;
	h=Date:To:From:Subject:Message-Id; b=JlnFHYtdiUBz3jvcre7Q1qVC1sY55TjVci+qP787CPFmcnPnONJGf4CReK6qay4x2sF9VXe0oQn+DI/DKR4T2+BCAhnUjS1Ky5AUZdQjdMvU9FMvOIe/C3D2K9tFF41qydExKSTVDpUGSk3sDmZSepFseE35t+tTorlgUck2ECQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cCeEBxi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cCeEBxi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30ACAC433C7;
	Wed, 21 Feb 2024 20:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708546489;
	bh=sLnf7yidkeL2zr2hxMYlXUgTkHWpAjQTzOJzdqjDzIY=;
	h=Date:To:From:Subject:From;
	b=cCeEBxi/cQTmekNhzQ4bWQY5DE4kNYL3rWynWV0VCFeS01VQlaKMw6khIMXJDCwIL
	 mleyKE1te4HlUme5m2I9/aum7fJM+i1xnz6rUJBRSYsDKVhiBE8Qy1gAP1v9BugR61
	 1l7eIbtOIrzotjMgkL+7hV6NTVROW69+ViB8/vRs=
Date: Wed, 21 Feb 2024 12:14:48 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch added to mm-unstable branch
Message-Id: <20240221201449.30ACAC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix a typo on the auto-tuning design reference link
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch

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
Subject: Docs/admin-guide/mm/damon/usage: fix a typo on the auto-tuning design reference link
Date: Wed, 21 Feb 2024 09:08:52 -0800

There was a typo on the quota auto-tuning design reference link that
caused below document build warning.  Fix it.

    WARNING: undefined label: 'damon_design_damos_quota_auto_tuning'

Link: https://lkml.kernel.org/r/20240221170852.55529-3-sj@kernel.org
Fixes: d50e871bd78b ("Docs/admin-guide/mm/damon/usage: document quota goal metric file")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lkml.kernel.org/r/20240221162745.4332955c@canb.auug.org.au
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -369,7 +369,7 @@ Among the multiple feedback, the best on
 Each goal directory contains three files, namely ``target_metric``,
 ``target_value`` and ``current_value``.  Users can set and get the three
 parameters for the quota auto-tuning goals that specified on the :ref:`design
-doc <damon_design_damos_quota_auto_tuning>` by writing to and reading from each
+doc <damon_design_damos_quotas_auto_tuning>` by writing to and reading from each
 of the files.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
 directory <sysfs_kdamond>` to pass the feedback to DAMON.
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
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix.patch
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
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch

