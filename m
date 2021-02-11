Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF3DAC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 23:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C19D864E42
	for <mm-commits@archiver.kernel.org>; Thu, 11 Feb 2021 23:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhBKXfz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:35:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:50296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230228AbhBKXfr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Feb 2021 18:35:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C66E864E30;
        Thu, 11 Feb 2021 23:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1613086507;
        bh=ZGIYFVXJvHuJGFmZt5NAjYsK+XjQ6JtEslKmMPdG+uA=;
        h=Date:From:To:Subject:From;
        b=CBi5plPqhhldenuSqkrgHF8W8ZSp0HDiE0zAGajjbBPdTALrDw/hAtsJwGUwoLxiI
         WwxBH6UHDJcKLKNHR+4fdCFB/2Dn2XS8QCotn4OxTQj7Nx7wOhRp6pqslnDhpbGURX
         Xv6R90U7ohfePqHyoQmFQCBOKvO9nsbohV+fMPNc=
Date:   Thu, 11 Feb 2021 15:35:06 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, lkp@intel.com, gerg@linux-m68k.org,
        geert@linux-m68k.org, rppt@linux.ibm.com
Subject:  +
 m68k-make-__pfn_to_phys-and-__phys_to_pfn-available-for-mmu.patch added to
 -mm tree
Message-ID: <20210211233506.iwyxB%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: make __pfn_to_phys() and __phys_to_pfn() available for !MMU
has been added to the -mm tree.  Its filename is
     m68k-make-__pfn_to_phys-and-__phys_to_pfn-available-for-mmu.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/m68k-make-__pfn_to_phys-and-__phys_to_pfn-available-for-mmu.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/m68k-make-__pfn_to_phys-and-__phys_to_pfn-available-for-mmu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

m68k-make-__pfn_to_phys-and-__phys_to_pfn-available-for-mmu.patch
mm-refactor-initialization-of-struct-page-for-holes-in-memory-layout.patch

