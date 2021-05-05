Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20D09C43460
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06510613FE
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhEEBfA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:35:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231221AbhEEBe7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:34:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4AF9613FB;
        Wed,  5 May 2021 01:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178443;
        bh=GzpSxDG+rPlLLSUaiDIhl4YiIb+BENUyMSPfXLI0ojQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Qv9rh8GRFSeOx9b8REQ0SQRIm6bjdiH0kxOBAzI6eDTq8U4RAAJmZkVuHovV3tAgy
         JoP/g46eltOPpL4SoKDe/UWlgUa8II4l19Y664W4vvW9IOcf8ea/sxBsgWbyLU1blx
         iIjQ7NUZcHeVtDXS4lfRrFqdzliyhLATMUSrIF2s=
Date:   Tue, 04 May 2021 18:34:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, richard.weiyang@linux.alibaba.com,
        thomas_os@shipmail.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, walken@google.com, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com,
        yulei.kernel@gmail.com, ziy@nvidia.com
Subject:  [patch 025/143] mm/huge_memory.c: remove redundant
 PageCompound() check
Message-ID: <20210505013402.Mqi6TFMjn%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
