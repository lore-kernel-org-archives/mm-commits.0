Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6C5C388F2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56C1220659
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 03:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604459478;
	bh=77C1rOCAGivHaXH7QEQd46ha2GWhjUILbYzOJIylXyo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=j6VYcaVdal4yQ8hn26zz2nLwumTDWnyyhpql8oFsEYAgfvIvhMc53l6XL4ItzgW4A
	 ZtSWMC4fPew7HMBbOOk/HIVB4eF2hLrDYWIJWbgS03iZ3m4sXFXeFNdLYjpJxYAZeJ
	 nol7ChI0pIbUD9LPHdLrNCaonAOOGocG8FapGP+I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgKDDLS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 3 Nov 2020 22:11:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:49494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730017AbgKDDLR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Nov 2020 22:11:17 -0500
Received: from X1 (unknown [208.106.6.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3321422409;
        Wed,  4 Nov 2020 03:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604459476;
        bh=77C1rOCAGivHaXH7QEQd46ha2GWhjUILbYzOJIylXyo=;
        h=Date:From:To:Subject:From;
        b=SqDsTtNotURwTFMNXx07U1k5DhI/+iNnpW7GVdLJ0mMolJT83xyDojpFTrat7d6eh
         mwUnUZGnovOKGx3u8bYGiKCEUP3frGSfuqTJt1ZauMAWlSwzi+RdbGjOW/AcoBFy0Z
         9aU2ReBKpeqmSYD1Ol13hvktd1bdrDg8wgHZvxvk=
Date:   Tue, 03 Nov 2020 19:11:13 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, will@kernel.org, vgupta@synopsys.com,
        tony.luck@intel.com, schmitzmic@gmail.com, mroos@linux.ee,
        mattst88@gmail.com, linux@armlinux.org.uk,
        glaubitz@physik.fu-berlin.de, gerg@linux-m68k.org,
        geert@linux-m68k.org, corbet@lwn.net, catalin.marinas@arm.com,
        adobriyan@gmail.com, rppt@linux.ibm.com
Subject:  +
 ia64-split-virtual-map-initialization-out-of-paging_init.patch added to -mm
 tree
Message-ID: <20201104031113.5o0Uy%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: split virtual map initialization out of paging_init()
has been added to the -mm tree.  Its filename is
     ia64-split-virtual-map-initialization-out-of-paging_init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-split-virtual-map-initialization-out-of-paging_init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-split-virtual-map-initialization-out-of-paging_init.patch

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
Subject: ia64: split virtual map initialization out of paging_init()

For both FLATMEM and DISCONTIGMEM/SPARSEMEM the virtual map initialization
is spread over paging_init() for no good reason.

Split out the bits related to virtual map initialization to a helper
functions, one for FLATMEM and another for !FLATMEM configurations.

Link: https://lkml.kernel.org/r/20201101170454.9567-6-rppt@kernel.org
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

 arch/ia64/mm/contig.c    |   34 ++++++++++++++++++++--------------
 arch/ia64/mm/discontig.c |   37 ++++++++++++++++++++-----------------
 2 files changed, 40 insertions(+), 31 deletions(-)

--- a/arch/ia64/mm/contig.c~ia64-split-virtual-map-initialization-out-of-paging_init
+++ a/arch/ia64/mm/contig.c
@@ -166,21 +166,8 @@ find_memory (void)
 	alloc_per_cpu_data();
 }
 
-/*
- * Set up the page tables.
- */
-
-void __init
-paging_init (void)
+static void __init virtual_map_init(void)
 {
-	unsigned long max_dma;
-	unsigned long max_zone_pfns[MAX_NR_ZONES];
-
-	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
-	max_dma = virt_to_phys((void *) MAX_DMA_ADDRESS) >> PAGE_SHIFT;
-	max_zone_pfns[ZONE_DMA32] = max_dma;
-	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
-
 #ifdef CONFIG_VIRTUAL_MEM_MAP
 	efi_memmap_walk(find_largest_hole, (u64 *)&max_gap);
 	if (max_gap < LARGE_GAP) {
@@ -206,6 +193,25 @@ paging_init (void)
 		printk("Virtual mem_map starts at 0x%p\n", mem_map);
 	}
 #endif /* !CONFIG_VIRTUAL_MEM_MAP */
+}
+
+/*
+ * Set up the page tables.
+ */
+
+void __init
+paging_init (void)
+{
+	unsigned long max_dma;
+	unsigned long max_zone_pfns[MAX_NR_ZONES];
+
+	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+	max_dma = virt_to_phys((void *) MAX_DMA_ADDRESS) >> PAGE_SHIFT;
+	max_zone_pfns[ZONE_DMA32] = max_dma;
+	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+
+	virtual_map_init();
+
 	free_area_init(max_zone_pfns);
 	zero_page_memmap_ptr = virt_to_page(ia64_imva(empty_zero_page));
 }
--- a/arch/ia64/mm/discontig.c~ia64-split-virtual-map-initialization-out-of-paging_init
+++ a/arch/ia64/mm/discontig.c
@@ -584,6 +584,25 @@ void call_pernode_memory(unsigned long s
 	}
 }
 
+static void __init virtual_map_init(void)
+{
+#ifdef CONFIG_VIRTUAL_MEM_MAP
+	int node;
+
+	VMALLOC_END -= PAGE_ALIGN(ALIGN(max_low_pfn, MAX_ORDER_NR_PAGES) *
+		sizeof(struct page));
+	vmem_map = (struct page *) VMALLOC_END;
+	efi_memmap_walk(create_mem_map_page_table, NULL);
+	printk("Virtual mem_map starts at 0x%p\n", vmem_map);
+
+	for_each_online_node(node) {
+		unsigned long pfn_offset = mem_data[node].min_pfn;
+
+		NODE_DATA(node)->node_mem_map = vmem_map + pfn_offset;
+	}
+#endif
+}
+
 /**
  * paging_init - setup page tables
  *
@@ -593,29 +612,13 @@ void call_pernode_memory(unsigned long s
 void __init paging_init(void)
 {
 	unsigned long max_dma;
-	unsigned long pfn_offset = 0;
-	int node;
 	unsigned long max_zone_pfns[MAX_NR_ZONES];
 
 	max_dma = virt_to_phys((void *) MAX_DMA_ADDRESS) >> PAGE_SHIFT;
 
 	sparse_init();
 
-#ifdef CONFIG_VIRTUAL_MEM_MAP
-	VMALLOC_END -= PAGE_ALIGN(ALIGN(max_low_pfn, MAX_ORDER_NR_PAGES) *
-		sizeof(struct page));
-	vmem_map = (struct page *) VMALLOC_END;
-	efi_memmap_walk(create_mem_map_page_table, NULL);
-	printk("Virtual mem_map starts at 0x%p\n", vmem_map);
-#endif
-
-	for_each_online_node(node) {
-		pfn_offset = mem_data[node].min_pfn;
-
-#ifdef CONFIG_VIRTUAL_MEM_MAP
-		NODE_DATA(node)->node_mem_map = vmem_map + pfn_offset;
-#endif
-	}
+	virtual_map_init();
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
 	max_zone_pfns[ZONE_DMA32] = max_dma;
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

