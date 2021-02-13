Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3D4C433DB
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF80D64E3C
	for <mm-commits@archiver.kernel.org>; Sat, 13 Feb 2021 04:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhBMExV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 Feb 2021 23:53:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:50442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229718AbhBMExT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 12 Feb 2021 23:53:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C80E064E2C;
        Sat, 13 Feb 2021 04:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613191959;
        bh=PwvXFnKtCJAfFkdPVjoAV8huBBexwedBb1v53FBvoCs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=BStdpS7WY4AggILAkIMRStpO5phABTE2mQe5ZMyaKOvc/yhSf23hYf3W/KFFIQ5xM
         EeeJJf43NSNuCGkHhDxA7bxpHN+6Skaw7tb7yyiCJ4gVpmijDvhKN4arYowlr/MQBe
         sYwFpr2XliN8Px+k1fN8rs9DX75XW56mzs9rPki4=
Date:   Fri, 12 Feb 2021 20:52:38 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, geert@linux-m68k.org,
        gerg@linux-m68k.org, linux-mm@kvack.org, lkp@intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 1/6] m68k: make __pfn_to_phys() and
 __phys_to_pfn() available for !MMU
Message-ID: <20210213045238.52VjY3l-i%akpm@linux-foundation.org>
In-Reply-To: <20210212205206.f99cbe2e7e368c802a385104@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: m68k: make __pfn_to_phys() and __phys_to_pfn() available for !MMU

Recent changes that obsoleted DISCONTIGMEM on m68k switched the MMU
variant to use generic definitions of __pfn_to_phys() and __phys_to_pfn(),
but missed the !MMU variant which caused a build failure:

All errors (new ones prefixed by >>):

   drivers/media/common/videobuf2/videobuf2-dma-contig.c: In function 'vb2_dc_get_userptr':
>> drivers/media/common/videobuf2/videobuf2-dma-contig.c:509:5: error: implicit declaration of function '__pfn_to_phys' [-Werror=implicit-function-declaration]
     509 |     __pfn_to_phys(nums[0]), size, buf->dma_dir, 0);
         |     ^~~~~~~~~~~~~
   cc1: some warnings being treated as errors

Enable __pfn_to_phys() and __phys_to_pfn() on !MMU builds.

Link: https://lkml.kernel.org/r/20210211232202.GS299309@linux.ibm.com
Fixes: 4bfc848e0981 ("m68k/mm: enable use of generic memory_model.h for !DISCONTIGMEM")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/page.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/m68k/include/asm/page.h~m68k-make-__pfn_to_phys-and-__phys_to_pfn-available-for-mmu
+++ a/arch/m68k/include/asm/page.h
@@ -62,7 +62,7 @@ extern unsigned long _ramend;
 #include <asm/page_no.h>
 #endif
 
-#ifdef CONFIG_DISCONTIGMEM
+#if !defined(CONFIG_MMU) || defined(CONFIG_DISCONTIGMEM)
 #define __phys_to_pfn(paddr)	((unsigned long)((paddr) >> PAGE_SHIFT))
 #define __pfn_to_phys(pfn)	PFN_PHYS(pfn)
 #endif
_
