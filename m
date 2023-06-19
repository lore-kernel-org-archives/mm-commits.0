Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 400CFEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjFSXYy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjFSXXK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DAC10FA
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F260360F4F
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CB9C433C8;
        Mon, 19 Jun 2023 23:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216955;
        bh=fYL8anxMl1CN7i31Xif75XyY3K0MXp8RSvQ0kl1nWZQ=;
        h=Date:To:From:Subject:From;
        b=F3ZtrZDfNN4FmIWnHl3cZpv7YRSF2jmzz7FKNZwXtp3Unwpr+xONe8NkGvUTHrMMb
         +b5VUwZDyb2w7MZ7QhDkm5NxuQlbzkqnajHOaaXv3B7wNIEde2e8X5HzyZXExs6pQC
         +5r91QBL+Nh5HZG7hBUuBapqSxI1g0EYWTmqXgkY=
Date:   Mon, 19 Jun 2023 16:22:34 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        vbabka@suse.cz, npiggin@gmail.com, mpe@ellerman.id.au,
        monstr@monstr.eu, lkp@intel.com, glaubitz@physik.fu-berlin.de,
        dalias@libc.org, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] powerpc-move-the-arch_dma_minalign-definition-to-asm-cacheh.patch removed from -mm tree
Message-Id: <20230619232235.57CB9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: powerpc: move the ARCH_DMA_MINALIGN definition to asm/cache.h
has been removed from the -mm tree.  Its filename was
     powerpc-move-the-arch_dma_minalign-definition-to-asm-cacheh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


