Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBFBCC433FE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Oct 2022 21:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiJGV31 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Oct 2022 17:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJGV3W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2022 17:29:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D638F258
        for <mm-commits@vger.kernel.org>; Fri,  7 Oct 2022 14:29:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C94AB82475
        for <mm-commits@vger.kernel.org>; Fri,  7 Oct 2022 21:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECF0C433D6;
        Fri,  7 Oct 2022 21:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665178158;
        bh=kFNqD13W7KnGa3gcB/hVFQaSotvACLkayIjT4G2dWxo=;
        h=Date:To:From:Subject:From;
        b=vzCYCrzNvjpKFSCPHxCmSL2KH3z+KLfy8u6ki8inSqQGLy78A0Yrxg00q0iKehmzt
         PyjbPuTsKTgWSAn8pP/e5MiroeE4N5XtBf1Mo/5l3g1aY0+9TZhKmAkwMn+FhBvT7V
         VurHXjkrc1ka2MnTHxlphUzuDRHQD60STHmZkitU=
Date:   Fri, 07 Oct 2022 14:29:17 -0700
To:     mm-commits@vger.kernel.org, svens@linux.ibm.com,
        songmuchun@bytedance.com, prakash.sangappa@oracle.com,
        peterx@redhat.com, pasha.tatashin@soleen.com,
        naoya.horiguchi@linux.dev, mhocko@suse.com, linmiaohe@huawei.com,
        kirill.shutemov@linux.intel.com, jthoughton@google.com,
        david@redhat.com, dave@stgolabs.net, axelrasmussen@google.com,
        aneesh.kumar@linux.vnet.ibm.com, almasrymina@google.com,
        aarcange@redhat.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-fix-vma-lock-handling-during-split-vma-and-range-unmapping.patch removed from -mm tree
Message-Id: <20221007212918.2ECF0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: fix vma lock handling during split vma and range unmapping
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-vma-lock-handling-during-split-vma-and-range-unmapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: fix vma lock handling during split vma and range unmapping
Date: Tue, 4 Oct 2022 18:17:05 -0700

Patch series "hugetlb: fixes for new vma lock series".

In review of the series "hugetlb: Use new vma lock for huge pmd sharing
synchronization", Miaohe Lin pointed out two key issues:

1) There is a race in the routine hugetlb_unmap_file_folio when locks
   are dropped and reacquired in the correct order [1].

2) With the switch to using vma lock for fault/truncate synchronization,
   we need to make sure lock exists for all VM_MAYSHARE vmas, not just
   vmas capable of pmd sharing.

These two issues are addressed here.  In addition, having a vma lock
present in all VM_MAYSHARE vmas, uncovered some issues around vma
splitting.  Those are also addressed.

[1] https://lore.kernel.org/linux-mm/01f10195-7088-4462-6def-909549c75ef4@huawei.com/


This patch (of 3):

The hugetlb vma lock hangs off the vm_private_data field and is specific
to the vma.  When vm_area_dup() is called as part of vma splitting, the
vma lock pointer is copied to the new vma.  This will result in issues
such as double freeing of the structure.  Update the hugetlb open vm_ops
to allocate a new vma lock for the new vma.

The routine __unmap_hugepage_range_final unconditionally unset VM_MAYSHARE
to prevent subsequent pmd sharing.  hugetlb_vma_lock_free attempted to
anticipate this by checking both VM_MAYSHARE and VM_SHARED.  However, if
only VM_MAYSHARE was set we would miss the free.  With the introduction of
the vma lock, a vma can not participate in pmd sharing if vm_private_data
is NULL.  Instead of clearing VM_MAYSHARE in __unmap_hugepage_range_final,
free the vma lock to prevent sharing.  Also, update the sharing code to
make sure vma lock is indeed a condition for pmd sharing. 
hugetlb_vma_lock_free can then key off VM_MAYSHARE and not miss any vmas.

Link: https://lkml.kernel.org/r/20221005011707.514612-1-mike.kravetz@oracle.com
Link: https://lkml.kernel.org/r/20221005011707.514612-2-mike.kravetz@oracle.com
Fixes: "hugetlb: add vma based lock for pmd sharing"
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   43 +++++++++++++++++++++++++++----------------
 mm/memory.c  |    4 ----
 2 files changed, 27 insertions(+), 20 deletions(-)

--- a/mm/hugetlb.c~hugetlb-fix-vma-lock-handling-during-split-vma-and-range-unmapping
+++ a/mm/hugetlb.c
@@ -4612,7 +4612,14 @@ static void hugetlb_vm_op_open(struct vm
 		kref_get(&resv->refs);
 	}
 
-	hugetlb_vma_lock_alloc(vma);
+	/*
+	 * vma_lock structure for sharable mappings is vma specific.
+	 * Clear old pointer (if copied via vm_area_dup) and create new.
+	 */
+	if (vma->vm_flags & VM_MAYSHARE) {
+		vma->vm_private_data = NULL;
+		hugetlb_vma_lock_alloc(vma);
+	}
 }
 
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
@@ -5168,19 +5175,23 @@ void __unmap_hugepage_range_final(struct
 			  unsigned long end, struct page *ref_page,
 			  zap_flags_t zap_flags)
 {
+	hugetlb_vma_lock_write(vma);
+	i_mmap_lock_write(vma->vm_file->f_mapping);
+
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
 	/*
-	 * Clear this flag so that x86's huge_pmd_share page_table_shareable
-	 * test will fail on a vma being torn down, and not grab a page table
-	 * on its way out.  We're lucky that the flag has such an appropriate
-	 * name, and can in fact be safely cleared here. We could clear it
-	 * before the __unmap_hugepage_range above, but all that's necessary
-	 * is to clear it before releasing the i_mmap_rwsem. This works
-	 * because in the context this is called, the VMA is about to be
-	 * destroyed and the i_mmap_rwsem is held.
+	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
+	 * the vma_lock is freed, this makes the vma ineligible for pmd
+	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
+	 * This is important as page tables for this unmapped range will
+	 * be asynchrously deleted.  If the page tables are shared, there
+	 * will be issues when accessed by someone else.
 	 */
-	vma->vm_flags &= ~VM_MAYSHARE;
+	hugetlb_vma_unlock_write(vma);
+	hugetlb_vma_lock_free(vma);
+
+	i_mmap_unlock_write(vma->vm_file->f_mapping);
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
@@ -6664,10 +6675,13 @@ static unsigned long page_table_shareabl
 	/*
 	 * match the virtual addresses, permission and the alignment of the
 	 * page table page.
+	 *
+	 * Also, vma_lock (vm_private_data) is required for sharing.
 	 */
 	if (pmd_index(addr) != pmd_index(saddr) ||
 	    vm_flags != svm_flags ||
-	    !range_in_vma(svma, sbase, s_end))
+	    !range_in_vma(svma, sbase, s_end) ||
+	    !svma->vm_private_data)
 		return 0;
 
 	return saddr;
@@ -6817,12 +6831,9 @@ void hugetlb_vma_lock_release(struct kre
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
 {
 	/*
-	 * Only present in sharable vmas.  See comment in
-	 * __unmap_hugepage_range_final about how VM_SHARED could
-	 * be set without VM_MAYSHARE.  As a result, we need to
-	 * check if either is set in the free path.
+	 * Only present in sharable vmas.
 	 */
-	if (!vma || !(vma->vm_flags & (VM_MAYSHARE | VM_SHARED)))
+	if (!vma || !__vma_shareable_flags_pmd(vma))
 		return;
 
 	if (vma->vm_private_data) {
--- a/mm/memory.c~hugetlb-fix-vma-lock-handling-during-split-vma-and-range-unmapping
+++ a/mm/memory.c
@@ -1685,12 +1685,8 @@ static void unmap_single_vma(struct mmu_
 			if (vma->vm_file) {
 				zap_flags_t zap_flags = details ?
 				    details->zap_flags : 0;
-				hugetlb_vma_lock_write(vma);
-				i_mmap_lock_write(vma->vm_file->f_mapping);
 				__unmap_hugepage_range_final(tlb, vma, start, end,
 							     NULL, zap_flags);
-				i_mmap_unlock_write(vma->vm_file->f_mapping);
-				hugetlb_vma_unlock_write(vma);
 			}
 		} else
 			unmap_page_range(tlb, vma, start, end, details);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

