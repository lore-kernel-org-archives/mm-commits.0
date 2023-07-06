Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B243FEB64D9
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 17:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbjGFREG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 13:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbjGFRDy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 13:03:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1B11BF6
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 10:03:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9688C60F6B
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 17:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3001C433C7;
        Thu,  6 Jul 2023 17:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688663027;
        bh=BU7YZ98Z7gOzxdCEDW6BGSVyjiU4ZvX22fFzf9uUJtI=;
        h=Date:To:From:Subject:From;
        b=kkWaX3L2TMLt4gxMRLOfUx4fKqz6br8VQvoQ6kq5HLSq2f7VaWjEg1nbRv4aXyd1/
         NLh9B9VUJyUgTE4RqMleyvYrXIa/17H04t+HImT6ITNQK247VwLYbyrgtUfH5hrtP0
         K4xV9SbIVLIWKPMc/dB5a0+NUbX0lgrllkWtjrrc=
Date:   Thu, 06 Jul 2023 10:03:46 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        willy@infradead.org, will@kernel.org, wangkefeng.wang@huawei.com,
        vgupta@kernel.org, svens@linux.ibm.com,
        stefan.kristiansson@saunalahti.fi, shorne@gmail.com,
        schnelle@linux.ibm.com, rppt@kernel.org, npiggin@gmail.com,
        nathan@kernel.org, mpe@ellerman.id.au, jonas@southpole.se,
        jcmvbkbc@gmail.com, James.Bottomley@HansenPartnership.com,
        hch@lst.de, hca@linux.ibm.com, gor@linux.ibm.com,
        glaubitz@physik.fu-berlin.de, gerald.schaefer@linux.ibm.com,
        geert@linux-m68k.org, deller@gmx.de, David.Laight@ACULAB.COM,
        dalias@libc.org, chris@zankel.net, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, bhe@redhat.com, bcain@quicinc.com,
        arnd@arndb.de, agordeev@linux.ibm.com, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-mm-convert-to-generic_ioremap.patch added to mm-unstable branch
Message-Id: <20230706170346.E3001C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: mm: convert to GENERIC_IOREMAP
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-mm-convert-to-generic_ioremap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-mm-convert-to-generic_ioremap.patch

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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: powerpc: mm: convert to GENERIC_IOREMAP
Date: Thu, 6 Jul 2023 23:45:18 +0800

By taking GENERIC_IOREMAP method, the generic generic_ioremap_prot(),
generic_iounmap(), and their generic wrapper ioremap_prot(), ioremap()
and iounmap() are all visible and available to arch. Arch needs to
provide wrapper functions to override the generic versions if there's
arch specific handling in its ioremap_prot(), ioremap() or iounmap().
This change will simplify implementation by removing duplicated code
with generic_ioremap_prot() and generic_iounmap(), and has the equivalent
functioality as before.

Here, add wrapper functions ioremap_prot() and iounmap() for powerpc's
special operation when ioremap() and iounmap().

Link: https://lkml.kernel.org/r/20230706154520.11257-18-bhe@redhat.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig          |    1 +
 arch/powerpc/include/asm/io.h |    8 +++-----
 arch/powerpc/mm/ioremap.c     |   26 +-------------------------
 arch/powerpc/mm/ioremap_32.c  |   19 +++++++++----------
 arch/powerpc/mm/ioremap_64.c  |   12 ++----------
 5 files changed, 16 insertions(+), 50 deletions(-)

--- a/arch/powerpc/include/asm/io.h~powerpc-mm-convert-to-generic_ioremap
+++ a/arch/powerpc/include/asm/io.h
@@ -889,8 +889,8 @@ static inline void iosync(void)
  *
  */
 extern void __iomem *ioremap(phys_addr_t address, unsigned long size);
-extern void __iomem *ioremap_prot(phys_addr_t address, unsigned long size,
-				  unsigned long flags);
+#define ioremap ioremap
+#define ioremap_prot ioremap_prot
 extern void __iomem *ioremap_wc(phys_addr_t address, unsigned long size);
 #define ioremap_wc ioremap_wc
 
@@ -904,14 +904,12 @@ void __iomem *ioremap_coherent(phys_addr
 #define ioremap_cache(addr, size) \
 	ioremap_prot((addr), (size), pgprot_val(PAGE_KERNEL))
 
-extern void iounmap(volatile void __iomem *addr);
+#define iounmap iounmap
 
 void __iomem *ioremap_phb(phys_addr_t paddr, unsigned long size);
 
 int early_ioremap_range(unsigned long ea, phys_addr_t pa,
 			unsigned long size, pgprot_t prot);
-void __iomem *do_ioremap(phys_addr_t pa, phys_addr_t offset, unsigned long size,
-			 pgprot_t prot, void *caller);
 
 extern void __iomem *__ioremap_caller(phys_addr_t, unsigned long size,
 				      pgprot_t prot, void *caller);
--- a/arch/powerpc/Kconfig~powerpc-mm-convert-to-generic_ioremap
+++ a/arch/powerpc/Kconfig
@@ -193,6 +193,7 @@ config PPC
 	select GENERIC_CPU_VULNERABILITIES	if PPC_BARRIER_NOSPEC
 	select GENERIC_EARLY_IOREMAP
 	select GENERIC_GETTIMEOFDAY
+	select GENERIC_IOREMAP
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_SHOW_LEVEL
 	select GENERIC_PCI_IOMAP		if PCI
--- a/arch/powerpc/mm/ioremap_32.c~powerpc-mm-convert-to-generic_ioremap
+++ a/arch/powerpc/mm/ioremap_32.c
@@ -22,6 +22,13 @@ __ioremap_caller(phys_addr_t addr, unsig
 	int err;
 
 	/*
+	 * If the address lies within the first 16 MB, assume it's in ISA
+	 * memory space
+	 */
+	if (addr < SZ_16M)
+		addr += _ISA_MEM_BASE;
+
+	/*
 	 * Choose an address to map it to.
 	 * Once the vmalloc system is running, we use it.
 	 * Before then, we use space going down from IOREMAP_TOP
@@ -31,13 +38,6 @@ __ioremap_caller(phys_addr_t addr, unsig
 	offset = addr & ~PAGE_MASK;
 	size = PAGE_ALIGN(addr + size) - p;
 
-	/*
-	 * If the address lies within the first 16 MB, assume it's in ISA
-	 * memory space
-	 */
-	if (p < 16 * 1024 * 1024)
-		p += _ISA_MEM_BASE;
-
 #ifndef CONFIG_CRASH_DUMP
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using.
@@ -63,7 +63,7 @@ __ioremap_caller(phys_addr_t addr, unsig
 		return (void __iomem *)v + offset;
 
 	if (slab_is_available())
-		return do_ioremap(p, offset, size, prot, caller);
+		return generic_ioremap_prot(addr, size, prot);
 
 	/*
 	 * Should check if it is a candidate for a BAT mapping
@@ -87,7 +87,6 @@ void iounmap(volatile void __iomem *addr
 	if (v_block_mapped((unsigned long)addr))
 		return;
 
-	if (addr > high_memory && (unsigned long)addr < ioremap_bot)
-		vunmap((void *)(PAGE_MASK & (unsigned long)addr));
+	generic_iounmap(addr);
 }
 EXPORT_SYMBOL(iounmap);
--- a/arch/powerpc/mm/ioremap_64.c~powerpc-mm-convert-to-generic_ioremap
+++ a/arch/powerpc/mm/ioremap_64.c
@@ -29,7 +29,7 @@ void __iomem *__ioremap_caller(phys_addr
 		return NULL;
 
 	if (slab_is_available())
-		return do_ioremap(paligned, offset, size, prot, caller);
+		return generic_ioremap_prot(addr, size, prot);
 
 	pr_warn("ioremap() called early from %pS. Use early_ioremap() instead\n", caller);
 
@@ -49,17 +49,9 @@ void __iomem *__ioremap_caller(phys_addr
  */
 void iounmap(volatile void __iomem *token)
 {
-	void *addr;
-
 	if (!slab_is_available())
 		return;
 
-	addr = (void *)((unsigned long __force)PCI_FIX_ADDR(token) & PAGE_MASK);
-
-	if ((unsigned long)addr < ioremap_bot) {
-		pr_warn("Attempt to iounmap early bolted mapping at 0x%p\n", addr);
-		return;
-	}
-	vunmap(addr);
+	generic_iounmap(PCI_FIX_ADDR(token));
 }
 EXPORT_SYMBOL(iounmap);
--- a/arch/powerpc/mm/ioremap.c~powerpc-mm-convert-to-generic_ioremap
+++ a/arch/powerpc/mm/ioremap.c
@@ -41,7 +41,7 @@ void __iomem *ioremap_coherent(phys_addr
 	return __ioremap_caller(addr, size, prot, caller);
 }
 
-void __iomem *ioremap_prot(phys_addr_t addr, unsigned long size, unsigned long flags)
+void __iomem *ioremap_prot(phys_addr_t addr, size_t size, unsigned long flags)
 {
 	pte_t pte = __pte(flags);
 	void *caller = __builtin_return_address(0);
@@ -74,27 +74,3 @@ int early_ioremap_range(unsigned long ea
 
 	return 0;
 }
-
-void __iomem *do_ioremap(phys_addr_t pa, phys_addr_t offset, unsigned long size,
-			 pgprot_t prot, void *caller)
-{
-	struct vm_struct *area;
-	int ret;
-	unsigned long va;
-
-	area = __get_vm_area_caller(size, VM_IOREMAP, IOREMAP_START, IOREMAP_END, caller);
-	if (area == NULL)
-		return NULL;
-
-	area->phys_addr = pa;
-	va = (unsigned long)area->addr;
-
-	ret = ioremap_page_range(va, va + size, pa, prot);
-	if (!ret)
-		return (void __iomem *)area->addr + offset;
-
-	vunmap_range(va, va + size);
-	free_vm_area(area);
-
-	return NULL;
-}
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-ioremap-define-generic_ioremap_prot-and-generic_iounmap.patch
mm-ioremap-consider-ioremap-space-in-generic-ioremap.patch
powerpc-mm-convert-to-generic_ioremap.patch

