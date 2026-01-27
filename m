Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A283191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486715; cv=none; b=R16h0AZapE2u41QMbHnu66z43bbteJriGNL4RtQjJUFZ5UN/ZvPBEzL5hyBrTCQH7lF9Kox8SCpI07haOcwJoMVP28rgMsksxtt5g/D+M/S9JD28OKD4H7o+zp6IRabFO1mTUzLqM+Q68N95+8Igx51PxIcyyJHrDQSSgsF2jbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486715; c=relaxed/simple;
	bh=8TzaHRBTHTJ7iXrez1MyYj6uL+7YScoXUVKgRwcPIPU=;
	h=Date:To:From:Subject:Message-Id; b=Qxn01Vx7hZEUcImGtxIhB+BoXUxreHF2yRcY9FpMEHwCY+K+5IdcuL6xGNegn+z/TmmlrqMZm04Qfrg4I5B0ehs3Y7yskNSh3WYdRCXLXM+siiJQNDjyexjTgbdlEWp/v9HWffXHtxSMYUNINzuXMs/xMc60Vd4nItrQXB1k7L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nNLcohQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nNLcohQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE999C116C6;
	Tue, 27 Jan 2026 04:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486715;
	bh=8TzaHRBTHTJ7iXrez1MyYj6uL+7YScoXUVKgRwcPIPU=;
	h=Date:To:From:Subject:From;
	b=nNLcohQGefX9XyVDMWsqLTeuXIvbm0YDsRhDkh54OBkCQ1pgH2l2ljjlKXHrgS2Dx
	 Utiv62pSzuEmmRVE0ruTXc17Y5thy9J4cQkzgSUyKp9gEsh+za84OoDeLtGaoDl96s
	 c6IZYaQFG8zmvG1BLl5iIQ+ar0XmUD/T3G1sKNLU=
Date: Mon, 26 Jan 2026 20:05:14 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-support-young-page-filters.patch removed from -mm tree
Message-Id: <20260127040514.EE999C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: support young page filters
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-support-young-page-filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

