Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E473C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE5D20721
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbgLODMU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:12:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727910AbgLODMP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:15 -0500
Date:   Mon, 14 Dec 2020 19:09:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001781;
        bh=VLk7sNPo1aLrKYJUSU7RD3oaxsJbne+m3OyiHhyDg1s=;
        h=From:To:Subject:In-Reply-To:From;
        b=rlk7j5b/9fGDmz7L3EcQTibn/nBNddM+4PciXHUwbfny7+oFao3KRphPwU/YEp1Hl
         diQF7NM18fEaDskVDbRJXz/Fir6HQlhgW153IZSyWHvy8ztAgY7dOGmgKs0JCMiQi/
         opyqMYVnQYl9gSh9DgWQshX4Dm7wGL6jrpBNe4D4=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org,
        catalin.marinas@arm.com, corbet@lwn.net, geert@linux-m68k.org,
        gerg@linux-m68k.org, glaubitz@physik.fu-berlin.de,
        linux-mm@kvack.org, linux@armlinux.org.uk, mattst88@gmail.com,
        mm-commits@vger.kernel.org, mroos@linux.ee, rppt@linux.ibm.com,
        schmitzmic@gmail.com, tony.luck@intel.com,
        torvalds@linux-foundation.org, vgupta@synopsys.com, will@kernel.org
Subject:  [patch 109/200] ia64: discontig: paging_init(): remove
 local max_pfn calculation
Message-ID: <20201215030939.1bMGkmDdD%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: ia64: discontig: paging_init(): remove local max_pfn calculation

The maximal PFN in the system is calculated during find_memory() time and
it is stored at max_low_pfn then.

Use this value in paging_init() and remove the redundant detection of
max_pfn in that function.

Link: https://lkml.kernel.org/r/20201101170454.9567-5-rppt@kernel.org
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

 arch/ia64/mm/discontig.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/arch/ia64/mm/discontig.c~ia64-discontig-paging_init-remove-local-max_pfn-calculation
+++ a/arch/ia64/mm/discontig.c
@@ -594,7 +594,6 @@ void __init paging_init(void)
 {
 	unsigned long max_dma;
 	unsigned long pfn_offset = 0;
-	unsigned long max_pfn = 0;
 	int node;
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
@@ -616,13 +615,11 @@ void __init paging_init(void)
 #ifdef CONFIG_VIRTUAL_MEM_MAP
 		NODE_DATA(node)->node_mem_map = vmem_map + pfn_offset;
 #endif
-		if (mem_data[node].max_pfn > max_pfn)
-			max_pfn = mem_data[node].max_pfn;
 	}
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 	max_zone_pfns[ZONE_DMA32] = max_dma;
-	max_zone_pfns[ZONE_NORMAL] = max_pfn;
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 	free_area_init(max_zone_pfns);
 
 	zero_page_memmap_ptr = virt_to_page(ia64_imva(empty_zero_page));
_
