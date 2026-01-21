Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF4C3101C0
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 01:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768960336; cv=none; b=jY34ftKuzDy2r2hGwqepnxXKyUCbpgYzvuZS+4SKc+s+BdTzDtAXhpKIU+LpYDK05JLBts+CiJ+HGcDhVbvW0TsxO/WPdNq/BOktFmzWLo9STxC4n9K9Iej8U/Z6mSsX8dQz2jFSzXQGiMFFSSIu4l1J5GtgmdhXGJyWDEjtHA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768960336; c=relaxed/simple;
	bh=zKAN8juLw1dik56/kLp8G5KuLvfNgDAJjCNB3tgDMSA=;
	h=Date:To:From:Subject:Message-Id; b=OAC9X79/aKRbXOkFIB2VfrkBzr2LZDIwK6cMrHzhyR3X02dixr7W5Ml+LTrcs1MzFohr7fZc9ywi7BiI3pmL1fIuBNip43q4GtXvWUAXtUTvobg6K0RfUr98+HAxRHU/7oW1xQfuT/0M4rhBxZzIxwa+wLY6mvc/RkSsmwStKLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dMgcGHoZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dMgcGHoZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832FDC19423;
	Wed, 21 Jan 2026 01:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768960335;
	bh=zKAN8juLw1dik56/kLp8G5KuLvfNgDAJjCNB3tgDMSA=;
	h=Date:To:From:Subject:From;
	b=dMgcGHoZ9JIbMK040hRjNTRysBI5bNiHVZApZlvTVor9kxKsEAgawsRyvZwRDyRBc
	 x8SrmyWplgu2vT0npmXjhC+sJ8DydLAjP3IVSMyv2a26/FOE52SVbDwmpHiCXBd+cn
	 OdJAlZoViAxnxJs5xq23/72n9s2TlSEG+2GrmhRc=
Date: Tue, 20 Jan 2026 17:52:14 -0800
To: mm-commits@vger.kernel.org,clm@meta.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch removed from -mm tree
Message-Id: <20260121015215.832FDC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: fix wrong list_is_last() call in damons_is_last_region()
has been removed from the -mm tree.  Its filename was
     mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch

This patch was dropped because it was folded into mm-damon-core-introduce-nr_snapshots-damos-stat.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix wrong list_is_last() call in damons_is_last_region()
Date: Wed, 14 Jan 2026 06:57:38 -0800

damon_is_last_region() is calling list_is_last() with swapped arguments. 
As a result, it works like damon_is_first_region().  Not that this is not
making user-visible impact, because the function is only used to increment
nr_snapshots stat once per DAMOS' regions iteration, and the stat is
exposed users only after the iteration is completed.  That's why it passed
a user space test.  Nonetheless, the bug is a bug and could cause real
user issues in future.  Fix it by correcting the order of arguments for
list_lis_last().

Link: https://lkml.kernel.org/r/20260114152049.99727-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/20260114122959.1164957-1-clm@meta.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-introduce-nr_snapshots-damos-stat-fix
+++ a/mm/damon/core.c
@@ -160,7 +160,7 @@ void damon_destroy_region(struct damon_r
 static bool damon_is_last_region(struct damon_region *r,
 		struct damon_target *t)
 {
-	return list_is_last(&t->regions_list, &r->list);
+	return list_is_last(&r->list, &t->regions_list);
 }
 
 /*
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

