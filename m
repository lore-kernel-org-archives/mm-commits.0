Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D33B6C43331
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1C4664FA6
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhCMFHm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Mar 2021 00:07:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231347AbhCMFHh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 13 Mar 2021 00:07:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 418C964F8E;
        Sat, 13 Mar 2021 05:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612055;
        bh=Kt+7BJiM0iGWUy/FKXCbhKejkvl2sD4jbH74Bk5GXg0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XpbQU2fX836w0wDgM7LpppidimVrGdSBkoPKQ3t+HBjyyXc07EFltFj4Qnuw0SKCC
         M2RIj+04MURqnGsdj5tiau1QgHd2o06U3Ou34ChEOoPm3QW9ZjXtBCgihy0Q+fZmoA
         DIKABX5XR0AXgJJ9bd2aIAtRtrIz6bbNxpLO+ogw=
Date:   Fri, 12 Mar 2021 21:07:33 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, adobriyan@gmail.com, airlied@linux.ie,
        akpm@linux-foundation.org, daniel@ffwll.ch,
        david@gibson.dropbear.id.au, galpress@amazon.com, hch@lst.de,
        jack@suse.cz, jannh@google.com, jgg@ziepe.ca, kirill@shutemov.name,
        ktkhai@virtuozzo.com, linmiaohe@huawei.com,
        linux-graphics-maintainer@vmware.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, rppt@linux.vnet.ibm.com, sroland@vmware.com,
        torvalds@linux-foundation.org, willy@infradead.org, wzam@amazon.com
Subject:  [patch 10/29] hugetlb: do early cow when page pinned on
 src mm
Message-ID: <20210313050733.VD2-U7JUE%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Peter Xu <peterx@redhat.com>
Subject: hugetlb: do early cow when page pinned on src mm

This is the last missing piece of the COW-during-fork effort when there're
pinned pages found.  One can reference 70e806e4e645 ("mm: Do early cow for
pinned pages during fork() for ptes", 2020-09-27) for more information,
since we do similar things here rather than pte this time, but just for
hugetlb.

Note that after Jason's recent work on 57efa1fe5957 ("mm/gup: prevent
gup_fast from racing with COW during fork", 2020-12-15) which is safer and
easier to understand, we're safe now within the whole copy_page_range()
against gup-fast, we don't need the wr-protect trick that proposed in
70e806e4e645 anymore.

Link: https://lkml.kernel.org/r/20210217233547.93892-6-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Gal Pressman <galpress@amazon.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Roland Scheidegger <sroland@vmware.com>
Cc: VMware Graphics <linux-graphics-maintainer@vmware.com>
Cc: Wei Zhang <wzam@amazon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 62 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~hugetlb-do-early-cow-when-page-pinned-on-src-mm
+++ a/mm/hugetlb.c
@@ -3728,6 +3728,18 @@ static bool is_hugetlb_entry_hwpoisoned(
 		return false;
 }
 
+static void
+hugetlb_install_page(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr,
+		     struct page *new_page)
+{
+	__SetPageUptodate(new_page);
+	set_huge_pte_at(vma->vm_mm, addr, ptep, make_huge_pte(vma, new_page, 1));
+	hugepage_add_new_anon_rmap(new_page, vma, addr);
+	hugetlb_count_add(pages_per_huge_page(hstate_vma(vma)), vma->vm_mm);
+	ClearHPageRestoreReserve(new_page);
+	SetHPageMigratable(new_page);
+}
+
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			    struct vm_area_struct *vma)
 {
@@ -3737,6 +3749,7 @@ int copy_hugetlb_page_range(struct mm_st
 	bool cow = is_cow_mapping(vma->vm_flags);
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
+	unsigned long npages = pages_per_huge_page(h);
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct mmu_notifier_range range;
 	int ret = 0;
@@ -3785,6 +3798,7 @@ int copy_hugetlb_page_range(struct mm_st
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 		entry = huge_ptep_get(src_pte);
 		dst_entry = huge_ptep_get(dst_pte);
+again:
 		if (huge_pte_none(entry) || !huge_pte_none(dst_entry)) {
 			/*
 			 * Skip if src entry none.  Also, skip in the
@@ -3808,6 +3822,52 @@ int copy_hugetlb_page_range(struct mm_st
 			}
 			set_huge_swap_pte_at(dst, addr, dst_pte, entry, sz);
 		} else {
+			entry = huge_ptep_get(src_pte);
+			ptepage = pte_page(entry);
+			get_page(ptepage);
+
+			/*
+			 * This is a rare case where we see pinned hugetlb
+			 * pages while they're prone to COW.  We need to do the
+			 * COW earlier during fork.
+			 *
+			 * When pre-allocating the page or copying data, we
+			 * need to be without the pgtable locks since we could
+			 * sleep during the process.
+			 */
+			if (unlikely(page_needs_cow_for_dma(vma, ptepage))) {
+				pte_t src_pte_old = entry;
+				struct page *new;
+
+				spin_unlock(src_ptl);
+				spin_unlock(dst_ptl);
+				/* Do not use reserve as it's private owned */
+				new = alloc_huge_page(vma, addr, 1);
+				if (IS_ERR(new)) {
+					put_page(ptepage);
+					ret = PTR_ERR(new);
+					break;
+				}
+				copy_user_huge_page(new, ptepage, addr, vma,
+						    npages);
+				put_page(ptepage);
+
+				/* Install the new huge page if src pte stable */
+				dst_ptl = huge_pte_lock(h, dst, dst_pte);
+				src_ptl = huge_pte_lockptr(h, src, src_pte);
+				spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
+				entry = huge_ptep_get(src_pte);
+				if (!pte_same(src_pte_old, entry)) {
+					put_page(new);
+					/* dst_entry won't change as in child */
+					goto again;
+				}
+				hugetlb_install_page(vma, dst_pte, addr, new);
+				spin_unlock(src_ptl);
+				spin_unlock(dst_ptl);
+				continue;
+			}
+
 			if (cow) {
 				/*
 				 * No need to notify as we are downgrading page
@@ -3818,12 +3878,10 @@ int copy_hugetlb_page_range(struct mm_st
 				 */
 				huge_ptep_set_wrprotect(src, addr, src_pte);
 			}
-			entry = huge_ptep_get(src_pte);
-			ptepage = pte_page(entry);
-			get_page(ptepage);
+
 			page_dup_rmap(ptepage, true);
 			set_huge_pte_at(dst, addr, dst_pte, entry);
-			hugetlb_count_add(pages_per_huge_page(h), dst);
+			hugetlb_count_add(npages, dst);
 		}
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
_
