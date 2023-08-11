Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF142C05051
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234483AbjHKXER (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbjHKXDV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:03:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CB035B8
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FB8367942
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACB7AC433C8;
        Fri, 11 Aug 2023 23:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794887;
        bh=OFnZtgGlifOivgeuqWScimrv0Qot7rsiHOBsEbbCYQk=;
        h=Date:To:From:Subject:From;
        b=ocAuYXynXkkU12sMwlKErIDbUEUqOtsqplk5tpKAu2NnqyyvQUzELnmf5qO6ArA1c
         6WDWLWuKVHw+ThcFemM6sWaWPlH5tVSYtOr8KI/SyGtHAMurlnGAs9pOaDohVDEUHb
         EH+9owOUGDcLoUHGCRmDOmX0cHY/2dNGzA3XFThY=
Date:   Fri, 11 Aug 2023 16:01:27 -0700
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
Subject: [merged mm-stable] openrisc-mm-convert-to-generic_ioremap.patch removed from -mm tree
Message-Id: <20230811230127.ACB7AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: openrisc: mm: convert to GENERIC_IOREMAP
has been removed from the -mm tree.  Its filename was
     openrisc-mm-convert-to-generic_ioremap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: openrisc: mm: convert to GENERIC_IOREMAP
Date: Thu, 6 Jul 2023 23:45:10 +0800

By taking GENERIC_IOREMAP method, the generic generic_ioremap_prot(),
generic_iounmap(), and their generic wrapper ioremap_prot(), ioremap() and
iounmap() are all visible and available to arch.  Arch needs to provide
wrapper functions to override the generic versions if there's arch
specific handling in its ioremap_prot(), ioremap() or iounmap().  This
change will simplify implementation by removing duplicated code with
generic_ioremap_prot() and generic_iounmap(), and has the equivalent
functioality as before.

For openrisc, the current ioremap() and iounmap() are the same as generic
version.  After taking GENERIC_IOREMAP way, the old ioremap() and
iounmap() can be completely removed.

Link: https://lkml.kernel.org/r/20230706154520.11257-10-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
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
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/Kconfig          |    1 
 arch/openrisc/include/asm/io.h |   11 +++---
 arch/openrisc/mm/ioremap.c     |   49 -------------------------------
 3 files changed, 7 insertions(+), 54 deletions(-)

--- a/arch/openrisc/include/asm/io.h~openrisc-mm-convert-to-generic_ioremap
+++ a/arch/openrisc/include/asm/io.h
@@ -15,6 +15,8 @@
 #define __ASM_OPENRISC_IO_H
 
 #include <linux/types.h>
+#include <asm/pgalloc.h>
+#include <asm/pgtable.h>
 
 /*
  * PCI: We do not use IO ports in OpenRISC
@@ -27,11 +29,10 @@
 #define PIO_OFFSET		0
 #define PIO_MASK		0
 
-#define ioremap ioremap
-void __iomem *ioremap(phys_addr_t offset, unsigned long size);
-
-#define iounmap iounmap
-extern void iounmap(volatile void __iomem *addr);
+/*
+ * I/O memory mapping functions.
+ */
+#define _PAGE_IOREMAP (pgprot_val(PAGE_KERNEL) | _PAGE_CI)
 
 #include <asm-generic/io.h>
 
--- a/arch/openrisc/Kconfig~openrisc-mm-convert-to-generic_ioremap
+++ a/arch/openrisc/Kconfig
@@ -21,6 +21,7 @@ config OPENRISC
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
+	select GENERIC_IOREMAP
 	select GENERIC_CPU_DEVICES
 	select HAVE_PCI
 	select HAVE_UID16
--- a/arch/openrisc/mm/ioremap.c~openrisc-mm-convert-to-generic_ioremap
+++ a/arch/openrisc/mm/ioremap.c
@@ -22,55 +22,6 @@
 
 extern int mem_init_done;
 
-/*
- * Remap an arbitrary physical address space into the kernel virtual
- * address space. Needed when the kernel wants to access high addresses
- * directly.
- *
- * NOTE! We need to allow non-page-aligned mappings too: we will obviously
- * have to convert them into an offset in a page-aligned mapping, but the
- * caller shouldn't need to know that small detail.
- */
-void __iomem *__ref ioremap(phys_addr_t addr, unsigned long size)
-{
-	phys_addr_t p;
-	unsigned long v;
-	unsigned long offset, last_addr;
-	struct vm_struct *area = NULL;
-
-	/* Don't allow wraparound or zero size */
-	last_addr = addr + size - 1;
-	if (!size || last_addr < addr)
-		return NULL;
-
-	/*
-	 * Mappings have to be page-aligned
-	 */
-	offset = addr & ~PAGE_MASK;
-	p = addr & PAGE_MASK;
-	size = PAGE_ALIGN(last_addr + 1) - p;
-
-	area = get_vm_area(size, VM_IOREMAP);
-	if (!area)
-		return NULL;
-	v = (unsigned long)area->addr;
-
-	if (ioremap_page_range(v, v + size, p,
-			__pgprot(pgprot_val(PAGE_KERNEL) | _PAGE_CI))) {
-		vfree(area->addr);
-		return NULL;
-	}
-
-	return (void __iomem *)(offset + (char *)v);
-}
-EXPORT_SYMBOL(ioremap);
-
-void iounmap(volatile void __iomem *addr)
-{
-	return vfree((void *)(PAGE_MASK & (unsigned long)addr));
-}
-EXPORT_SYMBOL(iounmap);
-
 /**
  * OK, this one's a bit tricky... ioremap can get called before memory is
  * initialized (early serial console does this) and will want to alloc a page
_

Patches currently in -mm which might be from bhe@redhat.com are

net-altera-tse-make-altera_tse-depend-on-has_iomem.patch
irqchip-al-fic-make-al_fic-depend-on-has_iomem.patch

