Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00AD35972;
	Mon,  1 Jun 2026 04:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780289461; cv=none; b=lyjGtIYMxEzVgITg0YfWKkyXzwKnxWj1b/xZLdOsOx4Z2FDoGQeqqN5N950X/BpnfYs8B3uQK1roxu2Uc4oYBMJ6csz/QZst6Y1CgCEpueeq0lESoBmvqQQ/f7L15dYxfwxBRI76X+hZf/4KDV8Z5tGsioxo4rgT9+UQHCnXee8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780289461; c=relaxed/simple;
	bh=2y4fRYDGb/Dwxgb6zfHjIGEwKRMNfxQmgpNG9iDW77s=;
	h=Date:To:From:Subject:Message-Id; b=FTibjy26T3eRL9nms+eh0PGl+tcRo84g2NV0smDnGtPB4516MTK7WN6WSAVqLt/SO2WSQ4eJliIu0adC/m2nzWS+oEgz1DeCtFdMRUC74CapKJHinfo+2cfgywBhu8iBEsz0axZb57XFTduOK48PMJ64CY3N6FIZF/aq2jF/mm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cOOiaLYv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cOOiaLYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CF81F00893;
	Mon,  1 Jun 2026 04:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780289460;
	bh=Eh38gK8dUr49BVRyQz6LwA+r1Q3JjuCSVPfxoKC8hbo=;
	h=Date:To:From:Subject;
	b=cOOiaLYvDrIG4pxMsUfWvuBamWFEA5RMxTcC0azFoQ6T5BeGQEDYHBzrA/SNMHG9+
	 WB+XhNk0RaKYtAQfAMOoe3WhG0B2KRiijcMN9yK+RieBlRZyrfhZOzu+cWlVnHVZVo
	 Adz5X3sQTGo33xoB4G3go49V1Ic/a2rS5zCCoEog=
Date: Sun, 31 May 2026 21:50:59 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sieberf@amazon.com,shakeel.butt@linux.dev,foersleo@amazon.de,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-ops-common-call-folio_test_lru-after-folio_get.patch removed from -mm tree
Message-Id: <20260601045100.01CF81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/ops-common: call folio_test_lru() after folio_get()
has been removed from the -mm tree.  Its filename was
     mm-damon-ops-common-call-folio_test_lru-after-folio_get.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/ops-common: call folio_test_lru() after folio_get()
Date: Mon, 25 May 2026 09:22:55 -0700

damon_get_folio() speculatively calls folio_test_lru() before
folio_try_get().  The folio can get freed and reallocated to a tail page. 
In the case, VM_BUG_ON_PGFLAGS() in const_folio_flags() can be triggered. 
Remove the speculative call.

Also mark folio_test_lru() check right after folio_try_get() success as no
more unlikely.

The race should be rare.  Also the problem can happen only if the kernel
has enabled CONFIG_DEBUG_VM_PGFLAGS.  No real world report of this issue
has been made so far.  This fix is based on only theoretical analysis. 
That said, a bug is a bug.  A similar issue was also fixed via commit
3203b3ab0fcf ("mm/filemap: don't call folio_test_locked() without a
reference in next_uptodate_folio()").  I don't expect this change will
make a meaningful impact to DAMON performance in the real world, though I
will be happy to be corrected from the real world reports.

The issue was discovered [1] by Sashiko.


Link: https://lore.kernel.org/20260525162256.8317-1-sj@kernel.org
Link: https://lore.kernel.org/20260517234112.89245-1-sj@kernel.org [1]
Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Fernand Sieber <sieberf@amazon.com>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-call-folio_test_lru-after-folio_get
+++ a/mm/damon/ops-common.c
@@ -32,9 +32,9 @@ struct folio *damon_get_folio(unsigned l
 		return NULL;
 
 	folio = page_folio(page);
-	if (!folio_test_lru(folio) || !folio_try_get(folio))
+	if (!folio_try_get(folio))
 		return NULL;
-	if (unlikely(page_folio(page) != folio || !folio_test_lru(folio))) {
+	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
 		folio_put(folio);
 		folio = NULL;
 	}
_

Patches currently in -mm which might be from sj@kernel.org are

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

