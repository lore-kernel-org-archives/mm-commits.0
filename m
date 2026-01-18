Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3194C6D
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 00:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768696784; cv=none; b=pIPKXFDm4PUGmMdWCN6FwIv4QhpIyz8JDag3cOuNri5GUSgfrVtbFo24HhHq8Sewispx3vJZPInCuykfrvD8lHl/GqiLAJn0x+UFW/6nMifQTE07BV4vm8w44EuyGHZFOzg5B32r34ZIh5eA1FNwEBin3VqyseXfsQ5mYj922CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768696784; c=relaxed/simple;
	bh=hynWCQlOK1GPf7ArhlnN+uM1EYo72vKqSR7kqPeiYgI=;
	h=Date:To:From:Subject:Message-Id; b=c2lPw/XTh7h3lygmUQ7uP+eSPt3oubedo+lEbGEDBumCDD3B8mzHhGDr0E6DWx4ukySOKe34w6w4lWlIxBXu5RWketSCDq/hdj27I3jZN3i7nYUiGe9m2VhhBc7RyJh7jECEGOYQFos3qghD55pPLnLuYgW8Z+DKBn+kzoFCrTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bm5K1SCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bm5K1SCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821A5C4CEF7;
	Sun, 18 Jan 2026 00:39:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768696784;
	bh=hynWCQlOK1GPf7ArhlnN+uM1EYo72vKqSR7kqPeiYgI=;
	h=Date:To:From:Subject:From;
	b=bm5K1SCVKtr3wjMehf1LaSwcDkgncYgj5Y1nx9nY4yaId2TfCE/iEFBRY7A8WKhrn
	 EfMjYLgYTBE3CGzlo14DZ0wcM8NdCzvfWIihFXY8tkjODauEHNWexLMhfcbvwWEHFN
	 E23EfbGVJM1x4VEdBtcLSSzsuIz4NZJIWXV5lRYA=
Date: Sat, 17 Jan 2026 16:39:43 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch added to mm-new branch
Message-Id: <20260118003944.821A5C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: cancel damos_walk() before damon_ctx->kdamond reset
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset.patch

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
Subject: mm/damon/core: cancel damos_walk() before damon_ctx->kdamond reset
Date: Sat, 17 Jan 2026 09:52:50 -0800

damos_walk() request is canceled after damon_ctx->kdamond is reset.  This
can make weird situations where damon_is_running() returns false but the
DAMON context has the damos_walk() request linked.  There was a similar
situation for damon_call() requests handling [1], which _was_ able to
cause a racy use-after-free bug.  Unlike the case of damon_call(), because
damos_walk() is always synchronously handled and allows only single
request at time, there is no such problematic race cases.  But, keeping it
as is could stem another subtle race condition bug in future.

Avoid that by cancelling the requests before the ->kdamond reset.  Note
that this change also makes all damon_ctx dependent resource cleanups
consistently done before the damon_ctx->kdamond reset.

Link: https://lkml.kernel.org/r/20260117175256.82826-4-sj@kernel.org
Link: https://lore.kernel.org/20251230014532.47563-1-sj@kernel.org [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-cancel-damos_walk-before-damon_ctx-kdamond-reset
+++ a/mm/damon/core.c
@@ -2856,14 +2856,13 @@ done:
 
 	kfree(ctx->regions_score_histogram);
 	kdamond_call(ctx, true);
+	damos_walk_cancel(ctx);
 
 	pr_debug("kdamond (%d) finishes\n", current->pid);
 	mutex_lock(&ctx->kdamond_lock);
 	ctx->kdamond = NULL;
 	mutex_unlock(&ctx->kdamond_lock);
 
-	damos_walk_cancel(ctx);
-
 	mutex_lock(&damon_lock);
 	nr_running_ctxs--;
 	if (!nr_running_ctxs && running_exclusive_ctxs)
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

