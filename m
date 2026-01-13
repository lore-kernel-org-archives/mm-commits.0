Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7244C350D57
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 22:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768343886; cv=none; b=XZfM6LzM6nnNFilsoA6aALAIenLzL/jDiPDSo+pDb3Od3z5C6CZJWibQPNOaL25sh7iIdT6hKygr69WBFgwgHTixCMpzo0usSHRwVhzLTY7p0XJbZijxg4asNmxn9bq4rm/DtklUPoVZSL/bb69WwNelyiIhXzcCyYgbG+8BgFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768343886; c=relaxed/simple;
	bh=nR8qb2sH2KizyVsLjOEV77PClufAZgv2tMCBIkJf8G0=;
	h=Date:To:From:Subject:Message-Id; b=IcecE70K0iTVWwZEt2kYxwpEUgGcElXJYjIZ3Vef1Iehdldz0Pfx7EwE/jaNjLzkS8kYMrCrh/V6Q4Nj+hR3LBusqNU71jlRWzPsXbtjGPrXlcGYObosUT0vQWuH3V6e/mzpO0L92CPXIoj3Bht6nhT8VuXOeAosYI/NQBseekU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gBRiK8RK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gBRiK8RK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B002DC116C6;
	Tue, 13 Jan 2026 22:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768343885;
	bh=nR8qb2sH2KizyVsLjOEV77PClufAZgv2tMCBIkJf8G0=;
	h=Date:To:From:Subject:From;
	b=gBRiK8RKt5XpanYVHy/Hy7IEg+0RMk3R1JXLeT/7AkA8cf89ZQqkts0HXXxwrEnSR
	 hdjmsMCyBisq4YcIUKo2avKZsoPayA+YLmbwsZZhveN7BqoLW1p96hGeUaOjtiUXXa
	 dRoYi6Q9IQiYXo3AERBo6+LFmX2R4lPUOwQkWIMs=
Date: Tue, 13 Jan 2026 14:38:04 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch added to mm-new branch
Message-Id: <20260113223805.B002DC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: activate DAMOS_LRU_PRIO targets instead of marking accessed
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed.patch

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
Subject: mm/damon/paddr: activate DAMOS_LRU_PRIO targets instead of marking accessed
Date: Tue, 13 Jan 2026 07:27:09 -0800

DAMOS_LRU_DEPRIOD directly deactivates the pages, while DAMOS_LRU_PRIO
calls folio_mark_accessed(), which does incremental activation.  The
incremental activation was assumed to be useful for making sure the pages
of the hot memory region are really hot.  After the introduction of
DAMOS_LRU_PRIO, the young page filter has added.  Users can use the young
page filter to make sure the page is eligible to be activated.  Meanwhile,
the asymmetric behavior of DAMOS_LRU_[DE]PRIO can confuse users.

Directly activate given pages for DAMOS_LRU_PRIO, to eliminate the
unnecessary incremental activation steps, and be symmetric with
DAMOS_LRU_DEPRIO for easier usages.

Link: https://lkml.kernel.org/r/20260113152717.70459-5-sj@kernel.org
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

 mm/damon/paddr.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-activate-damos_lru_prio-targets-instead-of-marking-accessed
+++ a/mm/damon/paddr.c
@@ -206,9 +206,9 @@ put_folio:
 	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
-static inline unsigned long damon_pa_mark_accessed_or_deactivate(
+static inline unsigned long damon_pa_de_activate(
 		struct damon_region *r, unsigned long addr_unit,
-		struct damos *s, bool mark_accessed,
+		struct damos *s, bool activate,
 		unsigned long *sz_filter_passed)
 {
 	phys_addr_t addr, applied = 0;
@@ -227,8 +227,8 @@ static inline unsigned long damon_pa_mar
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
-		if (mark_accessed)
-			folio_mark_accessed(folio);
+		if (activate)
+			folio_activate(folio);
 		else
 			folio_deactivate(folio);
 		applied += folio_nr_pages(folio);
@@ -240,20 +240,18 @@ put_folio:
 	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
-static unsigned long damon_pa_mark_accessed(struct damon_region *r,
+static unsigned long damon_pa_activate_pages(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, addr_unit, s, true,
-			sz_filter_passed);
+	return damon_pa_de_activate(r, addr_unit, s, true, sz_filter_passed);
 }
 
 static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, addr_unit, s, false,
-			sz_filter_passed);
+	return damon_pa_de_activate(r, addr_unit, s, false, sz_filter_passed);
 }
 
 static unsigned long damon_pa_migrate(struct damon_region *r,
@@ -327,7 +325,7 @@ static unsigned long damon_pa_apply_sche
 	case DAMOS_PAGEOUT:
 		return damon_pa_pageout(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_LRU_PRIO:
-		return damon_pa_mark_accessed(r, aunit, scheme,
+		return damon_pa_activate_pages(r, aunit, scheme,
 				sz_filter_passed);
 	case DAMOS_LRU_DEPRIO:
 		return damon_pa_deactivate_pages(r, aunit, scheme,
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

