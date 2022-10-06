Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32113C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  6 Oct 2022 20:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiJFU6X (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Oct 2022 16:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiJFU6W (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Oct 2022 16:58:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0BABBE3D
        for <mm-commits@vger.kernel.org>; Thu,  6 Oct 2022 13:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8945CB8218E
        for <mm-commits@vger.kernel.org>; Thu,  6 Oct 2022 20:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E302C433C1;
        Thu,  6 Oct 2022 20:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665089897;
        bh=l76KoT2jgfd767lzLI0/ATycejnj41Fb8STZ2nGeYJw=;
        h=Date:To:From:Subject:From;
        b=sXWkqZ2ub1SY5nQihxb4UwDlnQa7f+kB/wQkW0D7gcUkNuPLH6+qOj48MaR4U0yeq
         YXmpocQSqFWtUX1syACxt38NloiPrH/pBJZTYfYjQcAWBXYpHiF2zkWKO5SBLQQz1b
         68jd3JhUxAEQ+7ch6oLpBKLpSNVCQWiqzECUGbtY=
Date:   Thu, 06 Oct 2022 13:58:16 -0700
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
Subject: + hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer.patch added to mm-unstable branch
Message-Id: <20221006205817.3E302C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: take hugetlb vma_lock when clearing vma_lock->vma pointer
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer.patch

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
Subject: hugetlb: take hugetlb vma_lock when clearing vma_lock->vma pointer
Date: Tue, 4 Oct 2022 18:17:06 -0700

hugetlb file truncation/hole punch code may need to back out and take
locks in order in the routine hugetlb_unmap_file_folio().  This code could
race with vma freeing as pointed out in [1] and result in accessing a
stale vma pointer.  To address this, take the vma_lock when clearing the
vma_lock->vma pointer.

[1] https://lore.kernel.org/linux-mm/01f10195-7088-4462-6def-909549c75ef4@huawei.com/

Link: https://lkml.kernel.org/r/20221005011707.514612-3-mike.kravetz@oracle.com
Fixes: "hugetlb: use new vma_lock for pmd sharing synchronization"
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

 mm/hugetlb.c |   38 ++++++++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer
+++ a/mm/hugetlb.c
@@ -93,6 +93,7 @@ struct mutex *hugetlb_fault_mutex_table
 static int hugetlb_acct_memory(struct hstate *h, long delta);
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
+static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
@@ -5192,8 +5193,7 @@ void __unmap_hugepage_range_final(struct
 	 * be asynchrously deleted.  If the page tables are shared, there
 	 * will be issues when accessed by someone else.
 	 */
-	hugetlb_vma_unlock_write(vma);
-	hugetlb_vma_lock_free(vma);
+	__hugetlb_vma_unlock_write_free(vma);
 
 	i_mmap_unlock_write(vma->vm_file->f_mapping);
 }
@@ -6832,6 +6832,30 @@ void hugetlb_vma_lock_release(struct kre
 	kfree(vma_lock);
 }
 
+void __hugetlb_vma_unlock_write_put(struct hugetlb_vma_lock *vma_lock)
+{
+	struct vm_area_struct *vma = vma_lock->vma;
+
+	/*
+	 * vma_lock structure may or not be released as a result of put,
+	 * it certainly will no longer be attached to vma so clear pointer.
+	 * Semaphore synchronizes access to vma_lock->vma field.
+	 */
+	vma_lock->vma = NULL;
+	vma->vm_private_data = NULL;
+	up_write(&vma_lock->rw_sema);
+	kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
+}
+
+void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_flags_pmd(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		__hugetlb_vma_unlock_write_put(vma_lock);
+	}
+}
+
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
 {
 	/*
@@ -6843,14 +6867,8 @@ static void hugetlb_vma_lock_free(struct
 	if (vma->vm_private_data) {
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
-		/*
-		 * vma_lock structure may or not be released, but it
-		 * certainly will no longer be attached to vma so clear
-		 * pointer.
-		 */
-		vma_lock->vma = NULL;
-		kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
-		vma->vm_private_data = NULL;
+		down_write(&vma_lock->rw_sema);
+		__hugetlb_vma_unlock_write_put(vma_lock);
 	}
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-fix-vma-lock-handling-during-split-vma-and-range-unmapping.patch
hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer.patch
hugetlb-take-hugetlb-vma_lock-when-clearing-vma_lock-vma-pointer-fix.patch
hugetlb-allocate-vma-lock-for-all-sharable-vmas.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

