Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702FF30276A
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 20:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773262295; cv=none; b=r/iKVylCJB0/XKQtj7yXXE9Avd0aLTER/L+StWFI+wGyYOHxqEAhBHYRDiW5Pz4FdDstEbpuuoHbqBL3uMGc3/atV/+SYihJAR+36UOLCSxi6j/m1ZGDxQeimllBGRery0KOCmbSL0UAqEvi74Zqemok5p5cs6BbAs0M59W4/J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773262295; c=relaxed/simple;
	bh=ud1JUagPu/KrXvke15i/lthPqQq/UMdXdZRc1OHdQ8w=;
	h=Date:To:From:Subject:Message-Id; b=TGxVIU5/6zJiO1uOmWpqi94maeVppzcXi4eqDgGmp25ec2Z0D8VnRHjqDMKDjAI8arS3UPkTWFxmSqaVg3kJKRvc4nzUbZpHO5dH6uofzdi4InS5/RggQq1Q2O/5xOLx3SUfPGA9IKVKIGAoI/W8uValaA5+E7n+obrEwlH9TkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OuzkimWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OuzkimWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EB9C4CEF7;
	Wed, 11 Mar 2026 20:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773262295;
	bh=ud1JUagPu/KrXvke15i/lthPqQq/UMdXdZRc1OHdQ8w=;
	h=Date:To:From:Subject:From;
	b=OuzkimWKzb0lmGFysIYbvlX6D6+135JNZWfcoEcmIppVWrW2vPAzQMam7SL+vFmwl
	 35EdP24xHqK20GO+piBDXY8dFcuM4LG83wVAY81EUCKMW51aGfar1pqK0VX+YmZsDp
	 Au3ikJrbXl+DTE2HacOvi7atyr1k18zaTaz7RycM=
Date: Wed, 11 Mar 2026 13:51:34 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch added to mm-new branch
Message-Id: <20260311205135.02EB9C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: support addr_unit on damon_find_biggest_system_ram()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch

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
Subject: mm/damon/core: support addr_unit on damon_find_biggest_system_ram()
Date: Tue, 10 Mar 2026 22:29:23 -0700

damon_find_biggest_system_ram() sets an 'unsigned long' variable with
'resource_size_t' value.  This is fundamentally wrong.  On environments
such as ARM 32 bit machines having LPAE (Large Physical Address
Extensions), which DAMON supports, the size of 'unsigned long' may be
smaller than that of 'resource_size_t'.  It is safe, though, since we
restrict the walk to be done only up to ULONG_MAX.

DAMON supports the address size gap using 'addr_unit'.  We didn't add the
support to the function, just to make the initial support change small. 
Now the support is reasonably settled.  This kind of gap is only making
the code inconsistent and easy to be confused.  Add the support of
'addr_unit' to the function, by letting callers pass the 'addr_unit' and
handling it in the function.  All callers are passing 'addr_unit' 1,
though, to keep the old behavior.

Link: https://lkml.kernel.org/r/20260311052927.93921-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram
+++ a/mm/damon/core.c
@@ -3056,31 +3056,44 @@ done:
 
 static int walk_system_ram(struct resource *res, void *arg)
 {
-	struct damon_addr_range *a = arg;
+	struct resource *a = arg;
 
-	if (a->end - a->start < resource_size(res)) {
+	if (resource_size(a) < resource_size(res)) {
 		a->start = res->start;
-		a->end = res->end + 1;
+		a->end = res->end;
 	}
 	return 0;
 }
 
+static unsigned long damon_res_to_core_addr(resource_size_t ra,
+		unsigned long addr_unit)
+{
+	/*
+	 * Use div_u64() for avoiding linking errors related with __udivdi3,
+	 * __aeabi_uldivmod, or similar problems.  This should also improve the
+	 * performance optimization (read div_u64() comment for the detail).
+	 */
+	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
+		return div_u64(ra, addr_unit);
+	return ra / addr_unit;
+}
+
 /*
  * Find biggest 'System RAM' resource and store its start and end address in
  * @start and @end, respectively.  If no System RAM is found, returns false.
  */
 static bool damon_find_biggest_system_ram(unsigned long *start,
-						unsigned long *end)
+		unsigned long *end, unsigned long addr_unit)
 
 {
-	struct damon_addr_range arg = {};
+	struct resource res = {};
 
-	walk_system_ram_res(0, ULONG_MAX, &arg, walk_system_ram);
-	if (arg.end <= arg.start)
+	walk_system_ram_res(0, -1, &res, walk_system_ram);
+	if (res.end < res.start)
 		return false;
 
-	*start = arg.start;
-	*end = arg.end;
+	*start = damon_res_to_core_addr(res.start, addr_unit);
+	*end = damon_res_to_core_addr(res.end + 1, addr_unit);
 	return true;
 }
 
@@ -3110,7 +3123,7 @@ int damon_set_region_biggest_system_ram_
 		return -EINVAL;
 
 	if (!*start && !*end &&
-		!damon_find_biggest_system_ram(start, end))
+		!damon_find_biggest_system_ram(start, end, 1))
 		return -EINVAL;
 
 	addr_range.start = *start;
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

