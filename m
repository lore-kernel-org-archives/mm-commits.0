Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 885A0C678DB
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbjASBOy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjASBOE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:14:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC1268439
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:13:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0904B81F6C
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EF6C433EF;
        Thu, 19 Jan 2023 01:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090832;
        bh=sM7OwCTRKV7mw3zrEILWgTzjGTLrm2+cjmQ6Tav3CWw=;
        h=Date:To:From:Subject:From;
        b=mE6yGKLUhrjq4hZzKOv3iObcuqLxqpFBmlgYssUmjaU5GZ30GyFNIeHtn4f9Rf6Y3
         GnUIJ6t6Vdw1Z0X1i9YDvMoYDu8XAnoMlR4a3FQUgsUn34X45CgYQp3leqizBJEtLv
         g9jlsCopc0bBhRhy5+u/sf2WCL4VSn6TUXXpwYbc=
Date:   Wed, 18 Jan 2023 17:13:52 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        riel@surriel.com, nadav.amit@gmail.com, mike.kravetz@oracle.com,
        linmiaohe@huawei.com, jthoughton@google.com, jhubbard@nvidia.com,
        jannh@google.com, david@redhat.com, aarcange@redhat.com,
        peterx@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch removed from -mm tree
Message-Id: <20230119011352.96EF6C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: make userfaultfd_huge_must_wait() safe to pmd unshare
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: make userfaultfd_huge_must_wait() safe to pmd unshare
Date: Fri, 16 Dec 2022 10:52:17 -0500

We can take the hugetlb walker lock, here taking vma lock directly.

Link: https://lkml.kernel.org/r/20221216155217.2043700-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/fs/userfaultfd.c~mm-hugetlb-make-userfaultfd_huge_must_wait-safe-to-pmd-unshare
+++ a/fs/userfaultfd.c
@@ -391,7 +391,8 @@ static inline unsigned int userfaultfd_g
  */
 vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 {
-	struct mm_struct *mm = vmf->vma->vm_mm;
+	struct vm_area_struct *vma = vmf->vma;
+	struct mm_struct *mm = vma->vm_mm;
 	struct userfaultfd_ctx *ctx;
 	struct userfaultfd_wait_queue uwq;
 	vm_fault_t ret = VM_FAULT_SIGBUS;
@@ -418,7 +419,7 @@ vm_fault_t handle_userfault(struct vm_fa
 	 */
 	mmap_assert_locked(mm);
 
-	ctx = vmf->vma->vm_userfaultfd_ctx.ctx;
+	ctx = vma->vm_userfaultfd_ctx.ctx;
 	if (!ctx)
 		goto out;
 
@@ -508,6 +509,15 @@ vm_fault_t handle_userfault(struct vm_fa
 
 	blocking_state = userfaultfd_get_blocking_state(vmf->flags);
 
+        /*
+         * Take the vma lock now, in order to safely call
+         * userfaultfd_huge_must_wait() later. Since acquiring the
+         * (sleepable) vma lock can modify the current task state, that
+         * must be before explicitly calling set_current_state().
+         */
+	if (is_vm_hugetlb_page(vma))
+		hugetlb_vma_lock_read(vma);
+
 	spin_lock_irq(&ctx->fault_pending_wqh.lock);
 	/*
 	 * After the __add_wait_queue the uwq is visible to userland
@@ -522,13 +532,15 @@ vm_fault_t handle_userfault(struct vm_fa
 	set_current_state(blocking_state);
 	spin_unlock_irq(&ctx->fault_pending_wqh.lock);
 
-	if (!is_vm_hugetlb_page(vmf->vma))
+	if (!is_vm_hugetlb_page(vma))
 		must_wait = userfaultfd_must_wait(ctx, vmf->address, vmf->flags,
 						  reason);
 	else
-		must_wait = userfaultfd_huge_must_wait(ctx, vmf->vma,
+		must_wait = userfaultfd_huge_must_wait(ctx, vma,
 						       vmf->address,
 						       vmf->flags, reason);
+	if (is_vm_hugetlb_page(vma))
+		hugetlb_vma_unlock_read(vma);
 	mmap_read_unlock(mm);
 
 	if (likely(must_wait && !READ_ONCE(ctx->released))) {
_

Patches currently in -mm which might be from peterx@redhat.com are

selftests-vm-remove-__use_gnu-in-hugetlb-madvisec.patch

