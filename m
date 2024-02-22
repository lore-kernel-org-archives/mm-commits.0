Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92773137918
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644522; cv=none; b=RJ1EMnG7A0sDi8NYK/UR15zFWIIKkfKCFaTkRiTAgXFYmgg9gTXTVGrcDjjIP/bZXyXi8D0ZEG4VdtHsootYACcmA9RHrRHDmlHdrk8iTRjLPqF4LVBTY5f6GLp8s0/gEduee7+qASMAvSTpHlKY07BuXnF+QhOl0PEVOIHUAs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644522; c=relaxed/simple;
	bh=OyoNp2KGLI/hcJMziZ7FKfpL9OK/b8VPCBiufAodJgU=;
	h=Date:To:From:Subject:Message-Id; b=dxdI0HrL5GpcX03AzmZgcciho59Ou5epI5ZD2UElE9iFTrF3oj1Vpu/IvegOScFGbPWaTvMcTs3AnOplaSDWr9reqIxHHDyMFUxUw/2rYTfp0qwUXJb5rSCK6cI79gU5vyPkcMDtGNNSADDvi7iGb13MyP2u8KdjuUXk6fVFo1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V6yVjCDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V6yVjCDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660C1C433F1;
	Thu, 22 Feb 2024 23:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644522;
	bh=OyoNp2KGLI/hcJMziZ7FKfpL9OK/b8VPCBiufAodJgU=;
	h=Date:To:From:Subject:From;
	b=V6yVjCDdEurHqpIX9E38pHFzxM9gO7XLmSNrcIXLmm1AM8b1urx7J/76KOQ79JUKI
	 w/lDnyJsMGkh8oCe079GiBQGGtIs4k7i98YTQQvUfIpCNix8SuV+wIoP35kUJVkcyv
	 cn9UtWK5thib4DDkXoFz/Z0P7NGkfCPoPBJahX04=
Date: Thu, 22 Feb 2024 15:28:41 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch removed from -mm tree
Message-Id: <20240222232842.660C1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon: move monitoring target regions setup detail from the usage to the design document
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

