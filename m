Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4F1C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 21 Oct 2022 04:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiJUEf7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Oct 2022 00:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiJUEfK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2022 00:35:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E280145F4B
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 21:34:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5933D61DAA
        for <mm-commits@vger.kernel.org>; Fri, 21 Oct 2022 04:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB372C433B5;
        Fri, 21 Oct 2022 04:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666326896;
        bh=FFFvjujskQ/SPX1FShFPpN5P1rPprXeYTk2L1WQ/tHk=;
        h=Date:To:From:Subject:From;
        b=BwDWajDT+1DWHkYbJ0xI5HMuCcqRnxQ4vX+lIxFwzd4qNs+uHbXc5awDP8rbCa0dE
         6qHkZ5gpyTHZosGg7nc/r7xKjo/N6Yovl+rREqn/PuqibRgmzumDPVAVRruh603adw
         i+pW1JSo7yWesAsoQNPXIJ16KgILs2EYJ50ChIF4=
Date:   Thu, 20 Oct 2022 21:34:55 -0700
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
Subject: [merged mm-hotfixes-stable] hugetlb-fix-memory-leak-associated-with-vma_lock-structure.patch removed from -mm tree
Message-Id: <20221021043456.AB372C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: fix memory leak associated with vma_lock structure
has been removed from the -mm tree.  Its filename was
     hugetlb-fix-memory-leak-associated-with-vma_lock-structure.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: fix memory leak associated with vma_lock structure
Date: Wed, 19 Oct 2022 13:19:57 -0700

The hugetlb vma_lock structure hangs off the vm_private_data pointer of
sharable hugetlb vmas.  The structure is vma specific and can not be
shared between vmas.  At fork and various other times, vmas are duplicated
via vm_area_dup().  When this happens, the pointer in the newly created
vma must be cleared and the structure reallocated.  Two hugetlb specific
routines deal with this hugetlb_dup_vma_private and hugetlb_vm_op_open. 
Both routines are called for newly created vmas.  hugetlb_dup_vma_private
would always clear the pointer and hugetlb_vm_op_open would allocate the
new vms_lock structure.  This did not work in the case of this calling
sequence pointed out in [1].

  move_vma
    copy_vma
      new_vma = vm_area_dup(vma);
      new_vma->vm_ops->open(new_vma); --> new_vma has its own vma lock.
    is_vm_hugetlb_page(vma)
      clear_vma_resv_huge_pages
        hugetlb_dup_vma_private --> vma->vm_private_data is set to NULL

When clearing hugetlb_dup_vma_private we actually leak the associated
vma_lock structure.

The vma_lock structure contains a pointer to the associated vma.  This
information can be used in hugetlb_dup_vma_private and hugetlb_vm_op_open
to ensure we only clear the vm_private_data of newly created (copied)
vmas.  In such cases, the vma->vma_lock->vma field will not point to the
vma.

Update hugetlb_dup_vma_private and hugetlb_vm_op_open to not clear
vm_private_data if vma->vma_lock->vma == vma.  Also, log a warning if
hugetlb_vm_op_open ever encounters the case where vma_lock has already
been correctly allocated for the vma.

[1] https://lore.kernel.org/linux-mm/5154292a-4c55-28cd-0935-82441e512fc3@huawei.com/

Link: https://lkml.kernel.org/r/20221019201957.34607-1-mike.kravetz@oracle.com
Fixes: 131a79b474e9 ("hugetlb: fix vma lock handling during split vma and range unmapping")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: James Houghton <jthoughton@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
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

 mm/hugetlb.c |   35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

--- a/mm/hugetlb.c~hugetlb-fix-memory-leak-associated-with-vma_lock-structure
+++ a/mm/hugetlb.c
@@ -1014,15 +1014,23 @@ void hugetlb_dup_vma_private(struct vm_a
 	VM_BUG_ON_VMA(!is_vm_hugetlb_page(vma), vma);
 	/*
 	 * Clear vm_private_data
+	 * - For shared mappings this is a per-vma semaphore that may be
+	 *   allocated in a subsequent call to hugetlb_vm_op_open.
+	 *   Before clearing, make sure pointer is not associated with vma
+	 *   as this will leak the structure.  This is the case when called
+	 *   via clear_vma_resv_huge_pages() and hugetlb_vm_op_open has already
+	 *   been called to allocate a new structure.
 	 * - For MAP_PRIVATE mappings, this is the reserve map which does
 	 *   not apply to children.  Faults generated by the children are
 	 *   not guaranteed to succeed, even if read-only.
-	 * - For shared mappings this is a per-vma semaphore that may be
-	 *   allocated in a subsequent call to hugetlb_vm_op_open.
 	 */
-	vma->vm_private_data = (void *)0;
-	if (!(vma->vm_flags & VM_MAYSHARE))
-		return;
+	if (vma->vm_flags & VM_MAYSHARE) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		if (vma_lock && vma_lock->vma != vma)
+			vma->vm_private_data = NULL;
+	} else
+		vma->vm_private_data = NULL;
 }
 
 /*
@@ -4601,6 +4609,7 @@ static void hugetlb_vm_op_open(struct vm
 	struct resv_map *resv = vma_resv_map(vma);
 
 	/*
+	 * HPAGE_RESV_OWNER indicates a private mapping.
 	 * This new VMA should share its siblings reservation map if present.
 	 * The VMA will only ever have a valid reservation map pointer where
 	 * it is being copied for another still existing VMA.  As that VMA
@@ -4615,11 +4624,21 @@ static void hugetlb_vm_op_open(struct vm
 
 	/*
 	 * vma_lock structure for sharable mappings is vma specific.
-	 * Clear old pointer (if copied via vm_area_dup) and create new.
+	 * Clear old pointer (if copied via vm_area_dup) and allocate
+	 * new structure.  Before clearing, make sure vma_lock is not
+	 * for this vma.
 	 */
 	if (vma->vm_flags & VM_MAYSHARE) {
-		vma->vm_private_data = NULL;
-		hugetlb_vma_lock_alloc(vma);
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		if (vma_lock) {
+			if (vma_lock->vma != vma) {
+				vma->vm_private_data = NULL;
+				hugetlb_vma_lock_alloc(vma);
+			} else
+				pr_warn("HugeTLB: vma_lock already exists in %s.\n", __func__);
+		} else
+			hugetlb_vma_lock_alloc(vma);
 	}
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

