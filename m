Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3ED0500973
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 00:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768696779; cv=none; b=Ih8hO3aSlSm5+a1qd2Olw3R2CNxqX2M5FirJKLyeJpeH6uOazxxgJ9sB6sT4dQz4KAeVRggi7D8yQvIocKtcPTVUg1qTpd/Dznh9wApjGwOu82GYmemqRFeh+4hN0PwhpK+KrJnU1rxNYMk064U77Zml3B7sspccPA5Kbum65XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768696779; c=relaxed/simple;
	bh=MxtzYxF8vcnclNA8Qf/u3bJysCkmq9UUVdWcCOKgRNM=;
	h=Date:To:From:Subject:Message-Id; b=oAjnU4L8DV/Q8vveX20OB4Oek8+idFWF6G7O9/5z4duBOJbSSZ2YBWEPomSXbCfsw7w4mdRUb9rioGrVTXCrGXPfalRRtsmluTT6L40muMi0u81X1jfWX0GX7mmRtCr158HmbV7osGJtR5IkHR3UpDMR7RI/YWFaCtFYkVdidck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kIU4AD+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kIU4AD+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2479FC4CEF7;
	Sun, 18 Jan 2026 00:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768696779;
	bh=MxtzYxF8vcnclNA8Qf/u3bJysCkmq9UUVdWcCOKgRNM=;
	h=Date:To:From:Subject:From;
	b=kIU4AD+lF1bz7w4pNbkFC0iVupO7R8DK1aVeuww81fJHphlET6Vqa4yxV1/7jcHAm
	 X6V63KZ7i67QaIqhFEPQufW4wSLOU1yiL2DhKZJHDgflHtAWfShcvydrbjl3BJE70V
	 YsnbSs31RDeEf/9O6ndxpw+8M9mBuMTJQc4G9DrE=
Date: Sat, 17 Jan 2026 16:39:38 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-damon_operations-cleanup.patch added to mm-new branch
Message-Id: <20260118003939.2479FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: remove damon_operations->cleanup()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-remove-damon_operations-cleanup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-damon_operations-cleanup.patch

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
Subject: mm/damon: remove damon_operations->cleanup()
Date: Sat, 17 Jan 2026 09:52:48 -0800

Patch series "mm/damon: cleanup kdamond, damon_call(), damos filter and
DAMON_MIN_REGION".

Do miscellaneous code cleanups for improving readability.  First three
patches cleanup kdamond termination process, by removing unused operation
set cleanup callback (patch 1) and moving damon_ctx specific resource
cleanups on kdamond termination to synchronization-easy place (patches 2
and 3).  Next two patches touch damon_call() infrastructure, by
refactoring kdamond_call() function to do less and simpler locking
operations (patch 4), and documenting when dealloc_on_free does work
(patch 5).  Final three patches rename things for clear uses of those. 
Those rename damos_filter_out() to be more explicit about the fact that it
is only for core-handled filters (patch 6), DAMON_MIN_REGION macro to be
more explicit it is not about number of regions but size of each region
(patch 7), and damon_ctx->min_sz_region to be different from
damos_access_patern->min_sz_region (patch 8), so that those are not
confusing and easy to grep.


This patch (of 8):

damon_operations->cleanup() was added for a case that an operation set
implementation requires additional cleanups.  But no such implementation
exists at the moment.  Remove it.

Link: https://lkml.kernel.org/r/20260117175256.82826-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260117175256.82826-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 ---
 mm/damon/core.c       |    2 --
 mm/damon/paddr.c      |    1 -
 mm/damon/vaddr.c      |    1 -
 4 files changed, 7 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-damon_operations-cleanup
+++ a/include/linux/damon.h
@@ -607,7 +607,6 @@ enum damon_ops_id {
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
  * @cleanup_target:		Clean up each target before deallocation.
- * @cleanup:			Clean up the context.
  *
  * DAMON can be extended for various address spaces and usages.  For this,
  * users should register the low level operations for their target address
@@ -640,7 +639,6 @@ enum damon_ops_id {
  * @target_valid should check whether the target is still valid for the
  * monitoring.
  * @cleanup_target is called before the target will be deallocated.
- * @cleanup is called from @kdamond just before its termination.
  */
 struct damon_operations {
 	enum damon_ops_id id;
@@ -656,7 +654,6 @@ struct damon_operations {
 			struct damos *scheme, unsigned long *sz_filter_passed);
 	bool (*target_valid)(struct damon_target *t);
 	void (*cleanup_target)(struct damon_target *t);
-	void (*cleanup)(struct damon_ctx *context);
 };
 
 /*
--- a/mm/damon/core.c~mm-damon-remove-damon_operations-cleanup
+++ a/mm/damon/core.c
@@ -2859,8 +2859,6 @@ done:
 			damon_destroy_region(r, t);
 	}
 
-	if (ctx->ops.cleanup)
-		ctx->ops.cleanup(ctx);
 	kfree(ctx->regions_score_histogram);
 	kdamond_call(ctx, true);
 
--- a/mm/damon/paddr.c~mm-damon-remove-damon_operations-cleanup
+++ a/mm/damon/paddr.c
@@ -373,7 +373,6 @@ static int __init damon_pa_initcall(void
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
 		.target_valid = NULL,
-		.cleanup = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
 		.get_scheme_score = damon_pa_scheme_score,
 	};
--- a/mm/damon/vaddr.c~mm-damon-remove-damon_operations-cleanup
+++ a/mm/damon/vaddr.c
@@ -1014,7 +1014,6 @@ static int __init damon_va_initcall(void
 		.check_accesses = damon_va_check_accesses,
 		.target_valid = damon_va_target_valid,
 		.cleanup_target = damon_va_cleanup_target,
-		.cleanup = NULL,
 		.apply_scheme = damon_va_apply_scheme,
 		.get_scheme_score = damon_va_scheme_score,
 	};
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

