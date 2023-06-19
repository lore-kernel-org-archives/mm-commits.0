Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2DFDEB64DC
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjFSXYz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjFSXXL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76BC110FF
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1536960FDB
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA12C433C0;
        Mon, 19 Jun 2023 23:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216956;
        bh=M5ayrWd2pmlMK4gj1xSf3oOB++IxYb2+z0JWXy8PVt4=;
        h=Date:To:From:Subject:From;
        b=N1LxSquNHLuv6V3GxJ0KbPB/WY+2o+P2jMstHqYYBulgsw6tWoSUOMbczW48M5gwP
         oEthK569iGBq/Mix+fR2JSxApUe4iIRfa6m+mfvRSBYD6YGYNqUbHyEHo/JHfo+ag/
         5kCIgkwTBDO/c1frCnHKFcLMOu+vnnUaxooNXUWE=
Date:   Mon, 19 Jun 2023 16:22:35 -0700
To:     mm-commits@vger.kernel.org, ysato@users.sourceforge.jp,
        vbabka@suse.cz, npiggin@gmail.com, mpe@ellerman.id.au,
        monstr@monstr.eu, lkp@intel.com, glaubitz@physik.fu-berlin.de,
        dalias@libc.org, christophe.leroy@csgroup.eu,
        catalin.marinas@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] microblaze-move-the-arch_dmaslab_minalign-definitions-to-asm-cacheh.patch removed from -mm tree
Message-Id: <20230619232236.6EA12C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: microblaze: move the ARCH_{DMA,SLAB}_MINALIGN definitions to asm/cache.h
has been removed from the -mm tree.  Its filename was
     microblaze-move-the-arch_dmaslab_minalign-definitions-to-asm-cacheh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: microblaze: move the ARCH_{DMA,SLAB}_MINALIGN definitions to asm/cache.h
Date: Tue, 13 Jun 2023 16:52:44 +0100

The microblaze architecture defines ARCH_DMA_MINALIGN in asm/page.h.  Move
it to asm/cache.h to allow a generic ARCH_DMA_MINALIGN definition in
linux/cache.h without redefine errors/warnings.

While at it, also move ARCH_SLAB_MINALIGN to asm/cache.h for
consistency.

Link: https://lkml.kernel.org/r/20230613155245.1228274-3-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: kernel test robot <lkp@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/include/asm/cache.h |    5 +++++
 arch/microblaze/include/asm/page.h  |    5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/microblaze/include/asm/cache.h~microblaze-move-the-arch_dmaslab_minalign-definitions-to-asm-cacheh
+++ a/arch/microblaze/include/asm/cache.h
@@ -18,4 +18,9 @@
 
 #define SMP_CACHE_BYTES	L1_CACHE_BYTES
 
+/* MS be sure that SLAB allocates aligned objects */
+#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
+
+#define ARCH_SLAB_MINALIGN	L1_CACHE_BYTES
+
 #endif /* _ASM_MICROBLAZE_CACHE_H */
--- a/arch/microblaze/include/asm/page.h~microblaze-move-the-arch_dmaslab_minalign-definitions-to-asm-cacheh
+++ a/arch/microblaze/include/asm/page.h
@@ -30,11 +30,6 @@
 
 #ifndef __ASSEMBLY__
 
-/* MS be sure that SLAB allocates aligned objects */
-#define ARCH_DMA_MINALIGN	L1_CACHE_BYTES
-
-#define ARCH_SLAB_MINALIGN	L1_CACHE_BYTES
-
 /*
  * PAGE_OFFSET -- the first address of the first page of memory. With MMU
  * it is set to the kernel start address (aligned on a page boundary).
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


