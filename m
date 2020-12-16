Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C089C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:23:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C976622D49
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgLPEXV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:23:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbgLPEXV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:23:21 -0500
Date:   Tue, 15 Dec 2020 20:22:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608092560;
        bh=U1EN7Kb4wLsJ2TGD8DkA1cmb0otRLLqYV9r6tCMwgWQ=;
        h=From:To:Subject:From;
        b=PfsnvIsTEmDZDTdpBnjZ7KAiP/Rvnh2MxjFsBAK26Vmi263hzJvDW+UG3pTNKaMod
         4rROKrNTFaoxIXgKM0nsomRWSnxWxQfduuyyypAMkIhHKDYsPmzgEMqshHX+v40cwv
         Jr5rn4+4Ik6XoyU4HwFMLY0C5vTQxEIktXycAjR4=
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, hch@lst.de, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, sfr@canb.auug.org.au
Subject:  [folded-merged] mm-simplify-follow_ptepmd-fix.patch
 removed from -mm tree
Message-ID: <20201216042240.wutY4HsGj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: merge fix for "s390/pci: remove races against pte updates"
has been removed from the -mm tree.  Its filename was
     mm-simplify-follow_ptepmd-fix.patch

This patch was dropped because it was folded into mm-simplify-follow_ptepmd.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: merge fix for "s390/pci: remove races against pte updates"

Link: https://lkml.kernel.org/r/20201111221254.7f6a3658@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reported-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/pci/pci_mmio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/pci/pci_mmio.c~mm-simplify-follow_ptepmd-fix
+++ a/arch/s390/pci/pci_mmio.c
@@ -170,7 +170,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, uns
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte_pmd(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
+	ret = follow_pte(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
 	if (ret)
 		goto out_unlock_mmap;
 
@@ -311,7 +311,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsi
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte_pmd(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
+	ret = follow_pte(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
 	if (ret)
 		goto out_unlock_mmap;
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

mm-simplify-follow_ptepmd.patch

