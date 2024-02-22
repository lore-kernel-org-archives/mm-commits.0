Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773D3210E8
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644521; cv=none; b=l5Vp4F3jce74kcCNyp7gtkaxMysmmDSrh5lBZ6CweEo5OjicA1aoy/OOxz7qZweLrPmTItEYKRs2WSw/wsksdfiwOOAkKugGKxwlCpY41DYPATBEwlaY80Fcx0XFClxxowQgdglBY9mJt6rUn5HK0IamTpVgVJq9UHF/rePRDWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644521; c=relaxed/simple;
	bh=FxQVW/9OB/wOgndZl3R0A1mGZ5CiRDbjEauq7reRVM0=;
	h=Date:To:From:Subject:Message-Id; b=All34NQWXmDCk+BKJuLaOfsUs2AjtFD5WYE1DWxpgbwK+nCPOv1l97TtJZYQyT9C8egrGB1EsxwKqJR28w3gxxLRhuZRCxB5NRthyZFlich4hCYYCUjEErdAMb2QT7LB+GIf1hyDNhvLm6WDcGUr1l1B2p322lPHHiWijc1eeEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UxRd71ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UxRd71ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B055C433F1;
	Thu, 22 Feb 2024 23:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644521;
	bh=FxQVW/9OB/wOgndZl3R0A1mGZ5CiRDbjEauq7reRVM0=;
	h=Date:To:From:Subject:From;
	b=UxRd71lsE2HSV4WG6PH2bfIB3fvssS3U7bFdO/UW6dMINDYYSQgdsPU18oSrb8ahx
	 uy4vOFw19Fl8x9kZ2kQTVmNgsv5U0TI1T/aAPO0wGT+yecu4tDfPpqs0F+z5ktazAx
	 vv3GUj54Ap0CtFDQhbJRC1vGgeuHsRZp4OCEMAeQ=
Date: Thu, 22 Feb 2024 15:28:40 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch removed from -mm tree
Message-Id: <20240222232841.4B055C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon: move DAMON operation sets list from the usage to the design document
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon: move DAMON operation sets list from the usage to the design document
Date: Fri, 16 Feb 2024 16:58:40 -0800

The list of DAMON operation sets and their explanation, which may better
to be on design document, is written on the usage document.  Move the
detail to design document and make the usage document only reference the
design document.

[sj@kernel.org: fix a typo on a reference link]
  Link: https://lkml.kernel.org/r/20240221170852.55529-2-sj@kernel.org
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
+<damon_design_configurable_operations_set>`, including those for virtual address
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

