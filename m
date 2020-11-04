Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE17C388F2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F16E22403
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459468;
	bh=aZC0USR9jATn+45pEce63p5Y+3UEVdIOuluwS5jowfk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=tASvC0uRg8ZaVWXC+5EiaGdijdGMlGr+j0N4RdIqNfNKKuhW4dFzDP3yW5uLlOmmQ
	 ldX78nI0joS1RTelfZpd8KC5w9BL/6y8T2/Bp1w5c82nCpLSy2phL38+/D0bw08qfc
	 QHd6QfrfcaNAaZJqNcbSFkpEJl9PcIDcuUr+ESt4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbgKDDLI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:11:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbgKDDLH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:11:07 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3267A223C7;
        Wed,  4 Nov 2020 03:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459467;
        bh=aZC0USR9jATn+45pEce63p5Y+3UEVdIOuluwS5jowfk=;
        h=Date:From:To:Subject:From;
        b=e5Uz3r0dLC/7swZ0cfYMX48MLfYlO/3sLr5SkRL2lYDXKzKiBfqIVdDdUPz8FVmdi
         u0evbVWHDjjkCZI0jQwYm1eR//IByCcfm28UZEiLPnWw6rpq16Xr1QZ5YgRbNGxiqn
         VTivHiImQX6ixqFifl6x/swMRbx2fAQXz1zmUdto=
Date:   Tue, 03 Nov 2020 19:11:05 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        tony.luck@intel.com, schmitzmic@gmail.com, mroos@linux.ee,
        mattst88@gmail.com, linux@armlinux.org.uk,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, corbet@lwn.net, catalin.marinas@arm.com,
        adobriyan@gmail.com, rppt@linux.ibm.com
Subject:  + ia64-remove-ifdef-config_zone_dma32-statements.patch
 added to -mm tree
Message-ID: <20201104031105.gvD_L%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: remove 'ifdef CONFIG_ZONE_DMA32' statements
has been added to the -mm tree.  Its filename is
     ia64-remove-ifdef-config_zone_dma32-statements.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-remove-ifdef-config_zone_dma32-statements.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-remove-ifdef-config_zone_dma32-statements.patch

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
Subject: ia64: remove 'ifdef CONFIG_ZONE_DMA32' statements

After the removal of SN2 platform (commit cf07cb1ff4ea ("ia64: remove
support for the SGI SN2 platform") IA-64 always has ZONE_DMA32 and there is
no point to guard code with this configuration option.

Remove ifdefery associated with CONFIG_ZONE_DMA32

Link: https://lkml.kernel.org/r/20201101170454.9567-4-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/contig.c    |    2 --
 arch/ia64/mm/discontig.c |    2 --
 2 files changed, 4 deletions(-)

--- a/arch/ia64/mm/contig.c~ia64-remove-ifdef-config_zone_dma32-statements
+++ a/arch/ia64/mm/contig.c
@@ -177,10 +177,8 @@ paging_init (void)
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-#ifdef CONFIG_ZONE_DMA32
 	max_dma = virt_to_phys((void *) MAX_DMA_ADDRESS) >> PAGE_SHIFT;
 	max_zone_pfns[ZONE_DMA32] = max_dma;
-#endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 
 #ifdef CONFIG_VIRTUAL_MEM_MAP
--- a/arch/ia64/mm/discontig.c~ia64-remove-ifdef-config_zone_dma32-statements
+++ a/arch/ia64/mm/discontig.c
@@ -621,9 +621,7 @@ void __init paging_init(void)
 	}
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-#ifdef CONFIG_ZONE_DMA32
 	max_zone_pfns[ZONE_DMA32] = max_dma;
-#endif
 	max_zone_pfns[ZONE_NORMAL] = max_pfn;
 	free_area_init(max_zone_pfns);
 
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-introduce-debug_pagealloc_map_pages-helper.patch
pm-hibernate-make-direct-map-manipulations-more-explicit.patch
arch-mm-restore-dependency-of-__kernel_map_pages-of-debug_pagealloc.patch
arch-mm-make-kernel_page_present-always-available.patch
alpha-switch-from-discontigmem-to-sparsemem.patch
ia64-remove-custom-__early_pfn_to_nid.patch
ia64-remove-ifdef-config_zone_dma32-statements.patch
ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch
ia64-split-virtual-map-initialization-out-of-paging_init.patch
ia64-forbid-using-virtual_mem_map-with-flatmem.patch
ia64-make-sparsemem-default-and-disable-discontigmem.patch
arm-remove-config_arch_has_holes_memorymodel.patch
arm-arm64-move-free_unused_memmap-to-generic-mm.patch
arc-use-flatmem-with-freeing-of-unused-memory-map-instead-of-discontigmem.patch
m68k-mm-make-node-data-and-node-setup-depend-on-config_discontigmem.patch
m68k-mm-enable-use-of-generic-memory_modelh-for-discontigmem.patch
m68k-deprecate-discontigmem.patch

