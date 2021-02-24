Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D3DFC433E6
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5146564F28
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234906AbhBXUGa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:54852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235297AbhBXUFw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 096DD64F33;
        Wed, 24 Feb 2021 20:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197077;
        bh=0UgaiyCy4K6CLFeEvqJrQ7SfRWJaZcn/x8Ckb8PI/vs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uT9KRS9fEQ2txJ93EtfOzEiESaj5QJF4yxgmmMdG5AjaJQuJKZM0MxZgJX6iJwbZ3
         X5e8lI2PcM/q/tSmY1Ao4myexl/LujSXtnZE21ndxRtbp+amvfwA2C33Rk3f+EG9Vm
         5bcUqKC30aXEl31xer4Y89PtCR7T8wZgk2Ly+goc=
Date:   Wed, 24 Feb 2021 12:04:36 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 078/173] mm/pgtable-generic.c: simplify the
 VM_BUG_ON condition in pmdp_huge_clear_flush()
Message-ID: <20210224200436.R2zPY2Es_%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/pgtable-generic.c: simplify the VM_BUG_ON condition in pmdp_huge_clear_flush()

The condition (A && !C && !D) || !A is equivalent to !A || (A && !C && !D)
and can be further simplified to !A || (!C && !D).

Link: https://lkml.kernel.org/r/20210201114319.34720-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/pgtable-generic.c~mm-simplify-the-vm_bug_on-condition-in-pmdp_huge_clear_flush
+++ a/mm/pgtable-generic.c
@@ -135,8 +135,8 @@ pmd_t pmdp_huge_clear_flush(struct vm_ar
 {
 	pmd_t pmd;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON((pmd_present(*pmdp) && !pmd_trans_huge(*pmdp) &&
-			   !pmd_devmap(*pmdp)) || !pmd_present(*pmdp));
+	VM_BUG_ON(!pmd_present(*pmdp) || (!pmd_trans_huge(*pmdp) &&
+					  !pmd_devmap(*pmdp)));
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
_
