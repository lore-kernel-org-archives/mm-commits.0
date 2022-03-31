Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2BFC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiCaEgS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiCaEfM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:35:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF1C5A161
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13545B81E46
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99428C340ED;
        Thu, 31 Mar 2022 04:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701201;
        bh=5OlU2xZp1sm3SDQPIR7jRgzdZQuHipe6N1FZ6AheBs8=;
        h=Date:To:From:Subject:From;
        b=TfbjpQvKGd9kIw6BYZRbH9tvmj0tbNCTOZsc0LNwnecxVSj+RNh62e+TS6fJj/UdW
         RMt93pwWPPJdHyCRHADO8Y44Fn1c64fuIHZKg4aZjfB584DgeR4ZfTi4DOeEdUhcm+
         2XlA68ogxb5F4vUL9Sg4FF0grk5pvv5wx5PzKmOo=
Date:   Wed, 30 Mar 2022 21:33:21 -0700
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
Subject: + mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch added to -mm tree
Message-Id: <20220331043321.99428C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: sanity-check with CONFIG_DEBUG_VM that anonymous pages are exclusive when (un)pinning
has been added to the -mm tree.  Its filename is
     mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch

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
Subject: mm/gup: sanity-check with CONFIG_DEBUG_VM that anonymous pages are exclusive when (un)pinning

Let's verify when (un)pinning anonymous pages that we always deal with
exclusive anonymous pages, which guarantees that we'll have a reliable
PIN, meaning that we cannot end up with the GUP pin being inconsistent
with he pages mapped into the page tables due to a COW triggered by a
write fault.

When pinning pages, after conditionally triggering GUP unsharing of
possibly shared anonymous pages, we should always only see exclusive
anonymous pages.  Note that anonymous pages that are mapped writable must
be marked exclusive, otherwise we'd have a BUG.

When pinning during ordinary GUP, simply add a check after our conditional
GUP-triggered unsharing checks.  As we know exactly how the page is
mapped, we know exactly in which page we have to check for
PageAnonExclusive().

When pinning via GUP-fast we have to be careful, because we can race with
fork(): verify only after we made sure via the seqcount that we didn't
race with concurrent fork() that we didn't end up pinning a possibly
shared anonymous page.

Similarly, when unpinning, verify that the pages are still marked as
exclusive: otherwise something turned the pages possibly shared, which can
result in random memory corruptions, which we really want to catch.

With only the pinned pages at hand and not the actual page table entries
we have to be a bit careful: hugetlb pages are always mapped via a single
logical page table entry referencing the head page and PG_anon_exclusive
of the head page applies.  Anon THP are a bit more complicated, because we
might have obtained the page reference either via a PMD or a PTE --
depending on the mapping type we either have to check PageAnonExclusive of
the head page (PMD-mapped THP) or the tail page (PTE-mapped THP) applies:
as we don't know and to make our life easier, check that either is set.

Take care to not verify in case we're unpinning during GUP-fast because we
detected concurrent fork(): we might stumble over an anonymous page that
is now shared.

Link: https://lkml.kernel.org/r/20220329160440.193848-17-david@redhat.com
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

 mm/gup.c         |   61 ++++++++++++++++++++++++++++++++++++++++++++-
 mm/huge_memory.c |    3 ++
 mm/hugetlb.c     |    3 ++
 3 files changed, 66 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning
+++ a/mm/gup.c
@@ -29,6 +29,39 @@ struct follow_page_context {
 	unsigned int page_mask;
 };
 
+static inline void sanity_check_pinned_pages(struct page **pages,
+					     unsigned long npages)
+{
+	if (!IS_ENABLED(CONFIG_DEBUG_VM))
+		return;
+
+	/*
+	 * We only pin anonymous pages if they are exclusive. Once pinned, we
+	 * can no longer turn them possibly shared and PageAnonExclusive() will
+	 * stick around until the page is freed.
+	 *
+	 * We'd like to verify that our pinned anonymous pages are still mapped
+	 * exclusively. The issue with anon THP is that we don't know how
+	 * they are/were mapped when pinning them. However, for anon
+	 * THP we can assume that either the given page (PTE-mapped THP) or
+	 * the head page (PMD-mapped THP) should be PageAnonExclusive(). If
+	 * neither is the case, there is certainly something wrong.
+	 */
+	for (; npages; npages--, pages++) {
+		struct page *page = *pages;
+		struct folio *folio = page_folio(page);
+
+		if (!folio_test_anon(folio))
+			continue;
+		if (!folio_test_large(folio) || folio_test_hugetlb(folio))
+			VM_BUG_ON_PAGE(!PageAnonExclusive(&folio->page), page);
+		else
+			/* Either a PTE-mapped or a PMD-mapped THP. */
+			VM_BUG_ON_PAGE(!PageAnonExclusive(&folio->page) &&
+				       !PageAnonExclusive(page), page);
+	}
+}
+
 /*
  * Return the folio with ref appropriately incremented,
  * or NULL if that failed.
@@ -204,6 +237,7 @@ bool __must_check try_grab_page(struct p
  */
 void unpin_user_page(struct page *page)
 {
+	sanity_check_pinned_pages(&page, 1);
 	gup_put_folio(page_folio(page), 1, FOLL_PIN);
 }
 EXPORT_SYMBOL(unpin_user_page);
@@ -272,6 +306,7 @@ void unpin_user_pages_dirty_lock(struct
 		return;
 	}
 
+	sanity_check_pinned_pages(pages, npages);
 	for (i = 0; i < npages; i += nr) {
 		folio = gup_folio_next(pages, npages, i, &nr);
 		/*
@@ -344,6 +379,23 @@ void unpin_user_page_range_dirty_lock(st
 }
 EXPORT_SYMBOL(unpin_user_page_range_dirty_lock);
 
+static void unpin_user_pages_lockless(struct page **pages, unsigned long npages)
+{
+	unsigned long i;
+	struct folio *folio;
+	unsigned int nr;
+
+	/*
+	 * Don't perform any sanity checks because we might have raced with
+	 * fork() and some anonymous pages might now actually be shared --
+	 * which is why we're unpinning after all.
+	 */
+	for (i = 0; i < npages; i += nr) {
+		folio = gup_folio_next(pages, npages, i, &nr);
+		gup_put_folio(folio, nr, FOLL_PIN);
+	}
+}
+
 /**
  * unpin_user_pages() - release an array of gup-pinned pages.
  * @pages:  array of pages to be marked dirty and released.
@@ -367,6 +419,7 @@ void unpin_user_pages(struct page **page
 	if (WARN_ON(IS_ERR_VALUE(npages)))
 		return;
 
+	sanity_check_pinned_pages(pages, npages);
 	for (i = 0; i < npages; i += nr) {
 		folio = gup_folio_next(pages, npages, i, &nr);
 		gup_put_folio(folio, nr, FOLL_PIN);
@@ -510,6 +563,10 @@ retry:
 		page = ERR_PTR(-EMLINK);
 		goto out;
 	}
+
+	VM_BUG_ON((flags & FOLL_PIN) && PageAnon(page) &&
+		  !PageAnonExclusive(page));
+
 	/* try_grab_page() does nothing unless FOLL_GET or FOLL_PIN is set. */
 	if (unlikely(!try_grab_page(page, flags))) {
 		page = ERR_PTR(-ENOMEM);
@@ -2750,8 +2807,10 @@ static unsigned long lockless_pages_from
 	 */
 	if (gup_flags & FOLL_PIN) {
 		if (read_seqcount_retry(&current->mm->write_protect_seq, seq)) {
-			unpin_user_pages(pages, nr_pinned);
+			unpin_user_pages_lockless(pages, nr_pinned);
 			return 0;
+		} else {
+			sanity_check_pinned_pages(pages, nr_pinned);
 		}
 	}
 	return nr_pinned;
--- a/mm/huge_memory.c~mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning
+++ a/mm/huge_memory.c
@@ -1392,6 +1392,9 @@ struct page *follow_trans_huge_pmd(struc
 	if (!pmd_write(*pmd) && gup_must_unshare(flags, page))
 		return ERR_PTR(-EMLINK);
 
+	VM_BUG_ON((flags & FOLL_PIN) && PageAnon(page) &&
+		  !PageAnonExclusive(page));
+
 	if (!try_grab_page(page, flags))
 		return ERR_PTR(-ENOMEM);
 
--- a/mm/hugetlb.c~mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning
+++ a/mm/hugetlb.c
@@ -6100,6 +6100,9 @@ long follow_hugetlb_page(struct mm_struc
 		pfn_offset = (vaddr & ~huge_page_mask(h)) >> PAGE_SHIFT;
 		page = pte_page(huge_ptep_get(pte));
 
+		VM_BUG_ON((flags & FOLL_PIN) && PageAnon(page) &&
+			  !PageAnonExclusive(page));
+
 		/*
 		 * If subpage information not requested, update counters
 		 * and skip the same_page loop below.
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

