Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC879C88CB2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbjFLUEg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbjFLUEV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:04:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB3D170C
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:04:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AE9862DFF
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E129C433D2;
        Mon, 12 Jun 2023 20:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686600257;
        bh=jXuGzkC6m0qHjQRG5eHgGZOJt/am8V7F1wQTnQLY2sg=;
        h=Date:To:From:Subject:From;
        b=ysOtM0utZQ71pZHEMiJTocbSqRj/NSFdxeM+D99i+MdpNR7ZSddcqigt4Ca+CY52r
         VwtATGP50V7IVm7gSMT/3pTtkqCepQdt5Yl04ePiOQpst38nH/w3vO6UhjW/pbFKAt
         bx9XoXVdClyDCBl7oDNH5LL1ktGyniECJyw/4BAo=
Date:   Mon, 12 Jun 2023 13:04:16 -0700
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
Subject: + arm64-allow-kmalloc-caches-aligned-to-the-smaller-cache_line_size.patch added to mm-unstable branch
Message-Id: <20230612200417.6E129C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: allow kmalloc() caches aligned to the smaller cache_line_size()
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-allow-kmalloc-caches-aligned-to-the-smaller-cache_line_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-allow-kmalloc-caches-aligned-to-the-smaller-cache_line_size.patch

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
Subject: arm64: allow kmalloc() caches aligned to the smaller cache_line_size()
Date: Mon, 12 Jun 2023 16:31:55 +0100

On arm64, ARCH_DMA_MINALIGN is 128, larger than the cache line size on
most of the current platforms (typically 64).  Define
ARCH_KMALLOC_MINALIGN to 8 (the default for architectures without their
own ARCH_DMA_MINALIGN) and override dma_get_cache_alignment() to return
cache_line_size(), probed at run-time.  The kmalloc() caches will be
limited to the cache line size.  This will allow the additional
kmalloc-{64,192} caches on most arm64 platforms.

Link: https://lkml.kernel.org/r/20230612153201.554742-12-catalin.marinas@arm.com
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

 arch/arm64/include/asm/cache.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/include/asm/cache.h~arm64-allow-kmalloc-caches-aligned-to-the-smaller-cache_line_size
+++ a/arch/arm64/include/asm/cache.h
@@ -33,6 +33,7 @@
  * the CPU.
  */
 #define ARCH_DMA_MINALIGN	(128)
+#define ARCH_KMALLOC_MINALIGN	(8)
 
 #ifndef __ASSEMBLY__
 
@@ -90,6 +91,8 @@ static inline int cache_line_size_of_cpu
 
 int cache_line_size(void);
 
+#define dma_get_cache_alignment	cache_line_size
+
 /*
  * Read the effective value of CTR_EL0.
  *
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

