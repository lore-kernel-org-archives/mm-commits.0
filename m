Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016F0C433C1
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA3F86190A
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 04:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhCaEuN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 00:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhCaEuM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 00:50:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3B9961952;
        Wed, 31 Mar 2021 04:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617166212;
        bh=9ECgWp3PvLI65O2xjA2Oh+43i3i5bT41QYZNC1rPf4U=;
        h=Date:From:To:Subject:From;
        b=03MMepMmItA3hQgEhPkWdLszvAkPpgI+X5ag+f8TRtSgGnN8yCAIidwrIYibXxl/M
         GUbvWlT/4f0n8x8oeaHE+EGC4X/wrqM9hLe5h8wDdhgxMjsNNljOUFq51X89vsUcoT
         JzxBSq+62usEqVryty85z11hGHE4ichEgr6bSYXU=
Date:   Tue, 30 Mar 2021 21:50:11 -0700
From:   akpm@linux-foundation.org
To:     catalin.marinas@arm.com, chenhuacai@kernel.org,
        christophe.leroy@c-s.fr, dave.hansen@linux.intel.com,
        davem@davemloft.net, david@redhat.com, guoren@kernel.org,
        hca@linux.ibm.com, jonas@southpole.se, linux@armlinux.org.uk,
        matorola@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        palmer@dabbelt.com, peterz@infradead.org, rth@twiddle.net,
        wangkefeng.wang@huawei.com, ysato@users.osdn.me
Subject:  + mm-move-mem_init_print_info-into-mm_init.patch added to
 -mm tree
Message-ID: <20210331045011.5MrHgJU9D%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move mem_init_print_info() into mm_init()
has been added to the -mm tree.  Its filename is
     mm-move-mem_init_print_info-into-mm_init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-mem_init_print_info-into-mm_init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-mem_init_print_info-into-mm_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: move mem_init_print_info() into mm_init()

mem_init_print_info() is called in mem_init() on each architecture, and
pass NULL argument, so using void argument and move it into mm_init().

Link: https://lkml.kernel.org/r/20210317015210.33641-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>	[x86]
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>	[powerpc]
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Anatoly Pugachev <matorola@gmail.com>	[sparc64]
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Guo Ren <guoren@kernel.org>
Cc: Yoshinori Sato <ysato@users.osdn.me>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Peter Zijlstra" <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/mm/init.c             |    1 -
 arch/arc/mm/init.c               |    1 -
 arch/arm/mm/init.c               |    2 --
 arch/arm64/mm/init.c             |    2 --
 arch/csky/mm/init.c              |    1 -
 arch/h8300/mm/init.c             |    2 --
 arch/hexagon/mm/init.c           |    1 -
 arch/ia64/mm/init.c              |    1 -
 arch/m68k/mm/init.c              |    1 -
 arch/microblaze/mm/init.c        |    1 -
 arch/mips/loongson64/numa.c      |    1 -
 arch/mips/mm/init.c              |    1 -
 arch/mips/sgi-ip27/ip27-memory.c |    1 -
 arch/nds32/mm/init.c             |    1 -
 arch/nios2/mm/init.c             |    1 -
 arch/openrisc/mm/init.c          |    2 --
 arch/parisc/mm/init.c            |    2 --
 arch/powerpc/mm/mem.c            |    1 -
 arch/riscv/mm/init.c             |    1 -
 arch/s390/mm/init.c              |    2 --
 arch/sh/mm/init.c                |    1 -
 arch/sparc/mm/init_32.c          |    2 --
 arch/sparc/mm/init_64.c          |    1 -
 arch/um/kernel/mem.c             |    1 -
 arch/x86/mm/init_32.c            |    2 --
 arch/x86/mm/init_64.c            |    2 --
 arch/xtensa/mm/init.c            |    1 -
 include/linux/mm.h               |    2 +-
 init/main.c                      |    1 +
 mm/page_alloc.c                  |   10 +++++-----
 30 files changed, 7 insertions(+), 42 deletions(-)

--- a/arch/alpha/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/alpha/mm/init.c
@@ -282,5 +282,4 @@ mem_init(void)
 	set_max_mapnr(max_low_pfn);
 	high_memory = (void *) __va(max_low_pfn * PAGE_SIZE);
 	memblock_free_all();
-	mem_init_print_info(NULL);
 }
--- a/arch/arc/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/arc/mm/init.c
@@ -194,7 +194,6 @@ void __init mem_init(void)
 {
 	memblock_free_all();
 	highmem_init();
-	mem_init_print_info(NULL);
 }
 
 #ifdef CONFIG_HIGHMEM
--- a/arch/arm64/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/arm64/mm/init.c
@@ -491,8 +491,6 @@ void __init mem_init(void)
 	/* this will put all unused low memory onto the freelists */
 	memblock_free_all();
 
-	mem_init_print_info(NULL);
-
 	/*
 	 * Check boundaries twice: Some fundamental inconsistencies can be
 	 * detected at build time already.
--- a/arch/arm/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/arm/mm/init.c
@@ -316,8 +316,6 @@ void __init mem_init(void)
 
 	free_highpages();
 
-	mem_init_print_info(NULL);
-
 	/*
 	 * Check boundaries twice: Some fundamental inconsistencies can
 	 * be detected at build time already.
--- a/arch/csky/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/csky/mm/init.c
@@ -107,7 +107,6 @@ void __init mem_init(void)
 			free_highmem_page(page);
 	}
 #endif
-	mem_init_print_info(NULL);
 }
 
 void free_initmem(void)
--- a/arch/h8300/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/h8300/mm/init.c
@@ -98,6 +98,4 @@ void __init mem_init(void)
 
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
-
-	mem_init_print_info(NULL);
 }
--- a/arch/hexagon/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/hexagon/mm/init.c
@@ -55,7 +55,6 @@ void __init mem_init(void)
 {
 	/*  No idea where this is actually declared.  Seems to evade LXR.  */
 	memblock_free_all();
-	mem_init_print_info(NULL);
 
 	/*
 	 *  To-Do:  someone somewhere should wipe out the bootmem map
--- a/arch/ia64/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/ia64/mm/init.c
@@ -662,7 +662,6 @@ mem_init (void)
 	set_max_mapnr(max_low_pfn);
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
 	memblock_free_all();
-	mem_init_print_info(NULL);
 
 	/*
 	 * For fsyscall entrpoints with no light-weight handler, use the ordinary
--- a/arch/m68k/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/m68k/mm/init.c
@@ -153,5 +153,4 @@ void __init mem_init(void)
 	/* this will put all memory onto the freelists */
 	memblock_free_all();
 	init_pointer_tables();
-	mem_init_print_info(NULL);
 }
--- a/arch/microblaze/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/microblaze/mm/init.c
@@ -131,7 +131,6 @@ void __init mem_init(void)
 	highmem_setup();
 #endif
 
-	mem_init_print_info(NULL);
 	mem_init_done = 1;
 }
 
--- a/arch/mips/loongson64/numa.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/mips/loongson64/numa.c
@@ -167,7 +167,6 @@ void __init mem_init(void)
 	high_memory = (void *) __va(get_num_physpages() << PAGE_SHIFT);
 	memblock_free_all();
 	setup_zero_pages();	/* This comes from node 0 */
-	mem_init_print_info(NULL);
 }
 
 /* All PCI device belongs to logical Node-0 */
--- a/arch/mips/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/mips/mm/init.c
@@ -467,7 +467,6 @@ void __init mem_init(void)
 	memblock_free_all();
 	setup_zero_pages();	/* Setup zeroed pages.  */
 	mem_init_free_highmem();
-	mem_init_print_info(NULL);
 
 #ifdef CONFIG_64BIT
 	if ((unsigned long) &_text > (unsigned long) CKSEG0)
--- a/arch/mips/sgi-ip27/ip27-memory.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/mips/sgi-ip27/ip27-memory.c
@@ -420,5 +420,4 @@ void __init mem_init(void)
 	high_memory = (void *) __va(get_num_physpages() << PAGE_SHIFT);
 	memblock_free_all();
 	setup_zero_pages();	/* This comes from node 0 */
-	mem_init_print_info(NULL);
 }
--- a/arch/nds32/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/nds32/mm/init.c
@@ -191,7 +191,6 @@ void __init mem_init(void)
 
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
-	mem_init_print_info(NULL);
 
 	pr_info("virtual kernel memory layout:\n"
 		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
--- a/arch/nios2/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/nios2/mm/init.c
@@ -71,7 +71,6 @@ void __init mem_init(void)
 
 	/* this will put all memory onto the freelists */
 	memblock_free_all();
-	mem_init_print_info(NULL);
 }
 
 void __init mmu_init(void)
--- a/arch/openrisc/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/openrisc/mm/init.c
@@ -211,8 +211,6 @@ void __init mem_init(void)
 	/* this will put all low memory onto the freelists */
 	memblock_free_all();
 
-	mem_init_print_info(NULL);
-
 	printk("mem_init_done ...........................................\n");
 	mem_init_done = 1;
 	return;
--- a/arch/parisc/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/parisc/mm/init.c
@@ -573,8 +573,6 @@ void __init mem_init(void)
 #endif
 		parisc_vmalloc_start = SET_MAP_OFFSET(MAP_START);
 
-	mem_init_print_info(NULL);
-
 #if 0
 	/*
 	 * Do not expose the virtual kernel memory layout to userspace.
--- a/arch/powerpc/mm/mem.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/powerpc/mm/mem.c
@@ -312,7 +312,6 @@ void __init mem_init(void)
 		(mfspr(SPRN_TLB1CFG) & TLBnCFG_N_ENTRY) - 1;
 #endif
 
-	mem_init_print_info(NULL);
 #ifdef CONFIG_PPC32
 	pr_info("Kernel virtual memory layout:\n");
 #ifdef CONFIG_KASAN
--- a/arch/riscv/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/riscv/mm/init.c
@@ -102,7 +102,6 @@ void __init mem_init(void)
 	high_memory = (void *)(__va(PFN_PHYS(max_low_pfn)));
 	memblock_free_all();
 
-	mem_init_print_info(NULL);
 	print_vm_layout();
 }
 
--- a/arch/s390/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/s390/mm/init.c
@@ -209,8 +209,6 @@ void __init mem_init(void)
 	setup_zero_pages();	/* Setup zeroed pages. */
 
 	cmma_init_nodat();
-
-	mem_init_print_info(NULL);
 }
 
 void free_initmem(void)
--- a/arch/sh/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/sh/mm/init.c
@@ -359,7 +359,6 @@ void __init mem_init(void)
 
 	vsyscall_init();
 
-	mem_init_print_info(NULL);
 	pr_info("virtual kernel memory layout:\n"
 		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
 		"    vmalloc : 0x%08lx - 0x%08lx   (%4ld MB)\n"
--- a/arch/sparc/mm/init_32.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/sparc/mm/init_32.c
@@ -292,8 +292,6 @@ void __init mem_init(void)
 
 		map_high_region(start_pfn, end_pfn);
 	}
-
-	mem_init_print_info(NULL);
 }
 
 void sparc_flush_page_to_ram(struct page *page)
--- a/arch/sparc/mm/init_64.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/sparc/mm/init_64.c
@@ -2520,7 +2520,6 @@ void __init mem_init(void)
 	}
 	mark_page_reserved(mem_map_zero);
 
-	mem_init_print_info(NULL);
 
 	if (tlb_type == cheetah || tlb_type == cheetah_plus)
 		cheetah_ecache_flush_init();
--- a/arch/um/kernel/mem.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/um/kernel/mem.c
@@ -54,7 +54,6 @@ void __init mem_init(void)
 	memblock_free_all();
 	max_low_pfn = totalram_pages();
 	max_pfn = max_low_pfn;
-	mem_init_print_info(NULL);
 	kmalloc_ok = 1;
 }
 
--- a/arch/x86/mm/init_32.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/x86/mm/init_32.c
@@ -755,8 +755,6 @@ void __init mem_init(void)
 	after_bootmem = 1;
 	x86_init.hyper.init_after_bootmem();
 
-	mem_init_print_info(NULL);
-
 	/*
 	 * Check boundaries twice: Some fundamental inconsistencies can
 	 * be detected at build time already.
--- a/arch/x86/mm/init_64.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/x86/mm/init_64.c
@@ -1350,8 +1350,6 @@ void __init mem_init(void)
 		kclist_add(&kcore_vsyscall, (void *)VSYSCALL_ADDR, PAGE_SIZE, KCORE_USER);
 
 	preallocate_vmalloc_pages();
-
-	mem_init_print_info(NULL);
 }
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
--- a/arch/xtensa/mm/init.c~mm-move-mem_init_print_info-into-mm_init
+++ a/arch/xtensa/mm/init.c
@@ -119,7 +119,6 @@ void __init mem_init(void)
 
 	memblock_free_all();
 
-	mem_init_print_info(NULL);
 	pr_info("virtual kernel memory layout:\n"
 #ifdef CONFIG_KASAN
 		"    kasan   : 0x%08lx - 0x%08lx  (%5lu MB)\n"
--- a/include/linux/mm.h~mm-move-mem_init_print_info-into-mm_init
+++ a/include/linux/mm.h
@@ -2350,7 +2350,7 @@ extern unsigned long free_reserved_area(
 					int poison, const char *s);
 
 extern void adjust_managed_page_count(struct page *page, long count);
-extern void mem_init_print_info(const char *str);
+extern void mem_init_print_info(void);
 
 extern void reserve_bootmem_region(phys_addr_t start, phys_addr_t end);
 
--- a/init/main.c~mm-move-mem_init_print_info-into-mm_init
+++ a/init/main.c
@@ -830,6 +830,7 @@ static void __init mm_init(void)
 	report_meminit();
 	stack_depot_init();
 	mem_init();
+	mem_init_print_info();
 	/* page_owner must be initialized after buddy is ready */
 	page_ext_init_flatmem_late();
 	kmem_cache_init();
--- a/mm/page_alloc.c~mm-move-mem_init_print_info-into-mm_init
+++ a/mm/page_alloc.c
@@ -7734,7 +7734,7 @@ unsigned long free_reserved_area(void *s
 	return pages;
 }
 
-void __init mem_init_print_info(const char *str)
+void __init mem_init_print_info(void)
 {
 	unsigned long physpages, codesize, datasize, rosize, bss_size;
 	unsigned long init_code_size, init_data_size;
@@ -7773,17 +7773,17 @@ void __init mem_init_print_info(const ch
 #ifdef	CONFIG_HIGHMEM
 		", %luK highmem"
 #endif
-		"%s%s)\n",
+		")\n",
 		nr_free_pages() << (PAGE_SHIFT - 10),
 		physpages << (PAGE_SHIFT - 10),
 		codesize >> 10, datasize >> 10, rosize >> 10,
 		(init_data_size + init_code_size) >> 10, bss_size >> 10,
 		(physpages - totalram_pages() - totalcma_pages) << (PAGE_SHIFT - 10),
-		totalcma_pages << (PAGE_SHIFT - 10),
+		totalcma_pages << (PAGE_SHIFT - 10)
 #ifdef	CONFIG_HIGHMEM
-		totalhigh_pages() << (PAGE_SHIFT - 10),
+		, totalhigh_pages() << (PAGE_SHIFT - 10)
 #endif
-		str ? ", " : "", str ? str : "");
+		);
 }
 
 /**
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-move-mem_init_print_info-into-mm_init.patch
mm-page_alloc-avoid-page_to_pfn-in-move_freepages.patch

