Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63931370D4D
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027704; cv=none; b=pRkcjya4jYjuEKkttr5gkPl04s2dSj9vtPSa32IWi3+JtKNyHu4XSMbzPcn6HfdR56+JoFjSxfbhBjnKYfj2V58nP59O5PJfJDL4/WE+ekdxMwUWfUkN3dgVrdCRP4E5xjOpbvZKgGUS4LJBVbSP4SKwbEqxqu/CyLiHBICawdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027704; c=relaxed/simple;
	bh=JiDOF/rCtff0M0rSruw2hVpjO+Vdddhhl1AScSifi/A=;
	h=Date:To:From:Subject:Message-Id; b=ZLdMlO3N+65booKBty6hdcBIODNDOyr5R4LIhqgBlFDz4dLFIQ0Swt30CgJ5VmxTB1rHdqmZ28CxNE2aSbX0Za67Qcj1oL9NX0c1pIXeeFFyyvIXafNtisNuW7MMitkML0QtAa+dTewj16bNbwuRgynPrb2Ndh2jy91FN05KT64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MUUD5W9c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MUUD5W9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6261F00893;
	Fri, 29 May 2026 04:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027703;
	bh=UjsBV25K8FXqOD2DfcOXXhsHxLway4+RC3j8NGcHQBE=;
	h=Date:To:From:Subject;
	b=MUUD5W9c/L3KHVDuhMc4tencKv+X9ehJUAwKHhTijg8ZideO2G85p+1w7OTXwTzQa
	 v7kk62fmDuBP00zrs2jo8SvlHXKEdFG/E/1yrPW3w4czftxH14orbjW0ssp4acusii
	 zUEpHL8WQaWQK1hdnFaY9/XDpoH4N2fwT3kN+2MM=
Date: Thu, 28 May 2026 21:08:22 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-add-autotune_monitoring_intervals-parameter.patch removed from -mm tree
Message-Id: <20260529040823.3A6261F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: add autotune_monitoring_intervals parameter
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-add-autotune_monitoring_intervals-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: add autotune_monitoring_intervals parameter
Date: Thu, 30 Apr 2026 18:17:38 -0700

Patch series "mm/damon/reclaim: support monitoring intervals auto-tuning".

The monitoring intervals auto-tuning feature of DAMON has proven to be
useful in multiple environments.  Add a new DAMON_RECLAIM parameter for
supporting the feature, and update the document for the new parameter.


This patch (of 2):

DAMON's monitoring intervals auto-tuning feature has proven to be useful
in multiple environments.  DAMON_RECLAIM is still asking users to do the
manual tuning of the intervals.  Add a module parameter for utilizing the
auto-tuning feature with the suggested default setup.

Note that use of the auto-tuning overrides the manually entered monitoring
intervals.  Also, note that the 'min_age' will dynamically changed
proportional to auto-tuned intervals.  It is recommended to use 'min_age'
short enough and use 'quota_mem_pressure_us' like coldness threshold
auto-tuning features together.

Link: https://lore.kernel.org/20260501011740.81988-1-sj@kernel.org
Link: https://lore.kernel.org/20260501011740.81988-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-add-autotune_monitoring_intervals-parameter
+++ a/mm/damon/reclaim.c
@@ -91,6 +91,20 @@ module_param(quota_mem_pressure_us, ulon
 static unsigned long quota_autotune_feedback __read_mostly;
 module_param(quota_autotune_feedback, ulong, 0600);
 
+/*
+ * Auto-tune monitoring intervals.
+ *
+ * If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAMON's
+ * sampling and aggregation intervals.  The auto-tuning aims to capture
+ * meaningful amount of access events in each DAMON-snapshot, while keeping the
+ * sampling intervals 5 milliseconds in minimum, and 10 seconds in maximum.
+ * Setting this as ``N`` disables the auto-tuning.
+ *
+ * Disabled by default.
+ */
+static bool autotune_monitoring_intervals __read_mostly;
+module_param(autotune_monitoring_intervals, bool, 0600);
+
 static struct damos_watermarks damon_reclaim_wmarks = {
 	.metric = DAMOS_WMARK_FREE_MEM_RATE,
 	.interval = 5000000,	/* 5 seconds */
@@ -152,7 +166,7 @@ DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(
 static struct damon_ctx *ctx;
 static struct damon_target *target;
 
-static struct damos *damon_reclaim_new_scheme(void)
+static struct damos *damon_reclaim_new_scheme(unsigned long aggr_interval)
 {
 	struct damos_access_pattern pattern = {
 		/* Find regions having PAGE_SIZE or larger size */
@@ -162,8 +176,7 @@ static struct damos *damon_reclaim_new_s
 		.min_nr_accesses = 0,
 		.max_nr_accesses = 0,
 		/* for min_age or more micro-seconds */
-		.min_age_region = min_age /
-			damon_reclaim_mon_attrs.aggr_interval,
+		.min_age_region = min_age / aggr_interval,
 		.max_age_region = UINT_MAX,
 	};
 
@@ -184,6 +197,7 @@ static int damon_reclaim_apply_parameter
 {
 	struct damon_ctx *param_ctx;
 	struct damon_target *param_target;
+	struct damon_attrs attrs;
 	struct damos *scheme;
 	struct damos_quota_goal *goal;
 	struct damos_filter *filter;
@@ -201,12 +215,21 @@ static int damon_reclaim_apply_parameter
 		goto out;
 	}
 
-	err = damon_set_attrs(param_ctx, &damon_reclaim_mon_attrs);
+	attrs = damon_reclaim_mon_attrs;
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
-	scheme = damon_reclaim_new_scheme();
+	scheme = damon_reclaim_new_scheme(attrs.aggr_interval);
 	if (!scheme)
 		goto out;
 	damon_set_schemes(param_ctx, &scheme, 1);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-ops-common-call-folio_test_lru-after-folio_get.patch
mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
mm-damon-core-introduce-struct-damon_probe.patch
mm-damon-core-embed-damon_probe-objects-in-damon_ctx.patch
mm-damon-core-introduce-damon_filter.patch
mm-damon-core-commit-probes.patch
mm-damon-core-introduce-damon_region-probe_hits.patch
mm-damon-core-introduce-damon_ops-apply_probes.patch
mm-damon-core-do-data-attributes-monitoring.patch
mm-damon-paddr-support-data-attributes-monitoring.patch
mm-damon-sysfs-implement-probes-dir.patch
mm-damon-sysfs-implement-probe-dir.patch
mm-damon-sysfs-implement-filters-directory.patch
mm-damon-sysfs-implement-filter-dir.patch
mm-damon-sysfs-implement-filter-dir-files.patch
mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch
mm-damon-sysfs-schemes-implement-tried_regions-r-probes.patch
mm-damon-sysfs-schemes-implement-probe-dir.patch
mm-damon-sysfs-schemes-implement-probe-hits-file.patch
mm-damon-trace-probe_hits.patch
selftests-damon-sysfssh-test-probes-dir.patch
docs-mm-damon-design-document-data-attributes-monitoring.patch
docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring.patch
mm-damon-core-introduce-damon_filter_type_memcg.patch
mm-damon-paddr-support-damon_filter_type_memcg.patch
mm-damon-sysfs-add-filters-f-path-file.patch
mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch
mm-damon-sysfs-setup-damon_filter-memcg_id-from-path.patch
docs-mm-damon-design-update-for-memcg-damon-filter.patch
docs-admin-guide-mm-damon-usage-update-for-memcg-damon-filter.patch
mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch
mm-damon-core-do-not-use-region-out-of-a-loop-in-damon_set_regions.patch
samples-damon-mtier-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-tests-vaddr-kunit-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-core-hide-damon_add_region.patch
mm-damon-core-hide-damon_insert_region.patch
mm-damon-core-hide-damon_destroy_region.patch
mm-damon-core-add-kdamond_call-debug_sanity-check.patch
mm-damon-core-remove-damon_verify_nr_regions.patch
mm-damon-tests-core-kunit-add-damon_set_regions-test-cases.patch
selftests-damon-sysfspy-stop-kdamonds-before-failing.patch
selftests-damon-sysfssh-test-monitoring-intervals-goal-dir.patch
selftests-damon-sysfssh-test-addr_unit-file-existence.patch
selftests-damon-sysfssh-test-pause-file-existence.patch
mm-damon-core-trace-esz-at-first-setup.patch

