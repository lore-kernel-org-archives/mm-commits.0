Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E131D689
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 21:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708290780; cv=none; b=QjPVL2Om0JgUrI2GSwNkqTLoc1MbQn/N5rXm93Vaahvk++BhFrVamlb7CatoYNt0mxsnSS5nZ7q0/GRpqVCPhIu6VveOvtjsfHSk2pwCffHnUVGNXBO5usBShjM18zGIsMbqkbqXabqTq1Q2cHWEbCFgMkCl6HMpbvWIicy5w6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708290780; c=relaxed/simple;
	bh=qiBfkAWS9pOiwnO1Yo0mTaSNvT9mhenoGaOLIhZDaeU=;
	h=Date:To:From:Subject:Message-Id; b=Ywb9ZniUat+uviCRhXhS8+ROQ7jVnyHSft7x9x2yQvEMTknH11IOa1Kw8gMhSZrtEK7PXw912YqAd1WPqGMU8pYxZZeETgbI7oXrSKR/wQXcbXhdGicaXjUhYjsI/STccDBc5QQ9DWXe7gj5isZg2qBiPkGdbW178MWsRIFyf18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IfUOFUpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IfUOFUpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08AFC433F1;
	Sun, 18 Feb 2024 21:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708290779;
	bh=qiBfkAWS9pOiwnO1Yo0mTaSNvT9mhenoGaOLIhZDaeU=;
	h=Date:To:From:Subject:From;
	b=IfUOFUpforaDC/tSAYzo49njY8KSFrMhdJsS+oUJfewNdz0ZrAUNTAzgmraxm0nh+
	 5nEulnHEpjAPvLKF0EWgDx8KiJ2NWLxCjbTPU4rgvHDFq76+WGa/hHDTW5yrNfyoq5
	 r5bqxXmlv/v44bFtk6MULGsoUOV685gMTuTCQMhU=
Date: Sun, 18 Feb 2024 13:12:59 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch added to mm-unstable branch
Message-Id: <20240218211259.C08AFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon: move the list of DAMOS actions to design doc
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch

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
Subject: Docs/mm/damon: move the list of DAMOS actions to design doc
Date: Fri, 16 Feb 2024 16:58:39 -0800

DAMOS operation actions are explained nearly twice on the DAMON usage
document, once for the sysfs interface, and then again for the debugfs
interface.  Duplication is bad.  Also it would better to keep this kind of
concept level details in design document and keep the usage document small
and focus on only the usage.  Move the list to design document and update
usage document to reference it.

Link: https://lkml.kernel.org/r/20240217005842.87348-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   47 ++++-------------
 Documentation/mm/damon/design.rst            |   26 ++++++++-
 2 files changed, 36 insertions(+), 37 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-mm-damon-move-the-list-of-damos-actions-to-design-doc
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -302,27 +302,8 @@ In each scheme directory, five directori
 
 The ``action`` file is for setting and getting the scheme's :ref:`action
 <damon_design_damos_action>`.  The keywords that can be written to and read
-from the file and their meaning are as below.
-
-Note that support of each action depends on the running DAMON operations set
-:ref:`implementation <sysfs_context>`.
-
- - ``willneed``: Call ``madvise()`` for the region with ``MADV_WILLNEED``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
- - ``cold``: Call ``madvise()`` for the region with ``MADV_COLD``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
- - ``pageout``: Call ``madvise()`` for the region with ``MADV_PAGEOUT``.
-   Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
- - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
- - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
-   Supported by ``vaddr`` and ``fvaddr`` operations set.
- - ``lru_prio``: Prioritize the region on its LRU lists.
-   Supported by ``paddr`` operations set.
- - ``lru_deprio``: Deprioritize the region on its LRU lists.
-   Supported by ``paddr`` operations set.
- - ``stat``: Do nothing but count the statistics.
-   Supported by all operations sets.
+from the file and their meaning are same to those of the list on
+:ref:`design doc <damon_design_damos_action>`.
 
 The ``apply_interval_us`` file is for setting and getting the scheme's
 :ref:`apply_interval <damon_design_damos>` in microseconds.
@@ -763,19 +744,17 @@ Action
 ~~~~~~
 
 The ``<action>`` is a predefined integer for memory management :ref:`actions
-<damon_design_damos_action>`.  The supported numbers and their meanings are as
-below.
-
- - 0: Call ``madvise()`` for the region with ``MADV_WILLNEED``.  Ignored if
-   ``target`` is ``paddr``.
- - 1: Call ``madvise()`` for the region with ``MADV_COLD``.  Ignored if
-   ``target`` is ``paddr``.
- - 2: Call ``madvise()`` for the region with ``MADV_PAGEOUT``.
- - 3: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.  Ignored if
-   ``target`` is ``paddr``.
- - 4: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.  Ignored if
-   ``target`` is ``paddr``.
- - 5: Do nothing but count the statistics
+<damon_design_damos_action>`.  The mapping between the ``<action>`` values and
+the memory management actions is as below.  For the detailed meaning of the
+action and DAMON operations set supporting each action, please refer to the
+list on :ref:`design doc <damon_design_damos_action>`.
+
+ - 0: ``willneed``
+ - 1: ``cold``
+ - 2: ``pageout``
+ - 3: ``hugepage``
+ - 4: ``nohugepage``
+ - 5: ``stat``
 
 Quota
 ~~~~~
--- a/Documentation/mm/damon/design.rst~docs-mm-damon-move-the-list-of-damos-actions-to-design-doc
+++ a/Documentation/mm/damon/design.rst
@@ -294,9 +294,29 @@ not mandated to support all actions of t
 specific DAMOS action depends on what operations set is selected to be used
 together.
 
-Applying an action to a region is considered as changing the region's
-characteristics.  Hence, DAMOS resets the age of regions when an action is
-applied to those.
+The list of the supported actions, their meaning, and DAMON operations sets
+that supports each action are as below.
+
+ - ``willneed``: Call ``madvise()`` for the region with ``MADV_WILLNEED``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``cold``: Call ``madvise()`` for the region with ``MADV_COLD``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``pageout``: Call ``madvise()`` for the region with ``MADV_PAGEOUT``.
+   Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
+ - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
+   Supported by ``vaddr`` and ``fvaddr`` operations set.
+ - ``lru_prio``: Prioritize the region on its LRU lists.
+   Supported by ``paddr`` operations set.
+ - ``lru_deprio``: Deprioritize the region on its LRU lists.
+   Supported by ``paddr`` operations set.
+ - ``stat``: Do nothing but count the statistics.
+   Supported by all operations sets.
+
+Applying the actions except ``stat`` to a region is considered as changing the
+region's characteristics.  Hence, DAMOS resets the age of regions when any such
+actions are applied to those.
 
 
 .. _damon_design_damos_access_pattern:
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

