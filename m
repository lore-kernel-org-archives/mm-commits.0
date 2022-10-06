Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22996C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  6 Oct 2022 20:58:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJFU6Y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Oct 2022 16:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiJFU6X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2022 16:58:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186FCB6029
        for <mm-commits@vger.kernel.org>; Thu,  6 Oct 2022 13:58:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFCCBB820D8
        for <mm-commits@vger.kernel.org>; Thu,  6 Oct 2022 20:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BD0C433D6;
        Thu,  6 Oct 2022 20:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665089899;
        bh=uFslZktp5Y3lDpSBLfGotrXOd3dduebIVAhoeQsJIG8=;
        h=Date:To:From:Subject:From;
        b=Czwa6ESy38Fq2lC9ujH3ZQF6Na9K2Cb3nIvfUWqBmHSf2+I7lkLKZiOw+eQle5KtT
         JtTio1tbAsuOnfl0fOI9DAF/yF5fBhjKY17aE9t2ohbd5qaW8NgPsu/Gvcds2pawPN
         HL0K1WXBdirA7ewXkOjvzffurcvhjPhq6Nd4vSdA=
Date:   Thu, 06 Oct 2022 13:58:18 -0700
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
Subject: + hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix.patch added to mm-unstable branch
Message-Id: <20221006205819.73BD0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix.patch

This patch will later appear in the mm-unstable branch at
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
hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix.patch
hugetlb-allocate-vma-lock-for-all-sharable-vmas.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

