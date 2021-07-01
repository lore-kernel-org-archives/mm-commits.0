Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA71CC11F68
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C33E16146D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238529AbhGAB4n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238429AbhGAB4n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5187E61241;
        Thu,  1 Jul 2021 01:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104453;
        bh=1mLf1zR8rpOL8LdHJ3sDV6pUmT6Sb3F5WfGGkH6Jm3A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UyVGImAnXZ3QTISysKsOh2fFKqX5Xpj+tX1PxTLM/WzHnwmLb+kCIQFkWB1sSBeG0
         7nypZwEou0/1x5DA/+5QkVnoi01ZtVIyHhVm/+sOQkpwv7devusVGFbkgr4q1zLy33
         VA3pyfyPNiAV84xTKDqiMQY5gklJFwwTDs51RalE=
Date:   Wed, 30 Jun 2021 18:54:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apopple@nvidia.com, bskeggs@redhat.com,
        hch@lst.de, hughd@google.com, jgg@nvidia.com, jhubbard@nvidia.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, shakeelb@google.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 132/192] mm/rmap: split try_to_munlock from
 try_to_unmap
Message-ID: <20210701015412.snaTuyrO6%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>
Subject: mm/rmap: split try_to_munlock from try_to_unmap

The behaviour of try_to_unmap_one() is difficult to follow because it
performs different operations based on a fairly large set of flags used in
different combinations.

TTU_MUNLOCK is one such flag.  However it is exclusively used by
try_to_munlock() which specifies no other flags.  Therefore rather than
overload try_to_unmap_one() with unrelated behaviour split this out into
it's own function and remove the flag.

Link: https://lkml.kernel.org/r/20210616105937.23201-4-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.rst |   33 ++++--------
 include/linux/rmap.h                 |    3 -
 mm/mlock.c                           |   12 ++--
 mm/rmap.c                            |   66 ++++++++++++++++++-------
 4 files changed, 69 insertions(+), 45 deletions(-)

--- a/Documentation/vm/unevictable-lru.rst~mm-rmap-split-try_to_munlock-from-try_to_unmap
+++ a/Documentation/vm/unevictable-lru.rst
@@ -389,14 +389,14 @@ mlocked, munlock_vma_page() updates that
 mlocked pages.  Note, however, that at this point we haven't checked whether
 the page is mapped by other VM_LOCKED VMAs.
 
-We can't call try_to_munlock(), the function that walks the reverse map to
+We can't call page_mlock(), the function that walks the reverse map to
 check for other VM_LOCKED VMAs, without first isolating the page from the LRU.
-try_to_munlock() is a variant of try_to_unmap() and thus requires that the page
+page_mlock() is a variant of try_to_unmap() and thus requires that the page
 not be on an LRU list [more on these below].  However, the call to
-isolate_lru_page() could fail, in which case we couldn't try_to_munlock().  So,
+isolate_lru_page() could fail, in which case we can't call page_mlock().  So,
 we go ahead and clear PG_mlocked up front, as this might be the only chance we
-have.  If we can successfully isolate the page, we go ahead and
-try_to_munlock(), which will restore the PG_mlocked flag and update the zone
+have.  If we can successfully isolate the page, we go ahead and call
+page_mlock(), which will restore the PG_mlocked flag and update the zone
 page statistics if it finds another VMA holding the page mlocked.  If we fail
 to isolate the page, we'll have left a potentially mlocked page on the LRU.
 This is fine, because we'll catch it later if and if vmscan tries to reclaim
@@ -545,31 +545,24 @@ munlock or munmap system calls, mm teard
 holepunching, and truncation of file pages and their anonymous COWed pages.
 
 
-try_to_munlock() Reverse Map Scan
+page_mlock() Reverse Map Scan
 ---------------------------------
 
-.. warning::
-   [!] TODO/FIXME: a better name might be page_mlocked() - analogous to the
-   page_referenced() reverse map walker.
-
 When munlock_vma_page() [see section :ref:`munlock()/munlockall() System Call
 Handling <munlock_munlockall_handling>` above] tries to munlock a
 page, it needs to determine whether or not the page is mapped by any
 VM_LOCKED VMA without actually attempting to unmap all PTEs from the
 page.  For this purpose, the unevictable/mlock infrastructure
-introduced a variant of try_to_unmap() called try_to_munlock().
+introduced a variant of try_to_unmap() called page_mlock().
 
-try_to_munlock() calls the same functions as try_to_unmap() for anonymous and
-mapped file and KSM pages with a flag argument specifying unlock versus unmap
-processing.  Again, these functions walk the respective reverse maps looking
-for VM_LOCKED VMAs.  When such a VMA is found, as in the try_to_unmap() case,
-the functions mlock the page via mlock_vma_page() and return SWAP_MLOCK.  This
-undoes the pre-clearing of the page's PG_mlocked done by munlock_vma_page.
+page_mlock() walks the respective reverse maps looking for VM_LOCKED VMAs. When
+such a VMA is found the page is mlocked via mlock_vma_page(). This undoes the
+pre-clearing of the page's PG_mlocked done by munlock_vma_page.
 
-Note that try_to_munlock()'s reverse map walk must visit every VMA in a page's
+Note that page_mlock()'s reverse map walk must visit every VMA in a page's
 reverse map to determine that a page is NOT mapped into any VM_LOCKED VMA.
 However, the scan can terminate when it encounters a VM_LOCKED VMA.
-Although try_to_munlock() might be called a great many times when munlocking a
+Although page_mlock() might be called a great many times when munlocking a
 large region or tearing down a large address space that has been mlocked via
 mlockall(), overall this is a fairly rare event.
 
@@ -602,7 +595,7 @@ inactive lists to the appropriate node's
 shrink_inactive_list() should only see SHM_LOCK'd pages that became SHM_LOCK'd
 after shrink_active_list() had moved them to the inactive list, or pages mapped
 into VM_LOCKED VMAs that munlock_vma_page() couldn't isolate from the LRU to
-recheck via try_to_munlock().  shrink_inactive_list() won't notice the latter,
+recheck via page_mlock().  shrink_inactive_list() won't notice the latter,
 but will pass on to shrink_page_list().
 
 shrink_page_list() again culls obviously unevictable pages that it could
--- a/include/linux/rmap.h~mm-rmap-split-try_to_munlock-from-try_to_unmap
+++ a/include/linux/rmap.h
@@ -87,7 +87,6 @@ struct anon_vma_chain {
 
 enum ttu_flags {
 	TTU_MIGRATION		= 0x1,	/* migration mode */
-	TTU_MUNLOCK		= 0x2,	/* munlock mode */
 
 	TTU_SPLIT_HUGE_PMD	= 0x4,	/* split huge PMD if any */
 	TTU_IGNORE_MLOCK	= 0x8,	/* ignore mlock */
@@ -240,7 +239,7 @@ int page_mkclean(struct page *);
  * called in munlock()/munmap() path to check for other vmas holding
  * the page mlocked.
  */
-void try_to_munlock(struct page *);
+void page_mlock(struct page *page);
 
 void remove_migration_ptes(struct page *old, struct page *new, bool locked);
 
--- a/mm/mlock.c~mm-rmap-split-try_to_munlock-from-try_to_unmap
+++ a/mm/mlock.c
@@ -108,7 +108,7 @@ void mlock_vma_page(struct page *page)
 /*
  * Finish munlock after successful page isolation
  *
- * Page must be locked. This is a wrapper for try_to_munlock()
+ * Page must be locked. This is a wrapper for page_mlock()
  * and putback_lru_page() with munlock accounting.
  */
 static void __munlock_isolated_page(struct page *page)
@@ -118,7 +118,7 @@ static void __munlock_isolated_page(stru
 	 * and we don't need to check all the other vmas.
 	 */
 	if (page_mapcount(page) > 1)
-		try_to_munlock(page);
+		page_mlock(page);
 
 	/* Did try_to_unlock() succeed or punt? */
 	if (!PageMlocked(page))
@@ -158,7 +158,7 @@ static void __munlock_isolation_failed(s
  * munlock()ed or munmap()ed, we want to check whether other vmas hold the
  * page locked so that we can leave it on the unevictable lru list and not
  * bother vmscan with it.  However, to walk the page's rmap list in
- * try_to_munlock() we must isolate the page from the LRU.  If some other
+ * page_mlock() we must isolate the page from the LRU.  If some other
  * task has removed the page from the LRU, we won't be able to do that.
  * So we clear the PageMlocked as we might not get another chance.  If we
  * can't isolate the page, we leave it for putback_lru_page() and vmscan
@@ -168,7 +168,7 @@ unsigned int munlock_vma_page(struct pag
 {
 	int nr_pages;
 
-	/* For try_to_munlock() and to serialize with page migration */
+	/* For page_mlock() and to serialize with page migration */
 	BUG_ON(!PageLocked(page));
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
@@ -205,7 +205,7 @@ static int __mlock_posix_error_return(lo
  *
  * The fast path is available only for evictable pages with single mapping.
  * Then we can bypass the per-cpu pvec and get better performance.
- * when mapcount > 1 we need try_to_munlock() which can fail.
+ * when mapcount > 1 we need page_mlock() which can fail.
  * when !page_evictable(), we need the full redo logic of putback_lru_page to
  * avoid leaving evictable page in unevictable list.
  *
@@ -414,7 +414,7 @@ static unsigned long __munlock_pagevec_f
  *
  * We don't save and restore VM_LOCKED here because pages are
  * still on lru.  In unmap path, pages might be scanned by reclaim
- * and re-mlocked by try_to_{munlock|unmap} before we unmap and
+ * and re-mlocked by page_mlock/try_to_unmap before we unmap and
  * free them.  This will result in freeing mlocked pages.
  */
 void munlock_vma_pages_range(struct vm_area_struct *vma,
--- a/mm/rmap.c~mm-rmap-split-try_to_munlock-from-try_to_unmap
+++ a/mm/rmap.c
@@ -1411,10 +1411,6 @@ static bool try_to_unmap_one(struct page
 	if (flags & TTU_SYNC)
 		pvmw.flags = PVMW_SYNC;
 
-	/* munlock has nothing to gain from examining un-locked vmas */
-	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
-		return true;
-
 	if (IS_ENABLED(CONFIG_MIGRATION) && (flags & TTU_MIGRATION) &&
 	    is_zone_device_page(page) && !is_device_private_page(page))
 		return true;
@@ -1476,8 +1472,6 @@ static bool try_to_unmap_one(struct page
 				page_vma_mapped_walk_done(&pvmw);
 				break;
 			}
-			if (flags & TTU_MUNLOCK)
-				continue;
 		}
 
 		/* Unexpected PMD-mapped THP? */
@@ -1790,20 +1784,58 @@ void try_to_unmap(struct page *page, enu
 		rmap_walk(page, &rwc);
 }
 
+/*
+ * Walks the vma's mapping a page and mlocks the page if any locked vma's are
+ * found. Once one is found the page is locked and the scan can be terminated.
+ */
+static bool page_mlock_one(struct page *page, struct vm_area_struct *vma,
+				 unsigned long address, void *unused)
+{
+	struct page_vma_mapped_walk pvmw = {
+		.page = page,
+		.vma = vma,
+		.address = address,
+	};
+
+	/* An un-locked vma doesn't have any pages to lock, continue the scan */
+	if (!(vma->vm_flags & VM_LOCKED))
+		return true;
+
+	while (page_vma_mapped_walk(&pvmw)) {
+		/*
+		 * Need to recheck under the ptl to serialise with
+		 * __munlock_pagevec_fill() after VM_LOCKED is cleared in
+		 * munlock_vma_pages_range().
+		 */
+		if (vma->vm_flags & VM_LOCKED) {
+			/* PTE-mapped THP are never mlocked */
+			if (!PageTransCompound(page))
+				mlock_vma_page(page);
+			page_vma_mapped_walk_done(&pvmw);
+		}
+
+		/*
+		 * no need to continue scanning other vma's if the page has
+		 * been locked.
+		 */
+		return false;
+	}
+
+	return true;
+}
+
 /**
- * try_to_munlock - try to munlock a page
- * @page: the page to be munlocked
+ * page_mlock - try to mlock a page
+ * @page: the page to be mlocked
  *
- * Called from munlock code.  Checks all of the VMAs mapping the page
- * to make sure nobody else has this page mlocked. The page will be
- * returned with PG_mlocked cleared if no other vmas have it mlocked.
+ * Called from munlock code. Checks all of the VMAs mapping the page and mlocks
+ * the page if any are found. The page will be returned with PG_mlocked cleared
+ * if it is not mapped by any locked vmas.
  */
-
-void try_to_munlock(struct page *page)
+void page_mlock(struct page *page)
 {
 	struct rmap_walk_control rwc = {
-		.rmap_one = try_to_unmap_one,
-		.arg = (void *)TTU_MUNLOCK,
+		.rmap_one = page_mlock_one,
 		.done = page_not_mapped,
 		.anon_lock = page_lock_anon_vma_read,
 
@@ -1855,7 +1887,7 @@ static struct anon_vma *rmap_walk_anon_l
  * Find all the mappings of a page using the mapping pointer and the vma chains
  * contained in the anon_vma struct it points to.
  *
- * When called from try_to_munlock(), the mmap_lock of the mm containing the vma
+ * When called from page_mlock(), the mmap_lock of the mm containing the vma
  * where the page was found will be held for write.  So, we won't recheck
  * vm_flags for that VMA.  That should be OK, because that vma shouldn't be
  * LOCKED.
@@ -1908,7 +1940,7 @@ static void rmap_walk_anon(struct page *
  * Find all the mappings of a page using the mapping pointer and the vma chains
  * contained in the address_space struct it points to.
  *
- * When called from try_to_munlock(), the mmap_lock of the mm containing the vma
+ * When called from page_mlock(), the mmap_lock of the mm containing the vma
  * where the page was found will be held for write.  So, we won't recheck
  * vm_flags for that VMA.  That should be OK, because that vma shouldn't be
  * LOCKED.
_
