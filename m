From: akpm@linux-foundation.org
Subject: + redefine-resource_size_t-as-phys_addr_t.patch added to -mm tree
Date: Fri, 22 Aug 2008 13:00:56 -0700
Message-ID: <200808222000.m7MK0uql013846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757967AbYHVUCg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 22 Aug 2008 16:02:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, benh@kernel.crashing.org, ehabkost@redhat.com, jeremy.fitzhardinge@citrix.com, mingo@elte.hu, paulus@samba.org, takata@linux-m32r.org, tglx@linutronix.de


The patch titled
     redefine resource_size_t as phys_addr_t
has been added to the -mm tree.  Its filename is
     redefine-resource_size_t-as-phys_addr_t.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: redefine resource_size_t as phys_addr_t
From: Jeremy Fitzhardinge <jeremy@goop.org>

There's no good reason why a resource_size_t shouldn't just be a
physical address, so simply redefine it in terms of phys_addr_t.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/Kconfig.cputype |    1 -
 arch/powerpc/sysdev/ppc4xx_pci.c       |   16 ++++++----------
 arch/x86/Kconfig                       |    1 -
 arch/x86/kernel/e820.c                 |    4 +---
 drivers/pci/setup-bus.c                |    9 ++++-----
 include/linux/types.h                  |    8 ++------
 6 files changed, 13 insertions(+), 26 deletions(-)

diff -puN arch/powerpc/platforms/Kconfig.cputype~redefine-resource_size_t-as-phys_addr_t arch/powerpc/platforms/Kconfig.cputype
--- a/arch/powerpc/platforms/Kconfig.cputype~redefine-resource_size_t-as-phys_addr_t
+++ a/arch/powerpc/platforms/Kconfig.cputype
@@ -135,7 +135,6 @@ config PTE_64BIT
 config PHYS_64BIT
 	bool 'Large physical address support' if E500
 	depends on 44x || E500
-	select RESOURCES_64BIT
 	default y if 44x
 	---help---
 	  This option enables kernel support for larger than 32-bit physical
diff -puN arch/powerpc/sysdev/ppc4xx_pci.c~redefine-resource_size_t-as-phys_addr_t arch/powerpc/sysdev/ppc4xx_pci.c
--- a/arch/powerpc/sysdev/ppc4xx_pci.c~redefine-resource_size_t-as-phys_addr_t
+++ a/arch/powerpc/sysdev/ppc4xx_pci.c
@@ -41,13 +41,10 @@ extern unsigned long total_memory;
 #define U64_TO_U32_LOW(val)	((u32)((val) & 0x00000000ffffffffULL))
 #define U64_TO_U32_HIGH(val)	((u32)((val) >> 32))
 
-#ifdef CONFIG_RESOURCES_64BIT
-#define RES_TO_U32_LOW(val)	U64_TO_U32_LOW(val)
-#define RES_TO_U32_HIGH(val)	U64_TO_U32_HIGH(val)
-#else
-#define RES_TO_U32_LOW(val)	(val)
-#define RES_TO_U32_HIGH(val)	(0)
-#endif
+#define RES_TO_U32_LOW(val)	\
+	((sizeof(resource_size_t) > sizeof(u32)) ? U64_TO_U32_LOW(val) : (val))
+#define RES_TO_U32_HIGH(val)	\
+	((sizeof(resource_size_t) > sizeof(u32)) ? U64_TO_U32_HIGH(val) : (0))
 
 static inline int ppc440spe_revA(void)
 {
@@ -145,12 +142,11 @@ static int __init ppc4xx_parse_dma_range
 
 		/* Use that */
 		res->start = pci_addr;
-#ifndef CONFIG_RESOURCES_64BIT
 		/* Beware of 32 bits resources */
-		if ((pci_addr + size) > 0x100000000ull)
+		if (sizeof(resource_size_t) == sizeof(u32) &&
+		    (pci_addr + size) > 0x100000000ull)
 			res->end = 0xffffffff;
 		else
-#endif
 			res->end = res->start + size - 1;
 		break;
 	}
diff -puN arch/x86/Kconfig~redefine-resource_size_t-as-phys_addr_t arch/x86/Kconfig
--- a/arch/x86/Kconfig~redefine-resource_size_t-as-phys_addr_t
+++ a/arch/x86/Kconfig
@@ -961,7 +961,6 @@ config X86_PAE
 	def_bool n
 	prompt "PAE (Physical Address Extension) Support"
 	depends on X86_32 && !HIGHMEM4G
-	select RESOURCES_64BIT
 	help
 	  PAE is required for NX support, and furthermore enables
 	  larger swapspace support for non-overcommit purposes. It
diff -puN arch/x86/kernel/e820.c~redefine-resource_size_t-as-phys_addr_t arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c~redefine-resource_size_t-as-phys_addr_t
+++ a/arch/x86/kernel/e820.c
@@ -1280,12 +1280,10 @@ void __init e820_reserve_resources(void)
 	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
 	for (i = 0; i < e820.nr_map; i++) {
 		end = e820.map[i].addr + e820.map[i].size - 1;
-#ifndef CONFIG_RESOURCES_64BIT
-		if (end > 0x100000000ULL) {
+		if (end != (resource_size_t)end) {
 			res++;
 			continue;
 		}
-#endif
 		res->name = e820_type_to_string(e820.map[i].type);
 		res->start = e820.map[i].addr;
 		res->end = end;
diff -puN drivers/pci/setup-bus.c~redefine-resource_size_t-as-phys_addr_t drivers/pci/setup-bus.c
--- a/drivers/pci/setup-bus.c~redefine-resource_size_t-as-phys_addr_t
+++ a/drivers/pci/setup-bus.c
@@ -377,11 +377,10 @@ static int pbus_size_mem(struct pci_bus 
 	align = 0;
 	min_align = 0;
 	for (order = 0; order <= max_order; order++) {
-#ifdef CONFIG_RESOURCES_64BIT
-		resource_size_t align1 = 1ULL << (order + 20);
-#else
-		resource_size_t align1 = 1U << (order + 20);
-#endif
+		resource_size_t align1 = 1;
+
+		align1 <<= (order + 20);
+
 		if (!align)
 			min_align = align1;
 		else if (ALIGN(align + min_align, min_align) < align1)
diff -puN include/linux/types.h~redefine-resource_size_t-as-phys_addr_t include/linux/types.h
--- a/include/linux/types.h~redefine-resource_size_t-as-phys_addr_t
+++ a/include/linux/types.h
@@ -191,18 +191,14 @@ typedef __u32 __bitwise __wsum;
 #ifdef __KERNEL__
 typedef unsigned __bitwise__ gfp_t;
 
-#ifdef CONFIG_RESOURCES_64BIT
-typedef u64 resource_size_t;
-#else
-typedef u32 resource_size_t;
-#endif
