Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35E583CB2
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 20:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708546441; cv=none; b=LU4qkhACkSLRzpThhsZqXxT9eBNMmLPbrQWiiFDLBnkbVl3aF+1ZmzBYXUhUdSlNdUiSoBaPkFlJC8+zEFgD6Slmeb8SjdUNP1EJNCvVrZmlKqRqFPyxPnjbhR9e66A5DZdA/gghWgce+Eqxu0J5OYM7r9dz/Z/NWU5+vCFSBs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708546441; c=relaxed/simple;
	bh=Gpcgl+Z+ij15RghRZnVV0xJ6P+fxnwdzbj2EXsh1boM=;
	h=Date:To:From:Subject:Message-Id; b=Vvkteo0X+suBxAB2L5eqRrofUEFEdBBAm5uK55CHE4WXeBL4HHf3bMEpMr1qsmt8ui221lywTfvMzPr6WgMEroQTK/jJfCo7deH+I0LZ5vYEsFxXJ1F5jqSJJLqG+QEVY6FfIuXFsUgxGjcPvyZ/JLMqRA+XzlFN3km2aJCTf+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b2Tm6UGa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b2Tm6UGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6320BC433F1;
	Wed, 21 Feb 2024 20:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708546440;
	bh=Gpcgl+Z+ij15RghRZnVV0xJ6P+fxnwdzbj2EXsh1boM=;
	h=Date:To:From:Subject:From;
	b=b2Tm6UGa5zY9b2DWwK5WuYxlmDEdLnwr3PKClXoe/WL+IdxdVrJEVVAaIIdiFu2tW
	 CCwfnjxVAaJWSUf6LlhjK9uALunHOGJYuSJP69j1erYVenIHEtGdBTYA+rbKcqDaju
	 pD7xdmhDCFpgj6juPbBw/aFZqOzQaCeVPch1qnCc=
Date: Wed, 21 Feb 2024 12:13:59 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix.patch added to mm-unstable branch
Message-Id: <20240221201400.6320BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix a typo on a reference link
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix.patch

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
Subject: Docs/admin-guide/mm/damon/usage: fix a typo on a reference link
Date: Wed, 21 Feb 2024 09:08:51 -0800

There was a typo cuasing a document build warning below.  Fix it.

    WARNING: undefined label: 'damon_design_confiurable_operations_set'

Link: https://lkml.kernel.org/r/20240221170852.55529-2-sj@kernel.org
Fixes: afc858f0e6db ("Docs/mm/damon: move DAMON operation sets list from the usage to the design document")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -181,7 +181,7 @@ and three directories (``monitoring_attr
 exist.
 
 DAMON supports multiple types of :ref:`monitoring operations
-<damon_design_confiurable_operations_set>`, including those for virtual address
+<damon_design_configurable_operations_set>`, including those for virtual address
 space and the physical address space.  You can get the list of available
 monitoring operations set on the currently running kernel by reading
 ``avail_operations`` file.  Based on the kernel configuration, the file will
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
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch

