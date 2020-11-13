Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B310FC2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:41:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38BCD2078D
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:41:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ya6y7DA4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgKMAlY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 19:41:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:49414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKMAlY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 19:41:24 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8A352074B;
        Fri, 13 Nov 2020 00:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605228084;
        bh=sbL1pI1aRx9IWo0lr0Ueu1Ir0lnsdBaimMzWyQghxyc=;
        h=Date:From:To:Subject:From;
        b=ya6y7DA4ip0638gv1EjSi4aoYR5eYlIZgoJ1IJXJBgu/OC0t6M1M/3EW1hkhAgfXw
         BsjKBU3ERB2V6q76KCv/ODszht58gqVWouPujuDl41RzUuu7XqGfQMtxPn9xYPeIGr
         mQT8wzAgk4NfF5k8ws7KzWn/viZSvZEbYjCCFhLc=
Date:   Thu, 12 Nov 2020 16:41:23 -0800
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, hch@lst.de, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, sfr@canb.auug.org.au
Subject:  + mm-simplify-follow_ptepmd-fix.patch added to -mm tree
Message-ID: <20201113004123.PRr8zUdrT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: merge fix for "s390/pci: remove races against pte updates"
has been added to the -mm tree.  Its filename is
     mm-simplify-follow_ptepmd-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-follow_ptepmd-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-follow_ptepmd-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -173,7 +173,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, uns
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte_pmd(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
+	ret = follow_pte(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
 	if (ret)
 		goto out_unlock_mmap;
 
@@ -317,7 +317,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsi
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte_pmd(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
+	ret = follow_pte(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
 	if (ret)
 		goto out_unlock_mmap;
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kernelh-split-out-mathematical-helpers-fix.patch
mm-simplify-follow_ptepmd-fix.patch
kasan-split-out-shadowc-from-commonc-fix2.patch

