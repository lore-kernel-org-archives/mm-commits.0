Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953551411F3
	for <mm-commits@vger.kernel.org>; Tue,  4 Jun 2024 23:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544298; cv=none; b=Pfs+97H1vw57VbMuX1IhAqkg9c2VQ7P6b555VDQFHN/2axgQXF4BDoSz/ubI8pxtZePIqoA5Z5REsuZpguM3Aig7a0LzwlMWQbulT0OJ9nH7jn3k0omlfqMO9Y1ptaRABGAR10Vd9OCHgrxmkKpf9r2zYQkPs4LMgTn7EXRalP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544298; c=relaxed/simple;
	bh=nB2E3Bje33P5lDSHMUC0ybn7KxUNeBTCQcNh1jdmCzQ=;
	h=Date:To:From:Subject:Message-Id; b=pIuuQgZM3t6c4T6Ew5VIGNHl+RVSAt7VIH0A7A/VyNQa0RKeXSP/OpLVKYdPdWhmbbDNUOwf3LgIu7VmLkRR9K/gtHf/tXIi2dgD1AqHO8qsrP/tfo/PjWVsBYrsE5UQH69Z5udU2PGorxsoTMlnZBTHbdkhnzOPotZA36R8Mo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bfX1cLG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bfX1cLG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE5EC2BBFC;
	Tue,  4 Jun 2024 23:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717544298;
	bh=nB2E3Bje33P5lDSHMUC0ybn7KxUNeBTCQcNh1jdmCzQ=;
	h=Date:To:From:Subject:From;
	b=bfX1cLG4wyHkWGfRNlKTWl27DIWtZP3EscbuJOdFIHVRck4WcFXn/Fu7H6QgOdB6N
	 EtwG5xXIp2cTDMont41GWdWBXV8muCrqeffU6SVHxxkgTQCgcgJoZFIDc3JEeD3Kn3
	 D5BqtWk+GMUcCnt+PVbJea64Omf5Gbd6TLzKTTL4=
Date: Tue, 04 Jun 2024 16:38:17 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,deller@gmx.de,david@redhat.com,daniel@ffwll.ch,corbet@lwn.net,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch added to mm-unstable branch
Message-Id: <20240604233818.0BE5EC2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: use folio API in pte_is_pinned()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: fs/proc/task_mmu: use folio API in pte_is_pinned()
Date: Tue, 4 Jun 2024 19:48:19 +0800

Patch series "mm: remove page_maybe_dma_pinned() and page_mkclean()".

Most page_maybe_dma_pinned() and page_mkclean() callers have been
converted to the folio equivalents, after two more convertsions,
remove them and update the comment and documention.


This patch (of 4):

Convert to use vm_normal_folio() and folio_maybe_dma_pinned() API, which
helps to remove page_maybe_dma_pinned() in the subsequent change.

Link: https://lkml.kernel.org/r/20240604114822.2089819-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20240604114822.2089819-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-use-folio-api-in-pte_is_pinned
+++ a/fs/proc/task_mmu.c
@@ -1088,7 +1088,7 @@ struct clear_refs_private {
 
 static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
-	struct page *page;
+	struct folio *folio;
 
 	if (!pte_write(pte))
 		return false;
@@ -1096,10 +1096,10 @@ static inline bool pte_is_pinned(struct
 		return false;
 	if (likely(!test_bit(MMF_HAS_PINNED, &vma->vm_mm->flags)))
 		return false;
-	page = vm_normal_page(vma, addr, pte);
-	if (!page)
+	folio = vm_normal_folio(vma, addr, pte);
+	if (!folio)
 		return false;
-	return page_maybe_dma_pinned(page);
+	return folio_maybe_dma_pinned(folio);
 }
 
 static inline void clear_soft_dirty(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-add-folio_alloc_mpol.patch
mm-mempolicy-use-folio_alloc_mpol_noprof-in-vma_alloc_folio_noprof.patch
mm-mempolicy-use-folio_alloc_mpol-in-alloc_migration_target_by_mpol.patch
mm-shmem-use-folio_alloc_mpol-in-shmem_alloc_folio.patch
mm-refactor-folio_undo_large_rmappable.patch
mm-memcontrol-remove-page_memcg.patch
rmap-remove-define_page_vma_walk.patch
mm-migrate-simplify-__buffer_migrate_folio.patch
mm-migrate_device-use-a-newfolio-in-__migrate_device_pages.patch
mm-migrate_device-unify-migrate-folio-for-migrate_sync_no_copy.patch
mm-migrate-remove-migrate_folio_extra.patch
mm-remove-migrate_sync_no_copy-mode.patch
fs-proc-task_mmu-use-folio-api-in-pte_is_pinned.patch
mm-remove-page_maybe_dma_pinned.patch
fb_defio-use-a-folio-in-fb_deferred_io_work.patch
mm-remove-page_mkclean.patch

