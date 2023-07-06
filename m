Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B1EEB64DD
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 17:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjGFRD5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 13:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbjGFRDr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 13:03:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D008E1BEC
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 10:03:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DD5F60F40
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 17:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DCBC433C8;
        Thu,  6 Jul 2023 17:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688663023;
        bh=T8RTCCwclU+E7W3C15kJpFnt1dPmQbdUXoDRrEqWxG4=;
        h=Date:To:From:Subject:From;
        b=diCK84H4KGfiX7yoOn12iib8RYwxdRvN4CXwwqAFNaS7pnOBWsdjl/tKpJXRBVrcc
         zo8ak4xRoUlpG+Vvwkhr8M2Va44AhY6F8hjpjtHQA0+zO9pBUJP7ftfhFb+NLCj1u2
         04b/wR/215DkQeabj1S7kGBFsmxYklUSzWySMoxI=
Date:   Thu, 06 Jul 2023 10:03:43 -0700
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
Subject: + mm-move-is_ioremap_addr-into-new-header-file.patch added to mm-unstable branch
Message-Id: <20230706170343.89DCBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move is_ioremap_addr() into new header file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-is_ioremap_addr-into-new-header-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-is_ioremap_addr-into-new-header-file.patch

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
Subject: mm: move is_ioremap_addr() into new header file
Date: Thu, 6 Jul 2023 23:45:17 +0800

Now is_ioremap_addr() is only used in kernel/iomem.c and gonna be used in
mm/ioremap.c.  Move it into its own new header file linux/ioremap.h.

Link: https://lkml.kernel.org/r/20230706154520.11257-17-bhe@redhat.com
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

 arch/powerpc/include/asm/pgtable.h |   10 ---------
 include/linux/ioremap.h            |   30 +++++++++++++++++++++++++++
 include/linux/mm.h                 |    5 ----
 kernel/iomem.c                     |    1 
 mm/ioremap.c                       |   10 ---------
 5 files changed, 32 insertions(+), 24 deletions(-)

--- a/arch/powerpc/include/asm/pgtable.h~mm-move-is_ioremap_addr-into-new-header-file
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -157,16 +157,6 @@ static inline pgtable_t pmd_pgtable(pmd_
 	return (pgtable_t)pmd_page_vaddr(pmd);
 }
 
-#ifdef CONFIG_PPC64
-#define is_ioremap_addr is_ioremap_addr
-static inline bool is_ioremap_addr(const void *x)
-{
-	unsigned long addr = (unsigned long)x;
-
-	return addr >= IOREMAP_BASE && addr < IOREMAP_END;
-}
-#endif /* CONFIG_PPC64 */
-
 #endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_POWERPC_PGTABLE_H */
--- /dev/null
+++ a/include/linux/ioremap.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_IOREMAP_H
+#define _LINUX_IOREMAP_H
+
+#include <linux/kasan.h>
+#include <asm/pgtable.h>
+
+#if defined(CONFIG_HAS_IOMEM) || defined(CONFIG_GENERIC_IOREMAP)
+/*
+ * Ioremap often, but not always uses the generic vmalloc area. E.g on
+ * Power ARCH, it could have different ioremap space.
+ */
+#ifndef IOREMAP_START
+#define IOREMAP_START   VMALLOC_START
+#define IOREMAP_END     VMALLOC_END
+#endif
+static inline bool is_ioremap_addr(const void *x)
+{
+	unsigned long addr = (unsigned long)kasan_reset_tag(x);
+
+	return addr >= IOREMAP_START && addr < IOREMAP_END;
+}
+#else
+static inline bool is_ioremap_addr(const void *x)
+{
+	return false;
+}
+#endif
+
+#endif /* _LINUX_IOREMAP_H */
--- a/include/linux/mm.h~mm-move-is_ioremap_addr-into-new-header-file
+++ a/include/linux/mm.h
@@ -1090,11 +1090,6 @@ unsigned long vmalloc_to_pfn(const void
  * On nommu, vmalloc/vfree wrap through kmalloc/kfree directly, so there
  * is no special casing required.
  */
-
-#ifndef is_ioremap_addr
-#define is_ioremap_addr(x) is_vmalloc_addr(x)
-#endif
-
 #ifdef CONFIG_MMU
 extern bool is_vmalloc_addr(const void *x);
 extern int is_vmalloc_or_module_addr(const void *x);
--- a/kernel/iomem.c~mm-move-is_ioremap_addr-into-new-header-file
+++ a/kernel/iomem.c
@@ -3,6 +3,7 @@
 #include <linux/types.h>
 #include <linux/io.h>
 #include <linux/mm.h>
+#include <linux/ioremap.h>
 
 #ifndef ioremap_cache
 /* temporary while we convert existing ioremap_cache users to memremap */
--- a/mm/ioremap.c~mm-move-is_ioremap_addr-into-new-header-file
+++ a/mm/ioremap.c
@@ -10,15 +10,7 @@
 #include <linux/mm.h>
 #include <linux/io.h>
 #include <linux/export.h>
-
-/*
- * Ioremap often, but not always uses the generic vmalloc area. E.g on
- * Power ARCH, it could have different ioremap space.
- */
-#ifndef IOREMAP_START
-#define IOREMAP_START   VMALLOC_START
-#define IOREMAP_END     VMALLOC_END
-#endif
+#include <linux/ioremap.h>
 
 void __iomem *generic_ioremap_prot(phys_addr_t phys_addr, size_t size,
 				   pgprot_t prot)
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

