Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F33C4C7EE43
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbjFLUD7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjFLUD6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:03:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0902D186
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:03:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92F64620F0
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D385DC433D2;
        Mon, 12 Jun 2023 20:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686600236;
        bh=/chm2v8hYfA8hQeq73pFb4O8OZhJ1vAV7iYxu07h0C0=;
        h=Date:To:From:Subject:From;
        b=JlAUJ0IFmT4Oa4rsxQv4l8ByrNGb6+uyXf1VUZnpu/Xjs0gRx5APbml0CmFG3MSqH
         TKnjP+/j+osjCYv8XueMMyfpc1YOjQsJg1m579rfZFz8BoO0I7JYCsNPJJm2vjoEkE
         CQrfQbb03C2+E70Myp2O7YwUlB/SM5ph9lv5ulEg=
Date:   Mon, 12 Jun 2023 13:03:55 -0700
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
Subject: + mm-slab-decouple-arch_kmalloc_minalign-from-arch_dma_minalign.patch added to mm-unstable branch
Message-Id: <20230612200355.D385DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: decouple ARCH_KMALLOC_MINALIGN from ARCH_DMA_MINALIGN
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slab-decouple-arch_kmalloc_minalign-from-arch_dma_minalign.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slab-decouple-arch_kmalloc_minalign-from-arch_dma_minalign.patch

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
Subject: mm/slab: decouple ARCH_KMALLOC_MINALIGN from ARCH_DMA_MINALIGN
Date: Mon, 12 Jun 2023 16:31:45 +0100

Patch series "mm, dma, arm64: Reduce ARCH_KMALLOC_MINALIGN to 8", v7.

A series reducing the kmalloc() minimum alignment on arm64 to 8 (from
128).  


This patch (of 17):

In preparation for supporting a kmalloc() minimum alignment smaller than
the arch DMA alignment, decouple the two definitions.  This requires that
either the kmalloc() caches are aligned to a (run-time) cache-line size or
the DMA API bounces unaligned kmalloc() allocations.  Subsequent patches
will implement both options.

After this patch, ARCH_DMA_MINALIGN is expected to be used in static
alignment annotations and defined by an architecture to be the maximum
alignment for all supported configurations/SoCs in a single Image. 
Architectures opting in to a smaller ARCH_KMALLOC_MINALIGN will need to
define its value in the arch headers.

Since ARCH_DMA_MINALIGN is now always defined, adjust the #ifdef in
dma_get_cache_alignment() so that there is no change for architectures not
requiring a minimum DMA alignment.

Link: https://lkml.kernel.org/r/20230612153201.554742-1-catalin.marinas@arm.com
Link: https://lkml.kernel.org/r/20230612153201.554742-2-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cache.h       |    6 ++++++
 include/linux/dma-mapping.h |    3 ++-
 include/linux/slab.h        |   14 ++++++++++----
 3 files changed, 18 insertions(+), 5 deletions(-)

--- a/include/linux/cache.h~mm-slab-decouple-arch_kmalloc_minalign-from-arch_dma_minalign
+++ a/include/linux/cache.h
@@ -98,4 +98,10 @@ struct cacheline_padding {
 #define CACHELINE_PADDING(name)
 #endif
 
+#ifdef ARCH_DMA_MINALIGN
+#define ARCH_HAS_DMA_MINALIGN
+#else
+#define ARCH_DMA_MINALIGN __alignof__(unsigned long long)
+#endif
+
 #endif /* __LINUX_CACHE_H */
--- a/include/linux/dma-mapping.h~mm-slab-decouple-arch_kmalloc_minalign-from-arch_dma_minalign
+++ a/include/linux/dma-mapping.h
@@ -2,6 +2,7 @@
 #ifndef _LINUX_DMA_MAPPING_H
 #define _LINUX_DMA_MAPPING_H
 
+#include <linux/cache.h>
 #include <linux/sizes.h>
 #include <linux/string.h>
 #include <linux/device.h>
@@ -545,7 +546,7 @@ static inline int dma_set_min_align_mask
 
 static inline int dma_get_cache_alignment(void)
 {
-#ifdef ARCH_DMA_MINALIGN
+#ifdef ARCH_HAS_DMA_MINALIGN
 	return ARCH_DMA_MINALIGN;
 #endif
 	return 1;
--- a/include/linux/slab.h~mm-slab-decouple-arch_kmalloc_minalign-from-arch_dma_minalign
+++ a/include/linux/slab.h
@@ -12,6 +12,7 @@
 #ifndef _LINUX_SLAB_H
 #define	_LINUX_SLAB_H
 
+#include <linux/cache.h>
 #include <linux/gfp.h>
 #include <linux/overflow.h>
 #include <linux/types.h>
@@ -235,12 +236,17 @@ void kmem_dump_obj(void *object);
  * alignment larger than the alignment of a 64-bit integer.
  * Setting ARCH_DMA_MINALIGN in arch headers allows that.
  */
-#if defined(ARCH_DMA_MINALIGN) && ARCH_DMA_MINALIGN > 8
+#ifdef ARCH_HAS_DMA_MINALIGN
+#if ARCH_DMA_MINALIGN > 8 && !defined(ARCH_KMALLOC_MINALIGN)
 #define ARCH_KMALLOC_MINALIGN ARCH_DMA_MINALIGN
-#define KMALLOC_MIN_SIZE ARCH_DMA_MINALIGN
-#define KMALLOC_SHIFT_LOW ilog2(ARCH_DMA_MINALIGN)
-#else
+#endif
+#endif
+
+#ifndef ARCH_KMALLOC_MINALIGN
 #define ARCH_KMALLOC_MINALIGN __alignof__(unsigned long long)
+#elif ARCH_KMALLOC_MINALIGN > 8
+#define KMALLOC_MIN_SIZE ARCH_KMALLOC_MINALIGN
+#define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
 #endif
 
 /*
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

