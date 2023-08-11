Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12DE2C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:04:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbjHKXEw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbjHKXDY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2036C3590
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4C03676A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8B1C433C7;
        Fri, 11 Aug 2023 23:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794895;
        bh=WghWrGmo7qRHV1kSZXVCWxZxm8U1tVZV2tij8RD2HqU=;
        h=Date:To:From:Subject:From;
        b=w5OPg3kWAdQF9HPXqzvT06Rq/R/hiuQfxZhbDS5ZKyM3lTTrc6fXlV/sYWR+b7iCg
         YqOWTLkbQiyT4cA23NzuEry+32RAgsHrXOd6yR04/tr4GKo3pJTbqZiFhx0RV9y+n5
         Ye+RwhHp+V8tSPXj3nMXrw4Ht4OHbYnvUTj/vxTw=
Date:   Fri, 11 Aug 2023 16:01:34 -0700
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
Subject: [merged mm-stable] parisc-mm-convert-to-generic_ioremap.patch removed from -mm tree
Message-Id: <20230811230135.0E8B1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: parisc: mm: convert to GENERIC_IOREMAP
has been removed from the -mm tree.  Its filename was
     parisc-mm-convert-to-generic_ioremap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: parisc: mm: convert to GENERIC_IOREMAP
Date: Thu, 6 Jul 2023 23:45:15 +0800

By taking GENERIC_IOREMAP method, the generic generic_ioremap_prot(),
generic_iounmap(), and their generic wrapper ioremap_prot(), ioremap() and
iounmap() are all visible and available to arch.  Arch needs to provide
wrapper functions to override the generic versions if there's arch
specific handling in its ioremap_prot(), ioremap() or iounmap().  This
change will simplify implementation by removing duplicated code with
generic_ioremap_prot() and generic_iounmap(), and has the equivalent
functioality as before.

Here, add wrapper function ioremap_prot() for parisc's special operation
when iounmap().

Link: https://lkml.kernel.org/r/20230706154520.11257-15-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
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

 arch/parisc/Kconfig          |    1 
 arch/parisc/include/asm/io.h |   15 +++++--
 arch/parisc/mm/ioremap.c     |   62 ++-------------------------------
 3 files changed, 15 insertions(+), 63 deletions(-)

--- a/arch/parisc/include/asm/io.h~parisc-mm-convert-to-generic_ioremap
+++ a/arch/parisc/include/asm/io.h
@@ -125,12 +125,17 @@ static inline void gsc_writeq(unsigned l
 /*
  * The standard PCI ioremap interfaces
  */
-void __iomem *ioremap(unsigned long offset, unsigned long size);
-#define ioremap_wc			ioremap
-#define ioremap_uc			ioremap
-#define pci_iounmap			pci_iounmap
+#define ioremap_prot ioremap_prot
+
+#define _PAGE_IOREMAP (_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY | \
+		       _PAGE_ACCESSED | _PAGE_NO_CACHE)
 
-extern void iounmap(const volatile void __iomem *addr);
+#define ioremap_wc(addr, size)  \
+	ioremap_prot((addr), (size), _PAGE_IOREMAP)
+#define ioremap_uc(addr, size)  \
+	ioremap_prot((addr), (size), _PAGE_IOREMAP)
+
+#define pci_iounmap			pci_iounmap
 
 void memset_io(volatile void __iomem *addr, unsigned char val, int count);
 void memcpy_fromio(void *dst, const volatile void __iomem *src, int count);
--- a/arch/parisc/Kconfig~parisc-mm-convert-to-generic_ioremap
+++ a/arch/parisc/Kconfig
@@ -36,6 +36,7 @@ config PARISC
 	select GENERIC_ATOMIC64 if !64BIT
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PCI_IOMAP
+	select GENERIC_IOREMAP
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_ARCH_TOPOLOGY if SMP
--- a/arch/parisc/mm/ioremap.c~parisc-mm-convert-to-generic_ioremap
+++ a/arch/parisc/mm/ioremap.c
@@ -13,25 +13,9 @@
 #include <linux/io.h>
 #include <linux/mm.h>
 
-/*
- * Generic mapping function (not visible outside):
- */
-
-/*
- * Remap an arbitrary physical address space into the kernel virtual
- * address space.
- *
- * NOTE! We need to allow non-page-aligned mappings too: we will obviously
- * have to convert them into an offset in a page-aligned mapping, but the
- * caller shouldn't need to know that small detail.
- */
-void __iomem *ioremap(unsigned long phys_addr, unsigned long size)
+void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
+			   unsigned long prot)
 {
-	void __iomem *addr;
-	struct vm_struct *area;
-	unsigned long offset, last_addr;
-	pgprot_t pgprot;
-
 #ifdef CONFIG_EISA
 	unsigned long end = phys_addr + size - 1;
 	/* Support EISA addresses */
@@ -40,11 +24,6 @@ void __iomem *ioremap(unsigned long phys
 		phys_addr |= F_EXTEND(0xfc000000);
 #endif
 
-	/* Don't allow wraparound or zero size */
-	last_addr = phys_addr + size - 1;
-	if (!size || last_addr < phys_addr)
-		return NULL;
-
 	/*
 	 * Don't allow anybody to remap normal RAM that we're using..
 	 */
@@ -62,39 +41,6 @@ void __iomem *ioremap(unsigned long phys
 		}
 	}
 
-	pgprot = __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY |
-			  _PAGE_ACCESSED | _PAGE_NO_CACHE);
-
-	/*
-	 * Mappings have to be page-aligned
-	 */
-	offset = phys_addr & ~PAGE_MASK;
-	phys_addr &= PAGE_MASK;
-	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
-
-	/*
-	 * Ok, go for it..
-	 */
-	area = get_vm_area(size, VM_IOREMAP);
-	if (!area)
-		return NULL;
-
-	addr = (void __iomem *) area->addr;
-	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
-			       phys_addr, pgprot)) {
-		vunmap(addr);
-		return NULL;
-	}
-
-	return (void __iomem *) (offset + (char __iomem *)addr);
-}
-EXPORT_SYMBOL(ioremap);
-
-void iounmap(const volatile void __iomem *io_addr)
-{
-	unsigned long addr = (unsigned long)io_addr & PAGE_MASK;
-
-	if (is_vmalloc_addr((void *)addr))
-		vunmap((void *)addr);
+	return generic_ioremap_prot(phys_addr, size, __pgprot(prot));
 }
-EXPORT_SYMBOL(iounmap);
+EXPORT_SYMBOL(ioremap_prot);
_

Patches currently in -mm which might be from bhe@redhat.com are

net-altera-tse-make-altera_tse-depend-on-has_iomem.patch
irqchip-al-fic-make-al_fic-depend-on-has_iomem.patch

