Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8418329361
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343898; cv=none; b=jTW96CI6Qgw2zbLoOJNfLDM/k/u0rJb3uOZsnxoXcovexRm3lXBYjI/syXsLvbFD8HE2t83b12qbpByJr9EuLt1F5vu4CbfmtqihtTdWw1FXMphHmNUL5DbnKMiPu38+Tvpxht0YHS3ho10cRoRcPo0aEljASztTP3Oqf2mSVKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343898; c=relaxed/simple;
	bh=JoQgtvUpc9y+qCYUgxbH0QM3wo8FM7zrbfLO1mcaYfQ=;
	h=Date:To:From:Subject:Message-Id; b=GZL2M64LSU1vWq0/285h4r2SL/oLUai8Q4Nanel24a1E/LcZGERwOY6COBggSROF/tNybPAL+zPhRPNiqrlqQg0CBH5PWVsmw6G4eXwX5o/VlH4q2LnU34NuXyAWrElt51pA7RTz2JECRaV0WsL6cFknQvwIKStVB+cAPFkv0uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LB9KusDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LB9KusDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3736FC116C6;
	Tue, 13 Jan 2026 22:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768343898;
	bh=JoQgtvUpc9y+qCYUgxbH0QM3wo8FM7zrbfLO1mcaYfQ=;
	h=Date:To:From:Subject:From;
	b=LB9KusDw4qy/idRMFhqOscAqhxiu7geSQA8SLiHbLxVlcrnJnlVE6eA8kfxH7Mxnx
	 pJpcKrAz91QlK1TQVxROnxdvPcFXVUzuMjNFGG3gGY0NrwbkbWZKHZrFBgbUnYfK0/
	 GeonWuzrr8A6Lq0JVcMcLPz3xA3ruWc0dh5cXa7s=
Date: Tue, 13 Jan 2026 14:38:17 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch added to mm-new branch
Message-Id: <20260113223818.3736FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: add monitoring intervals auto-tuning parameter
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch

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
Subject: mm/damon/lru_sort: add monitoring intervals auto-tuning parameter
Date: Tue, 13 Jan 2026 07:27:15 -0800

DAMON monitoring intervals tuning was crucial for every DAMON use case. 
Now there are a tuning guideline and an automated intervals tuning
feature.  DAMON_LRU_SORT is still using manual control of intervals.  Add
a module parameter for utilizing the auto-tuning feature with a suggested
auto-tuning parameters.

Link: https://lkml.kernel.org/r/20260113152717.70459-11-sj@kernel.org
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

 mm/damon/lru_sort.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter
+++ a/mm/damon/lru_sort.c
@@ -56,6 +56,20 @@ static unsigned long active_mem_bp __rea
 module_param(active_mem_bp, ulong, 0600);
 
 /*
+ * Auto-tune monitoring intervals.
+ *
+ * If this parameter is set as ``Y``, DAMON_LRU_SORT automatically tunes
+ * DAMON's sampling and aggregation intervals.  The auto-tuning aims to capture
+ * meaningful amount of access events in each DAMON-snapshot, while keeping the
+ * sampling interval 5 milliseconds in minimum, and 10 seconds in maximum.
+ * Setting this as ``N`` disables the auto-tuning.
+ *
+ * Disabled by default.
+ */
+static bool autotune_monitoring_intervals __read_mostly;
+module_param(autotune_monitoring_intervals, bool, 0600);
+
+/*
  * Filter [non-]young pages accordingly for LRU [de]prioritizations.
  *
  * If this is set, check page level access (youngness) once again before each
@@ -268,6 +282,7 @@ static int damon_lru_sort_apply_paramete
 {
 	struct damon_ctx *param_ctx;
 	struct damon_target *param_target;
+	struct damon_attrs attrs;
 	struct damos *hot_scheme, *cold_scheme;
 	unsigned int hot_thres, cold_thres;
 	int err;
@@ -290,18 +305,27 @@ static int damon_lru_sort_apply_paramete
 		goto out;
 	}
 
-	err = damon_set_attrs(param_ctx, &damon_lru_sort_mon_attrs);
+	attrs = damon_lru_sort_mon_attrs;
+	if (autotune_monitoring_intervals) {
+		attrs.sample_interval = 5000;
+		attrs.aggr_interval = 100000;
+		attrs.intervals_goal.access_bp = 40;
+		attrs.intervals_goal.aggrs = 3;
+		attrs.intervals_goal.min_sample_us = 5000;
+		attrs.intervals_goal.max_sample_us = 10 * 1000 * 1000;
+	}
+	err = damon_set_attrs(param_ctx, &attrs);
 	if (err)
 		goto out;
 
 	err = -ENOMEM;
-	hot_thres = damon_max_nr_accesses(&damon_lru_sort_mon_attrs) *
+	hot_thres = damon_max_nr_accesses(&attrs) *
 		hot_thres_access_freq / 1000;
 	hot_scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!hot_scheme)
 		goto out;
 
-	cold_thres = cold_min_age / damon_lru_sort_mon_attrs.aggr_interval;
+	cold_thres = cold_min_age / attrs.aggr_interval;
 	cold_scheme = damon_lru_sort_new_cold_scheme(cold_thres);
 	if (!cold_scheme) {
 		damon_destroy_scheme(hot_scheme);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
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
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch

