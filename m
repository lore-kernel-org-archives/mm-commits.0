Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A377C88CB6
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235962AbjFLUEs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234579AbjFLUEf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:04:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6096A171C
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:04:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEAC862E0F
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476FEC433D2;
        Mon, 12 Jun 2023 20:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686600272;
        bh=DF5e0aD96BneatEoOmZwPgyGOCdsrlwenIL4F6nWfDg=;
        h=Date:To:From:Subject:From;
        b=PN4O09zq8AMexq+Un2JIqiwgRbeIZsA1Q8gxMSSXzvrHWhZn/AnL8F/UqxttZSGAa
         v+FXMsZ+Rz/Wt/bH5Vpt1YGGadKlAmAG2PwHfXcrHAFsAL+Fl7jvB3bqXpBppwqjus
         737C156AqjOTcFcnRRWd9QJVWu/DOqHgT9+zjodk=
Date:   Mon, 12 Jun 2023 13:04:31 -0700
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
Subject: + arm64-enable-arch_want_kmalloc_dma_bounce-for-arm64.patch added to mm-unstable branch
Message-Id: <20230612200432.476FEC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: enable ARCH_WANT_KMALLOC_DMA_BOUNCE for arm64
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-enable-arch_want_kmalloc_dma_bounce-for-arm64.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-enable-arch_want_kmalloc_dma_bounce-for-arm64.patch

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
@@ -440,7 +440,12 @@ void __init bootmem_init(void)
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

