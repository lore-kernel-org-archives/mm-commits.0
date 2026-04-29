Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C1F3F7AA1
	for <mm-commits@vger.kernel.org>; Wed, 29 Apr 2026 12:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777467125; cv=none; b=KLWoQSYeOrZ8f6ZwglocMK5yAHGX+H9CziQcRWrWk/e3HpZOH1BJU/pZgWMJGtT+LjN0g5BaHg6DqQJiSMa26NuwLFuctcSwp/4s9KDPPGoXNq+T0aPXWYYZDYxX1wF0tXmAzz5rhidFdSBu1ooHrXT1yaWFKRjSXyFMiTsb4ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777467125; c=relaxed/simple;
	bh=EYGrUSK8NuYqQl2dDdcLJgEiDsX4Rc7y11IDXCQFW98=;
	h=Date:To:From:Subject:Message-Id; b=mB5lE55sw+4I7d8tq/2YfcDlsXCGYMYZiOiovD1Vu457d5KL7XgORtwYIavvM6epaD3+YiSEW425WrLzC5KQxPT063oQV04UwBmgoafpG3h4x/RvVLF/ttPH19LgLgWKFg5oPH6IZ44DYq7iBQFXk0NGCJeIGpcqE5StO66sxGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xbjd7skA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xbjd7skA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA20C19425;
	Wed, 29 Apr 2026 12:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777467125;
	bh=EYGrUSK8NuYqQl2dDdcLJgEiDsX4Rc7y11IDXCQFW98=;
	h=Date:To:From:Subject:From;
	b=Xbjd7skAfXGMrbI4+4LrDYagxRunwVkrGAPtWjCxX0svBBxxMyU5t7HGqqBavMg7Y
	 obqyywofH+xJpRa/lKGnxBBQkpC1EEaUKSDyZ5HBodsBlzfgdvtBuAZ/0guDQnqUxG
	 zbyUU5Ii8bV7k5d8QCBQnJ3L9qJG8WO2GrDjuH48=
Date: Wed, 29 Apr 2026 05:52:04 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-remove-damon_set_region_biggest_system_ram_default.patch added to mm-new branch
Message-Id: <20260429125205.1CA20C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: remove damon_set_region_biggest_system_ram_default()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-remove-damon_set_region_biggest_system_ram_default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-remove-damon_set_region_biggest_system_ram_default.patch

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
Subject: mm/damon/core: remove damon_set_region_biggest_system_ram_default()
Date: Tue, 28 Apr 2026 21:12:26 -0700

Now nobody is using damon_set_region_biggest_system_ram_default().  Remove
it.

Link: https://lore.kernel.org/20260429041232.90257-5-sj@kernel.org
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

 include/linux/damon.h |    5 ---
 mm/damon/core.c       |   64 ----------------------------------------
 2 files changed, 69 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-remove-damon_set_region_biggest_system_ram_default
+++ a/include/linux/damon.h
@@ -1003,11 +1003,6 @@ int damon_set_region_system_rams_default
 				unsigned long addr_unit,
 				unsigned long min_region_sz);
 
-int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-				unsigned long *start, unsigned long *end,
-				unsigned long addr_unit,
-				unsigned long min_region_sz);
-
 #endif	/* CONFIG_DAMON */
 
 #endif	/* _DAMON_H */
--- a/mm/damon/core.c~mm-damon-core-remove-damon_set_region_biggest_system_ram_default
+++ a/mm/damon/core.c
@@ -3185,70 +3185,6 @@ int damon_set_region_system_rams_default
 	return damon_set_regions(t, &addr_range, 1, min_region_sz);
 }
 
-static int walk_system_ram(struct resource *res, void *arg)
-{
-	struct resource *a = arg;
-
-	if (resource_size(a) < resource_size(res)) {
-		a->start = res->start;
-		a->end = res->end;
-	}
-	return 0;
-}
-
-/*
- * Find biggest 'System RAM' resource and store its start and end address in
- * @start and @end, respectively.  If no System RAM is found, returns false.
- */
-static bool damon_find_biggest_system_ram(unsigned long *start,
-		unsigned long *end, unsigned long addr_unit)
-
-{
-	struct resource res = {};
-
-	walk_system_ram_res(0, -1, &res, walk_system_ram);
-	*start = damon_res_to_core_addr(res.start, addr_unit);
-	*end = damon_res_to_core_addr(res.end + 1, addr_unit);
-	if (*end <= *start)
-		return false;
-	return true;
-}
-
-/**
- * damon_set_region_biggest_system_ram_default() - Set the region of the given
- * monitoring target as requested, or biggest 'System RAM'.
- * @t:		The monitoring target to set the region.
- * @start:	The pointer to the start address of the region.
- * @end:	The pointer to the end address of the region.
- * @addr_unit:	The address unit for the damon_ctx of @t.
- * @min_region_sz:	Minimum region size.
- *
- * This function sets the region of @t as requested by @start and @end.  If the
- * values of @start and @end are zero, however, this function finds the biggest
- * 'System RAM' resource and sets the region to cover the resource.  In the
- * latter case, this function saves the start and end addresses of the resource
- * in @start and @end, respectively.
- *
- * Return: 0 on success, negative error code otherwise.
- */
-int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-			unsigned long *start, unsigned long *end,
-			unsigned long addr_unit, unsigned long min_region_sz)
-{
-	struct damon_addr_range addr_range;
-
-	if (*start > *end)
-		return -EINVAL;
-
-	if (!*start && !*end &&
-			!damon_find_biggest_system_ram(start, end, addr_unit))
-		return -EINVAL;
-
-	addr_range.start = *start;
-	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, 1, min_region_sz);
-}
-
 /*
  * damon_moving_sum() - Calculate an inferred moving sum value.
  * @mvsum:	Inferred sum of the last @len_window values.
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

