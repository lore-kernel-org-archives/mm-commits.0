Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C17EB64D9
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 17:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbjGFRDz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 13:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232351AbjGFRDi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 13:03:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289D41BF0
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 10:03:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB3E360F61
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 17:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BEDC433C7;
        Thu,  6 Jul 2023 17:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688663016;
        bh=EtrcPNY/e9SwDRCbUFq5BZlYCZuIaqtsPTpPk3v4I8Q=;
        h=Date:To:From:Subject:From;
        b=hX8oz2hdNCypzeHf/3uPUNc7gjDEfXUEKROqQymK9xkaS0wonMIRInI+U+9LyuGsL
         4uXAL5dzwGyE5VsaDH0JKE/HC1diNSVrwl3xmODMPmzC09ou8F2m/4bueGp7gYX/Jx
         8S/QFVBNHvihFEyR9Z6/RdxrT/A0vrJFT0uAvlLM=
Date:   Thu, 06 Jul 2023 10:03:35 -0700
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
Subject: + xtensa-mm-convert-to-generic_ioremap.patch added to mm-unstable branch
Message-Id: <20230706170336.12BEDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xtensa: mm: convert to GENERIC_IOREMAP
has been added to the -mm mm-unstable branch.  Its filename is
     xtensa-mm-convert-to-generic_ioremap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xtensa-mm-convert-to-generic_ioremap.patch

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
Subject: xtensa: mm: convert to GENERIC_IOREMAP
Date: Thu, 6 Jul 2023 23:45:14 +0800

By taking GENERIC_IOREMAP method, the generic generic_ioremap_prot(),
generic_iounmap(), and their generic wrapper ioremap_prot(), ioremap() and
iounmap() are all visible and available to arch.  Arch needs to provide
wrapper functions to override the generic versions if there's arch
specific handling in its ioremap_prot(), ioremap() or iounmap().  This
change will simplify implementation by removing duplicated code with
generic_ioremap_prot() and generic_iounmap(), and has the equivalent
functioality as before.

Here, add wrapper functions ioremap_prot(), ioremap() and iounmap() for
xtensa's special operation when ioremap() and iounmap().

Link: https://lkml.kernel.org/r/20230706154520.11257-14-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
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
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
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

 arch/xtensa/Kconfig          |    1 
 arch/xtensa/include/asm/io.h |   32 ++++++------------
 arch/xtensa/mm/ioremap.c     |   58 +++++++--------------------------
 3 files changed, 27 insertions(+), 64 deletions(-)

--- a/arch/xtensa/include/asm/io.h~xtensa-mm-convert-to-generic_ioremap
+++ a/arch/xtensa/include/asm/io.h
@@ -16,6 +16,7 @@
 #include <asm/vectors.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
+#include <linux/pgtable.h>
 
 #include <linux/types.h>
 
@@ -24,22 +25,24 @@
 #define PCI_IOBASE		((void __iomem *)XCHAL_KIO_BYPASS_VADDR)
 
 #ifdef CONFIG_MMU
-
-void __iomem *xtensa_ioremap_nocache(unsigned long addr, unsigned long size);
-void __iomem *xtensa_ioremap_cache(unsigned long addr, unsigned long size);
-void xtensa_iounmap(volatile void __iomem *addr);
-
 /*
- * Return the virtual address for the specified bus memory.
+ * I/O memory mapping functions.
  */
+void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
+			   unsigned long prot);
+#define ioremap_prot ioremap_prot
+#define iounmap iounmap
+
 static inline void __iomem *ioremap(unsigned long offset, unsigned long size)
 {
 	if (offset >= XCHAL_KIO_PADDR
 	    && offset - XCHAL_KIO_PADDR < XCHAL_KIO_SIZE)
 		return (void*)(offset-XCHAL_KIO_PADDR+XCHAL_KIO_BYPASS_VADDR);
 	else
-		return xtensa_ioremap_nocache(offset, size);
+		return ioremap_prot(offset, size,
+			pgprot_val(pgprot_noncached(PAGE_KERNEL)));
 }
+#define ioremap ioremap
 
 static inline void __iomem *ioremap_cache(unsigned long offset,
 		unsigned long size)
@@ -48,21 +51,10 @@ static inline void __iomem *ioremap_cach
 	    && offset - XCHAL_KIO_PADDR < XCHAL_KIO_SIZE)
 		return (void*)(offset-XCHAL_KIO_PADDR+XCHAL_KIO_CACHED_VADDR);
 	else
-		return xtensa_ioremap_cache(offset, size);
-}
-#define ioremap_cache ioremap_cache
+		return ioremap_prot(offset, size, pgprot_val(PAGE_KERNEL));
 
-static inline void iounmap(volatile void __iomem *addr)
-{
-	unsigned long va = (unsigned long) addr;
-
-	if (!(va >= XCHAL_KIO_CACHED_VADDR &&
-	      va - XCHAL_KIO_CACHED_VADDR < XCHAL_KIO_SIZE) &&
-	    !(va >= XCHAL_KIO_BYPASS_VADDR &&
-	      va - XCHAL_KIO_BYPASS_VADDR < XCHAL_KIO_SIZE))
-		xtensa_iounmap(addr);
 }
-
+#define ioremap_cache ioremap_cache
 #endif /* CONFIG_MMU */
 
 #include <asm-generic/io.h>
--- a/arch/xtensa/Kconfig~xtensa-mm-convert-to-generic_ioremap
+++ a/arch/xtensa/Kconfig
@@ -28,6 +28,7 @@ config XTENSA
 	select GENERIC_LIB_UCMPDI2
 	select GENERIC_PCI_IOMAP
 	select GENERIC_SCHED_CLOCK
+	select GENERIC_IOREMAP if MMU
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
 	select HAVE_ARCH_KASAN if MMU && !XIP_KERNEL
--- a/arch/xtensa/mm/ioremap.c~xtensa-mm-convert-to-generic_ioremap
+++ a/arch/xtensa/mm/ioremap.c
@@ -6,60 +6,30 @@
  */
 
 #include <linux/io.h>
-#include <linux/vmalloc.h>
 #include <linux/pgtable.h>
 #include <asm/cacheflush.h>
 #include <asm/io.h>
 
-static void __iomem *xtensa_ioremap(unsigned long paddr, unsigned long size,
-				    pgprot_t prot)
+void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
+			   unsigned long prot)
 {
-	unsigned long offset = paddr & ~PAGE_MASK;
-	unsigned long pfn = __phys_to_pfn(paddr);
-	struct vm_struct *area;
-	unsigned long vaddr;
-	int err;
-
-	paddr &= PAGE_MASK;
-
+	unsigned long pfn = __phys_to_pfn((phys_addr));
 	WARN_ON(pfn_valid(pfn));
 
-	size = PAGE_ALIGN(offset + size);
-
-	area = get_vm_area(size, VM_IOREMAP);
-	if (!area)
-		return NULL;
-
-	vaddr = (unsigned long)area->addr;
-	area->phys_addr = paddr;
-
-	err = ioremap_page_range(vaddr, vaddr + size, paddr, prot);
-
-	if (err) {
-		vunmap((void *)vaddr);
-		return NULL;
-	}
-
-	flush_cache_vmap(vaddr, vaddr + size);
-	return (void __iomem *)(offset + vaddr);
-}
-
-void __iomem *xtensa_ioremap_nocache(unsigned long addr, unsigned long size)
-{
-	return xtensa_ioremap(addr, size, pgprot_noncached(PAGE_KERNEL));
+	return generic_ioremap_prot(phys_addr, size, __pgprot(prot));
 }
-EXPORT_SYMBOL(xtensa_ioremap_nocache);
+EXPORT_SYMBOL(ioremap_prot);
 
-void __iomem *xtensa_ioremap_cache(unsigned long addr, unsigned long size)
+void iounmap(volatile void __iomem *addr)
 {
-	return xtensa_ioremap(addr, size, PAGE_KERNEL);
-}
-EXPORT_SYMBOL(xtensa_ioremap_cache);
+	unsigned long va = (unsigned long) addr;
 
-void xtensa_iounmap(volatile void __iomem *io_addr)
-{
-	void *addr = (void *)(PAGE_MASK & (unsigned long)io_addr);
+	if ((va >= XCHAL_KIO_CACHED_VADDR &&
+	      va - XCHAL_KIO_CACHED_VADDR < XCHAL_KIO_SIZE) ||
+	    (va >= XCHAL_KIO_BYPASS_VADDR &&
+	      va - XCHAL_KIO_BYPASS_VADDR < XCHAL_KIO_SIZE))
+		return;
 
-	vunmap(addr);
+	generic_iounmap(addr);
 }
-EXPORT_SYMBOL(xtensa_iounmap);
+EXPORT_SYMBOL(iounmap);
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

