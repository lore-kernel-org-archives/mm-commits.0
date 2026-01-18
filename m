Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826BA246BC7
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 19:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768764079; cv=none; b=Nt3wavlpQnFad5HSJozFH5ojslaNLY6mgHpG5EGZqO++8/5kq0jAaPXpdO0RHZDjQ7Uqk2aLntWg1/fgQ3oNIS1GW5OIpZFx6U7TPZZdPjw3DEUDa0gYaQ1HFKn3X8s6IREeCENKYV89OjxvDiZv87Xb0HQGWdOXgG2cPPk14ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768764079; c=relaxed/simple;
	bh=yzpnq1f8GhVUmqhjO3U1CCC1uCpw7XNjQsQflQNRJ6o=;
	h=Date:To:From:Subject:Message-Id; b=DGz1PlxhpWwL8m0Ugp+nc3npECBtDCsbyF8YfYSac5/wZNJHN9Gt3HbI7ZPHfjmYj1UENUu4bfmHyOAA8mOtnMVqbMe5rMopFMF+HAqWWeaAS8TLQX+nhDeAghcVCgaoltgxBH0Gv3rKizKr+QsqU4xUPmp3cFdDrF/r/yQGYio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EyWfexok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EyWfexok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DC8C116D0;
	Sun, 18 Jan 2026 19:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768764079;
	bh=yzpnq1f8GhVUmqhjO3U1CCC1uCpw7XNjQsQflQNRJ6o=;
	h=Date:To:From:Subject:From;
	b=EyWfexokP81j5hvB2JR7cgK4U1S2n01G/rjI/21yVUAPc5H3/3Vn1z2MEenqNvUU6
	 p0mamRuXLCGGex42LOzjef37YocbunfZpL3+ChN5mPKixlAwxYCX3bDh1aJxCxv7mT
	 /Rn4lGp2K2C/t6XfKJT1eM3GTJZtPR4S+tULHS4I=
Date: Sun, 18 Jan 2026 11:21:18 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-index-simplify-the-intro.patch added to mm-new branch
Message-Id: <20260118192119.00DC8C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/index: simplify the intro
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-index-simplify-the-intro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-index-simplify-the-intro.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/index: simplify the intro
Date: Sun, 18 Jan 2026 10:02:52 -0800

Patch series "Docs/mm/damon: update intro, modules, maintainer profile,
and misc".

Update DAMON documentations for wordsmithing, clarifications, and
miscellaneous outdated things with eight patches.  Patch 1 simplifies the
brief introduction of DAMON.  Patch 2 updates DAMON user-space tool
packaged distros information on design doc to include not only Fedora, but
refer to repology.  Three following patches update design and usage
documents for clarifying DAMON sample modules purposes (patch 3), and
outdated information about usages of DAMON modules (patches 4 and 5). 
Final three patches update usage and maintainer-profile for sysfs
refresh_ms feature behavior (patch 6), synchronize DAMON MAINTAINERS
section name (patch 7), and broken damon-tests performance tests (patch
8).


This patch (of 8):

The intro is a bit verbose and redundant.  Simplify it by replacing
details with more links to the design docs, and refining the design points
list.

Link: https://lkml.kernel.org/r/20260118180305.70023-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260118180305.70023-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/index.rst |   29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

--- a/Documentation/mm/damon/index.rst~docs-mm-damon-index-simplify-the-intro
+++ a/Documentation/mm/damon/index.rst
@@ -4,28 +4,15 @@
 DAMON: Data Access MONitoring and Access-aware System Operations
 ================================================================
 
-DAMON is a Linux kernel subsystem that provides a framework for data access
-monitoring and the monitoring results based system operations.  The core
-monitoring :ref:`mechanisms <damon_design_monitoring>` of DAMON make it
+DAMON is a Linux kernel subsystem for efficient :ref:`data access monitoring
+<damon_design_monitoring>` and :ref:`access-aware system operations
+<damon_design_damos>`.  It is designed for being
 
- - *accurate* (the monitoring output is useful enough for DRAM level memory
-   management; It might not appropriate for CPU Cache levels, though),
- - *light-weight* (the monitoring overhead is low enough to be applied online),
-   and
- - *scalable* (the upper-bound of the overhead is in constant range regardless
-   of the size of target workloads).
-
-Using this framework, therefore, the kernel can operate system in an
-access-aware fashion.  Because the features are also exposed to the :doc:`user
-space </admin-guide/mm/damon/index>`, users who have special information about
-their workloads can write personalized applications for better understanding
-and optimizations of their workloads and systems.
-
-For easier development of such systems, DAMON provides a feature called
-:ref:`DAMOS <damon_design_damos>` (DAMon-based Operation Schemes) in addition
-to the monitoring.  Using the feature, DAMON users in both kernel and :doc:`user
-spaces </admin-guide/mm/damon/index>` can do access-aware system operations
-with no code but simple configurations.
+ - *accurate* (for DRAM level memory management),
+ - *light-weight* (for production online usages),
+ - *scalable* (in terms of memory size),
+ - *tunable* (for flexible usages), and
+ - *autoamted* (for production operation without manual tunings).
 
 .. toctree::
    :maxdepth: 2
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch
mm-damon-sysfs-schemes-introduce-nr_snapshots-damos-stat-file.patch
docs-mm-damon-design-update-for-nr_snapshots-damos-stat.patch
docs-admin-guide-mm-damon-usage-update-for-nr_snapshots-damos-stat.patch
docs-abi-damon-update-for-nr_snapshots-damos-stat.patch
mm-damon-update-damos-kerneldoc-for-stat-field.patch
mm-damon-core-implement-max_nr_snapshots.patch
mm-damon-sysfs-schemes-implement-max_nr_snapshots-file.patch
docs-mm-damon-design-update-for-max_nr_snapshots.patch
docs-admin-guide-mm-damon-usage-update-for-max_nr_snapshots.patch
docs-abi-damon-update-for-max_nr_snapshots.patch
mm-damon-core-add-trace-point-for-damos-stat-per-apply-interval.patch
mm-damon-tests-core-kunit-add-test-cases-for-multiple-regions-in-damon_test_split_regions_of-fix.patch
mm-damon-core-introduce-active-memory-ratio-damos-quota-goal-metric.patch
mm-damon-sysfs-schemes-support-damos_quota_active_mem_bp.patch
docs-mm-damon-design-document-damos_quota_active_mem_bp.patch
mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch
mm-damon-lru_sort-consider-age-for-quota-prioritization.patch
mm-damon-lru_sort-support-young-page-filters.patch
docs-admin-guide-mm-damon-lru_sort-document-filter_young_pages.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch
mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch
mm-vma-temporary-build-fix.patch
selftests-damon-sysfs_memcg_path_leaksh-use-kmemleak.patch
selftests-damon-wss_estimation-test-for-up-to-160-mib-working-set-size.patch
selftests-damon-access_memory-add-repeat-mode.patch
selftests-damon-wss_estimation-ensure-number-of-collected-wss.patch
selftests-damon-wss_estimation-deduplicate-failed-samples-output.patch
mm-damon-remove-damon_operations-cleanup.patch
mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch
mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch
mm-damon-core-process-damon_call_control-requests-on-a-local-list.patch
mm-damon-document-damon_call_control-dealloc_on_cancel-repeat-behavior.patch
mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch
mm-damon-rename-damon_min_region-to-damon_min_region_sz.patch
mm-damon-rename-min_sz_region-of-damon_ctx-to-min_region_sz.patch
docs-mm-damon-index-simplify-the-intro.patch
docs-mm-damon-design-link-repology-instead-of-fedora-package.patch
docs-mm-damon-design-document-damon-sample-modules.patch
docs-mm-damon-design-add-reference-to-damon_stat-usage.patch
docs-admin-guide-mm-damon-usage-introduce-damon-modules-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-stats-update-process-for-refresh_ms.patch
docs-mm-damon-maintainer-profile-fix-wrong-maitnainers-section-name.patch
docs-mm-damon-maintainer-profile-remove-damon-tests-perf-suggestion.patch

