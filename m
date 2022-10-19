Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6386FC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 19 Oct 2022 23:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbiJSXgC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Oct 2022 19:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiJSXf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2022 19:35:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848C51C6BCA
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 16:35:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AED2B81E85
        for <mm-commits@vger.kernel.org>; Wed, 19 Oct 2022 23:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF58C433C1;
        Wed, 19 Oct 2022 23:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666222553;
        bh=X5H7iyoCENAMz8SgmVhjkFhj/uCQWKQ7UVtPI+Bqrbk=;
        h=Date:To:From:Subject:From;
        b=l6cbW5U7uI8GckcN0WrpfN4eDCWBWMysZNnxphvwk+5rKT35ROcbJ0RtQa8ta1RDV
         cBqILROh5vq6EheIAoGIu8ZaBpvFEFKEwn+NbF7vPrOIFW00GTI8/tnxvxVlCoq6nx
         Eez7ySJJOn5Q4uQwtNZ1TiQejfBYSKGjlmZTgcUg=
Date:   Wed, 19 Oct 2022 16:35:53 -0700
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com, jarkko@kernel.org,
        dinguyen@kernel.org, dave.hansen@linux.intel.com, daniel@ffwll.ch,
        christian.koenig@amd.com, alexander.deucher@amd.com,
        airlied@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-use-vm_access_flags.patch added to mm-unstable branch
Message-Id: <20221019233553.BDF58C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mprotect: use VM_ACCESS_FLAGS
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mprotect-use-vm_access_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mprotect-use-vm_access_flags.patch

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
Subject: mm: mprotect: use VM_ACCESS_FLAGS
Date: Wed, 19 Oct 2022 11:49:43 +0800

Simplify VM_READ|VM_WRITE|VM_EXEC with VM_ACCESS_FLAGS.

Link: https://lkml.kernel.org/r/20221019034945.93081-4-wangkefeng.wang@huawei.com
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

 mm/mprotect.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-use-vm_access_flags
+++ a/mm/mprotect.c
@@ -756,8 +756,7 @@ static int do_mprotect_pkey(unsigned lon
 		 * If a permission is not passed to mprotect(), it must be
 		 * cleared from the VMA.
 		 */
-		mask_off_old_flags = VM_READ | VM_WRITE | VM_EXEC |
-					VM_FLAGS_CLEAR;
+		mask_off_old_flags = VM_ACCESS_FLAGS | VM_FLAGS_CLEAR;
 
 		new_vma_pkey = arch_override_mprotect_pkey(vma, prot, pkey);
 		newflags = calc_vm_prot_bits(prot, new_vma_pkey);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-rmap-rename-page_not_mapped-to-folio_not_mapped.patch
mm-remove-kern_addr_valid-completely.patch
nios2-remove-unused-init_mmap.patch
x86-sgx-use-vm_access_flags.patch
mm-mprotect-use-vm_access_flags.patch
mm-debug_vm_pgtable-use-vm_access_flags.patch
amdgpu-use-vm_access_flags.patch

