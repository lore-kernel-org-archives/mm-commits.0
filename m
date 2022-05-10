Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A83CC4167D
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbiEJEV2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236222AbiEJEUB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157FF23AE5B
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4FBFB81AE7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC99C385C7;
        Tue, 10 May 2022 04:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156075;
        bh=D6rpwUR679NkbajtazEWFWnVF16mX0wJXo5jz+ykl8E=;
        h=Date:To:From:Subject:From;
        b=QcCANqO/OaJZ/2SAbM4v/91zTKW2Z4SILcGNJBwWK2B7QpBWzjlMqn8xuWlLthA/u
         451l6BtXMdzBc8ZPNMx2U6/doJTUOMu+maWjDxSJupUIF7bI09rJsNr7KAy4UJR0Hu
         sRXVSv48iqjoFp4MH6C9Fhi//rz7lNSqhh6Nqzz4=
Date:   Mon, 09 May 2022 21:14:34 -0700
To:     mm-commits@vger.kernel.org, zhangliang5@huawei.com,
        willy@infradead.org, vbabka@suse.cz, shy828301@gmail.com,
        shakeelb@google.com, rppt@linux.ibm.com, rientjes@google.com,
        riel@surriel.com, peterx@redhat.com, pedrodemargomes@gmail.com,
        oleg@redhat.com, oded.gabbay@gmail.com, namit@vmware.com,
        mike.kravetz@oracle.com, mhocko@kernel.org,
        kirill.shutemov@linux.intel.com, khalid.aziz@oracle.com,
        jhubbard@nvidia.com, jgg@nvidia.com, jannh@google.com,
        jack@suse.cz, hughd@google.com, hch@lst.de, guro@fb.com,
        ddutile@redhat.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap.patch removed from -mm tree
Message-Id: <20220510041435.4FC99C385C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()

...  and move the special check for pinned pages into
page_try_dup_anon_rmap() to prepare for tracking exclusive anonymous pages
via a new pageflag, clearing it only after making sure that there are no
GUP pins on the anonymous page.

We really only care about pins on anonymous pages, because they are prone
to getting replaced in the COW handler once mapped R/O.  For !anon pages
in cow-mappings (!VM_SHARED && VM_MAYWRITE) we shouldn't really care about
that, at least not that I could come up with an example.

Let's drop the is_cow_mapping() check from page_needs_cow_for_dma(), as we
know we're dealing with anonymous pages.  Also, drop the handling of
pinned pages from copy_huge_pud() and add a comment if ever supporting
anonymous pages on the PUD level.

This is a preparation for tracking exclusivity of anonymous pages in the
rmap code, and disallowing marking a page shared (-> failing to duplicate)
if there are GUP pins on a page.

Link: https://lkml.kernel.org/r/20220428083441.37290-5-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Don Dutile <ddutile@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Khalid Aziz <khalid.aziz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Liang Zhang <zhangliang5@huawei.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nadav Amit <namit@vmware.com>
Cc: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h   |    5 ----
 include/linux/rmap.h |   49 ++++++++++++++++++++++++++++++++++++++++-
 mm/huge_memory.c     |   27 ++++++----------------
 mm/hugetlb.c         |   16 +++++++------
 mm/memory.c          |   17 ++++++++++----
 mm/migrate.c         |    2 -
 6 files changed, 79 insertions(+), 37 deletions(-)

--- a/include/linux/mm.h~mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap
+++ a/include/linux/mm.h
@@ -1575,16 +1575,13 @@ static inline bool page_maybe_dma_pinned
 
 /*
  * This should most likely only be called during fork() to see whether we
- * should break the cow immediately for a page on the src mm.
+ * should break the cow immediately for an anon page on the src mm.
  *
  * The caller has to hold the PT lock and the vma->vm_mm->->write_protect_seq.
  */
 static inline bool page_needs_cow_for_dma(struct vm_area_struct *vma,
 					  struct page *page)
 {
-	if (!is_cow_mapping(vma->vm_flags))
-		return false;
-
 	VM_BUG_ON(!(raw_read_seqcount(&vma->vm_mm->write_protect_seq) & 1));
 
 	if (!test_bit(MMF_HAS_PINNED, &vma->vm_mm->flags))
--- a/include/linux/rmap.h~mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap
+++ a/include/linux/rmap.h
@@ -12,6 +12,7 @@
 #include <linux/memcontrol.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/memremap.h>
 
 /*
  * The anon_vma heads a list of private "related" vmas, to scan if
@@ -182,11 +183,57 @@ void hugepage_add_anon_rmap(struct page
 void hugepage_add_new_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address);
 
-static inline void page_dup_rmap(struct page *page, bool compound)
+static inline void __page_dup_rmap(struct page *page, bool compound)
 {
 	atomic_inc(compound ? compound_mapcount_ptr(page) : &page->_mapcount);
 }
 
+static inline void page_dup_file_rmap(struct page *page, bool compound)
+{
+	__page_dup_rmap(page, compound);
+}
+
+/**
+ * page_try_dup_anon_rmap - try duplicating a mapping of an already mapped
+ *			    anonymous page
+ * @page: the page to duplicate the mapping for
+ * @compound: the page is mapped as compound or as a small page
+ * @vma: the source vma
+ *
+ * The caller needs to hold the PT lock and the vma->vma_mm->write_protect_seq.
+ *
+ * Duplicating the mapping can only fail if the page may be pinned; device
+ * private pages cannot get pinned and consequently this function cannot fail.
+ *
+ * If duplicating the mapping succeeds, the page has to be mapped R/O into
+ * the parent and the child. It must *not* get mapped writable after this call.
+ *
+ * Returns 0 if duplicating the mapping succeeded. Returns -EBUSY otherwise.
+ */
+static inline int page_try_dup_anon_rmap(struct page *page, bool compound,
+					 struct vm_area_struct *vma)
+{
+	VM_BUG_ON_PAGE(!PageAnon(page), page);
+
+	/*
+	 * If this page may have been pinned by the parent process,
+	 * don't allow to duplicate the mapping but instead require to e.g.,
+	 * copy the page immediately for the child so that we'll always
+	 * guarantee the pinned page won't be randomly replaced in the
+	 * future on write faults.
+	 */
+	if (likely(!is_device_private_page(page) &&
+	    unlikely(page_needs_cow_for_dma(vma, page))))
+		return -EBUSY;
+
+	/*
+	 * It's okay to share the anon page between both processes, mapping
+	 * the page R/O into both processes.
+	 */
+	__page_dup_rmap(page, compound);
+	return 0;
+}
+
 /*
  * Called from mm/vmscan.c to handle paging out
  */
--- a/mm/huge_memory.c~mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap
+++ a/mm/huge_memory.c
@@ -1097,23 +1097,16 @@ int copy_huge_pmd(struct mm_struct *dst_
 	src_page = pmd_page(pmd);
 	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
 
-	/*
-	 * If this page is a potentially pinned page, split and retry the fault
-	 * with smaller page size.  Normally this should not happen because the
-	 * userspace should use MADV_DONTFORK upon pinned regions.  This is a
-	 * best effort that the pinned pages won't be replaced by another
-	 * random page during the coming copy-on-write.
-	 */
-	if (unlikely(page_needs_cow_for_dma(src_vma, src_page))) {
+	get_page(src_page);
+	if (unlikely(page_try_dup_anon_rmap(src_page, true, src_vma))) {
+		/* Page maybe pinned: split and retry the fault on PTEs. */
+		put_page(src_page);
 		pte_free(dst_mm, pgtable);
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
 		__split_huge_pmd(src_vma, src_pmd, addr, false, NULL);
 		return -EAGAIN;
 	}
-
-	get_page(src_page);
-	page_dup_rmap(src_page, true);
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
@@ -1217,14 +1210,10 @@ int copy_huge_pud(struct mm_struct *dst_
 		/* No huge zero pud yet */
 	}
 
-	/* Please refer to comments in copy_huge_pmd() */
-	if (unlikely(page_needs_cow_for_dma(vma, pud_page(pud)))) {
-		spin_unlock(src_ptl);
-		spin_unlock(dst_ptl);
-		__split_huge_pud(vma, src_pud, addr);
-		return -EAGAIN;
-	}
-
+	/*
+	 * TODO: once we support anonymous pages, use page_try_dup_anon_rmap()
+	 * and split if duplicating fails.
+	 */
 	pudp_set_wrprotect(src_mm, addr, src_pud);
 	pud = pud_mkold(pud_wrprotect(pud));
 	set_pud_at(dst_mm, addr, dst_pud, pud);
--- a/mm/hugetlb.c~mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap
+++ a/mm/hugetlb.c
@@ -4806,15 +4806,18 @@ again:
 			get_page(ptepage);
 
 			/*
-			 * This is a rare case where we see pinned hugetlb
-			 * pages while they're prone to COW.  We need to do the
-			 * COW earlier during fork.
+			 * Failing to duplicate the anon rmap is a rare case
+			 * where we see pinned hugetlb pages while they're
+			 * prone to COW. We need to do the COW earlier during
+			 * fork.
 			 *
 			 * When pre-allocating the page or copying data, we
 			 * need to be without the pgtable locks since we could
 			 * sleep during the process.
 			 */
-			if (unlikely(page_needs_cow_for_dma(vma, ptepage))) {
+			if (!PageAnon(ptepage)) {
+				page_dup_file_rmap(ptepage, true);
+			} else if (page_try_dup_anon_rmap(ptepage, true, vma)) {
 				pte_t src_pte_old = entry;
 				struct page *new;
 
@@ -4861,7 +4864,6 @@ again:
 				entry = huge_pte_wrprotect(entry);
 			}
 
-			page_dup_rmap(ptepage, true);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
 			hugetlb_count_add(npages, dst);
 		}
@@ -5541,7 +5543,7 @@ retry:
 		ClearHPageRestoreReserve(page);
 		hugepage_add_new_anon_rmap(page, vma, haddr);
 	} else
-		page_dup_rmap(page, true);
+		page_dup_file_rmap(page, true);
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
 	set_huge_pte_at(mm, haddr, ptep, new_pte);
@@ -5902,7 +5904,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_s
 		goto out_release_unlock;
 
 	if (vm_shared) {
-		page_dup_rmap(page, true);
+		page_dup_file_rmap(page, true);
 	} else {
 		ClearHPageRestoreReserve(page);
 		hugepage_add_new_anon_rmap(page, dst_vma, dst_addr);
--- a/mm/memory.c~mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap
+++ a/mm/memory.c
@@ -825,7 +825,8 @@ copy_nonpresent_pte(struct mm_struct *ds
 		 */
 		get_page(page);
 		rss[mm_counter(page)]++;
-		page_dup_rmap(page, false);
+		/* Cannot fail as these pages cannot get pinned. */
+		BUG_ON(page_try_dup_anon_rmap(page, false, src_vma));
 
 		/*
 		 * We do not preserve soft-dirty information, because so
@@ -921,18 +922,24 @@ copy_present_pte(struct vm_area_struct *
 	struct page *page;
 
 	page = vm_normal_page(src_vma, addr, pte);
-	if (page && unlikely(page_needs_cow_for_dma(src_vma, page))) {
+	if (page && PageAnon(page)) {
 		/*
 		 * If this page may have been pinned by the parent process,
 		 * copy the page immediately for the child so that we'll always
 		 * guarantee the pinned page won't be randomly replaced in the
 		 * future.
 		 */
-		return copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
-					 addr, rss, prealloc, page);
+		get_page(page);
+		if (unlikely(page_try_dup_anon_rmap(page, false, src_vma))) {
+			/* Page maybe pinned, we have to copy. */
+			put_page(page);
+			return copy_present_page(dst_vma, src_vma, dst_pte, src_pte,
+						 addr, rss, prealloc, page);
+		}
+		rss[mm_counter(page)]++;
 	} else if (page) {
 		get_page(page);
-		page_dup_rmap(page, false);
+		page_dup_file_rmap(page, false);
 		rss[mm_counter(page)]++;
 	}
 
--- a/mm/migrate.c~mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap
+++ a/mm/migrate.c
@@ -234,7 +234,7 @@ static bool remove_migration_pte(struct
 			if (folio_test_anon(folio))
 				hugepage_add_anon_rmap(new, vma, pvmw.address);
 			else
-				page_dup_rmap(new, true);
+				page_dup_file_rmap(new, true);
 			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 		} else
 #endif
_

Patches currently in -mm which might be from david@redhat.com are


