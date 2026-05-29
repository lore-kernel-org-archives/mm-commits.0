Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9098370AFB
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027682; cv=none; b=GPXcFF8R0gCJTANvG5WZ6mt4gf4l2iml62Xtgv0TU19oMsnZu4moAU3gSQSQza0wwJl0CpQDTicN7U8gqtCX5weh5pyjWyg7GJGIyZmv2DHgV3UzqQggCX3+8hGYg35ooVio3rO4gWX4xk0I48D5tM74ibcOe+WpqW8cjA0gKMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027682; c=relaxed/simple;
	bh=Rg7rykGC6M8iRH3N3skczlXxLNLS0j+hJxeDkXATzaQ=;
	h=Date:To:From:Subject:Message-Id; b=V5OB10pg5jhECpNivtDdttFheJndt/6TGKUThCSWzMi5D6m32sutXwFoWJIPhLqrDY+0Wed2vbPPJv1SjdD/ZUHPRcxrMg5tSsUO8JclZoVQacXTQwVTudXXWAJfpmTJPwWUY1AH2wUA4nwRjPSGmBIcbI4uzoSuBPgNRv14qPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FPWtOssc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FPWtOssc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB98A1F00898;
	Fri, 29 May 2026 04:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027680;
	bh=WLNtNZo/kJ8Mfk8akVAem4+KdmnOUev7Nx9IGzrF7rk=;
	h=Date:To:From:Subject;
	b=FPWtOssc5EPruv5jf7VmP+Gu6yU5hoLj9+b4ueO4hmOJ2TvFBcNH+/EEcPxhUlEnr
	 zpZwwacNlajF7BGvf3IX3mUNOjx4vn5wu4wwsp1ukBOsdxuJFOZpTSZs+LUViwshZh
	 QL+6AGSgJpXO/+OHlBdrwq9U+6BHZj6Yku1dl3gA=
Date: Thu, 28 May 2026 21:08:00 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-stat-use-damon_set_region_system_rams_default.patch removed from -mm tree
Message-Id: <20260529040800.BB98A1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/stat: use damon_set_region_system_rams_default()
has been removed from the -mm tree.  Its filename was
     mm-damon-stat-use-damon_set_region_system_rams_default.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-ops-common-call-folio_test_lru-after-folio_get.patch
mm-damon-reclaim-handle-ctx-allocation-failure.patch
mm-damonn-lru_sort-handle-ctx-allocation-failure.patch
mm-damon-core-introduce-struct-damon_probe.patch
mm-damon-core-embed-damon_probe-objects-in-damon_ctx.patch
mm-damon-core-introduce-damon_filter.patch
mm-damon-core-commit-probes.patch
mm-damon-core-introduce-damon_region-probe_hits.patch
mm-damon-core-introduce-damon_ops-apply_probes.patch
mm-damon-core-do-data-attributes-monitoring.patch
mm-damon-paddr-support-data-attributes-monitoring.patch
mm-damon-sysfs-implement-probes-dir.patch
mm-damon-sysfs-implement-probe-dir.patch
mm-damon-sysfs-implement-filters-directory.patch
mm-damon-sysfs-implement-filter-dir.patch
mm-damon-sysfs-implement-filter-dir-files.patch
mm-damon-sysfs-setup-probes-on-damon-core-api-parameters.patch
mm-damon-sysfs-schemes-implement-tried_regions-r-probes.patch
mm-damon-sysfs-schemes-implement-probe-dir.patch
mm-damon-sysfs-schemes-implement-probe-hits-file.patch
mm-damon-trace-probe_hits.patch
selftests-damon-sysfssh-test-probes-dir.patch
docs-mm-damon-design-document-data-attributes-monitoring.patch
docs-admin-guide-mm-damon-usage-document-data-attributes-monitoring.patch
mm-damon-core-introduce-damon_filter_type_memcg.patch
mm-damon-paddr-support-damon_filter_type_memcg.patch
mm-damon-sysfs-add-filters-f-path-file.patch
mm-damon-sysfs-schemes-move-memcg_path_to_id-to-sysfs-common.patch
mm-damon-sysfs-setup-damon_filter-memcg_id-from-path.patch
docs-mm-damon-design-update-for-memcg-damon-filter.patch
docs-admin-guide-mm-damon-usage-update-for-memcg-damon-filter.patch
mm-damon-core-safely-handle-no-region-case-in-damon_set_regions.patch
mm-damon-core-do-not-use-region-out-of-a-loop-in-damon_set_regions.patch
samples-damon-mtier-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-tests-vaddr-kunit-replace-damon_add_region-with-damon_set_regions.patch
mm-damon-core-hide-damon_add_region.patch
mm-damon-core-hide-damon_insert_region.patch
mm-damon-core-hide-damon_destroy_region.patch
mm-damon-core-add-kdamond_call-debug_sanity-check.patch
mm-damon-core-remove-damon_verify_nr_regions.patch
mm-damon-tests-core-kunit-add-damon_set_regions-test-cases.patch
selftests-damon-sysfspy-stop-kdamonds-before-failing.patch
selftests-damon-sysfssh-test-monitoring-intervals-goal-dir.patch
selftests-damon-sysfssh-test-addr_unit-file-existence.patch
selftests-damon-sysfssh-test-pause-file-existence.patch
mm-damon-core-trace-esz-at-first-setup.patch

