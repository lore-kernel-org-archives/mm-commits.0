Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B8C1D689
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 21:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708290786; cv=none; b=pnYp/eYymCDBMBTRPq+2qUs+/pGDBmKySzsQ66/UIwwHip9gS8j4TswLYdWHA5NGHsIgOeDK6rhhBJYtvREkbWx6zXcO/tN4/6aQV/MIt2IFSZjZ7JPVhj0OJPmtRQX1S+AGUupENs8JXPjuBaR2oWDoo704lLve7Ob6hF8ba/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708290786; c=relaxed/simple;
	bh=5ERT/SfxB0Zzpe8jEYs2tyy7su+S4dRK04q8vidm1xk=;
	h=Date:To:From:Subject:Message-Id; b=DZ9SCnF+qTrtkO0LDzkJGakFiP7VD1vH6Oi9sI9Cvcwaj+MlL7dWSbvrmw9pdR2UYZVpZOIlJrG2KranG1ugX14Or7xymv20SxseOkXDwOV683uAayVqAy2MblpPFIN6uDV6O1nL0SyVRQOSNeWtqwX8OZ4PiJBFWHu7BiEscek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0DtGimqI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0DtGimqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F315C433F1;
	Sun, 18 Feb 2024 21:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708290786;
	bh=5ERT/SfxB0Zzpe8jEYs2tyy7su+S4dRK04q8vidm1xk=;
	h=Date:To:From:Subject:From;
	b=0DtGimqIxZPJDXrSkOnMaJaZrdA7dgqG8CH8mvS7GWI1uYhqTpk0ld3neNPLfk2tQ
	 uA0i3qeVGmTkrp8sStfRViGDxEFqGMNrTybCoR0ZoxcinFSWIL8Rlr+2J9npdtXEi/
	 Kn3R3mX/zJLoxUZzYGrKPofcGhH8KxfPzb+yyZ8U=
Date: Sun, 18 Feb 2024 13:13:05 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch added to mm-unstable branch
Message-Id: <20240218211306.0F315C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix wrong quotas diabling condition
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch

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
Subject: Docs/admin-guide/mm/damon/usage: fix wrong quotas diabling condition
Date: Fri, 16 Feb 2024 16:58:42 -0800

After the introduction of DAMOS quotas, DAMOS quotas is not disabled if
both size and time quotas are zero but the quota goal is set.  The new
rule is also applied to DAMON sysfs interface, but the usage doc is not
updated.  Update it.

Link: https://lkml.kernel.org/r/20240217005842.87348-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -329,7 +329,8 @@ respectively.  Then, DAMON tries to use
 for applying the ``action`` to memory regions of the ``access_pattern``, and to
 apply the action to only up to ``bytes`` bytes of memory regions within the
 ``reset_interval_ms``.  Setting both ``ms`` and ``bytes`` zero disables the
-quota limits.
+quota limits unless at least one :ref:`goal <sysfs_schemes_quota_goals>` is
+set.
 
 Under ``weights`` directory, three files (``sz_permil``,
 ``nr_accesses_permil``, and ``age_permil``) exist.
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-check-apply-interval-in-damon_do_apply_schemes.patch
mm-damon-sysfs-schemes-handle-schemes-sysfs-dir-removal-before-commit_schemes_quota_goals.patch
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

