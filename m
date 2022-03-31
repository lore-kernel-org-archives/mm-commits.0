Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B86C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiCaEfJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiCaEew (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0345A178
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:33:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE7A56147D
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:33:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E392C340ED;
        Thu, 31 Mar 2022 04:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701183;
        bh=uYa0NmHZHFyv5gmBV08lykVts5MxsFP03tosUr/j0sw=;
        h=Date:To:From:Subject:From;
        b=Do3vxdzKo5a9e9pnED5APNEEDFpLMYfdzl82WRDUis9r2JDW3OYq+RSB3tYZWgEdo
         zIbpleJ2EaomLA+x5oM5raQGCkg+/HXiN1xUL58w8psvP5gb6+2XbmYRNWbgWWkZ1v
         0KrDwMhLwFLowqEcPDx2KAa9ZEkAZEO2iI25a8A4=
Date:   Wed, 30 Mar 2022 21:33:02 -0700
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
Subject: + mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages.patch added to -mm tree
Message-Id: <20220331043303.3E392C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-flags: reuse PG_mappedtodisk as PG_anon_exclusive for PageAnon() pages
has been added to the -mm tree.  Its filename is
     mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages.patch

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
Subject: mm/page-flags: reuse PG_mappedtodisk as PG_anon_exclusive for PageAnon() pages

The basic question we would like to have a reliable and efficient answer
to is: is this anonymous page exclusive to a single process or might it be
shared?  We need that information for ordinary/single pages, hugetlb
pages, and possibly each subpage of a THP.

Introduce a way to mark an anonymous page as exclusive, with the ultimate
goal of teaching our COW logic to not do "wrong COWs", whereby GUP pins
lose consistency with the pages mapped into the page table, resulting in
reported memory corruptions.

Most pageflags already have semantics for anonymous pages, however,
PG_mappedtodisk should never apply to pages in the swapcache, so let's
reuse that flag.

As PG_has_hwpoisoned also uses that flag on the second tail page of a
compound page, convert it to PG_error instead, which is marked as
PF_NO_TAIL, so never used for tail pages.

Use custom page flag modification functions such that we can do additional
sanity checks.  The semantics we'll put into some kernel doc in the future
are:

"
  PG_anon_exclusive is *usually* only expressive in combination with a
  page table entry. Depending on the page table entry type it might
  store the following information:

       Is what's mapped via this page table entry exclusive to the
       single process and can be mapped writable without further
       checks? If not, it might be shared and we might have to COW.

  For now, we only expect PTE-mapped THPs to make use of
  PG_anon_exclusive in subpages. For other anonymous compound
  folios (i.e., hugetlb), only the head page is logically mapped and
  holds this information.

  For example, an exclusive, PMD-mapped THP only has PG_anon_exclusive
  set on the head page. When replacing the PMD by a page table full
  of PTEs, PG_anon_exclusive, if set on the head page, will be set on
  all tail pages accordingly. Note that converting from a PTE-mapping
  to a PMD mapping using the same compound page is currently not
  possible and consequently doesn't require care.

  If GUP wants to take a reliable pin (FOLL_PIN) on an anonymous page,
  it should only pin if the relevant PG_anon_bit is set. In that case,
  the pin will be fully reliable and stay consistent with the pages
  mapped into the page table, as the bit cannot get cleared (e.g., by
  fork(), KSM) while the page is pinned. For anonymous pages that
  are mapped R/W, PG_anon_exclusive can be assumed to always be set
  because such pages cannot possibly be shared.

  The page table lock protecting the page table entry is the primary
  synchronization mechanism for PG_anon_exclusive; GUP-fast that does
  not take the PT lock needs special care when trying to clear the
  flag.

  Page table entry types and PG_anon_exclusive:
  * Present: PG_anon_exclusive applies.
  * Swap: the information is lost. PG_anon_exclusive was cleared.
  * Migration: the entry holds this information instead.
               PG_anon_exclusive was cleared.
  * Device private: PG_anon_exclusive applies.
  * Device exclusive: PG_anon_exclusive applies.
  * HW Poison: PG_anon_exclusive is stale and not changed.

  If the page may be pinned (FOLL_PIN), clearing PG_anon_exclusive is
  not allowed and the flag will stick around until the page is freed
  and folio->mapping is cleared.
"

We won't be clearing PG_anon_exclusive on destructive unmapping (i.e.,
zapping) of page table entries, page freeing code will handle that when
also invalidate page->mapping to not indicate PageAnon() anymore.  Letting
information about exclusivity stick around will be an important property
when adding sanity checks to unpinning code.

Note that we properly clear the flag in free_pages_prepare() via
PAGE_FLAGS_CHECK_AT_PREP for each individual subpage of a compound page,
so there is no need to manually clear the flag.

Link: https://lkml.kernel.org/r/20220329160440.193848-12-david@redhat.com
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

 include/linux/page-flags.h |   39 ++++++++++++++++++++++++++++++++++-
 mm/hugetlb.c               |    2 +
 mm/memory.c                |   11 +++++++++
 mm/memremap.c              |    9 ++++++++
 mm/swapfile.c              |    4 +++
 tools/vm/page-types.c      |    8 ++++++-
 6 files changed, 71 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h~mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages
+++ a/include/linux/page-flags.h
@@ -142,6 +142,15 @@ enum pageflags {
 
 	PG_readahead = PG_reclaim,
 
+	/*
+	 * Depending on the way an anonymous folio can be mapped into a page
+	 * table (e.g., single PMD/PUD/CONT of the head page vs. PTE-mapped
+	 * THP), PG_anon_exclusive may be set only for the head page or for
+	 * tail pages of an anonymous folio. For now, we only expect it to be
+	 * set on tail pages for PTE-mapped THP.
+	 */
+	PG_anon_exclusive = PG_mappedtodisk,
+
 	/* Filesystems */
 	PG_checked = PG_owner_priv_1,
 
@@ -176,7 +185,7 @@ enum pageflags {
 	 * Indicates that at least one subpage is hwpoisoned in the
 	 * THP.
 	 */
-	PG_has_hwpoisoned = PG_mappedtodisk,
+	PG_has_hwpoisoned = PG_error,
 #endif
 
 	/* non-lru isolated movable page */
@@ -1002,6 +1011,34 @@ extern bool is_free_buddy_page(struct pa
 
 PAGEFLAG(Isolated, isolated, PF_ANY);
 
+static __always_inline int PageAnonExclusive(struct page *page)
+{
+	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
+	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
+	return test_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
+}
+
+static __always_inline void SetPageAnonExclusive(struct page *page)
+{
+	VM_BUG_ON_PGFLAGS(!PageAnon(page) || PageKsm(page), page);
+	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
+	set_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
+}
+
+static __always_inline void ClearPageAnonExclusive(struct page *page)
+{
+	VM_BUG_ON_PGFLAGS(!PageAnon(page) || PageKsm(page), page);
+	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
+	clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
+}
+
+static __always_inline void __ClearPageAnonExclusive(struct page *page)
+{
+	VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
+	VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
+	__clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
+}
+
 #ifdef CONFIG_MMU
 #define __PG_MLOCKED		(1UL << PG_mlocked)
 #else
--- a/mm/hugetlb.c~mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages
+++ a/mm/hugetlb.c
@@ -1672,6 +1672,8 @@ void free_huge_page(struct page *page)
 	VM_BUG_ON_PAGE(page_mapcount(page), page);
 
 	hugetlb_set_page_subpool(page, NULL);
+	if (PageAnon(page))
+		__ClearPageAnonExclusive(page);
 	page->mapping = NULL;
 	restore_reserve = HPageRestoreReserve(page);
 	ClearHPageRestoreReserve(page);
--- a/mm/memory.c~mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages
+++ a/mm/memory.c
@@ -3664,6 +3664,17 @@ vm_fault_t do_swap_page(struct vm_fault
 	}
 
 	/*
+	 * PG_anon_exclusive reuses PG_mappedtodisk for anon pages. A swap pte
+	 * must never point at an anonymous page in the swapcache that is
+	 * PG_anon_exclusive. Sanity check that this holds and especially, that
+	 * no filesystem set PG_mappedtodisk on a page in the swapcache. Sanity
+	 * check after taking the PT lock and making sure that nobody
+	 * concurrently faulted in this page and set PG_anon_exclusive.
+	 */
+	BUG_ON(!PageAnon(page) && PageMappedToDisk(page));
+	BUG_ON(PageAnon(page) && PageAnonExclusive(page));
+
+	/*
 	 * Remove the swap entry and conditionally try to free up the swapcache.
 	 * We're already holding a reference on the page but haven't mapped it
 	 * yet.
--- a/mm/memremap.c~mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages
+++ a/mm/memremap.c
@@ -479,6 +479,15 @@ void free_zone_device_page(struct page *
 	mem_cgroup_uncharge(page_folio(page));
 
 	/*
+	 * Note: we don't expect anonymous compound pages yet. Once supported
+	 * and we could PTE-map them similar to THP, we'd have to clear
+	 * PG_anon_exclusive on all tail pages.
+	 */
+	VM_BUG_ON_PAGE(PageAnon(page) && PageCompound(page), page);
+	if (PageAnon(page))
+		__ClearPageAnonExclusive(page);
+
+	/*
 	 * When a device managed page is freed, the page->mapping field
 	 * may still contain a (stale) mapping value. For example, the
 	 * lower bits of page->mapping may still identify the page as an
--- a/mm/swapfile.c~mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages
+++ a/mm/swapfile.c
@@ -1796,6 +1796,10 @@ static int unuse_pte(struct vm_area_stru
 		goto out;
 	}
 
+	/* See do_swap_page() */
+	BUG_ON(!PageAnon(page) && PageMappedToDisk(page));
+	BUG_ON(PageAnon(page) && PageAnonExclusive(page));
+
 	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
 	get_page(page);
--- a/tools/vm/page-types.c~mm-page-flags-reuse-pg_mappedtodisk-as-pg_anon_exclusive-for-pageanon-pages
+++ a/tools/vm/page-types.c
@@ -80,9 +80,10 @@
 #define KPF_SOFTDIRTY		40
 #define KPF_ARCH_2		41
 
-/* [48-] take some arbitrary free slots for expanding overloaded flags
+/* [47-] take some arbitrary free slots for expanding overloaded flags
  * not part of kernel API
  */
+#define KPF_ANON_EXCLUSIVE	47
 #define KPF_READAHEAD		48
 #define KPF_SLOB_FREE		49
 #define KPF_SLUB_FROZEN		50
@@ -138,6 +139,7 @@ static const char * const page_flag_name
 	[KPF_SOFTDIRTY]		= "f:softdirty",
 	[KPF_ARCH_2]		= "H:arch_2",
 
+	[KPF_ANON_EXCLUSIVE]	= "d:anon_exclusive",
 	[KPF_READAHEAD]		= "I:readahead",
 	[KPF_SLOB_FREE]		= "P:slob_free",
 	[KPF_SLUB_FROZEN]	= "A:slub_frozen",
@@ -472,6 +474,10 @@ static int bit_mask_ok(uint64_t flags)
 
 static uint64_t expand_overloaded_flags(uint64_t flags, uint64_t pme)
 {
+	/* Anonymous pages overload PG_mappedtodisk */
+	if ((flags & BIT(ANON)) && (flags & BIT(MAPPEDTODISK)))
+		flags ^= BIT(MAPPEDTODISK) | BIT(ANON_EXCLUSIVE);
+
 	/* SLOB/SLUB overload several page flags */
 	if (flags & BIT(SLAB)) {
 		if (flags & BIT(PRIVATE))
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

