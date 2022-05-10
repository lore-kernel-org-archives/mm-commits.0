Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84EFC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:16:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233199AbiEJEUn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236174AbiEJET6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:19:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C075E2AC0FF
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E6176175C
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD59C385C5;
        Tue, 10 May 2022 04:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156080;
        bh=GzaLMJmK56DQulOhEg8UiH0h/iz1Mrl44gkx321Z//I=;
        h=Date:To:From:Subject:From;
        b=zSN11cCANGBYJPgGdos0s4moaeknaKCjUy8tdEn5IMxHDLF3ou2TrDzCjy8Hwm/0t
         +j1V0YUeC6BYMjrkZ7aRgAe9JEfcGuO3KMm+scXL2/iaY+BB5Ronkx+S0IvXc5tu2x
         WKVLZ0DUCp/yrUeBPpsY+fR425Sa9BDEssap+IMs=
Date:   Mon, 09 May 2022 21:14:40 -0700
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
Subject: [merged mm-stable] mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch removed from -mm tree
Message-Id: <20220510041440.ACD59C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: drop "compound" parameter from page_add_new_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: drop "compound" parameter from page_add_new_anon_rmap()

New anonymous pages are always mapped natively: only THP/khugepaged code
maps a new compound anonymous page and passes "true".  Otherwise, we're
just dealing with simple, non-compound pages.

Let's give the interface clearer semantics and document these.  Remove the
PageTransCompound() sanity check from page_add_new_anon_rmap().

Link: https://lkml.kernel.org/r/20220428083441.37290-9-david@redhat.com
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

 include/linux/rmap.h    |    3 ++-
 kernel/events/uprobes.c |    2 +-
 mm/huge_memory.c        |    2 +-
 mm/khugepaged.c         |    2 +-
 mm/memory.c             |   10 +++++-----
 mm/migrate_device.c     |    2 +-
 mm/rmap.c               |   11 ++++++-----
 mm/swapfile.c           |    2 +-
 mm/userfaultfd.c        |    2 +-
 9 files changed, 19 insertions(+), 17 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap
+++ a/include/linux/rmap.h
@@ -185,11 +185,12 @@ void page_move_anon_rmap(struct page *,
 void page_add_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *,
-		unsigned long address, bool compound);
+		unsigned long address);
 void page_add_file_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
 void page_remove_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
+
 void hugepage_add_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
 void hugepage_add_new_anon_rmap(struct page *, struct vm_area_struct *,
--- a/kernel/events/uprobes.c~mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap
+++ a/kernel/events/uprobes.c
@@ -180,7 +180,7 @@ static int __replace_page(struct vm_area
 
 	if (new_page) {
 		get_page(new_page);
-		page_add_new_anon_rmap(new_page, vma, addr, false);
+		page_add_new_anon_rmap(new_page, vma, addr);
 		lru_cache_add_inactive_or_unevictable(new_page, vma);
 	} else
 		/* no new page, just dec_mm_counter for old_page */
--- a/mm/huge_memory.c~mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap
+++ a/mm/huge_memory.c
@@ -647,7 +647,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		page_add_new_anon_rmap(page, vma, haddr, true);
+		page_add_new_anon_rmap(page, vma, haddr);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
--- a/mm/khugepaged.c~mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap
+++ a/mm/khugepaged.c
@@ -1183,7 +1183,7 @@ static void collapse_huge_page(struct mm
 
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
-	page_add_new_anon_rmap(new_page, vma, address, true);
+	page_add_new_anon_rmap(new_page, vma, address);
 	lru_cache_add_inactive_or_unevictable(new_page, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, address, pmd, _pmd);
--- a/mm/memory.c~mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap
+++ a/mm/memory.c
@@ -893,7 +893,7 @@ copy_present_page(struct vm_area_struct
 	*prealloc = NULL;
 	copy_user_highpage(new_page, page, addr, src_vma);
 	__SetPageUptodate(new_page);
-	page_add_new_anon_rmap(new_page, dst_vma, addr, false);
+	page_add_new_anon_rmap(new_page, dst_vma, addr);
 	lru_cache_add_inactive_or_unevictable(new_page, dst_vma);
 	rss[mm_counter(new_page)]++;
 
@@ -3058,7 +3058,7 @@ static vm_fault_t wp_page_copy(struct vm
 		 * some TLBs while the old PTE remains in others.
 		 */
 		ptep_clear_flush_notify(vma, vmf->address, vmf->pte);
-		page_add_new_anon_rmap(new_page, vma, vmf->address, false);
+		page_add_new_anon_rmap(new_page, vma, vmf->address);
 		lru_cache_add_inactive_or_unevictable(new_page, vma);
 		/*
 		 * We call the notify macro here because, when using secondary
@@ -3702,7 +3702,7 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	/* ksm created a completely new copy */
 	if (unlikely(page != swapcache && swapcache)) {
-		page_add_new_anon_rmap(page, vma, vmf->address, false);
+		page_add_new_anon_rmap(page, vma, vmf->address);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	} else {
 		page_add_anon_rmap(page, vma, vmf->address, rmap_flags);
@@ -3852,7 +3852,7 @@ static vm_fault_t do_anonymous_page(stru
 	}
 
 	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, vma, vmf->address, false);
+	page_add_new_anon_rmap(page, vma, vmf->address);
 	lru_cache_add_inactive_or_unevictable(page, vma);
 setpte:
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
@@ -4039,7 +4039,7 @@ void do_set_pte(struct vm_fault *vmf, st
 	/* copy-on-write page */
 	if (write && !(vma->vm_flags & VM_SHARED)) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
-		page_add_new_anon_rmap(page, vma, addr, false);
+		page_add_new_anon_rmap(page, vma, addr);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	} else {
 		inc_mm_counter_fast(vma->vm_mm, mm_counter_file(page));
--- a/mm/migrate_device.c~mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap
+++ a/mm/migrate_device.c
@@ -610,7 +610,7 @@ static void migrate_vma_insert_page(stru
 		goto unlock_abort;
 
 	inc_mm_counter(mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, vma, addr, false);
+	page_add_new_anon_rmap(page, vma, addr);
 	if (!is_zone_device_page(page))
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	get_page(page);
--- a/mm/rmap.c~mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap
+++ a/mm/rmap.c
@@ -1226,19 +1226,22 @@ void page_add_anon_rmap(struct page *pag
 }
 
 /**
- * page_add_new_anon_rmap - add pte mapping to a new anonymous page
+ * page_add_new_anon_rmap - add mapping to a new anonymous page
  * @page:	the page to add the mapping to
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
- * @compound:	charge the page as compound or small page
+ *
+ * If it's a compound page, it is accounted as a compound page. As the page
+ * is new, it's assume to get mapped exclusively by a single process.
  *
  * Same as page_add_anon_rmap but must only be called on *new* pages.
  * This means the inc-and-test can be bypassed.
  * Page does not have to be locked.
  */
 void page_add_new_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address, bool compound)
+	struct vm_area_struct *vma, unsigned long address)
 {
+	const bool compound = PageCompound(page);
 	int nr = compound ? thp_nr_pages(page) : 1;
 
 	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
@@ -1251,8 +1254,6 @@ void page_add_new_anon_rmap(struct page
 
 		__mod_lruvec_page_state(page, NR_ANON_THPS, nr);
 	} else {
-		/* Anon THP always mapped first with PMD */
-		VM_BUG_ON_PAGE(PageTransCompound(page), page);
 		/* increment count (starts at -1) */
 		atomic_set(&page->_mapcount, 0);
 	}
--- a/mm/swapfile.c~mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap
+++ a/mm/swapfile.c
@@ -1802,7 +1802,7 @@ static int unuse_pte(struct vm_area_stru
 	if (page == swapcache) {
 		page_add_anon_rmap(page, vma, addr, RMAP_NONE);
 	} else { /* ksm created a completely new copy */
-		page_add_new_anon_rmap(page, vma, addr, false);
+		page_add_new_anon_rmap(page, vma, addr);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	}
 	set_pte_at(vma->vm_mm, addr, pte,
--- a/mm/userfaultfd.c~mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap
+++ a/mm/userfaultfd.c
@@ -104,7 +104,7 @@ int mfill_atomic_install_pte(struct mm_s
 			lru_cache_add(page);
 		page_add_file_rmap(page, dst_vma, false);
 	} else {
-		page_add_new_anon_rmap(page, dst_vma, dst_addr, false);
+		page_add_new_anon_rmap(page, dst_vma, dst_addr);
 		lru_cache_add_inactive_or_unevictable(page, dst_vma);
 	}
 
_

Patches currently in -mm which might be from david@redhat.com are


