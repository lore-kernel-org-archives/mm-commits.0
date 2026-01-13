Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E01320CA7
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343890; cv=none; b=klP7ADIkqKVVoSdijhXtWl8JBG3XJAdShaG8yLrTaqWd7P9QfafJj1750NNWJgl7xkdlliI4Ax1NSzFGPeOMt14IbRxB82AKGUNHZawdLZEQcdvanNulq+OJpiVdhjp5+Uh6YyHALsAtxJckJh140I4HtXUaj20JrIGVQYffZYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343890; c=relaxed/simple;
	bh=DFDyLcAxqGxzE37nXz3bEqfuntmibARqnWh3GIm6aZg=;
	h=Date:To:From:Subject:Message-Id; b=U0wUmFaoiZcb/MczSIv8zOojA5/fgt9kfSPvVFQVLGIZcodgfbp1JIciZvOjvUTsGNuubaWIePWvXF0Od70DHrzYEcLw91MIRLHVnE649KbcToCZ7bVQl2pWWfZI1v4mfIJAp96svaFYPoAlM6GrFdCyvn1zF9iMg+VRH9KsHIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=me+WFqUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="me+WFqUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03C6C116C6;
	Tue, 13 Jan 2026 22:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768343889;
	bh=DFDyLcAxqGxzE37nXz3bEqfuntmibARqnWh3GIm6aZg=;
	h=Date:To:From:Subject:From;
	b=me+WFqUce7VG5U7TTi3yt0XS3MS1jIglc2vCvfBssBv85xFXSV7bEF7VFp8ooBGaQ
	 mAJ33WI6466xeogOCz1gItNyb/SVh1CMNrywYvDqVslLdcIK3dxbrmW4OHv5j4/61T
	 pbRUjaWQK+MTVqt6n5IU50be+HMPLlD6CEiAi5DM=
Date: Tue, 13 Jan 2026 14:38:09 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-support-young-page-filters.patch added to mm-new branch
Message-Id: <20260113223809.D03C6C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: support young page filters
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-lru_sort-support-young-page-filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-support-young-page-filters.patch

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
Subject: mm/damon/lru_sort: support young page filters
Date: Tue, 13 Jan 2026 07:27:11 -0800

DAMON monitors access patterns at the region level, and hence there could
be some page level mismatches.  A few hot pages could be located in cold
regions, and vice versa.  Young page filters can be useful for doing
additional page level access checks before applying some DAMOS action.

DAMON_LRU_SORT is not using young page filters, though.  Add a parameter
for using it.

Link: https://lkml.kernel.org/r/20260113152717.70459-7-sj@kernel.org
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

 mm/damon/lru_sort.c |   41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-support-young-page-filters
+++ a/mm/damon/lru_sort.c
@@ -42,6 +42,21 @@ static bool commit_inputs __read_mostly;
 module_param(commit_inputs, bool, 0600);
 
 /*
+ * Filter [non-]young pages accordingly for LRU [de]prioritizations.
+ *
+ * If this is set, check page level access (youngness) once again before each
+ * LRU [de]prioritization operation.  LRU prioritization operation is skipped
+ * if the page has not accessed since the last check (not young).  LRU
+ * deprioritization operation is skipped if the page has accessed since the
+ * last check (young).  The feature is enabled or disabled if this parameter is
+ * set as ``Y`` or ``N``, respectively.
+ *
+ * Disabled by default.
+ */
+static bool filter_young_pages __read_mostly;
+module_param(filter_young_pages, bool, 0600);
+
+/*
  * Access frequency threshold for hot memory regions identification in permil.
  *
  * If a memory region is accessed in frequency of this or higher,
@@ -193,6 +208,28 @@ static struct damos *damon_lru_sort_new_
 	return damon_lru_sort_new_scheme(&pattern, DAMOS_LRU_DEPRIO);
 }
 
+static int damon_lru_sort_add_filters(struct damos *hot_scheme,
+		struct damos *cold_scheme)
+{
+	struct damos_filter *filter;
+
+	if (!filter_young_pages)
+		return 0;
+
+	/* disallow prioritizing not-young pages */
+	filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, false, false);
+	if (!filter)
+		return -ENOMEM;
+	damos_add_filter(hot_scheme, filter);
+
+	/* disabllow de-prioritizing young pages */
+	filter = damos_new_filter(DAMOS_FILTER_TYPE_YOUNG, true, false);
+	if (!filter)
+		return -ENOMEM;
+	damos_add_filter(cold_scheme, filter);
+	return 0;
+}
+
 static int damon_lru_sort_apply_parameters(void)
 {
 	struct damon_ctx *param_ctx;
@@ -240,6 +277,10 @@ static int damon_lru_sort_apply_paramete
 	damon_set_schemes(param_ctx, &hot_scheme, 1);
 	damon_add_scheme(param_ctx, cold_scheme);
 
+	err = damon_lru_sort_add_filters(hot_scheme, cold_scheme);
+	if (err)
+		goto out;
+
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
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

