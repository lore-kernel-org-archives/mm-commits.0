Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68406C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C97C6145A
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhD3Fy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhD3Fy1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1DA261424;
        Fri, 30 Apr 2021 05:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762020;
        bh=lh27A+dMxiuGW8qV7GpQueTIWRk86s3cXGvIyRFFwio=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0n7JJTU/tZw0+/UfsoHiKSIzfcqSHhCezLxsDy3H1iF/Gh4U5CJ3dPDCMTwurSAni
         ylEyt5DQ+rmAz6WBirwNFYcRim+vzEDEMTUfljNNryxCYWcNX9VehT+ptIubg3Ae3h
         5d7HTzjKPSMK/MAW9MmN42qoWqj15r0ckjuPOO/I=
Date:   Thu, 29 Apr 2021 22:53:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ardb@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, slyfox@gentoo.org,
        torvalds@linux-foundation.org
Subject:  [patch 008/178] ia64: fix EFI_DEBUG build
Message-ID: <20210430055339.GthfO0fS1%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: ia64: fix EFI_DEBUG build

When enabled local debugging via `#define EFI_DEBUG 1` noticed build
failure:

    arch/ia64/kernel/efi.c:564:8: error: 'i' undeclared (first use in this function)

While at it fixed benign string format mismatches visible only when
EFI_DEBUG is enabled:

    arch/ia64/kernel/efi.c:589:11:
        warning: format '%lx' expects argument of type 'long unsigned int',
        but argument 5 has type 'u64' {aka 'long long unsigned int'} [-Wformat=]

Link: https://lkml.kernel.org/r/20210328212246.685601-1-slyfox@gentoo.org
Fixes: 14fb42090943559 ("efi: Merge EFI system table revision and vendor checks")
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/ia64/kernel/efi.c~ia64-fix-efi_debug-build
+++ a/arch/ia64/kernel/efi.c
@@ -415,10 +415,10 @@ efi_get_pal_addr (void)
 		mask  = ~((1 << IA64_GRANULE_SHIFT) - 1);
 
 		printk(KERN_INFO "CPU %d: mapping PAL code "
-                       "[0x%lx-0x%lx) into [0x%lx-0x%lx)\n",
-                       smp_processor_id(), md->phys_addr,
-                       md->phys_addr + efi_md_size(md),
-                       vaddr & mask, (vaddr & mask) + IA64_GRANULE_SIZE);
+			"[0x%llx-0x%llx) into [0x%llx-0x%llx)\n",
+			smp_processor_id(), md->phys_addr,
+			md->phys_addr + efi_md_size(md),
+			vaddr & mask, (vaddr & mask) + IA64_GRANULE_SIZE);
 #endif
 		return __va(md->phys_addr);
 	}
@@ -560,6 +560,7 @@ efi_init (void)
 	{
 		efi_memory_desc_t *md;
 		void *p;
+		unsigned int i;
 
 		for (i = 0, p = efi_map_start; p < efi_map_end;
 		     ++i, p += efi_desc_size)
@@ -586,7 +587,7 @@ efi_init (void)
 			}
 
 			printk("mem%02d: %s "
-			       "range=[0x%016lx-0x%016lx) (%4lu%s)\n",
+			       "range=[0x%016llx-0x%016llx) (%4lu%s)\n",
 			       i, efi_md_typeattr_format(buf, sizeof(buf), md),
 			       md->phys_addr,
 			       md->phys_addr + efi_md_size(md), size, unit);
_
