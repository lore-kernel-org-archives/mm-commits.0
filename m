Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1F7E936F2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244906AbjJDUXX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244929AbjJDUXH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:07 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE7E19B
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:03 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0B0C433C9;
        Wed,  4 Oct 2023 20:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450982;
        bh=P6ejuMf4iNRachi3wn6CSBk+0WKAVG8KXH1uXwZLgDA=;
        h=Date:To:From:Subject:From;
        b=xhHbWDuUENEUzeFndGHbaHzLgF6dWw3uT00L9rf59AlexuO8ENjB3uMEC0bYQsCqq
         p534augQxS5KCj0Yj8hUl/DrDxiPqv+aoSfSi692bsH9RRsERdpxcgOf2sbe9jkA7y
         ud/+iWLeIhJ56VqRrMwvYw4WIjbIcua7oEIxtQGA=
Date:   Wed, 04 Oct 2023 13:23:00 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        yosryahmed@google.com, willy@infradead.org, shy828301@gmail.com,
        ryan.roberts@arm.com, hughd@google.com, david@redhat.com,
        fengwei.yin@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-large-folio-when-large-folio-in-vm_locked-vma-range.patch removed from -mm tree
Message-Id: <20231004202302.8A0B0C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: handle large folio when large folio in VM_LOCKED VMA range
has been removed from the -mm tree.  Its filename was
     mm-handle-large-folio-when-large-folio-in-vm_locked-vma-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: mm: handle large folio when large folio in VM_LOCKED VMA range
Date: Mon, 18 Sep 2023 15:33:17 +0800

If large folio is in the range of VM_LOCKED VMA, it should be mlocked to
avoid being picked by page reclaim.  Which may split the large folio and
then mlock each pages again.

Mlock this kind of large folio to prevent them being picked by page
reclaim.

For the large folio which cross the boundary of VM_LOCKED VMA or not fully
mapped to VM_LOCKED VMA, we'd better not to mlock it.  So if the system is
under memory pressure, this kind of large folio will be split and the
pages ouf of VM_LOCKED VMA can be reclaimed.

Ideally, for large folio, we should mlock it when the large folio is fully
mapped to VMA and munlock it if any page are unmampped from VMA.  But it's
not easy to detect whether the large folio is fully mapped to VMA in some
cases (like add/remove rmap).  So we update mlock_vma_folio() and
munlock_vma_folio() to mlock/munlock the folio according to vma->vm_flags.
Let caller to decide whether they should call these two functions.

For add rmap, only mlock normal 4K folio and postpone large folio handling
to page reclaim phase.  It is possible to reuse page table iterator to
detect whether folio is fully mapped or not during page reclaim phase. 
For remove rmap, invoke munlock_vma_folio() to munlock folio unconditionly
because rmap makes folio not fully mapped to VMA.

Link: https://lkml.kernel.org/r/20230918073318.1181104-3-fengwei.yin@intel.com
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   23 +++++++++-------
 mm/rmap.c     |   66 ++++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 68 insertions(+), 21 deletions(-)

--- a/mm/internal.h~mm-handle-large-folio-when-large-folio-in-vm_locked-vma-range
+++ a/mm/internal.h
@@ -644,14 +644,10 @@ folio_within_vma(struct folio *folio, st
  * mlock is usually called at the end of page_add_*_rmap(), munlock at
  * the end of page_remove_rmap(); but new anon folios are managed by
  * folio_add_lru_vma() calling mlock_new_folio().
- *
- * @compound is used to include pmd mappings of THPs, but filter out
- * pte mappings of THPs, which cannot be consistently counted: a pte
- * mapping of the THP head cannot be distinguished by the page alone.
  */
 void mlock_folio(struct folio *folio);
 static inline void mlock_vma_folio(struct folio *folio,
-			struct vm_area_struct *vma, bool compound)
+				struct vm_area_struct *vma)
 {
 	/*
 	 * The VM_SPECIAL check here serves two purposes.
@@ -661,17 +657,24 @@ static inline void mlock_vma_folio(struc
 	 *    file->f_op->mmap() is using vm_insert_page(s), when VM_LOCKED may
 	 *    still be set while VM_SPECIAL bits are added: so ignore it then.
 	 */
-	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED) &&
-	    (compound || !folio_test_large(folio)))
+	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) == VM_LOCKED))
 		mlock_folio(folio);
 }
 
 void munlock_folio(struct folio *folio);
 static inline void munlock_vma_folio(struct folio *folio,
-			struct vm_area_struct *vma, bool compound)
+					struct vm_area_struct *vma)
 {
-	if (unlikely(vma->vm_flags & VM_LOCKED) &&
-	    (compound || !folio_test_large(folio)))
+	/*
+	 * munlock if the function is called. Ideally, we should only
+	 * do munlock if any page of folio is unmapped from VMA and
+	 * cause folio not fully mapped to VMA.
+	 *
+	 * But it's not easy to confirm that's the situation. So we
+	 * always munlock the folio and page reclaim will correct it
+	 * if it's wrong.
+	 */
+	if (unlikely(vma->vm_flags & VM_LOCKED))
 		munlock_folio(folio);
 }
 
--- a/mm/rmap.c~mm-handle-large-folio-when-large-folio-in-vm_locked-vma-range
+++ a/mm/rmap.c
@@ -798,6 +798,7 @@ struct folio_referenced_arg {
 	unsigned long vm_flags;
 	struct mem_cgroup *memcg;
 };
+
 /*
  * arg: folio_referenced_arg will be passed
  */
@@ -807,17 +808,33 @@ static bool folio_referenced_one(struct
 	struct folio_referenced_arg *pra = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int referenced = 0;
+	unsigned long start = address, ptes = 0;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
 
-		if ((vma->vm_flags & VM_LOCKED) &&
-		    (!folio_test_large(folio) || !pvmw.pte)) {
-			/* Restore the mlock which got missed */
-			mlock_vma_folio(folio, vma, !pvmw.pte);
-			page_vma_mapped_walk_done(&pvmw);
-			pra->vm_flags |= VM_LOCKED;
-			return false; /* To break the loop */
+		if (vma->vm_flags & VM_LOCKED) {
+			if (!folio_test_large(folio) || !pvmw.pte) {
+				/* Restore the mlock which got missed */
+				mlock_vma_folio(folio, vma);
+				page_vma_mapped_walk_done(&pvmw);
+				pra->vm_flags |= VM_LOCKED;
+				return false; /* To break the loop */
+			}
+			/*
+			 * For large folio fully mapped to VMA, will
+			 * be handled after the pvmw loop.
+			 *
+			 * For large folio cross VMA boundaries, it's
+			 * expected to be picked  by page reclaim. But
+			 * should skip reference of pages which are in
+			 * the range of VM_LOCKED vma. As page reclaim
+			 * should just count the reference of pages out
+			 * the range of VM_LOCKED vma.
+			 */
+			ptes++;
+			pra->mapcount--;
+			continue;
 		}
 
 		if (pvmw.pte) {
@@ -842,6 +859,23 @@ static bool folio_referenced_one(struct
 		pra->mapcount--;
 	}
 
+	if ((vma->vm_flags & VM_LOCKED) &&
+			folio_test_large(folio) &&
+			folio_within_vma(folio, vma)) {
+		unsigned long s_align, e_align;
+
+		s_align = ALIGN_DOWN(start, PMD_SIZE);
+		e_align = ALIGN_DOWN(start + folio_size(folio) - 1, PMD_SIZE);
+
+		/* folio doesn't cross page table boundary and fully mapped */
+		if ((s_align == e_align) && (ptes == folio_nr_pages(folio))) {
+			/* Restore the mlock which got missed */
+			mlock_vma_folio(folio, vma);
+			pra->vm_flags |= VM_LOCKED;
+			return false; /* To break the loop */
+		}
+	}
+
 	if (referenced)
 		folio_clear_idle(folio);
 	if (folio_test_clear_young(folio))
@@ -1254,7 +1288,14 @@ void page_add_anon_rmap(struct page *pag
 			  (folio_test_large(folio) && folio_entire_mapcount(folio) > 1)) &&
 			 PageAnonExclusive(page), folio);
 
-	mlock_vma_folio(folio, vma, compound);
+	/*
+	 * For large folio, only mlock it if it's fully mapped to VMA. It's
+	 * not easy to check whether the large folio is fully mapped to VMA
+	 * here. Only mlock normal 4K folio and leave page reclaim to handle
+	 * large folio.
+	 */
+	if (!folio_test_large(folio))
+		mlock_vma_folio(folio, vma);
 }
 
 /**
@@ -1354,7 +1395,9 @@ void folio_add_file_rmap_range(struct fo
 	if (nr)
 		__lruvec_stat_mod_folio(folio, NR_FILE_MAPPED, nr);
 
-	mlock_vma_folio(folio, vma, compound);
+	/* See comments in page_add_anon_rmap() */
+	if (!folio_test_large(folio))
+		mlock_vma_folio(folio, vma);
 }
 
 /**
@@ -1465,7 +1508,7 @@ void page_remove_rmap(struct page *page,
 	 * it's only reliable while mapped.
 	 */
 
-	munlock_vma_folio(folio, vma, compound);
+	munlock_vma_folio(folio, vma);
 }
 
 /*
@@ -1530,7 +1573,8 @@ static bool try_to_unmap_one(struct foli
 		if (!(flags & TTU_IGNORE_MLOCK) &&
 		    (vma->vm_flags & VM_LOCKED)) {
 			/* Restore the mlock which got missed */
-			mlock_vma_folio(folio, vma, false);
+			if (!folio_test_large(folio))
+				mlock_vma_folio(folio, vma);
 			page_vma_mapped_walk_done(&pvmw);
 			ret = false;
 			break;
_

Patches currently in -mm which might be from fengwei.yin@intel.com are


