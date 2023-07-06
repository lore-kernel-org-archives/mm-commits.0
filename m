Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B1A4EB64D9
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 17:03:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbjGFRDn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 13:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbjGFRDi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 13:03:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0DC1BE9
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 10:03:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0031560F75
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 17:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D74AC433C7;
        Thu,  6 Jul 2023 17:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688663013;
        bh=PgnK8kHWAq0KcDPiB8o8+W76aWkj/RNbmPEKM3a0EkA=;
        h=Date:To:From:Subject:From;
        b=vXGvwpX9bZ7705P50VZcvnRB8qv2+n9UlNv0WYOucS2g5fnxZpAJR9Y0TIjvdgkcC
         SRBefFSNhxz6JovuQZd4GHWCW//WfmU1uOSWukgjNH8hkbC2yYIteLdRVNXMSCVva2
         MuAKfDp8Ej0WnrbFty/rtvEtxsQIvCyDntL6turQ=
Date:   Thu, 06 Jul 2023 10:03:32 -0700
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
        dalias@libc.org, chris@zankel.net, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, borntraeger@linux.ibm.com,
        bcain@quicinc.com, arnd@arndb.de, agordeev@linux.ibm.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-mm-convert-to-generic_ioremap.patch added to mm-unstable branch
Message-Id: <20230706170333.4D74AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: mm: convert to GENERIC_IOREMAP
has been added to the -mm mm-unstable branch.  Its filename is
     sh-mm-convert-to-generic_ioremap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-mm-convert-to-generic_ioremap.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: sh: mm: convert to GENERIC_IOREMAP
Date: Thu, 6 Jul 2023 23:45:13 +0800

By taking GENERIC_IOREMAP method, the generic generic_ioremap_prot(),
generic_iounmap(), and their generic wrapper ioremap_prot(), ioremap() and
iounmap() are all visible and available to arch.  Arch needs to provide
wrapper functions to override the generic versions if there's arch
specific handling in its ioremap_prot(), ioremap() or iounmap().  This
change will simplify implementation by removing duplicated code with
generic_ioremap_prot() and generic_iounmap(), and has the equivalent
functioality as before.

Here, add wrapper functions ioremap_prot() and iounmap() for SuperH's
special operation when ioremap() and iounmap().

Link: https://lkml.kernel.org/r/20230706154520.11257-13-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/Kconfig          |    1 
 arch/sh/include/asm/io.h |   40 ++++------------------
 arch/sh/mm/ioremap.c     |   65 ++++++-------------------------------
 3 files changed, 20 insertions(+), 86 deletions(-)

--- a/arch/sh/include/asm/io.h~sh-mm-convert-to-generic_ioremap
+++ a/arch/sh/include/asm/io.h
@@ -266,40 +266,16 @@ unsigned long long poke_real_address_q(u
 #endif
 
 #ifdef CONFIG_MMU
-void iounmap(void __iomem *addr);
-void __iomem *__ioremap_caller(phys_addr_t offset, unsigned long size,
-			       pgprot_t prot, void *caller);
+/*
+ * I/O memory mapping functions.
+ */
+#define ioremap_prot ioremap_prot
+#define iounmap iounmap
 
-static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
-{
-	return __ioremap_caller(offset, size, PAGE_KERNEL_NOCACHE,
-			__builtin_return_address(0));
-}
+#define _PAGE_IOREMAP pgprot_val(PAGE_KERNEL_NOCACHE)
 
-static inline void __iomem *
-ioremap_cache(phys_addr_t offset, unsigned long size)
-{
-	return __ioremap_caller(offset, size, PAGE_KERNEL,
-			__builtin_return_address(0));
-}
-#define ioremap_cache ioremap_cache
-
-#ifdef CONFIG_HAVE_IOREMAP_PROT
-static inline void __iomem *ioremap_prot(phys_addr_t offset, unsigned long size,
-		unsigned long flags)
-{
-	return __ioremap_caller(offset, size, __pgprot(flags),
-			__builtin_return_address(0));
-}
-#endif /* CONFIG_HAVE_IOREMAP_PROT */
-
-#else /* CONFIG_MMU */
-static inline void __iomem *ioremap(phys_addr_t offset, size_t size)
-{
-	return (void __iomem *)(unsigned long)offset;
-}
-
-static inline void iounmap(volatile void __iomem *addr) { }
+#define ioremap_cache(addr, size)  \
+	ioremap_prot((addr), (size), pgprot_val(PAGE_KERNEL))
 #endif /* CONFIG_MMU */
 
 #define ioremap_uc	ioremap
--- a/arch/sh/Kconfig~sh-mm-convert-to-generic_ioremap
+++ a/arch/sh/Kconfig
@@ -29,6 +29,7 @@ config SUPERH
 	select GENERIC_SMP_IDLE_THREAD
 	select GUP_GET_PXX_LOW_HIGH if X2TLB
 	select HAS_IOPORT if HAS_IOPORT_MAP
+	select GENERIC_IOREMAP if MMU
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_SECCOMP_FILTER
--- a/arch/sh/mm/ioremap.c~sh-mm-convert-to-generic_ioremap
+++ a/arch/sh/mm/ioremap.c
@@ -72,22 +72,11 @@ __ioremap_29bit(phys_addr_t offset, unsi
 #define __ioremap_29bit(offset, size, prot)		NULL
 #endif /* CONFIG_29BIT */
 
-/*
- * Remap an arbitrary physical address space into the kernel virtual
- * address space. Needed when the kernel wants to access high addresses
- * directly.
- *
- * NOTE! We need to allow non-page-aligned mappings too: we will obviously
- * have to convert them into an offset in a page-aligned mapping, but the
- * caller shouldn't need to know that small detail.
- */
-void __iomem * __ref
-__ioremap_caller(phys_addr_t phys_addr, unsigned long size,
-		 pgprot_t pgprot, void *caller)
+void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
+			   unsigned long prot)
 {
-	struct vm_struct *area;
-	unsigned long offset, last_addr, addr, orig_addr;
 	void __iomem *mapped;
+	pgprot_t pgprot = __pgprot(prot);
 
 	mapped = __ioremap_trapped(phys_addr, size);
 	if (mapped)
@@ -97,11 +86,6 @@ __ioremap_caller(phys_addr_t phys_addr,
 	if (mapped)
 		return mapped;
 
-	/* Don't allow wraparound or zero size */
-	last_addr = phys_addr + size - 1;
-	if (!size || last_addr < phys_addr)
-		return NULL;
-
 	/*
 	 * If we can't yet use the regular approach, go the fixmap route.
 	 */
@@ -112,34 +96,14 @@ __ioremap_caller(phys_addr_t phys_addr,
 	 * First try to remap through the PMB.
 	 * PMB entries are all pre-faulted.
 	 */
-	mapped = pmb_remap_caller(phys_addr, size, pgprot, caller);
+	mapped = pmb_remap_caller(phys_addr, size, pgprot,
+			__builtin_return_address(0));
 	if (mapped && !IS_ERR(mapped))
 		return mapped;
 
-	/*
-	 * Mappings have to be page-aligned
-	 */
-	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
-	size = PAGE_ALIGN(last_addr+1) - phys_addr;
-
-	/*
-	 * Ok, go for it..
-	 */
-	area = get_vm_area_caller(size, VM_IOREMAP, caller);
-	if (!area)
-		return NULL;
-	area->phys_addr = phys_addr;
-	orig_addr = addr = (unsigned long)area->addr;
-
-	if (ioremap_page_range(addr, addr + size, phys_addr, pgprot)) {
-		vunmap((void *)orig_addr);
-		return NULL;
-	}
-
-	return (void __iomem *)(offset + (char *)orig_addr);
+	return generic_ioremap_prot(phys_addr, size, pgprot);
 }
-EXPORT_SYMBOL(__ioremap_caller);
+EXPORT_SYMBOL(ioremap_prot);
 
 /*
  * Simple checks for non-translatable mappings.
@@ -158,10 +122,9 @@ static inline int iomapping_nontranslata
 	return 0;
 }
 
-void iounmap(void __iomem *addr)
+void iounmap(volatile void __iomem *addr)
 {
 	unsigned long vaddr = (unsigned long __force)addr;
-	struct vm_struct *p;
 
 	/*
 	 * Nothing to do if there is no translatable mapping.
@@ -172,21 +135,15 @@ void iounmap(void __iomem *addr)
 	/*
 	 * There's no VMA if it's from an early fixed mapping.
 	 */
-	if (iounmap_fixed(addr) == 0)
+	if (iounmap_fixed((void __iomem *)addr) == 0)
 		return;
 
 	/*
 	 * If the PMB handled it, there's nothing else to do.
 	 */
-	if (pmb_unmap(addr) == 0)
-		return;
-
-	p = remove_vm_area((void *)(vaddr & PAGE_MASK));
-	if (!p) {
-		printk(KERN_ERR "%s: bad address %p\n", __func__, addr);
+	if (pmb_unmap((void __iomem *)addr) == 0)
 		return;
-	}
 
-	kfree(p);
+	generic_iounmap(addr);
 }
 EXPORT_SYMBOL(iounmap);
_

Patches currently in -mm which might be from bhe@redhat.com are

asm-generic-iomaph-remove-arch_has_ioremap_xx-macros.patch
hexagon-mm-convert-to-generic_ioremap.patch
openrisc-mm-remove-unneeded-early-ioremap-code.patch
mm-ioremap-allow-arch-to-have-its-own-ioremap-method-definition.patch
mm-ioremap-add-slab-availability-checking-in-ioremap_prot.patch
arc-mm-convert-to-generic_ioremap.patch
ia64-mm-convert-to-generic_ioremap.patch
openrisc-mm-convert-to-generic_ioremap.patch
s390-mm-convert-to-generic_ioremap.patch
sh-add-asm-generic-ioh-including.patch
sh-mm-convert-to-generic_ioremap.patch
xtensa-mm-convert-to-generic_ioremap.patch
parisc-mm-convert-to-generic_ioremap.patch
mm-move-is_ioremap_addr-into-new-header-file.patch
arm64-mm-add-wrapper-function-ioremap_prot.patch
mm-ioremap-remove-unneeded-ioremap_allowed-and-iounmap_allowed.patch

