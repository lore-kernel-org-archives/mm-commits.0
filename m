Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDEEC04FE2
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjHKXER (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234483AbjHKXDV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517014239
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5BEF67AB8
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B72C433C8;
        Fri, 11 Aug 2023 23:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794886;
        bh=allsJV79qTc0FBN33vHBZl8Hhvcsvx9ehNP53SdqUfo=;
        h=Date:To:From:Subject:From;
        b=oED8/XPW8xcpmCjba0QT7g5sdgMdBsCFZMe5z2lihuLXIutMk44EoALUasXEI/4Uh
         lYvCLGwu0z2vtGDQJtIigvrp0FVfnhtLkGRgwqeA2eTnUCjO4/TS1hnAolQOl6QpWG
         Q92wout6gMPA+AjHPDWobTV6bcM5XheL1UJ5oUbo=
Date:   Fri, 11 Aug 2023 16:01:25 -0700
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
Subject: [merged mm-stable] ia64-mm-convert-to-generic_ioremap.patch removed from -mm tree
Message-Id: <20230811230126.40B72C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ia64: mm: convert to GENERIC_IOREMAP
has been removed from the -mm tree.  Its filename was
     ia64-mm-convert-to-generic_ioremap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: ia64: mm: convert to GENERIC_IOREMAP
Date: Thu, 6 Jul 2023 23:45:09 +0800

By taking GENERIC_IOREMAP method, the generic generic_ioremap_prot(),
generic_iounmap(), and their generic wrapper ioremap_prot(), ioremap() and
iounmap() are all visible and available to arch.  Arch needs to provide
wrapper functions to override the generic versions if there's arch
specific handling in its ioremap_prot(), ioremap() or iounmap().  This
change will simplify implementation by removing duplicated code with
generic_ioremap_prot() and generic_iounmap(), and has the equivalent
functioality as before.

Here, add wrapper functions ioremap_prot() and iounmap() for ia64's
special operation when ioremap() and iounmap().

Link: https://lkml.kernel.org/r/20230706154520.11257-9-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
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
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig          |    1 
 arch/ia64/include/asm/io.h |   13 ++++-------
 arch/ia64/mm/ioremap.c     |   41 +++++------------------------------
 3 files changed, 12 insertions(+), 43 deletions(-)

--- a/arch/ia64/include/asm/io.h~ia64-mm-convert-to-generic_ioremap
+++ a/arch/ia64/include/asm/io.h
@@ -243,15 +243,12 @@ static inline void outsl(unsigned long p
 
 # ifdef __KERNEL__
 
-extern void __iomem * ioremap(unsigned long offset, unsigned long size);
+#define _PAGE_IOREMAP pgprot_val(PAGE_KERNEL)
+
 extern void __iomem * ioremap_uc(unsigned long offset, unsigned long size);
-extern void iounmap (volatile void __iomem *addr);
-static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
-{
-	return ioremap(phys_addr, size);
-}
-#define ioremap ioremap
-#define ioremap_cache ioremap_cache
+
+#define ioremap_prot ioremap_prot
+#define ioremap_cache ioremap
 #define ioremap_uc ioremap_uc
 #define iounmap iounmap
 
--- a/arch/ia64/Kconfig~ia64-mm-convert-to-generic_ioremap
+++ a/arch/ia64/Kconfig
@@ -47,6 +47,7 @@ config IA64
 	select GENERIC_IRQ_LEGACY
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
+	select GENERIC_IOREMAP
 	select GENERIC_SMP_IDLE_THREAD
 	select ARCH_TASK_STRUCT_ON_STACK
 	select ARCH_TASK_STRUCT_ALLOCATOR
--- a/arch/ia64/mm/ioremap.c~ia64-mm-convert-to-generic_ioremap
+++ a/arch/ia64/mm/ioremap.c
@@ -29,13 +29,9 @@ early_ioremap (unsigned long phys_addr,
 	return __ioremap_uc(phys_addr);
 }
 
-void __iomem *
-ioremap (unsigned long phys_addr, unsigned long size)
+void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
+			   unsigned long flags)
 {
-	void __iomem *addr;
-	struct vm_struct *area;
-	unsigned long offset;
-	pgprot_t prot;
 	u64 attr;
 	unsigned long gran_base, gran_size;
 	unsigned long page_base;
@@ -68,36 +64,12 @@ ioremap (unsigned long phys_addr, unsign
 	 */
 	page_base = phys_addr & PAGE_MASK;
 	size = PAGE_ALIGN(phys_addr + size) - page_base;
-	if (efi_mem_attribute(page_base, size) & EFI_MEMORY_WB) {
-		prot = PAGE_KERNEL;
-
-		/*
-		 * Mappings have to be page-aligned
-		 */
-		offset = phys_addr & ~PAGE_MASK;
-		phys_addr &= PAGE_MASK;
-
-		/*
-		 * Ok, go for it..
-		 */
-		area = get_vm_area(size, VM_IOREMAP);
-		if (!area)
-			return NULL;
-
-		area->phys_addr = phys_addr;
-		addr = (void __iomem *) area->addr;
-		if (ioremap_page_range((unsigned long) addr,
-				(unsigned long) addr + size, phys_addr, prot)) {
-			vunmap((void __force *) addr);
-			return NULL;
-		}
-
-		return (void __iomem *) (offset + (char __iomem *)addr);
-	}
+	if (efi_mem_attribute(page_base, size) & EFI_MEMORY_WB)
+		return generic_ioremap_prot(phys_addr, size, __pgprot(flags));
 
 	return __ioremap_uc(phys_addr);
 }
-EXPORT_SYMBOL(ioremap);
+EXPORT_SYMBOL(ioremap_prot);
 
 void __iomem *
 ioremap_uc(unsigned long phys_addr, unsigned long size)
@@ -114,8 +86,7 @@ early_iounmap (volatile void __iomem *ad
 {
 }
 
-void
-iounmap (volatile void __iomem *addr)
+void iounmap(volatile void __iomem *addr)
 {
 	if (REGION_NUMBER(addr) == RGN_GATE)
 		vunmap((void *) ((unsigned long) addr & PAGE_MASK));
_

Patches currently in -mm which might be from bhe@redhat.com are

net-altera-tse-make-altera_tse-depend-on-has_iomem.patch
irqchip-al-fic-make-al_fic-depend-on-has_iomem.patch

