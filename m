Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D3FC433FE
	for <mm-commits@archiver.kernel.org>; Thu, 31 Mar 2022 04:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbiCaEev (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Mar 2022 00:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiCaEej (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 31 Mar 2022 00:34:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C787F5A588
        for <mm-commits@vger.kernel.org>; Wed, 30 Mar 2022 21:32:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64F0F6147F
        for <mm-commits@vger.kernel.org>; Thu, 31 Mar 2022 04:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B220EC340F0;
        Thu, 31 Mar 2022 04:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648701171;
        bh=JdvGJo6BM92cSQQBLAd26y2YtfCf4cXM92KQ3wfUUzc=;
        h=Date:To:From:Subject:From;
        b=0AlvOwU/GfGHMRXGLpbz2I9bIRGy1Ct6ujsMYSmMo89WLzYsbK7D46jVWFcNvgdh4
         kygxgNL40qMrJPZZRYfHNY6UWb8mZc7eMOrnVVnkndhUa/Bn/HCUHeZ47yE37q+l7T
         TPx9swGERNIUf86kPen/c5hH+KY3Qb/3jaxinSuc=
Date:   Wed, 30 Mar 2022 21:32:51 -0700
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
Subject: + mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch added to -mm tree
Message-Id: <20220331043251.B220EC340F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: pass rmap flags to hugepage_add_anon_rmap()
has been added to the -mm tree.  Its filename is
     mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap.patch

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
Subject: mm/rmap: pass rmap flags to hugepage_add_anon_rmap()

Let's prepare for passing RMAP_EXCLUSIVE, similarly as we do for
page_add_anon_rmap() now.  RMAP_COMPOUND is implicit for hugetlb pages and
ignored.

Link: https://lkml.kernel.org/r/20220329160440.193848-8-david@redhat.com
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

 include/linux/rmap.h |    2 +-
 mm/migrate.c         |    3 ++-
 mm/rmap.c            |    9 ++++++---
 3 files changed, 9 insertions(+), 5 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap
+++ a/include/linux/rmap.h
@@ -191,7 +191,7 @@ void page_add_file_rmap(struct page *, s
 void page_remove_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
 void hugepage_add_anon_rmap(struct page *, struct vm_area_struct *,
-		unsigned long address);
+		unsigned long address, rmap_t flags);
 void hugepage_add_new_anon_rmap(struct page *, struct vm_area_struct *,
 		unsigned long address);
 
--- a/mm/migrate.c~mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap
+++ a/mm/migrate.c
@@ -232,7 +232,8 @@ static bool remove_migration_pte(struct
 			pte = pte_mkhuge(pte);
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			if (folio_test_anon(folio))
-				hugepage_add_anon_rmap(new, vma, pvmw.address);
+				hugepage_add_anon_rmap(new, vma, pvmw.address,
+						       RMAP_NONE);
 			else
 				page_dup_file_rmap(new, true);
 			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
--- a/mm/rmap.c~mm-rmap-pass-rmap-flags-to-hugepage_add_anon_rmap
+++ a/mm/rmap.c
@@ -2347,9 +2347,11 @@ void rmap_walk_locked(struct folio *foli
  * The following two functions are for anonymous (private mapped) hugepages.
  * Unlike common anonymous pages, anonymous hugepages have no accounting code
  * and no lru code, because we handle hugepages differently from common pages.
+ *
+ * RMAP_COMPOUND is ignored.
  */
-void hugepage_add_anon_rmap(struct page *page,
-			    struct vm_area_struct *vma, unsigned long address)
+void hugepage_add_anon_rmap(struct page *page, struct vm_area_struct *vma,
+			    unsigned long address, rmap_t flags)
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 	int first;
@@ -2359,7 +2361,8 @@ void hugepage_add_anon_rmap(struct page
 	/* address might be in next vma when migration races vma_adjust */
 	first = atomic_inc_and_test(compound_mapcount_ptr(page));
 	if (first)
-		__page_set_anon_rmap(page, vma, address, 0);
+		__page_set_anon_rmap(page, vma, address,
+				     !!(flags & RMAP_EXCLUSIVE));
 }
 
 void hugepage_add_new_anon_rmap(struct page *page,
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

