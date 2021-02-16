Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6E6C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 16 Feb 2021 20:20:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5A3964EB3
	for <mm-commits@archiver.kernel.org>; Tue, 16 Feb 2021 20:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbhBPUUW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Feb 2021 15:20:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229708AbhBPUUU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Feb 2021 15:20:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C569664E7A;
        Tue, 16 Feb 2021 20:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613506780;
        bh=9wCauCd13SZSHIGvbikWVR4Q1rdNlzib81R9pQgAP4k=;
        h=Date:From:To:Subject:From;
        b=neI07ySa1m93KkIrjiB7gVUtrPuH+L4DCMIzFIbswKZ2lSd/F4iyPTNgQT5oXm6wZ
         3ORS25Jz4EbsuVwhcjYVw2SOjhA63M8eNtJlwqjRCm8rkmnREuuxUtwTmqVtpLXKc3
         6mNb7zS7z2VP4szlhbrLPhQcun640zpSaL2ZPuvY=
Date:   Tue, 16 Feb 2021 12:19:39 -0800
From:   akpm@linux-foundation.org
To:     geert@linux-m68k.org, gerg@linux-m68k.org, lkp@intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  [merged]
 m68k-make-__pfn_to_phys-and-__phys_to_pfn-available-for-mmu.patch removed
 from -mm tree
Message-ID: <20210216201939.KLmeTt4XO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: make __pfn_to_phys() and __phys_to_pfn() available for !MMU
has been removed from the -mm tree.  Its filename was
     m68k-make-__pfn_to_phys-and-__phys_to_pfn-available-for-mmu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-refactor-initialization-of-struct-page-for-holes-in-memory-layout.patch

