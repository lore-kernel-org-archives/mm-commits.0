Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578E821660D
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188353; cv=none; b=a1t9ajCdNoZg6MEJBk98JWjYQ/jwlqBnkeG8OBEijOzV8W8TWJVzUEG2CYBuS9i0Opm+ZSjzI8hnxOOCmetfWAFP+qeVO6MFhKdkgiAqVpd3kTmALrSVSeDvNVAJ4Qes0qPeN0zR21ZQFmH2m5XuUogXnPjQSEvCPcUTBxvzr98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188353; c=relaxed/simple;
	bh=wbb1ofKlk/+5JtgauG9csHIvb+nINQCqNDjNpiYFPuU=;
	h=Date:To:From:Subject:Message-Id; b=WK2jGfXnRMwavTJfjrkxGRd1FpB75nvhJaUP1CxvT0f7JiWErj8BKwSV90/ws/GG98BOBrFDJDwDxgVxjv4PLBtCDwKxc+7TBzAVY170N/4kg4iQ8UqLT9thQ5IfhZKyXVOIACINZqboSrXCx4faQsscNDqeVH+XCW74p7gIOMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jkVZ09wC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jkVZ09wC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1E7C4CEEC;
	Mon, 17 Mar 2025 05:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188353;
	bh=wbb1ofKlk/+5JtgauG9csHIvb+nINQCqNDjNpiYFPuU=;
	h=Date:To:From:Subject:From;
	b=jkVZ09wCwEU9v7CPegDGaQtcLMRYLWgrZIWt8+IFhVIkiV2Rfv9HLWPn+0fGd0yYm
	 jwBFrmdutnHdGRCHvk1Amn1IvWjaFjORi2w+OI4LGz9HEoM1olsngEKjkDEnF1UDAx
	 Ll4IkMTj2bc/J1dzld2v8fZ4GBuFHtULTxVWL1T4=
Date: Sun, 16 Mar 2025 22:12:32 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch removed from -mm tree
Message-Id: <20250317051233.2B1E7C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/damon: move DAMOS filter type names and meaning to design doc
has been removed from the -mm tree.  Its filename was
     docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

