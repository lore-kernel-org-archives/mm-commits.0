Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FD5C43461
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5783E613EB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhEEBeh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231958AbhEEBeg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:34:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6D55613E6;
        Wed,  5 May 2021 01:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178421;
        bh=qhUMRVT/49jl9eWLaOUD10MbkJOnzko9+kILXv0BAdU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1wO45tL60CRDQqpYjHiqmQaLonvXT6l+FAhuh6MDsi3cKms3peO72PAECrrDN2UCb
         d5ALF43RNlGqnrBR6sZz5c/TayT1VEndwRMZ7Zz5IFACuE3ecczXbE7akJCVRMtl2c
         6YhjfZDiaekAu6n9SZevhG6oDWB4htYWZSZy/7Ko=
Date:   Tue, 04 May 2021 18:33:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.carpenter@oracle.com,
        ebru.akagunduz@gmail.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, riel@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 018/143] khugepaged: reuse the smp_wmb() inside
 __SetPageUptodate()
Message-ID: <20210505013340.loNVXx15X%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: khugepaged: reuse the smp_wmb() inside __SetPageUptodate()

smp_wmb() is needed to avoid the copy_huge_page writes to become visible
after the set_pmd_at() write here.  But we can reuse the smp_wmb() inside
__SetPageUptodate() to remove this redundant one.

Link: https://lkml.kernel.org/r/20210306032947.35921-3-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~khugepaged-reuse-the-smp_wmb-inside-__setpageuptodate
+++ a/mm/khugepaged.c
@@ -1183,19 +1183,18 @@ static void collapse_huge_page(struct mm
 	__collapse_huge_page_copy(pte, new_page, vma, address, pte_ptl,
 			&compound_pagelist);
 	pte_unmap(pte);
+	/*
+	 * spin_lock() below is not the equivalent of smp_wmb(), but
+	 * the smp_wmb() inside __SetPageUptodate() can be reused to
+	 * avoid the copy_huge_page writes to become visible after
+	 * the set_pmd_at() write.
+	 */
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
 
 	_pmd = mk_huge_pmd(new_page, vma->vm_page_prot);
 	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
 
-	/*
-	 * spin_lock() below is not the equivalent of smp_wmb(), so
-	 * this is needed to avoid the copy_huge_page writes to become
-	 * visible after the set_pmd_at() write.
-	 */
-	smp_wmb();
-
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(new_page, vma, address, true);
_
