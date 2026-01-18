Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B826A199949
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 00:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768696790; cv=none; b=Cmo9FKbo/V8/sozgYo59IiIvg0mQTyDS9bid51bsUerCeUbZQ2RF5Jxpuqlj/kMwJlQx3ef0Nxt4v1ej4v2CZWnOVhIamGINS0a+Pp3b+1G+NIIZkQZn4enan/jRTa9fZES36ooqcojNVglAFXP5qir1+XAtf11z8Z8V1p+7hIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768696790; c=relaxed/simple;
	bh=9RSx6G/k0dVvswWJd8LkVPUv38/hyIP0GGGqkhLzGO8=;
	h=Date:To:From:Subject:Message-Id; b=F3k3uwipWcK0jui/zo59Dn7+0TqKc4ISflygr6zzckwW1L7+7ba6oamHWLHjQtuoOgEv8q0hw2fHUpf9QSDb6srdPVvXlA+66JZmnemThDQoCYUOJeBHv/rKDghUkSHG8VayLpJn2hR1D8K55LROX5RWeMSdAkiKrgcFxUjcat4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FVIJfqwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FVIJfqwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEBDC4CEF7;
	Sun, 18 Jan 2026 00:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768696790;
	bh=9RSx6G/k0dVvswWJd8LkVPUv38/hyIP0GGGqkhLzGO8=;
	h=Date:To:From:Subject:From;
	b=FVIJfqwgpwx8KB7NHUnV7C7moV6OUnwjJGgzPbXnxoJtW4pRQgMIoaUp0Qq/qWJaC
	 JwUw1CBabpHEu5MJbw6XiCJi3HRkF1J9jJIBJbov7cut+2tOEeNkOoy2dObtyeHJpB
	 /H3nkNntmYxteGpuzEhh9siaWjOxtQ0FSI74/H00=
Date: Sat, 17 Jan 2026 16:39:50 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch added to mm-new branch
Message-Id: <20260118003950.8CEBDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: rename damos_filter_out() to damos_core_filter_out()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out.patch

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
Subject: mm/damon/core: rename damos_filter_out() to damos_core_filter_out()
Date: Sat, 17 Jan 2026 09:52:53 -0800

DAMOS filters are processed on the core layer and operations layer,
depending on their types.  damos_filter_out() in core.c, which is for only
core layer handled filters, can confuse the fact.  Rename it to
damos_core_filter_out(), to be more explicit about the fact.

Link: https://lkml.kernel.org/r/20260117175256.82826-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-rename-damos_filter_out-to-damos_core_filter_out
+++ a/mm/damon/core.c
@@ -1813,7 +1813,7 @@ static bool damos_filter_match(struct da
 	return matched == filter->matching;
 }
 
-static bool damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
+static bool damos_core_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
 	struct damos_filter *filter;
@@ -1960,7 +1960,7 @@ static void damos_apply_scheme(struct da
 				goto update_stat;
 			damon_split_region_at(t, r, sz);
 		}
-		if (damos_filter_out(c, t, r, s))
+		if (damos_core_filter_out(c, t, r, s))
 			return;
 		ktime_get_coarse_ts64(&begin);
 		trace_damos_before_apply(cidx, sidx, tidx, r,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch
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

