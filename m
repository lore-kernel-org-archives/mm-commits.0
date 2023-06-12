Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1071C88CB2
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbjFLUEG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjFLUEF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:04:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FC310FC
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:04:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB8DA62DD9
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:04:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34BDDC433D2;
        Mon, 12 Jun 2023 20:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686600243;
        bh=RFfZTaUxnMipSjotR41m/LZuI+AR/0cobspgJfOu7kQ=;
        h=Date:To:From:Subject:From;
        b=ICEinfURiNxVW1k4DdHsSpnO8gD600hhSHM1gNADmQG2VUWjv8Nw0F8sFz1FfN9he
         VIuyaQ5FVSvLi/Fz1jaOKe1MBiDDIBjPMckKUbVQmNkMRTbdp7OBC60mldTg5LYwX3
         M3ouTPwvoLi/Vrke/f+fAgiJIG6uxKzPU+h2UgNA=
Date:   Mon, 12 Jun 2023 13:04:02 -0700
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
Subject: + mm-slab-limit-kmalloc-minimum-alignment-to-dma_get_cache_alignment.patch added to mm-unstable branch
Message-Id: <20230612200403.34BDDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: limit kmalloc() minimum alignment to dma_get_cache_alignment()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slab-limit-kmalloc-minimum-alignment-to-dma_get_cache_alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slab-limit-kmalloc-minimum-alignment-to-dma_get_cache_alignment.patch

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
Subject: mm/slab: limit kmalloc() minimum alignment to dma_get_cache_alignment()
Date: Mon, 12 Jun 2023 16:31:48 +0100

Do not create kmalloc() caches which are not aligned to
dma_get_cache_alignment().  There is no functional change since for
current architectures defining ARCH_DMA_MINALIGN, ARCH_KMALLOC_MINALIGN
equals ARCH_DMA_MINALIGN (and dma_get_cache_alignment()).  On
architectures without a specific ARCH_DMA_MINALIGN,
dma_get_cache_alignment() is 1, so no change to the kmalloc() caches.

Link: https://lkml.kernel.org/r/20230612153201.554742-5-catalin.marinas@arm.com
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

 mm/slab_common.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/mm/slab_common.c~mm-slab-limit-kmalloc-minimum-alignment-to-dma_get_cache_alignment
+++ a/mm/slab_common.c
@@ -17,6 +17,7 @@
 #include <linux/cpu.h>
 #include <linux/uaccess.h>
 #include <linux/seq_file.h>
+#include <linux/dma-mapping.h>
 #include <linux/proc_fs.h>
 #include <linux/debugfs.h>
 #include <linux/kasan.h>
@@ -862,9 +863,18 @@ void __init setup_kmalloc_cache_index_ta
 	}
 }
 
+static unsigned int __kmalloc_minalign(void)
+{
+	return dma_get_cache_alignment();
+}
+
 void __init
 new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 {
+	unsigned int minalign = __kmalloc_minalign();
+	unsigned int aligned_size = kmalloc_info[idx].size;
+	int aligned_idx = idx;
+
 	if ((KMALLOC_RECLAIM != KMALLOC_NORMAL) && (type == KMALLOC_RECLAIM)) {
 		flags |= SLAB_RECLAIM_ACCOUNT;
 	} else if (IS_ENABLED(CONFIG_MEMCG_KMEM) && (type == KMALLOC_CGROUP)) {
@@ -877,9 +887,17 @@ new_kmalloc_cache(int idx, enum kmalloc_
 		flags |= SLAB_CACHE_DMA;
 	}
 
-	kmalloc_caches[type][idx] = create_kmalloc_cache(
-					kmalloc_info[idx].name[type],
-					kmalloc_info[idx].size, flags);
+	if (minalign > ARCH_KMALLOC_MINALIGN) {
+		aligned_size = ALIGN(aligned_size, minalign);
+		aligned_idx = __kmalloc_index(aligned_size, false);
+	}
+
+	if (!kmalloc_caches[type][aligned_idx])
+		kmalloc_caches[type][aligned_idx] = create_kmalloc_cache(
+					kmalloc_info[aligned_idx].name[type],
+					aligned_size, flags);
+	if (idx != aligned_idx)
+		kmalloc_caches[type][idx] = kmalloc_caches[type][aligned_idx];
 
 	/*
 	 * If CONFIG_MEMCG_KMEM is enabled, disable cache merging for
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

