Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D6048CD63;
	Tue,  1 Sep 2026 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788282643; cv=none; b=VcIV/3frIGkAWhti1K4BKepJa23gFW1flB2PIpo2e0VVkhP2pmkGRcHOJoXzi2sA8y8Y/V8kbR+t904p19rXR/UYTwKqLT7nJwCU4FTmK3+Jt/GZEV4eVxsegqTJk20XQWN3Bp0ejz8H+gLxNBDSwoAjUlWfhuJmy+MIpbjMFH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788282643; c=relaxed/simple;
	bh=HgBBuqoq5UHmz7Luwo2h5pgfGIOhUK60Yws47F5tkGM=;
	h=Date:To:From:Subject:Message-Id; b=SNeKGrhGqopesw7zZzyEgZePDg4JGqYltbhuFbM2ZPnga+x7Qjyr5UsPsBUM93oiT+w5ZDsbNonb+WYmUmRus+3mP3G7AbK6l88MR/10rd5E95X0kLzMKTK0YBhn4K+nJ+2EJ3f+zFfA3SEVYW1HunaFrVqWaMqStCU5WWzcHKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0fdiDJay; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0fdiDJay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8151F000E9;
	Tue,  1 Sep 2026 17:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788282642;
	bh=b8pzTdl3QvUUwC2yBVrzGB+KtHXMOBWk+W4ENUzWwGg=;
	h=Date:To:From:Subject;
	b=0fdiDJayWaNQ0VPqNMlDDyAGPqSOqvOYQqRVfo0aD2nWWZB98cNUgxOEJlQzaphkG
	 q6ENSeqH6YoraBlPTJ2YDsHWWXLjYjHCzrUYG5cv4BRvVGyh3FBT2P2zGK0XHs7roP
	 I78y4dcfpUhHwrHPUsRwasQR+2TNpa74S7KzEmJk=
Date: Tue, 01 Sep 2026 10:10:41 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch added to mm-new branch
Message-Id: <20260901171042.3E8151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch

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
Subject: mm/damon/vaddr: respect folio end for DAMOS_MIGRATE_{HOT,COLD}
Date: Tue, 1 Sep 2026 06:18:46 -0700

For applying DAMOS_MIGRATE_{HOT,COLD} actions to a region, DAMON virtual
address space operation set (vaddr) calls walk_page_range[_vma]() for the
region.  The pmd walk entry function, namely damon_va_migrate_pmd_entry(),
collects folios of addresses of the region in the pmd.  It starts from the
walking address and advances the address by the size of the folio of the
address until it goes out of the pmd or the region.

Let's suppose it is for the first pmd of the region, and the region start
address is in the middle of a large folio.  Also, the next folios are
small.  Then, some of the next folios could be skipped.  Fix the issue by
advancing the address to exactly the start address of the next folio.

The user impact is that DAMOS action is applied to less than expected
amount of memory.  Given the best effort nature of DAMON, it is no big
problem, but it is clearly a bug that is better to be fixed.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260901131850.98037-6-sj@kernel.org
Link: https://lore.kernel.org/20260514015053.149396-1-sj@kernel.org [1]
Fixes: 09efc56a3b1c ("mm/damon/vaddr: consistently use only pmd_entry for damos_migrate")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold
+++ a/mm/damon/vaddr.c
@@ -669,6 +669,8 @@ huge_out:
 		return 0;
 
 	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		unsigned long page_idx;
+
 		nr = 1;
 		ptent = ptep_get(pte);
 
@@ -681,7 +683,8 @@ huge_out:
 			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
-		nr = folio_nr_pages(folio);
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 	}
 	pte_unmap_unlock(start_pte, ptl);
 	return 0;
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

