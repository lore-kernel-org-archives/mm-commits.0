Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF63FC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbiEJEUu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbiEJEUA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7BD2AC6D5
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:14:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D84961767
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12ABC385C2;
        Tue, 10 May 2022 04:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156093;
        bh=9X+xvFHNfi8O9UrVzDHkJBsBuqrxpK9LOfZ2ALkSVP4=;
        h=Date:To:From:Subject:From;
        b=HiIZVN5EQnoS6TzxjOwOk3HEBWEOl3eVWL8dhCFZVxySuQBzPs2bvmLMGuIso45dx
         AOqwhB0VS9pK2GgEES5cZQKwT1QZxgNsAf+ky87/mU4K6hdwM6CgS8t/xZxbp5aDIj
         y44MoO2WYx43NYXkCYSiRX3eoUxF9srWiBofarCA=
Date:   Mon, 09 May 2022 21:14:53 -0700
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
Subject: [merged mm-stable] mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch removed from -mm tree
Message-Id: <20220510041453.B12ABC385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup: sanity-check with CONFIG_DEBUG_VM that anonymous pages are exclusive when (un)pinning
has been removed from the -mm tree.  Its filename was
     mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning.patch

This patch was dropped because it was merged into mm-stable

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

Link: https://lkml.kernel.org/r/20220428083441.37290-18-david@redhat.com
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
+	VM_BUG_ON_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
+		       !PageAnonExclusive(page), page);
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
 
+	VM_BUG_ON_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
+			!PageAnonExclusive(page), page);
+
 	if (!try_grab_page(page, flags))
 		return ERR_PTR(-ENOMEM);
 
--- a/mm/hugetlb.c~mm-gup-sanity-check-with-config_debug_vm-that-anonymous-pages-are-exclusive-when-unpinning
+++ a/mm/hugetlb.c
@@ -6118,6 +6118,9 @@ long follow_hugetlb_page(struct mm_struc
 		pfn_offset = (vaddr & ~huge_page_mask(h)) >> PAGE_SHIFT;
 		page = pte_page(huge_ptep_get(pte));
 
+		VM_BUG_ON_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
+			       !PageAnonExclusive(page), page);
+
 		/*
 		 * If subpage information not requested, update counters
 		 * and skip the same_page loop below.
_

Patches currently in -mm which might be from david@redhat.com are


