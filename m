Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED2A198A2F
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741041126; cv=none; b=Rkw9wPj6Uxk819OdTPpzx9RPq664yS4IdX8Oi2oDCLCOpx6u0pagjM6qXzOkPCsKMEysmFnt2A8jKAmgY4cMqIXTsi4RsTqH0wuVFyNotDiy7pOeRgekoIySg1D9RNLtyiWYedp4DP0wtBFOjzUuhqNHtx4fa9Sk96TZQ8eZL0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741041126; c=relaxed/simple;
	bh=WBImMuuMyJC2xFIA8hsIK/CIbuHK4f46+oDkDMFvqJc=;
	h=Date:To:From:Subject:Message-Id; b=TIUzzvd8Bh94U6s47SVdxihP44gTDS5LzFSPsGQw2m+WZsx8vyHMrEWItz6rGXOjWFZ+RSTtMDxIoj16OTFSRDH/l9+QnbcjwtyW2R0+TMGDv5v3doYOJft8O/LxIFqkNNGwBNtgAr87YHwusFTHQIXo6WqFxPlA0xSYbgk9g1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aVBo3m7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aVBo3m7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53699C4CED6;
	Mon,  3 Mar 2025 22:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741041126;
	bh=WBImMuuMyJC2xFIA8hsIK/CIbuHK4f46+oDkDMFvqJc=;
	h=Date:To:From:Subject:From;
	b=aVBo3m7sJ3+GsWfNxkj8Sg22qZfrabTXxnSUtWAcRYcKgBXaETXzkb6qZM2KUNDYe
	 EFpIlJi3Iwhmg3Wl/WfiacIgx70XLKqW4TajFdGlcHbE00aGJvN2UtvllvPj2vsn/7
	 yGGSizTg+5SLITrhRxEzoEzrE1gWLOlq7EeGRIXI=
Date: Mon, 03 Mar 2025 14:32:05 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch added to mm-unstable branch
Message-Id: <20250303223206.53699C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: add intervals_goal directory on the hierarchy
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch

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
Subject: Docs/admin-guide/mm/damon/usage: add intervals_goal directory on the hierarchy
Date: Mon, 3 Mar 2025 14:17:26 -0800

Document DAMON sysfs interface usage for DAMON sampling and aggregation
intervals auto-tuning.

Link: https://lkml.kernel.org/r/20250303221726.484227-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   25 +++++++++++++++++
 Documentation/mm/damon/design.rst            |    4 ++
 2 files changed, 29 insertions(+)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -64,6 +64,7 @@ comma (",").
     │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations
     │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
+    │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
     │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target
@@ -132,6 +133,11 @@ Users can write below commands for the k
 - ``off``: Stop running.
 - ``commit``: Read the user inputs in the sysfs files except ``state`` file
   again.
+- ``update_tuned_intervals``: Update the contents of ``sample_us`` and
+  ``aggr_us`` files of the kdamond with the auto-tuning applied ``sampling
+  interval`` and ``aggregation interval`` for the files.  Please refer to
+  :ref:`intervals_goal section <damon_usage_sysfs_monitoring_intervals_goal>`
+  for more details.
 - ``commit_schemes_quota_goals``: Read the DAMON-based operation schemes'
   :ref:`quota goals <sysfs_schemes_quota_goals>`.
 - ``update_schemes_stats``: Update the contents of stats files for each
@@ -213,6 +219,25 @@ writing to and rading from the files.
 For more details about the intervals and monitoring regions range, please refer
 to the Design document (:doc:`/mm/damon/design`).
 
+.. _damon_usage_sysfs_monitoring_intervals_goal:
+
+contexts/<N>/monitoring_attrs/intervals/intervals_goal/
+-------------------------------------------------------
+
+Under the ``intervals`` directory, one directory for automated tuning of
+``sample_us`` and ``aggr_us``, namely ``intervals_goal`` directory also exists.
+Under the directory, four files for the auto-tuning control, namely
+``access_bp``, ``aggrs``, ``min_sample_us`` and ``max_sample_us`` exist.
+Please refer to  the :ref:`design document of the feature
+<damon_design_monitoring_intervals_autotuning>` for the internal of the tuning
+mechanism.  Reading and writing the four files under ``intervals_goal``
+directory shows and updates the tuning parameters that described in the
+:ref:design doc <damon_design_monitoring_intervals_autotuning>` with the same
+names.  The tuning starts with the user-set ``sample_us`` and ``aggr_us``.  The
+tuning-applied current values of the two intervals can be read from the
+``sample_us`` and ``aggr_us`` files after writing ``update_tuned_intervals`` to
+the ``state`` file.
+
 .. _sysfs_targets:
 
 contexts/<N>/targets/
--- a/Documentation/mm/damon/design.rst~docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy
+++ a/Documentation/mm/damon/design.rst
@@ -366,6 +366,10 @@ is recommended.  Note that Parreto princ
 That is, assumes 4% (20% of 20%) DAMON-observed access events ratio (source)
 to capture 64% (80% multipled by 80%) real access events (outcomes).
 
+To know how user-space can use this feature via :ref:`DAMON sysfs interface
+<sysfs_interface>`, refer to :ref:`intervals_goal <sysfs_scheme>` part of
+the documentation.
+
 
 .. _damon_design_damos:
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
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
docs-abi-damon-document-intervals-auto-tuning-abi.patch
docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch

