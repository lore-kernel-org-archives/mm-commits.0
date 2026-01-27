Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661CF315D5C
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 03:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486242; cv=none; b=gW9ziiTcUi+HSz8GR6u3qS5DL4rk45n05AG1VHNaXM/LZzMTJ4yh6VkL5yPTds2mjSUCsOcCzLzWPLJd2tu/c0/JOpKfCfuOhuvH0djhLw3Gwn7WXShFSTlpzEC/H7teZBYs7aIn8fsKnnAs+049zDvUZ9jO8kFfNQ0jYZs4/88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486242; c=relaxed/simple;
	bh=8crcKr5wVX+zLusyf2U61IG+UvVGttUIvM81AkVCczo=;
	h=Date:To:From:Subject:Message-Id; b=EhEtlKU5dVpIIBEM3CrkCbgo3pMJJJAN30JpMH/m5kNd1GN3o5HfFZhTq/pYXpMbJIqix5NOyPlh4jiyRNQ2ykwjK71F4//8A5UELVIwZ1b4PWpqZ8bXS7Lqix7vjw/4gl1EVD650yXGU52imESEpvTKXZ1y3temnT2F0LQHlaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OlW++YfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OlW++YfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD906C116C6;
	Tue, 27 Jan 2026 03:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486241;
	bh=8crcKr5wVX+zLusyf2U61IG+UvVGttUIvM81AkVCczo=;
	h=Date:To:From:Subject:From;
	b=OlW++YfMT97TABpLZ/fQpRwxRvlhiWZnQtKu098pxz1qCm7XqmJ+bPh3jL2YxWLp8
	 mEMYiK+Q30XTMlXlQihP46G5SHF9leDqJP3IZ0+d2yUJTV2kwiO8PrdX1P90RvVhZe
	 IyIoKUnPTj/3VOS51GNefw7x5VDYB9OTYmVChWIA=
Date: Mon, 26 Jan 2026 19:57:21 -0800
To: mm-commits@vger.kernel.org,lianux.mm@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch removed from -mm tree
Message-Id: <20260127035721.CD906C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/lru_sort: add inactive mem ratio quota goal to cold_scheme
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix.patch

This patch was dropped because it was folded into mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: add inactive mem ratio quota goal to cold_scheme
Date: Tue, 13 Jan 2026 21:48:53 -0800

damon_lru_sort_add_quota_goals() is adding inactive memory ratio quota
goal, which is for cold pages scheme, to hot pages scheme.  Fix it.

Link: https://lkml.kernel.org/r/20260114055308.79884-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: wang lian <lianux.mm@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-support-active-inactive-memory-ratio-based-auto-tuning-fix
+++ a/mm/damon/lru_sort.c
@@ -238,7 +238,7 @@ static int damon_lru_sort_add_quota_goal
 			10000 - active_mem_bp + 2);
 	if (!goal)
 		return -ENOMEM;
-	damos_add_quota_goal(&hot_scheme->quota, goal);
+	damos_add_quota_goal(&cold_scheme->quota, goal);
 	return 0;
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

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
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch
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

