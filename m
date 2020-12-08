Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1510C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 00:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80DAF23A50
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 00:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgLHAqh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 19:46:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:59742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgLHAqh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Dec 2020 19:46:37 -0500
Date:   Mon, 07 Dec 2020 16:45:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607388350;
        bh=A1JZb8rOkclU4QuRp/DgfPstk7Lt8eAiMD2ZNos5RYE=;
        h=From:To:Subject:From;
        b=BRu1tYUkBhLY+9B/K4XABGt9huv/t1AOIl23C0yUzex0YB5PkhJJYVQT4G90wECur
         tkAf0RMPW0cVb/zDfJQlhl+63m/CJ465Qr/JyiFwUBiYJYlq7QupeKJ/ihgnpXaMD8
         A1kk7gecdiAfBkGvjm1Zxt5CNJ5DvW2ieB/SSQ3A=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  [obsolete] linux-next-git-rejects.patch removed from -mm
 tree
Message-ID: <20201208004549.dF2WVqNXG%akpm@linux-foundation.org>
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

 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c |   12 ----------
 drivers/md/dm.c                                           |   11 ---------
 drivers/net/ethernet/ibm/ibmvnic.c                        |   10 --------
 3 files changed, 33 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c~linux-next-git-rejects
+++ a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -195,18 +195,6 @@ void rn_update_clocks(struct clk_mgr *cl
 		new_clocks->dispclk_khz = clk_mgr_base->clks.dispclk_khz;
 	}
 
-<<<<<<< HEAD
-	/*
-	 * Temporally ignore thew 0 cases for disp and dpp clks.
-	 * We may have a new feature that requires 0 clks in the future.
-	 */
-	if (new_clocks->dppclk_khz == 0 || new_clocks->dispclk_khz == 0) {
-		new_clocks->dppclk_khz = clk_mgr_base->clks.dppclk_khz;
-		new_clocks->dispclk_khz = clk_mgr_base->clks.dispclk_khz;
-	}
-
-=======
->>>>>>> linux-next/akpm-base
 	if (should_set_clock(safe_to_lower, new_clocks->dppclk_khz, clk_mgr_base->clks.dppclk_khz)) {
 		if (clk_mgr_base->clks.dppclk_khz > new_clocks->dppclk_khz)
 			dpp_clock_lowered = true;
--- a/drivers/md/dm.c~linux-next-git-rejects
+++ a/drivers/md/dm.c
@@ -1043,16 +1043,6 @@ static sector_t max_io_len(struct dm_tar
 	 * Does the target need to split IO even further?
 	 * - varied (per target) IO splitting is a tenet of DM; this
 	 *   explains why stacked chunk_sectors based splitting via
-<<<<<<< HEAD
-	 *   blk_max_size_offset() isn't possible here. So pass in
-	 *   ti->max_io_len to override stacked chunk_sectors.
-	 */
-	if (ti->max_io_len) {
-		max_len = blk_max_size_offset(ti->table->md->queue,
-					      target_offset, ti->max_io_len);
-		if (len > max_len)
-			len = max_len;
-=======
 	 *   blk_max_size_offset() isn't possible here.
 	 */
 	if (max_io_len) {
@@ -1063,7 +1053,6 @@ static sector_t max_io_len(struct dm_tar
 
 		if (len > max_io_len)
 			len = max_io_len;
->>>>>>> linux-next/akpm-base
 	}
 
 	return len;
--- a/drivers/net/ethernet/ibm/ibmvnic.c~linux-next-git-rejects
+++ a/drivers/net/ethernet/ibm/ibmvnic.c
@@ -2499,11 +2499,7 @@ restart_poll:
 		 * holds a valid descriptor before reading its contents.
 		 */
 		dma_rmb();
-<<<<<<< HEAD
-		next = ibmvnic_next_scrq(adapter, adapter->rx_scrq[scrq_num]);
-=======
 		next = ibmvnic_next_scrq(adapter, rx_scrq);
->>>>>>> linux-next/akpm-base
 		rx_buff =
 		    (struct ibmvnic_rx_buff *)be64_to_cpu(next->
 							  rx_comp.correlator);
@@ -2978,18 +2974,12 @@ static int reset_one_sub_crq_queue(struc
 		irq_dispose_mapping(scrq->irq);
 		scrq->irq = 0;
 	}
-<<<<<<< HEAD
-=======
 
->>>>>>> linux-next/akpm-base
 	if (scrq->msgs) {
 		memset(scrq->msgs, 0, 4 * PAGE_SIZE);
 		atomic_set(&scrq->used, 0);
 		scrq->cur = 0;
-<<<<<<< HEAD
-=======
 		scrq->ind_buf.index = 0;
->>>>>>> linux-next/akpm-base
 	} else {
 		netdev_dbg(adapter->netdev, "Invalid scrq reset\n");
 		return -EINVAL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

