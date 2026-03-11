Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8AD3148D3
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 20:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773262297; cv=none; b=hXaA3gznzzZU1lqVurKj8t1j+7tnayU0CUcPQdgql/yXL8CUlYvXs8OAKABWLz0QqL5NU/22dRVFQ3x+jLZbOBT1NNrdSUh/FBNfnJMBA/WXeJDDRLdvLz4cWvFPtkO1qf2RJCUZY8z9tbpfKRSEXvpGrXcVDuxabumZwyTNITI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773262297; c=relaxed/simple;
	bh=TyNmtew6DOLS+HdmFJ3uXKfD0ing3eju21b//xdIsig=;
	h=Date:To:From:Subject:Message-Id; b=mIugJtynmbzGkIycZ/U2qe7lGf/vxDHmoJc59vidUVsIWXqml6S8CkLwTKlptOCFkpzMdJlh8JIwZZyJHYdjnaDodnQc2dalCpfMg5wXRz9g4N4fDXGT37B3ZEpUybqDfzTW9GUVpRZBIx5xjWKzvOQQFHEr2LboVGZnKLx4Jps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nWE5s4wa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nWE5s4wa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0C6C4CEF7;
	Wed, 11 Mar 2026 20:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773262296;
	bh=TyNmtew6DOLS+HdmFJ3uXKfD0ing3eju21b//xdIsig=;
	h=Date:To:From:Subject:From;
	b=nWE5s4waphR4A+zsdBrFyiOlRK0DZIqYhly1/T3xjkPrpa0GtHXIIVrytpz7bAyg+
	 AOpQERlZ5QHL6MFopvmM6qmnIh2RmU7Wbwfzac23KXJy1Jh1tKbWAZLx55Z+xvxEtD
	 dumWI7uIjH9q0y4Al7SWf13y0cvrw9xsGxbteTg8=
Date: Wed, 11 Mar 2026 13:51:35 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch added to mm-new branch
Message-Id: <20260311205136.7F0C6C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: receive addr_unit on damon_set_region_biggest_system_ram_default()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm/damon/core: receive addr_unit on damon_set_region_biggest_system_ram_default()
Date: Tue, 10 Mar 2026 22:29:24 -0700

damon_find_biggest_system_ram() was not supporting addr_unit in the past. 
Hence, its caller, damon_set_region_biggest_system_ram_default(), was also
not supporting addr_unit.  The previous commit has updated the inner
function to support addr_unit.  There is no more reason to not support
addr_unit on damon_set_region_biggest_system_ram_default().  Rather, it
makes unnecessary inconsistency on support of addr_unit.  Update it to
receive addr_unit and handle it inside.

Link: https://lkml.kernel.org/r/20260311052927.93921-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 mm/damon/core.c       |    7 ++++---
 mm/damon/lru_sort.c   |    1 +
 mm/damon/reclaim.c    |    1 +
 mm/damon/stat.c       |    2 +-
 5 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default
+++ a/include/linux/damon.h
@@ -988,6 +988,7 @@ int damos_walk(struct damon_ctx *ctx, st
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
+				unsigned long addr_unit,
 				unsigned long min_region_sz);
 
 #endif	/* CONFIG_DAMON */
--- a/mm/damon/core.c~mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/core.c
@@ -3103,6 +3103,7 @@ static bool damon_find_biggest_system_ra
  * @t:		The monitoring target to set the region.
  * @start:	The pointer to the start address of the region.
  * @end:	The pointer to the end address of the region.
+ * @addr_unit:	The address unit for the damon_ctx of @t.
  * @min_region_sz:	Minimum region size.
  *
  * This function sets the region of @t as requested by @start and @end.  If the
@@ -3115,7 +3116,7 @@ static bool damon_find_biggest_system_ra
  */
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 			unsigned long *start, unsigned long *end,
-			unsigned long min_region_sz)
+			unsigned long addr_unit, unsigned long min_region_sz)
 {
 	struct damon_addr_range addr_range;
 
@@ -3123,12 +3124,12 @@ int damon_set_region_biggest_system_ram_
 		return -EINVAL;
 
 	if (!*start && !*end &&
-		!damon_find_biggest_system_ram(start, end, 1))
+			!damon_find_biggest_system_ram(start, end, addr_unit))
 		return -EINVAL;
 
 	addr_range.start = *start;
 	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, 1, min_region_sz);
+	return damon_set_regions(t, &addr_range, addr_unit, min_region_sz);
 }
 
 /*
--- a/mm/damon/lru_sort.c~mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/lru_sort.c
@@ -345,6 +345,7 @@ static int damon_lru_sort_apply_paramete
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
+					param_ctx->addr_unit,
 					param_ctx->min_region_sz);
 	if (err)
 		goto out;
--- a/mm/damon/reclaim.c~mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/reclaim.c
@@ -251,6 +251,7 @@ static int damon_reclaim_apply_parameter
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
+					param_ctx->addr_unit,
 					param_ctx->min_region_sz);
 	if (err)
 		goto out;
--- a/mm/damon/stat.c~mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/stat.c
@@ -181,7 +181,7 @@ static struct damon_ctx *damon_stat_buil
 		goto free_out;
 	damon_add_target(ctx, target);
 	if (damon_set_region_biggest_system_ram_default(target, &start, &end,
-							ctx->min_region_sz))
+				ctx->addr_unit, ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch
mm-damon-core-introduce-damos_quota_goal_tuner.patch
mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch
mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch
mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file.patch
docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch
docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file.patch
docs-abi-damon-update-for-goal_tuner.patch
mm-damon-tests-core-kunit-test-goal_tuner-commit.patch
selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch
selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping.patch
selftests-damon-sysfspy-test-goal_tuner-commit.patch
mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch
mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch
mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch

