Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 417FAC41513
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 22:58:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbjHKW6x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 18:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236864AbjHKW6p (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:58:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641A5268C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:58:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 023E565BD7
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:58:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591D3C433C8;
        Fri, 11 Aug 2023 22:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794723;
        bh=rp0u312Jiq3UPXhcTZzYo6Vc5p7Vdy6UU3kFhar1G4Q=;
        h=Date:To:From:Subject:From;
        b=FNMkxXlhvAlmZ1wRA5rviXkSedd2WVN7O4oiVzHSLR4PDTDuFe7JXXxJSW4697kYC
         G9sWMfZFlRPXHAvoUjjbDbTrxPbLYiQYl9IPMY8FVepS/x2dvl1tUad1xlLKf6h9xh
         8hu8kUBPESS9EEDv2vHvQO5v3Kch2MRSoktKwwMQ=
Date:   Fri, 11 Aug 2023 15:58:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rppt@kernel.org, mike.kravetz@oracle.com,
        lstoakes@gmail.com, kirill@shutemov.name, jthoughton@google.com,
        jhubbard@nvidia.com, jgg@nvidia.com, hughd@google.com,
        david@redhat.com, aarcange@redhat.com, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-add-page_mask-for-hugetlb_follow_page_mask.patch removed from -mm tree
Message-Id: <20230811225843.591D3C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: add page_mask for hugetlb_follow_page_mask()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-page_mask-for-hugetlb_follow_page_mask.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: add page_mask for hugetlb_follow_page_mask()
Date: Wed, 28 Jun 2023 17:53:05 -0400

follow_page() doesn't need it, but we'll start to need it when unifying
gup for hugetlb.

Link: https://lkml.kernel.org/r/20230628215310.73782-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A . Shutemov <kirill@shutemov.name>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    8 +++++---
 mm/gup.c                |    3 ++-
 mm/hugetlb.c            |    5 ++++-
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-add-page_mask-for-hugetlb_follow_page_mask
+++ a/include/linux/hugetlb.h
@@ -131,7 +131,8 @@ int move_hugetlb_page_tables(struct vm_a
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *,
 			    struct vm_area_struct *, struct vm_area_struct *);
 struct page *hugetlb_follow_page_mask(struct vm_area_struct *vma,
-				unsigned long address, unsigned int flags);
+				      unsigned long address, unsigned int flags,
+				      unsigned int *page_mask);
 long follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
 			 struct page **, unsigned long *, unsigned long *,
 			 long, unsigned int, int *);
@@ -297,8 +298,9 @@ static inline void adjust_range_if_pmd_s
 {
 }
 
-static inline struct page *hugetlb_follow_page_mask(struct vm_area_struct *vma,
-				unsigned long address, unsigned int flags)
+static inline struct page *hugetlb_follow_page_mask(
+    struct vm_area_struct *vma, unsigned long address, unsigned int flags,
+    unsigned int *page_mask)
 {
 	BUILD_BUG(); /* should never be compiled in if !CONFIG_HUGETLB_PAGE*/
 }
--- a/mm/gup.c~mm-hugetlb-add-page_mask-for-hugetlb_follow_page_mask
+++ a/mm/gup.c
@@ -824,7 +824,8 @@ static struct page *follow_page_mask(str
 	 * Ordinary GUP uses follow_hugetlb_page for hugetlb processing.
 	 */
 	if (is_vm_hugetlb_page(vma))
-		return hugetlb_follow_page_mask(vma, address, flags);
+		return hugetlb_follow_page_mask(vma, address, flags,
+						&ctx->page_mask);
 
 	pgd = pgd_offset(mm, address);
 
--- a/mm/hugetlb.c~mm-hugetlb-add-page_mask-for-hugetlb_follow_page_mask
+++ a/mm/hugetlb.c
@@ -6454,7 +6454,8 @@ static inline bool __follow_hugetlb_must
 }
 
 struct page *hugetlb_follow_page_mask(struct vm_area_struct *vma,
-				unsigned long address, unsigned int flags)
+				      unsigned long address, unsigned int flags,
+				      unsigned int *page_mask)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct mm_struct *mm = vma->vm_mm;
@@ -6504,6 +6505,8 @@ struct page *hugetlb_follow_page_mask(st
 			page = ERR_PTR(ret);
 			goto out;
 		}
+
+		*page_mask = (1U << huge_page_order(h)) - 1;
 	}
 out:
 	spin_unlock(ptl);
_

Patches currently in -mm which might be from peterx@redhat.com are


