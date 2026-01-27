Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8816F3191B9
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486717; cv=none; b=l607toGf9LphoOqLh11iJfNhPcND2RPOSogs2TEToWlUkFxCVqp8Kf+vNkjYdjdf6ctkwE88SgbDnsB5j60Hwml8FmrdPKW080HVdg6zmEYwwXSLDliyyFtWgqgQW1MT9El8orvkijWQYDkex3QZ0ugKOkMwD9U+pFM39P04uWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486717; c=relaxed/simple;
	bh=V2jyuFBoaEHtvaggPhHcvWv19fCZXnfdAzyvdGzezfw=;
	h=Date:To:From:Subject:Message-Id; b=TspmGJMGJ9IM9syX/KkznxmBh3NGahoc1W4g5hkOGbZjVoH+qM0LL5BsVHnD0tNzHDulziGCv2Sw3YuL64ZqljSfi5EkNVKSezIaiqHP4NlA+HO1kWJnxZmy6QEwT0JoE6aHF6Yfl7tDTva2yRoJAfjkLjS5vqyMpIZoNqLgzY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1tdiyw0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1tdiyw0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6266FC116C6;
	Tue, 27 Jan 2026 04:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486717;
	bh=V2jyuFBoaEHtvaggPhHcvWv19fCZXnfdAzyvdGzezfw=;
	h=Date:To:From:Subject:From;
	b=1tdiyw0LA3jREov/jUb7GPCoMnivL28rlsnOiWwTYodL7WLbjB8ALnzCHqlfL7/lp
	 wcQmHXnCiZpwy1OUKXVK9ZI8PEkLmLf9e1W6J82t0NEP9Rz+ueeMY7NTJpoOIDnbmw
	 iV5fzyIawZmUypRXajOfKwqRnEceLD5gjs/q2RE0=
Date: Mon, 26 Jan 2026 20:05:16 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch removed from -mm tree
Message-Id: <20260127040517.6266FC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[sj@kernel.org: add inactive mem ratio quota goal to cold_scheme]
  Link: https://lkml.kernel.org/r/20260114055308.79884-1-sj@kernel.org
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
+	damos_add_quota_goal(&cold_scheme->quota, goal);
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

