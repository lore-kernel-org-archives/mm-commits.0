Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4A13126CA
	for <mm-commits@vger.kernel.org>; Fri,  1 May 2026 13:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777641213; cv=none; b=HzCunroT6pMZ0T3ssNbTL3qG1jo9D/1gc6F7PlkalJq13684PVw84UsA2VvAXqSdqQD59BDSOD1/Dvn91l5i5fdkPTNdgnW3muY8etCmmh833MYmDsBpXvbCTKjWY6C5tPmQu/QRu803fkS9/Px2C13AKLzgCmyRHlPvjrag7EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777641213; c=relaxed/simple;
	bh=/UmMDljkAr2xvkJ5xN43bu53iDhmLqy22p5zVn9zP/o=;
	h=Date:To:From:Subject:Message-Id; b=Lc9HADi2q2JCj0Tx4DQT7PkvLAJ0jguklSXMLftPtd/5P5IQlHXmsx590Qkq3yfwiJa1ruR6USWYzARQ0znlJ7sdpqTSe4fottykjQihtegCoyXH7I0NhmDaKO5FxWXC6Fp2QlCaYMb51g0+hFxvF9zmRpJhKyU9SjvAb17sCew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1o80PKXx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1o80PKXx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F71C2BCB4;
	Fri,  1 May 2026 13:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777641212;
	bh=/UmMDljkAr2xvkJ5xN43bu53iDhmLqy22p5zVn9zP/o=;
	h=Date:To:From:Subject:From;
	b=1o80PKXxc6JWkWrNsdf6G65CwjtNLjGIDwe09VB1W5PbCc+AKjePytfJePnCldttC
	 70a9dzVu7uMCaVeGft+Ui9hHsffMg43fqBKwECNiRKmZK2E3Sa3qszCb81s3vebs5/
	 D5uaKb9aX21UnoNc6p6qFZ8189KN9oO7KGf54Vb4=
Date: Fri, 01 May 2026 06:13:32 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-add-autotune_monitoring_intervals-parameter.patch added to mm-new branch
Message-Id: <20260501131332.A5F71C2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: add autotune_monitoring_intervals parameter
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-reclaim-add-autotune_monitoring_intervals-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-add-autotune_monitoring_intervals-parameter.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
mm-damon-core-make-charge_addr_from-aware-of-end-address-exclusivity.patch
mm-damon-core-handle-min_region_sz-remaining-quota-as-empty.patch
mm-damon-core-merge-regions-after-applying-damos-schemes.patch
mm-damon-core-introduce-failed-region-quota-charge-ratio.patch
mm-damon-sysfs-schemes-implement-fail_charge_numdenom-files.patch
docs-mm-damon-design-document-fail_charge_numdenom.patch
docs-admin-guide-mm-damon-usage-document-fail_charge_numdenom-files.patch
docs-abi-damon-document-fail_charge_numdenom.patch
mm-damon-tests-core-kunit-test-fail_charge_numdenom-committing.patch
selftests-damon-_damon_sysfs-support-failed-region-quota-charge-ratio.patch
selftests-damon-drgn_dump_damon_status-support-failed-region-quota-charge-ratio.patch
selftests-damon-sysfspy-test-failed-region-quota-charge-ratio.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch
mm-damon-core-introduce-damon_ctx-paused.patch
mm-damon-sysfs-add-pause-file-under-context-dir.patch
docs-mm-damon-design-update-for-context-pause-resume-feature.patch
docs-admin-guide-mm-damon-usage-update-for-pause-file.patch
docs-abi-damon-update-for-pause-sysfs-file.patch
mm-damon-tests-core-kunit-test-pause-commitment.patch
selftests-damon-_damon_sysfs-support-pause-file-staging.patch
selftests-damon-drgn_dump_damon_status-dump-pause.patch
selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch
selftests-damon-sysfspy-pause-damon-before-dumping-status.patch
mm-damon-introduce-damon_set_region_system_rams_default.patch
mm-damon-reclaim-cover-all-system-rams.patch
mm-damon-lru_sort-cover-all-system-rams.patch
mm-damon-core-remove-damon_set_region_biggest_system_ram_default.patch
mm-damon-stat-use-damon_set_region_system_rams_default.patch
docs-admin-guide-mm-damon-reclaim-update-for-entire-memory-monitoring.patch
docs-admin-guide-mm-damon-lru_sort-update-for-entire-memory-monitoring.patch
docs-admin-guide-mm-damon-usage-mark-scheme-filters-sysfs-dir-as-deprecated.patch
docs-abi-damon-mark-schemes-s-filters-deprecated.patch
mm-damon-reclaim-add-autotune_monitoring_intervals-parameter.patch
docs-admin-guide-mm-damon-reclaim-update-for-autotune_monitoring_intervals.patch

