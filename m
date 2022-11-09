Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B55C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiKIBkx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiKIBkB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D5167F4A
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95469B81CDB
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432ECC433D6;
        Wed,  9 Nov 2022 01:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957951;
        bh=MuyqwciiIj6zQVA5UV0PGnXuQfJXTPWOi6JLBzk3mNY=;
        h=Date:To:From:Subject:From;
        b=Sop3m58zKtfauITMNdZR3sZvYDstA/Fc2hGwQKK3oZ26w6Y3qfI/PjafjHUN0Yooe
         JfRBbVrG6Cg165jjjtutyQ7JDm2tFwQf3NQuMOmeFjY997wnxRx3anHtG8wLXIgfp+
         xQQFsKB6ESK13w6rVo1jD4Fj/wsra8P8czpmsQqw=
Date:   Tue, 08 Nov 2022 17:39:10 -0800
To:     mm-commits@vger.kernel.org, Xinhui.Pan@amd.com, jarkko@kernel.org,
        dinguyen@kernel.org, dave.hansen@linux.intel.com, daniel@ffwll.ch,
        christian.koenig@amd.com, alexander.deucher@amd.com,
        airlied@gmail.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-debug_vm_pgtable-use-vm_access_flags.patch removed from -mm tree
Message-Id: <20221109013911.432ECC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: debug_vm_pgtable: use VM_ACCESS_FLAGS
has been removed from the -mm tree.  Its filename was
     mm-debug_vm_pgtable-use-vm_access_flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


