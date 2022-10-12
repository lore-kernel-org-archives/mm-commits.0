Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF138C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 12 Oct 2022 22:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiJLWUv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Oct 2022 18:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbiJLWUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2022 18:20:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D51B140A4
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 15:20:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BACE5B81C6C
        for <mm-commits@vger.kernel.org>; Wed, 12 Oct 2022 22:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6D2C433D7;
        Wed, 12 Oct 2022 22:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1665613240;
        bh=zPxXTE/sXOn69GTqnawddMZEWxYnf6Q38RMPmbzrw5A=;
        h=Date:To:From:Subject:From;
        b=AYfXvUk/gsRMCYyn4yXJV4XM5gdW4A60bijQiMqWQScf/7/PZaqrhcBCBDXS4y2F/
         u86ClSIZZMusejVCdcVZNAVraDFmpoVIcfSNg2VnwJUYlu/aVbeKJAxMbMkP9YYEVR
         tMaNsYHe+tf5IKHBLa7Q4tT7q4peSt3WntbcIdNQ=
Date:   Wed, 12 Oct 2022 15:20:39 -0700
To:     mm-commits@vger.kernel.org, apopple@nvidia.com, mpe@ellerman.id.au,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memoryc-fix-race-when-faulting-a-device-private-page-fix.patch removed from -mm tree
Message-Id: <20221012222040.5D6D2C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memoryc-fix-race-when-faulting-a-device-private-page-fix
has been removed from the -mm tree.  Its filename was
     mm-memoryc-fix-race-when-faulting-a-device-private-page-fix.patch

This patch was dropped because it was folded into mm-memoryc-fix-race-when-faulting-a-device-private-page.patch

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

 arch/powerpc/kvm/book3s_hv_uvmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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

mm-memoryc-fix-race-when-faulting-a-device-private-page.patch

