Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE0E14D715
	for <mm-commits@vger.kernel.org>; Tue,  4 Jun 2024 23:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544304; cv=none; b=XZSNq2wKhXZvJ7J2TAQG9WN6rmc6RQZuZzP8n96OjlMGdcAhbfEiGgV+HpuR/LnyBB+mFH1pT1dhDTTrlnoRtXPqOoJ4u6wJi+XwoMvdJCi1IUwNTGbYHO4z1yY7bmBb4vLrlee2TSL5Fse1oN2WZ/3P//OZRZxUWHm9d735FOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544304; c=relaxed/simple;
	bh=6ogIo6/ldejxwnccgJAtcYpQ6tFbuxtReFpYH5iZ4iM=;
	h=Date:To:From:Subject:Message-Id; b=LnoMA9GchVri+VbLPP/EwA45Q42yTwQmu2wyOxZ03ouYqQ+0T0KstmW2s0N0peVZDkJU9rgGshp2/Xt+NsmbRdsAXFkx65nhqrvnR8gynNJLaHqNFC2jH+MgULCQy2TnpaAmrNlO/twFeOxV8azXdarSS2/aVvMSfmN2dwoqyjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xu1jrBhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xu1jrBhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21A1C3277B;
	Tue,  4 Jun 2024 23:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717544304;
	bh=6ogIo6/ldejxwnccgJAtcYpQ6tFbuxtReFpYH5iZ4iM=;
	h=Date:To:From:Subject:From;
	b=Xu1jrBhz79XZOA+8riZgQSkL/PIfvzUg9w43417e4QwdKeZS327vv6igwXNCgrbZx
	 fBGM9DDuLjJH3eusuVeEtDto9WlW88OaePgLQSpAhJKu9ZBIC6InvNC6MBVc3Tun+w
	 ur7sgtcJ4AsWAT+D8oHgKvgAp4zC9yTZuXlE5cc0=
Date: Tue, 04 Jun 2024 16:38:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,deller@gmx.de,david@redhat.com,daniel@ffwll.ch,corbet@lwn.net,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_mkclean.patch added to mm-unstable branch
Message-Id: <20240604233823.F21A1C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove page_mkclean()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_mkclean.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_mkclean.patch

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
Subject: mm: remove page_mkclean()
Date: Tue, 4 Jun 2024 19:48:22 +0800

There are no more users of page_mkclean(), remove it and update the
document and comment.

Link: https://lkml.kernel.org/r/20240604114822.2089819-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Helge Deller <deller@gmx.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/pin_user_pages.rst |    8 ++++----
 drivers/video/fbdev/core/fb_defio.c       |    4 ++--
 include/linux/mm.h                        |    2 +-
 include/linux/rmap.h                      |    4 ----
 mm/gup.c                                  |    2 +-
 mm/mremap.c                               |    2 +-
 6 files changed, 9 insertions(+), 13 deletions(-)

--- a/Documentation/core-api/pin_user_pages.rst~mm-remove-page_mkclean
+++ a/Documentation/core-api/pin_user_pages.rst
@@ -132,7 +132,7 @@ CASE 1: Direct IO (DIO)
 -----------------------
 There are GUP references to pages that are serving
 as DIO buffers. These buffers are needed for a relatively short time (so they
-are not "long term"). No special synchronization with page_mkclean() or
+are not "long term"). No special synchronization with folio_mkclean() or
 munmap() is provided. Therefore, flags to set at the call site are: ::
 
     FOLL_PIN
@@ -144,7 +144,7 @@ CASE 2: RDMA
 ------------
 There are GUP references to pages that are serving as DMA
 buffers. These buffers are needed for a long time ("long term"). No special
-synchronization with page_mkclean() or munmap() is provided. Therefore, flags
+synchronization with folio_mkclean() or munmap() is provided. Therefore, flags
 to set at the call site are: ::
 
     FOLL_PIN | FOLL_LONGTERM
@@ -170,7 +170,7 @@ callback, simply remove the range from t
 
 Either way, as long as the driver unpins the pages upon mmu notifier callback,
 then there is proper synchronization with both filesystem and mm
-(page_mkclean(), munmap(), etc). Therefore, neither flag needs to be set.
+(folio_mkclean(), munmap(), etc). Therefore, neither flag needs to be set.
 
 CASE 4: Pinning for struct page manipulation only
 -------------------------------------------------
@@ -200,7 +200,7 @@ folio_maybe_dma_pinned(): the whole poin
 ===================================================
 
 The whole point of marking folios as "DMA-pinned" or "gup-pinned" is to be able
-to query, "is this folio DMA-pinned?" That allows code such as page_mkclean()
+to query, "is this folio DMA-pinned?" That allows code such as folio_mkclean()
 (and file system writeback code in general) to make informed decisions about
 what to do when a folio cannot be unmapped due to such pins.
 
--- a/drivers/video/fbdev/core/fb_defio.c~mm-remove-page_mkclean
+++ a/drivers/video/fbdev/core/fb_defio.c
@@ -113,7 +113,7 @@ static vm_fault_t fb_deferred_io_fault(s
 		printk(KERN_ERR "no mapping available\n");
 
 	BUG_ON(!page->mapping);
-	page->index = vmf->pgoff; /* for page_mkclean() */
+	page->index = vmf->pgoff; /* for folio_mkclean() */
 
 	vmf->page = page;
 	return 0;
@@ -161,7 +161,7 @@ static vm_fault_t fb_deferred_io_track_p
 
 	/*
 	 * We want the page to remain locked from ->page_mkwrite until
-	 * the PTE is marked dirty to avoid page_mkclean() being called
+	 * the PTE is marked dirty to avoid folio_mkclean() being called
 	 * before the PTE is updated, which would leave the page ignored
 	 * by defio.
 	 * Do this by locking the page here and informing the caller
--- a/include/linux/mm.h~mm-remove-page_mkclean
+++ a/include/linux/mm.h
@@ -1597,7 +1597,7 @@ static inline void put_page(struct page
  * issue.
  *
  * Locking: the lockless algorithm described in folio_try_get_rcu()
- * provides safe operation for get_user_pages(), page_mkclean() and
+ * provides safe operation for get_user_pages(), folio_mkclean() and
  * other calls that race to set up page table entries.
  */
 #define GUP_PIN_COUNTING_BIAS (1U << 10)
--- a/include/linux/rmap.h~mm-remove-page_mkclean
+++ a/include/linux/rmap.h
@@ -780,8 +780,4 @@ static inline int folio_mkclean(struct f
 }
 #endif	/* CONFIG_MMU */
 
-static inline int page_mkclean(struct page *page)
-{
-	return folio_mkclean(page_folio(page));
-}
 #endif	/* _LINUX_RMAP_H */
--- a/mm/gup.c~mm-remove-page_mkclean
+++ a/mm/gup.c
@@ -393,7 +393,7 @@ void unpin_user_pages_dirty_lock(struct
 		 * 1) This code sees the page as already dirty, so it
 		 * skips the call to set_page_dirty(). That could happen
 		 * because clear_page_dirty_for_io() called
-		 * page_mkclean(), followed by set_page_dirty().
+		 * folio_mkclean(), followed by set_page_dirty().
 		 * However, now the page is going to get written back,
 		 * which meets the original intention of setting it
 		 * dirty, so all is well: clear_page_dirty_for_io() goes
--- a/mm/mremap.c~mm-remove-page_mkclean
+++ a/mm/mremap.c
@@ -198,7 +198,7 @@ static int move_ptes(struct vm_area_stru
 		 * PTE.
 		 *
 		 * NOTE! Both old and new PTL matter: the old one
-		 * for racing with page_mkclean(), the new one to
+		 * for racing with folio_mkclean(), the new one to
 		 * make sure the physical page stays valid until
 		 * the TLB entry for the old mapping has been
 		 * flushed.
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

