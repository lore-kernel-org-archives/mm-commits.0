Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A432C433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 337C020789
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597795071;
	bh=rpmhZH7h/lKJnNMry/m+Pb0uGMb1i73zUlwVHRPW27A=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ehl2HUJUiRGZrDCJz9aOBZUhHrZVg6QeurgTtyyNfyHPoFwqI0PWqeqq92L3yNHZC
	 mSc6Lf1UbevwyzFCgASxPP008lS7ar49AIdNDMutudr+xbOjFh7Jd6eIaDsOTnMzzU
	 9J/0oZpiOsUTu8w/5L8kCmNQWHrRBSr8lb83QDbw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHRX5u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727106AbgHRX5s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 19:57:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C169520789;
        Tue, 18 Aug 2020 23:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597795067;
        bh=rpmhZH7h/lKJnNMry/m+Pb0uGMb1i73zUlwVHRPW27A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oPd4QJbXwXBPHxVbp2Ynm0TkGuVE+OUqu7I7dX/xa/4NYt8ds79cUf+nypdihAner
         RtOX72q9WldBVIpLBMaQleJN2Bxc8dvyNkXWwOKCRU+Kq1ciiTL2+/I4d/JUXCt8qp
         HRJw0KwLNjwzrYSnhM/IuXILILHlNqQ0QBQuCRmc=
Date:   Tue, 18 Aug 2020 16:57:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        yanfei.xu@windriver.com
Subject:  + mm-memoryc-replace-vmf-vma-with-variable-vma.patch
 added to -mm tree
Message-ID: <20200818235746.r3bpSfJ2s%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: replace vmf->vma with variable vma
has been added to the -mm tree.  Its filename is
     mm-memoryc-replace-vmf-vma-with-variable-vma.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memoryc-replace-vmf-vma-with-variable-vma.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memoryc-replace-vmf-vma-with-variable-vma.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3454,7 +3454,7 @@ static vm_fault_t __do_fault(struct vm_f
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

mm-memory-fix-typo-in-__do_fault-comment.patch
mm-memoryc-replace-vmf-vma-with-variable-vma.patch

