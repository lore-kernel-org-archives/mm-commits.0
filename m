Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D133FB05D
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 12:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777467128; cv=none; b=eNroaJbcIADa6soYDZOqJKRop+SEstxuOy3JKWhH2ZFt+T4CeIT7Y1EDMNsu/IWvCn9UizqEtjm7yKdgUyjPYgQNdexlSWTtrY0IPvdl68XZhfRwvjF3kYx+HOwIzyo7iSnem48gsKaBuXIY5xnHBkOo23RIJ+i3dKkSLGEu6TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777467128; c=relaxed/simple;
	bh=AJoXGHuDuPme7BkPHFH3x70Bo2YCq8xglUYEA72HTlQ=;
	h=Date:To:From:Subject:Message-Id; b=C9eNP/XrFmhqYiLPCeIDTFod+vndIYlDM2Lt7kIr8iDDe2ya1AilwOmcWF+lUPy2mdnxA0KJIgiB5kmaxFolkniyrCQy0ZKnH6OPW+7Cy5EysXimiH4gJxYNQHiIzQ1FRpK5hQU+6NRgJC5OOKthxML3b5Pkx3860QXRLJ20S6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R8FLRFIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R8FLRFIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F115C2BCC9;
	Wed, 29 Apr 2026 12:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777467127;
	bh=AJoXGHuDuPme7BkPHFH3x70Bo2YCq8xglUYEA72HTlQ=;
	h=Date:To:From:Subject:From;
	b=R8FLRFIOkeEqWLM0qGxk1TMx33QTgiyB31DwToRXn21pucDr1u4sisUNZFQQTveX3
	 PXg3i//gmUKPfhFuYDtIvMCPtTCZ9uxYNedBHqmxWm3O83Mk+DxeIzAPh6iAi9HSc9
	 6YzoGmJKjGOST6yGW+QrBkEndiIUXUdG5W8GrRfs=
Date: Wed, 29 Apr 2026 05:52:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-stat-use-damon_set_region_system_rams_default.patch added to mm-new branch
Message-Id: <20260429125207.8F115C2BCC9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/stat: use damon_set_region_system_rams_default()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-stat-use-damon_set_region_system_rams_default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-stat-use-damon_set_region_system_rams_default.patch

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
Subject: mm/damon/stat: use damon_set_region_system_rams_default()
Date: Tue, 28 Apr 2026 21:12:27 -0700

damon_stat_set_moniotirng_region() is nearly a duplicate of the core
function, damon_set_region_system_rams_default().  Use the core
implementation.

Link: https://lore.kernel.org/20260429041232.90257-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/stat.c |   53 ++--------------------------------------------
 1 file changed, 3 insertions(+), 50 deletions(-)

--- a/mm/damon/stat.c~mm-damon-stat-use-damon_set_region_system_rams_default
+++ a/mm/damon/stat.c
@@ -148,59 +148,12 @@ static int damon_stat_damon_call_fn(void
 	return 0;
 }
 
-struct damon_stat_system_ram_range_walk_arg {
-	bool walked;
-	struct resource res;
-};
-
-static int damon_stat_system_ram_walk_fn(struct resource *res, void *arg)
-{
-	struct damon_stat_system_ram_range_walk_arg *a = arg;
-
-	if (!a->walked) {
-		a->walked = true;
-		a->res.start = res->start;
-	}
-	a->res.end = res->end;
-	return 0;
-}
-
-static unsigned long damon_stat_res_to_core_addr(resource_size_t ra,
-		unsigned long addr_unit)
-{
-	/*
-	 * Use div_u64() for avoiding linking errors related with __udivdi3,
-	 * __aeabi_uldivmod, or similar problems.  This should also improve the
-	 * performance optimization (read div_u64() comment for the detail).
-	 */
-	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
-		return div_u64(ra, addr_unit);
-	return ra / addr_unit;
-}
-
-static int damon_stat_set_monitoring_region(struct damon_target *t,
-		unsigned long addr_unit, unsigned long min_region_sz)
-{
-	struct damon_addr_range addr_range;
-	struct damon_stat_system_ram_range_walk_arg arg = {};
-
-	walk_system_ram_res(0, -1, &arg, damon_stat_system_ram_walk_fn);
-	if (!arg.walked)
-		return -EINVAL;
-	addr_range.start = damon_stat_res_to_core_addr(
-			arg.res.start, addr_unit);
-	addr_range.end = damon_stat_res_to_core_addr(
-			arg.res.end + 1, addr_unit);
-	if (addr_range.end <= addr_range.start)
-		return -EINVAL;
-	return damon_set_regions(t, &addr_range, 1, min_region_sz);
-}
-
 static struct damon_ctx *damon_stat_build_ctx(void)
 {
 	struct damon_ctx *ctx;
 	struct damon_attrs attrs;
 	struct damon_target *target;
+	unsigned long start = 0, end = 0;
 
 	ctx = damon_new_ctx();
 	if (!ctx)
@@ -230,8 +183,8 @@ static struct damon_ctx *damon_stat_buil
 	if (!target)
 		goto free_out;
 	damon_add_target(ctx, target);
-	if (damon_stat_set_monitoring_region(target, ctx->addr_unit,
-				ctx->min_region_sz))
+	if (damon_set_region_system_rams_default(target, &start, &end,
+				ctx->addr_unit, ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch
mm-damon-core-introduce-damon_ctx-paused.patch
mm-damon-sysfs-add-pause-file-under-context-dir.patch
docs-mm-damon-design-update-for-context-pause-resume-feature.patch
docs-admin-guide-mm-damon-usage-update-for-pause-file.patch
docs-abi-damon-update-for-pause-sysfs-file.patch
mm-damon-tests-core-kunit-test-pause-commitment.patch
selftests-damon-_damon_sysfs-support-pause-file-staging.patch
selftests-damon-drgn_dump_damon_status-dump-pause.patch
selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch
selftests-damon-sysfspy-pause-damon-before-dumping-status.patch
mm-damon-introduce-damon_set_region_system_rams_default.patch
mm-damon-reclaim-cover-all-system-rams.patch
mm-damon-lru_sort-cover-all-system-rams.patch
mm-damon-core-remove-damon_set_region_biggest_system_ram_default.patch
mm-damon-stat-use-damon_set_region_system_rams_default.patch
docs-admin-guide-mm-damon-reclaim-update-for-entire-memory-monitoring.patch
docs-admin-guide-mm-damon-lru_sort-update-for-entire-memory-monitoring.patch

