Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793670993;
	b=sqWjxUK1Eb12ihI1RuVaLPmDz2v9bkL16uZRYE35hgBzx1zs/HX5EnPj/bU4lSqFC6np
	 Q22ebtArWDswHheoslE0VBJBP0NTuVh4pCzGUwrp3UvV7ZXWSKo6gAzLQ7yoGk3YsYigR
	 NheuhBERyCaVPFWnGT5w/4q7wmDDbtXJqpbHQN0FGBpVbu2CVQlgrDbqVHMKzDeLLWqda
	 8IBr74VbIJkuXDWT6vQ00pTdfHB+dFbLoEi1KSrR+ZoGPJf5tmzeG31pLaMjxaRWOf6V9
	 nblU5T3V/sqOi7+nvMpvmXsuZ38B/Hfhvz2wc1y1wDkCEgUzF7gI6bEqj97J4IpqyPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793670993;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ttMDqZmFh1ACAwkOLfvMuhAIHjUWLzYWrsD0TPRPsGk=;
	b=KPWa72nVm+fYpYWO3SJ/0ZRmSbjC8BGh2dpMdXxP3L04nlopeTTjry71FWfJGEJTcKrS
	 xvy0Oj2Jfwy7iGvHjHWfCR44QQ7codD8runexzykE/lS+lPzAvh7jn3EW6zTy1Wm525Jp
	 nizZVaj/mD9Kf8LPLRjKQkvDUyQWMpXHStRNTupiPKnWskZwwDwMNIb+uWpbr4Nvc79DO
	 os1aktPw+GnxoVPe3osXbt3viSraRtmGYU8WvUkCxWswgmcUD53K65iq1UNxq24P3WaWZ
	 3rJeWBh8cPESgoovz21zxmBB7riGQ70u4i4WKUxV4gFeoOje5mlOSPu/NKxyEFb1aQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wHT7e9ZY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A5B606A324
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wHT7e9ZY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BA91F000C1;
	Tue,  3 Nov 2026 01:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793670992;
	bh=ttMDqZmFh1ACAwkOLfvMuhAIHjUWLzYWrsD0TPRPsGk=;
	h=Date:To:From:Subject;
	b=wHT7e9ZYTziHcK5IIQ5hX5sCMgPpLGi4XLdgWjInnrzPQH9dRe3/MG5IDwsA4ghdn
	 ho23zFJ1/s2HkUie91qhAuB7Jfm6g2Rtxb5DPo1I/EvwNveqMy36et8b7HYcnxYZ9o
	 388WRQcXwCnChFHV16hgeMjaWqePCzjhkUEg0I0I=
Date: Mon, 02 Nov 2026 17:56:31 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	willy@infradead.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,
	rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,matthew.brost@intel.com,
	ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,
	jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,hughd@google.com,
	gourry@gourry.net,david@kernel.org,byungchul@sk.com,
	baolin.wang@linux.alibaba.com,apopple@nvidia.com,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-clear_page_dirty_for_io.patch added to mm-new branch
Message-Id: <20261103015632.52BA91F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: remove clear_page_dirty_for_io()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-clear_page_dirty_for_io.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-clear_page_dirty_for_io.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove clear_page_dirty_for_io()
Date: Mon, 02 Nov 2026 17:54:08 -0500

There are no callers left. Point the comments that named it at
folio_clear_dirty_for_io() instead.

Link: https://lore.kernel.org/20261102-page-wrappers-v1-3-e7280bdb31f6@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
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
mm-remove-wait_on_page_writeback.patch
mm-remove-end_page_writeback.patch
mm-remove-clear_page_dirty_for_io.patch
mm-remove-attach_page_private-and-detach_page_private.patch
mm-remove-find_get_page_flags.patch
mm-remove-find_lock_page.patch
mm-remove-read_cache_page_gfp.patch
mm-remove-thp_size-and-thp_order.patch

