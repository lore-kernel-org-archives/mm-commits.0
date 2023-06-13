Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FD9EB64D7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jun 2023 19:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjFMT2z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jun 2023 15:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjFMT2y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jun 2023 15:28:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CB119F
        for <mm-commits@vger.kernel.org>; Tue, 13 Jun 2023 12:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 88A0F62F54
        for <mm-commits@vger.kernel.org>; Tue, 13 Jun 2023 19:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3231C433D9;
        Tue, 13 Jun 2023 19:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686684531;
        bh=Au6KxVM0xHevopHunxw9OQJb4303yng2XGj7NLMZ84c=;
        h=Date:To:From:Subject:From;
        b=eKad4+vtiiH+lJgpZESiBS+UX4DjEjq5F3MdDCa2fEQ12xl5nEc/plFidk0hVNT1N
         1KjQXCYQ9fkhW99Lf/TaihcSMmaZqC2ZRabGmooaS2Prr2n2baqM75OVvPYo5b3lKp
         bzli2h8XLVfQm/zc5s83ikMHQoUVBqedey7jxcSE=
Date:   Tue, 13 Jun 2023 12:28:50 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        vbabka@suse.cz, npiggin@gmail.com, mpe@ellerman.id.au,
        monstr@monstr.eu, lkp@intel.com, glaubitz@physik.fu-berlin.de,
        dalias@libc.org, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-move-the-arch_dma_minalign-definition-to-asm-cacheh.patch added to mm-unstable branch
Message-Id: <20230613192850.E3231C433D9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: move the ARCH_DMA_MINALIGN definition to asm/cache.h
has been added to the -mm mm-unstable branch.  Its filename is
     powerpc-move-the-arch_dma_minalign-definition-to-asm-cacheh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-move-the-arch_dma_minalign-definition-to-asm-cacheh.patch

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
Subject: powerpc: move the ARCH_DMA_MINALIGN definition to asm/cache.h
Date: Tue, 13 Jun 2023 16:52:43 +0100

Patch series "Move the ARCH_DMA_MINALIGN definition to asm/cache.h".

The ARCH_KMALLOC_MINALIGN reduction series defines a generic
ARCH_DMA_MINALIGN in linux/cache.h:

https://lore.kernel.org/r/20230612153201.554742-2-catalin.marinas@arm.com/

Unfortunately, this causes a duplicate definition warning for
microblaze, powerpc (32-bit only) and sh as these architectures define
ARCH_DMA_MINALIGN in a different file than asm/cache.h. Move the macro
to asm/cache.h to avoid this issue and also bring them in line with the
other architectures.


This patch (of 3):

The powerpc architecture defines ARCH_DMA_MINALIGN in asm/page_32.h and
only if CONFIG_NOT_COHERENT_CACHE is enabled (32-bit platforms only). 
Move this macro to asm/cache.h to allow a generic ARCH_DMA_MINALIGN
definition in linux/cache.h without redefine errors/warnings.

Link: https://lkml.kernel.org/r/20230613155245.1228274-1-catalin.marinas@arm.com
Link: https://lkml.kernel.org/r/20230613155245.1228274-2-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306131053.1ybvRRhO-lkp@intel.com/
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Rich Felker <dalias@libc.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/cache.h   |    4 ++++
 arch/powerpc/include/asm/page_32.h |    4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/powerpc/include/asm/cache.h~powerpc-move-the-arch_dma_minalign-definition-to-asm-cacheh
+++ a/arch/powerpc/include/asm/cache.h
@@ -33,6 +33,10 @@
 
 #define IFETCH_ALIGN_BYTES	(1 << IFETCH_ALIGN_SHIFT)
 
+#ifdef CONFIG_NOT_COHERENT_CACHE
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
+#endif
+
 #if !defined(__ASSEMBLY__)
 #ifdef CONFIG_PPC64
 
--- a/arch/powerpc/include/asm/page_32.h~powerpc-move-the-arch_dma_minalign-definition-to-asm-cacheh
+++ a/arch/powerpc/include/asm/page_32.h
@@ -12,10 +12,6 @@
 
 #define VM_DATA_DEFAULT_FLAGS	VM_DATA_DEFAULT_FLAGS32
 
-#ifdef CONFIG_NOT_COHERENT_CACHE
-#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
-#endif
-
 #if defined(CONFIG_PPC_256K_PAGES) || \
     (defined(CONFIG_PPC_8xx) && defined(CONFIG_PPC_16K_PAGES))
 #define PTE_SHIFT	(PAGE_SHIFT - PTE_T_LOG2 - 2)	/* 1/4 of a page */
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

