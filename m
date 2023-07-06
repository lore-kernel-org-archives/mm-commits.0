Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F15EB64D9
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 17:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjGFRDQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 13:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232181AbjGFRDO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 13:03:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852B71BE8
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 10:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2332C60F56
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 17:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3EDC433C7;
        Thu,  6 Jul 2023 17:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688662992;
        bh=UyADyegCJOuoWO8tT2bzlOxX3iCUhiWv1F3a6KlvoKo=;
        h=Date:To:From:Subject:From;
        b=V8GHT0q6Xs7T+uCSz1fWmPh9vBcuh36G9GNH8SKNXrIbfsiOZMGhREoK+YcPXc8kH
         XgYzTRkAI03dyQB1DtDAy5AC1qOb3GdOVMl+pkZWhQI25pWW1dAtFLBJZtT5uuBwn2
         CdWRJv4hF2nItcYMvZCIRo8QAPMZq+GTc2ZljLJA=
Date:   Thu, 06 Jul 2023 10:03:11 -0700
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
        dalias@libc.org, chris@zankel.net, catalin.marinas@arm.com,
        borntraeger@linux.ibm.com, bhe@redhat.com, bcain@quicinc.com,
        arnd@arndb.de, agordeev@linux.ibm.com, christophe.leroy@csgroup.eu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ioremap-define-generic_ioremap_prot-and-generic_iounmap.patch added to mm-unstable branch
Message-Id: <20230706170312.6F3EDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/ioremap: define generic_ioremap_prot() and generic_iounmap()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ioremap-define-generic_ioremap_prot-and-generic_iounmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ioremap-define-generic_ioremap_prot-and-generic_iounmap.patch

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
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: mm/ioremap: define generic_ioremap_prot() and generic_iounmap()
Date: Thu, 6 Jul 2023 23:45:05 +0800

Define a generic version of ioremap_prot() and iounmap() that
architectures can call after they have performed the necessary alteration
to parameters and/or necessary verifications.

Link: https://lkml.kernel.org/r/20230706154520.11257-5-bhe@redhat.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
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

 include/asm-generic/io.h |    4 ++++
 mm/ioremap.c             |   22 ++++++++++++++++------
 2 files changed, 20 insertions(+), 6 deletions(-)

--- a/include/asm-generic/io.h~mm-ioremap-define-generic_ioremap_prot-and-generic_iounmap
+++ a/include/asm-generic/io.h
@@ -1073,9 +1073,13 @@ static inline bool iounmap_allowed(void
 }
 #endif
 
+void __iomem *generic_ioremap_prot(phys_addr_t phys_addr, size_t size,
+				   pgprot_t prot);
+
 void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
 			   unsigned long prot);
 void iounmap(volatile void __iomem *addr);
+void generic_iounmap(volatile void __iomem *addr);
 
 static inline void __iomem *ioremap(phys_addr_t addr, size_t size)
 {
--- a/mm/ioremap.c~mm-ioremap-define-generic_ioremap_prot-and-generic_iounmap
+++ a/mm/ioremap.c
@@ -11,8 +11,8 @@
 #include <linux/io.h>
 #include <linux/export.h>
 
-void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
-			   unsigned long prot)
+void __iomem *generic_ioremap_prot(phys_addr_t phys_addr, size_t size,
+				   pgprot_t prot)
 {
 	unsigned long offset, vaddr;
 	phys_addr_t last_addr;
@@ -28,7 +28,7 @@ void __iomem *ioremap_prot(phys_addr_t p
 	phys_addr -= offset;
 	size = PAGE_ALIGN(size + offset);
 
-	if (!ioremap_allowed(phys_addr, size, prot))
+	if (!ioremap_allowed(phys_addr, size, pgprot_val(prot)))
 		return NULL;
 
 	area = get_vm_area_caller(size, VM_IOREMAP,
@@ -38,17 +38,22 @@ void __iomem *ioremap_prot(phys_addr_t p
 	vaddr = (unsigned long)area->addr;
 	area->phys_addr = phys_addr;
 
-	if (ioremap_page_range(vaddr, vaddr + size, phys_addr,
-			       __pgprot(prot))) {
+	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
 		free_vm_area(area);
 		return NULL;
 	}
 
 	return (void __iomem *)(vaddr + offset);
 }
+
+void __iomem *ioremap_prot(phys_addr_t phys_addr, size_t size,
+			   unsigned long prot)
+{
+	return generic_ioremap_prot(phys_addr, size, __pgprot(prot));
+}
 EXPORT_SYMBOL(ioremap_prot);
 
-void iounmap(volatile void __iomem *addr)
+void generic_iounmap(volatile void __iomem *addr)
 {
 	void *vaddr = (void *)((unsigned long)addr & PAGE_MASK);
 
@@ -58,4 +63,9 @@ void iounmap(volatile void __iomem *addr
 	if (is_vmalloc_addr(vaddr))
 		vunmap(vaddr);
 }
+
+void iounmap(volatile void __iomem *addr)
+{
+	generic_iounmap(addr);
+}
 EXPORT_SYMBOL(iounmap);
_

Patches currently in -mm which might be from christophe.leroy@csgroup.eu are

mm-ioremap-define-generic_ioremap_prot-and-generic_iounmap.patch
mm-ioremap-consider-ioremap-space-in-generic-ioremap.patch
powerpc-mm-convert-to-generic_ioremap.patch

