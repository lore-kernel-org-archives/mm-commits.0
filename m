Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60E0DC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 24 Apr 2022 20:17:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239576AbiDXUUy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 24 Apr 2022 16:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239573AbiDXUUy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 24 Apr 2022 16:20:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7EB12607
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 13:17:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 314496126B
        for <mm-commits@vger.kernel.org>; Sun, 24 Apr 2022 20:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCD3C385A7;
        Sun, 24 Apr 2022 20:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650831471;
        bh=t9yMtXNFMb2PYL28v0RtljTV4o8hni2KTFYWzy8CREo=;
        h=Date:To:From:Subject:From;
        b=Q5/22oMWIqGpTFr95+2vw6fq/kCX2/cn7517m/CXVaTi7i5X+e4L7OdLzMpigm3US
         XPDtItSjUwe7d36nPJPuvrSheoZA8+eftMlOzd+Wqd7vSssyz+oGFcJ7ns8aZL7jBV
         4egUwnDgn5skYwkPFBD8NFeV8nuEvljVLRHZQ/P4=
Date:   Sun, 24 Apr 2022 13:17:50 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-next-git-rejects.patch added to -mm tree
Message-Id: <20220424201751.7CCD3C385A7@smtp.kernel.org>
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

 drivers/gpu/drm/radeon/radeon_sync.c |    4 
 fs/io_uring.c                        |   12 -
 sound/soc/atmel/sam9g20_wm8731.c     |    5 
 sound/soc/codecs/cs35l41-lib.c       |    4 
 sound/soc/codecs/wm8731.c            |  178 -------------------------
 5 files changed, 203 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_sync.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/radeon/radeon_sync.c
@@ -96,11 +96,7 @@ int radeon_sync_resv(struct radeon_devic
 	struct dma_fence *f;
 	int r = 0;
 
-<<<<<<< HEAD
-	dma_resv_for_each_fence(&cursor, resv, !shared, f) {
-=======
 	dma_resv_for_each_fence(&cursor, resv, dma_resv_usage_rw(shared), f) {
->>>>>>> linux-next/akpm-base
 		fence = to_radeon_fence(f);
 		if (fence && fence->rdev == rdev)
 			radeon_sync_fence(sync, fence);
--- a/fs/io_uring.c~linux-next-git-rejects
+++ a/fs/io_uring.c
@@ -2944,11 +2944,7 @@ static int io_do_iopoll(struct io_ring_c
 		nr_events++;
 		if (unlikely(req->flags & REQ_F_CQE_SKIP))
 			continue;
-<<<<<<< HEAD
-		__io_fill_cqe_req(req, req->result, io_put_kbuf(req, 0));
-=======
 		__io_fill_cqe_req(req, req->cqe.res, io_put_kbuf(req, 0));
->>>>>>> linux-next/akpm-base
 	}
 
 	if (unlikely(!nr_events))
@@ -3967,11 +3963,7 @@ static int io_read(struct io_kiocb *req,
 		kfree(iovec);
 		return ret;
 	}
-<<<<<<< HEAD
-	req->result = iov_iter_count(&s->iter);
-=======
 	req->cqe.res = iov_iter_count(&s->iter);
->>>>>>> linux-next/akpm-base
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
@@ -4099,11 +4091,7 @@ static int io_write(struct io_kiocb *req
 		kfree(iovec);
 		return ret;
 	}
-<<<<<<< HEAD
-	req->result = iov_iter_count(&s->iter);
-=======
 	req->cqe.res = iov_iter_count(&s->iter);
->>>>>>> linux-next/akpm-base
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
--- a/sound/soc/atmel/sam9g20_wm8731.c~linux-next-git-rejects
+++ a/sound/soc/atmel/sam9g20_wm8731.c
@@ -127,13 +127,8 @@ static int at91sam9g20ek_audio_probe(str
 
 	ret = atmel_ssc_set_audio(0);
 	if (ret) {
-<<<<<<< HEAD
-		dev_err(&pdev->dev, "ssc channel is not valid\n");
-		return -EINVAL;
-=======
 		dev_err(&pdev->dev, "ssc channel is not valid: %d\n", ret);
 		return ret;
->>>>>>> linux-next/akpm-base
 	}
 
 	card->dev = &pdev->dev;
--- a/sound/soc/codecs/cs35l41-lib.c~linux-next-git-rejects
+++ a/sound/soc/codecs/cs35l41-lib.c
@@ -822,11 +822,7 @@ int cs35l41_otp_unpack(struct device *de
 	word_offset = otp_map_match->word_offset;
 
 	for (i = 0; i < otp_map_match->num_elements; i++) {
-<<<<<<< HEAD
-		dev_dbg(dev, "bitoffset= %d, word_offset=%d, bit_sum mod 32=%d otp_map[i].size = %d\n",
-=======
 		dev_dbg(dev, "bitoffset= %d, word_offset=%d, bit_sum mod 32=%d, otp_map[i].size = %u\n",
->>>>>>> linux-next/akpm-base
 			bit_offset, word_offset, bit_sum % 32, otp_map[i].size);
 		if (bit_offset + otp_map[i].size - 1 >= 32) {
 			otp_val = (otp_mem[word_offset] &
--- a/sound/soc/codecs/wm8731.c~linux-next-git-rejects
+++ a/sound/soc/codecs/wm8731.c
@@ -619,9 +619,6 @@ int wm8731_init(struct device *dev, stru
 
 	regcache_mark_dirty(wm8731->regmap);
 
-<<<<<<< HEAD
-err:
-=======
 	ret = devm_snd_soc_register_component(dev,
 			&soc_component_dev_wm8731, &wm8731_dai, 1);
 	if (ret != 0) {
@@ -635,7 +632,6 @@ err_regulator_enable:
 	/* Regulators will be enabled by bias management */
 	regulator_bulk_disable(ARRAY_SIZE(wm8731->supplies), wm8731->supplies);
 
->>>>>>> linux-next/akpm-base
 	return ret;
 }
 EXPORT_SYMBOL_GPL(wm8731_init);
@@ -651,181 +647,7 @@ const struct regmap_config wm8731_regmap
 	.reg_defaults = wm8731_reg_defaults,
 	.num_reg_defaults = ARRAY_SIZE(wm8731_reg_defaults),
 };
-<<<<<<< HEAD
-
-#if defined(CONFIG_SPI_MASTER)
-static int wm8731_spi_probe(struct spi_device *spi)
-{
-	struct wm8731_priv *wm8731;
-	int ret;
-
-	wm8731 = devm_kzalloc(&spi->dev, sizeof(*wm8731), GFP_KERNEL);
-	if (wm8731 == NULL)
-		return -ENOMEM;
-
-	wm8731->mclk = devm_clk_get(&spi->dev, "mclk");
-	if (IS_ERR(wm8731->mclk)) {
-		ret = PTR_ERR(wm8731->mclk);
-		if (ret == -ENOENT) {
-			wm8731->mclk = NULL;
-			dev_warn(&spi->dev, "Assuming static MCLK\n");
-		} else {
-			dev_err(&spi->dev, "Failed to get MCLK: %d\n",
-				ret);
-			return ret;
-		}
-	}
-
-	mutex_init(&wm8731->lock);
-
-	spi_set_drvdata(spi, wm8731);
-
-	ret = wm8731_request_supplies(&spi->dev, wm8731);
-	if (ret != 0)
-		return ret;
-
-	wm8731->regmap = devm_regmap_init_spi(spi, &wm8731_regmap);
-	if (IS_ERR(wm8731->regmap)) {
-		ret = PTR_ERR(wm8731->regmap);
-		dev_err(&spi->dev, "Failed to allocate register map: %d\n",
-			ret);
-		return ret;
-	}
-
-	ret = wm8731_hw_init(&spi->dev, wm8731);
-	if (ret != 0)
-		return ret;
-
-	ret = devm_snd_soc_register_component(&spi->dev,
-			&soc_component_dev_wm8731, &wm8731_dai, 1);
-	if (ret != 0) {
-		dev_err(&spi->dev, "Failed to register CODEC: %d\n", ret);
-		return ret;
-	}
-
-	return 0;
-}
-
-static struct spi_driver wm8731_spi_driver = {
-	.driver = {
-		.name	= "wm8731",
-		.of_match_table = wm8731_of_match,
-	},
-	.probe		= wm8731_spi_probe,
-};
-#endif /* CONFIG_SPI_MASTER */
-
-#if IS_ENABLED(CONFIG_I2C)
-static int wm8731_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
-{
-	struct wm8731_priv *wm8731;
-	int ret;
-
-	wm8731 = devm_kzalloc(&i2c->dev, sizeof(struct wm8731_priv),
-			      GFP_KERNEL);
-	if (wm8731 == NULL)
-		return -ENOMEM;
-
-	wm8731->mclk = devm_clk_get(&i2c->dev, "mclk");
-	if (IS_ERR(wm8731->mclk)) {
-		ret = PTR_ERR(wm8731->mclk);
-		if (ret == -ENOENT) {
-			wm8731->mclk = NULL;
-			dev_warn(&i2c->dev, "Assuming static MCLK\n");
-		} else {
-			dev_err(&i2c->dev, "Failed to get MCLK: %d\n",
-				ret);
-			return ret;
-		}
-	}
-
-	mutex_init(&wm8731->lock);
-
-	i2c_set_clientdata(i2c, wm8731);
-
-	ret = wm8731_request_supplies(&i2c->dev, wm8731);
-	if (ret != 0)
-		return ret;
-
-	wm8731->regmap = devm_regmap_init_i2c(i2c, &wm8731_regmap);
-	if (IS_ERR(wm8731->regmap)) {
-		ret = PTR_ERR(wm8731->regmap);
-		dev_err(&i2c->dev, "Failed to allocate register map: %d\n",
-			ret);
-		goto err_regulator_enable;
-	}
-
-	ret = wm8731_hw_init(&i2c->dev, wm8731);
-	if (ret != 0)
-		goto err_regulator_enable;
-
-	ret = devm_snd_soc_register_component(&i2c->dev,
-			&soc_component_dev_wm8731, &wm8731_dai, 1);
-	if (ret != 0) {
-		dev_err(&i2c->dev, "Failed to register CODEC: %d\n", ret);
-		goto err_regulator_enable;
-	}
-
-	return 0;
-
-err_regulator_enable:
-	/* Regulators will be enabled by bias management */
-	regulator_bulk_disable(ARRAY_SIZE(wm8731->supplies), wm8731->supplies);
-
-	return ret;
-}
-
-static const struct i2c_device_id wm8731_i2c_id[] = {
-	{ "wm8731", 0 },
-	{ }
-};
-MODULE_DEVICE_TABLE(i2c, wm8731_i2c_id);
-
-static struct i2c_driver wm8731_i2c_driver = {
-	.driver = {
-		.name = "wm8731",
-		.of_match_table = wm8731_of_match,
-	},
-	.probe =    wm8731_i2c_probe,
-	.id_table = wm8731_i2c_id,
-};
-#endif
-
-static int __init wm8731_modinit(void)
-{
-	int ret = 0;
-#if IS_ENABLED(CONFIG_I2C)
-	ret = i2c_add_driver(&wm8731_i2c_driver);
-	if (ret != 0) {
-		printk(KERN_ERR "Failed to register WM8731 I2C driver: %d\n",
-		       ret);
-	}
-#endif
-#if defined(CONFIG_SPI_MASTER)
-	ret = spi_register_driver(&wm8731_spi_driver);
-	if (ret != 0) {
-		printk(KERN_ERR "Failed to register WM8731 SPI driver: %d\n",
-		       ret);
-	}
-#endif
-	return ret;
-}
-module_init(wm8731_modinit);
-
-static void __exit wm8731_exit(void)
-{
-#if IS_ENABLED(CONFIG_I2C)
-	i2c_del_driver(&wm8731_i2c_driver);
-#endif
-#if defined(CONFIG_SPI_MASTER)
-	spi_unregister_driver(&wm8731_spi_driver);
-#endif
-}
-module_exit(wm8731_exit);
-=======
 EXPORT_SYMBOL_GPL(wm8731_regmap);
->>>>>>> linux-next/akpm-base
 
 MODULE_DESCRIPTION("ASoC WM8731 driver");
 MODULE_AUTHOR("Richard Purdie");
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
kasan-fix-sleeping-function-called-from-invalid-context-on-rt-kernel-fix.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
mm-check-against-orig_pte-for-finish_fault-fix-checkpatch-fixes.patch
mm-hugetlb-only-drop-uffd-wp-special-pte-if-required-fix-fix.patch
mm-vmscan-fix-comment-for-current_may_throttle-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
linux-next-git-rejects.patch

