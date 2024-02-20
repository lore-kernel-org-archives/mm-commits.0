Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DF7A28
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 00:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708387709; cv=none; b=Hzfmm6l1cF2G47swAK5z3pNRCcsTUFkWusiGsAqxXD4AaFuwstREfMXsmwSNlLTgyTJvkdGXCOOe9eLTIAf+SVrL4CAhNPqYqoOqHf4D+SGsNvm4Upfm+Uxv6xAp6jRF5+Vz1qR3BM/XXPi3in1jXvkZFHYGLLqNCtSb0xQ09V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708387709; c=relaxed/simple;
	bh=AKadJ8uly8Zg5mP5N7VAKU/TD2TPjLILRojRupBABbw=;
	h=Date:To:From:Subject:Message-Id; b=JtI9LFVKvvnchnhNISs/lWtQ5TaaSOgyWnyNvX62wTH2vWukKl8/UhNhPtPjaOZlWVAASrU+x17Knen/AOG/3DQzAWcZQl7MgW1eL8V4f8LnA07DeQqVsRwLaOCt7NWLlWweLziWjzamnWsTqmU1GYGDfENRrCBKWdbHWdadQwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u8jhglLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u8jhglLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DE3C433F1;
	Tue, 20 Feb 2024 00:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708387708;
	bh=AKadJ8uly8Zg5mP5N7VAKU/TD2TPjLILRojRupBABbw=;
	h=Date:To:From:Subject:From;
	b=u8jhglLiSqz1cJ1RAAP7k0JKLbBhqGO+Ru3/E41GqwOo5Wk5g9RSWp5ja5W0nFYV+
	 4lv+2+sAClUyxw0nLxAMcJu1lmXpIlCCEKnapnYBKJeRU7A2vFdIUFpUF7TSqJ9Bns
	 08MjSFe5Mnb3PSUlaGuKC/gawFhb0puKR3jOEuMg=
Date: Mon, 19 Feb 2024 16:08:28 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch added to mm-unstable branch
Message-Id: <20240220000828.C8DE3C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document effective_bytes file
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch

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
Subject: Docs/admin-guide/mm/damon/usage: document effective_bytes file
Date: Mon, 19 Feb 2024 11:44:16 -0800

Update DAMON usage document for the effective quota file of the DAMON
sysfs interface.

Link: https://lkml.kernel.org/r/20240219194431.159606-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   19 ++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-effective_bytes-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,7 @@ comma (",").
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
     │ │ │ │ │ │ │ │ age/min,max
-    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms
+    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_value,current_value
@@ -153,6 +153,9 @@ Users can write below commands for the k
 - ``clear_schemes_tried_regions``: Clear the DAMON-based operating scheme
   action tried regions directory for each DAMON-based operation scheme of the
   kdamond.
+- ``update_schemes_effective_bytes``: Update the contents of
+  ``effective_bytes`` files for each DAMON-based operation scheme of the
+  kdamond.  For more details, refer to :ref:`quotas directory <sysfs_quotas>`.
 
 If the state is ``on``, reading ``pid`` shows the pid of the kdamond thread.
 
@@ -320,8 +323,9 @@ schemes/<N>/quotas/
 The directory for the :ref:`quotas <damon_design_damos_quotas>` of the given
 DAMON-based operation scheme.
 
-Under ``quotas`` directory, three files (``ms``, ``bytes``,
-``reset_interval_ms``) and two directores (``weights`` and ``goals``) exist.
+Under ``quotas`` directory, four files (``ms``, ``bytes``,
+``reset_interval_ms``, ``effective_bytes``) and two directores (``weights`` and
+``goals``) exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
@@ -332,6 +336,15 @@ apply the action to only up to ``bytes``
 quota limits unless at least one :ref:`goal <sysfs_schemes_quota_goals>` is
 set.
 
+The time quota is internally transformed to a size quota.  Between the
+transformed size quota and user-specified size quota, smaller one is applied.
+Based on the user-specified :ref:`goal <sysfs_schemes_quota_goals>`, the
+effective size quota is further adjusted.  Reading ``effective_bytes`` returns
+the current effective size quota.  The file is not updated in real time, so
+users should ask DAMON sysfs interface to update the content of the file for
+the stats by writing a special keyword, ``update_schemes_effective_bytes`` to
+the relevant ``kdamonds/<N>/state`` file.
+
 Under ``weights`` directory, three files (``sz_permil``,
 ``nr_accesses_permil``, and ``age_permil``) exist.
 You can set the :ref:`prioritization weights
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

