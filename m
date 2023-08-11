Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83469C04FE0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237138AbjHKXEQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237027AbjHKXDI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDFA3AB8
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8B4A679F8
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6E6C433C8;
        Fri, 11 Aug 2023 23:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794882;
        bh=XddCbI5icTNh/3XJvXcGXVd9M+Y4UyzLnA1EyeRyktw=;
        h=Date:To:From:Subject:From;
        b=MepE6wHEGhDCks0m697M6pEkKHVWchTegIlG64wFIZHgYKNdXRidVjpdHLDOLTGNd
         qSWGfLmjAZiXuFEIS/YHayP83/D+rvzSOGrbCPofOV/IVKYJMMtlxqdLwfDHuVRb5/
         qv6KAu3FlvyEn5cle4sXEwORfh3zhn+TJE3UBT7A=
Date:   Fri, 11 Aug 2023 16:01:21 -0700
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
Subject: [merged mm-stable] mm-ioremap-allow-arch-to-have-its-own-ioremap-method-definition.patch removed from -mm tree
Message-Id: <20230811230122.1E6E6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: ioremap: allow ARCH to have its own ioremap method definition
has been removed from the -mm tree.  Its filename was
     mm-ioremap-allow-arch-to-have-its-own-ioremap-method-definition.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm: ioremap: allow ARCH to have its own ioremap method definition
Date: Thu, 6 Jul 2023 23:45:06 +0800

Architectures can be converted to GENERIC_IOREMAP, to take standard
ioremap_xxx() and iounmap() way.  But some ARCH-es could have specific
handling for ioremap_prot(), ioremap() and iounmap(), than standard
methods.

In oder to convert these ARCH-es to take GENERIC_IOREMAP method, allow
these architecutres to have their own ioremap_prot(), ioremap() and
iounmap() definitions.

Link: https://lkml.kernel.org/r/20230706154520.11257-6-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
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

 include/asm-generic/io.h |    3 +++
 mm/ioremap.c             |    4 ++++
 2 files changed, 7 insertions(+)

--- a/include/asm-generic/io.h~mm-ioremap-allow-arch-to-have-its-own-ioremap-method-definition
+++ a/include/asm-generic/io.h
@@ -1081,11 +1081,14 @@ void __iomem *ioremap_prot(phys_addr_t p
 void iounmap(volatile void __iomem *addr);
 void generic_iounmap(volatile void __iomem *addr);
 
+#ifndef ioremap
+#define ioremap ioremap
 static inline void __iomem *ioremap(phys_addr_t addr, size_t size)
 {
 	/* _PAGE_IOREMAP needs to be supplied by the architecture */
 	return ioremap_prot(addr, size, _PAGE_IOREMAP);
 }
+#endif
 #endif /* !CONFIG_MMU || CONFIG_GENERIC_IOREMAP */
 
 #ifndef ioremap_wc
--- a/mm/ioremap.c~mm-ioremap-allow-arch-to-have-its-own-ioremap-method-definition
+++ a/mm/ioremap.c
@@ -46,12 +46,14 @@ void __iomem *generic_ioremap_prot(phys_
 	return (void __iomem *)(vaddr + offset);
 }
 
+#ifndef ioremap_prot
 void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
 			   unsigned long prot)
 {
 	return generic_ioremap_prot(phys_addr, size, __pgprot(prot));
 }
 EXPORT_SYMBOL(ioremap_prot);
+#endif
 
 void generic_iounmap(volatile void __iomem *addr)
 {
@@ -64,8 +66,10 @@ void generic_iounmap(volatile void __iom
 		vunmap(vaddr);
 }
 
+#ifndef iounmap
 void iounmap(volatile void __iomem *addr)
 {
 	generic_iounmap(addr);
 }
 EXPORT_SYMBOL(iounmap);
+#endif
_

Patches currently in -mm which might be from bhe@redhat.com are

net-altera-tse-make-altera_tse-depend-on-has_iomem.patch
irqchip-al-fic-make-al_fic-depend-on-has_iomem.patch

