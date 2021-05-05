Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8758C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DA3C613FE
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhEEBe4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:34:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231221AbhEEBe4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:34:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65B5A613F5;
        Wed,  5 May 2021 01:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178439;
        bh=sqXXbb8YiLRc4L+59CMDwfq41lKXzda8xwoIEdH22HI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ss4asmV6N6gyueVE00IjmRBUTOvbT0DCoAflUvR/1VKlIA9g9re4KLIv6PJjGXJSY
         T5O54RBkL27eWN+3XmwPvp+EiNEoE7RZAVU08UcqD/ARp5y6/2hbz5QNSZ6wzF8iBU
         mVWwrXx0eT4qQnJ8pcefQxwHTc8nfPPCfkglabCs=
Date:   Tue, 04 May 2021 18:33:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, richard.weiyang@linux.alibaba.com,
        thomas_os@shipmail.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, walken@google.com, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com,
        yulei.kernel@gmail.com, ziy@nvidia.com
Subject:  [patch 024/143] mm/huge_memory.c: rework the function
 do_huge_pmd_numa_page() slightly
Message-ID: <20210505013359.lNWeVfPym%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
