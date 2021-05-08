Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24330C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1360613E8
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEHWsC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWsC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A80136101D;
        Sat,  8 May 2021 22:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514020;
        bh=YZH0inQmM+UIxNVjjlZ7crvP9MN3VJcVefZQT0y7A/M=;
        h=Date:From:To:Subject:From;
        b=IzUVnjNUCa9YT0sBfpS1sC1y1t99D2kXdzBGGD/4ebdqL37MWL3yeYklW8u45b8m0
         HPOtq5UkSkALxJ1ifFBg/Q1i/V66ZPuKu9UcwQT1ExfyOu4+EvNtLzy1sRWfWl1h4L
         d8k4ozrXBgYemniK2iiKbMQ3DzagI4zgAu8DhnY0=
Date:   Sat, 08 May 2021 15:46:59 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, richard.weiyang@linux.alibaba.com,
        thomas_os@shipmail.org, vbabka@suse.cz, walken@google.com,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, yulei.kernel@gmail.com, ziy@nvidia.com
Subject:  [merged]
 mm-huge_memoryc-remove-redundant-pagecompound-check.patch removed from -mm
 tree
Message-ID: <20210508224659.EbcgZs3rv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: remove redundant PageCompound() check
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-remove-redundant-pagecompound-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: remove redundant PageCompound() check

The !PageCompound() check limits the page must be head or tail while
!PageHead() further limits it to page head only.  So !PageHead() check is
equivalent here.

Link: https://lkml.kernel.org/r/20210318122722.13135-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
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
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-remove-redundant-pagecompound-check
+++ a/mm/huge_memory.c
@@ -1291,7 +1291,7 @@ vm_fault_t do_huge_pmd_wp_page(struct vm
 	}
 
 	page = pmd_page(orig_pmd);
-	VM_BUG_ON_PAGE(!PageCompound(page) || !PageHead(page), page);
+	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	/* Lock page for reuse_swap_page() */
 	if (!trylock_page(page)) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


