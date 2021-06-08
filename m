Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52F7AC47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 20:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 369BC6108D
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 20:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234695AbhFHUNe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 16:13:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:53808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232764AbhFHUNe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 16:13:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F01460FE9;
        Tue,  8 Jun 2021 20:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623183101;
        bh=nCJwt7VYhcK1x2/kxUoTsC5YptlGNXeWvCwaSK3+n/M=;
        h=Date:From:To:Subject:From;
        b=XQPVE+zE+m/JzvkDRZ57na1zSEqhMggq5uHPTxqP1Ty4sVPVgXXEeQ8HfIq7gwkZK
         krutkmZQLdsx5G4E2qb4oXrOH+mxFp7jby7GQjvodobNJzZubULpXdalbaQsm5yIE5
         GVShDTg2DdEZH0dn+tUhh1/dYHQVypDFEeRR3WVE=
Date:   Tue, 08 Jun 2021 13:11:40 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + linux-next-git-rejects.patch added to -mm tree
Message-ID: <20210608201140.gGJ3HkHpn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/fan53555.c |   11 -----------
 drivers/spi/spi-bcm2835.c    |   11 -----------
 drivers/spi/spi-pxa2xx.c     |    6 ------
 3 files changed, 28 deletions(-)

--- a/drivers/regulator/fan53555.c~linux-next-git-rejects
+++ a/drivers/regulator/fan53555.c
@@ -343,16 +343,6 @@ static int fan53555_voltages_setup_siler
 
 static int fan53526_voltages_setup_tcs(struct fan53555_device_info *di)
 {
-<<<<<<< HEAD
-	di->slew_reg = TCS4525_TIME;
-	di->slew_mask = TCS_SLEW_MASK;
-	di->slew_shift = TCS_SLEW_MASK;
-
-	/* Init voltage range and step */
-	di->vsel_min = 600000;
-	di->vsel_step = 6250;
-	di->vsel_count = FAN53526_NVOLTAGES;
-=======
 	switch (di->chip_id) {
 	case TCS4525_CHIP_ID_12:
 	case TCS4526_CHIP_ID_00:
@@ -370,7 +360,6 @@ static int fan53526_voltages_setup_tcs(s
 		dev_err(di->dev, "Chip ID %d not supported!\n", di->chip_id);
 		return -EINVAL;
 	}
->>>>>>> linux-next/akpm-base
 
 	return 0;
 }
--- a/drivers/spi/spi-bcm2835.c~linux-next-git-rejects
+++ a/drivers/spi/spi-bcm2835.c
@@ -68,10 +68,6 @@
 #define BCM2835_SPI_FIFO_SIZE		64
 #define BCM2835_SPI_FIFO_SIZE_3_4	48
 #define BCM2835_SPI_DMA_MIN_LENGTH	96
-<<<<<<< HEAD
-#define BCM2835_SPI_NUM_CS		24  /* raise as necessary */
-=======
->>>>>>> linux-next/akpm-base
 #define BCM2835_SPI_MODE_BITS	(SPI_CPOL | SPI_CPHA | SPI_CS_HIGH \
 				| SPI_NO_CS | SPI_3WIRE)
 
@@ -1220,12 +1216,6 @@ static int bcm2835_spi_setup(struct spi_
 	int ret;
 	u32 cs;
 
-<<<<<<< HEAD
-	if (spi->chip_select >= BCM2835_SPI_NUM_CS) {
-		dev_err(&spi->dev, "only %d chip-selects supported\n",
-			BCM2835_SPI_NUM_CS - 1);
-		return -EINVAL;
-=======
 	if (!slv) {
 		slv = kzalloc(ALIGN(sizeof(*slv), dma_get_cache_alignment()),
 			      GFP_KERNEL);
@@ -1237,7 +1227,6 @@ static int bcm2835_spi_setup(struct spi_
 		ret = bcm2835_spi_setup_dma(ctlr, spi, bs, slv);
 		if (ret)
 			goto err_cleanup;
->>>>>>> linux-next/akpm-base
 	}
 
 	/*
--- a/drivers/spi/spi-pxa2xx.c~linux-next-git-rejects
+++ a/drivers/spi/spi-pxa2xx.c
@@ -1236,13 +1236,7 @@ static int setup_cs(struct spi_device *s
 			return err;
 		}
 
-<<<<<<< HEAD
-		err = gpiod_direction_output(gpiod, !chip->gpio_cs_inverted);
-		if (err)
-			gpiod_put(chip->gpiod_cs);
-=======
 		spi->cs_gpio = gpio;
->>>>>>> linux-next/akpm-base
 	}
 
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality-fix-2.patch
slub-force-on-no_hash_pointers-when-slub_debug-is-enabled-fix.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-checkpatch-fixes.patch
mm-memcg-optimize-user-context-object-stock-access-checkpatch-fixes.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-v5-fix.patch
binfmt-remove-in-tree-usage-of-map_executable-fix.patch
mm-mmap-introduce-unlock_range-for-code-cleanup-fix.patch
lazy-tlb-allow-lazy-tlb-mm-refcounting-to-be-configurable-fix.patch
mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix-checkpatch-fixes.patch
mm-memory-failure-use-a-mutex-to-avoid-memory_failure-races-fix.patch
mm-memory_hotplug-disable-memmap_on_memory-when-hugetlb_free_vmemmap-enabled-fix.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork-fix.patch
nommu-remove-__gfp_highmem-in-vmalloc-vzalloc-checkpatch-fixes.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables-checkpatch-fixes.patch
mmmemory_hotplug-drop-unneeded-locking-fix.patch
fs-proc-kcorec-add-mmap-interface-fix.patch
kernelh-split-out-panic-and-oops-helpers-fix.patch
lib-math-rational-add-kunit-test-cases-fix.patch
lib-decompressors-remove-set-but-not-used-variabled-level-fix.patch
ipc-utilc-use-binary-search-for-max_idx-fix.patch
linux-next-pre.patch
linux-next-post.patch
linux-next-rejects.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix.patch
module-add-printk-formats-to-add-module-build-id-to-stacktraces-fix-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-git-rejects.patch

