Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14320EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjFSXYZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbjFSXWY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C08A173B
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C72A960FDA
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A87EC433C0;
        Mon, 19 Jun 2023 23:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216935;
        bh=XoiMykPo6lmIgChG7Fh+yhwvg5cJk0Ta4qEWUNKpLWE=;
        h=Date:To:From:Subject:From;
        b=Kl45RnOkajF+m2WEvai9Fu2ZRmoYhk3Ai3h9APT/NVOMmOorxUl5V4hhFtOEApcYD
         liLhNsayAwaNth79cJx43wtkNkoWg2630TPvn1NhZO4w3+CbMvUtfGI/RHmrlN2TLx
         QpVRkql4soeJx2t9ozroVmIB11UjramYGqUCBqGE=
Date:   Mon, 19 Jun 2023 16:22:14 -0700
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
Subject: [merged mm-stable] dma-allow-dma_get_cache_alignment-to-be-overridden-by-the-arch-code.patch removed from -mm tree
Message-Id: <20230619232215.2A87EC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dma: allow dma_get_cache_alignment() to be overridden by the arch code
has been removed from the -mm tree.  Its filename was
     dma-allow-dma_get_cache_alignment-to-be-overridden-by-the-arch-code.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: dma: allow dma_get_cache_alignment() to be overridden by the arch code
Date: Mon, 12 Jun 2023 16:31:46 +0100

On arm64, ARCH_DMA_MINALIGN is larger than most cache line size
configurations deployed.  Allow an architecture to override
dma_get_cache_alignment() in order to return a run-time probed value (e.g.
cache_line_size()).

Link: https://lkml.kernel.org/r/20230612153201.554742-3-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
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
Cc: Saravana Kannan <saravanak@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/include/linux/dma-mapping.h~dma-allow-dma_get_cache_alignment-to-be-overridden-by-the-arch-code
+++ a/include/linux/dma-mapping.h
@@ -544,6 +544,7 @@ static inline int dma_set_min_align_mask
 	return 0;
 }
 
+#ifndef dma_get_cache_alignment
 static inline int dma_get_cache_alignment(void)
 {
 #ifdef ARCH_HAS_DMA_MINALIGN
@@ -551,6 +552,7 @@ static inline int dma_get_cache_alignmen
 #endif
 	return 1;
 }
+#endif
 
 static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp)
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


