Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767A836EAB9
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027679; cv=none; b=IRltq4qRooKRGe3zot3RkbH6VrXThY8wqEYOH5ygJUWKBr1uc/y+dUszEYynCdIbwQf/kn5Smmt6sVRSPwCabYpNfq2lYD40QbpTZcNNG5EiPx87AH8zmUPjAJOmwT+EeaaoTSGQfVY0Xs63tbH+l14zbpSPHPUznAxJpmARN8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027679; c=relaxed/simple;
	bh=eL6TR/xYvB0X6AzC3YIXQauCHus0odlXlwoDOKZjxSY=;
	h=Date:To:From:Subject:Message-Id; b=u341DQ0pm906f0EsnrLzVoXhtm65ThVhZqaMOHmszN2b2T4xGrZVcWxX9sKaJB/Z6TqosltL5equGPAb8f33W2VDQgH4joh+BROCfhs6p7/aG0j+7HitHKHf5S5EnDNgTSWk4HU5ThkD/GjTgkpH0ZWRu3r3x7CIikjMncUHMsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sPVLFYIJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sPVLFYIJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9696B1F00893;
	Fri, 29 May 2026 04:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780027677;
	bh=m/usZqm3kOz6bPXHVQuUQNE5e1C1vteVyWq4CjtR0NE=;
	h=Date:To:From:Subject;
	b=sPVLFYIJruWZlR4lAh7RMKm0DzwkUBqzwC/g+sYmlVzaRya2vSpuCPnldDEbGSytN
	 hNSg/+QPuaKpOlDtmKQG5lO+zIb9IFweb7geN6zk9PntjbvlJy9iElmURgLhzrMdes
	 N5GemJyP/fT00xLBmIIQHHV+gIDkksCINSXvX7XM=
Date: Thu, 28 May 2026 21:07:55 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-cover-all-system-rams.patch removed from -mm tree
Message-Id: <20260529040756.9696B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/reclaim: cover all system rams
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-cover-all-system-rams.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: cover all system rams
Date: Tue, 28 Apr 2026 21:12:24 -0700

DAMON_RECLAIM allows users to set the physical address range to monitor
and do the work on.  When users don't explicitly set the range, the
biggest System RAM resource of the system is selected as the monitoring
target address range.  The intention was to reduce the overhead from
monitoring non-System RAM areas because monitoring of non-System RAM may
be meaningless.  However, because of the sampling based access check and
adaptive regions adjustment, the overhead should be negligible.  It makes
more sense to just cover all system rams of the system.  Do so.

Link: https://lore.kernel.org/20260429041232.90257-3-sj@kernel.org
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

 mm/damon/reclaim.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-cover-all-system-rams
+++ a/mm/damon/reclaim.c
@@ -113,7 +113,8 @@ DEFINE_DAMON_MODULES_MON_ATTRS_PARAMS(da
  * Start of the target memory region in physical address.
  *
  * The start physical address of memory region that DAMON_RECLAIM will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire physical memory is used as the
+ * region.
  */
 static unsigned long monitor_region_start __read_mostly;
 module_param(monitor_region_start, ulong, 0600);
@@ -122,7 +123,8 @@ module_param(monitor_region_start, ulong
  * End of the target memory region in physical address.
  *
  * The end physical address of memory region that DAMON_RECLAIM will do work
- * against.  By default, biggest System RAM is used as the region.
+ * against.  By default, the system's entire physical memory is used as the
+ * region.
  */
 static unsigned long monitor_region_end __read_mostly;
 module_param(monitor_region_end, ulong, 0600);
@@ -232,11 +234,9 @@ static int damon_reclaim_apply_parameter
 		damos_add_filter(scheme, filter);
 	}
 
-	err = damon_set_region_biggest_system_ram_default(param_target,
-					&monitor_region_start,
-					&monitor_region_end,
-					param_ctx->addr_unit,
-					param_ctx->min_region_sz);
+	err = damon_set_region_system_rams_default(param_target,
+			&monitor_region_start, &monitor_region_end,
+			param_ctx->addr_unit, param_ctx->min_region_sz);
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
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

