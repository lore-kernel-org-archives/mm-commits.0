Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A54EB64D7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jun 2023 19:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbjFMT3F (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jun 2023 15:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjFMT26 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jun 2023 15:28:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6D3E6F
        for <mm-commits@vger.kernel.org>; Tue, 13 Jun 2023 12:28:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3067562EEC
        for <mm-commits@vger.kernel.org>; Tue, 13 Jun 2023 19:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82061C433F0;
        Tue, 13 Jun 2023 19:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686684535;
        bh=EcQ7/Rm9CE/ocxqBi+jlQyyqI8x2o8zmTzmeYGnw88Y=;
        h=Date:To:From:Subject:From;
        b=m+ZrSlmGflZi5T2jtuo9Z6XJBb2KfRdwTee6eWhQ/UUiW98iqE32qdgRCCy+ntafG
         5go1rS6G8nH+iyJ+GkEHem6d4B/0KXDKVist37SEVWfyGM/JoiA5MmKrFa2QAdnq30
         1e5TU37RjsjkyhOeXGEk+s1A9+TnzDD4P7QUxISw=
Date:   Tue, 13 Jun 2023 12:28:54 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        vbabka@suse.cz, npiggin@gmail.com, mpe@ellerman.id.au,
        monstr@monstr.eu, lkp@intel.com, glaubitz@physik.fu-berlin.de,
        dalias@libc.org, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sh-move-the-arch_dma_minalign-definition-to-asm-cacheh.patch added to mm-unstable branch
Message-Id: <20230613192855.82061C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sh: move the ARCH_DMA_MINALIGN definition to asm/cache.h
has been added to the -mm mm-unstable branch.  Its filename is
     sh-move-the-arch_dma_minalign-definition-to-asm-cacheh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sh-move-the-arch_dma_minalign-definition-to-asm-cacheh.patch

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
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: sh: move the ARCH_DMA_MINALIGN definition to asm/cache.h
Date: Tue, 13 Jun 2023 16:52:45 +0100

The sh architecture defines ARCH_DMA_MINALIGN in asm/page.h.  Move it to
asm/cache.h to allow a generic ARCH_DMA_MINALIGN definition in
linux/cache.h without redefine errors/warnings.

Link: https://lkml.kernel.org/r/20230613155245.1228274-4-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: kernel test robot <lkp@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/cache.h |    6 ++++++
 arch/sh/include/asm/page.h  |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/sh/include/asm/cache.h~sh-move-the-arch_dma_minalign-definition-to-asm-cacheh
+++ a/arch/sh/include/asm/cache.h
@@ -14,6 +14,12 @@
 
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
+/*
+ * Some drivers need to perform DMA into kmalloc'ed buffers
+ * and so we have to increase the kmalloc minalign for this.
+ */
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
+
 #define __read_mostly __section(".data..read_mostly")
 
 #ifndef __ASSEMBLY__
--- a/arch/sh/include/asm/page.h~sh-move-the-arch_dma_minalign-definition-to-asm-cacheh
+++ a/arch/sh/include/asm/page.h
@@ -174,10 +174,4 @@ typedef struct page *pgtable_t;
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
 
-/*
- * Some drivers need to perform DMA into kmalloc'ed buffers
- * and so we have to increase the kmalloc minalign for this.
- */
-#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
-
 #endif /* __ASM_SH_PAGE_H */
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

mm-slab-decouple-arch_kmalloc_minalign-from-arch_dma_minalign.patch
dma-allow-dma_get_cache_alignment-to-be-overridden-by-the-arch-code.patch
mm-slab-simplify-create_kmalloc_cache-args-and-make-it-static.patch
mm-slab-limit-kmalloc-minimum-alignment-to-dma_get_cache_alignment.patch
drivers-base-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign.patch
drivers-gpu-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign.patch
drivers-usb-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign.patch
drivers-spi-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign.patch
dm-crypt-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign.patch
iio-core-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign.patch
arm64-allow-kmalloc-caches-aligned-to-the-smaller-cache_line_size.patch
dma-mapping-force-bouncing-if-the-kmalloc-size-is-not-cache-line-aligned.patch
iommu-dma-force-bouncing-if-the-size-is-not-cacheline-aligned.patch
mm-slab-reduce-the-kmalloc-minimum-alignment-if-dma-bouncing-possible.patch
arm64-enable-arch_want_kmalloc_dma_bounce-for-arm64.patch
powerpc-move-the-arch_dma_minalign-definition-to-asm-cacheh.patch
microblaze-move-the-arch_dmaslab_minalign-definitions-to-asm-cacheh.patch
sh-move-the-arch_dma_minalign-definition-to-asm-cacheh.patch

