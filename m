Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F99DC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7583D613C5
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:47:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhEHWsF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:48:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWsF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:48:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A726D6101D;
        Sat,  8 May 2021 22:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514023;
        bh=OaRTFlLc9Kkzx0MQfjcJpyocfYTw1qsM0Nuad63Z4ME=;
        h=Date:From:To:Subject:From;
        b=kxqs0J7fuyMYil8G52yTrZQEDpiRBXETgFzW6zYN4QNG2bURg4Hl1QCkK+HzQua75
         Q4YXg/NpZsrHnKD2C2QIwroznjEA5KBxvoEidPBmJ7ecxUfzNKdsX5Msq86huFJiWu
         ZUipbexPQBv/HqxE3cN9I05KRc4HpTBAmoT2chh8=
Date:   Sat, 08 May 2021 15:47:02 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, richard.weiyang@linux.alibaba.com,
        thomas_os@shipmail.org, vbabka@suse.cz, walken@google.com,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, yulei.kernel@gmail.com, ziy@nvidia.com
Subject:  [merged]
 =?US-ASCII?Q?mm-huge=5Fmemoryc-remove-unused-macro-transparent=5Fhugep?=
 =?US-ASCII?Q?age=5Fdebug=5Fcow=5Fflag.patch?= removed from -mm tree
Message-ID: <20210508224702.ExosFtP6M%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: remove unused macro TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-remove-unused-macro-transparent_hugepage_debug_cow_flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: remove unused macro TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG

Commit 4958e4d86ecb ("mm: thp: remove debug_cow switch") forgot to remove
TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG macro.  Remove it here.

Link: https://lkml.kernel.org/r/20210318122722.13135-6-linmiaohe@huawei.com
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

 include/linux/huge_mm.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memoryc-remove-unused-macro-transparent_hugepage_debug_cow_flag
+++ a/include/linux/huge_mm.h
@@ -87,9 +87,6 @@ enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
 	TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
-#ifdef CONFIG_DEBUG_VM
-	TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG,
-#endif
 };
 
 struct kobject;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


