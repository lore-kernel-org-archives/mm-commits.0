Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870D931AF07
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343894; cv=none; b=g8SnTDD1Uoege3lXR3D7ly9xvk2n3vml+n2d4unBSE81Q8rz/ILgOaSiBnN14BQ5GqvnMM7kaW8ZQIl9WytLXfDExox5FywLvKitXOwtOaEg86w1RKlnPFztir1vwWgtDPVvMcKo2ZH1cOuA09/OAwOms0EcWMwCHO5YkLmQMmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343894; c=relaxed/simple;
	bh=EEA7k9YajX4TmiFXLMbYHUwj/RvSG8yRVz2IbZilMaI=;
	h=Date:To:From:Subject:Message-Id; b=TjeDHpo0eXC9T8m9vaQESceRJi/7ajFE0+sr2OIr3C4UH7CvKzeDYxWlR23A5hqEiJgvKcOmPown9+uPZTuLRuT8MVTORswuKTWhKFAJkA8WESBngIWXzC3zEdEo2TL98l3NVICF0DflYyY0up6xWARXNgocU53TS7qlqRu6hD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QPHky8vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QPHky8vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A525C116C6;
	Tue, 13 Jan 2026 22:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768343894;
	bh=EEA7k9YajX4TmiFXLMbYHUwj/RvSG8yRVz2IbZilMaI=;
	h=Date:To:From:Subject:From;
	b=QPHky8vd0wP/i77E9q8EPTnLUx71tVFWfh/TYr3RiKGy6bFh5wMtRJjoQYC7CMlWy
	 lewyA0s58obOcCo2u5KtRzUIITX9Lri0JQukTrPXu3FOhpCIcRzLwn3BhKHb0dOOHv
	 3h8lYcgqf7c94cwcJPoPDPvJUVX9TpGsb/K1PRUc=
Date: Tue, 13 Jan 2026 14:38:13 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch added to mm-new branch
Message-Id: <20260113223814.1A525C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch

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
Subject: mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning
Date: Tue, 13 Jan 2026 07:27:13 -0800

Doing DAMOS_LRU_[DE]PRIO with DAMOS_QUOTA_[IN]ACTIVE_MEM_BP based quota
auto-tuning can be easy and intuitive, compared to the manual
[de]prioritization target access pattern thresholds tuning.  For example,
users can ask DAMON to "find hot/cold pages and activate/deactivate those
aiming 50:50 active:inactive memory size." But DAMON_LRU_SORT has no
interface to do that.  Add a module parameter for setting the target
ratio.

Link: https://lkml.kernel.org/r/20260113152717.70459-9-sj@kernel.org
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

 mm/damon/lru_sort.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning
+++ a/mm/damon/lru_sort.c
@@ -42,6 +42,20 @@ static bool commit_inputs __read_mostly;
 module_param(commit_inputs, bool, 0600);
 
 /*
+ * Desired active to [in]active memory ratio in bp (1/10,000).
+ *
+ * While keeping the caps that set by other quotas, DAMON_LRU_SORT
+ * automatically increases and decreases the effective level of the quota
+ * aiming the LRU [de]prioritizations of the hot and cold memory resulting in
+ * this active to [in]active memory ratio.  Value zero means disabling this
+ * auto-tuning feature.
+ *
+ * Disabled by default.
+ */
+static unsigned long active_mem_bp __read_mostly;
+module_param(active_mem_bp, ulong, 0600);
+
+/*
  * Filter [non-]young pages accordingly for LRU [de]prioritizations.
  *
  * If this is set, check page level access (youngness) once again before each
@@ -208,6 +222,26 @@ static struct damos *damon_lru_sort_new_
 	return damon_lru_sort_new_scheme(&pattern, DAMOS_LRU_DEPRIO);
 }
 
+static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
+		struct damos *cold_scheme)
+{
+	struct damos_quota_goal *goal;
+
+	if (!active_mem_bp)
+		return 0;
+	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
+	if (!goal)
+		return -ENOMEM;
+	damos_add_quota_goal(&hot_scheme->quota, goal);
+	/* aim 0.2 % goal conflict, to keep little ping pong */
+	goal = damos_new_quota_goal(DAMOS_QUOTA_INACTIVE_MEM_BP,
+			10000 - active_mem_bp + 2);
+	if (!goal)
+		return -ENOMEM;
+	damos_add_quota_goal(&hot_scheme->quota, goal);
+	return 0;
+}
+
 static int damon_lru_sort_add_filters(struct damos *hot_scheme,
 		struct damos *cold_scheme)
 {
@@ -277,6 +311,9 @@ static int damon_lru_sort_apply_paramete
 	damon_set_schemes(param_ctx, &hot_scheme, 1);
 	damon_add_scheme(param_ctx, cold_scheme);
 
+	err = damon_lru_sort_add_quota_goals(hot_scheme, cold_scheme);
+	if (err)
+		goto out;
 	err = damon_lru_sort_add_filters(hot_scheme, cold_scheme);
 	if (err)
 		goto out;
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

