Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854CDC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Oct 2022 21:29:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJGV31 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Oct 2022 17:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJGV3X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2022 17:29:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ABC95E51
        for <mm-commits@vger.kernel.org>; Fri,  7 Oct 2022 14:29:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B80D61B7F
        for <mm-commits@vger.kernel.org>; Fri,  7 Oct 2022 21:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F79CC433C1;
        Fri,  7 Oct 2022 21:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665178161;
        bh=+8LFoCVEuwD2NZmI0mRXBkIdUReoj0H9vqPPrV1CgyI=;
        h=Date:To:From:Subject:From;
        b=hFLaatLQcBzVqLni4V1nBn7gckQDZcU4E/UgsGBvsU/u9LXibJh2E5UQszL5gdtOD
         uTZsOWV99/CWSmXbr3Xw0qpndxADQbnmleJGdudzIHQFbuURKx3UinvL0sqFNZ5Qrk
         cD1v46k78SdTnVUZYJU0BfSuH/UwZEPkFjdQCN+U=
Date:   Fri, 07 Oct 2022 14:29:20 -0700
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
Subject: [merged mm-stable] hugetlb-allocate-vma-lock-for-all-sharable-vmas.patch removed from -mm tree
Message-Id: <20221007212921.8F79CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: allocate vma lock for all sharable vmas
has been removed from the -mm tree.  Its filename was
     hugetlb-allocate-vma-lock-for-all-sharable-vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: allocate vma lock for all sharable vmas
Date: Tue, 4 Oct 2022 18:17:07 -0700

The hugetlb vma lock was originally designed to synchronize pmd sharing. 
As such, it was only necessary to allocate the lock for vmas that were
capable of pmd sharing.  Later in the development cycle, it was discovered
that it could also be used to simplify fault/truncation races as described
in [1].  However, a subsequent change to allocate the lock for all vmas
that use the page cache was never made.  A fault/truncation race could
leave pages in a file past i_size until the file is removed.

Remove the previous restriction and allocate lock for all VM_MAYSHARE
vmas.  Warn in the unlikely event of allocation failure.

[1] https://lore.kernel.org/lkml/Yxiv0SkMkZ0JWGGp@monkey/#t

Link: https://lkml.kernel.org/r/20221005011707.514612-4-mike.kravetz@oracle.com
Fixes: "hugetlb: clean up code checking for fault/truncation races"
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

 mm/hugetlb.c |   50 ++++++++++++++-----------------------------------
 1 file changed, 15 insertions(+), 35 deletions(-)

--- a/mm/hugetlb.c~hugetlb-allocate-vma-lock-for-all-sharable-vmas
+++ a/mm/hugetlb.c
@@ -6687,10 +6687,11 @@ static unsigned long page_table_shareabl
 	return saddr;
 }
 
-static bool __vma_aligned_range_pmd_shareable(struct vm_area_struct *vma,
-				unsigned long start, unsigned long end,
-				bool check_vma_lock)
+bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr)
 {
+	unsigned long start = addr & PUD_MASK;
+	unsigned long end = start + PUD_SIZE;
+
 #ifdef CONFIG_USERFAULTFD
 	if (uffd_disable_huge_pmd_share(vma))
 		return false;
@@ -6700,38 +6701,13 @@ static bool __vma_aligned_range_pmd_shar
 	 */
 	if (!(vma->vm_flags & VM_MAYSHARE))
 		return false;
-	if (check_vma_lock && !vma->vm_private_data)
+	if (!vma->vm_private_data)	/* vma lock required for sharing */
 		return false;
 	if (!range_in_vma(vma, start, end))
 		return false;
 	return true;
 }
 
-static bool vma_pmd_shareable(struct vm_area_struct *vma)
-{
-	unsigned long start = ALIGN(vma->vm_start, PUD_SIZE),
-		      end = ALIGN_DOWN(vma->vm_end, PUD_SIZE);
-
-	if (start >= end)
-		return false;
-
-	return __vma_aligned_range_pmd_shareable(vma, start, end, false);
-}
-
-static bool vma_addr_pmd_shareable(struct vm_area_struct *vma,
-						unsigned long addr)
-{
-	unsigned long start = addr & PUD_MASK;
-	unsigned long end = start + PUD_SIZE;
-
-	return __vma_aligned_range_pmd_shareable(vma, start, end, true);
-}
-
-bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr)
-{
-	return vma_addr_pmd_shareable(vma, addr);
-}
-
 /*
  * Determine if start,end range within vma could be mapped by shared pmd.
  * If yes, adjust start and end to cover range associated with possible
@@ -6880,17 +6856,21 @@ static void hugetlb_vma_lock_alloc(struc
 	if (vma->vm_private_data)
 		return;
 
-	/* Check size/alignment for pmd sharing possible */
-	if (!vma_pmd_shareable(vma))
-		return;
-
 	vma_lock = kmalloc(sizeof(*vma_lock), GFP_KERNEL);
-	if (!vma_lock)
+	if (!vma_lock) {
 		/*
 		 * If we can not allocate structure, then vma can not
-		 * participate in pmd sharing.
+		 * participate in pmd sharing.  This is only a possible
+		 * performance enhancement and memory saving issue.
+		 * However, the lock is also used to synchronize page
+		 * faults with truncation.  If the lock is not present,
+		 * unlikely races could leave pages in a file past i_size
+		 * until the file is removed.  Warn in the unlikely case of
+		 * allocation failure.
 		 */
+		pr_warn_once("HugeTLB: unable to allocate vma specific lock\n");
 		return;
+	}
 
 	kref_init(&vma_lock->refs);
 	init_rwsem(&vma_lock->rw_sema);
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

