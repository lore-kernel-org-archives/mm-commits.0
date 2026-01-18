Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6F92032D
	for <mm-commits@vger.kernel.org>; Sun, 18 Jan 2026 00:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768696782; cv=none; b=lbpyJuBtVp80c2TIfKyll73hr7jxBJMko89PLZjmb6oNVU9TuqCDb4bWm90KRJSmr+8281WlF0qZl/E9yD0SR4ejRLOlbBcat9bV7yYPy00KKsp3DFchoMG0CQeBU4+r86QbYgmYos1kplsnPfWUZn7m82K8z6RjUz+SBfE0r8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768696782; c=relaxed/simple;
	bh=p/T6wJmEpQYYJpAysSXadmPyiRqomq+GZ7XhRKNw0ms=;
	h=Date:To:From:Subject:Message-Id; b=Yp9neJdEpOz/MOsGWDuFDoOcrdbbXz/chzAi0hvv2T3C+k717GF+DaRLemWLrFw3sj2Pfj0VNlJmRjELSqbQwafjKzhrB09uLdS1IaWaeID/55a5a3uW9P5TB7cD9/RMK9tDsZ9HXlZJvdIZiP/Eb9bDBZeffgiOvQ0482Qb2mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EMjzaC4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EMjzaC4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA4FC4CEF7;
	Sun, 18 Jan 2026 00:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768696782;
	bh=p/T6wJmEpQYYJpAysSXadmPyiRqomq+GZ7XhRKNw0ms=;
	h=Date:To:From:Subject:From;
	b=EMjzaC4yehHKqdnamaXyzQzw+3aTGy3K/l/zD84Fgenz2APXNGljEmFnRQxyhzw64
	 NI2aYLABqeFvXg9AvqeIHHiXPUE5zsfrRUB8sen+FzxO0tZxtLAQCAdigQkphgSG1O
	 8eb5ILLsBHPufM8zB9cEgq+CecjDWDYaoVcrWlZc=
Date: Sat, 17 Jan 2026 16:39:41 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch added to mm-new branch
Message-Id: <20260118003942.6FA4FC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: cleanup targets and regions at once on kdamond termination
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination.patch

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
Subject: mm/damon/core: cleanup targets and regions at once on kdamond termination
Date: Sat, 17 Jan 2026 09:52:49 -0800

When kdamond terminates, it destroys the regions of the context first, and
the targets of the context just before the kdamond main function returns. 
Because regions are linked inside targets, doing them separately is only
inefficient and looks weird.  A more serious problem is that the cleanup
of the targets is done after damon_ctx->kdamond reset, which is the event
that lets DAMON API callers know the kdamond is no longer actively
running.  That is, some DAMON targets could still exist while kdamond is
not running.  There are no real problems from this, but this implicit fact
could cause subtle racy issues in future.  Destroy targets and regions at
one.

Adding contexts on how the code has evolved in the way.  Doing only
regions destruction was because putting pids of the targets were done on
DAMON API callers.  Commit 7114bc5e01cf ("mm/damon/core: add
cleanup_target() ops callback") moved the role to be done via operations
set on each target destruction.  Hence it removed the reason to do only
regions cleanup.  Commit 3a69f1635769 ("mm/damon/core: destroy targets
when kdamond_fn() finish") therefore further destructed targets on kdamond
termination time.  It was still separated from regions destruction because
damon_operations->cleanup() may do additional targets cleanup.  Placing
the targets destruction after damon_ctx->kdamond reset was just an
unnecessary decision of the commit.  The previous commit removed
damon_operations->cleanup(), so there is no more reason to do destructions
of regions and targets separately.

Link: https://lkml.kernel.org/r/20260117175256.82826-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-cleanup-targets-and-regions-at-once-on-kdamond-termination
+++ a/mm/damon/core.c
@@ -2748,8 +2748,6 @@ static void kdamond_init_ctx(struct damo
 static int kdamond_fn(void *data)
 {
 	struct damon_ctx *ctx = data;
-	struct damon_target *t;
-	struct damon_region *r, *next;
 	unsigned int max_nr_accesses = 0;
 	unsigned long sz_limit = 0;
 
@@ -2854,10 +2852,7 @@ static int kdamond_fn(void *data)
 		}
 	}
 done:
-	damon_for_each_target(t, ctx) {
-		damon_for_each_region_safe(r, next, t)
-			damon_destroy_region(r, t);
-	}
+	damon_destroy_targets(ctx);
 
 	kfree(ctx->regions_score_histogram);
 	kdamond_call(ctx, true);
@@ -2875,7 +2870,6 @@ done:
 		running_exclusive_ctxs = false;
 	mutex_unlock(&damon_lock);
 
-	damon_destroy_targets(ctx);
 	return 0;
 }
 
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

