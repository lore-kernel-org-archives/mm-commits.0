Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4944C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbiJSXfy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiJSXfy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:35:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FD41C4920
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:35:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25D8EB81E85
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA79DC433D6;
        Wed, 19 Oct 2022 23:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666222549;
        bh=FYzzrFXqBwv0YOaLLTJ0+PUsxbpcZ0aPy4WWnEwJqk8=;
        h=Date:To:From:Subject:From;
        b=ugsdNRMhZNwURGnXQVBcYdkuWIG3Kcl7zMQ5UsPBqKUdK2XALUetO6h+8BBW07g3a
         3HQt0y+jgm4KSyNYA+Cm3BDyuex/+Ly26T4JALCG2JwMqRf4KryPCTbcEyWx1XxMch
         ODAz2uOupqUk51noBdpAAx83qGY2T/NqK99qs7jo=
Date:   Wed, 19 Oct 2022 16:35:49 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com, jarkko@kernel.org,
        dinguyen@kernel.org, dave.hansen@linux.intel.com, daniel@ffwll.ch,
        christian.koenig@amd.com, alexander.deucher@amd.com,
        airlied@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nios2-remove-unused-init_mmap.patch added to mm-unstable branch
Message-Id: <20221019233549.CA79DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nios2: remove unused INIT_MMAP
has been added to the -mm mm-unstable branch.  Its filename is
     nios2-remove-unused-init_mmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nios2-remove-unused-init_mmap.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: nios2: remove unused INIT_MMAP
Date: Wed, 19 Oct 2022 11:49:41 +0800

Patch series "mm: cleanup with VM_ACCESS_FLAGS".


This patch (of 5):

It seems that INIT_MMAP is gone in 2.4.10, not sure, anyways, it is
useless now, kill it.

Link: https://lkml.kernel.org/r/20221019034945.93081-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20221019034945.93081-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: David Airlie <airlied@gmail.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/include/asm/processor.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/arch/nios2/include/asm/processor.h~nios2-remove-unused-init_mmap
+++ a/arch/nios2/include/asm/processor.h
@@ -50,9 +50,6 @@ struct thread_struct {
 	unsigned long kpsr;
 };
 
-#define INIT_MMAP \
-	{ &init_mm, (0), (0), __pgprot(0x0), VM_READ | VM_WRITE | VM_EXEC }
-
 # define INIT_THREAD {			\
 	.kregs	= NULL,			\
 	.ksp	= 0,			\
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch
mm-remove-kern_addr_valid-completely.patch
nios2-remove-unused-init_mmap.patch
x86-sgx-use-vm_access_flags.patch
mm-mprotect-use-vm_access_flags.patch
mm-debug_vm_pgtable-use-vm_access_flags.patch
amdgpu-use-vm_access_flags.patch

