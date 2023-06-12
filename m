Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADA55C7EE43
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjFLUEF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbjFLUEE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:04:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D148310F9
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:04:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56C8D62DEF
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:04:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2868C433D2;
        Mon, 12 Jun 2023 20:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686600240;
        bh=kR+oSop4oJyJwLNYukTSn8Zi7zEJzuhjJI2eXq8BNoo=;
        h=Date:To:From:Subject:From;
        b=yLJdt54cZWNj1UhNXIRTDrL/Hpd67XMj5R59rM++xMXCct1dNH5lrm7Ys8E5T6Akk
         ZwLYaTQyML4YtoT1m6aSLUl1rrCkNNUvrMGynLIFLtwALBpCuq0rsSfOl69wufDi54
         JaiW/fwEPkw05RnDCNvw8v/LWTF1bcueRM2h5Hxc=
Date:   Mon, 12 Jun 2023 13:04:00 -0700
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
Subject: + mm-slab-simplify-create_kmalloc_cache-args-and-make-it-static.patch added to mm-unstable branch
Message-Id: <20230612200400.A2868C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: simplify create_kmalloc_cache() args and make it static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-slab-simplify-create_kmalloc_cache-args-and-make-it-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-slab-simplify-create_kmalloc_cache-args-and-make-it-static.patch

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
Subject: mm/slab: simplify create_kmalloc_cache() args and make it static
Date: Mon, 12 Jun 2023 16:31:47 +0100

In the slab variant of kmem_cache_init(), call new_kmalloc_cache() instead
of initialising the kmalloc_caches array directly.  With this,
create_kmalloc_cache() is now only called from new_kmalloc_cache() in the
same file, so make it static.  In addition, the useroffset argument is
always 0 while usersize is the same as size.  Remove them.

Link: https://lkml.kernel.org/r/20230612153201.554742-4-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
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
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c        |    6 +-----
 mm/slab.h        |    5 ++---
 mm/slab_common.c |   14 ++++++--------
 3 files changed, 9 insertions(+), 16 deletions(-)

--- a/mm/slab.c~mm-slab-simplify-create_kmalloc_cache-args-and-make-it-static
+++ a/mm/slab.c
@@ -1240,11 +1240,7 @@ void __init kmem_cache_init(void)
 	 * Initialize the caches that provide memory for the  kmem_cache_node
 	 * structures first.  Without this, further allocations will bug.
 	 */
-	kmalloc_caches[KMALLOC_NORMAL][INDEX_NODE] = create_kmalloc_cache(
-				kmalloc_info[INDEX_NODE].name[KMALLOC_NORMAL],
-				kmalloc_info[INDEX_NODE].size,
-				ARCH_KMALLOC_FLAGS, 0,
-				kmalloc_info[INDEX_NODE].size);
+	new_kmalloc_cache(INDEX_NODE, KMALLOC_NORMAL, ARCH_KMALLOC_FLAGS);
 	slab_state = PARTIAL_NODE;
 	setup_kmalloc_cache_index_table();
 
--- a/mm/slab_common.c~mm-slab-simplify-create_kmalloc_cache-args-and-make-it-static
+++ a/mm/slab_common.c
@@ -658,17 +658,16 @@ void __init create_boot_cache(struct kme
 	s->refcount = -1;	/* Exempt from merging for now */
 }
 
-struct kmem_cache *__init create_kmalloc_cache(const char *name,
-		unsigned int size, slab_flags_t flags,
-		unsigned int useroffset, unsigned int usersize)
+static struct kmem_cache *__init create_kmalloc_cache(const char *name,
+						      unsigned int size,
+						      slab_flags_t flags)
 {
 	struct kmem_cache *s = kmem_cache_zalloc(kmem_cache, GFP_NOWAIT);
 
 	if (!s)
 		panic("Out of memory when creating slab %s\n", name);
 
-	create_boot_cache(s, name, size, flags | SLAB_KMALLOC, useroffset,
-								usersize);
+	create_boot_cache(s, name, size, flags | SLAB_KMALLOC, 0, size);
 	list_add(&s->list, &slab_caches);
 	s->refcount = 1;
 	return s;
@@ -863,7 +862,7 @@ void __init setup_kmalloc_cache_index_ta
 	}
 }
 
-static void __init
+void __init
 new_kmalloc_cache(int idx, enum kmalloc_cache_type type, slab_flags_t flags)
 {
 	if ((KMALLOC_RECLAIM != KMALLOC_NORMAL) && (type == KMALLOC_RECLAIM)) {
@@ -880,8 +879,7 @@ new_kmalloc_cache(int idx, enum kmalloc_
 
 	kmalloc_caches[type][idx] = create_kmalloc_cache(
 					kmalloc_info[idx].name[type],
-					kmalloc_info[idx].size, flags, 0,
-					kmalloc_info[idx].size);
+					kmalloc_info[idx].size, flags);
 
 	/*
 	 * If CONFIG_MEMCG_KMEM is enabled, disable cache merging for
--- a/mm/slab.h~mm-slab-simplify-create_kmalloc_cache-args-and-make-it-static
+++ a/mm/slab.h
@@ -255,9 +255,8 @@ gfp_t kmalloc_fix_flags(gfp_t flags);
 /* Functions provided by the slab allocators */
 int __kmem_cache_create(struct kmem_cache *, slab_flags_t flags);
 
-struct kmem_cache *create_kmalloc_cache(const char *name, unsigned int size,
-			slab_flags_t flags, unsigned int useroffset,
-			unsigned int usersize);
+void __init new_kmalloc_cache(int idx, enum kmalloc_cache_type type,
+			      slab_flags_t flags);
 extern void create_boot_cache(struct kmem_cache *, const char *name,
 			unsigned int size, slab_flags_t flags,
 			unsigned int useroffset, unsigned int usersize);
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

