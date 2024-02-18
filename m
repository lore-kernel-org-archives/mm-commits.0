Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706951D689
	for <mm-commits@vger.kernel.org>; Sun, 18 Feb 2024 21:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708290784; cv=none; b=EGbWrfSz2WqMOdRaSeXIIbHDFzN8NlYWaxH3N8TT06lTRjgUrJPB8e+w7KrOkuz3aQt2fuBQ8dz4VvLmmq4mGKkgQU6ZARLDYElIpBar6yWG5SefGR4Idhi+y80SWSrPxxWuc7cnQ70b3IPhOXJq3dFQl301+fkAdVyN5bpZSkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708290784; c=relaxed/simple;
	bh=EeR3qOowAVhhxEbzwBwkkKrxU8YZqtGj+5BDbwWPqJM=;
	h=Date:To:From:Subject:Message-Id; b=ucyv8bAzNiBXTlhzrNlbZgij3852iSIzaGab9aL1aJvYrhxnpPWGWBdaomSVIHECQBz86Kma2PiemMKVCIMtZVTfVs8I6LVbWKLxtKQVw7h5FWFk2GUhRevNouDslUL40j4R0T6Idh0tWdJxI7ef9RQ1DzjNetiLvTkdjq2NxQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0xUXtARK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0xUXtARK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA91C433C7;
	Sun, 18 Feb 2024 21:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708290784;
	bh=EeR3qOowAVhhxEbzwBwkkKrxU8YZqtGj+5BDbwWPqJM=;
	h=Date:To:From:Subject:From;
	b=0xUXtARKNZ6E0SwmhfKL3PIoUhD30JEgkRd7KQK5AO9XOvcEF3qXFBjFisJ5qhLjY
	 0LfNTkydIBnRjsu8WuhP26lesbCJrp3U97x9NVkOqgwf4dCuoI3jZ2aHxDv831hQRQ
	 AMeD5H+kk8qhJojMhCPp/0E0ycFxk77RlyIhMgxw=
Date: Sun, 18 Feb 2024 13:13:03 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch added to mm-unstable branch
Message-Id: <20240218211304.0BA91C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon: move monitoring target regions setup detail from the usage to the design document
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch

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
Subject: Docs/mm/damon: move monitoring target regions setup detail from the usage to the design document
Date: Fri, 16 Feb 2024 16:58:41 -0800

Design doc is aimed to have all concept level details, while the usage doc
is focused on only how the features can be used.  Some details about
monitoring target regions construction is on the usage doc.  Move the
details about the monitoring target regions construction differences for
DAMON operations set from the usage to the design doc.

Link: https://lkml.kernel.org/r/20240217005842.87348-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   16 +++++-----------
 Documentation/mm/damon/design.rst            |   12 +++++++++---
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -242,17 +242,11 @@ process to the ``pid_target`` file.
 targets/<N>/regions
 -------------------
 
-When ``vaddr`` monitoring operations set is being used (``vaddr`` is written to
-the ``contexts/<N>/operations`` file), DAMON automatically sets and updates the
-monitoring target regions so that entire memory mappings of target processes
-can be covered.  However, users could want to set the initial monitoring region
-to specific address ranges.
-
-In contrast, DAMON do not automatically sets and updates the monitoring target
-regions when ``fvaddr`` or ``paddr`` monitoring operations sets are being used
-(``fvaddr`` or ``paddr`` have written to the ``contexts/<N>/operations``).
-Therefore, users should set the monitoring target regions by themselves in the
-cases.
+In case of ``fvaddr`` or ``paddr`` monitoring operations sets, users are
+required to set the monitoring target address ranges.  In case of ``vaddr``
+operations set, it is not mandatory, but users can optionally set the initial
+monitoring region to specific address ranges.  Please refer to the :ref:`design
+<damon_design_vaddr_target_regions_construction>` for more details.
 
 For such cases, users can explicitly set the initial monitoring target regions
 as they want, by writing proper values to the files under this directory.
--- a/Documentation/mm/damon/design.rst~docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document
+++ a/Documentation/mm/damon/design.rst
@@ -83,12 +83,18 @@ describe how those work.
  - paddr: Monitor the physical address space of the system
 
 
+ .. _damon_design_vaddr_target_regions_construction:
+
 VMA-based Target Address Range Construction
 -------------------------------------------
 
-This is only for the virtual address space monitoring operations
-implementation.  That for the physical address space simply asks users to
-manually set the monitoring target address ranges.
+A mechanism of ``vaddr`` DAMON operations set that automatically initializes
+and updates the monitoring target address regions so that entire memory
+mappings of the target processes can be covered.
+
+This mechanism is only for the ``vaddr`` operations set.  In cases of
+``fvaddr`` and ``paddr`` operation sets, users are asked to manually set the
+monitoring target address ranges.
 
 Only small parts in the super-huge virtual address space of the processes are
 mapped to the physical memory and accessed.  Thus, tracking the unmapped
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

