Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B903DEB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjFSXYn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjFSXXE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFDD10F3
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A025A60FF9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F25C433C0;
        Mon, 19 Jun 2023 23:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216954;
        bh=x8zkT3o3l47pyos09jRq2QdYgnCze3hwTdZYRcVQwic=;
        h=Date:To:From:Subject:From;
        b=PdguMlLELxhkesg2kPe/E09lw3HcxXm//4Wh/j289pIPfgVqiHbgmR4nK970e/19H
         CMakgUe1H+Dsyinfrr3nfNTVEdO9YISPYLeuhjl6dxmn4Ac8E6p7W/Lw0FUz5/zC9Q
         dRI8Ql0jIJmJED+tweEgxhXmCULvANXFdxDKvnRc=
Date:   Mon, 19 Jun 2023 16:22:33 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vbabka@suse.cz,
        snitzer@kernel.org, saravanak@google.com, robin.murphy@arm.com,
        rafael@kernel.org, maz@kernel.org, logang@deltatee.com,
        lars@metafoo.de, jsnitsel@redhat.com, joro@8bytes.org,
        Jonathan.Cameron@huawei.com, jic23@kernel.org,
        isaacmanjarres@google.com, herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, daniel@ffwll.ch, broonie@kernel.org,
        arnd@arndb.de, ardb@kernel.org, agk@redhat.com,
        catalin.marinas@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-enable-arch_want_kmalloc_dma_bounce-for-arm64.patch removed from -mm tree
Message-Id: <20230619232234.03F25C433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: enable ARCH_WANT_KMALLOC_DMA_BOUNCE for arm64
has been removed from the -mm tree.  Its filename was
     arm64-enable-arch_want_kmalloc_dma_bounce-for-arm64.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: arm64: enable ARCH_WANT_KMALLOC_DMA_BOUNCE for arm64
Date: Mon, 12 Jun 2023 16:32:01 +0100

With the DMA bouncing of unaligned kmalloc() buffers now in place, enable
it for arm64 to allow the kmalloc-{8,16,32,48,96} caches.  In addition,
always create the swiotlb buffer even when the end of RAM is within the
32-bit physical address range (the swiotlb buffer can still be disabled on
the kernel command line).

Link: https://lkml.kernel.org/r/20230612153201.554742-18-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig   |    1 +
 arch/arm64/mm/init.c |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/arch/arm64/Kconfig~arm64-enable-arch_want_kmalloc_dma_bounce-for-arm64
+++ a/arch/arm64/Kconfig
@@ -120,6 +120,7 @@ config ARM64
 	select CRC32
 	select DCACHE_WORD_ACCESS
 	select DYNAMIC_FTRACE if FUNCTION_TRACER
+	select DMA_BOUNCE_UNALIGNED_KMALLOC
 	select DMA_DIRECT_REMAP
 	select EDAC_SUPPORT
 	select FRAME_POINTER
--- a/arch/arm64/mm/init.c~arm64-enable-arch_want_kmalloc_dma_bounce-for-arm64
+++ a/arch/arm64/mm/init.c
@@ -442,7 +442,12 @@ void __init bootmem_init(void)
  */
 void __init mem_init(void)
 {
-	swiotlb_init(max_pfn > PFN_DOWN(arm64_dma_phys_limit), SWIOTLB_VERBOSE);
+	bool swiotlb = max_pfn > PFN_DOWN(arm64_dma_phys_limit);
+
+	if (IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC))
+		swiotlb = true;
+
+	swiotlb_init(swiotlb, SWIOTLB_VERBOSE);
 
 	/* this will put all unused low memory onto the freelists */
 	memblock_free_all();
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


