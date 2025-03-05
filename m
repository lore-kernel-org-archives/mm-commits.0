Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59CF206F2C
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741217526; cv=none; b=Tq1Zz/PwfwqyDvdDzeyT3psZsnSm+3OurjEqJTgge2OznDT67cVa929PgqP+1ATXmHL/BdI4NCqWI3FfC9x14UDJf0Xq0xfgUO1AYEyZ3Mb3CEnPHAR2RlAcaIOpGs4RqZ5dFNyRf6xt5cTYmlLBWxR4tMYt20tWUBamWxunExs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741217526; c=relaxed/simple;
	bh=lgYo4tIIhMwBTA8hcOBz0oibd1W9kyy1+lh+TEcmkuM=;
	h=Date:To:From:Subject:Message-Id; b=Z9Wy+HRoES1tkUW5L8Ok8bXLD6beIA+D2sl/B1ZtG5IlUdy4Yopol00OVG+uK5syqwd6B47KajE3wnIR98hsX1ZHfrPDq9mUf+g1qFb9pdmiGboHaH9kFRFeT03B2BGScS8IT73eqIFQivAFuoh/E17XQHYMaa2QfAxTHbM63v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XS8Iejmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XS8Iejmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2914DC4CED1;
	Wed,  5 Mar 2025 23:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741217526;
	bh=lgYo4tIIhMwBTA8hcOBz0oibd1W9kyy1+lh+TEcmkuM=;
	h=Date:To:From:Subject:From;
	b=XS8IejmiE7jZ5HYedJPFR6paqvbE7AK44NMyGo+XQSWWMuHHSwFYAl5Chhz8fCpZI
	 tXFXpU4JE9ts4TSZsdXLy65aJCsB4lUplbVKZn3goVrnewkSyZ840nrXLPoQIVPGes
	 Sq9GggZHBFB/Kk2I/GyqzZte4zK0nzx8Glu9na48=
Date: Wed, 05 Mar 2025 15:32:05 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch added to mm-unstable branch
Message-Id: <20250305233206.2914DC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for {core,ops}_filters directories
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch

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
Subject: Docs/admin-guide/mm/damon/usage: update for {core,ops}_filters directories
Date: Wed, 5 Mar 2025 14:27:33 -0800

Document {core,ops}_filters directories on usage document.

Link: https://lkml.kernel.org/r/20250305222733.59089-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   31 ++++++++++++-----
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,7 @@ comma (",").
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
-    │ │ │ │ │ │ │ :ref:`filters <sysfs_filters>`/nr_filters
+    │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
@@ -307,9 +307,10 @@ to ``N-1``.  Each directory represents e
 schemes/<N>/
 ------------
 
-In each scheme directory, five directories (``access_pattern``, ``quotas``,
-``watermarks``, ``filters``, ``stats``, and ``tried_regions``) and three files
-(``action``, ``target_nid`` and ``apply_interval``) exist.
+In each scheme directory, seven directories (``access_pattern``, ``quotas``,
+``watermarks``, ``core_filters``, ``ops_filters``, ``filters``, ``stats``, and
+``tried_regions``) and three files (``action``, ``target_nid`` and
+``apply_interval``) exist.
 
 The ``action`` file is for setting and getting the scheme's :ref:`action
 <damon_design_damos_action>`.  The keywords that can be written to and read
@@ -420,13 +421,24 @@ The ``interval`` should written in micro
 
 .. _sysfs_filters:
 
-schemes/<N>/filters/
---------------------
+schemes/<N>/{core\_,ops\_,}filters/
+-----------------------------------
 
-The directory for the :ref:`filters <damon_design_damos_filters>` of the given
+Directories for :ref:`filters <damon_design_damos_filters>` of the given
 DAMON-based operation scheme.
 
-In the beginning, this directory has only one file, ``nr_filters``.  Writing a
+``core_filters`` and ``ops_filters`` directories are for the filters handled by
+the DAMON core layer and operations set layer, respectively.  ``filters``
+directory can be used for installing filters regardless of their handled
+layers.  Filters that requested by ``core_filters`` and ``ops_filters`` will be
+installed before those of ``filters``.  All three directories have same files.
+
+Use of ``filters`` directory can make expecting evaluation orders of given
+filters with the files under directory bit confusing.  Users are hence
+recommended to use ``core_filters`` and ``ops_filters`` directories.  The
+``filters`` directory could be deprecated in future.
+
+In the beginning, the directory has only one file, ``nr_filters``.  Writing a
 number (``N``) to the file creates the number of child directories named ``0``
 to ``N-1``.  Each directory represents each filter.  The filters are evaluated
 in the numeric order.
@@ -435,7 +447,7 @@ Each filter directory contains nine file
 ``allow``, ``memcg_path``, ``addr_start``, ``addr_end``, ``min``, ``max``
 and ``target_idx``.  To ``type`` file, you can write the type of the filter.
 Refer to :ref:`the design doc <damon_design_damos_filters>` for available type
-names and their meanings.
+names, their meaning and on what layer those are handled.
 
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
@@ -455,6 +467,7 @@ the ``type`` and ``matching`` should be
 For example, below restricts a DAMOS action to be applied to only non-anonymous
 pages of all memory cgroups except ``/having_care_already``.::
 
+    # cd ops_filters/0/
     # echo 2 > nr_filters
     # # disallow anonymous pages
     echo anon > 0/type
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch
mm-damon-core-initialize-damos-walk_completed-in-damon_new_scheme.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch
mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch
docs-mm-damon-design-document-unmapped-damos-filter-type.patch
mm-damon-add-data-structure-for-monitoring-intervals-auto-tuning.patch
mm-damon-core-implement-intervals-auto-tuning.patch
mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch
mm-damon-sysfs-commit-intervals-tuning-goal.patch
mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch
docs-mm-damon-design-document-for-intervals-auto-tuning.patch
docs-mm-damon-design-document-for-intervals-auto-tuning-fix.patch
docs-abi-damon-document-intervals-auto-tuning-abi.patch
docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch
mm-damon-core-introduce-damos-ops_filters.patch
mm-damon-paddr-support-ops_filters.patch
mm-damon-core-support-committing-ops_filters.patch
mm-damon-core-put-ops-handled-filters-to-damos-ops_filters.patch
mm-damon-paddr-support-only-damos-ops_filters.patch
mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos.patch
mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch
mm-damon-paddr-respect-ops_filters_default_reject.patch
docs-mm-damon-design-update-for-changed-filter-default-behavior.patch
mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch

