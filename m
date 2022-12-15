Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7794C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 15 Dec 2022 22:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiLOWek (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 17:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLOWej (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 17:34:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8045E083
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 14:34:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A39461F56
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 22:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A7CC433EF;
        Thu, 15 Dec 2022 22:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671143677;
        bh=l4Wk5NH45mkS/nL2v+EReaVSaz3G2cklF7r5jnXbusk=;
        h=Date:To:From:Subject:From;
        b=Hku9WUsIKuTZjbIFwMDhPOASh6lZXvFkyQpM0E/0c+AcIO0U2yMGgKdaf8+WqqMKp
         SAPH/sKUfyEeM1SI4Ljr0DMcPdpS06GpyKQyoFIhZxM/TApwcZ0CREKgLif8bkCdft
         KjLSRukNCpq3kaX2C9XZDJHB8wPqEccrakh2Hl6c=
Date:   Thu, 15 Dec 2022 14:34:36 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        peterx@redhat.com, naoya.horiguchi@linux.dev, linmiaohe@huawei.com,
        jthoughton@google.com, david@redhat.com,
        aneesh.kumar@linux.vnet.ibm.com, almasrymina@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-update-vma-flag-check-for-hugetlb-vma-lock.patch added to mm-unstable branch
Message-Id: <20221215223436.F1A7CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: update vma flag check for hugetlb vma lock
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-update-vma-flag-check-for-hugetlb-vma-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-update-vma-flag-check-for-hugetlb-vma-lock.patch

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
Subject: hugetlb: update vma flag check for hugetlb vma lock
Date: Mon, 12 Dec 2022 15:50:42 -0800

The check for whether a hugetlb vma lock exists partially depends on the
vma's flags.  Currently, it checks for either VM_MAYSHARE or VM_SHARED. 
The reason both flags are used is because VM_MAYSHARE was previously
cleared in hugetlb vmas as they are tore down.  This is no longer the
case, and only the VM_MAYSHARE check is required.

Link: https://lkml.kernel.org/r/20221212235042.178355-2-mike.kravetz@oracle.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb.c~hugetlb-update-vma-flag-check-for-hugetlb-vma-lock
+++ a/mm/hugetlb.c
@@ -260,8 +260,7 @@ static inline struct hugepage_subpool *s
  */
 static bool __vma_shareable_lock(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_MAYSHARE | VM_SHARED) &&
-		vma->vm_private_data;
+	return vma->vm_flags & VM_MAYSHARE && vma->vm_private_data;
 }
 
 void hugetlb_vma_lock_read(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-really-allocate-vma-lock-for-all-sharable-vmas.patch
hugetlb-update-vma-flag-check-for-hugetlb-vma-lock.patch

