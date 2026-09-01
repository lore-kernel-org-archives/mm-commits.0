Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CA3486B81;
	Tue,  1 Sep 2026 17:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788282641; cv=none; b=DF/IxZ5Vc9bqlKmZvYqCPkjTsi7rpxTW5ERCdbbXhYd5TBwKcZ/cO7tACLY4sThHFYPUJQPPNXzGNysqhI67eMoEE/VXODarzApLBZhiI9VwpYeYuEA+fkMJszelB3B445hbT2Q7qWTv+4Z8hx5oiOHw4Zn3kOfwhcNDSrL1SCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788282641; c=relaxed/simple;
	bh=lnGMmJJyt0FQj20f5VNVEiua5wJaTp1g1W6JfS6Spg0=;
	h=Date:To:From:Subject:Message-Id; b=V57ChStpEPkBXnjg2wkH3XIv76JJVIIPvNsut44+H8Cz0TG8HUnnK9QbnI8FYVgOkfc/BYxqhHJZgAp1K5SCbps4u9a+bDFOBiXK5CDv+sTXsLoLq5MDrzzBPgRyjY2E5zGnncc1vCv4JZiMY6q4zlqxRja2qEYT+VN9/kyC5UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NdDq3/oy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NdDq3/oy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397FB1F00A3E;
	Tue,  1 Sep 2026 17:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788282640;
	bh=lGxKGb60pJAWlfY0194eTYsMI8LBfDSTKXuM9l0tmGA=;
	h=Date:To:From:Subject;
	b=NdDq3/oypNVEc4JHVw6v58O7WV6AwFNW6L7EyrLgJr5obqTF3OCWKvdQ57nSzyBKf
	 PKPYPuu02OpBmueQHj6KolKaQuTrgKZiqRm7CwQD9Yqcz3AMzqDSiUyGsnKFJFcP0b
	 y6jD2Wib9NdK1MZ7IgcNH3s6sIpVTqUgjcrEnyd4=
Date: Tue, 01 Sep 2026 10:10:39 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-respect-folio-end-for-damos_stat.patch added to mm-new branch
Message-Id: <20260901171040.397FB1F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: respect folio end for DAMOS_STAT
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-vaddr-respect-folio-end-for-damos_stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-respect-folio-end-for-damos_stat.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/vaddr: respect folio end for DAMOS_STAT
Date: Tue, 1 Sep 2026 06:18:45 -0700

For applying DAMOS_STAT action to a region, DAMON virtual address space
operation set (vaddr) calls walk_page_range[_vma]() for the region.  The
pmd walk entry function, namely damon_va_stat_pmd_entry(), applies DAMOS
filters to folios of addresses of the region in the pmd.  It starts from
the walking address and advances the address by the size of the folio of
the address until it goes out of the pmd or the region.

Let's suppose it is for the first pmd of the region, and the region start
address is in the middle of a large folio.  Also, the next folios are
small.  Then, some of the next folios could be skipped.  Fix the issue by
advancing the address to exactly the start address of the next folio.

The user impact is that the DAMOS_STAT-based page level monitoring results
become inaccurate.  Since the page level monitoring is supposed to provide
relatively high precision, this is definitely a problem.  It is arguably
not critical since it is only monitoring quality degradation.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-5-sj@kernel.org
Link: https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org [1]
Fixes: 63f39737d1e3 ("mm/damon/vaddr: support stat-purpose DAMOS filters")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-respect-folio-end-for-damos_stat
+++ a/mm/damon/vaddr.c
@@ -831,6 +831,8 @@ huge_unlock:
 		return 0;
 
 	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		unsigned long page_idx;
+
 		nr = 1;
 		ptent = ptep_get(pte);
 
@@ -844,7 +846,8 @@ huge_unlock:
 
 		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
 			*sz_filter_passed += folio_size(folio);
-		nr = folio_nr_pages(folio);
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 		s->last_applied = folio;
 	}
 	pte_unmap_unlock(start_pte, ptl);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch

