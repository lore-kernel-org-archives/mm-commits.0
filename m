Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C269BC63777
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 18:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C5FE2073C
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 18:57:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iuq7FYoA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgK3S5W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Nov 2020 13:57:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728727AbgK3S5W (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 30 Nov 2020 13:57:22 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35187206B5;
        Mon, 30 Nov 2020 18:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606762601;
        bh=CS4SBoDtYHUPybsE0nCqeVo0jVFiwTKpG1fOHOUopVw=;
        h=Date:From:To:Subject:From;
        b=iuq7FYoAGy589m9Tt+WSdxuca2CiG7MJhyzqGdBT5m+GH85A16iFG5KxiWgGVjgxL
         SWZGJGU7WxxYYSktAwfnjLg527bqiz+AoxA6loNS+VE+SAbsb9myhcpdDNPAATVeuk
         pWHJHXwBqWL+B5sFg9kr2Vo9JKgUCW+1WbYI7aIs=
Date:   Mon, 30 Nov 2020 10:56:40 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20201130185640.TWq07QoZU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/Kconfig                |    3 ---
 drivers/gpu/drm/ast/ast_mode.c             |    7 -------
 drivers/gpu/drm/i915/gvt/gvt.h             |    3 ---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c |    4 ----
 drivers/mtd/nand/raw/cs553x_nand.c         |    4 ----
 drivers/mtd/nand/raw/davinci_nand.c        |    7 -------
 drivers/mtd/nand/raw/fsmc_nand.c           |    4 ----
 drivers/mtd/nand/raw/lpc32xx_slc.c         |    4 ----
 drivers/mtd/nand/raw/sharpsl.c             |    4 ----
 drivers/net/can/usb/gs_usb.c               |    6 ------
 fs/btrfs/inode.c                           |    5 -----
 include/linux/platform_data/ti-sysc.h      |    3 ---
 12 files changed, 54 deletions(-)

--- a/arch/arm/mach-omap2/Kconfig~linux-next-git-rejects
+++ a/arch/arm/mach-omap2/Kconfig
@@ -10,10 +10,7 @@ config ARCH_OMAP2
 	depends on ARCH_MULTI_V6
 	select ARCH_OMAP2PLUS
 	select CPU_V6
-<<<<<<< HEAD
-=======
 	select OMAP_HWMOD
->>>>>>> linux-next/akpm-base
 	select SOC_HAS_OMAP2_SDRC
 
 config ARCH_OMAP3
--- a/drivers/gpu/drm/ast/ast_mode.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/ast/ast_mode.c
@@ -779,12 +779,6 @@ static int ast_crtc_helper_atomic_check(
 }
 
 static void
-<<<<<<< HEAD
-ast_crtc_helper_atomic_flush(struct drm_crtc *crtc, struct drm_crtc_state *old_crtc_state)
-{
-	struct ast_private *ast = to_ast_private(crtc->dev);
-	struct ast_crtc_state *ast_crtc_state = to_ast_crtc_state(crtc->state);
-=======
 ast_crtc_helper_atomic_flush(struct drm_crtc *crtc,
 			     struct drm_atomic_state *state)
 {
@@ -794,7 +788,6 @@ ast_crtc_helper_atomic_flush(struct drm_
 									      crtc);
 	struct ast_private *ast = to_ast_private(crtc->dev);
 	struct ast_crtc_state *ast_crtc_state = to_ast_crtc_state(crtc_state);
->>>>>>> linux-next/akpm-base
 	struct ast_crtc_state *old_ast_crtc_state = to_ast_crtc_state(old_crtc_state);
 
 	/*
--- a/drivers/gpu/drm/i915/gvt/gvt.h~linux-next-git-rejects
+++ a/drivers/gpu/drm/i915/gvt/gvt.h
@@ -255,11 +255,8 @@ struct intel_gvt_mmio {
 #define F_CMD_ACCESS	(1 << 3)
 /* This reg has been accessed by a VM */
 #define F_ACCESSED	(1 << 4)
-<<<<<<< HEAD
-=======
 /* This reg requires save & restore during host PM suspend/resume */
 #define F_PM_SAVE	(1 << 5)
->>>>>>> linux-next/akpm-base
 /* This reg could be accessed by unaligned address */
 #define F_UNALIGN	(1 << 6)
 /* This reg is in GVT's mmio save-restor list and in hardware
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c~linux-next-git-rejects
+++ a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -313,11 +313,7 @@ static struct arm_smmu_device *qcom_smmu
 	if (!qcom_scm_is_available())
 		return ERR_PTR(-EPROBE_DEFER);
 
-<<<<<<< HEAD
-	qsmmu = devm_kzalloc(smmu->dev, sizeof(*qsmmu), GFP_KERNEL);
-=======
 	qsmmu = devm_krealloc(smmu->dev, smmu, sizeof(*qsmmu), GFP_KERNEL);
->>>>>>> linux-next/akpm-base
 	if (!qsmmu)
 		return ERR_PTR(-ENOMEM);
 
--- a/drivers/mtd/nand/raw/cs553x_nand.c~linux-next-git-rejects
+++ a/drivers/mtd/nand/raw/cs553x_nand.c
@@ -251,11 +251,7 @@ static int cs553x_attach_chip(struct nan
 	chip->ecc.bytes = 3;
 	chip->ecc.hwctl  = cs_enable_hwecc;
 	chip->ecc.calculate = cs_calculate_ecc;
-<<<<<<< HEAD
-	chip->ecc.correct  = nand_correct_data;
-=======
 	chip->ecc.correct  = rawnand_sw_hamming_correct;
->>>>>>> linux-next/akpm-base
 	chip->ecc.strength = 1;
 
 	return 0;
--- a/drivers/mtd/nand/raw/davinci_nand.c~linux-next-git-rejects
+++ a/drivers/mtd/nand/raw/davinci_nand.c
@@ -586,17 +586,10 @@ static int davinci_nand_attach_chip(stru
 		return PTR_ERR(pdata);
 
 	/* Use board-specific ECC config */
-<<<<<<< HEAD
-	info->chip.ecc.engine_type = pdata->engine_type;
-	info->chip.ecc.placement = pdata->ecc_placement;
-
-	switch (info->chip.ecc.engine_type) {
-=======
 	chip->ecc.engine_type = pdata->engine_type;
 	chip->ecc.placement = pdata->ecc_placement;
 
 	switch (chip->ecc.engine_type) {
->>>>>>> linux-next/akpm-base
 	case NAND_ECC_ENGINE_TYPE_NONE:
 		pdata->ecc_bits = 0;
 		break;
--- a/drivers/mtd/nand/raw/fsmc_nand.c~linux-next-git-rejects
+++ a/drivers/mtd/nand/raw/fsmc_nand.c
@@ -917,11 +917,7 @@ static int fsmc_nand_attach_chip(struct
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
 		dev_info(host->dev, "Using 1-bit HW ECC scheme\n");
 		nand->ecc.calculate = fsmc_read_hwecc_ecc1;
-<<<<<<< HEAD
-		nand->ecc.correct = nand_correct_data;
-=======
 		nand->ecc.correct = rawnand_sw_hamming_correct;
->>>>>>> linux-next/akpm-base
 		nand->ecc.hwctl = fsmc_enable_hwecc;
 		nand->ecc.bytes = 3;
 		nand->ecc.strength = 1;
--- a/drivers/mtd/nand/raw/lpc32xx_slc.c~linux-next-git-rejects
+++ a/drivers/mtd/nand/raw/lpc32xx_slc.c
@@ -802,11 +802,7 @@ static int lpc32xx_nand_attach_chip(stru
 	chip->ecc.write_oob = lpc32xx_nand_write_oob_syndrome;
 	chip->ecc.read_oob = lpc32xx_nand_read_oob_syndrome;
 	chip->ecc.calculate = lpc32xx_nand_ecc_calculate;
-<<<<<<< HEAD
-	chip->ecc.correct = nand_correct_data;
-=======
 	chip->ecc.correct = rawnand_sw_hamming_correct;
->>>>>>> linux-next/akpm-base
 	chip->ecc.hwctl = lpc32xx_nand_ecc_enable;
 
 	/*
--- a/drivers/mtd/nand/raw/sharpsl.c~linux-next-git-rejects
+++ a/drivers/mtd/nand/raw/sharpsl.c
@@ -106,11 +106,7 @@ static int sharpsl_attach_chip(struct na
 	chip->ecc.strength = 1;
 	chip->ecc.hwctl = sharpsl_nand_enable_hwecc;
 	chip->ecc.calculate = sharpsl_nand_calculate_ecc;
-<<<<<<< HEAD
-	chip->ecc.correct = nand_correct_data;
-=======
 	chip->ecc.correct = rawnand_sw_hamming_correct;
->>>>>>> linux-next/akpm-base
 
 	return 0;
 }
--- a/drivers/net/can/usb/gs_usb.c~linux-next-git-rejects
+++ a/drivers/net/can/usb/gs_usb.c
@@ -510,16 +510,10 @@ static netdev_tx_t gs_can_start_xmit(str
 
 	cf = (struct can_frame *)skb->data;
 
-<<<<<<< HEAD
-	hf->can_id = cpu_to_le32(cf->can_id);
-	hf->can_dlc = cf->can_dlc;
-	memcpy(hf->data, cf->data, cf->can_dlc);
-=======
 	hf->can_id = cf->can_id;
 	hf->can_dlc = can_get_cc_dlc(cf, dev->can.ctrlmode);
 
 	memcpy(hf->data, cf->data, cf->len);
->>>>>>> linux-next/akpm-base
 
 	usb_fill_bulk_urb(urb, dev->udev,
 			  usb_sndbulkpipe(dev->udev, GSUSB_ENDPOINT_OUT),
--- a/fs/btrfs/inode.c~linux-next-git-rejects
+++ a/fs/btrfs/inode.c
@@ -2348,13 +2348,8 @@ static int btrfs_find_new_delalloc_bytes
 
 		ret = set_extent_bit(&inode->io_tree, search_start,
 				     search_start + em_len - 1,
-<<<<<<< HEAD
-				     EXTENT_DELALLOC_NEW,
-				     NULL, cached_state, GFP_NOFS);
-=======
 				     EXTENT_DELALLOC_NEW, 0, NULL, cached_state,
 				     GFP_NOFS, NULL);
->>>>>>> linux-next/akpm-base
 next:
 		search_start = extent_map_end(em);
 		free_extent_map(em);
--- a/include/linux/platform_data/ti-sysc.h~linux-next-git-rejects
+++ a/include/linux/platform_data/ti-sysc.h
@@ -50,10 +50,7 @@ struct sysc_regbits {
 	s8 emufree_shift;
 };
 
-<<<<<<< HEAD
-=======
 #define SYSC_QUIRK_GPMC_DEBUG		BIT(26)
->>>>>>> linux-next/akpm-base
 #define SYSC_MODULE_QUIRK_ENA_RESETDONE	BIT(25)
 #define SYSC_MODULE_QUIRK_PRUSS		BIT(24)
 #define SYSC_MODULE_QUIRK_DSS_RESET	BIT(23)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

