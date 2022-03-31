Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9CBC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbiCaEew (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiCaEer (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:34:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9945A5A8
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19E0961416
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670DDC340ED;
        Thu, 31 Mar 2022 04:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701174;
        bh=PKqb+Uz2nl9FSGBFg61ohAz4zjb1pdBIMxRorkNDKKo=;
        h=Date:To:From:Subject:From;
        b=SK1Kc9Dwb2PwbyLSSYWro0pipSYoWbMY58M8IhH9lpnBWOz/RvywBh2aAKkdFGR3b
         t3IJAfVA64dBeiTVpEyk3nWon8wrWgZlewUi/mxUCsjKiA3o4h9rVV+tLiAA/mzJD4
         TZ8pWXxDzQh2SF8zad9p6I7f5Z7Qu070bBmLagio=
Date:   Wed, 30 Mar 2022 21:32:53 -0700
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
Subject: + mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch added to -mm tree
Message-Id: <20220331043254.670DDC340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: drop "compound" parameter from page_add_new_anon_rmap()
has been added to the -mm tree.  Its filename is
     mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: drop "compound" parameter from page_add_new_anon_rmap()

New anonymous pages are always mapped natively: only THP/khugepagd code
maps a new compound anonymous page and passes "true".  Otherwise, we're
just dealing with simple, non-compound pages.

Let's give the interface clearer semantics and document these.

Link: https://lkml.kernel.org/r/20220329160440.193848-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
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
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h    |    3 ++-
 kernel/events/uprobes.c |    2 +-
 mm/huge_memory.c        |    2 +-
 mm/khugepaged.c         |    2 +-
 mm/memory.c             |   10 +++++-----
 mm/migrate_device.c     |    2 +-
 mm/rmap.c               |    9 ++++++---
 mm/swapfile.c           |    2 +-
 mm/userfaultfd.c        |    2 +-
 9 files changed, 19 insertions(+), 15 deletions(-)

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
@@ -3698,7 +3698,7 @@ vm_fault_t do_swap_page(struct vm_fault
 
 	/* ksm created a completely new copy */
 	if (unlikely(page != swapcache && swapcache)) {
-		page_add_new_anon_rmap(page, vma, vmf->address, false);
+		page_add_new_anon_rmap(page, vma, vmf->address);
 		lru_cache_add_inactive_or_unevictable(page, vma);
 	} else {
 		page_add_anon_rmap(page, vma, vmf->address, rmap_flags);
@@ -3848,7 +3848,7 @@ static vm_fault_t do_anonymous_page(stru
 	}
 
 	inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
-	page_add_new_anon_rmap(page, vma, vmf->address, false);
+	page_add_new_anon_rmap(page, vma, vmf->address);
 	lru_cache_add_inactive_or_unevictable(page, vma);
 setpte:
 	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
@@ -4035,7 +4035,7 @@ void do_set_pte(struct vm_fault *vmf, st
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
@@ -1182,19 +1182,22 @@ void page_add_anon_rmap(struct page *pag
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

mm-rmap-fix-missing-swap_free-in-try_to_unmap-after-arch_unmap_one-failed.patch
mm-hugetlb-take-src_mm-write_protect_seq-in-copy_hugetlb_page_range.patch
mm-memory-slightly-simplify-copy_present_pte.patch
mm-rmap-split-page_dup_rmap-into-page_dup_file_rmap-and-page_try_dup_anon_rmap.patch
mm-rmap-convert-rmap-flags-to-a-proper-distinct-rmap_t-type.patch
mm-rmap-remove-do_page_add_anon_rmap.patch
mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch
mm-rmap-drop-compound-parameter-from-page_add_new_anon_rmap.patch
mm-rmap-use-page_move_anon_rmap-when-reusing-a-mapped-pageanon-page-exclusively.patch
mm-huge_memory-remove-outdated-vm_warn_on_once_page-from-unmap_page.patch
mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages.patch
mm-remember-exclusively-mapped-anonymous-pages-with-pg_anon_exclusive.patch
mm-gup-disallow-follow_pagefoll_pin.patch
mm-support-gup-triggered-unsharing-of-anonymous-pages.patch
mm-gup-trigger-fault_flag_unshare-when-r-o-pinning-a-possibly-shared-anonymous-page.patch
mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch
mm-swap-remember-pg_anon_exclusive-via-a-swp-pte-bit.patch
mm-debug_vm_pgtable-add-tests-for-__have_arch_pte_swp_exclusive.patch
x86-pgtable-support-__have_arch_pte_swp_exclusive.patch
arm64-pgtable-support-__have_arch_pte_swp_exclusive.patch
s390-pgtable-cleanup-description-of-swp-pte-layout.patch
s390-pgtable-support-__have_arch_pte_swp_exclusive.patch
powerpc-pgtable-remove-_page_bit_swap_type-for-book3s.patch
powerpc-pgtable-support-__have_arch_pte_swp_exclusive-for-book3s.patch

