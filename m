Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FA88EB64DA
	for <mm-commits@archiver.kernel.org>; Sun,  9 Jul 2023 00:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjGIAi7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Jul 2023 20:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjGIAi7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Jul 2023 20:38:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5657198
        for <mm-commits@vger.kernel.org>; Sat,  8 Jul 2023 17:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6173360B67
        for <mm-commits@vger.kernel.org>; Sun,  9 Jul 2023 00:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3598C433C7;
        Sun,  9 Jul 2023 00:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688863136;
        bh=SRSxCBrIIv/1eOZ1YoqpE2Qb64iaLx1JIAkUJW2gvUw=;
        h=Date:To:From:Subject:From;
        b=bKeDSmncek2vPulxp+OXs4MWK8JtHxsWBPJkDCSt5mX1MBdZso3Nsdnz3GGEmsn7k
         F8Y4uRJK2ig2IEvgzY7dnQUWYh0ylOl2HK75AAJ3Mi1B0BhovgzFdcWtVCpiNhRShn
         zUyQZ207tuqFd4kBfGebdCzi/fpKJ62L3NAlFhUg=
Date:   Sat, 08 Jul 2023 17:38:56 -0700
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
Subject: [obsolete] s390-mm-convert-to-generic_ioremap.patch removed from -mm tree
Message-Id: <20230709003856.A3598C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: s390: mm: convert to GENERIC_IOREMAP
has been removed from the -mm tree.  Its filename was
     s390-mm-convert-to-generic_ioremap.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: s390: mm: convert to GENERIC_IOREMAP
Date: Thu, 6 Jul 2023 23:45:11 +0800

By taking GENERIC_IOREMAP method, the generic generic_ioremap_prot(),
generic_iounmap(), and their generic wrapper ioremap_prot(), ioremap() and
iounmap() are all visible and available to arch.  Arch needs to provide
wrapper functions to override the generic versions if there's arch
specific handling in its ioremap_prot(), ioremap() or iounmap().  This
change will simplify implementation by removing duplicated code with
generic_ioremap_prot() and generic_iounmap(), and has the equivalent
functioality as before.

Here, add wrapper functions ioremap_prot() and iounmap() for s390's
special operation when ioremap() and iounmap().

And also replace including <asm-generic/io.h> with <asm/io.h> in
arch/s390/kernel/perf_cpum_sf.c, otherwise building error will be seen
because macro defined in <asm/io.h> can't be seen in perf_cpum_sf.c.

Link: https://lkml.kernel.org/r/20230706154520.11257-11-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Tested-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig               |    1 
 arch/s390/include/asm/io.h      |   21 ++++++-----
 arch/s390/kernel/perf_cpum_sf.c |    2 -
 arch/s390/pci/pci.c             |   57 +++++-------------------------
 4 files changed, 24 insertions(+), 57 deletions(-)

--- a/arch/s390/include/asm/io.h~s390-mm-convert-to-generic_ioremap
+++ a/arch/s390/include/asm/io.h
@@ -22,11 +22,18 @@ void unxlate_dev_mem_ptr(phys_addr_t phy
 
 #define IO_SPACE_LIMIT 0
 
-void __iomem *ioremap_prot(phys_addr_t addr, size_t size, unsigned long prot);
-void __iomem *ioremap(phys_addr_t addr, size_t size);
-void __iomem *ioremap_wc(phys_addr_t addr, size_t size);
-void __iomem *ioremap_wt(phys_addr_t addr, size_t size);
-void iounmap(volatile void __iomem *addr);
+/*
+ * I/O memory mapping functions.
+ */
+#define ioremap_prot ioremap_prot
+#define iounmap iounmap
+
+#define _PAGE_IOREMAP pgprot_val(PAGE_KERNEL)
+
+#define ioremap_wc(addr, size)  \
+	ioremap_prot((addr), (size), pgprot_val(pgprot_writecombine(PAGE_KERNEL)))
+#define ioremap_wt(addr, size)  \
+	ioremap_prot((addr), (size), pgprot_val(pgprot_writethrough(PAGE_KERNEL)))
 
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
@@ -51,10 +58,6 @@ static inline void ioport_unmap(void __i
 #define pci_iomap_wc pci_iomap_wc
 #define pci_iomap_wc_range pci_iomap_wc_range
 
-#define ioremap ioremap
-#define ioremap_wt ioremap_wt
-#define ioremap_wc ioremap_wc
-
 #define memcpy_fromio(dst, src, count)	zpci_memcpy_fromio(dst, src, count)
 #define memcpy_toio(dst, src, count)	zpci_memcpy_toio(dst, src, count)
 #define memset_io(dst, val, count)	zpci_memset_io(dst, val, count)
--- a/arch/s390/Kconfig~s390-mm-convert-to-generic_ioremap
+++ a/arch/s390/Kconfig
@@ -143,6 +143,7 @@ config S390
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_VDSO_TIME_NS
+	select GENERIC_IOREMAP if PCI
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_JUMP_LABEL
--- a/arch/s390/kernel/perf_cpum_sf.c~s390-mm-convert-to-generic_ioremap
+++ a/arch/s390/kernel/perf_cpum_sf.c
@@ -22,7 +22,7 @@
 #include <asm/irq.h>
 #include <asm/debug.h>
 #include <asm/timex.h>
-#include <asm-generic/io.h>
+#include <asm/io.h>
 
 /* Minimum number of sample-data-block-tables:
  * At least one table is required for the sampling buffer structure.
--- a/arch/s390/pci/pci.c~s390-mm-convert-to-generic_ioremap
+++ a/arch/s390/pci/pci.c
@@ -244,62 +244,25 @@ void __iowrite64_copy(void __iomem *to,
        zpci_memcpy_toio(to, from, count);
 }
 
-static void __iomem *__ioremap(phys_addr_t addr, size_t size, pgprot_t prot)
+void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
+			   unsigned long prot)
 {
-	unsigned long offset, vaddr;
-	struct vm_struct *area;
-	phys_addr_t last_addr;
-
-	last_addr = addr + size - 1;
-	if (!size || last_addr < addr)
-		return NULL;
-
+	/*
+	 * When PCI MIO instructions are unavailable the "physical" address
+	 * encodes a hint for accessing the PCI memory space it represents.
+	 * Just pass it unchanged such that ioread/iowrite can decode it.
+	 */
 	if (!static_branch_unlikely(&have_mio))
-		return (void __iomem *) addr;
-
-	offset = addr & ~PAGE_MASK;
-	addr &= PAGE_MASK;
-	size = PAGE_ALIGN(size + offset);
-	area = get_vm_area(size, VM_IOREMAP);
-	if (!area)
-		return NULL;
-
-	vaddr = (unsigned long) area->addr;
-	if (ioremap_page_range(vaddr, vaddr + size, addr, prot)) {
-		free_vm_area(area);
-		return NULL;
-	}
-	return (void __iomem *) ((unsigned long) area->addr + offset);
-}
+		return (void __iomem *)phys_addr;
 
-void __iomem *ioremap_prot(phys_addr_t addr, size_t size, unsigned long prot)
-{
-	return __ioremap(addr, size, __pgprot(prot));
+	return generic_ioremap_prot(phys_addr, size, __pgprot(prot));
 }
 EXPORT_SYMBOL(ioremap_prot);
 
-void __iomem *ioremap(phys_addr_t addr, size_t size)
-{
-	return __ioremap(addr, size, PAGE_KERNEL);
-}
-EXPORT_SYMBOL(ioremap);
-
-void __iomem *ioremap_wc(phys_addr_t addr, size_t size)
-{
-	return __ioremap(addr, size, pgprot_writecombine(PAGE_KERNEL));
-}
-EXPORT_SYMBOL(ioremap_wc);
-
-void __iomem *ioremap_wt(phys_addr_t addr, size_t size)
-{
-	return __ioremap(addr, size, pgprot_writethrough(PAGE_KERNEL));
-}
-EXPORT_SYMBOL(ioremap_wt);
-
 void iounmap(volatile void __iomem *addr)
 {
 	if (static_branch_likely(&have_mio))
-		vunmap((__force void *) ((unsigned long) addr & PAGE_MASK));
+		generic_iounmap(addr);
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
sh-add-asm-generic-ioh-including.patch
sh-mm-convert-to-generic_ioremap.patch
xtensa-mm-convert-to-generic_ioremap.patch
parisc-mm-convert-to-generic_ioremap.patch
mm-move-is_ioremap_addr-into-new-header-file.patch
arm64-mm-add-wrapper-function-ioremap_prot.patch
mm-ioremap-remove-unneeded-ioremap_allowed-and-iounmap_allowed.patch

