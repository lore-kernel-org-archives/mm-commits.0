Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C690E488222;
	Tue,  1 Sep 2026 17:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788282638; cv=none; b=uuHxHql4iIZceHYfhKhn9yg/K4wfYND9TFVfug6Rp1599ntfNtVL4rYPD83ax1iLvFqupu/SUSK5xDx0s6XCcVUJgnSxtipjYVF33kKBZkJR82oGK/usiCWLa4dsLFINXUuAkp8JU5FejnqTMahE91p+JULqnBS3jRdZ30xV/Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788282638; c=relaxed/simple;
	bh=PuCrFXSpvfBX9zbhG6UHco1lpbKcBCajfcsH3T3W9P0=;
	h=Date:To:From:Subject:Message-Id; b=L/3UhQeLxzrLz79mG+tWJ7x3Ph8uTIHTlMQPyfPcC4+02kdMB+3s7hX8uZnCC5KmN9jGWm5bifI2aqQJe3kpqJ/+FTbQG4IihYtSEYj3NlkFgKQG3qKLLQh0gdbB4bgkcx+swJw2elWYlqy08WEOWPL8lAAyjdjcST8YiEAYm8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FwH5tEb1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FwH5tEb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF411F00A3A;
	Tue,  1 Sep 2026 17:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788282636;
	bh=k5rBUz6W7IrfQVaPtk5rDYJY+h4xWt3ng59BZlhbtho=;
	h=Date:To:From:Subject;
	b=FwH5tEb1FULdWxczoxX2nO4BYbGLNEg1K1Wlm1n+v/G5ZFIbRvoSSvfQ56ugEg015
	 v3OWvIkhi1PZ7lgn34yVWnw7jNuuWVMd5ivdqQDuLBD9nICWWqvRnqeLdYvRIeXr9L
	 Bdc608TPfIIFzfBW0+h1xBRSerNeOjbRGd/AslDg=
Date: Tue, 01 Sep 2026 10:10:35 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-respect-folio-end-for-damos_stat.patch added to mm-new branch
Message-Id: <20260901171036.3BF411F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: respect folio end for DAMOS_STAT
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-paddr-respect-folio-end-for-damos_stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-respect-folio-end-for-damos_stat.patch

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
Subject: mm/damon/paddr: respect folio end for DAMOS_STAT
Date: Tue, 1 Sep 2026 06:18:43 -0700

The function for applying DAMOS_STAT in DAMON physical address space
operation set (paddr), namely damon_pa_stat(), applies DAMOS filters to
folios of the given region.  For that, it gets folios of addresses in the
region.  It starts from the region start address and advances the address
by the size of the folio of the address until it goes out of the region. 
If the start address is in the middle of a large folio, and if the next
folios are small, some of the next folios could be skipped.  Fix the issue
by advancing the address to exactly the start address of the next folio.

The user impact is that the DAMOS_STAT-based page level monitoring results
become inaccurate.  Since the page level monitoring is supposed to provide
relatively high precision, this is definitely a problem.  It is arguably
not critical since it is only monitoring quality degradation.

Link: https://lore.kernel.org/20260901131850.98037-3-sj@kernel.org
Fixes: bdbe1d7bc325 ("mm/damon/paddr: increment pa_stat damon address range by folio size")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-respect-folio-end-for-damos_stat
+++ a/mm/damon/paddr.c
@@ -379,7 +379,7 @@ static unsigned long damon_pa_stat(struc
 
 		if (!damos_pa_filter_out(s, folio))
 			*sz_filter_passed += folio_size(folio) / addr_unit;
-		addr += folio_size(folio);
+		addr = PFN_PHYS(folio_pfn(folio)) + folio_size(folio);
 		folio_put(folio);
 	}
 	s->last_applied = folio;
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

