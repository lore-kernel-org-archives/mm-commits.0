Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 917E7C43217
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbiEJEVa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiEJEUB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B768F2AC0FE
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C125B81AF2
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA1BC385C7;
        Tue, 10 May 2022 04:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156078;
        bh=6KSYEaGsvsNgW5wJ4VbSVOXU0Bo133sbY7K0SGuIxn4=;
        h=Date:To:From:Subject:From;
        b=kppwxeOSs6Ey+9qC6Su44SWHN+M0XLm2suMj4hl01w8AZtv4VX2Kd0Y68MNmDDLed
         1/R+Lcfi2A376MDphePn+Dc6O3LQjTU9cWCkqxuW0n7QoOqC8PSm6fJy++TJttvNJi
         3989Xr5qA2STK8sRqgm69szOmDia5CrxVKNDAUHY=
Date:   Mon, 09 May 2022 21:14:37 -0700
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
Subject: [merged mm-stable] mm-rmap-remove-do_page_add_anon_rmap.patch removed from -mm tree
Message-Id: <20220510041438.0BA1BC385C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rmap: remove do_page_add_anon_rmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-remove-do_page_add_anon_rmap.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: remove do_page_add_anon_rmap()

... and instead convert page_add_anon_rmap() to accept flags.

Passing flags instead of bools is usually nicer either way, and we want to
more often also pass RMAP_EXCLUSIVE in follow up patches when detecting
that an anonymous page is exclusive: for example, when restoring an
anonymous page from a writable migration entry.

This is a preparation for marking an anonymous page inside
page_add_anon_rmap() as exclusive when RMAP_EXCLUSIVE is passed.

Link: https://lkml.kernel.org/r/20220428083441.37290-7-david@redhat.com
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

 include/linux/rmap.h |    2 --
 mm/huge_memory.c     |    2 +-
 mm/ksm.c             |    2 +-
 mm/memory.c          |    4 ++--
 mm/migrate.c         |    3 ++-
 mm/rmap.c            |   14 +-------------
 mm/swapfile.c        |    2 +-
 7 files changed, 8 insertions(+), 21 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-remove-do_page_add_anon_rmap
+++ a/include/linux/rmap.h
@@ -183,8 +183,6 @@ typedef int __bitwise rmap_t;
  */
 void page_move_anon_rmap(struct page *, struct vm_area_struct *);
 void page_add_anon_rmap(struct page *, struct vm_area_struct *,
-		unsigned long address, bool compound);
-void do_page_add_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
 void page_add_new_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address, bool compound);
--- a/mm/huge_memory.c~mm-rmap-remove-do_page_add_anon_rmap
+++ a/mm/huge_memory.c
@@ -3077,7 +3077,7 @@ void remove_migration_pmd(struct page_vm
 		pmde = pmd_wrprotect(pmd_mkuffd_wp(pmde));
 
 	if (PageAnon(new))
-		page_add_anon_rmap(new, vma, mmun_start, true);
+		page_add_anon_rmap(new, vma, mmun_start, RMAP_COMPOUND);
 	else
 		page_add_file_rmap(new, vma, true);
 	set_pmd_at(mm, mmun_start, pvmw->pmd, pmde);
--- a/mm/ksm.c~mm-rmap-remove-do_page_add_anon_rmap
+++ a/mm/ksm.c
@@ -1156,7 +1156,7 @@ static int replace_page(struct vm_area_s
 	 */
 	if (!is_zero_pfn(page_to_pfn(kpage))) {
 		get_page(kpage);
-		page_add_anon_rmap(kpage, vma, addr, false);
+		page_add_anon_rmap(kpage, vma, addr, RMAP_NONE);
 		newpte = mk_pte(kpage, vma->vm_page_prot);
 	} else {
 		newpte = pte_mkspecial(pfn_pte(page_to_pfn(kpage),
--- a/mm/memory.c~mm-rmap-remove-do_page_add_anon_rmap
+++ a/mm/memory.c
@@ -725,7 +725,7 @@ static void restore_exclusive_pte(struct
 	 * created when the swap entry was made.
 	 */
 	if (PageAnon(page))
-		page_add_anon_rmap(page, vma, address, false);
+		page_add_anon_rmap(page, vma, address, RMAP_NONE);
 	else
 		/*
 		 * Currently device exclusive access only supports anonymous
@@ -3705,7 +3705,7 @@ vm_fault_t do_swap_page(struct vm_fault
 		page_add_new_anon_rmap(page, vma, vmf->address, false);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	} else {
-		do_page_add_anon_rmap(page, vma, vmf->address, rmap_flags);
+		page_add_anon_rmap(page, vma, vmf->address, rmap_flags);
 	}
 
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, pte);
--- a/mm/migrate.c~mm-rmap-remove-do_page_add_anon_rmap
+++ a/mm/migrate.c
@@ -240,7 +240,8 @@ static bool remove_migration_pte(struct
 #endif
 		{
 			if (folio_test_anon(folio))
-				page_add_anon_rmap(new, vma, pvmw.address, false);
+				page_add_anon_rmap(new, vma, pvmw.address,
+						   RMAP_NONE);
 			else
 				page_add_file_rmap(new, vma, false);
 			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
--- a/mm/rmap.c~mm-rmap-remove-do_page_add_anon_rmap
+++ a/mm/rmap.c
@@ -1171,7 +1171,7 @@ static void __page_check_anon_rmap(struc
  * @page:	the page to add the mapping to
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
- * @compound:	charge the page as compound or small page
+ * @flags:	the rmap flags
  *
  * The caller needs to hold the pte lock, and the page must be locked in
  * the anon_vma case: to serialize mapping,index checking after setting,
@@ -1179,18 +1179,6 @@ static void __page_check_anon_rmap(struc
  * (but PageKsm is never downgraded to PageAnon).
  */
 void page_add_anon_rmap(struct page *page,
-	struct vm_area_struct *vma, unsigned long address, bool compound)
-{
-	do_page_add_anon_rmap(page, vma, address,
-			      compound ? RMAP_COMPOUND : RMAP_NONE);
-}
-
-/*
- * Special version of the above for do_swap_page, which often runs
- * into pages that are exclusively owned by the current process.
- * Everybody else should continue to use page_add_anon_rmap above.
- */
-void do_page_add_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address, rmap_t flags)
 {
 	bool compound = flags & RMAP_COMPOUND;
--- a/mm/swapfile.c~mm-rmap-remove-do_page_add_anon_rmap
+++ a/mm/swapfile.c
@@ -1800,7 +1800,7 @@ static int unuse_pte(struct vm_area_stru
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
 	get_page(page);
 	if (page == swapcache) {
-		page_add_anon_rmap(page, vma, addr, false);
+		page_add_anon_rmap(page, vma, addr, RMAP_NONE);
 	} else { /* ksm created a completely new copy */
 		page_add_new_anon_rmap(page, vma, addr, false);
 		lru_cache_add_inactive_or_unevictable(page, vma);
_

Patches currently in -mm which might be from david@redhat.com are


