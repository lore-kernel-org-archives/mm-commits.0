Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651F6C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4401A613F9
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhEEBeu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:34:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231221AbhEEBet (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:34:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C82D2613F0;
        Wed,  5 May 2021 01:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178433;
        bh=G/U5WhOHJmFHIjRJp/gNWp1uFOP8gPeMKe4owM7phH4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=TBou2+bH1FI8OGL7onEVBX3VsV8nizZHYqUQXP2/yiRckA6zumkBkeJQJTpaxpQXx
         C54Oq3MSA09etMibWytGaEP/zEwppc75zuH9DCbwgcK/KvjxgPbhDbBLydGzuWc6Gz
         cMmVFcMUlyYuk22R4lqACtwUQ8WrvVZzp9H/YiQo=
Date:   Tue, 04 May 2021 18:33:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, richard.weiyang@linux.alibaba.com,
        thomas_os@shipmail.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, walken@google.com, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com,
        yulei.kernel@gmail.com, ziy@nvidia.com
Subject:  [patch 022/143] mm/huge_memory.c: rework the function
 vma_adjust_trans_huge()
Message-ID: <20210505013352.pYR1qaNmD%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: rework the function vma_adjust_trans_huge()

Patch series "Some cleanups for huge_memory", v3.

This series contains cleanups to rework some function logics to make it
more readable, use helper function and so on.  More details can be found
in the respective changelogs.


This patch (of 6):

The current implementation of vma_adjust_trans_huge() contains some
duplicated codes.  Add helper function to get rid of these codes to make
it more succinct.

Link: https://lkml.kernel.org/r/20210318122722.13135-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20210318122722.13135-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Peter Xu <peterx@redhat.com>
Cc: yuleixzhang <yulei.kernel@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Thomas Hellstrm (Intel) <thomas_os@shipmail.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Cc: Wei Yang <richard.weiyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-rework-the-function-vma_adjust_trans_huge
+++ a/mm/huge_memory.c
@@ -2301,44 +2301,38 @@ void split_huge_pmd_address(struct vm_ar
 	__split_huge_pmd(vma, pmd, address, freeze, page);
 }
 
+static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned long address)
+{
+	/*
+	 * If the new address isn't hpage aligned and it could previously
+	 * contain an hugepage: check if we need to split an huge pmd.
+	 */
+	if (!IS_ALIGNED(address, HPAGE_PMD_SIZE) &&
+	    range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
+			 ALIGN(address, HPAGE_PMD_SIZE)))
+		split_huge_pmd_address(vma, address, false, NULL);
+}
+
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
 			     unsigned long start,
 			     unsigned long end,
 			     long adjust_next)
 {
-	/*
-	 * If the new start address isn't hpage aligned and it could
-	 * previously contain an hugepage: check if we need to split
-	 * an huge pmd.
-	 */
-	if (start & ~HPAGE_PMD_MASK &&
-	    (start & HPAGE_PMD_MASK) >= vma->vm_start &&
-	    (start & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
-		split_huge_pmd_address(vma, start, false, NULL);
+	/* Check if we need to split start first. */
+	split_huge_pmd_if_needed(vma, start);
 
-	/*
-	 * If the new end address isn't hpage aligned and it could
-	 * previously contain an hugepage: check if we need to split
-	 * an huge pmd.
-	 */
-	if (end & ~HPAGE_PMD_MASK &&
-	    (end & HPAGE_PMD_MASK) >= vma->vm_start &&
-	    (end & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= vma->vm_end)
-		split_huge_pmd_address(vma, end, false, NULL);
+	/* Check if we need to split end next. */
+	split_huge_pmd_if_needed(vma, end);
 
 	/*
-	 * If we're also updating the vma->vm_next->vm_start, if the new
-	 * vm_next->vm_start isn't hpage aligned and it could previously
-	 * contain an hugepage: check if we need to split an huge pmd.
+	 * If we're also updating the vma->vm_next->vm_start,
+	 * check if we need to split it.
 	 */
 	if (adjust_next > 0) {
 		struct vm_area_struct *next = vma->vm_next;
 		unsigned long nstart = next->vm_start;
 		nstart += adjust_next;
-		if (nstart & ~HPAGE_PMD_MASK &&
-		    (nstart & HPAGE_PMD_MASK) >= next->vm_start &&
-		    (nstart & HPAGE_PMD_MASK) + HPAGE_PMD_SIZE <= next->vm_end)
-			split_huge_pmd_address(next, nstart, false, NULL);
+		split_huge_pmd_if_needed(next, nstart);
 	}
 }
 
_
