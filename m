Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49442C433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EC81613FC
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhEEBfC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:35:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231221AbhEEBfC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:35:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0841F613F6;
        Wed,  5 May 2021 01:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178446;
        bh=7zaxAc+tPBYcSjTH9XqLQfwuAZaa4geCtP15vrGTen4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=E7Gz+7PN1lnpv/u/XBR7qPy0NBUku5Nlb6ZJajd85qiHyuMdvUxS1NDCxG8lcCCD3
         ViqMXxevFRxv7Y0R578zC6MqjSux/4jemrgju2sMcCxGkAoB2XprjaX+47Jfxq/N2m
         KECCWQIM70dQvmuHF71Pu1aZrsbtu/xZSDumoQeM=
Date:   Tue, 04 May 2021 18:34:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        linmiaohe@huawei.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, peterx@redhat.com,
        rcampbell@nvidia.com, richard.weiyang@linux.alibaba.com,
        thomas_os@shipmail.org, torvalds@linux-foundation.org,
        vbabka@suse.cz, walken@google.com, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com,
        yulei.kernel@gmail.com, ziy@nvidia.com
Subject:  [patch 026/143] mm/huge_memory.c: remove unused macro
 TRANSPARENT_HUGEPAGE_DEBUG_COW_FLAG
Message-ID: <20210505013405.XHatOwscV%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
