Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F374C2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBBA322409
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459472;
	bh=+Gz7WWmH2yMYKr7VEH4oPi3LTv7LpdkmOlvOu1s6CKU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LUTuJo8WfUqm7hXSaJKuS2lXuM4AZE5Qt6F0RVYxX/kBg1qQppsilwIY9FCAuk52/
	 5YoaDIKwjz2tnL60YxHBi3/taOOfpwbBwX/VGg8K/C3gPl+RXMQqVa2fH+buLf8BjE
	 w6ncXa61ZkUGZMCGnxPJjf+XMeZaaJGoZkbV8cIM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730490AbgKDDLM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:11:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbgKDDLM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:11:12 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48DF3223FD;
        Wed,  4 Nov 2020 03:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459471;
        bh=+Gz7WWmH2yMYKr7VEH4oPi3LTv7LpdkmOlvOu1s6CKU=;
        h=Date:From:To:Subject:From;
        b=sAUz3OVV+PSmc9+RbZKHQTOtYmtBAyj92mmTztDeyHlcFQu/kul5xaCZQ8Iou7KQP
         9Yg7rrROVmiVJkH6mXyxlWU1wRJrf8M92/9m381kXEuO+xMkM8hItliLmsGvKugF40
         dDb2ghEIlyq8xESu84PwdS3TwUrD23VOJn/QtR6w=
Date:   Tue, 03 Nov 2020 19:11:09 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        tony.luck@intel.com, schmitzmic@gmail.com, mroos@linux.ee,
        mattst88@gmail.com, linux@armlinux.org.uk,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, corbet@lwn.net, catalin.marinas@arm.com,
        adobriyan@gmail.com, rppt@linux.ibm.com
Subject:  +
 ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch added to
 -mm tree
Message-ID: <20201104031109.6j0Ud%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: discontig: paging_init(): remove local max_pfn calculation
has been added to the -mm tree.  Its filename is
     ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-discontig-paging_init-remove-local-max_pfn-calculation.patch

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

