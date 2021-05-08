Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D58C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14CFD610D2
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhEHWr7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229616AbhEHWr7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A64326101D;
        Sat,  8 May 2021 22:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514017;
        bh=YPKw1li7Vt8GAmUiBZCNHIq4xw791fTrfW+O78jcmxw=;
        h=Date:From:To:Subject:From;
        b=cTYp8STQIZlplNiM6EbgrD0GcRPJVzVD85lTyypGd4uWgxSOvomaqP2+csIR1SR1P
         dag0p9+IH7SozRETA+qdyRwp6erfeFXZEESDc8fCPc6tApYHJyKKct2xma+Rhat2SX
         wMoFeNuKZc3Hd7k0OwKBj8fADLrhVs/XNJzPXS0w=
Date:   Sat, 08 May 2021 15:46:56 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, richard.weiyang@linux.alibaba.com,
        thomas_os@shipmail.org, vbabka@suse.cz, walken@google.com,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, yulei.kernel@gmail.com, ziy@nvidia.com
Subject:  [merged]
 mm-huge_memoryc-rework-the-function-do_huge_pmd_numa_page-slightly.patch
 removed from -mm tree
Message-ID: <20210508224656.-sZzvAFi0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: rework the function do_huge_pmd_numa_page() slightly
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-rework-the-function-do_huge_pmd_numa_page-slightly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: rework the function do_huge_pmd_numa_page() slightly

The current code that checks if migrating misplaced transhuge page is
needed is pretty hard to follow.  Rework it and add a comment to make its
logic more clear and improve readability.

Link: https://lkml.kernel.org/r/20210318122722.13135-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Thomas Hellstrm (Intel) <thomas_os@shipmail.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: yuleixzhang <yulei.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-rework-the-function-do_huge_pmd_numa_page-slightly
+++ a/mm/huge_memory.c
@@ -1462,12 +1462,6 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	 */
 	page_locked = trylock_page(page);
 	target_nid = mpol_misplaced(page, vma, haddr);
-	if (target_nid == NUMA_NO_NODE) {
-		/* If the page was locked, there are no parallel migrations */
-		if (page_locked)
-			goto clear_pmdnuma;
-	}
-
 	/* Migration could have started since the pmd_trans_migrating check */
 	if (!page_locked) {
 		page_nid = NUMA_NO_NODE;
@@ -1476,6 +1470,11 @@ vm_fault_t do_huge_pmd_numa_page(struct
 		spin_unlock(vmf->ptl);
 		put_and_wait_on_page_locked(page, TASK_UNINTERRUPTIBLE);
 		goto out;
+	} else if (target_nid == NUMA_NO_NODE) {
+		/* There are no parallel migrations and page is in the right
+		 * node. Clear the numa hinting info in this pmd.
+		 */
+		goto clear_pmdnuma;
 	}
 
 	/*
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


