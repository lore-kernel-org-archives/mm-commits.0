Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4370EC433DB
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC27564F2C
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhBXUGi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:06:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:55514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235306AbhBXUFy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:05:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3397364F2D;
        Wed, 24 Feb 2021 20:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614197080;
        bh=gTjnI4BIkQ1GHRRNKlBFUJ5q0apX1+RAnlPsE3l1wrM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rxojsoa+cRx2XPRA9Tgq0RbmX4T5PVc6bvMRulNKxb0w/nPJQsLKp7Ult8N7TQXop
         Qt+mvrAgu50RxT+RJDHuvr1MhuMgHYO4eZZaAdg0JUbbE8X6m8enKLyhQJpBiN0Jrd
         CYKIz+y1sHvZGBFBe2zhvLpjLVA8OxlBIpFOER6A=
Date:   Wed, 24 Feb 2021 12:04:39 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 079/173] mm/pgtable-generic.c: optimize the
 VM_BUG_ON condition in pmdp_huge_clear_flush()
Message-ID: <20210224200439.0k6rJzU8V%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/pgtable-generic.c: optimize the VM_BUG_ON condition in pmdp_huge_clear_flush()

The developer will have trouble figuring out why the BUG actually
triggered when there is a complex expression in the VM_BUG_ON.  Because we
can only identify the condition triggered BUG via line number provided by
VM_BUG_ON.  Optimize this by spliting such a complex expression into two
simple conditions.

Link: https://lkml.kernel.org/r/20210203084137.25522-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/pgtable-generic.c~mm-pgtable-genericc-optimize-the-vm_bug_on-condition-in-pmdp_huge_clear_flush
+++ a/mm/pgtable-generic.c
@@ -135,8 +135,9 @@ pmd_t pmdp_huge_clear_flush(struct vm_ar
 {
 	pmd_t pmd;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON(!pmd_present(*pmdp) || (!pmd_trans_huge(*pmdp) &&
-					  !pmd_devmap(*pmdp)));
+	VM_BUG_ON(!pmd_present(*pmdp));
+	/* Below assumes pmd_present() is true */
+	VM_BUG_ON(!pmd_trans_huge(*pmdp) && !pmd_devmap(*pmdp));
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
_
