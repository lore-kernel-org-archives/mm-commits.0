Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DB9C43467
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA74722253
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709266;
	bh=3/+I8BRvMxcxRT0KHvzm/2DtPGd4kdYVfYKGjW9RdEo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=TA9ob2xkquVFhl1zxGRTbTPnJFPYmbF4yIptUkhuO4XWCzih8/zQSaGyVnwCCe39c
	 +ZDwqmwznWZqLnWNsOyB44VuW4Mv0e5tokNIdcQpeXK9uL5SdC/fJMLKiUNJ9Ql2QJ
	 7QdFCFy/ZU9dROAxlgpFRSQRjGxvBr3HDLr+Ppzg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbgJNVBF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:51166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727931AbgJNVBD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:01:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AFDA22257;
        Wed, 14 Oct 2020 21:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709249;
        bh=3/+I8BRvMxcxRT0KHvzm/2DtPGd4kdYVfYKGjW9RdEo=;
        h=Date:From:To:Subject:From;
        b=p5wGeMHWyaDhzz6qN06HZlrUUggAj8j0f9dBQYKJBH236qq2RnVL1Ke5+cJTaYPaw
         ZBxdCIctIRoToL79qzTZr+d+nCmmlBWySL/YizoHw+GCgrdm7uofKNMub5nU88/0Hy
         otpzDoMShemSRAq1rGVKZ9LiaDvEHV0H9MYtLFAs=
Date:   Wed, 14 Oct 2020 14:00:49 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        yanfei.xu@windriver.com
Subject:  [merged]
 mm-memoryc-replace-vmf-vma-with-variable-vma.patch removed from -mm tree
Message-ID: <20201014210049.zv9LVwwtZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: replace vmf->vma with variable vma
has been removed from the -mm tree.  Its filename was
     mm-memoryc-replace-vmf-vma-with-variable-vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/memory.c: replace vmf->vma with variable vma

The code has declared a vma_struct named vma which is assigned a value of
vmf->vma.  Thus, use variable vma directly here.

Link: http://lkml.kernel.org/r/20200818084607.37616-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memoryc-replace-vmf-vma-with-variable-vma
+++ a/mm/memory.c
@@ -3597,7 +3597,7 @@ static vm_fault_t __do_fault(struct vm_f
 	 *				# flush A, B to clear the writeback
 	 */
 	if (pmd_none(*vmf->pmd) && !vmf->prealloc_pte) {
-		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
+		vmf->prealloc_pte = pte_alloc_one(vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
 		smp_wmb(); /* See comment in __pte_alloc() */
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are


