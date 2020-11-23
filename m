Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB491C2D0E4
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 18:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 775A92075A
	for <mm-commits@archiver.kernel.org>; Mon, 23 Nov 2020 18:02:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GvLtDcLL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbgKWSCJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 23 Nov 2020 13:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:55244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728717AbgKWSCJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Nov 2020 13:02:09 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1545B206B2;
        Mon, 23 Nov 2020 18:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606154528;
        bh=OnA0xsLOfbHWRBkHlWDdpiQh9T8u1jkFy1SlEtlW7qA=;
        h=Date:From:To:Subject:From;
        b=GvLtDcLLClBslXDNXdUjNtEmTgreDOYIdFR/VwTGXM5wxkfsdh+gBw3xwaGP4vMCq
         CNJizhsQmHhbaJ+hGdqJMYEeCdcRG3RiopuMKDJQ6uEa0Nl56Jo1oEfX1qc+hplJvd
         iZ0I50PgFrd+FIQVJn4ibsWsMcBL8gLZqCOVvVyU=
Date:   Mon, 23 Nov 2020 10:02:07 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20201123180207.owbtNDY17%akpm@linux-foundation.org>
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

 drivers/dma/idxd/device.c    |    5 -----
 drivers/dma/idxd/registers.h |    6 ------
 drivers/dma/idxd/submit.c    |    4 ----
 sound/soc/intel/catpt/pcm.c  |    7 -------
 4 files changed, 22 deletions(-)

--- a/drivers/dma/idxd/device.c~linux-next-git-rejects
+++ a/drivers/dma/idxd/device.c
@@ -616,10 +616,6 @@ static int idxd_wq_config_write(struct i
 
 	/* byte 8-11 */
 	wq->wqcfg->priv = !!(wq->type == IDXD_WQT_KERNEL);
-<<<<<<< HEAD
-	wq->wqcfg->mode = 1;
-	wq->wqcfg->priority = wq->priority;
-=======
 	if (wq_dedicated(wq))
 		wq->wqcfg->mode = 1;
 
@@ -634,7 +630,6 @@ static int idxd_wq_config_write(struct i
 	if (idxd->hw.gen_cap.block_on_fault &&
 	    test_bit(WQ_FLAG_BLOCK_ON_FAULT, &wq->flags))
 		wq->wqcfg->bof = 1;
->>>>>>> linux-next/akpm-base
 
 	/* bytes 12-15 */
 	wq->wqcfg->max_xfer_shift = ilog2(wq->max_xfer_bytes);
--- a/drivers/dma/idxd/registers.h~linux-next-git-rejects
+++ a/drivers/dma/idxd/registers.h
@@ -338,11 +338,8 @@ union wqcfg {
 	u32 bits[8];
 } __packed;
 
-<<<<<<< HEAD
-=======
 #define WQCFG_PASID_IDX                2
 
->>>>>>> linux-next/akpm-base
 /*
  * This macro calculates the offset into the WQCFG register
  * idxd - struct idxd *
@@ -361,8 +358,6 @@ union wqcfg {
 
 #define WQCFG_STRIDES(_idxd_dev) ((_idxd_dev)->wqcfg_size / sizeof(u32))
 
-<<<<<<< HEAD
-=======
 #define GRPCFG_SIZE		64
 #define GRPWQCFG_STRIDES	4
 
@@ -381,5 +376,4 @@ union wqcfg {
 #define GRPENGCFG_OFFSET(idxd_dev, n) ((idxd_dev)->grpcfg_offset + (n) * GRPCFG_SIZE + 32)
 #define GRPFLGCFG_OFFSET(idxd_dev, n) ((idxd_dev)->grpcfg_offset + (n) * GRPCFG_SIZE + 40)
 
->>>>>>> linux-next/akpm-base
 #endif
--- a/drivers/dma/idxd/submit.c~linux-next-git-rejects
+++ a/drivers/dma/idxd/submit.c
@@ -86,12 +86,8 @@ int idxd_submit_desc(struct idxd_wq *wq,
 	if (idxd->state != IDXD_DEV_ENABLED)
 		return -EIO;
 
-<<<<<<< HEAD
-	portal = wq->dportal;
-=======
 	portal = wq->portal;
 
->>>>>>> linux-next/akpm-base
 	/*
 	 * The wmb() flushes writes to coherent DMA data before
 	 * possibly triggering a DMA read. The wmb() is necessary
--- a/sound/soc/intel/catpt/pcm.c~linux-next-git-rejects
+++ a/sound/soc/intel/catpt/pcm.c
@@ -462,13 +462,6 @@ static int catpt_dai_prepare(struct snd_
 	if (ret)
 		return CATPT_IPC_ERROR(ret);
 
-<<<<<<< HEAD
-	ret = catpt_dai_apply_usettings(dai, stream);
-	if (ret)
-		return ret;
-
-=======
->>>>>>> linux-next/akpm-base
 	stream->prepared = true;
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

