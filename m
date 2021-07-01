Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC977C11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:51:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B5416124B
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 00:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhGAAyB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 20:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236299AbhGAAyB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 20:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81E066146B;
        Thu,  1 Jul 2021 00:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625100691;
        bh=LXRq5emsfdgVBKHvI6Ba7cZP+8nfLg8cYAltMrpkf5k=;
        h=Date:From:To:Subject:From;
        b=TdBf6jaHSM8sQUw4KcluVjSpjXCKMfyy/dlV9gto188G2H9JomHm2HJdLtGPvH/ci
         J4ZBZPLGBbVaApGKWC5HQXBxgMlk462u85jc06g3406dzWP8zh5u3E3x+IRPWQ8j46
         7/ijtavKPnZAw+sxmqddhHMTLA1I/yjmn3AFX180=
Date:   Wed, 30 Jun 2021 17:51:31 -0700
From:   akpm@linux-foundation.org
To:     almasrymina@google.com, axelrasmussen@google.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        peterx@redhat.com, yuehaibing@huawei.com
Subject:  [folded-merged]
 mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix.patch
 removed from -mm tree
Message-ID: <20210701005131.ex7f4M5Te%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: userfaultfd: remove set but not used variable 'vm_alloc_shared'
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix.patch

This patch was dropped because it was folded into mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy.patch

------------------------------------------------------
From: YueHaibing <yuehaibing@huawei.com>
Subject: userfaultfd: remove set but not used variable 'vm_alloc_shared'

mm/userfaultfd.c: In function `__mcopy_atomic_hugetlb':
mm/userfaultfd.c:284:6: warning: variable `vm_alloc_shared' set but not used [-Wunused-but-set-variable]
  int vm_alloc_shared = dst_vma->vm_flags & VM_SHARED;
      ^~~~~~~~~~~~~~~

commit 1786d0012620 ("mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY")
left behind this.

Link: https://lkml.kernel.org/r/20210601141610.28332-1-yuehaibing@huawei.com
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/userfaultfd.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/userfaultfd.c~mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy-fix
+++ a/mm/userfaultfd.c
@@ -209,7 +209,6 @@ static __always_inline ssize_t __mcopy_a
 					      unsigned long len,
 					      enum mcopy_atomic_mode mode)
 {
-	int vm_alloc_shared = dst_vma->vm_flags & VM_SHARED;
 	int vm_shared = dst_vma->vm_flags & VM_SHARED;
 	ssize_t err;
 	pte_t *dst_pte;
@@ -308,7 +307,6 @@ retry:
 
 		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		i_mmap_unlock_read(mapping);
-		vm_alloc_shared = vm_shared;
 
 		cond_resched();
 
_

Patches currently in -mm which might be from yuehaibing@huawei.com are

mm-dmapool-use-device_attr_ro-macro.patch
mm-hugetlb-fix-racy-resv_huge_pages-underflow-on-uffdio_copy.patch
mm-compaction-use-device_attr_wo-macro.patch

