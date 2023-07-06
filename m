Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D29FEB64D9
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jul 2023 17:03:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjGFRDI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Jul 2023 13:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjGFRDF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2023 13:03:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90341737
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 10:03:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 447CA60DC1
        for <mm-commits@vger.kernel.org>; Thu,  6 Jul 2023 17:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81EE8C433C8;
        Thu,  6 Jul 2023 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688662982;
        bh=LOH3brIPU1yYwu36H6tuYIIbreXbHx35JOfV5gA3VUY=;
        h=Date:To:From:Subject:From;
        b=CFqzClyzE3IKbkr3VmFkqYoqMLxYn7hXHVG8g7TpnfCFUBYt1jzh9klesJjyevLa6
         qYuX2Cwtj1SLT5A/nV7B1acIWjNgFpz67erud8rHmdl8kJQSRWOd53332nZhhClALu
         EjFbRdVrDcqvifJisjTZOO7hIFyjftfqoCmyYaJg=
Date:   Thu, 06 Jul 2023 10:03:01 -0700
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
Subject: + asm-generic-iomaph-remove-arch_has_ioremap_xx-macros.patch added to mm-unstable branch
Message-Id: <20230706170302.81EE8C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: asm-generic/iomap.h: remove ARCH_HAS_IOREMAP_xx macros
has been added to the -mm mm-unstable branch.  Its filename is
     asm-generic-iomaph-remove-arch_has_ioremap_xx-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/asm-generic-iomaph-remove-arch_has_ioremap_xx-macros.patch

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
Subject: asm-generic/iomap.h: remove ARCH_HAS_IOREMAP_xx macros
Date: Thu, 6 Jul 2023 23:45:02 +0800

Patch series "mm: ioremap: Convert architectures to take GENERIC_IOREMAP
way", v8.

Motivation and implementation:
==============================
Currently, many architecutres have't taken the standard GENERIC_IOREMAP
way to implement ioremap_prot(), iounmap(), and ioremap_xx(), but make
these functions specifically under each arch's folder.  Those cause many
duplicated code of ioremap() and iounmap().

In this patchset, firstly introduce generic_ioremap_prot() and
generic_iounmap() to extract the generic code for GENERIC_IOREMAP.  By
taking GENERIC_IOREMAP method, the generic generic_ioremap_prot(),
generic_iounmap(), and their generic wrapper ioremap_prot(), ioremap() and
iounmap() are all visible and available to arch.  Arch needs to provide
wrapper functions to override the generic version if there's arch specific
handling in its corresponding ioremap_prot(), ioremap() or iounmap(). 
With these changes, duplicated ioremap/iounmap() code uder ARCH-es are
removed, and the equivalent functioality is kept as before.

Background info:
================

1) The converting more architectures to take GENERIC_IOREMAP way is
   suggested by Christoph in below discussion:
   https://lore.kernel.org/all/Yp7h0Jv6vpgt6xdZ@infradead.org/T/#u

2) In the previous v1 to v3, it's basically further action after arm64
   has converted to GENERIC_IOREMAP way in below patchset.  It's done by
   adding hook ioremap_allowed() and iounmap_allowed() in ARCH to add ARCH
   specific handling the middle of ioremap_prot() and iounmap().

[PATCH v5 0/6] arm64: Cleanup ioremap() and support ioremap_prot()
https://lore.kernel.org/all/20220607125027.44946-1-wangkefeng.wang@huawei.com/T/#u

Later, during v3 reviewing, Christophe Leroy suggested to introduce
generic_ioremap_prot() and generic_iounmap() to generic codes, and ARCH
can provide wrapper function ioremap_prot(), ioremap() or iounmap() if
needed.  Christophe made a RFC patchset as below to specially demonstrate
his idea.  This is what v4 and now v5 is doing.

[RFC PATCH 0/8] mm: ioremap: Convert architectures to take GENERIC_IOREMAP way
https://lore.kernel.org/all/cover.1665568707.git.christophe.leroy@csgroup.eu/T/#u

Testing:
========
In v8, I only applied this patchset onto the latest linus's tree to build
and run on arm64 and s390.


This patch (of 19):

Let's use '#define ioremap_xx' and "#ifdef ioremap_xx" instead.

To remove defined ARCH_HAS_IOREMAP_xx macros in <asm/io.h> of each ARCH,
the ARCH's own ioremap_wc|wt|np definition need be above "#include
<asm-generic/iomap.h>.  Otherwise the redefinition error would be seen
during compiling.  So the relevant adjustments are made to avoid compiling
error:

  loongarch:
  - doesn't include <asm-generic/iomap.h>, defining ARCH_HAS_IOREMAP_WC
    is redundant, so simply remove it.

  m68k:
  - selected GENERIC_IOMAP, <asm-generic/iomap.h> has been added in
    <asm-generic/io.h>, and <asm/kmap.h> is included above
    <asm-generic/iomap.h>, so simply remove ARCH_HAS_IOREMAP_WT defining.

  mips:
  - move "#include <asm-generic/iomap.h>" below ioremap_wc definition
    in <asm/io.h>

  powerpc:
  - remove "#include <asm-generic/iomap.h>" in <asm/io.h> because it's
    duplicated with the one in <asm-generic/io.h>, let's rely on the
    latter.

  x86:
  - selected GENERIC_IOMAP, remove #include <asm-generic/iomap.h> in
    the middle of <asm/io.h>. Let's rely on <asm-generic/io.h>.

Link: https://lkml.kernel.org/r/20230706154520.11257-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Helge Deller <deller@gmx.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Brian Cain <bcain@quicinc.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vineet Gupta <vgupta@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/include/asm/io.h     |    2 --
 arch/m68k/include/asm/io_mm.h       |    2 --
 arch/m68k/include/asm/kmap.h        |    2 --
 arch/mips/include/asm/io.h          |    5 ++---
 arch/powerpc/include/asm/io.h       |    9 +--------
 arch/x86/include/asm/io.h           |    5 -----
 drivers/net/ethernet/sfc/io.h       |    2 +-
 drivers/net/ethernet/sfc/siena/io.h |    2 +-
 include/asm-generic/iomap.h         |    6 +++---
 9 files changed, 8 insertions(+), 27 deletions(-)

--- a/arch/loongarch/include/asm/io.h~asm-generic-iomaph-remove-arch_has_ioremap_xx-macros
+++ a/arch/loongarch/include/asm/io.h
@@ -5,8 +5,6 @@
 #ifndef _ASM_IO_H
 #define _ASM_IO_H
 
-#define ARCH_HAS_IOREMAP_WC
-
 #include <linux/kernel.h>
 #include <linux/types.h>
 
--- a/arch/m68k/include/asm/io_mm.h~asm-generic-iomaph-remove-arch_has_ioremap_xx-macros
+++ a/arch/m68k/include/asm/io_mm.h
@@ -26,8 +26,6 @@
 #include <asm/virtconvert.h>
 #include <asm/kmap.h>
 
-#include <asm-generic/iomap.h>
-
 #ifdef CONFIG_ATARI
 #define atari_readb   raw_inb
 #define atari_writeb  raw_outb
--- a/arch/m68k/include/asm/kmap.h~asm-generic-iomaph-remove-arch_has_ioremap_xx-macros
+++ a/arch/m68k/include/asm/kmap.h
@@ -4,8 +4,6 @@
 
 #ifdef CONFIG_MMU
 
-#define ARCH_HAS_IOREMAP_WT
-
 /* Values for nocacheflag and cmode */
 #define IOMAP_FULL_CACHING		0
 #define IOMAP_NOCACHE_SER		1
--- a/arch/mips/include/asm/io.h~asm-generic-iomaph-remove-arch_has_ioremap_xx-macros
+++ a/arch/mips/include/asm/io.h
@@ -12,8 +12,6 @@
 #ifndef _ASM_IO_H
 #define _ASM_IO_H
 
-#define ARCH_HAS_IOREMAP_WC
-
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -25,7 +23,6 @@
 #include <asm/byteorder.h>
 #include <asm/cpu.h>
 #include <asm/cpu-features.h>
-#include <asm-generic/iomap.h>
 #include <asm/page.h>
 #include <asm/pgtable-bits.h>
 #include <asm/processor.h>
@@ -210,6 +207,8 @@ void iounmap(const volatile void __iomem
 #define ioremap_wc(offset, size)					\
 	ioremap_prot((offset), (size), boot_cpu_data.writecombine)
 
+#include <asm-generic/iomap.h>
+
 #if defined(CONFIG_CPU_CAVIUM_OCTEON)
 #define war_io_reorder_wmb()		wmb()
 #else
--- a/arch/powerpc/include/asm/io.h~asm-generic-iomaph-remove-arch_has_ioremap_xx-macros
+++ a/arch/powerpc/include/asm/io.h
@@ -3,11 +3,6 @@
 #define _ASM_POWERPC_IO_H
 #ifdef __KERNEL__
 
-#define ARCH_HAS_IOREMAP_WC
-#ifdef CONFIG_PPC32
-#define ARCH_HAS_IOREMAP_WT
-#endif
-
 /*
  */
 
@@ -732,9 +727,7 @@ static inline void name at					\
 #define writel_relaxed(v, addr)	writel(v, addr)
 #define writeq_relaxed(v, addr)	writeq(v, addr)
 
-#ifdef CONFIG_GENERIC_IOMAP
-#include <asm-generic/iomap.h>
-#else
+#ifndef CONFIG_GENERIC_IOMAP
 /*
  * Here comes the implementation of the IOMAP interfaces.
  */
--- a/arch/x86/include/asm/io.h~asm-generic-iomaph-remove-arch_has_ioremap_xx-macros
+++ a/arch/x86/include/asm/io.h
@@ -35,9 +35,6 @@
   *  - Arnaldo Carvalho de Melo <acme@conectiva.com.br>
   */
 
-#define ARCH_HAS_IOREMAP_WC
-#define ARCH_HAS_IOREMAP_WT
-
 #include <linux/string.h>
 #include <linux/compiler.h>
 #include <linux/cc_platform.h>
@@ -212,8 +209,6 @@ void memset_io(volatile void __iomem *,
 #define memcpy_toio memcpy_toio
 #define memset_io memset_io
 
-#include <asm-generic/iomap.h>
-
 /*
  * ISA space is 'always mapped' on a typical x86 system, no need to
  * explicitly ioremap() it. The fact that the ISA IO space is mapped
--- a/drivers/net/ethernet/sfc/io.h~asm-generic-iomaph-remove-arch_has_ioremap_xx-macros
+++ a/drivers/net/ethernet/sfc/io.h
@@ -70,7 +70,7 @@
  */
 #ifdef CONFIG_X86_64
 /* PIO is a win only if write-combining is possible */
-#ifdef ARCH_HAS_IOREMAP_WC
+#ifdef ioremap_wc
 #define EFX_USE_PIO 1
 #endif
 #endif
--- a/drivers/net/ethernet/sfc/siena/io.h~asm-generic-iomaph-remove-arch_has_ioremap_xx-macros
+++ a/drivers/net/ethernet/sfc/siena/io.h
@@ -70,7 +70,7 @@
  */
 #ifdef CONFIG_X86_64
 /* PIO is a win only if write-combining is possible */
-#ifdef ARCH_HAS_IOREMAP_WC
+#ifdef ioremap_wc
 #define EFX_USE_PIO 1
 #endif
 #endif
--- a/include/asm-generic/iomap.h~asm-generic-iomaph-remove-arch_has_ioremap_xx-macros
+++ a/include/asm-generic/iomap.h
@@ -93,15 +93,15 @@ extern void __iomem *ioport_map(unsigned
 extern void ioport_unmap(void __iomem *);
 #endif
 
-#ifndef ARCH_HAS_IOREMAP_WC
+#ifndef ioremap_wc
 #define ioremap_wc ioremap
 #endif
 
-#ifndef ARCH_HAS_IOREMAP_WT
+#ifndef ioremap_wt
 #define ioremap_wt ioremap
 #endif
 
-#ifndef ARCH_HAS_IOREMAP_NP
+#ifndef ioremap_np
 /* See the comment in asm-generic/io.h about ioremap_np(). */
 #define ioremap_np ioremap_np
 static inline void __iomem *ioremap_np(phys_addr_t offset, size_t size)
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

