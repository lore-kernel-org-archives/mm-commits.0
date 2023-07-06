Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470B2EB64DC
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 17:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjGFRDP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 13:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGFRDJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 13:03:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E26A1737
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 10:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B211260F56
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 17:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BAEC433C7;
        Thu,  6 Jul 2023 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688662987;
        bh=EguVRAw2956+xlvzoF/ohEQaWwAjJ/JOBL755G0FcRM=;
        h=Date:To:From:Subject:From;
        b=iBLcD+6EGHnypK45PgLrWZ9UlZh8lsUtOuvNNonzY2M82AbUyvzQs4MbK3OHZCUfl
         vUnCRDs7L9O++ac4kS/VEGe8eL48w68c/CBs309Bv9RbWQYlaPoyTej7ks0lsvlBFc
         573g12TOmBtHtDQlmz7haQXRYE0dMxZv2fE96RZA=
Date:   Thu, 06 Jul 2023 10:03:06 -0700
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
Subject: + hexagon-mm-convert-to-generic_ioremap.patch added to mm-unstable branch
Message-Id: <20230706170307.01BAEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hexagon: mm: convert to GENERIC_IOREMAP
has been added to the -mm mm-unstable branch.  Its filename is
     hexagon-mm-convert-to-generic_ioremap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hexagon-mm-convert-to-generic_ioremap.patch

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
Subject: hexagon: mm: convert to GENERIC_IOREMAP
Date: Thu, 6 Jul 2023 23:45:03 +0800

By taking GENERIC_IOREMAP method, the generic ioremap_prot() and iounmap()
are visible and available to arch.  This change will simplify
implementation by removing duplicated code with generic ioremap_prot() and
iounmap(), and has the equivalent functioality.

For hexagon, the current ioremap() and iounmap() are the same as generic
version.  After taking GENERIC_IOREMAP way, the old ioremap() and
iounmap() can be completely removed.

Link: https://lkml.kernel.org/r/20230706154520.11257-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
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
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
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

 arch/hexagon/Kconfig                |    1 
 arch/hexagon/include/asm/io.h       |   11 ++++--
 arch/hexagon/kernel/hexagon_ksyms.c |    2 -
 arch/hexagon/mm/Makefile            |    2 -
 arch/hexagon/mm/ioremap.c           |   44 --------------------------
 5 files changed, 9 insertions(+), 51 deletions(-)

--- a/arch/hexagon/include/asm/io.h~hexagon-mm-convert-to-generic_ioremap
+++ a/arch/hexagon/include/asm/io.h
@@ -27,8 +27,6 @@
 extern int remap_area_pages(unsigned long start, unsigned long phys_addr,
 				unsigned long end, unsigned long flags);
 
-extern void iounmap(const volatile void __iomem *addr);
-
 /* Defined in lib/io.c, needed for smc91x driver. */
 extern void __raw_readsw(const void __iomem *addr, void *data, int wordlen);
 extern void __raw_writesw(void __iomem *addr, const void *data, int wordlen);
@@ -170,8 +168,13 @@ static inline void writel(u32 data, vola
 #define writew_relaxed __raw_writew
 #define writel_relaxed __raw_writel
 
-void __iomem *ioremap(unsigned long phys_addr, unsigned long size);
-#define ioremap_uc(X, Y) ioremap((X), (Y))
+/*
+ * I/O memory mapping functions.
+ */
+#define _PAGE_IOREMAP (_PAGE_PRESENT | _PAGE_READ | _PAGE_WRITE | \
+		       (__HEXAGON_C_DEV << 6))
+
+#define ioremap_uc(addr, size) ioremap((addr), (size))
 
 
 #define __raw_writel writel
--- a/arch/hexagon/Kconfig~hexagon-mm-convert-to-generic_ioremap
+++ a/arch/hexagon/Kconfig
@@ -25,6 +25,7 @@ config HEXAGON
 	select NEED_SG_DMA_LENGTH
 	select NO_IOPORT_MAP
 	select GENERIC_IOMAP
+	select GENERIC_IOREMAP
 	select GENERIC_SMP_IDLE_THREAD
 	select STACKTRACE_SUPPORT
 	select GENERIC_CLOCKEVENTS_BROADCAST
--- a/arch/hexagon/kernel/hexagon_ksyms.c~hexagon-mm-convert-to-generic_ioremap
+++ a/arch/hexagon/kernel/hexagon_ksyms.c
@@ -14,12 +14,10 @@
 EXPORT_SYMBOL(__clear_user_hexagon);
 EXPORT_SYMBOL(raw_copy_from_user);
 EXPORT_SYMBOL(raw_copy_to_user);
-EXPORT_SYMBOL(iounmap);
 EXPORT_SYMBOL(__vmgetie);
 EXPORT_SYMBOL(__vmsetie);
 EXPORT_SYMBOL(__vmyield);
 EXPORT_SYMBOL(empty_zero_page);
-EXPORT_SYMBOL(ioremap);
 EXPORT_SYMBOL(memcpy);
 EXPORT_SYMBOL(memset);
 
--- a/arch/hexagon/mm/ioremap.c
+++ /dev/null
@@ -1,44 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * I/O remap functions for Hexagon
- *
- * Copyright (c) 2010-2011, The Linux Foundation. All rights reserved.
- */
-
-#include <linux/io.h>
-#include <linux/vmalloc.h>
-#include <linux/mm.h>
-
-void __iomem *ioremap(unsigned long phys_addr, unsigned long size)
-{
-	unsigned long last_addr, addr;
-	unsigned long offset = phys_addr & ~PAGE_MASK;
-	struct vm_struct *area;
-
-	pgprot_t prot = __pgprot(_PAGE_PRESENT|_PAGE_READ|_PAGE_WRITE
-					|(__HEXAGON_C_DEV << 6));
-
-	last_addr = phys_addr + size - 1;
-
-	/*  Wrapping not allowed  */
-	if (!size || (last_addr < phys_addr))
-		return NULL;
-
-	/*  Rounds up to next page size, including whole-page offset */
-	size = PAGE_ALIGN(offset + size);
-
-	area = get_vm_area(size, VM_IOREMAP);
-	addr = (unsigned long)area->addr;
-
-	if (ioremap_page_range(addr, addr+size, phys_addr, prot)) {
-		vunmap((void *)addr);
-		return NULL;
-	}
-
-	return (void __iomem *) (offset + addr);
-}
-
-void iounmap(const volatile void __iomem *addr)
-{
-	vunmap((void *) ((unsigned long) addr & PAGE_MASK));
-}
--- a/arch/hexagon/mm/Makefile~hexagon-mm-convert-to-generic_ioremap
+++ a/arch/hexagon/mm/Makefile
@@ -3,5 +3,5 @@
 # Makefile for Hexagon memory management subsystem
 #
 
-obj-y := init.o ioremap.o uaccess.o vm_fault.o cache.o
+obj-y := init.o uaccess.o vm_fault.o cache.o
 obj-y += copy_to_user.o copy_from_user.o vm_tlb.o
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

