Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 996121C84A3
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188508; cv=none; b=WiRBY7W3PsVr4crKfPe6do2pKUNljhwJyXzfs4xWOmG9HFSkKMQMVGXvdn5OvVJMZS63noNZ8d2k/cXEGiQyL2rTe9fdbHRwbL+Z/mrR+LlOmGO2V8naAjSkAT/T+VI62YtMFXfq+BSSHe1lQ9WWg9kSZOY2aLduEbN1Od2Z9HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188508; c=relaxed/simple;
	bh=4vh0VZKrA52+zCtKGFGDbR5jRiqJiuDF0JvP4VUavkU=;
	h=Date:To:From:Subject:Message-Id; b=GyfRio5bryvfIStA0/frfx3/DEOU15GXUMveLBhh6ACEj+MeDns+5MrJ/Xv1CYLHMbzKkVcDo3J+sa+fexyb7/ayqncQB+HbE5XSjKTkFAUfiSkv+cvbo5FvW5qE9zJ73b9VqEm3pCYM+9TBsjf9hx8ppRQqV+pL27DcisLdfQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oMEyDyN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oMEyDyN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C25BC4CEEC;
	Mon, 17 Mar 2025 05:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188508;
	bh=4vh0VZKrA52+zCtKGFGDbR5jRiqJiuDF0JvP4VUavkU=;
	h=Date:To:From:Subject:From;
	b=oMEyDyN5c96PsmwbH+gaxihds91G9ZdnTVNtcfIw5rH4e1+YKwwmPXj4hafvcMtlL
	 p1A9iesREASL+wok2H/R5XrTIV0tDiynwHeVrsbcoKmh1GBlmES0w4MCpapiLMLOSq
	 iIT88/+5mcAYODWFi3YmmFZIyJMPGOCEleyIndQc=
Date: Sun, 16 Mar 2025 22:15:07 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch removed from -mm tree
Message-Id: <20250317051508.6C25BC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: add intervals_goal directory on the hierarchy
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

