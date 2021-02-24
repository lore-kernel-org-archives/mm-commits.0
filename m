Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E58C7C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF2AF64F0C
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbhBXUI0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:08:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235368AbhBXUH5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:07:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B5F864F20;
        Wed, 24 Feb 2021 20:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197250;
        bh=x4Kev3w/HWUO8XzagillSlgaP/LUtP4yRoEgl1VDGMU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mcY/GET/sAC05KhQd9j3+V4Nsnc9FiK9VaaT41VB5p+0DU+gHgaiyHZ+pKKvgd76F
         t9UKpig+eBQkdqLCI+VfCCILOf8V/++doBZpSzqBScIgocgy1sepAWgPAtONHJImrn
         kW375lDKK5sxh/64wXy2GnhtVdfka4Jl808gg18k=
Date:   Wed, 24 Feb 2021 12:07:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 124/173] mm/huge_memory.c: remove unused return
 value of set_huge_zero_page()
Message-ID: <20210224200729._Bjv-Xo-g%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/huge_memory.c: remove unused return value of set_huge_zero_page()

The return value of set_huge_zero_page() is always ignored.  So we should
drop such return value.

Link: https://lkml.kernel.org/r/20210203084816.46307-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-remove-unused-return-value-of-set_huge_zero_page
+++ a/mm/huge_memory.c
@@ -691,20 +691,19 @@ static inline gfp_t alloc_hugepage_direc
 }
 
 /* Caller must hold page table lock. */
-static bool set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+static void set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
 		struct page *zero_page)
 {
 	pmd_t entry;
 	if (!pmd_none(*pmd))
-		return false;
+		return;
 	entry = mk_pmd(zero_page, vma->vm_page_prot);
 	entry = pmd_mkhuge(entry);
 	if (pgtable)
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
 	mm_inc_nr_ptes(mm);
-	return true;
 }
 
 vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
_
