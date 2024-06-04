Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C76514E2C1
	for <mm-commits@vger.kernel.org>; Tue,  4 Jun 2024 23:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544302; cv=none; b=IDwfNeGY+81Tfks99yo9Vi6eD/rFEXWooJdjwVBiojuhKccscrTXsCaSukqpi2Sx4UoUz1Tgo3SmiHchkdyi6wt1XWsooLlLbo2whLirkNjv1y8TkcQd/vbvcrjdpw9eQ4D9TfXIqL2Y+SkLyyr68Uau6Cq3lt4eUKc7cQRHP3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544302; c=relaxed/simple;
	bh=YMgFzwz0xU355Y4bXztaRPLPFSCqcRfG7kykyFKianw=;
	h=Date:To:From:Subject:Message-Id; b=mPm0rHT5jJyJnZX5Xs94yOubPCd3uYkSar2Q672GkSLWuksBNKliF/XDPd12b/oF1J5FHlPvZjqsgrPvWZw6+Y2tBh4W05T1w6brcSCKKeaZy8r3LUkueCXjLXOP5Za86IF3o7TKTAawQJ+j1V9RLcao26wedgmgss+NEmSho0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CSmPQm2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CSmPQm2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10035C2BBFC;
	Tue,  4 Jun 2024 23:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717544302;
	bh=YMgFzwz0xU355Y4bXztaRPLPFSCqcRfG7kykyFKianw=;
	h=Date:To:From:Subject:From;
	b=CSmPQm2ScRGy2H9itQCVZgyKCWMiMfYdDwKQUU3kXSvt6jxx8nYrN6L6Glf9dRqta
	 ceKGAqA4EahuiwvfN7rwuKesQqG99nAzsc8KpRKBl5aGCjPpWXCJuTr+tNcZCCgyKw
	 dSVdhboeAKZuvwMyQSk8B/0sDcSBVcUjm4GZjEK8=
Date: Tue, 04 Jun 2024 16:38:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,deller@gmx.de,david@redhat.com,daniel@ffwll.ch,corbet@lwn.net,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fb_defio-use-a-folio-in-fb_deferred_io_work.patch added to mm-unstable branch
Message-Id: <20240604233822.10035C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fb_defio: use a folio in fb_deferred_io_work()
has been added to the -mm mm-unstable branch.  Its filename is
     fb_defio-use-a-folio-in-fb_deferred_io_work.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fb_defio-use-a-folio-in-fb_deferred_io_work.patch

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
Subject: fb_defio: use a folio in fb_deferred_io_work()
Date: Tue, 4 Jun 2024 19:48:21 +0800

Replaces three calls to compound_head() with one, which removes last
caller of page_mkclean().

Link: https://lkml.kernel.org/r/20240604114822.2089819-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/fbdev/core/fb_defio.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/video/fbdev/core/fb_defio.c~fb_defio-use-a-folio-in-fb_deferred_io_work
+++ a/drivers/video/fbdev/core/fb_defio.c
@@ -244,10 +244,11 @@ static void fb_deferred_io_work(struct w
 	/* here we mkclean the pages, then do all deferred IO */
 	mutex_lock(&fbdefio->lock);
 	list_for_each_entry(pageref, &fbdefio->pagereflist, list) {
-		struct page *cur = pageref->page;
-		lock_page(cur);
-		page_mkclean(cur);
-		unlock_page(cur);
+		struct folio *folio = page_folio(pageref->page);
+
+		folio_lock(folio);
+		folio_mkclean(folio);
+		folio_unlock(folio);
 	}
 
 	/* driver's callback with pagereflist */
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

