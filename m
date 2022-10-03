Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1620DC43219
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiJCVOb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbiJCVMs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:12:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E2CC7B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 30A0A611CB
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854BAC433D7;
        Mon,  3 Oct 2022 21:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831276;
        bh=9sCdbl35H0mGe6z16/mWs2bBRklHSSm1dEbx5DWGpZs=;
        h=Date:To:From:Subject:From;
        b=LS1yXFGj314gN4JkgVOe6Or6140611wBl7l6Dc+nJxdmOAn3X5n6sonBHD+K5B7ml
         6tkZstKiTPxt0tfbAzgCOnTYmI0CSQOIMxARFElvcBmUq4gHcuRNqH2qgPUS+7fGu/
         ZpzzbqICCW6skJ4yZAvRyMAHpkKTCMalJVik6Fbg=
Date:   Mon, 03 Oct 2022 14:07:55 -0700
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
Subject: [merged mm-stable] hugetlb-rename-vma_shareable-and-refactor-code.patch removed from -mm tree
Message-Id: <20221003210756.854BAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: rename vma_shareable() and refactor code
has been removed from the -mm tree.  Its filename was
     hugetlb-rename-vma_shareable-and-refactor-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: rename vma_shareable() and refactor code
Date: Wed, 14 Sep 2022 15:18:06 -0700

Rename the routine vma_shareable to vma_addr_pmd_shareable as it is
checking a specific address within the vma.  Refactor code to check if an
aligned range is shareable as this will be needed in a subsequent patch.

Link: https://lkml.kernel.org/r/20220914221810.95771-6-mike.kravetz@oracle.com
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

 mm/hugetlb.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/mm/hugetlb.c~hugetlb-rename-vma_shareable-and-refactor-code
+++ a/mm/hugetlb.c
@@ -6640,26 +6640,33 @@ static unsigned long page_table_shareabl
 	return saddr;
 }
 
-static bool vma_shareable(struct vm_area_struct *vma, unsigned long addr)
+static bool __vma_aligned_range_pmd_shareable(struct vm_area_struct *vma,
+				unsigned long start, unsigned long end)
 {
-	unsigned long base = addr & PUD_MASK;
-	unsigned long end = base + PUD_SIZE;
-
 	/*
 	 * check on proper vm_flags and page table alignment
 	 */
-	if (vma->vm_flags & VM_MAYSHARE && range_in_vma(vma, base, end))
+	if (vma->vm_flags & VM_MAYSHARE && range_in_vma(vma, start, end))
 		return true;
 	return false;
 }
 
+static bool vma_addr_pmd_shareable(struct vm_area_struct *vma,
+						unsigned long addr)
+{
+	unsigned long start = addr & PUD_MASK;
+	unsigned long end = start + PUD_SIZE;
+
+	return __vma_aligned_range_pmd_shareable(vma, start, end);
+}
+
 bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr)
 {
 #ifdef CONFIG_USERFAULTFD
 	if (uffd_disable_huge_pmd_share(vma))
 		return false;
 #endif
-	return vma_shareable(vma, addr);
+	return vma_addr_pmd_shareable(vma, addr);
 }
 
 /*
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

