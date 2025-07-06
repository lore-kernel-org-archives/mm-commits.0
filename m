Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26DC846F
	for <mm-commits@vger.kernel.org>; Sun,  6 Jul 2025 21:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751838599; cv=none; b=huKpcXa5mAUvnkDZRx6L+GUb+FCmeHsvgfnJtjXJojJdL9/c2yVx3i3XSR/+VZIPHuIu7N+qKPbGxGJ1stgN/3bHR6/D7UkyJwbhylFT4S4wtbmZ1HaQvumTN5h/dhOSiIZH93sGxHU0hfNhDHO7j7tf5yPBaKSiSw3VdIN/XiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751838599; c=relaxed/simple;
	bh=XEAF9d3FV4QXLSB+Z08j9VuvA9VEUh0UI4OIFLSJOIo=;
	h=Date:To:From:Subject:Message-Id; b=Nmqf4SE0QICvy4ghptvA5lQoiLYfl8Ibim0n1zsHfKcZBQfxn4iq8T3XQPwIQdCYNPVndWjnQQlg2uAFP8AGABFR+smGqUlDbY0gbwx5qQD589JkHMr6fWL2HdgSGaOwLxBd8UvB3pJbIu9LHosvAUxzGsFV04nxvIcBEas0HuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=le4AGV2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="le4AGV2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC3EC4CEED;
	Sun,  6 Jul 2025 21:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751838599;
	bh=XEAF9d3FV4QXLSB+Z08j9VuvA9VEUh0UI4OIFLSJOIo=;
	h=Date:To:From:Subject:From;
	b=le4AGV2FHLerYa8ilQMudOvUoLFhUsWPlpSmk2dFG+GfYTUeAjmAJgG8vvSAc7wMJ
	 tIUhjwAF1puTtah+uNJeAB0Cse8Xn7x9zEf9/FIODvbAR2xs850LmDYv49xw00AC6z
	 zxIWQvhyXqJKgwjSHj7agqZPrs5EHhlGhMfZvWOo=
Date: Sun, 06 Jul 2025 14:49:59 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch added to mm-new branch
Message-Id: <20250706214959.8BC3EC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: update for mm-new tree
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: Docs/mm/damon/maintainer-profile: update for mm-new tree
Date: Sat, 5 Jul 2025 10:50:00 -0700

Recently a new mm tree for new patches, namely mm-new, has been added. 
Update DAMON maintainer's profile doc for DAMON patches life cycle, which
depend on those of mm trees.

Link: https://lkml.kernel.org/r/20250705175000.56259-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |   35 ++++++++--------
 1 file changed, 19 insertions(+), 16 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-update-for-mm-new-tree
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -7,9 +7,9 @@ The DAMON subsystem covers the files tha
 section of 'MAINTAINERS' file.
 
 The mailing lists for the subsystem are damon@lists.linux.dev and
-linux-mm@kvack.org.  Patches should be made against the `mm-unstable tree
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ whenever possible and posted
-to the mailing lists.
+linux-mm@kvack.org.  Patches should be made against the `mm-new tree
+<https://git.kernel.org/akpm/mm/h/mm-new>`_ whenever possible and posted to the
+mailing lists.
 
 SCM Trees
 ---------
@@ -17,17 +17,19 @@ SCM Trees
 There are multiple Linux trees for DAMON development.  Patches under
 development or testing are queued in `damon/next
 <https://git.kernel.org/sj/h/damon/next>`_ by the DAMON maintainer.
-Sufficiently reviewed patches will be queued in `mm-unstable
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ by the memory management
-subsystem maintainer.  After more sufficient tests, the patches will be queued
-in `mm-stable <https://git.kernel.org/akpm/mm/h/mm-stable>`_, and finally
-pull-requested to the mainline by the memory management subsystem maintainer.
-
-Note again the patches for `mm-unstable tree
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ are queued by the memory
-management subsystem maintainer.  If the patches requires some patches in
-`damon/next tree <https://git.kernel.org/sj/h/damon/next>`_ which not yet merged
-in mm-unstable, please make sure the requirement is clearly specified.
+Sufficiently reviewed patches will be queued in `mm-new
+<https://git.kernel.org/akpm/mm/h/mm-new>`_ by the memory management subsystem
+maintainer.  As more sufficient tests are done, the patches will move to
+`mm-unstable <https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and then to
+`mm-stable <https://git.kernel.org/akpm/mm/h/mm-stable>`_.  And finally those
+will be pull-requested to the mainline by the memory management subsystem
+maintainer.
+
+Note again the patches for `mm-new tree
+<https://git.kernel.org/akpm/mm/h/mm-new>`_ are queued by the memory management
+subsystem maintainer.  If the patches requires some patches in `damon/next tree
+<https://git.kernel.org/sj/h/damon/next>`_ which not yet merged in mm-new,
+please make sure the requirement is clearly specified.
 
 Submit checklist addendum
 -------------------------
@@ -53,8 +55,9 @@ Further doing below and putting the resu
 Key cycle dates
 ---------------
 
-Patches can be sent anytime.  Key cycle dates of the `mm-unstable
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and `mm-stable
+Patches can be sent anytime.  Key cycle dates of the `mm-new
+<https://git.kernel.org/akpm/mm/h/mm-new>`_, `mm-unstable
+<https://git.kernel.org/akpm/mm/h/mm-unstable>`_and `mm-stable
 <https://git.kernel.org/akpm/mm/h/mm-stable>`_ trees depend on the memory
 management subsystem maintainer.
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-introduce-damon_stat-module-fix-2.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch
mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch
mm-damon-sysfs-decouple-from-damon_ops_id.patch
selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch

