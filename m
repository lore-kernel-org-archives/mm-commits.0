Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7489D1D689
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 21:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708290782; cv=none; b=JdGxo+hDU+PeaEFgUQgWr8lO396PZEjeGDaHYZmUq2uORSHlFTFURWz0S0tFq6eQZ4M0St90Zn8FZ2L3uQwt0nrl/Ce9KMRfWtIAChoeZyhyuhqWATuqaT81hOxpx1+W9oCb4woB+WTFlXxlfuGDOnnKcxw8gthS+SPLtciWHF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708290782; c=relaxed/simple;
	bh=qFoY9siIEQMLiHA+Yuu9vyV2gMCl4auaALr+QUFYXSw=;
	h=Date:To:From:Subject:Message-Id; b=LvpG3s0w9kaDhz0bjdJOkAmzdhev2UsfBUAuBWAiLQrWf2cXQB6kvSULSy26yU3lzY09Ja0s8dPx2zdgbex4BTllLMCYBS8HZ+qPEq93njPlAxwMW8o4fBMZ5hFZ7sbqyodx8pY7oAv8r5giR19sJYvmBqcmX9mi8yrM/k3igsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y6YjcnDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y6YjcnDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8FBC433F1;
	Sun, 18 Feb 2024 21:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708290782;
	bh=qFoY9siIEQMLiHA+Yuu9vyV2gMCl4auaALr+QUFYXSw=;
	h=Date:To:From:Subject:From;
	b=Y6YjcnDD53NxB3O7nY2IhNyIRdAullegMxG4FQ2tpWzbP12K3VeVVR9FPpA0oUc3T
	 CZsz5+t3Q7SnACzisM3Kq544DSl4MCUuZ0l6o/pD1xqoNiwCV1Tehg8zTwQjJai5a0
	 Ue8Xwi6ZCDPNPU0FzQ7cNiCwuAfLb6EoiQPlFn6I=
Date: Sun, 18 Feb 2024 13:13:01 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch added to mm-unstable branch
Message-Id: <20240218211301.EC8FBC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon: move DAMON operation sets list from the usage to the design document
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch

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
Subject: Docs/mm/damon: move DAMON operation sets list from the usage to the design document
Date: Fri, 16 Feb 2024 16:58:40 -0800

The list of DAMON operation sets and their explanation, which may better
to be on design document, is written on the usage document.  Move the
detail to design document and make the usage document only reference the
design document.

Link: https://lkml.kernel.org/r/20240217005842.87348-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   19 ++++++-----------
 Documentation/mm/damon/design.rst            |   12 ++++++++--
 2 files changed, 17 insertions(+), 14 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -180,19 +180,14 @@ In each context directory, two files (``
 and three directories (``monitoring_attrs``, ``targets``, and ``schemes``)
 exist.
 
-DAMON supports multiple types of monitoring operations, including those for
-virtual address space and the physical address space.  You can get the list of
-available monitoring operations set on the currently running kernel by reading
+DAMON supports multiple types of :ref:`monitoring operations
+<damon_design_confiurable_operations_set>`, including those for virtual address
+space and the physical address space.  You can get the list of available
+monitoring operations set on the currently running kernel by reading
 ``avail_operations`` file.  Based on the kernel configuration, the file will
-list some or all of below keywords.
-
- - vaddr: Monitor virtual address spaces of specific processes
- - fvaddr: Monitor fixed virtual address ranges
- - paddr: Monitor the physical address space of the system
-
-Please refer to :ref:`regions sysfs directory <sysfs_regions>` for detailed
-differences between the operations sets in terms of the monitoring target
-regions.
+list different available operation sets.  Please refer to the :ref:`design
+<damon_operations_set>` for the list of all available operation sets and their
+brief explanations.
 
 You can set and get what type of monitoring operations DAMON will use for the
 context by writing one of the keywords listed in ``avail_operations`` file and
--- a/Documentation/mm/damon/design.rst~docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document
+++ a/Documentation/mm/damon/design.rst
@@ -31,6 +31,8 @@ DAMON subsystem is configured with three
   interfaces for the user space, on top of the core layer.
 
 
+.. _damon_design_configurable_operations_set:
+
 Configurable Operations Set
 ---------------------------
 
@@ -63,6 +65,8 @@ modules that built on top of the core la
 used by the user space end users.
 
 
+.. _damon_operations_set:
+
 Operations Set Layer
 ====================
 
@@ -71,8 +75,12 @@ The monitoring operations are defined in
 1. Identification of the monitoring target address range for the address space.
 2. Access check of specific address range in the target space.
 
-DAMON currently provides the implementations of the operations for the physical
-and virtual address spaces. Below two subsections describe how those work.
+DAMON currently provides below three operation sets.  Below two subsections
+describe how those work.
+
+ - vaddr: Monitor virtual address spaces of specific processes
+ - fvaddr: Monitor fixed virtual address ranges
+ - paddr: Monitor the physical address space of the system
 
 
 VMA-based Target Address Range Construction
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

