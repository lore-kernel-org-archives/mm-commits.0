Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E1B1EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjFSXYb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjFSXW2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378981A3
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C157960FBE
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2529FC433C0;
        Mon, 19 Jun 2023 23:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216940;
        bh=v+M1n0EvgLmDXx40xtHGKxcryR8lfEeVQ1lR9gQaI5s=;
        h=Date:To:From:Subject:From;
        b=T3Dcxz4zKYFllrlplFvwMTmttxk21pmXzkVQIMM1/NDTSrh6KzPFZu0N4luislXSO
         LfHDKrYmG6DTdmvbSFs46Fa6l2Se0DTzGyJ9FIn0WRQlNoSywpabh49KIuwrG+IDly
         YvgT6EBK7BGpXiL06U8pwmSfTLvOWJ2kmvtsQkn4=
Date:   Mon, 19 Jun 2023 16:22:19 -0700
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
Subject: [merged mm-stable] drivers-gpu-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign.patch removed from -mm tree
Message-Id: <20230619232220.2529FC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drivers/gpu: use ARCH_DMA_MINALIGN instead of ARCH_KMALLOC_MINALIGN
has been removed from the -mm tree.  Its filename was
     drivers-gpu-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: drivers/gpu: use ARCH_DMA_MINALIGN instead of ARCH_KMALLOC_MINALIGN
Date: Mon, 12 Jun 2023 16:31:50 +0100

ARCH_DMA_MINALIGN represents the minimum (static) alignment for safe DMA
operations while ARCH_KMALLOC_MINALIGN is the minimum kmalloc() objects
alignment.

Link: https://lkml.kernel.org/r/20230612153201.554742-7-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
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
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/drm_managed.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_managed.c~drivers-gpu-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign
+++ a/drivers/gpu/drm/drm_managed.c
@@ -49,10 +49,10 @@ struct drmres {
 	 * Some archs want to perform DMA into kmalloc caches
 	 * and need a guaranteed alignment larger than
 	 * the alignment of a 64-bit integer.
-	 * Thus we use ARCH_KMALLOC_MINALIGN here and get exactly the same
-	 * buffer alignment as if it was allocated by plain kmalloc().
+	 * Thus we use ARCH_DMA_MINALIGN for data[] which will force the same
+	 * alignment for struct drmres when allocated by kmalloc().
 	 */
-	u8 __aligned(ARCH_KMALLOC_MINALIGN) data[];
+	u8 __aligned(ARCH_DMA_MINALIGN) data[];
 };
 
 static void free_dr(struct drmres *dr)
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


