Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E83D1DE2C5
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 23:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739921901; cv=none; b=LlZj/BQmZV0HQcPtS1jM5Hc2SfpBnCzKDZw9myHiUATImGaH0zJLdBPvjXJIDGvYpXmuAw0iy7QXIyRH3fpBx46dfkpuJnBkGRMHMqucR8LNZc+PL4VSJLpb1ZSNiGlgK6ObT+QAmYi3pK+t1m7ygxAFyudS++oAoAEk1xRpYNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739921901; c=relaxed/simple;
	bh=8Tcoj12ccpesDE10krC1OACm4o24pFvNxzew0VFLON4=;
	h=Date:To:From:Subject:Message-Id; b=FR3E4B2h+zjMNsl0qf3HiuxXDHhCbTX6XI0UTrL0SFSegP/A7NjlXtjYpZD+A9r4OdE7vEEOevU7msuahpOtXfPxgliC3WAQAZQjSExd3gwXVrcqgg/UknkLyrOiiIdGJydJotQ6giFQN00iPom+O6FYct9cgooBW3IUFqjQtS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vBQYVzL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vBQYVzL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA86C4CEE2;
	Tue, 18 Feb 2025 23:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739921900;
	bh=8Tcoj12ccpesDE10krC1OACm4o24pFvNxzew0VFLON4=;
	h=Date:To:From:Subject:From;
	b=vBQYVzL3xmni8xqi1vhU1AFhQUdke2N7bMzzOi4/ajQ+8wjYaxbp+VlRaH6cW7UL5
	 TDrW/eRrPR0Rfgk2pzynD2VdXj6X9rFsly41MtV776gZAy+4rn+11a9boiLogXOYtn
	 5P2q+jkmtdEGYqrO0EmZ9XNKVcrryhbXYeyBta6Y=
Date: Tue, 18 Feb 2025 15:38:20 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch added to mm-unstable branch
Message-Id: <20250218233820.CDA86C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/damon: move DAMOS filter type names and meaning to design doc
has been added to the -mm mm-unstable branch.  Its filename is
     docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch

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
Subject: Docs/damon: move DAMOS filter type names and meaning to design doc
Date: Tue, 18 Feb 2025 14:37:06 -0800

DAMON sysfs usage doc is describing DAMOS filter type names and their
meanings in short.  The design doc is providing the short meaning and
detailed descriptions, too.  This is unnecessary duplicates and confuses
where to document new DAMOS filter types and features.  Move the details
from usage to design doc.

Link: https://lkml.kernel.org/r/20250218223708.53437-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   26 +++++++----------
 Documentation/mm/damon/design.rst            |   12 +++----
 2 files changed, 18 insertions(+), 20 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -408,21 +408,19 @@ in the numeric order.
 
 Each filter directory contains nine files, namely ``type``, ``matching``,
 ``allow``, ``memcg_path``, ``addr_start``, ``addr_end``, ``min``, ``max``
-and ``target_idx``.  To ``type`` file, you can write one of six special
-keywords: ``anon`` for anonymous pages, ``memcg`` for specific memory cgroup,
-``young`` for young pages, ``addr`` for specific address range (an open-ended
-interval), ``hugepage_size`` for large folios of a specific size range [``min``,
-``max``] or ``target`` for specific DAMON monitoring target filtering.  Meaning
-of the types are same to the description on the :ref:`design doc
-<damon_design_damos_filters>`.
+and ``target_idx``.  To ``type`` file, you can write the type of the filter.
+Refer to :ref:`the design doc <damon_design_damos_filters>` for available type
+names and their meanings.
 
-In case of the memory cgroup filtering, you can specify the memory cgroup of
-the interest by writing the path of the memory cgroup from the cgroups mount
-point to ``memcg_path`` file.  In case of the address range filtering, you can
-specify the start and end address of the range to ``addr_start`` and
-``addr_end`` files, respectively.  For the DAMON monitoring target filtering,
-you can specify the index of the target between the list of the DAMON context's
-monitoring targets list to ``target_idx`` file.
+For ``memcg`` type, you can specify the memory cgroup of the interest by
+writing the path of the memory cgroup from the cgroups mount point to
+``memcg_path`` file.  For ``addr`` type, you can specify the start and end
+address of the range (open-ended interval) to ``addr_start`` and ``addr_end``
+files, respectively.  For ``hugepage_size`` type, you can specify the minimum
+and maximum size of the range (closed interval) to ``min`` and ``max`` files,
+respectively.  For ``target`` type, you can specify the index of the target
+between the list of the DAMON context's monitoring targets list to
+``target_idx`` file.
 
 You can write ``Y`` or ``N`` to ``matching`` file to specify whether the filter
 is for memory that matches the ``type``.  You can write ``Y`` or ``N`` to
--- a/Documentation/mm/damon/design.rst~docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc
+++ a/Documentation/mm/damon/design.rst
@@ -600,23 +600,23 @@ counted as the scheme has tried.  This d
 
 Below ``type`` of filters are currently supported.
 
-- anonymous page
+- anon
     - Applied to pages that containing data that not stored in files.
     - Handled by operations set layer.  Supported by only ``paddr`` set.
-- memory cgroup
+- memcg
     - Applied to pages that belonging to a given cgroup.
     - Handled by operations set layer.  Supported by only ``paddr`` set.
-- young page
+- young
     - Applied to pages that are accessed after the last access check from the
       scheme.
     - Handled by operations set layer.  Supported by only ``paddr`` set.
-- pages that managed in a given size range
+- hugepage_size
     - Applied to pages that managed in a given size range.
     - Handled by operations set layer.  Supported by only ``paddr`` set.
-- address range
+- addr
     - Applied to pages that belonging to a given address range.
     - Handled by the core logic.
-- DAMON monitoring target
+- target
     - Applied to pages that belonging to a given DAMON monitoring target.
     - Handled by the core logic.
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch

