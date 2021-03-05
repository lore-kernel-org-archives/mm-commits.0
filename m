Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B052C433DB
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 02:21:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20DC86500D
	for <mm-commits@archiver.kernel.org>; Fri,  5 Mar 2021 02:21:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbhCECVa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 4 Mar 2021 21:21:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:59358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229436AbhCECVa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Mar 2021 21:21:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28E2864FDB;
        Fri,  5 Mar 2021 02:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614910889;
        bh=LcpIkoGZqgub7P+9pTOdj2f9VpWt7pfX4+qoNNMb7V0=;
        h=Date:From:To:Subject:From;
        b=mEgCbXvABsVYLae/LMgqcOun5kjyohDOGt2cDamIeC+ezf5aGGkKCEm4hw0WHO2gC
         igoNNMXep8llBc5ZQ/h4XGvX+QLPl1F0XL2lEtrS4zM4iNn38IcgL8DqspB5vev3qb
         xOTYhR6Z8r/LtBwaPflfuNBrQzOvYX8dKH6Z6Dzo=
Date:   Thu, 04 Mar 2021 18:21:27 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, adobriyan@gmail.com, airlied@linux.ie,
        daniel@ffwll.ch, david@gibson.dropbear.id.au, galpress@amazon.com,
        hch@lst.de, jack@suse.cz, jannh@google.com, jgg@ziepe.ca,
        kirill@shutemov.name, ktkhai@virtuozzo.com, linmiaohe@huawei.com,
        linux-graphics-maintainer@vmware.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rppt@linux.vnet.ibm.com, sroland@vmware.com, willy@infradead.org,
        wzam@amazon.com
Subject:  + mm-use-is_cow_mapping-across-tree-where-proper.patch
 added to -mm tree
Message-ID: <20210305022127.VX4LOxKsQ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use is_cow_mapping() across tree where proper
has been added to the -mm tree.  Its filename is
     mm-use-is_cow_mapping-across-tree-where-proper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-use-is_cow_mapping-across-tree-where-proper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-use-is_cow_mapping-across-tree-where-proper.patch

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
Subject: mm: use is_cow_mapping() across tree where proper

After is_cow_mapping() is exported in mm.h, replace some manual checks
elsewhere throughout the tree but start to use the new helper.

Link: https://lkml.kernel.org/r/20210217233547.93892-5-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@ziepe.ca>
Cc: VMware Graphics <linux-graphics-maintainer@vmware.com>
Cc: Roland Scheidegger <sroland@vmware.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Gal Pressman <galpress@amazon.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Kirill Shutemov <kirill@shutemov.name>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Wei Zhang <wzam@amazon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c |    4 +---
 drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c   |    2 +-
 fs/proc/task_mmu.c                         |    2 --
 mm/hugetlb.c                               |    4 +---
 4 files changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c~mm-use-is_cow_mapping-across-tree-where-proper
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
@@ -500,8 +500,6 @@ vm_fault_t vmw_bo_vm_huge_fault(struct v
 	vm_fault_t ret;
 	pgoff_t fault_page_size;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
-	bool is_cow_mapping =
-		(vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
 
 	switch (pe_size) {
 	case PE_SIZE_PMD:
@@ -518,7 +516,7 @@ vm_fault_t vmw_bo_vm_huge_fault(struct v
 	}
 
 	/* Always do write dirty-tracking and COW on PTE level. */
-	if (write && (READ_ONCE(vbo->dirty) || is_cow_mapping))
+	if (write && (READ_ONCE(vbo->dirty) || is_cow_mapping(vma->vm_flags)))
 		return VM_FAULT_FALLBACK;
 
 	ret = ttm_bo_vm_reserve(bo, vmf);
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c~mm-use-is_cow_mapping-across-tree-where-proper
+++ a/drivers/gpu/drm/vmwgfx/vmwgfx_ttm_glue.c
@@ -49,7 +49,7 @@ int vmw_mmap(struct file *filp, struct v
 	vma->vm_ops = &vmw_vm_ops;
 
 	/* Use VM_PFNMAP rather than VM_MIXEDMAP if not a COW mapping */
-	if ((vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) != VM_MAYWRITE)
+	if (!is_cow_mapping(vma->vm_flags))
 		vma->vm_flags = (vma->vm_flags & ~VM_MIXEDMAP) | VM_PFNMAP;
 
 	return 0;
--- a/fs/proc/task_mmu.c~mm-use-is_cow_mapping-across-tree-where-proper
+++ a/fs/proc/task_mmu.c
@@ -1036,8 +1036,6 @@ struct clear_refs_private {
 
 #ifdef CONFIG_MEM_SOFT_DIRTY
 
-#define is_cow_mapping(flags) (((flags) & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE)
-
 static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr, pte_t pte)
 {
 	struct page *page;
--- a/mm/hugetlb.c~mm-use-is_cow_mapping-across-tree-where-proper
+++ a/mm/hugetlb.c
@@ -3756,15 +3756,13 @@ int copy_hugetlb_page_range(struct mm_st
 	pte_t *src_pte, *dst_pte, entry, dst_entry;
 	struct page *ptepage;
 	unsigned long addr;
-	int cow;
+	bool cow = is_cow_mapping(vma->vm_flags);
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
 	struct address_space *mapping = vma->vm_file->f_mapping;
 	struct mmu_notifier_range range;
 	int ret = 0;
 
-	cow = (vma->vm_flags & (VM_SHARED | VM_MAYWRITE)) == VM_MAYWRITE;
-
 	if (cow) {
 		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, src,
 					vma->vm_start,
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

