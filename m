Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2C8C7EE2F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjFLUEh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbjFLUEV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:04:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD671711
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:04:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AF5A62E03
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667A9C433D2;
        Mon, 12 Jun 2023 20:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686600259;
        bh=HNQGTywm9HyBIDC5G9RlVhZvNV68NKzeTpjbxDkk+6c=;
        h=Date:To:From:Subject:From;
        b=bD18MYZ8q4iWNaPF1ejAUZr+QNBFcCXy1VbE9Ua3W8NoXSyFKwprlR6ewlXNzMT+W
         tgNnqy0+xnHnGAu3OXQXCbcz3hhngTYNbMmV9K8pXYw45PPuNNMxODzq/Yoi9fLsn/
         F7Kqo3ZyfrIN6adREaF9EiI6/twzVZAQccyukGWM=
Date:   Mon, 12 Jun 2023 13:04:18 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org, vbabka@suse.cz,
        snitzer@kernel.org, saravanak@google.com, rafael@kernel.org,
        maz@kernel.org, logang@deltatee.com, lars@metafoo.de,
        jsnitsel@redhat.com, joro@8bytes.org, Jonathan.Cameron@huawei.com,
        jic23@kernel.org, isaacmanjarres@google.com,
        herbert@gondor.apana.org.au, hch@lst.de,
        gregkh@linuxfoundation.org, daniel@ffwll.ch,
        catalin.marinas@arm.com, broonie@kernel.org, arnd@arndb.de,
        ardb@kernel.org, agk@redhat.com, robin.murphy@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + scatterlist-add-dedicated-config-for-dma-flags.patch added to mm-unstable branch
Message-Id: <20230612200419.667A9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scatterlist: add dedicated config for DMA flags
has been added to the -mm mm-unstable branch.  Its filename is
     scatterlist-add-dedicated-config-for-dma-flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scatterlist-add-dedicated-config-for-dma-flags.patch

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
From: Robin Murphy <robin.murphy@arm.com>
Subject: scatterlist: add dedicated config for DMA flags
Date: Mon, 12 Jun 2023 16:31:56 +0100

The DMA flags field will be useful for users beyond PCI P2P, so upgrade to
its own dedicated config option.

[catalin.marinas@arm.com: use #ifdef CONFIG_NEED_SG_DMA_FLAGS in scatterlist.h]
[catalin.marinas@arm.com: update PCI_P2PDMA dma_flags comment in scatterlist.h]
Link: https://lkml.kernel.org/r/20230612153201.554742-13-catalin.marinas@arm.com
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
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
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/Kconfig         |    1 +
 include/linux/scatterlist.h |   13 ++++++-------
 kernel/dma/Kconfig          |    3 +++
 3 files changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/pci/Kconfig~scatterlist-add-dedicated-config-for-dma-flags
+++ a/drivers/pci/Kconfig
@@ -168,6 +168,7 @@ config PCI_P2PDMA
 	#
 	depends on 64BIT
 	select GENERIC_ALLOCATOR
+	select NEED_SG_DMA_FLAGS
 	help
 	  Enableѕ drivers to do PCI peer-to-peer transactions to and from
 	  BARs that are exposed in other devices that are the part of
--- a/include/linux/scatterlist.h~scatterlist-add-dedicated-config-for-dma-flags
+++ a/include/linux/scatterlist.h
@@ -16,7 +16,7 @@ struct scatterlist {
 #ifdef CONFIG_NEED_SG_DMA_LENGTH
 	unsigned int	dma_length;
 #endif
-#ifdef CONFIG_PCI_P2PDMA
+#ifdef CONFIG_NEED_SG_DMA_FLAGS
 	unsigned int    dma_flags;
 #endif
 };
@@ -249,12 +249,11 @@ static inline void sg_unmark_end(struct
 }
 
 /*
- * CONFGI_PCI_P2PDMA depends on CONFIG_64BIT which means there is 4 bytes
- * in struct scatterlist (assuming also CONFIG_NEED_SG_DMA_LENGTH is set).
- * Use this padding for DMA flags bits to indicate when a specific
- * dma address is a bus address.
+ * One 64-bit architectures there is a 4-byte padding in struct scatterlist
+ * (assuming also CONFIG_NEED_SG_DMA_LENGTH is set). Use this padding for DMA
+ * flags bits to indicate when a specific dma address is a bus address.
  */
-#ifdef CONFIG_PCI_P2PDMA
+#ifdef CONFIG_NEED_SG_DMA_FLAGS
 
 #define SG_DMA_BUS_ADDRESS (1 << 0)
 
@@ -312,7 +311,7 @@ static inline void sg_dma_unmark_bus_add
 {
 }
 
-#endif
+#endif	/* CONFIG_NEED_SG_DMA_FLAGS */
 
 /**
  * sg_phys - Return physical address of an sg entry
--- a/kernel/dma/Kconfig~scatterlist-add-dedicated-config-for-dma-flags
+++ a/kernel/dma/Kconfig
@@ -24,6 +24,9 @@ config DMA_OPS_BYPASS
 config ARCH_HAS_DMA_MAP_DIRECT
 	bool
 
+config NEED_SG_DMA_FLAGS
+	bool
+
 config NEED_SG_DMA_LENGTH
 	bool
 
_

Patches currently in -mm which might be from robin.murphy@arm.com are

scatterlist-add-dedicated-config-for-dma-flags.patch
dma-mapping-name-sg-dma-flag-helpers-consistently.patch

