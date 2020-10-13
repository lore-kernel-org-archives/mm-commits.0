Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 215DEC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D895922265
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633510;
	bh=pOc4VWbX78gOSUjq9G2LEiqsOKZeJ/0KCuGpegRSZyY=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Eqb1oW3TDPcZEbufP9OyBGKcuCtrqqTp+PWOofqXlip8vTlx7qUhGVP2YtaVW5Yy2
	 lMexwccIdtwK1b5qjGoU04EAJnay5PPjn+iMe8NwjCO3qEJXwb77zM+ybf4dXv66Dn
	 SGpDlkXWgaBWAY+XyAWS5kd+xWt8cxGM2sY5D6j0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389376AbgJMX6a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:58:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:44962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387851AbgJMX6a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:58:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 416D422248;
        Tue, 13 Oct 2020 23:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633507;
        bh=pOc4VWbX78gOSUjq9G2LEiqsOKZeJ/0KCuGpegRSZyY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=16e/1VnfHz/7YEnmo+nIpt0ePPpA0MN4WrZEGZ06CkQgu9mCd+YsdPPTo9XrJ1WG1
         65SVecIBrDh5ZGZg4v+ya1ssN05C7mAMD1IkWIyHaaJYMdlaIPZL0Ngct2rH/k+C53
         NsFGh9r+D/Ryscv6mBCQIlVEzdXZHYxT+c85uQJU=
Date:   Tue, 13 Oct 2020 16:58:25 -0700
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
Subject:  [patch 177/181] memblock: implement
 for_each_reserved_mem_region() using __next_mem_region()
Message-ID: <20201013235825.vSH-L7BPb%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: memblock: implement for_each_reserved_mem_region() using __next_mem_region()

Iteration over memblock.reserved with for_each_reserved_mem_region() used
__next_reserved_mem_region() that implemented a subset of
__next_mem_region().

Use __for_each_mem_range() and, essentially, __next_mem_region() with
appropriate parameters to reduce code duplication.

While on it, rename for_each_reserved_mem_region() to
for_each_reserved_mem_range() for consistency.

Link: https://lkml.kernel.org/r/20200818151634.14343-17-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>	[.clang-format]
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
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

 .clang-format                    |    2 -
 arch/arm64/kernel/setup.c        |    2 -
 drivers/irqchip/irq-gic-v3-its.c |    2 -
 include/linux/memblock.h         |   12 ++----
 mm/memblock.c                    |   56 ++++++++++-------------------
 5 files changed, 27 insertions(+), 47 deletions(-)

--- a/arch/arm64/kernel/setup.c~memblock-implement-for_each_reserved_mem_region-using-__next_mem_region
+++ a/arch/arm64/kernel/setup.c
@@ -257,7 +257,7 @@ static int __init reserve_memblock_reser
 		if (!memblock_is_region_reserved(mem->start, mem_size))
 			continue;
 
-		for_each_reserved_mem_region(j, &r_start, &r_end) {
+		for_each_reserved_mem_range(j, &r_start, &r_end) {
 			resource_size_t start, end;
 
 			start = max(PFN_PHYS(PFN_DOWN(r_start)), mem->start);
--- a/.clang-format~memblock-implement-for_each_reserved_mem_region-using-__next_mem_region
+++ a/.clang-format
@@ -273,7 +273,7 @@ ForEachMacros:
   - 'for_each_registered_fb'
   - 'for_each_requested_gpio'
   - 'for_each_requested_gpio_in_range'
-  - 'for_each_reserved_mem_region'
+  - 'for_each_reserved_mem_range'
   - 'for_each_rtd_codec_dais'
   - 'for_each_rtd_codec_dais_rollback'
   - 'for_each_rtd_components'
--- a/drivers/irqchip/irq-gic-v3-its.c~memblock-implement-for_each_reserved_mem_region-using-__next_mem_region
+++ a/drivers/irqchip/irq-gic-v3-its.c
@@ -2198,7 +2198,7 @@ static bool gic_check_reserved_range(phy
 
 	addr_end = addr + size - 1;
 
-	for_each_reserved_mem_region(i, &start, &end) {
+	for_each_reserved_mem_range(i, &start, &end) {
 		if (addr >= start && addr_end <= end)
 			return true;
 	}
--- a/include/linux/memblock.h~memblock-implement-for_each_reserved_mem_region-using-__next_mem_region
+++ a/include/linux/memblock.h
@@ -132,9 +132,6 @@ void __next_mem_range_rev(u64 *idx, int
 			  struct memblock_type *type_b, phys_addr_t *out_start,
 			  phys_addr_t *out_end, int *out_nid);
 
-void __next_reserved_mem_region(u64 *idx, phys_addr_t *out_start,
-				phys_addr_t *out_end);
-
 void __memblock_free_late(phys_addr_t base, phys_addr_t size);
 
 #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
@@ -224,7 +221,7 @@ static inline void __next_physmem_range(
 				 MEMBLOCK_NONE, p_start, p_end, NULL)
 
 /**
- * for_each_reserved_mem_region - iterate over all reserved memblock areas
+ * for_each_reserved_mem_range - iterate over all reserved memblock areas
  * @i: u64 used as loop variable
  * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
@@ -232,10 +229,9 @@ static inline void __next_physmem_range(
  * Walks over reserved areas of memblock. Available as soon as memblock
  * is initialized.
  */
-#define for_each_reserved_mem_region(i, p_start, p_end)			\
-	for (i = 0UL, __next_reserved_mem_region(&i, p_start, p_end);	\
-	     i != (u64)ULLONG_MAX;					\
-	     __next_reserved_mem_region(&i, p_start, p_end))
+#define for_each_reserved_mem_range(i, p_start, p_end)			\
+	__for_each_mem_range(i, &memblock.reserved, NULL, NUMA_NO_NODE,	\
+			     MEMBLOCK_NONE, p_start, p_end, NULL)
 
 static inline bool memblock_is_hotpluggable(struct memblock_region *m)
 {
--- a/mm/memblock.c~memblock-implement-for_each_reserved_mem_region-using-__next_mem_region
+++ a/mm/memblock.c
@@ -132,6 +132,14 @@ struct memblock_type physmem = {
 };
 #endif
 
+/*
+ * keep a pointer to &memblock.memory in the text section to use it in
+ * __next_mem_range() and its helpers.
+ *  For architectures that do not keep memblock data after init, this
+ * pointer will be reset to NULL at memblock_discard()
+ */
+static __refdata struct memblock_type *memblock_memory = &memblock.memory;
+
 #define for_each_memblock_type(i, memblock_type, rgn)			\
 	for (i = 0, rgn = &memblock_type->regions[0];			\
 	     i < memblock_type->cnt;					\
@@ -402,6 +410,8 @@ void __init memblock_discard(void)
 				  memblock.memory.max);
 		__memblock_free_late(addr, size);
 	}
+
+	memblock_memory = NULL;
 }
 #endif
 
@@ -952,42 +962,16 @@ int __init_memblock memblock_clear_nomap
 	return memblock_setclr_flag(base, size, 0, MEMBLOCK_NOMAP);
 }
 
-/**
- * __next_reserved_mem_region - next function for for_each_reserved_region()
- * @idx: pointer to u64 loop variable
- * @out_start: ptr to phys_addr_t for start address of the region, can be %NULL
- * @out_end: ptr to phys_addr_t for end address of the region, can be %NULL
- *
- * Iterate over all reserved memory regions.
- */
-void __init_memblock __next_reserved_mem_region(u64 *idx,
-					   phys_addr_t *out_start,
-					   phys_addr_t *out_end)
-{
-	struct memblock_type *type = &memblock.reserved;
-
-	if (*idx < type->cnt) {
-		struct memblock_region *r = &type->regions[*idx];
-		phys_addr_t base = r->base;
-		phys_addr_t size = r->size;
-
-		if (out_start)
-			*out_start = base;
-		if (out_end)
-			*out_end = base + size - 1;
-
-		*idx += 1;
-		return;
-	}
-
-	/* signal end of iteration */
-	*idx = ULLONG_MAX;
-}
-
-static bool should_skip_region(struct memblock_region *m, int nid, int flags)
+static bool should_skip_region(struct memblock_type *type,
+			       struct memblock_region *m,
+			       int nid, int flags)
 {
 	int m_nid = memblock_get_region_node(m);
 
+	/* we never skip regions when iterating memblock.reserved or physmem */
+	if (type != memblock_memory)
+		return false;
+
 	/* only memory regions are associated with nodes, check it */
 	if (nid != NUMA_NO_NODE && nid != m_nid)
 		return true;
@@ -1052,7 +1036,7 @@ void __next_mem_range(u64 *idx, int nid,
 		phys_addr_t m_end = m->base + m->size;
 		int	    m_nid = memblock_get_region_node(m);
 
-		if (should_skip_region(m, nid, flags))
+		if (should_skip_region(type_a, m, nid, flags))
 			continue;
 
 		if (!type_b) {
@@ -1156,7 +1140,7 @@ void __init_memblock __next_mem_range_re
 		phys_addr_t m_end = m->base + m->size;
 		int m_nid = memblock_get_region_node(m);
 
-		if (should_skip_region(m, nid, flags))
+		if (should_skip_region(type_a, m, nid, flags))
 			continue;
 
 		if (!type_b) {
@@ -1981,7 +1965,7 @@ static unsigned long __init free_low_mem
 
 	memblock_clear_hotplug(0, -1);
 
-	for_each_reserved_mem_region(i, &start, &end)
+	for_each_reserved_mem_range(i, &start, &end)
 		reserve_bootmem_region(start, end);
 
 	/*
_
