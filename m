Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17C2C88CB8
	for <mm-commits@archiver.kernel.org>; Mon, 12 Jun 2023 20:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234509AbjFLUEj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Jun 2023 16:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234281AbjFLUE0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jun 2023 16:04:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22203186
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 13:04:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B285F62DFC
        for <mm-commits@vger.kernel.org>; Mon, 12 Jun 2023 20:04:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07136C433D2;
        Mon, 12 Jun 2023 20:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686600262;
        bh=YXcEQr9Np0nN5X1jwmVs9g+HcxVSB+ps44pY9CR/Ukk=;
        h=Date:To:From:Subject:From;
        b=kcPyDYp6SGHPEPgQ65HO2Jbz9f7x/DpK/T1lil/y0T5zCntamEHVoBbrn93yF9uCB
         mzdcpQcXY8h+oXc58NDNJ5ntXlZzPQLt8WRdP2IUEv7g5uDxH1626GQhFSWnBpIIsT
         H+MBxL888HbhpSGZEgwm1cZ6wXBfTIjqg2L6sF4M=
Date:   Mon, 12 Jun 2023 13:04:21 -0700
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
Subject: + dma-mapping-name-sg-dma-flag-helpers-consistently.patch added to mm-unstable branch
Message-Id: <20230612200422.07136C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: name SG DMA flag helpers consistently
has been added to the -mm mm-unstable branch.  Its filename is
     dma-mapping-name-sg-dma-flag-helpers-consistently.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dma-mapping-name-sg-dma-flag-helpers-consistently.patch

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
Date: Mon, 12 Jun 2023 16:31:57 +0100
Subject: dma-mapping: name SG DMA flag helpers consistently

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

scatterlist-add-dedicated-config-for-dma-flags.patch
dma-mapping-name-sg-dma-flag-helpers-consistently.patch

