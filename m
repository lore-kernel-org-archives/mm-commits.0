Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03E7EB64DD
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 17:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjGFREN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 13:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbjGFRDz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 13:03:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18241FC2
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 10:03:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4422F60FE5
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 17:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB5EC433C7;
        Thu,  6 Jul 2023 17:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688663032;
        bh=Adw74cLgDSfMU3w+lz0PF6tAShLlN3bXMrvnLoA7DvU=;
        h=Date:To:From:Subject:From;
        b=wGXVUH8j4kQKsB0Eas7a4nCS4XjbSHOrfKuYfe4Mq6eoCZvl02D/fiL8Jq2vSLMxd
         5DGU2m51QY3eLmDYzO9Z5zj42Mp9H1SVTYTtY/ZuCqjCyvyJoB+5NLNWzk3+I/4M1E
         5O9tjmWH2FWb/UnImtYdL+lczxOdSwX/OWqxuJJI=
Date:   Thu, 06 Jul 2023 10:03:52 -0700
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
Subject: + mm-ioremap-remove-unneeded-ioremap_allowed-and-iounmap_allowed.patch added to mm-unstable branch
Message-Id: <20230706170352.8EB5EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: ioremap: remove unneeded ioremap_allowed and iounmap_allowed
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ioremap-remove-unneeded-ioremap_allowed-and-iounmap_allowed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ioremap-remove-unneeded-ioremap_allowed-and-iounmap_allowed.patch

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
Subject: mm: ioremap: remove unneeded ioremap_allowed and iounmap_allowed
Date: Thu, 6 Jul 2023 23:45:20 +0800

Now there are no users of ioremap_allowed and iounmap_allowed, clean
them up.

Link: https://lkml.kernel.org/r/20230706154520.11257-20-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
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

 include/asm-generic/io.h |   26 --------------------------
 mm/ioremap.c             |    6 ------
 2 files changed, 32 deletions(-)

--- a/include/asm-generic/io.h~mm-ioremap-remove-unneeded-ioremap_allowed-and-iounmap_allowed
+++ a/include/asm-generic/io.h
@@ -1047,32 +1047,6 @@ static inline void iounmap(volatile void
 #elif defined(CONFIG_GENERIC_IOREMAP)
 #include <linux/pgtable.h>
 
-/*
- * Arch code can implement the following two hooks when using GENERIC_IOREMAP
- * ioremap_allowed() return a bool,
- *   - true means continue to remap
- *   - false means skip remap and return directly
- * iounmap_allowed() return a bool,
- *   - true means continue to vunmap
- *   - false means skip vunmap and return directly
- */
-#ifndef ioremap_allowed
-#define ioremap_allowed ioremap_allowed
-static inline bool ioremap_allowed(phys_addr_t phys_addr, size_t size,
-				   unsigned long prot)
-{
-	return true;
-}
-#endif
-
-#ifndef iounmap_allowed
-#define iounmap_allowed iounmap_allowed
-static inline bool iounmap_allowed(void *addr)
-{
-	return true;
-}
-#endif
-
 void __iomem *generic_ioremap_prot(phys_addr_t phys_addr, size_t size,
 				   pgprot_t prot);
 
--- a/mm/ioremap.c~mm-ioremap-remove-unneeded-ioremap_allowed-and-iounmap_allowed
+++ a/mm/ioremap.c
@@ -33,9 +33,6 @@ void __iomem *generic_ioremap_prot(phys_
 	phys_addr -= offset;
 	size = PAGE_ALIGN(size + offset);
 
-	if (!ioremap_allowed(phys_addr, size, pgprot_val(prot)))
-		return NULL;
-
 	area = __get_vm_area_caller(size, VM_IOREMAP, IOREMAP_START,
 				    IOREMAP_END, __builtin_return_address(0));
 	if (!area)
@@ -64,9 +61,6 @@ void generic_iounmap(volatile void __iom
 {
 	void *vaddr = (void *)((unsigned long)addr & PAGE_MASK);
 
-	if (!iounmap_allowed(vaddr))
-		return;
-
 	if (is_ioremap_addr(vaddr))
 		vunmap(vaddr);
 }
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

