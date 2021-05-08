Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93770C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78059613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhEHWru (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhEHWru (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82A8B610D2;
        Sat,  8 May 2021 22:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514008;
        bh=Lv3DuEzxli1FA1N4jFKG0ZxZGeNYpOnvY0+x1rZNNn8=;
        h=Date:From:To:Subject:From;
        b=yQqwjrnrikAeSzkscYpepBICFOhJNS6t2w7Z6fwpwbdfqFmvoOZH7xeddkvt3Vhk+
         q95gpYg3dVYdMIO7OMUHRxZ7JFO36m/iSo7BGMnRKXI1nsmrk76uMMrIsDxvyFM2un
         pxQwWP+vNXOln1qqgrFNqhvDMt18A+4gAcjQjxdA=
Date:   Sat, 08 May 2021 15:46:48 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-huge_memoryc-remove-unnecessary-local-variable-ret2.patch removed from
 -mm tree
Message-ID: <20210508224648.feJRybDOv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: remove unnecessary local variable ret2
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-remove-unnecessary-local-variable-ret2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: remove unnecessary local variable ret2

There is no need to use a new local variable ret2 to get the return value
of handle_userfault(). Use ret directly to make code more succinct.

Link: https://lkml.kernel.org/r/20210210072409.60587-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-remove-unnecessary-local-variable-ret2
+++ a/mm/huge_memory.c
@@ -624,14 +624,12 @@ static vm_fault_t __do_huge_pmd_anonymou
 
 		/* Deliver the page fault to userland */
 		if (userfaultfd_missing(vma)) {
-			vm_fault_t ret2;
-
 			spin_unlock(vmf->ptl);
 			put_page(page);
 			pte_free(vma->vm_mm, pgtable);
-			ret2 = handle_userfault(vmf, VM_UFFD_MISSING);
-			VM_BUG_ON(ret2 & VM_FAULT_FALLBACK);
-			return ret2;
+			ret = handle_userfault(vmf, VM_UFFD_MISSING);
+			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
+			return ret;
 		}
 
 		entry = mk_huge_pmd(page, vma->vm_page_prot);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


