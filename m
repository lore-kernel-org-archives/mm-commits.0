Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8AFEB64DD
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 17:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjGFRDQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 13:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbjGFRDN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 13:03:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDEE1BE3
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 10:03:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF33A60F52
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 17:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B68C433C7;
        Thu,  6 Jul 2023 17:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688662990;
        bh=Kp64/TOIMSp8NhMAYwnD9szH3RlO74onefnQCe6yS3g=;
        h=Date:To:From:Subject:From;
        b=KyjebGTKBG+dNIqM8BGxrc+WQxRjjdeaES9ejDQtp33K5xEplYu0QKoHAgSsvlzE4
         lsBcUhKNxipgXXwH07JxAEPtNJN098hqqK3Wj7b1rYN5jmC81uqFefwqDJucWoo8AU
         OKUkmL1UePhGw5qxCPpIX7QroVNGdrU5bGKiCyps=
Date:   Thu, 06 Jul 2023 10:03:09 -0700
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
Subject: + openrisc-mm-remove-unneeded-early-ioremap-code.patch added to mm-unstable branch
Message-Id: <20230706170310.27B68C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: openrisc: mm: remove unneeded early ioremap code
has been added to the -mm mm-unstable branch.  Its filename is
     openrisc-mm-remove-unneeded-early-ioremap-code.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/openrisc-mm-remove-unneeded-early-ioremap-code.patch

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
Subject: openrisc: mm: remove unneeded early ioremap code
Date: Thu, 6 Jul 2023 23:45:04 +0800

Under arch/openrisc, there isn't any place where ioremap() is called.  It
means that there isn't early ioremap handling needed in openrisc, So the
early ioremap handling code in ioremap() of arch/openrisc/mm/ioremap.c is
unnecessary and can be removed.

And also remove the special handling in iounmap() since no page is got
from fixmap pool along with early ioremap code removing in ioremap().

Link: https://lore.kernel.org/linux-mm/YwxfxKrTUtAuejKQ@oscomms1/
Link: https://lkml.kernel.org/r/20230706154520.11257-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Stafford Horne <shorne@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
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

 arch/openrisc/mm/ioremap.c |   43 ++++-------------------------------
 1 file changed, 5 insertions(+), 38 deletions(-)

--- a/arch/openrisc/mm/ioremap.c~openrisc-mm-remove-unneeded-early-ioremap-code
+++ a/arch/openrisc/mm/ioremap.c
@@ -22,8 +22,6 @@
 
 extern int mem_init_done;
 
-static unsigned int fixmaps_used __initdata;
-
 /*
  * Remap an arbitrary physical address space into the kernel virtual
  * address space. Needed when the kernel wants to access high addresses
@@ -52,24 +50,14 @@ void __iomem *__ref ioremap(phys_addr_t
 	p = addr & PAGE_MASK;
 	size = PAGE_ALIGN(last_addr + 1) - p;
 
-	if (likely(mem_init_done)) {
-		area = get_vm_area(size, VM_IOREMAP);
-		if (!area)
-			return NULL;
-		v = (unsigned long)area->addr;
-	} else {
-		if ((fixmaps_used + (size >> PAGE_SHIFT)) > FIX_N_IOREMAPS)
-			return NULL;
-		v = fix_to_virt(FIX_IOREMAP_BEGIN + fixmaps_used);
-		fixmaps_used += (size >> PAGE_SHIFT);
-	}
+	area = get_vm_area(size, VM_IOREMAP);
+	if (!area)
+		return NULL;
+	v = (unsigned long)area->addr;
 
 	if (ioremap_page_range(v, v + size, p,
 			__pgprot(pgprot_val(PAGE_KERNEL) | _PAGE_CI))) {
-		if (likely(mem_init_done))
-			vfree(area->addr);
-		else
-			fixmaps_used -= (size >> PAGE_SHIFT);
+		vfree(area->addr);
 		return NULL;
 	}
 
@@ -79,27 +67,6 @@ EXPORT_SYMBOL(ioremap);
 
 void iounmap(volatile void __iomem *addr)
 {
-	/* If the page is from the fixmap pool then we just clear out
-	 * the fixmap mapping.
-	 */
-	if (unlikely((unsigned long)addr > FIXADDR_START)) {
-		/* This is a bit broken... we don't really know
-		 * how big the area is so it's difficult to know
-		 * how many fixed pages to invalidate...
-		 * just flush tlb and hope for the best...
-		 * consider this a FIXME
-		 *
-		 * Really we should be clearing out one or more page
-		 * table entries for these virtual addresses so that
-		 * future references cause a page fault... for now, we
-		 * rely on two things:
-		 *   i)  this code never gets called on known boards
-		 *   ii) invalid accesses to the freed areas aren't made
-		 */
-		flush_tlb_all();
-		return;
-	}
-
 	return vfree((void *)(PAGE_MASK & (unsigned long)addr));
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
s390-mm-convert-to-generic_ioremap.patch
sh-add-asm-generic-ioh-including.patch
sh-mm-convert-to-generic_ioremap.patch
xtensa-mm-convert-to-generic_ioremap.patch
parisc-mm-convert-to-generic_ioremap.patch
mm-move-is_ioremap_addr-into-new-header-file.patch
arm64-mm-add-wrapper-function-ioremap_prot.patch
mm-ioremap-remove-unneeded-ioremap_allowed-and-iounmap_allowed.patch

