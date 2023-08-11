Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08506C04FE1
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjHKXEQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237030AbjHKXDM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076F14237
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92F7B676A6
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0947C433C7;
        Fri, 11 Aug 2023 23:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794885;
        bh=bXaw0B99ZoQRy4svwsk5X0F1Y6g0idED6Lmpk5TczGI=;
        h=Date:To:From:Subject:From;
        b=IQ/rSGl7oTcj/IDKxF2maKSQcm17P7vQUPHl2Mp0MzCOoSnf2U1oFHObCljn/ZkgC
         c+NH4BQx8foS7x2NQkS7hRLRqIZIuLKCOxFfZH8hI1KaMZIRg56OYBRyplBfTeBNe8
         Fe2G+T7SIKLGUSENxSAwxJUQ1I2yJRMjqrGG1Tr0=
Date:   Fri, 11 Aug 2023 16:01:24 -0700
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
Subject: [merged mm-stable] arc-mm-convert-to-generic_ioremap.patch removed from -mm tree
Message-Id: <20230811230124.E0947C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arc: mm: convert to GENERIC_IOREMAP
has been removed from the -mm tree.  Its filename was
     arc-mm-convert-to-generic_ioremap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: arc: mm: convert to GENERIC_IOREMAP
Date: Thu, 6 Jul 2023 23:45:08 +0800

By taking GENERIC_IOREMAP method, the generic generic_ioremap_prot(),
generic_iounmap(), and their generic wrapper ioremap_prot(), ioremap() and
iounmap() are all visible and available to arch.  Arch needs to provide
wrapper functions to override the generic versions if there's arch
specific handling in its ioremap_prot(), ioremap() or iounmap().  This
change will simplify implementation by removing duplicated code with
generic_ioremap_prot() and generic_iounmap(), and has the equivalent
functioality as before.

Here, add wrapper functions ioremap_prot() and iounmap() for arc's special
operation when ioremap_prot() and iounmap().

Link: https://lkml.kernel.org/r/20230706154520.11257-8-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Vineet Gupta <vgupta@kernel.org>
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
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/Kconfig          |    1 
 arch/arc/include/asm/io.h |    7 ++---
 arch/arc/mm/ioremap.c     |   49 ++----------------------------------
 3 files changed, 8 insertions(+), 49 deletions(-)

--- a/arch/arc/include/asm/io.h~arc-mm-convert-to-generic_ioremap
+++ a/arch/arc/include/asm/io.h
@@ -21,8 +21,9 @@
 #endif
 
 extern void __iomem *ioremap(phys_addr_t paddr, unsigned long size);
-extern void __iomem *ioremap_prot(phys_addr_t paddr, unsigned long size,
-				  unsigned long flags);
+#define ioremap ioremap
+#define ioremap_prot ioremap_prot
+#define iounmap iounmap
 static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
 {
 	return (void __iomem *)port;
@@ -32,8 +33,6 @@ static inline void ioport_unmap(void __i
 {
 }
 
-extern void iounmap(const volatile void __iomem *addr);
-
 /*
  * io{read,write}{16,32}be() macros
  */
--- a/arch/arc/Kconfig~arc-mm-convert-to-generic_ioremap
+++ a/arch/arc/Kconfig
@@ -26,6 +26,7 @@ config ARC
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_SCHED_CLOCK
 	select GENERIC_SMP_IDLE_THREAD
+	select GENERIC_IOREMAP
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE if ARC_MMU_V4
--- a/arch/arc/mm/ioremap.c~arc-mm-convert-to-generic_ioremap
+++ a/arch/arc/mm/ioremap.c
@@ -8,7 +8,6 @@
 #include <linux/module.h>
 #include <linux/io.h>
 #include <linux/mm.h>
-#include <linux/slab.h>
 #include <linux/cache.h>
 
 static inline bool arc_uncached_addr_space(phys_addr_t paddr)
@@ -25,13 +24,6 @@ static inline bool arc_uncached_addr_spa
 
 void __iomem *ioremap(phys_addr_t paddr, unsigned long size)
 {
-	phys_addr_t end;
-
-	/* Don't allow wraparound or zero size */
-	end = paddr + size - 1;
-	if (!size || (end < paddr))
-		return NULL;
-
 	/*
 	 * If the region is h/w uncached, MMU mapping can be elided as optim
 	 * The cast to u32 is fine as this region can only be inside 4GB
@@ -51,55 +43,22 @@ EXPORT_SYMBOL(ioremap);
  * ARC hardware uncached region, this one still goes thru the MMU as caller
  * might need finer access control (R/W/X)
  */
-void __iomem *ioremap_prot(phys_addr_t paddr, unsigned long size,
+void __iomem *ioremap_prot(phys_addr_t paddr, size_t size,
 			   unsigned long flags)
 {
-	unsigned int off;
-	unsigned long vaddr;
-	struct vm_struct *area;
-	phys_addr_t end;
 	pgprot_t prot = __pgprot(flags);
 
-	/* Don't allow wraparound, zero size */
-	end = paddr + size - 1;
-	if ((!size) || (end < paddr))
-		return NULL;
-
-	/* An early platform driver might end up here */
-	if (!slab_is_available())
-		return NULL;
-
 	/* force uncached */
-	prot = pgprot_noncached(prot);
-
-	/* Mappings have to be page-aligned */
-	off = paddr & ~PAGE_MASK;
-	paddr &= PAGE_MASK_PHYS;
-	size = PAGE_ALIGN(end + 1) - paddr;
-
-	/*
-	 * Ok, go for it..
-	 */
-	area = get_vm_area(size, VM_IOREMAP);
-	if (!area)
-		return NULL;
-	area->phys_addr = paddr;
-	vaddr = (unsigned long)area->addr;
-	if (ioremap_page_range(vaddr, vaddr + size, paddr, prot)) {
-		vunmap((void __force *)vaddr);
-		return NULL;
-	}
-	return (void __iomem *)(off + (char __iomem *)vaddr);
+	return generic_ioremap_prot(paddr, size, pgprot_noncached(prot));
 }
 EXPORT_SYMBOL(ioremap_prot);
 
-
-void iounmap(const volatile void __iomem *addr)
+void iounmap(volatile void __iomem *addr)
 {
 	/* weird double cast to handle phys_addr_t > 32 bits */
 	if (arc_uncached_addr_space((phys_addr_t)(u32)addr))
 		return;
 
-	vfree((void *)(PAGE_MASK & (unsigned long __force)addr));
+	generic_iounmap(addr);
 }
 EXPORT_SYMBOL(iounmap);
_

Patches currently in -mm which might be from bhe@redhat.com are

net-altera-tse-make-altera_tse-depend-on-has_iomem.patch
irqchip-al-fic-make-al_fic-depend-on-has_iomem.patch

