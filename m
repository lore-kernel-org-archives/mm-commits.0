Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8E62E7186
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343888; cv=none; b=J10nDXwfFl/x+m93UBQHn/Norcwt5A9jfpqaB7UALgzM4E3m6cseoUuR0OH5ncBjHn7FldN1LigdhQh0VuPaWncE6YLYiib/MIVCnBFWMsPSLzilQZLEmSFUwWhPAlVtRupy3FmEyjB8kRI/oIlrkKkedTVRZylevet2d8eljX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343888; c=relaxed/simple;
	bh=kloIc1ZnKhAjGI0eqXQKGvzNqu8DmMv5Yv4yjc04tRs=;
	h=Date:To:From:Subject:Message-Id; b=D9GKw1PuGtaC+XZcTfOiEeVZWdRK/H0ZQlG3XyS7PoJc0MRydVDZpreS19n4Ov0sb4X+WZs4PlZBDEeLC1lG5EmPe8OEmTR9fZVBbXfQURh5F83XQQMcon6N7Bgqr/T0MklyXqvxvaSo4Q64Q2Atzs6z9z8JfPXCGbnaJHVEZC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i5dzpknh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i5dzpknh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D371DC116C6;
	Tue, 13 Jan 2026 22:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768343887;
	bh=kloIc1ZnKhAjGI0eqXQKGvzNqu8DmMv5Yv4yjc04tRs=;
	h=Date:To:From:Subject:From;
	b=i5dzpknh+jaevORn7XRZ1qhQDloIsCz5Z4rclMdcZYMps6PGV9TZ26RkuWKEQZQWx
	 sR2/ozr61F33RodB9ZVqKbnIYutzIIoSSFm6ugmLuvDGLSWnI5Y14wIz9TmKPOuFIn
	 VpuB76SUn7s7mTFMuCkDZAYLyUaXp/KuJlh8UbfA=
Date: Tue, 13 Jan 2026 14:38:07 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-consider-age-for-quota-prioritization.patch added to mm-new branch
Message-Id: <20260113223807.D371DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: consider age for quota prioritization
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-lru_sort-consider-age-for-quota-prioritization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-consider-age-for-quota-prioritization.patch

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
Subject: mm/damon/lru_sort: consider age for quota prioritization
Date: Tue, 13 Jan 2026 07:27:10 -0800

DAMON_LRU_SORT is doing under-quota access pattern based regions
prioritization using only access frequency.  Age of regions is another
useful information for distinguishing hot and cold regions.  Use it for
prioritization, too.

Link: https://lkml.kernel.org/r/20260113152717.70459-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-consider-age-for-quota-prioritization
+++ a/mm/damon/lru_sort.c
@@ -71,7 +71,7 @@ static struct damos_quota damon_lru_sort
 	/* Within the quota, mark hotter regions accessed first. */
 	.weight_sz = 0,
 	.weight_nr_accesses = 1,
-	.weight_age = 0,
+	.weight_age = 1,
 };
 DEFINE_DAMON_MODULES_DAMOS_TIME_QUOTA(damon_lru_sort_quota);
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-nr_snapshots-damos-stat.patch
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

