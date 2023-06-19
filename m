Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FAC1EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 23:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjFSXYg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 19:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjFSXXC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 19:23:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AF5E6C
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 16:22:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E7AE60FDD
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 23:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A6AC433C0;
        Mon, 19 Jun 2023 23:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687216948;
        bh=+Ogn1Uq+m7BcP+DktWbQpmNKO01ZhqINz1UDzyDzYBc=;
        h=Date:To:From:Subject:From;
        b=wc/ofhYZ5d1sWjAWjqFqLDwLu3SZFHT9xV32tRRLmpqLxXsVQxy2aTyz6v9qrERWt
         BrC/JSxHD4mdH5dYwHCzHLMxWZyuGO4hBgvOOKqA19ZdlYKMf7iPWw4ugDnT57+p91
         cOGndAZyHg0EOZ8igH2xTYu1t6uCg4RHLHFmw7+I=
Date:   Mon, 19 Jun 2023 16:22:28 -0700
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
Subject: [merged mm-stable] dma-mapping-name-sg-dma-flag-helpers-consistently.patch removed from -mm tree
Message-Id: <20230619232228.C8A6AC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: dma-mapping: name SG DMA flag helpers consistently
has been removed from the -mm tree.  Its filename was
     dma-mapping-name-sg-dma-flag-helpers-consistently.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Robin Murphy <robin.murphy@arm.com>
Subject: dma-mapping: name SG DMA flag helpers consistently
Date: Mon, 12 Jun 2023 16:31:57 +0100

sg_is_dma_bus_address() is inconsistent with the naming pattern of its
corresponding setters and its own kerneldoc, so take the majority vote and
rename it sg_dma_is_bus_address() (and fix up the missing underscores in
the kerneldoc too).  This gives us a nice clear pattern where SG DMA flags
are SG_DMA_<NAME>, and the helpers for acting on them are
sg_dma_<action>_<name>().

Link: https://lkml.kernel.org/r/20230612153201.554742-14-catalin.marinas@arm.com
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
  Link: https://lore.kernel.org/r/fa2eca2862c7ffc41b50337abffb2dfd2864d3ea.1685036694.git.robin.murphy@arm.com
Tested-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iommu/dma-iommu.c   |    8 ++++----
 drivers/iommu/iommu.c       |    2 +-
 include/linux/scatterlist.h |    8 ++++----
 kernel/dma/direct.c         |    2 +-
 4 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/iommu/dma-iommu.c~dma-mapping-name-sg-dma-flag-helpers-consistently
+++ a/drivers/iommu/dma-iommu.c
@@ -1080,7 +1080,7 @@ static int __finalise_sg(struct device *
 		sg_dma_address(s) = DMA_MAPPING_ERROR;
 		sg_dma_len(s) = 0;
 
-		if (sg_is_dma_bus_address(s)) {
+		if (sg_dma_is_bus_address(s)) {
 			if (i > 0)
 				cur = sg_next(cur);
 
@@ -1136,7 +1136,7 @@ static void __invalidate_sg(struct scatt
 	int i;
 
 	for_each_sg(sg, s, nents, i) {
-		if (sg_is_dma_bus_address(s)) {
+		if (sg_dma_is_bus_address(s)) {
 			sg_dma_unmark_bus_address(s);
 		} else {
 			if (sg_dma_address(s) != DMA_MAPPING_ERROR)
@@ -1329,7 +1329,7 @@ static void iommu_dma_unmap_sg(struct de
 	 * just have to be determined.
 	 */
 	for_each_sg(sg, tmp, nents, i) {
-		if (sg_is_dma_bus_address(tmp)) {
+		if (sg_dma_is_bus_address(tmp)) {
 			sg_dma_unmark_bus_address(tmp);
 			continue;
 		}
@@ -1343,7 +1343,7 @@ static void iommu_dma_unmap_sg(struct de
 
 	nents -= i;
 	for_each_sg(tmp, tmp, nents, i) {
-		if (sg_is_dma_bus_address(tmp)) {
+		if (sg_dma_is_bus_address(tmp)) {
 			sg_dma_unmark_bus_address(tmp);
 			continue;
 		}
--- a/drivers/iommu/iommu.c~dma-mapping-name-sg-dma-flag-helpers-consistently
+++ a/drivers/iommu/iommu.c
@@ -2567,7 +2567,7 @@ ssize_t iommu_map_sg(struct iommu_domain
 			len = 0;
 		}
 
-		if (sg_is_dma_bus_address(sg))
+		if (sg_dma_is_bus_address(sg))
 			goto next;
 
 		if (len) {
--- a/include/linux/scatterlist.h~dma-mapping-name-sg-dma-flag-helpers-consistently
+++ a/include/linux/scatterlist.h
@@ -258,7 +258,7 @@ static inline void sg_unmark_end(struct
 #define SG_DMA_BUS_ADDRESS (1 << 0)
 
 /**
- * sg_dma_is_bus address - Return whether a given segment was marked
+ * sg_dma_is_bus_address - Return whether a given segment was marked
  *			   as a bus address
  * @sg:		 SG entry
  *
@@ -266,13 +266,13 @@ static inline void sg_unmark_end(struct
  *   Returns true if sg_dma_mark_bus_address() has been called on
  *   this segment.
  **/
-static inline bool sg_is_dma_bus_address(struct scatterlist *sg)
+static inline bool sg_dma_is_bus_address(struct scatterlist *sg)
 {
 	return sg->dma_flags & SG_DMA_BUS_ADDRESS;
 }
 
 /**
- * sg_dma_mark_bus address - Mark the scatterlist entry as a bus address
+ * sg_dma_mark_bus_address - Mark the scatterlist entry as a bus address
  * @sg:		 SG entry
  *
  * Description:
@@ -300,7 +300,7 @@ static inline void sg_dma_unmark_bus_add
 
 #else
 
-static inline bool sg_is_dma_bus_address(struct scatterlist *sg)
+static inline bool sg_dma_is_bus_address(struct scatterlist *sg)
 {
 	return false;
 }
--- a/kernel/dma/direct.c~dma-mapping-name-sg-dma-flag-helpers-consistently
+++ a/kernel/dma/direct.c
@@ -463,7 +463,7 @@ void dma_direct_unmap_sg(struct device *
 	int i;
 
 	for_each_sg(sgl,  sg, nents, i) {
-		if (sg_is_dma_bus_address(sg))
+		if (sg_dma_is_bus_address(sg))
 			sg_dma_unmark_bus_address(sg);
 		else
 			dma_direct_unmap_page(dev, sg->dma_address,
_

Patches currently in -mm which might be from robin.murphy@arm.com are


