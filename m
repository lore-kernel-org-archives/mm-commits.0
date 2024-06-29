Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A7BAD55
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628205; cv=none; b=N5z095MGftbpKFBjoJ5JtY4Q2ebyiHrii6SvTZS+Cegcf+cIZAV4UIH7h5cuCZNBc7WZRR8mMgrd/MzL3cAyd18IBACI97khRdAx8ypV/37lBYl59zo3xMJbfy4t7Bq8oPOkLikon2I7t4f/fk/2Ar01GK1IoSG7Zt7X0VGq8To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628205; c=relaxed/simple;
	bh=qcnxybAMeBwLJvqICeQh5STwHb6QLHTXvuCYGJVUyQQ=;
	h=Date:To:From:Subject:Message-Id; b=Y60uBtJJso4oirHzOCy8651ipZtke+5nDoHWt0Px9hwL8ibY84i3QxSyd+JusUB8JNQDPJ3bLnC+tCMslbpMLINIRPO7zGVEs8aVSTAkM/1l/j8FUR+s0Mkj+Wn4qvAraQ0Mn5SkmpBRgzZ3TxVxRrrOWJqweRQyNCHKOkuK+4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sj9aVzRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sj9aVzRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B7CC32781;
	Sat, 29 Jun 2024 02:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628204;
	bh=qcnxybAMeBwLJvqICeQh5STwHb6QLHTXvuCYGJVUyQQ=;
	h=Date:To:From:Subject:From;
	b=Sj9aVzRet/vCKWLZCqR5R6wY+3j//klNNDUAKSkhCB/XoTIxF3h7Ux2b1a/uErqcV
	 3L4m2YgCH2wrGR21U8uCoW8DIGkG7sZ75Ev0PIFVJ/5VQVt83T6PkpgYolR/5BMjZS
	 VvAN6uYadwJxOSnNzz/3Ssizux4jbO2Fejne6i6g=
Date: Fri, 28 Jun 2024 19:30:04 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,deller@gmx.de,david@redhat.com,daniel@ffwll.ch,corbet@lwn.net,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-page_mkclean.patch removed from -mm tree
Message-Id: <20240629023004.80B7CC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove page_mkclean()
has been removed from the -mm tree.  Its filename was
     mm-remove-page_mkclean.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
 ====================================================
 
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
@@ -1577,7 +1577,7 @@ static inline void put_page(struct page
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
@@ -802,8 +802,4 @@ static inline int folio_mkclean(struct f
 }
 #endif	/* CONFIG_MMU */
 
-static inline int page_mkclean(struct page *page)
-{
-	return folio_mkclean(page_folio(page));
-}
 #endif	/* _LINUX_RMAP_H */
--- a/mm/gup.c~mm-remove-page_mkclean
+++ a/mm/gup.c
@@ -378,7 +378,7 @@ void unpin_user_pages_dirty_lock(struct
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

mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

