Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2418FC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 02:21:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7D5364FEF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 02:21:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhCECV0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:21:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhCECV0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Mar 2021 21:21:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A4F96500D;
        Fri,  5 Mar 2021 02:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614910885;
        bh=+M9wswncNbyyUlZDl/lMdqNyGyJJrSgJddc/dTg0GyU=;
        h=Date:From:To:Subject:From;
        b=j4o0zNJmLHdMuOr7wDyQ75RjYkKJAsaKbMDlHDRxM6Bq5oiOEcwdZmD9QjP+704U/
         VmpduY1FaSMBPGKQ4n8W7d0D81WccVTZY0BxAt5ClT2HZcWE3QSpyQMNdchhKNR/yu
         f8MUeG1pLzwzzM85443Knn0q8tw0ESpYBLiCdp6U=
Date:   Thu, 04 Mar 2021 18:21:23 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, adobriyan@gmail.com, airlied@linux.ie,
        daniel@ffwll.ch, david@gibson.dropbear.id.au, galpress@amazon.com,
        hch@lst.de, jack@suse.cz, jannh@google.com, jgg@ziepe.ca,
        kirill@shutemov.name, ktkhai@virtuozzo.com, linmiaohe@huawei.com,
        linux-graphics-maintainer@vmware.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, sroland@vmware.com, willy@infradead.org,
        wzam@amazon.com
Subject:  +
 mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow.patch added to
 -mm tree
Message-ID: <20210305022123.QflvdCIVm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: introduce page_needs_cow_for_dma() for deciding whether cow
has been added to the -mm tree.  Its filename is
     mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm: introduce page_needs_cow_for_dma() for deciding whether cow

We've got quite a few places (pte, pmd, pud) that explicitly checked
against whether we should break the cow right now during fork().  It's
easier to provide a helper, especially before we work the same thing on
hugetlbfs.

Since we'll reference is_cow_mapping() in mm.h, move it there too. 
Actually it suites mm.h more since internal.h is mm/ only, but mm.h is
exported to the whole kernel.  With that we should expect another patch to
use is_cow_mapping() whenever we can across the kernel since we do use it
quite a lot but it's always done with raw code against VM_* flags.

Link: https://lkml.kernel.org/r/20210217233547.93892-4-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
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
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Roland Scheidegger <sroland@vmware.com>
Cc: VMware Graphics <linux-graphics-maintainer@vmware.com>
Cc: Wei Zhang <wzam@amazon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   21 +++++++++++++++++++++
 mm/huge_memory.c   |    8 ++------
 mm/internal.h      |    5 -----
 mm/memory.c        |    8 +-------
 4 files changed, 24 insertions(+), 18 deletions(-)

--- a/include/linux/mm.h~mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow
+++ a/include/linux/mm.h
@@ -1300,6 +1300,27 @@ static inline bool page_maybe_dma_pinned
 		GUP_PIN_COUNTING_BIAS;
 }
 
+static inline bool is_cow_mapping(vm_flags_t flags)
+{
+	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
+}
+
+/*
+ * This should most likely only be called during fork() to see whether we
+ * should break the cow immediately for a page on the src mm.
+ */
+static inline bool page_needs_cow_for_dma(struct vm_area_struct *vma,
+					  struct page *page)
+{
+	if (!is_cow_mapping(vma->vm_flags))
+		return false;
+
+	if (!atomic_read(&vma->vm_mm->has_pinned))
+		return false;
+
+	return page_maybe_dma_pinned(page);
+}
+
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
 #endif
--- a/mm/huge_memory.c~mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow
+++ a/mm/huge_memory.c
@@ -1100,9 +1100,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	 * best effort that the pinned pages won't be replaced by another
 	 * random page during the coming copy-on-write.
 	 */
-	if (unlikely(is_cow_mapping(vma->vm_flags) &&
-		     atomic_read(&src_mm->has_pinned) &&
-		     page_maybe_dma_pinned(src_page))) {
+	if (unlikely(page_needs_cow_for_dma(vma, src_page))) {
 		pte_free(dst_mm, pgtable);
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
@@ -1214,9 +1212,7 @@ int copy_huge_pud(struct mm_struct *dst_
 	}
 
 	/* Please refer to comments in copy_huge_pmd() */
-	if (unlikely(is_cow_mapping(vma->vm_flags) &&
-		     atomic_read(&src_mm->has_pinned) &&
-		     page_maybe_dma_pinned(pud_page(pud)))) {
+	if (unlikely(page_needs_cow_for_dma(vma, pud_page(pud)))) {
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
 		__split_huge_pud(vma, src_pud, addr);
--- a/mm/internal.h~mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow
+++ a/mm/internal.h
@@ -296,11 +296,6 @@ static inline unsigned int buddy_order(s
  */
 #define buddy_order_unsafe(page)	READ_ONCE(page_private(page))
 
-static inline bool is_cow_mapping(vm_flags_t flags)
-{
-	return (flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
-}
-
 /*
  * These three helpers classifies VMAs for virtual memory accounting.
  */
--- a/mm/memory.c~mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow
+++ a/mm/memory.c
@@ -809,12 +809,8 @@ copy_present_page(struct vm_area_struct
 		  pte_t *dst_pte, pte_t *src_pte, unsigned long addr, int *rss,
 		  struct page **prealloc, pte_t pte, struct page *page)
 {
-	struct mm_struct *src_mm = src_vma->vm_mm;
 	struct page *new_page;
 
-	if (!is_cow_mapping(src_vma->vm_flags))
-		return 1;
-
 	/*
 	 * What we want to do is to check whether this page may
 	 * have been pinned by the parent process.  If so,
@@ -828,9 +824,7 @@ copy_present_page(struct vm_area_struct
 	 * the page count. That might give false positives for
 	 * for pinning, but it will work correctly.
 	 */
-	if (likely(!atomic_read(&src_mm->has_pinned)))
-		return 1;
-	if (likely(!page_maybe_dma_pinned(page)))
+	if (likely(!page_needs_cow_for_dma(src_vma, page)))
 		return 1;
 
 	new_page = *prealloc;
_

Patches currently in -mm which might be from peterx@redhat.com are

hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share.patch
hugetlb-pass-vma-into-huge_pte_alloc-and-huge_pmd_share-fix.patch
hugetlb-userfaultfd-forbid-huge-pmd-sharing-when-uffd-enabled.patch
mm-hugetlb-move-flush_hugetlb_tlb_range-into-hugetlbh.patch
hugetlb-userfaultfd-unshare-all-pmds-for-hugetlbfs-when-register-wp.patch
hugetlb-dedup-the-code-to-add-a-new-file_region.patch
hugetlg-break-earlier-in-add_reservation_in_range-when-we-can.patch
mm-introduce-page_needs_cow_for_dma-for-deciding-whether-cow.patch
mm-use-is_cow_mapping-across-tree-where-proper.patch
hugetlb-do-early-cow-when-page-pinned-on-src-mm.patch

