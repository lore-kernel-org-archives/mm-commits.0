Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D012C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  8 Apr 2022 17:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbiDHRqf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 8 Apr 2022 13:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiDHRqe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Apr 2022 13:46:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F254726F7
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 10:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB30FB82A16
        for <mm-commits@vger.kernel.org>; Fri,  8 Apr 2022 17:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659E1C385A3;
        Fri,  8 Apr 2022 17:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649439867;
        bh=dusbQkuHsogVxYO63WSVe3btL5w5XZW+szgH9TEidqE=;
        h=Date:To:From:Subject:From;
        b=kqXyq/yRNFtoLnXTvlOK3KTftUEFJ9PaYoMqkvqIFqXYg78wxapAxzH2k3qfbptLT
         vbVApE/lfOt+lm/rpjT7P65TLSZHWj7XFZQhUfF1D5Zo6D5hruASJ3gc9U76q4pjUD
         Y9BW1UFqwpkE+m52EL8J4micEIvBQwFbyrcf1lDQ=
Date:   Fri, 08 Apr 2022 10:44:26 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + linux-next-git-rejects.patch added to -mm tree
Message-Id: <20220408174427.659E1C385A3@smtp.kernel.org>
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

mm-list_lruc-revert-mm-list_lru-optimize-memcg_reparent_list_lru_node.patch
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
linux-next-git-rejects.patch

