Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894086;
	b=OmWq3Z9Itw/dnyfZkVmeIic4kTnMoJkFHMnjBUtnUPxmb8CuCxpbJ0JqYwW3DWn/82Zm
	 IUNheNi1B+/ESU54Y4gwbxa2l5uPVCxv8mng9U6cG7FH/Skwa0aJDv43Viv0G7gku5JLZ
	 bcnA9g4u3SF3jTOkGXTHHUgzZYJ1MO5C9gnKROWRXDWqVMPkJCw66j+XKMBSbMfP56jmS
	 XbyCM/fCl36xSyITnV2SPmNM911DxDPGOf6cIgThr+8E44ym0gsyBsbSpnUWEThwEOfFM
	 SxXmKhrZ3GRNuCYf982oMfQ6JG8GoO+hMWUS6i72kBHZSJX775atgUtGxxMbAO83sbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894086;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=dJjPYRk00p2n14nDC77fcZhRqR4DEmx9LIXfIV/qK0s=;
	b=gCyyNbDJcWeoVMvE/wGYjVs3y685ogPOVZn6yKMmXcwD59Au3NdPANk69p8NfeXHpD6a
	 B8QD6as/dGMoS8DQCazTS5Q10DlHp19j+K9TVS12T/nZSPkJA2IjXMKKayUDZ8/GiBeXs
	 56hQFvHPD0txCxkoIXVUVQcazA4Qs75fV4DggRS0DJykK2Q2hzD9KWgD1TaTcurS0n2HT
	 u6+5pCPGrozgh2RKdyL1BZ+edPwfLlw5G/R1qzVOAwHjg8ZAOjWOC2z/HJWKwSmed4tOd
	 y6asRL14ePiPpvlp/0iIBBxJITPkj8wDN6Hsj1c85IBzoohDYB+SBPdVlopQY5PiVIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Sm45+7UN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC6A606BE83
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 15:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Sm45+7UN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A6A1F00A18;
	Thu,  5 Nov 2026 15:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793894085;
	bh=dJjPYRk00p2n14nDC77fcZhRqR4DEmx9LIXfIV/qK0s=;
	h=Date:To:From:Subject;
	b=Sm45+7UNPa0tx+CQkfNS32HfHmVVssa9Hnn4nGuiuDKxJFsKVgp11ntG1SFGb9XA6
	 MFKSSVlPcw9S5hZIFqhm7tbotzeTxhCfjVvzeeJzSayVz9HHOEWMVuJQBnXMuL8LqY
	 7wqmmPcGeC/DIS4KsmtwLeT5OyX+dU5oTeSbky8k=
Date: Thu, 05 Nov 2026 07:54:44 -0800
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-clear_page_dirty_for_io.patch removed from -mm tree
Message-Id: <20261105155445.27A6A1F00A18@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: remove clear_page_dirty_for_io()
has been removed from the -mm tree.  Its filename was
     mm-remove-clear_page_dirty_for_io.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove clear_page_dirty_for_io()
Date: Mon, 02 Nov 2026 17:54:08 -0500

There are no callers left. Point the comments that named it at
folio_clear_dirty_for_io() instead.

Link: https://lore.kernel.org/20261102-page-wrappers-v1-3-e7280bdb31f6@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 include/linux/pagemap.h |    1 -
 mm/folio-compat.c       |    6 ------
 mm/gup.c                |    6 +++---
 mm/page-writeback.c     |    2 +-
 4 files changed, 4 insertions(+), 11 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-clear_page_dirty_for_io
+++ a/include/linux/pagemap.h
@@ -1315,7 +1315,6 @@ static inline void folio_cancel_dirty(st
 		__folio_cancel_dirty(folio);
 }
 bool folio_clear_dirty_for_io(struct folio *folio);
-bool clear_page_dirty_for_io(struct page *page);
 void folio_invalidate(struct folio *folio, size_t offset, size_t length);
 bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
 
--- a/mm/folio-compat.c~mm-remove-clear_page_dirty_for_io
+++ a/mm/folio-compat.c
@@ -42,12 +42,6 @@ int set_page_dirty_lock(struct page *pag
 }
 EXPORT_SYMBOL(set_page_dirty_lock);
 
-bool clear_page_dirty_for_io(struct page *page)
-{
-	return folio_clear_dirty_for_io(page_folio(page));
-}
-EXPORT_SYMBOL(clear_page_dirty_for_io);
-
 bool redirty_page_for_writepage(struct writeback_control *wbc,
 		struct page *page)
 {
--- a/mm/gup.c~mm-remove-clear_page_dirty_for_io
+++ a/mm/gup.c
@@ -298,16 +298,16 @@ void unpin_user_pages_dirty_lock(struct
 		folio = gup_folio_next(pages, npages, i, &nr);
 		/*
 		 * Checking PageDirty at this point may race with
-		 * clear_page_dirty_for_io(), but that's OK. Two key
+		 * folio_clear_dirty_for_io(), but that's OK. Two key
 		 * cases:
 		 *
 		 * 1) This code sees the page as already dirty, so it
 		 * skips the call to set_page_dirty(). That could happen
-		 * because clear_page_dirty_for_io() called
+		 * because folio_clear_dirty_for_io() called
 		 * folio_mkclean(), followed by set_page_dirty().
 		 * However, now the page is going to get written back,
 		 * which meets the original intention of setting it
-		 * dirty, so all is well: clear_page_dirty_for_io() goes
+		 * dirty, so all is well: folio_clear_dirty_for_io() goes
 		 * on to call TestClearPageDirty(), and write the page
 		 * back.
 		 *
--- a/mm/page-writeback.c~mm-remove-clear_page_dirty_for_io
+++ a/mm/page-writeback.c
@@ -2821,7 +2821,7 @@ EXPORT_SYMBOL(folio_mark_dirty_lock);
  * This cancels just the dirty bit on the kernel page itself, it does NOT
  * actually remove dirty bits on any mmap's that may be around. It also
  * leaves the page tagged dirty, so any sync activity will still find it on
- * the dirty lists, and in particular, clear_page_dirty_for_io() will still
+ * the dirty lists, and in particular, folio_clear_dirty_for_io() will still
  * look at the dirty bits in the VM.
  *
  * Doing this should *normally* only ever be done when a page is truncated,
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch
mm-remove-attach_page_private-and-detach_page_private.patch
mm-remove-find_get_page_flags.patch
mm-remove-find_lock_page.patch
mm-remove-read_cache_page_gfp.patch
mm-remove-thp_size-and-thp_order.patch

