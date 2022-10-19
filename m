Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F747C43217
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231734AbiJSXgC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiJSXf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FFA1C7118
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:35:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B163611FC
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC686C433B5;
        Wed, 19 Oct 2022 23:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666222555;
        bh=511J1qvS2By94rRMerg/bn/LVvA3sNibDMmbF6bXpZA=;
        h=Date:To:From:Subject:From;
        b=gr9323XetRv43EiW+w/h0riY5ZQTeKG3WQLB0hvD5v8zyIPt3jaxqG6fbvXKWk9mk
         8t4CH2LWvYC8pVTdKgI/fmyDNU10WAyH7hzjaKp3KB3t4ekFsq4w1+9vb5A57FJmkL
         BNgFuTnVgDb/6H7mtbK3papdJmRHs1srwL0+uvNY=
Date:   Wed, 19 Oct 2022 16:35:55 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com, jarkko@kernel.org,
        dinguyen@kernel.org, dave.hansen@linux.intel.com, daniel@ffwll.ch,
        christian.koenig@amd.com, alexander.deucher@amd.com,
        airlied@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-debug_vm_pgtable-use-vm_access_flags.patch added to mm-unstable branch
Message-Id: <20221019233555.BC686C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: debug_vm_pgtable: use VM_ACCESS_FLAGS
has been added to the -mm mm-unstable branch.  Its filename is
     mm-debug_vm_pgtable-use-vm_access_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-debug_vm_pgtable-use-vm_access_flags.patch

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
Subject: mm: debug_vm_pgtable: use VM_ACCESS_FLAGS
Date: Wed, 19 Oct 2022 11:49:44 +0800

Directly use VM_ACCESS_FLAGS instead VMFLAGS.

Link: https://lkml.kernel.org/r/20221019034945.93081-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug_vm_pgtable.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/mm/debug_vm_pgtable.c~mm-debug_vm_pgtable-use-vm_access_flags
+++ a/mm/debug_vm_pgtable.c
@@ -38,11 +38,7 @@
  * Please refer Documentation/mm/arch_pgtable_helpers.rst for the semantics
  * expectations that are being validated here. All future changes in here
  * or the documentation need to be in sync.
- */
-
-#define VMFLAGS	(VM_READ|VM_WRITE|VM_EXEC)
-
-/*
+ *
  * On s390 platform, the lower 4 bits are used to identify given page table
  * entry type. But these bits might affect the ability to clear entries with
  * pxx_clear() because of how dynamic page table folding works on s390. So
@@ -1125,7 +1121,7 @@ static int __init init_args(struct pgtab
 	 */
 	memset(args, 0, sizeof(*args));
 	args->vaddr              = get_random_vaddr();
-	args->page_prot          = vm_get_page_prot(VMFLAGS);
+	args->page_prot          = vm_get_page_prot(VM_ACCESS_FLAGS);
 	args->page_prot_none     = vm_get_page_prot(VM_NONE);
 	args->is_contiguous_page = false;
 	args->pud_pfn            = ULONG_MAX;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch
mm-remove-kern_addr_valid-completely.patch
nios2-remove-unused-init_mmap.patch
x86-sgx-use-vm_access_flags.patch
mm-mprotect-use-vm_access_flags.patch
mm-debug_vm_pgtable-use-vm_access_flags.patch
amdgpu-use-vm_access_flags.patch

