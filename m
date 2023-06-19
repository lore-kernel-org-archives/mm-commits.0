Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CAEEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjFSXYn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjFSXXE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E9510C7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64D8E60F4F
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD954C433CA;
        Mon, 19 Jun 2023 23:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216952;
        bh=EioZRD/G1NUjy0+0Op8Fb8LTF4fIvwPKqHgoM5Stpy4=;
        h=Date:To:From:Subject:From;
        b=ofzkHi2GWYm2/A5aeS1rQ2+q5nLPZsOuizo37c4ESJKZPim8tWGz8h9FxW2r7h7fY
         pgOXZVnxyowVQTZAvm/C0U23QyyX6ItFkXRO9SMqqpUslPHtUSElpvlK2LI2grByVF
         KeJUJDsdmY51vFikDNKiLU9BleOhunhPkq1N2UpU=
Date:   Mon, 19 Jun 2023 16:22:32 -0700
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
Subject: [merged mm-stable] mm-slab-reduce-the-kmalloc-minimum-alignment-if-dma-bouncing-possible.patch removed from -mm tree
Message-Id: <20230619232232.BD954C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: slab: reduce the kmalloc() minimum alignment if DMA bouncing possible
has been removed from the -mm tree.  Its filename was
     mm-slab-reduce-the-kmalloc-minimum-alignment-if-dma-bouncing-possible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: mm: slab: reduce the kmalloc() minimum alignment if DMA bouncing possible
Date: Mon, 12 Jun 2023 16:32:00 +0100

If an architecture opted in to DMA bouncing of unaligned kmalloc() buffers
(ARCH_WANT_KMALLOC_DMA_BOUNCE), reduce the minimum kmalloc() cache
alignment below cache-line size to ARCH_KMALLOC_MINALIGN.

Link: https://lkml.kernel.org/r/20230612153201.554742-17-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>
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
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/slab_common.c~mm-slab-reduce-the-kmalloc-minimum-alignment-if-dma-bouncing-possible
+++ a/mm/slab_common.c
@@ -18,6 +18,7 @@
 #include <linux/uaccess.h>
 #include <linux/seq_file.h>
 #include <linux/dma-mapping.h>
+#include <linux/swiotlb.h>
 #include <linux/proc_fs.h>
 #include <linux/debugfs.h>
 #include <linux/kasan.h>
@@ -865,6 +866,10 @@ void __init setup_kmalloc_cache_index_ta
 
 static unsigned int __kmalloc_minalign(void)
 {
+#ifdef CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC
+	if (io_tlb_default_mem.nslabs)
+		return ARCH_KMALLOC_MINALIGN;
+#endif
 	return dma_get_cache_alignment();
 }
 
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


