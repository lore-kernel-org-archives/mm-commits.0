Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E0AEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjFSXY4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjFSXXY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90911173E
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E5E260FBB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B7DC433C0;
        Mon, 19 Jun 2023 23:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216957;
        bh=wdhOpOVow1cP5zjyag0tz0x6e2J7UbBVTbIlr7vxfkM=;
        h=Date:To:From:Subject:From;
        b=0d4irf95Vv9IThZEIr7Xv1DBVx8DO20G+NEyy5VF5sMCYctC1q0ii/cRcFIW8nPX9
         aYAZAGCk/XGstaS2SaU+x+MdgTSXREO95abymmntLNvD6yOaUwxzRgRupHk799TYgM
         pmHBp/mzYl1KNfCmu2HMiJcpmGsk04e796P+MTvE=
Date:   Mon, 19 Jun 2023 16:22:36 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        vbabka@suse.cz, npiggin@gmail.com, mpe@ellerman.id.au,
        monstr@monstr.eu, lkp@intel.com, glaubitz@physik.fu-berlin.de,
        dalias@libc.org, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] sh-move-the-arch_dma_minalign-definition-to-asm-cacheh.patch removed from -mm tree
Message-Id: <20230619232237.87B7DC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sh: move the ARCH_DMA_MINALIGN definition to asm/cache.h
has been removed from the -mm tree.  Its filename was
     sh-move-the-arch_dma_minalign-definition-to-asm-cacheh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


