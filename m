Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E00EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjFSXYa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbjFSXW2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:22:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C1AF9
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F05F60FB7
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E608FC433C0;
        Mon, 19 Jun 2023 23:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216939;
        bh=fJA2MiICWuA7gsluoqP06gC+k+OfVFtfk0qobz7RSZQ=;
        h=Date:To:From:Subject:From;
        b=2LA0JrufIeZK/l6uFxeb87eJ/5A2hieyVGLnx6U7vRQCFNuXBl73cgc1UFkzmBc4y
         TKqqRi3ozQ/m5k9l5vm9C6YBKhIM0zj56Li9hwklYTRRJNjF+jJ+lhVWPrs2xaRQPu
         rlLe5/KGqL0nR9817uP5HRYmuFKo3ndPf8eywOF0=
Date:   Mon, 19 Jun 2023 16:22:18 -0700
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
Subject: [merged mm-stable] drivers-base-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign.patch removed from -mm tree
Message-Id: <20230619232218.E608FC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drivers/base: use ARCH_DMA_MINALIGN instead of ARCH_KMALLOC_MINALIGN
has been removed from the -mm tree.  Its filename was
     drivers-base-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: drivers/base: use ARCH_DMA_MINALIGN instead of ARCH_KMALLOC_MINALIGN
Date: Mon, 12 Jun 2023 16:31:49 +0100

ARCH_DMA_MINALIGN represents the minimum (static) alignment for safe DMA
operations while ARCH_KMALLOC_MINALIGN is the minimum kmalloc() objects
alignment.

Link: https://lkml.kernel.org/r/20230612153201.554742-6-catalin.marinas@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
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
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/devres.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/base/devres.c~drivers-base-use-arch_dma_minalign-instead-of-arch_kmalloc_minalign
+++ a/drivers/base/devres.c
@@ -29,10 +29,10 @@ struct devres {
 	 * Some archs want to perform DMA into kmalloc caches
 	 * and need a guaranteed alignment larger than
 	 * the alignment of a 64-bit integer.
-	 * Thus we use ARCH_KMALLOC_MINALIGN here and get exactly the same
-	 * buffer alignment as if it was allocated by plain kmalloc().
+	 * Thus we use ARCH_DMA_MINALIGN for data[] which will force the same
+	 * alignment for struct devres when allocated by kmalloc().
 	 */
-	u8 __aligned(ARCH_KMALLOC_MINALIGN) data[];
+	u8 __aligned(ARCH_DMA_MINALIGN) data[];
 };
 
 struct devres_group {
_

Patches currently in -mm which might be from catalin.marinas@arm.com are


