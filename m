Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1BEC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1001E20B1F
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597865265;
	bh=V2f8GEsVFIR9wzmdRWu9gKElZC0/33wrMgIdS80EeeQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=CyDync1yMQggMhl/NwTwTGxxXNk32IePJN5QdDIqxRLgwYNojMCkC1xrQTui9ZJbn
	 TjCFSsWe2zlfGmfb8AySoLbvQCeq9Aiw72IHqdS/w7XLdCgPC88vAM029MFiSAHwhp
	 e7A4QCf86E8Ghw28Rs0gko/WK8tzDxK6QMOr6Cy4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgHST1n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 15:27:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbgHST1n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 15:27:43 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3818620888;
        Wed, 19 Aug 2020 19:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597865262;
        bh=V2f8GEsVFIR9wzmdRWu9gKElZC0/33wrMgIdS80EeeQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FWe/kQIul9vy4yDH21YPCfOf9Xb6R/MWONvd6I0aMu22nZvSZEUdU/A9QvavNMriV
         N1uhTIvh8WmK1fvWUETm/h+5Ke69CwYbikTeuKePeUcULP1qSJYvroP0oWBTytybBP
         YjIh4lyWiVXLYeEPx1Uy9/3aqpgldsIiqo3SDzps=
Date:   Wed, 19 Aug 2020 12:27:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     benh@kernel.crashing.org, bhe@redhat.com, bp@alien8.de,
        catalin.marinas@arm.com, dave.hansen@linux.intel.com,
        dja@axtens.net, hbathini@linux.ibm.com, hch@lst.de,
        jcmvbkbc@gmail.com, Jonathan.Cameron@huawei.com, kernel@esmil.dk,
        linux@armlinux.org.uk, luto@kernel.org, m.szyprowski@samsung.com,
        miguel.ojeda.sandonis@gmail.com, mingo@kernel.org,
        mingo@redhat.com, mm-commits@vger.kernel.org, monstr@monstr.eu,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, peterz@infradead.org, rppt@linux.ibm.com,
        shorne@gmail.com, tglx@linutronix.de, tsbogend@alpha.franken.de,
        will@kernel.org, ysato@users.sourceforge.jp
Subject:  +
 memblock-make-memblock_debug-and-related-functionality-private.patch added
 to -mm tree
Message-ID: <20200819192740.zAdqB-zhQ%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memblock: make memblock_debug and related functionality private
has been added to the -mm tree.  Its filename is
     memblock-make-memblock_debug-and-related-functionality-private.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memblock-make-memblock_debug-and-related-functionality-private.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memblock-make-memblock_debug-and-related-functionality-private.patch

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
Subject: memblock: make memblock_debug and related functionality private

The only user of memblock_dbg() outside memblock was s390 setup code and
it is converted to use pr_debug() instead.  This allows to stop exposing
memblock_debug and memblock_dbg() to the rest of the kernel.

Link: https://lkml.kernel.org/r/20200818151634.14343-10-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
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
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
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

 arch/s390/kernel/setup.c |    4 ++--
 include/linux/memblock.h |   12 +-----------
 mm/memblock.c            |   13 +++++++++++--
 3 files changed, 14 insertions(+), 15 deletions(-)

--- a/arch/s390/kernel/setup.c~memblock-make-memblock_debug-and-related-functionality-private
+++ a/arch/s390/kernel/setup.c
@@ -776,8 +776,8 @@ static void __init memblock_add_mem_dete
 	unsigned long start, end;
 	int i;
 
-	memblock_dbg("physmem info source: %s (%hhd)\n",
-		     get_mem_info_source(), mem_detect.info_source);
+	pr_debug("physmem info source: %s (%hhd)\n",
+		 get_mem_info_source(), mem_detect.info_source);
 	/* keep memblock lists close to the kernel */
 	memblock_set_bottom_up(true);
 	for_each_mem_detect_block(i, &start, &end) {
--- a/include/linux/memblock.h~memblock-make-memblock_debug-and-related-functionality-private
+++ a/include/linux/memblock.h
@@ -86,7 +86,6 @@ struct memblock {
 };
 
 extern struct memblock memblock;
-extern int memblock_debug;
 
 #ifndef CONFIG_ARCH_KEEP_MEMBLOCK
 #define __init_memblock __meminit
@@ -98,9 +97,6 @@ void memblock_discard(void);
 static inline void memblock_discard(void) {}
 #endif
 
-#define memblock_dbg(fmt, ...) \
-	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
-
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
 void memblock_allow_resize(void);
@@ -476,13 +472,7 @@ bool memblock_is_region_memory(phys_addr
 bool memblock_is_reserved(phys_addr_t addr);
 bool memblock_is_region_reserved(phys_addr_t base, phys_addr_t size);
 
-extern void __memblock_dump_all(void);
-
-static inline void memblock_dump_all(void)
-{
-	if (memblock_debug)
-		__memblock_dump_all();
-}
+void memblock_dump_all(void);
 
 /**
  * memblock_set_current_limit - Set the current allocation limit to allow
--- a/mm/memblock.c~memblock-make-memblock_debug-and-related-functionality-private
+++ a/mm/memblock.c
@@ -137,7 +137,10 @@ struct memblock_type physmem = {
 	     i < memblock_type->cnt;					\
 	     i++, rgn = &memblock_type->regions[i])
 
-int memblock_debug __initdata_memblock;
+#define memblock_dbg(fmt, ...) \
+	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
+
+static int memblock_debug __initdata_memblock;
 static bool system_has_some_mirror __initdata_memblock = false;
 static int memblock_can_resize __initdata_memblock;
 static int memblock_memory_in_slab __initdata_memblock = 0;
@@ -1920,7 +1923,7 @@ static void __init_memblock memblock_dum
 	}
 }
 
-void __init_memblock __memblock_dump_all(void)
+static void __init_memblock __memblock_dump_all(void)
 {
 	pr_info("MEMBLOCK configuration:\n");
 	pr_info(" memory size = %pa reserved size = %pa\n",
@@ -1934,6 +1937,12 @@ void __init_memblock __memblock_dump_all
 #endif
 }
 
+void __init_memblock memblock_dump_all(void)
+{
+	if (memblock_debug)
+		__memblock_dump_all();
+}
+
 void __init memblock_allow_resize(void)
 {
 	memblock_can_resize = 1;
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

kvm-ppc-book3s-hv-simplify-kvm_cma_reserve.patch
dma-contiguous-simplify-cma_early_percent_memory.patch
arm-xtensa-simplify-initialization-of-high-memory-pages.patch
arm64-numa-simplify-dummy_numa_init.patch
h8300-nds32-openrisc-simplify-detection-of-memory-extents.patch
riscv-drop-unneeded-node-initialization.patch
mircoblaze-drop-unneeded-numa-and-sparsemem-initializations.patch
memblock-make-for_each_memblock_type-iterator-private.patch
memblock-make-memblock_debug-and-related-functionality-private.patch
memblock-reduce-number-of-parameters-in-for_each_mem_range.patch
arch-mm-replace-for_each_memblock-with-for_each_mem_pfn_range.patch
arch-drivers-replace-for_each_membock-with-for_each_mem_range.patch
x86-setup-simplify-initrd-relocation-and-reservation.patch
x86-setup-simplify-reserve_crashkernel.patch
memblock-remove-unused-memblock_mem_size.patch
memblock-implement-for_each_reserved_mem_region-using-__next_mem_region.patch
memblock-use-separate-iterators-for-memory-and-reserved-regions.patch

