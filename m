Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2857C04E69
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234637AbjHKXES (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235310AbjHKXDW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1812359D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18B2667ADC
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65359C433C7;
        Fri, 11 Aug 2023 23:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794890;
        bh=7ZeQhXfq5Bfda6UL4Ej+1Ybg83nAVGf0XiEH/ZcfbXU=;
        h=Date:To:From:Subject:From;
        b=dANkNZYFxM40BodehYyCxBy/PpBofO+h1N/7owcaJ6ursTVdUcW8VmDHLovUgrkQC
         IFiJ6kA/vNfiyLMcdOg4bcV06iVVos+CkhBMwEfewhh/H+swkosDt0gSJAJ5HiDUwj
         BLD8mOs0K1RPnWmgJ5uWAYhSUf8HTURNW0+N0s7A=
Date:   Fri, 11 Aug 2023 16:01:29 -0700
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
Subject: [merged mm-stable] sh-add-asm-generic-ioh-including.patch removed from -mm tree
Message-Id: <20230811230130.65359C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sh: add <asm-generic/io.h> including
has been removed from the -mm tree.  Its filename was
     sh-add-asm-generic-ioh-including.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: sh: add <asm-generic/io.h> including
Date: Thu, 6 Jul 2023 23:45:12 +0800

In <asm-generic/io.h>, it provides a generic implementation of all
I/O accessors.

For some port|mm io functions, SuperH has its own implementation in
arch/sh/kernel/iomap.c and arch/sh/include/asm/io_noioport.h.  These will
conflict with those in <asm-generic/io.h> and cause compiling error. 
Hence add macro definitions to ensure that the SuperH version of them will
override the generic version.

[arnd@arndb.de: fix asm-generic/io.h inclusion]
  Link: https://lkml.kernel.org/r/20230802141658.2064864-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20230706154520.11257-12-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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

 arch/sh/include/asm/io.h          |   49 ++++++++++++++++++++++++++++
 arch/sh/include/asm/io_noioport.h |    7 ----
 2 files changed, 49 insertions(+), 7 deletions(-)

--- a/arch/sh/include/asm/io.h~sh-add-asm-generic-ioh-including
+++ a/arch/sh/include/asm/io.h
@@ -119,6 +119,30 @@ void __raw_readsl(const void __iomem *ad
 
 __BUILD_MEMORY_STRING(__raw_, q, u64)
 
+#define ioport_map ioport_map
+#define ioport_unmap ioport_unmap
+#define pci_iounmap pci_iounmap
+
+#define ioread8 ioread8
+#define ioread16 ioread16
+#define ioread16be ioread16be
+#define ioread32 ioread32
+#define ioread32be ioread32be
+
+#define iowrite8 iowrite8
+#define iowrite16 iowrite16
+#define iowrite16be iowrite16be
+#define iowrite32 iowrite32
+#define iowrite32be iowrite32be
+
+#define ioread8_rep ioread8_rep
+#define ioread16_rep ioread16_rep
+#define ioread32_rep ioread32_rep
+
+#define iowrite8_rep iowrite8_rep
+#define iowrite16_rep iowrite16_rep
+#define iowrite32_rep iowrite32_rep
+
 #ifdef CONFIG_HAS_IOPORT_MAP
 
 /*
@@ -221,10 +245,33 @@ __BUILD_IOPORT_STRING(q, u64)
 
 #endif
 
+#define inb(addr)      inb(addr)
+#define inw(addr)      inw(addr)
+#define inl(addr)      inl(addr)
+#define outb(x, addr)  outb((x), (addr))
+#define outw(x, addr)  outw((x), (addr))
+#define outl(x, addr)  outl((x), (addr))
+
+#define inb_p(addr)    inb(addr)
+#define inw_p(addr)    inw(addr)
+#define inl_p(addr)    inl(addr)
+#define outb_p(x, addr)        outb((x), (addr))
+#define outw_p(x, addr)        outw((x), (addr))
+#define outl_p(x, addr)        outl((x), (addr))
+
+#define insb insb
+#define insw insw
+#define insl insl
+#define outsb outsb
+#define outsw outsw
+#define outsl outsl
 
 #define IO_SPACE_LIMIT 0xffffffff
 
 /* We really want to try and get these to memcpy etc */
+#define memset_io memset_io
+#define memcpy_fromio memcpy_fromio
+#define memcpy_toio memcpy_toio
 void memcpy_fromio(void *, const volatile void __iomem *, unsigned long);
 void memcpy_toio(volatile void __iomem *, const void *, unsigned long);
 void memset_io(volatile void __iomem *, int, unsigned long);
@@ -288,6 +335,8 @@ static inline void iounmap(volatile void
 #define xlate_dev_mem_ptr(p)	__va(p)
 #define unxlate_dev_mem_ptr(p, v) do { } while (0)
 
+#include <asm-generic/io.h>
+
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
 int valid_phys_addr_range(phys_addr_t addr, size_t size);
 int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
--- a/arch/sh/include/asm/io_noioport.h~sh-add-asm-generic-ioh-including
+++ a/arch/sh/include/asm/io_noioport.h
@@ -46,13 +46,6 @@ static inline void ioport_unmap(void __i
 	BUG();
 }
 
-#define inb_p(addr)	inb(addr)
-#define inw_p(addr)	inw(addr)
-#define inl_p(addr)	inl(addr)
-#define outb_p(x, addr)	outb((x), (addr))
-#define outw_p(x, addr)	outw((x), (addr))
-#define outl_p(x, addr)	outl((x), (addr))
-
 static inline void insb(unsigned long port, void *dst, unsigned long count)
 {
 	BUG();
_

Patches currently in -mm which might be from bhe@redhat.com are

net-altera-tse-make-altera_tse-depend-on-has_iomem.patch
irqchip-al-fic-make-al_fic-depend-on-has_iomem.patch

