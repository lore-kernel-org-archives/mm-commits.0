Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4126C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 11 Apr 2022 23:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiDKXE7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Apr 2022 19:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiDKXE6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Apr 2022 19:04:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76B61ADB9
        for <mm-commits@vger.kernel.org>; Mon, 11 Apr 2022 16:02:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BE42B819A7
        for <mm-commits@vger.kernel.org>; Mon, 11 Apr 2022 23:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FD1C385A3;
        Mon, 11 Apr 2022 23:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649718161;
        bh=k0A0fZnZGFK7AivLxlmrYTTAmKtgBQcKAz9HfkWJ2MA=;
        h=Date:To:From:Subject:From;
        b=xP37M2CmcHqVM6YDELNT20cAF0IT+rwqzdHtLVf8BYzjo9H6lwZe6p6kiHSAoyK1l
         AdJIAW8p4wQYLJ4LAXu5RIuxayF7wmWcujG/6A7Nlu0ANtrjEi9eZuUFtSN+6bjkFW
         3MvPL8OZExa6QStElpRK/Lfg/c25pcLL0nUduiuc=
Date:   Mon, 11 Apr 2022 16:02:40 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Message-Id: <20220411230240.F2FD1C385A3@smtp.kernel.org>
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

 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c |    3 ---
 drivers/mmc/host/mmci_stm32_sdmmc.c                       |    8 --------
 2 files changed, 11 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c
@@ -1495,13 +1495,10 @@ void dcn10_init_hw(struct dc *dc)
 		if (link->link_enc->funcs->is_dig_enabled &&
 			link->link_enc->funcs->is_dig_enabled(link->link_enc)) {
 			link->link_status.link_active = true;
-<<<<<<< HEAD
-=======
 			if (link->link_enc->funcs->fec_is_active &&
 					link->link_enc->funcs->fec_is_active(link->link_enc))
 				link->fec_state = dc_link_fec_enabled;
 		}
->>>>>>> linux-next/akpm-base
 	}
 
 	/* we want to turn off all dp displays before doing detection */
--- a/drivers/mmc/host/mmci_stm32_sdmmc.c~linux-next-git-rejects
+++ a/drivers/mmc/host/mmci_stm32_sdmmc.c
@@ -70,11 +70,7 @@ static int sdmmc_idma_validate_data(stru
 	for_each_sg(data->sg, sg, data->sg_len - 1, i) {
 		if (!IS_ALIGNED(sg->offset, sizeof(u32)) ||
 		    !IS_ALIGNED(sg->length, SDMMC_IDMA_BURST)) {
-<<<<<<< HEAD
-			dev_err(mmc_dev(host->mmc),
-=======
 			dev_dbg(mmc_dev(host->mmc),
->>>>>>> linux-next/akpm-base
 				"unaligned scatterlist: ofst:%x length:%d\n",
 				data->sg->offset, data->sg->length);
 			goto use_bounce_buffer;
@@ -82,11 +78,7 @@ static int sdmmc_idma_validate_data(stru
 	}
 
 	if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
-<<<<<<< HEAD
-		dev_err(mmc_dev(host->mmc),
-=======
 		dev_dbg(mmc_dev(host->mmc),
->>>>>>> linux-next/akpm-base
 			"unaligned last scatterlist: ofst:%x length:%d\n",
 			data->sg->offset, data->sg->length);
 		goto use_bounce_buffer;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-create-new-mm-swaph-header-file-fix.patch
mm-shmem-make-shmem_init-return-void-fix.patch
ksm-count-ksm-merging-pages-for-each-process-fix.patch
mm-memory_hotplug-refactor-hotadd_init_pgdat-and-try_online_node-checkpatch-fixes.patch
proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
fs-proc-kcorec-remove-check-of-list-iterator-against-head-past-the-loop-body-fix.patch
add-fat-messages-to-printk-index-checkpatch-fixes.patch
linux-next-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch

