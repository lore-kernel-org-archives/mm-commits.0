Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C94420B1F4
	for <mm-commits@vger.kernel.org>; Wed,  9 Jul 2025 02:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752027819; cv=none; b=e9xlZ3/v4OKtA8nOXSBRitmvIulpJ2VNyWMjzqM9PEsTRaYglcgTFz7dk3xWSRqqUdTZcsCpk8ZNNhckAPtsgW/HXXvTgpXWFtMD9xCJXkMMt4HSl2lVoICN+DB95XkTns7QOMSTTDiRtkw4Q6iECOweJmk6QRgEpdyhuYDNT/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752027819; c=relaxed/simple;
	bh=UYU9xCQmhQ3kwhSvIHSEzUdtv5Mzgn9CFiVVamMrS40=;
	h=Date:To:From:Subject:Message-Id; b=p26qub3hkTtAkGvFmBVxTL68aZZXZh5TmPPMZGWfEDLSgiPA5Og80JgETytK5okbHu54L0GAihX+4mkCg06VQ7Xfs498ziJOhuU1GWhlw2POczuXGcS/2WE6pa9S6y7Mmx4bgMJS4Hohso8P149sOOvLTFs4Q+xCJrnPrv85X/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vxZ8cnx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vxZ8cnx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3431C4CEF7;
	Wed,  9 Jul 2025 02:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752027817;
	bh=UYU9xCQmhQ3kwhSvIHSEzUdtv5Mzgn9CFiVVamMrS40=;
	h=Date:To:From:Subject:From;
	b=vxZ8cnx8gfMkMbzau4wd+w7mwHX4i21GruoUIrq1h59CLGMuBB/zGsmDrLu2hBMRl
	 OCvHpuCo62o+SqKMH6ASwCnNs58MT30Bc5RHS2bzHL+ZSRbhqlUZU4nbR5munR4lUO
	 pU45p1FEqzjhRzB9ps/aMkeXNOuOHIKFfEK8vblE=
Date: Tue, 08 Jul 2025 19:23:35 -0700
To: mm-commits@vger.kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-dests-directory.patch added to mm-new branch
Message-Id: <20250709022337.C3431C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document dests directory
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-dests-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-dests-directory.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: Docs/admin-guide/mm/damon/usage: document dests directory
Date: Tue, 8 Jul 2025 19:59:36 -0500

Document the newly added DAMOS action destination directory of the DAMON
sysfs interface on the usage document.

Link: https://lkml.kernel.org/r/20250709005952.17776-7-bijan311@gmail.com
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bijan Tabatabai <bijantabatab@micron.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   33 ++++++++++++++---
 1 file changed, 29 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-dests-directory
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -85,6 +85,8 @@ comma (",").
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`{core_,ops_,}filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,target_idx,min,max
+    │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
+    │ │ │ │ │ │ │ │ 0/id,weight
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
@@ -307,10 +309,10 @@ to ``N-1``.  Each directory represents e
 schemes/<N>/
 ------------
 
-In each scheme directory, seven directories (``access_pattern``, ``quotas``,
-``watermarks``, ``core_filters``, ``ops_filters``, ``filters``, ``stats``, and
-``tried_regions``) and three files (``action``, ``target_nid`` and
-``apply_interval``) exist.
+In each scheme directory, eight directories (``access_pattern``, ``quotas``,
+``watermarks``, ``core_filters``, ``ops_filters``, ``filters``, ``dests``,
+``stats``, and ``tried_regions``) and three files (``action``, ``target_nid``
+and ``apply_interval``) exist.
 
 The ``action`` file is for setting and getting the scheme's :ref:`action
 <damon_design_damos_action>`.  The keywords that can be written to and read
@@ -484,6 +486,29 @@ Refer to the :ref:`DAMOS filters design
 of different ``allow`` works, when each of the filters are supported, and
 differences on stats.
 
+.. _damon_sysfs_dests:
+
+schemes/<N>/dests/
+------------------
+
+Directory for specifying the destinations of given DAMON-based operation
+scheme's action.  This directory is ignored if the action of the given scheme
+is not supporting multiple destinations.  Only ``DAMOS_MIGRATE_{HOT,COLD}``
+actions are supporting multiple destinations.
+
+In the beginning, the directory has only one file, ``nr_dests``.  Writing a
+number (``N``) to the file creates the number of child directories named ``0``
+to ``N-1``.  Each directory represents each action destination.
+
+Each destination directory contains two files, namely ``id`` and ``weight``.
+Users can write and read the identifier of the destination to ``id`` file.
+For ``DAMOS_MIGRATE_{HOT,COLD}`` actions, the migrate destination node's node
+id should be written to ``id`` file.  Users can write and read the weight of
+the destination among the given destinations to the ``weight`` file.  The
+weight can be an arbitrary integer.  When DAMOS apply the action to each entity
+of the memory region, it will select the destination of the action based on the
+relative weights of the destinations.
+
 .. _sysfs_schemes_stats:
 
 schemes/<N>/stats/
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-handle-damon_call_control-as-normal-under-kdmond-deactivation.patch
mm-damon-introduce-damon_stat-module.patch
mm-damon-introduce-damon_stat-module-fix.patch
mm-damon-introduce-damon_stat-module-fix-2.patch
mm-damon-stat-calculate-and-expose-estimated-memory-bandwidth.patch
mm-damon-stat-calculate-and-expose-idle-time-percentiles.patch
docs-admin-guide-mm-damon-add-damon_stat-usage-document.patch
mm-damon-paddr-use-alloc_migartion_target-with-no-migration-fallback-nodemask.patch
revert-mm-rename-alloc_demote_folio-to-alloc_migrate_folio.patch
revert-mm-make-alloc_demote_folio-externally-invokable-for-migration.patch
selftets-damon-add-a-test-for-memcg_path-leak.patch
mm-damon-sysfs-schemes-decouple-from-damos_quota_goal_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_action.patch
mm-damon-sysfs-schemes-decouple-from-damos_wmark_metric.patch
mm-damon-sysfs-schemes-decouple-from-damos_filter_type.patch
mm-damon-sysfs-decouple-from-damon_ops_id.patch
selftests-damon-add-drgn-script-for-extracting-damon-status.patch
selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch
selftests-damon-add-python-and-drgn-based-damon-sysfs-test.patch
selftests-damon-sysfspy-test-monitoring-attribute-parameters.patch
selftests-damon-sysfspy-test-adaptive-targets-parameter.patch
selftests-damon-sysfspy-test-damos-schemes-parameters-setup.patch
mm-damon-add-trace-event-for-auto-tuned-monitoring-intervals.patch
mm-damon-add-trace-event-for-effective-size-quota.patch
mm-damon-add-trace-event-for-effective-size-quota-fix.patch
samples-damon-wsse-fix-boot-time-enable-handling.patch
samples-damon-prcl-fix-boot-time-enable-crash.patch
samples-damon-mtier-support-boot-time-enable-setup.patch
mm-damon-reclaim-reset-enabled-when-damon-start-failed.patch
mm-damon-lru_sort-reset-enabled-when-damon-start-failed.patch
mm-damon-reclaim-use-parameter-context-correctly.patch
samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch

