Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE9B3191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486722; cv=none; b=oTvBl5C985NUP7ferZc5HkI9eaGN0y4me5BuYsBtTT2VOxK6CEodshzBobYXswOS8imuZrKf2ZACOHjGXxEW4RW7ISrAz9A0iQd/zAd1trmCahU9rT6hR1COF4y1XmlvRhmzntVujn+zY5glhttffHLxb+tO67gkHiA2tQ7XI6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486722; c=relaxed/simple;
	bh=VlQJRZuA0c3klrRpO8cYnhO43+5baBPqnTAyOz9lwHc=;
	h=Date:To:From:Subject:Message-Id; b=cMZYonsCBBJnTI1zgsUdWsib75N0EKjlfhpOnQhpYQEC1Z6VINCEapjHHRaYz1UGAquoif6/3tuDPkolAgpHaoE4m6UKr6z6utkcNTWgf82cl+Yh80VniQm7xIgEQeJkqKk/HobH3xgkzfLvLmCLyztTXraX64czrBEzsO7z2nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N3O5BO8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N3O5BO8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B5BC116C6;
	Tue, 27 Jan 2026 04:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486721;
	bh=VlQJRZuA0c3klrRpO8cYnhO43+5baBPqnTAyOz9lwHc=;
	h=Date:To:From:Subject:From;
	b=N3O5BO8FzIXt4IHsK7nEoOc4jxI146lGXZcuvO2X6gwOTUT2w2aWwyFt3P5YJCof9
	 YajVMjkzDMqZx6Z6UvEpZJhSurBU8YM1+hYkh2vRrn7RDqZreuULAGK7yn+1flk9vB
	 KDSjEY61cc3zqX+6OYBAlS2pNDcpwF4lXz3CoBrY=
Date: Mon, 26 Jan 2026 20:05:21 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch removed from -mm tree
Message-Id: <20260127040521.C4B5BC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: add monitoring intervals auto-tuning parameter
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: wang lian <lianux.mm@gmail.com>
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
maple_tree-start-using-maple-copy-node-for-destination-fix.patch

