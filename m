Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3F315B1
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387707; cv=none; b=hBkcADyqa6gzlmqgUYRJCY1D6ptGClDncOjkQJF0Iui17xBIgdSlSrVl302C2Oz1ibOK30cSn1yitWquipStTBu5kbIHtsOLTPPWudI26E/ljP7XRw1Vebi6r/IN3BIVyVjDMeIMUA+BqHP5M2SPmXqoedqqH6kn//HtChCPA88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387707; c=relaxed/simple;
	bh=ib/o/k1SqbfyrhTljlXUrSRMIchn43WXcwPwHitsYgc=;
	h=Date:To:From:Subject:Message-Id; b=qUBi2NnnbD+w/7YfNctUMvGyDbo3KNrfv57lR3jxhM1c6n++x62xZju2UfszEQYsCDoF9wu6cnOdLn9Wa8LIqgdjjjPdyInzvDj1Mi6y9lgXZicbt8JKgIMo7L0zb4kPiCiUOgdfBK7nJO0eysslhShSeALCu/eiFVxDaseOaPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tkzqX+OJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tkzqX+OJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AE2C433F1;
	Tue, 20 Feb 2024 00:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387707;
	bh=ib/o/k1SqbfyrhTljlXUrSRMIchn43WXcwPwHitsYgc=;
	h=Date:To:From:Subject:From;
	b=tkzqX+OJYX+J8WfXxutRsu5LcquGKCk/nsuzgp0tcy7IkNRZQ8eZ08VZQRJ/o1K2j
	 h9SOhcU2+Xf0rDZwhJWvARe6lDaIqUTfUWCby7V09AJzs+A7hYmGjTEXs92g5h5W2h
	 Yq0g/nMle16Y0niCvm0mT0B6whxKlyXE8GKBvfqw=
Date: Mon, 19 Feb 2024 16:08:26 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-damon-document-effective_bytes-sysfs-file.patch added to mm-unstable branch
Message-Id: <20240220000827.27AE2C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/ABI/damon: document effective_bytes sysfs file
has been added to the -mm mm-unstable branch.  Its filename is
     docs-abi-damon-document-effective_bytes-sysfs-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-damon-document-effective_bytes-sysfs-file.patch

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
Subject: Docs/ABI/damon: document effective_bytes sysfs file
Date: Mon, 19 Feb 2024 11:44:15 -0800

Update the DAMON ABI doc for the effective_bytes sysfs file and the
kdamond state file input command for updating the content of the file.

Link: https://lkml.kernel.org/r/20240219194431.159606-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~docs-abi-damon-document-effective_bytes-sysfs-file
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -34,7 +34,9 @@ Description:	Writing 'on' or 'off' to th
 		kdamond.  Writing 'update_schemes_tried_bytes' to the file
 		updates only '.../tried_regions/total_bytes' files of this
 		kdamond.  Writing 'clear_schemes_tried_regions' to the file
-		removes contents of the 'tried_regions' directory.
+		removes contents of the 'tried_regions' directory.  Writing
+		'update_schemes_effective_quotas' to the file updates
+		'.../quotas/effective_bytes' files of this kdamond.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
@@ -208,6 +210,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the size
 		quota of the scheme in bytes.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/effective_bytes
+Date:		Feb 2024
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Reading from this file gets the effective size quota of the
+		scheme in bytes, which adjusted for the time quota and goals.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/reset_interval_ms
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
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

