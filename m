Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D626C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Oct 2022 21:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiJGV1L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Oct 2022 17:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiJGV1K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2022 17:27:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C368F258
        for <mm-commits@vger.kernel.org>; Fri,  7 Oct 2022 14:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5A0661B7F
        for <mm-commits@vger.kernel.org>; Fri,  7 Oct 2022 21:27:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C396C433D7;
        Fri,  7 Oct 2022 21:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665178028;
        bh=c4fGH4aB8SJi4+lSGLi4/DYBI0pfqCF7h6cTbaAlQ9Q=;
        h=Date:To:From:Subject:From;
        b=NiEM1KwQ0xBG/0Ey6kfVIKTa7YOkuTmYt4cl8RgDF9uHrMAPxzEEE1wmMl+2eIzpp
         gaLDltp7os17dbP0LS7bN5TDTIEGSdeZHU7CSQe9hPN5owDSj895CBywnQRAZrif0e
         Xh8L9OY6/sy96d1r5rcA2C23ccegdK8IrntAEfyY=
Date:   Fri, 07 Oct 2022 14:27:07 -0700
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
Subject: [folded-merged] hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix.patch removed from -mm tree
Message-Id: <20221007212708.1C396C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix.patch

This patch was dropped because it was folded into hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer.patch

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix
Date: Wed, 5 Oct 2022 20:30:30 -0700

address build issues

Link: https://lkml.kernel.org/r/Yz5L1uxQYR1VqFtJ@monkey
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

 mm/hugetlb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix
+++ a/mm/hugetlb.c
@@ -6847,7 +6847,7 @@ void __hugetlb_vma_unlock_write_put(stru
 	kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
 }
 
-void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
+static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
 {
 	if (__vma_shareable_flags_pmd(vma)) {
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
@@ -7019,6 +7019,10 @@ void hugetlb_vma_lock_release(struct kre
 {
 }
 
+static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
+{
+}
+
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
 {
 }
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-fix-vma-lock-handling-during-split-vma-and-range-unmapping.patch
hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer.patch
hugetlb-allocate-vma-lock-for-all-sharable-vmas.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

