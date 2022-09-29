Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 537CCC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 29 Sep 2022 14:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiI2OLm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 29 Sep 2022 10:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235617AbiI2OLi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2022 10:11:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47648177341
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 07:11:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F049614CC
        for <mm-commits@vger.kernel.org>; Thu, 29 Sep 2022 14:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5290AC433C1;
        Thu, 29 Sep 2022 14:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664460694;
        bh=Z/n9WVGAGMbyS9EVvtclPqGN4DPfHMhpgAbIF4nStOc=;
        h=Date:To:From:Subject:From;
        b=jL3wEyD1Aps3F5CUp9vYdIcW2HprNbsXPOqlmZymAkoHdY5sapcoIueWDqX78QpX/
         XyW3eUtni5/uSW8C/Hb8o2LFH5rcNfkDTYvsjGvUlEZLGltl/LStnYMM1Iezo/M650
         0o6Z5bXKFfiEKIf3CFBwSfPRni916eiHNG1/3K+w=
Date:   Thu, 29 Sep 2022 07:11:33 -0700
To:     mm-commits@vger.kernel.org, apopple@nvidia.com, mpe@ellerman.id.au,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memoryc-fix-race-when-faulting-a-device-private-page-fix.patch added to mm-unstable branch
Message-Id: <20220929141134.5290AC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memoryc-fix-race-when-faulting-a-device-private-page-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memoryc-fix-race-when-faulting-a-device-private-page-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memoryc-fix-race-when-faulting-a-device-private-page-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Michael Ellerman <mpe@ellerman.id.au>
Subject: mm-memoryc-fix-race-when-faulting-a-device-private-page-fix
Date: Thu, 29 Sep 2022 10:07:26 +1000

fix build

kvmppc_svm_page_out() is called via some paths other than the
migrate_to_ram callback.

I think it's correct to just pass fault_page = NULL when it's not called
from the migrate_to_ram callback?

Link: https://lkml.kernel.org/r/87fsgbf3gh.fsf@mpe.ellerman.id.au
Cc: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-memoryc-fix-race-when-faulting-a-device-private-page-fix
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -637,7 +637,7 @@ void kvmppc_uvmem_drop_pages(const struc
 			pvt->remove_gfn = true;
 
 			if (__kvmppc_svm_page_out(vma, addr, addr + PAGE_SIZE,
-						  PAGE_SHIFT, kvm, pvt->gpa))
+						  PAGE_SHIFT, kvm, pvt->gpa, NULL))
 				pr_err("Can't page out gpa:0x%lx addr:0x%lx\n",
 				       pvt->gpa, addr);
 		} else {
@@ -1068,7 +1068,7 @@ kvmppc_h_svm_page_out(struct kvm *kvm, u
 	if (!vma || vma->vm_start > start || vma->vm_end < end)
 		goto out;
 
-	if (!kvmppc_svm_page_out(vma, start, end, page_shift, kvm, gpa))
+	if (!kvmppc_svm_page_out(vma, start, end, page_shift, kvm, gpa, NULL))
 		ret = H_SUCCESS;
 out:
 	mmap_read_unlock(kvm->mm);
_

Patches currently in -mm which might be from mpe@ellerman.id.au are

mm-memoryc-fix-race-when-faulting-a-device-private-page-fix.patch

