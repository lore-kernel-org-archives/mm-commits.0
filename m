Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8201EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjFSXYd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjFSXXB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19306E65
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB4FE6100E
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BACBC433C8;
        Mon, 19 Jun 2023 23:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216945;
        bh=+muls5yEn0RXZ8hCyUuOwEaxbde0jJftJQrpN5Ipej0=;
        h=Date:To:From:Subject:From;
        b=k0S7THuOJCLfHan5PXZTfK5ihZsq8Ur66CXf4dzIGa0QWeaPAbrqJMomzGLEz9u0B
         wgOQ9r4BkiDUl843IE+S+pw0l8y74yaFkK+v25iqrmsxDyzarnPdxm/i/3Q3MTqwPW
         PUE+Wr3IOEiq6tYriVsSZDQx+lc6ZGGzd5RdOjms=
Date:   Mon, 19 Jun 2023 16:22:24 -0700
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
Subject: [merged mm-stable] iio-core-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign.patch removed from -mm tree
Message-Id: <20230619232225.0BACBC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: iio: core: use ARCH_DMA_MINALIGN instead of ARCH_KMALLOC_MINALIGN
has been removed from the -mm tree.  Its filename was
     iio-core-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: iio: core: use ARCH_DMA_MINALIGN instead of ARCH_KMALLOC_MINALIGN
Date: Mon, 12 Jun 2023 16:31:54 +0100

ARCH_DMA_MINALIGN represents the minimum (static) alignment for safe DMA
operations while ARCH_KMALLOC_MINALIGN is the minimum kmalloc() objects
alignment.

Link: https://lkml.kernel.org/r/20230612153201.554742-11-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
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

 include/linux/iio/iio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/iio/iio.h~iio-core-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign
+++ a/include/linux/iio/iio.h
@@ -722,7 +722,7 @@ static inline void *iio_device_get_drvda
  * must not share  cachelines with the rest of the structure, thus making
  * them safe for use with non-coherent DMA.
  */
-#define IIO_DMA_MINALIGN ARCH_KMALLOC_MINALIGN
+#define IIO_DMA_MINALIGN ARCH_DMA_MINALIGN
 struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv);
 
 /* The information at the returned address is guaranteed to be cacheline aligned */
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


