Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0EDC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1764D22246
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633487;
	bh=UGYVNT80KtJNSvY2Gkpb5a2+2HsK37BmpebyMoay41w=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=SsAtKSpT4n8rcHfgPXezdTiFT56sPSEPmhEkTAuwp6omccFRBizEiDZd4AVpmddQi
	 Y6SDxPx2t11zLdQMz6g4gb1DEAwKQTv5raYNnQ1BxYAk7BFs1jp2ugboTX1kXVFxaX
	 9Lzqmlly/ED9YwB3fm3tTrjxm8jcltEzmdbJdmSc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388435AbgJMX6G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387851AbgJMX6G (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:58:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25985218AC;
        Tue, 13 Oct 2020 23:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633485;
        bh=UGYVNT80KtJNSvY2Gkpb5a2+2HsK37BmpebyMoay41w=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JPdfCsWTZzaX7lUJajSQp7grkCucR+4/8n0+GrXZmpvsesPl+GGRQvGpJ7SnSje+C
         IZOnfYXhzIICAG0UUVbZXsNAIG79vWuPrMcUKZoauMJ8NBeQnFpd+aov9SAmG04oqJ
         qMhCxMcCiHurxc2LRPSTX1Fz8IaHt+BCnqwdUyEo=
Date:   Tue, 13 Oct 2020 16:58:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, benh@kernel.crashing.org,
        bhe@redhat.com, bp@alien8.de, catalin.marinas@arm.com,
        dave.hansen@linux.intel.com, dja@axtens.net,
        hbathini@linux.ibm.com, hch@lst.de, jcmvbkbc@gmail.com,
        Jonathan.Cameron@huawei.com, kernel@esmil.dk, linux-mm@kvack.org,
        linux@armlinux.org.uk, luto@kernel.org, m.szyprowski@samsung.com,
        miguel.ojeda.sandonis@gmail.com, mingo@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, peterz@infradead.org, rppt@linux.ibm.com,
        shorne@gmail.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, tsbogend@alpha.franken.de,
        will@kernel.org, ysato@users.sourceforge.jp
Subject:  [patch 172/181] arch, mm: replace for_each_memblock()
 with for_each_mem_pfn_range()
Message-ID: <20201013235803.pVrgkPpsb%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arch, mm: replace for_each_memblock() with for_each_mem_pfn_range()

There are several occurrences of the following pattern:

	for_each_memblock(memory, reg) {
		start_pfn = memblock_region_memory_base_pfn(reg);
		end_pfn = memblock_region_memory_end_pfn(reg);

		/* do something with start_pfn and end_pfn */
	}

Rather than iterate over all memblock.memory regions and each time query
for their start and end PFNs, use for_each_mem_pfn_range() iterator to get
simpler and clearer code.

Link: https://lkml.kernel.org/r/20200818151634.14343-12-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>	[.clang-format]
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Emil Renner Berthing <kernel@esmil.dk>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/init.c           |   11 ++++-------
 arch/arm64/mm/init.c         |   11 ++++-------
 arch/powerpc/kernel/fadump.c |   11 ++++++-----
 arch/powerpc/mm/mem.c        |   15 ++++++++-------
 arch/powerpc/mm/numa.c       |    7 ++-----
 arch/s390/mm/page-states.c   |    6 ++----
 arch/sh/mm/init.c            |    9 +++------
 mm/memblock.c                |    6 ++----
 mm/sparse.c                  |   10 ++++------
 9 files changed, 35 insertions(+), 51 deletions(-)

--- a/arch/arm64/mm/init.c~arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range
+++ a/arch/arm64/mm/init.c
@@ -471,12 +471,10 @@ static inline void free_memmap(unsigned
  */
 static void __init free_unused_memmap(void)
 {
-	unsigned long start, prev_end = 0;
-	struct memblock_region *reg;
-
-	for_each_memblock(memory, reg) {
-		start = __phys_to_pfn(reg->base);
+	unsigned long start, end, prev_end = 0;
+	int i;
 
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, NULL) {
 #ifdef CONFIG_SPARSEMEM
 		/*
 		 * Take care not to free memmap entries that don't exist due
@@ -496,8 +494,7 @@ static void __init free_unused_memmap(vo
 		 * memmap entries are valid from the bank end aligned to
 		 * MAX_ORDER_NR_PAGES.
 		 */
-		prev_end = ALIGN(__phys_to_pfn(reg->base + reg->size),
-				 MAX_ORDER_NR_PAGES);
+		prev_end = ALIGN(end, MAX_ORDER_NR_PAGES);
 	}
 
 #ifdef CONFIG_SPARSEMEM
--- a/arch/arm/mm/init.c~arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range
+++ a/arch/arm/mm/init.c
@@ -299,16 +299,14 @@ free_memmap(unsigned long start_pfn, uns
  */
 static void __init free_unused_memmap(void)
 {
-	unsigned long start, prev_end = 0;
-	struct memblock_region *reg;
+	unsigned long start, end, prev_end = 0;
+	int i;
 
 	/*
 	 * This relies on each bank being in address order.
 	 * The banks are sorted previously in bootmem_init().
 	 */
-	for_each_memblock(memory, reg) {
-		start = memblock_region_memory_base_pfn(reg);
-
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, NULL) {
 #ifdef CONFIG_SPARSEMEM
 		/*
 		 * Take care not to free memmap entries that don't exist
@@ -336,8 +334,7 @@ static void __init free_unused_memmap(vo
 		 * memmap entries are valid from the bank end aligned to
 		 * MAX_ORDER_NR_PAGES.
 		 */
-		prev_end = ALIGN(memblock_region_memory_end_pfn(reg),
-				 MAX_ORDER_NR_PAGES);
+		prev_end = ALIGN(end, MAX_ORDER_NR_PAGES);
 	}
 
 #ifdef CONFIG_SPARSEMEM
--- a/arch/powerpc/kernel/fadump.c~arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range
+++ a/arch/powerpc/kernel/fadump.c
@@ -1242,14 +1242,15 @@ static void fadump_free_reserved_memory(
  */
 static void fadump_release_reserved_area(u64 start, u64 end)
 {
-	u64 tstart, tend, spfn, epfn;
-	struct memblock_region *reg;
+	u64 tstart, tend, spfn, epfn, reg_spfn, reg_epfn, i;
 
 	spfn = PHYS_PFN(start);
 	epfn = PHYS_PFN(end);
-	for_each_memblock(memory, reg) {
-		tstart = max_t(u64, spfn, memblock_region_memory_base_pfn(reg));
-		tend   = min_t(u64, epfn, memblock_region_memory_end_pfn(reg));
+
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &reg_spfn, &reg_epfn, NULL) {
+		tstart = max_t(u64, spfn, reg_spfn);
+		tend   = min_t(u64, epfn, reg_epfn);
+
 		if (tstart < tend) {
 			fadump_free_reserved_memory(tstart, tend);
 
--- a/arch/powerpc/mm/mem.c~arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range
+++ a/arch/powerpc/mm/mem.c
@@ -184,15 +184,16 @@ void __init initmem_init(void)
 /* mark pages that don't exist as nosave */
 static int __init mark_nonram_nosave(void)
 {
-	struct memblock_region *reg, *prev = NULL;
+	unsigned long spfn, epfn, prev = 0;
+	int i;
 
-	for_each_memblock(memory, reg) {
-		if (prev &&
-		    memblock_region_memory_end_pfn(prev) < memblock_region_memory_base_pfn(reg))
-			register_nosave_region(memblock_region_memory_end_pfn(prev),
-					       memblock_region_memory_base_pfn(reg));
-		prev = reg;
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &spfn, &epfn, NULL) {
+		if (prev && prev < spfn)
+			register_nosave_region(prev, spfn);
+
+		prev = epfn;
 	}
+
 	return 0;
 }
 #else /* CONFIG_NEED_MULTIPLE_NODES */
--- a/arch/powerpc/mm/numa.c~arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range
+++ a/arch/powerpc/mm/numa.c
@@ -804,17 +804,14 @@ static void __init setup_nonnuma(void)
 	unsigned long total_ram = memblock_phys_mem_size();
 	unsigned long start_pfn, end_pfn;
 	unsigned int nid = 0;
-	struct memblock_region *reg;
+	int i;
 
 	printk(KERN_DEBUG "Top of RAM: 0x%lx, Total RAM: 0x%lx\n",
 	       top_of_ram, total_ram);
 	printk(KERN_DEBUG "Memory hole size: %ldMB\n",
 	       (top_of_ram - total_ram) >> 20);
 
-	for_each_memblock(memory, reg) {
-		start_pfn = memblock_region_memory_base_pfn(reg);
-		end_pfn = memblock_region_memory_end_pfn(reg);
-
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
 		fake_numa_create_new_node(end_pfn, &nid);
 		memblock_set_node(PFN_PHYS(start_pfn),
 				  PFN_PHYS(end_pfn - start_pfn),
--- a/arch/s390/mm/page-states.c~arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range
+++ a/arch/s390/mm/page-states.c
@@ -183,9 +183,9 @@ static void mark_kernel_pgd(void)
 
 void __init cmma_init_nodat(void)
 {
-	struct memblock_region *reg;
 	struct page *page;
 	unsigned long start, end, ix;
+	int i;
 
 	if (cmma_flag < 2)
 		return;
@@ -193,9 +193,7 @@ void __init cmma_init_nodat(void)
 	mark_kernel_pgd();
 
 	/* Set all kernel pages not used for page tables to stable/no-dat */
-	for_each_memblock(memory, reg) {
-		start = memblock_region_memory_base_pfn(reg);
-		end = memblock_region_memory_end_pfn(reg);
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, NULL) {
 		page = pfn_to_page(start);
 		for (ix = start; ix < end; ix++, page++) {
 			if (__test_and_clear_bit(PG_arch_1, &page->flags))
--- a/arch/sh/mm/init.c~arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range
+++ a/arch/sh/mm/init.c
@@ -226,15 +226,12 @@ void __init allocate_pgdat(unsigned int
 
 static void __init do_init_bootmem(void)
 {
-	struct memblock_region *reg;
+	unsigned long start_pfn, end_pfn;
+	int i;
 
 	/* Add active regions with valid PFNs. */
-	for_each_memblock(memory, reg) {
-		unsigned long start_pfn, end_pfn;
-		start_pfn = memblock_region_memory_base_pfn(reg);
-		end_pfn = memblock_region_memory_end_pfn(reg);
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL)
 		__add_active_range(0, start_pfn, end_pfn);
-	}
 
 	/* All of system RAM sits in node 0 for the non-NUMA case */
 	allocate_pgdat(0);
--- a/mm/memblock.c~arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range
+++ a/mm/memblock.c
@@ -1663,12 +1663,10 @@ phys_addr_t __init_memblock memblock_res
 phys_addr_t __init memblock_mem_size(unsigned long limit_pfn)
 {
 	unsigned long pages = 0;
-	struct memblock_region *r;
 	unsigned long start_pfn, end_pfn;
+	int i;
 
-	for_each_memblock(memory, r) {
-		start_pfn = memblock_region_memory_base_pfn(r);
-		end_pfn = memblock_region_memory_end_pfn(r);
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, NULL) {
 		start_pfn = min_t(unsigned long, start_pfn, limit_pfn);
 		end_pfn = min_t(unsigned long, end_pfn, limit_pfn);
 		pages += end_pfn - start_pfn;
--- a/mm/sparse.c~arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range
+++ a/mm/sparse.c
@@ -291,13 +291,11 @@ static void __init memory_present(int ni
  */
 static void __init memblocks_present(void)
 {
-	struct memblock_region *reg;
+	unsigned long start, end;
+	int i, nid;
 
-	for_each_memblock(memory, reg) {
-		memory_present(memblock_get_region_node(reg),
-			       memblock_region_memory_base_pfn(reg),
-			       memblock_region_memory_end_pfn(reg));
-	}
+	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
+		memory_present(nid, start, end);
 }
 
 /*
_
