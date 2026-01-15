Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC99F321426
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 23:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768518606; cv=none; b=DV/aCrOvNp5hUEO2ZjSSTKxu7T7YkoQkL/Q9X21Bu0Xs21/pO50t+S5chmhg1gAjm3Yv/0nayG7+F/tVFpjoE+qNMVitoT5zFTeNptA5raSUeItv/8eowijqQoD3tWJu2G+fO/XwdiIdLT94ZVpgjLQMLbioLRSDm5VejiCHlBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768518606; c=relaxed/simple;
	bh=J3qRC56Eo37dvsHlYjVLW6QAnAqJHe8/9KzAw/Afkr0=;
	h=Date:To:From:Subject:Message-Id; b=sZuBByDY+6+YBWRFsvXnTSvdlUc4Xqk7tirAvmeua4gPrID1GJT/CiGpsDbdN0geInfXO3JQRNU05+SscUDEulCkyx1pgp4J6gu5dSw3omwUppDpEleS9GZ2yRh5Quh+9NKN+CbIahNnofN1LY7qiaZj28I/PmuF87QkyLcDeYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gFsB2p9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gFsB2p9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59303C116D0;
	Thu, 15 Jan 2026 23:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768518605;
	bh=J3qRC56Eo37dvsHlYjVLW6QAnAqJHe8/9KzAw/Afkr0=;
	h=Date:To:From:Subject:From;
	b=gFsB2p9Ex1snduxt08sNw5MKtsSdXL7M8x0GyVZlUAMMWso3kT5zdkdXSziHs57N+
	 s4d5kpH1zhTOlapYGqwvkGmLO1yy3+3+fpTQyB6mfGJk85d2q928gwV25KY7uJ9Vgn
	 JBufWvdDSn8HsxeSYIMNAKKkUGtmKaCP5GLGd53I=
Date: Thu, 15 Jan 2026 15:10:04 -0800
To: mm-commits@vger.kernel.org,clm@meta.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch added to mm-unstable branch
Message-Id: <20260115231005.59303C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix wrong list_is_last() call in damons_is_last_region()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-nr_snapshots-damos-stat-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/core: fix wrong list_is_last() call in damons_is_last_region()
Date: Wed, 14 Jan 2026 06:57:38 -0800

damon_is_last_region() is calling list_is_last() with swapped arguments. 
As a result, it works like damon_is_first_region().  Not that this is not
making user-visible impact, because the function is only used to increment
nr_snapshots stat once per DAMOS' regions iteration, and the stat is
exposed users only after the iteration is completed.  That's why it passed
a user space test.  Nonetheless, the bug is a bug and could cause real
user issues in future.  Fix it by correcting the order of arguments for
list_lis_last().

Link: https://lkml.kernel.org/r/20260114152049.99727-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lore.kernel.org/20260114122959.1164957-1-clm@meta.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-introduce-nr_snapshots-damos-stat-fix
+++ a/mm/damon/core.c
@@ -160,7 +160,7 @@ void damon_destroy_region(struct damon_r
 static bool damon_is_last_region(struct damon_region *r,
 		struct damon_target *t)
 {
-	return list_is_last(&t->regions_list, &r->list);
+	return list_is_last(&r->list, &t->regions_list);
 }
 
 /*
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
docs-admin-guide-mm-damon-lru_sort-document-active_mem_bp-parameter.patch
mm-damon-lru_sort-add-monitoring-intervals-auto-tuning-parameter.patch
docs-admin-guide-mm-damon-lru_sort-document-intervals-autotuning.patch
mm-damon-core-implement-damon_kdamond_pid.patch
mm-damon-sysfs-use-damon_kdamond_pid.patch
mm-damon-lru_sort-use-damon_kdamond_pid.patch
mm-damon-reclaim-use-damon_kdamond_pid.patch
mm-damon-hide-kdamond-and-kdamond_lock-of-damon_ctx.patch

