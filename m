Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB81EED0
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387731; cv=none; b=iqVJfN3ttUyGdG297/fHW9jX52eZJPA3pflKqprX5S3lnmeNpL0xs7EYl9V4njXZ5MUmT9tis19/cUxJODY9TsUTsZTW1esNd/I9BMCveeRuWO8IGN//ZjDr9BZTzPv8z7Ir+LX9izappIOgawtm+KoC8X8yiOUiNwsSPaT5j7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387731; c=relaxed/simple;
	bh=oFjgNCWUAdiQpSV7tTH1cc0+KERU6KPluzY5hB9HZD8=;
	h=Date:To:From:Subject:Message-Id; b=gpCaIRKPfY2CQv/j5XViTvzmKouD9bzYntC2U6y7zwYvvVQNcqTEc/bqyXcO0D6ZDqlBxGkNZ6wzztPoAsmn0cToy/qngN4LoEs8//5SKzf0vLBz6Kw6R1z+eenzjBGTbhycpt3zuVeMdF3KyOelSPrc//jQIF/O/tyhoZT8ab8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=saTuhABr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="saTuhABr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D093C433C7;
	Tue, 20 Feb 2024 00:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387730;
	bh=oFjgNCWUAdiQpSV7tTH1cc0+KERU6KPluzY5hB9HZD8=;
	h=Date:To:From:Subject:From;
	b=saTuhABrV8dFPxN59DJuUkBQWxSt8nTINL97DTy0s5aUyRDK0rqgGXrnjPPaBjNSj
	 yu63qIQL0pdgq7RpvJcBgT4vysc8SPMCbJ1EYQbtMdKXM64tZ1hO1DKdz1z1hEthHw
	 6WPzCE/dg0g699N2OFokLNXuX8BkFL9JylKSQWZo=
Date: Mon, 19 Feb 2024 16:08:50 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-quota-goal-self-tuning.patch added to mm-unstable branch
Message-Id: <20240220000850.6D093C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document quota goal self-tuning
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-quota-goal-self-tuning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-quota-goal-self-tuning.patch

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
Subject: Docs/mm/damon/design: document quota goal self-tuning
Date: Mon, 19 Feb 2024 11:44:26 -0800

Update DAMON design doc to explain the quota goal self-tuning, which can
be used by setting the goal's metric to metrics that kernel can
self-retrieve.

Link: https://lkml.kernel.org/r/20240219194431.159606-16-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-quota-goal-self-tuning
+++ a/Documentation/mm/damon/design.rst
@@ -398,12 +398,28 @@ Aim-oriented Feedback-driven Auto-tuning
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 Automatic feedback-driven quota tuning.  Instead of setting the absolute quota
-value, users can repeatedly provide numbers representing how much of their goal
-for the scheme is achieved as feedback.  DAMOS then automatically tunes the
+value, users can specify the metric of their interest, and what target value
+they want the metric value to be.  DAMOS then automatically tunes the
 aggressiveness (the quota) of the corresponding scheme.  For example, if DAMOS
 is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
 is over achieving the goal, it decreases the quota.
 
+The goal can be specified with three parameters, namely ``target_metric``,
+``target_value``, and ``current_value``.  The auto-tuning mechanism tries to
+make ``current_value`` of ``target_metric`` be same to ``target_value``.
+Currently, two ``target_metric`` are provided.
+
+- ``user_input``: User-provided value.  Users could use any metric that they
+  has interest in for the value.  Use space main workload's latency or
+  throughput, system metrics like free memory ratio or memory pressure stall
+  time (PSI) could be examples.  Note that users should explicitly set
+  ``current_value`` on their own in this case.  In other words, users should
+  repeatedly provide the feedback.
+- ``some_mem_psi_us``: System-wide ``some`` memory pressure stall information
+  in microseconds that measured from last quota reset to next quota reset.
+  DAMOS does the measurement on its own, so only ``target_value`` need to be
+  set by users at the initial time.  In other words, DAMOS does self-feedback.
+
 
 .. _damon_design_damos_watermarks:
 
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

