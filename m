Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06801A9B4D
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274582; cv=none; b=N1XJH9zDR831RBq90c+w5Bu3fTFwRRkj8KQx6fuKMUOQw9iFmY4zTUuHcIuOsxgqtqu4RCVXWJkuI36HL2K6yjxv/WIWOoneI2DeQuyb6UuU+tC8Drlgxuh9rxuLdyjCfo7MTABLQczYhpcKP805dGrce919xierEdPm3dcAWBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274582; c=relaxed/simple;
	bh=bgh2JIQu/o6QFYbjv1EkR+rGFsmpHJlFlXZTST9cix0=;
	h=Date:To:From:Subject:Message-Id; b=SiwwOZjg+Mf3NK023D1J2ClH2EeQCroM/u3axzwfi/U42iTcfElrFRZwtr1FoSsBEO6mXQKqsp6gwsMVXiFSHFQyMYtKrsAncOh68GkEm2E5OVsNychUOyY0iJmv+27yCLc16RcIbapxdozLyMLW4Ea/ikiBi8ROlNssU+XNOeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Nb8iHOpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Nb8iHOpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CFCC4CEDD;
	Tue, 18 Mar 2025 05:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274582;
	bh=bgh2JIQu/o6QFYbjv1EkR+rGFsmpHJlFlXZTST9cix0=;
	h=Date:To:From:Subject:From;
	b=Nb8iHOplTI+NbqNcbrZ+RSA8egCHP1ndxuAuxAkHr9d+ZxRqWIpLSn/qGXLUEmqCI
	 mZRcF8NBHAF7LjX7KIYmlU8HrnWgWi6svzhBWsnhfiLLYai+5JWad0LZ1XSxbLmpPW
	 /20jbXrCR7QpAQlYt5BfCrf9AjRfoqAuzubaM4Jw=
Date: Mon, 17 Mar 2025 22:09:41 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vgupta@kernel.org,tsbogend@alpha.franken.de,tglx@linutronix.de,shorne@gmail.com,richard@nod.at,palmer@dabbelt.com,mpe@ellerman.id.au,monstr@monstr.eu,mingo@redhat.com,mattst88@gmail.com,maddy@linux.ibm.com,luto@kernel.org,linux@armlinux.org.uk,johannes@sipsolutions.net,jiaxun.yang@flygoat.com,jcmvbkbc@gmail.com,hca@linux.ibm.com,guoren@kernel.org,gor@linux.ibm.com,glaubitz@physik.fu-berlin.de,gerald.schaefer@linux.ibm.com,geert@linux-m68k.org,dinguyen@kernel.org,deller@gmx.de,davem@davemloft.net,dave.hansen@linux.intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,broonie@kernel.org,bp@alien8.de,arnd@arndb.de,ardb@kernel.org,andreas@gaisler.com,agordeev@linux.ibm.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xtensa-split-out-printing-of-virtual-memory-layout-to-a-function.patch removed from -mm tree
Message-Id: <20250318050942.70CFCC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: xtensa: split out printing of virtual memory layout to a function
has been removed from the -mm tree.  Its filename was
     xtensa-split-out-printing-of-virtual-memory-layout-to-a-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-mm_init-rename-__init_reserved_page_zone-to-__init_page_from_nid.patch
mm-mm_init-rename-init_reserved_page-to-init_deferred_page.patch

