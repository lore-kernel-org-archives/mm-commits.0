Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC361F2B94
	for <mm-commits@vger.kernel.org>; Thu, 13 Mar 2025 21:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741899717; cv=none; b=MnxhHMOhmqEWSxKNbTHHuqaikVSspjrEJwF/pg06EFt+6ec25hRam790m2ulDqSKaCjmmGOToA43smHICPBvL7ZD+zoPnOYpFPfX4MDQAiYZEAA9p78+H542jfqFkFYTY+WOcHDl3A43ruv9xshCk7oiZKlOX7wghHz7Yu7PgEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741899717; c=relaxed/simple;
	bh=6MOo6JfVg2bbTD1Avp/Rho427qvgd6s7LYFN6RdfQGQ=;
	h=Date:To:From:Subject:Message-Id; b=bWL8RR145mhtPI24TAZMrNbp04DyqlLOfTjRqzFQAXzpS85FJqqPXM5glNokL5uKSeEA4YuuFPVFYRBJd+WPcdaH/hl4+sdT1h0/ZQY+mj3oy4D3DD7kORgbQRxZaI5vZEjq31T2JEOqAXlKBD/JYigpiEIS8PdcI6UUZt6xnbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2a4rBPTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2a4rBPTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14654C4CEDD;
	Thu, 13 Mar 2025 21:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741899717;
	bh=6MOo6JfVg2bbTD1Avp/Rho427qvgd6s7LYFN6RdfQGQ=;
	h=Date:To:From:Subject:From;
	b=2a4rBPTJQ7ugTYPWyAyMgGMlbcX6pZS+RVlmWfdAQMnuyZKKNuNfsEx0lTCOtoNUX
	 LZ4Tl1Qj+fWlJ8vqgeBY7LAkQzMB9cCfiRMISEDhgeFagCDG7IYRvYJrdOeRFRN7Os
	 SNBSK7x3AkA+wY0Hrt4cejlmMRv0jGY9GSIQZbMM=
Date: Thu, 13 Mar 2025 14:01:56 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,luto@kernel.org,linux@armlinux.org.uk,johannes@sipsolutions.net,jiaxun.yang@flygoat.com,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + xtensa-split-out-printing-of-virtual-memory-layout-to-a-function.patch added to mm-unstable branch
Message-Id: <20250313210157.14654C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: xtensa: split out printing of virtual memory layout to a function
has been added to the -mm mm-unstable branch.  Its filename is
     xtensa-split-out-printing-of-virtual-memory-layout-to-a-function.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xtensa-split-out-printing-of-virtual-memory-layout-to-a-function.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: xtensa: split out printing of virtual memory layout to a function
Date: Thu, 13 Mar 2025 15:49:58 +0200

This will help with pulling out memblock_free_all() to the generic
code and reducing code duplication in arch::mem_init().

Link: https://lkml.kernel.org/r/20250313135003.836600-9-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dinh Nguyen <dinguyen@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Guo Ren (csky) <guoren@kernel.org>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russel King <linux@armlinux.org.uk>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/init.c |   97 ++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 47 deletions(-)

--- a/arch/xtensa/mm/init.c~xtensa-split-out-printing-of-virtual-memory-layout-to-a-function
+++ a/arch/xtensa/mm/init.c
@@ -66,6 +66,55 @@ void __init bootmem_init(void)
 	memblock_dump_all();
 }
 
+static void __init print_vm_layout(void)
+{
+	pr_info("virtual kernel memory layout:\n"
+#ifdef CONFIG_KASAN
+		"    kasan   : 0x%08lx - 0x%08lx  (%5lu MB)\n"
+#endif
+#ifdef CONFIG_MMU
+		"    vmalloc : 0x%08lx - 0x%08lx  (%5lu MB)\n"
+#endif
+#ifdef CONFIG_HIGHMEM
+		"    pkmap   : 0x%08lx - 0x%08lx  (%5lu kB)\n"
+		"    fixmap  : 0x%08lx - 0x%08lx  (%5lu kB)\n"
+#endif
+		"    lowmem  : 0x%08lx - 0x%08lx  (%5lu MB)\n"
+		"    .text   : 0x%08lx - 0x%08lx  (%5lu kB)\n"
+		"    .rodata : 0x%08lx - 0x%08lx  (%5lu kB)\n"
+		"    .data   : 0x%08lx - 0x%08lx  (%5lu kB)\n"
+		"    .init   : 0x%08lx - 0x%08lx  (%5lu kB)\n"
+		"    .bss    : 0x%08lx - 0x%08lx  (%5lu kB)\n",
+#ifdef CONFIG_KASAN
+		KASAN_SHADOW_START, KASAN_SHADOW_START + KASAN_SHADOW_SIZE,
+		KASAN_SHADOW_SIZE >> 20,
+#endif
+#ifdef CONFIG_MMU
+		VMALLOC_START, VMALLOC_END,
+		(VMALLOC_END - VMALLOC_START) >> 20,
+#ifdef CONFIG_HIGHMEM
+		PKMAP_BASE, PKMAP_BASE + LAST_PKMAP * PAGE_SIZE,
+		(LAST_PKMAP*PAGE_SIZE) >> 10,
+		FIXADDR_START, FIXADDR_END,
+		(FIXADDR_END - FIXADDR_START) >> 10,
+#endif
+		PAGE_OFFSET, PAGE_OFFSET +
+		(max_low_pfn - min_low_pfn) * PAGE_SIZE,
+#else
+		min_low_pfn * PAGE_SIZE, max_low_pfn * PAGE_SIZE,
+#endif
+		((max_low_pfn - min_low_pfn) * PAGE_SIZE) >> 20,
+		(unsigned long)_text, (unsigned long)_etext,
+		(unsigned long)(_etext - _text) >> 10,
+		(unsigned long)__start_rodata, (unsigned long)__end_rodata,
+		(unsigned long)(__end_rodata - __start_rodata) >> 10,
+		(unsigned long)_sdata, (unsigned long)_edata,
+		(unsigned long)(_edata - _sdata) >> 10,
+		(unsigned long)__init_begin, (unsigned long)__init_end,
+		(unsigned long)(__init_end - __init_begin) >> 10,
+		(unsigned long)__bss_start, (unsigned long)__bss_stop,
+		(unsigned long)(__bss_stop - __bss_start) >> 10);
+}
 
 void __init zones_init(void)
 {
@@ -77,6 +126,7 @@ void __init zones_init(void)
 #endif
 	};
 	free_area_init(max_zone_pfn);
+	print_vm_layout();
 }
 
 static void __init free_highpages(void)
@@ -118,53 +168,6 @@ void __init mem_init(void)
 	high_memory = (void *)__va(max_low_pfn << PAGE_SHIFT);
 
 	memblock_free_all();
-
-	pr_info("virtual kernel memory layout:\n"
-#ifdef CONFIG_KASAN
-		"    kasan   : 0x%08lx - 0x%08lx  (%5lu MB)\n"
-#endif
-#ifdef CONFIG_MMU
-		"    vmalloc : 0x%08lx - 0x%08lx  (%5lu MB)\n"
-#endif
-#ifdef CONFIG_HIGHMEM
-		"    pkmap   : 0x%08lx - 0x%08lx  (%5lu kB)\n"
-		"    fixmap  : 0x%08lx - 0x%08lx  (%5lu kB)\n"
-#endif
-		"    lowmem  : 0x%08lx - 0x%08lx  (%5lu MB)\n"
-		"    .text   : 0x%08lx - 0x%08lx  (%5lu kB)\n"
-		"    .rodata : 0x%08lx - 0x%08lx  (%5lu kB)\n"
-		"    .data   : 0x%08lx - 0x%08lx  (%5lu kB)\n"
-		"    .init   : 0x%08lx - 0x%08lx  (%5lu kB)\n"
-		"    .bss    : 0x%08lx - 0x%08lx  (%5lu kB)\n",
-#ifdef CONFIG_KASAN
-		KASAN_SHADOW_START, KASAN_SHADOW_START + KASAN_SHADOW_SIZE,
-		KASAN_SHADOW_SIZE >> 20,
-#endif
-#ifdef CONFIG_MMU
-		VMALLOC_START, VMALLOC_END,
-		(VMALLOC_END - VMALLOC_START) >> 20,
-#ifdef CONFIG_HIGHMEM
-		PKMAP_BASE, PKMAP_BASE + LAST_PKMAP * PAGE_SIZE,
-		(LAST_PKMAP*PAGE_SIZE) >> 10,
-		FIXADDR_START, FIXADDR_END,
-		(FIXADDR_END - FIXADDR_START) >> 10,
-#endif
-		PAGE_OFFSET, PAGE_OFFSET +
-		(max_low_pfn - min_low_pfn) * PAGE_SIZE,
-#else
-		min_low_pfn * PAGE_SIZE, max_low_pfn * PAGE_SIZE,
-#endif
-		((max_low_pfn - min_low_pfn) * PAGE_SIZE) >> 20,
-		(unsigned long)_text, (unsigned long)_etext,
-		(unsigned long)(_etext - _text) >> 10,
-		(unsigned long)__start_rodata, (unsigned long)__end_rodata,
-		(unsigned long)(__end_rodata - __start_rodata) >> 10,
-		(unsigned long)_sdata, (unsigned long)_edata,
-		(unsigned long)(_edata - _sdata) >> 10,
-		(unsigned long)__init_begin, (unsigned long)__init_end,
-		(unsigned long)(__init_end - __init_begin) >> 10,
-		(unsigned long)__bss_start, (unsigned long)__bss_stop,
-		(unsigned long)(__bss_stop - __bss_start) >> 10);
 }
 
 static void __init parse_memmap_one(char *p)
_

Patches currently in -mm which might be from rppt@kernel.org are

arm-mem_init-use-memblock_phys_free-to-free-dma-memory-on-sa1111.patch
csky-move-setup_initrd-to-setupc.patch
hexagon-move-initialization-of-init_mmcontext-init-to-paging_init.patch
mips-consolidate-mem_init-for-numa-machines.patch
mips-make-setup_zero_pages-use-memblock.patch
nios2-move-pr_debug-about-memory-start-and-end-to-setup_arch.patch
s390-make-setup_zero_pages-use-memblock.patch
xtensa-split-out-printing-of-virtual-memory-layout-to-a-function.patch
arch-mm-set-max_mapnr-when-allocating-memory-map-for-flatmem.patch
arch-mm-set-high_memory-in-free_area_init.patch
arch-mm-streamline-highmem-freeing.patch
arch-mm-introduce-arch_mm_preinit.patch
arch-mm-make-releasing-of-memory-to-page-allocator-more-explicit.patch

