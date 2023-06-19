Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C6DEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjFSXYf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjFSXXC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B5BE78
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA63360FD7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487A4C433C9;
        Mon, 19 Jun 2023 23:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216946;
        bh=hkbu0MJQeOH+Yq0KDDybr9cG3ri87olmrmVPcRy0VMA=;
        h=Date:To:From:Subject:From;
        b=JvBCiNI3Uzycb1UWmlSzwglvPVR5GEV8oIOm55u2pfTheuxPU1izbPIrJtO1d1ZXl
         AnmunKIX5+LFL+THmOvc/9YYmoUDCVMqXfxmebDNy06J8di5pBEb9jyd4R7q7+QmQb
         7zlkHIPt+3p3M4H7ULl7PEG9/WHJV9S/WBg14kj4=
Date:   Mon, 19 Jun 2023 16:22:25 -0700
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
Subject: [merged mm-stable] arm64-allow-kmalloc-caches-aligned-to-the-smaller-cache_line_size.patch removed from -mm tree
Message-Id: <20230619232226.487A4C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: allow kmalloc() caches aligned to the smaller cache_line_size()
has been removed from the -mm tree.  Its filename was
     arm64-allow-kmalloc-caches-aligned-to-the-smaller-cache_line_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


