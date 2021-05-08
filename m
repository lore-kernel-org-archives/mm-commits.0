Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F874C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A708613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhEHWr5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:59188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229559AbhEHWr5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:47:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABD23610D2;
        Sat,  8 May 2021 22:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514014;
        bh=jI+M7AQYpodpxQrMh1QF8cEMl1aXg4Id6Xlhj/iPEnM=;
        h=Date:From:To:Subject:From;
        b=CgiCHZ3LLvkMtpqgSWqOAKGAoZ68zpvLZOKa/koSg3hwAbSaZyJjOD4T5m/WRPfaL
         xp/YRhFb4htEI7fJOH0k/vOlVa3Gi2vysQ9l+6XNxAU5DuTTotkSOTq+yQa89pQvFj
         Y545TuWtLX+eNPENh+CEmcIqgOf/ahRHS//FP5eE=
Date:   Sat, 08 May 2021 15:46:53 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, richard.weiyang@linux.alibaba.com,
        thomas_os@shipmail.org, vbabka@suse.cz, walken@google.com,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com, yulei.kernel@gmail.com, ziy@nvidia.com
Subject:  [merged]
 mm-huge_memoryc-make-get_huge_zero_page-return-bool.patch removed from -mm
 tree
Message-ID: <20210508224653.zoKyYwxrG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/huge_memory.c: make get_huge_zero_page() return bool
has been removed from the -mm tree.  Its filename was
     mm-huge_memoryc-make-get_huge_zero_page-return-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: make get_huge_zero_page() return bool

It's guaranteed that huge_zero_page will not be NULL if huge_zero_refcount
is increased successfully.  When READ_ONCE(huge_zero_page) is returned,
there must be a huge_zero_page and it can be replaced with returning
'true' when we do not care about the value of huge_zero_page.  We can thus
make it return bool to save READ_ONCE cpu cycles as the return value is
just used to check if huge_zero_page exists.

Link: https://lkml.kernel.org/r/20210318122722.13135-3-linmiaohe@huawei.com
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

 mm/huge_memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-make-get_huge_zero_page-return-bool
+++ a/mm/huge_memory.c
@@ -77,18 +77,18 @@ bool transparent_hugepage_enabled(struct
 	return false;
 }
 
-static struct page *get_huge_zero_page(void)
+static bool get_huge_zero_page(void)
 {
 	struct page *zero_page;
 retry:
 	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
-		return READ_ONCE(huge_zero_page);
+		return true;
 
 	zero_page = alloc_pages((GFP_TRANSHUGE | __GFP_ZERO) & ~__GFP_MOVABLE,
 			HPAGE_PMD_ORDER);
 	if (!zero_page) {
 		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
-		return NULL;
+		return false;
 	}
 	count_vm_event(THP_ZERO_PAGE_ALLOC);
 	preempt_disable();
@@ -101,7 +101,7 @@ retry:
 	/* We take additional reference here. It will be put back by shrinker */
 	atomic_set(&huge_zero_refcount, 2);
 	preempt_enable();
-	return READ_ONCE(huge_zero_page);
+	return true;
 }
 
 static void put_huge_zero_page(void)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


