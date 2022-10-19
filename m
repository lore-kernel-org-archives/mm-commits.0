Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430FEC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbiJSXDP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiJSXCz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:02:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5C21911CF
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:02:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5D69B822C8
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1D0C433D6;
        Wed, 19 Oct 2022 23:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666220497;
        bh=3g7wLAg68hNV434A6rJ1Pmh+QOGBrcoEBck17P5Q9KY=;
        h=Date:To:From:Subject:From;
        b=XoiCp1Noe3Z+/b04YTwIdYVjLJFmGBxJdH2Sz+sJyO2nqfTDUoOe8N9xJASUeA+m0
         0L7xQP4AaldQP25yCpLA0OcT9K6czxXVV1juv84YtieD4+9wRGk1cmU6qD1gQG4G/a
         C0dtYykyEvHsu73gpxe/wmt+0+ECOpmpGQcUWPm4=
Date:   Wed, 19 Oct 2022 16:01:36 -0700
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
Subject: + hugetlb-fix-memory-leak-associated-with-vma_lock-structure.patch added to mm-hotfixes-unstable branch
Message-Id: <20221019230137.5B1D0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix memory leak associated with vma_lock structure
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlb-fix-memory-leak-associated-with-vma_lock-structure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-fix-memory-leak-associated-with-vma_lock-structure.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-mmap-undo-mmap-when-mas_preallocate-fails.patch
hugetlb-fix-memory-leak-associated-with-vma_lock-structure.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

