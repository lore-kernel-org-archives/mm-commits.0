Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04744C00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239743AbiG3BN0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239698AbiG3BNQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:13:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F530261A
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B98561C3A
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D516C433D7;
        Sat, 30 Jul 2022 01:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143594;
        bh=JApPul8pvyrhE+FTbKlYMA3Sur64aX6OZEY830IJhHQ=;
        h=Date:To:From:Subject:From;
        b=Bw4Yd7Z9u+0rvsfFQMJRODH2AwqbcklKsyJwrCVlwUYyDIFQCfnBf06A2D34fGPqm
         pw6jOp4R2U6AcQ40LLfyAsf6Smrd/mMiGMS+KtGpT81rMY81qWFx1E3FB2W/M9zz/J
         LUw0lVajNK9896a3BgZYOzD11Iw9ikT33oueMHtc=
Date:   Fri, 29 Jul 2022 18:13:13 -0700
To:     mm-commits@vger.kernel.org, neilb@suse.de, jack@suse.cz,
        xiujianfeng@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] bdi-remove-enum-wb_congested_state.patch removed from -mm tree
Message-Id: <20220730011314.6D516C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: bdi: remove enum wb_congested_state
has been removed from the -mm tree.  Its filename was
     bdi-remove-enum-wb_congested_state.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: bdi: remove enum wb_congested_state
Date: Tue, 19 Jul 2022 16:33:49 +0800

enum wb_congested_state and the member 'congested' in bdi_writeback are
useless since commit a88f2096d5a2 ("remove congestion tracking
framework"), so remove it.

Link: https://lkml.kernel.org/r/20220719083349.87547-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: NeilBrown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev-defs.h |    7 -------
 1 file changed, 7 deletions(-)

--- a/include/linux/backing-dev-defs.h~bdi-remove-enum-wb_congested_state
+++ a/include/linux/backing-dev-defs.h
@@ -28,11 +28,6 @@ enum wb_state {
 	WB_start_all,		/* nr_pages == 0 (all) work pending */
 };
 
-enum wb_congested_state {
-	WB_async_congested,	/* The async (write) queue is getting full */
-	WB_sync_congested,	/* The sync queue is getting full */
-};
-
 enum wb_stat_item {
 	WB_RECLAIMABLE,
 	WB_WRITEBACK,
@@ -122,8 +117,6 @@ struct bdi_writeback {
 	atomic_t writeback_inodes;	/* number of inodes under writeback */
 	struct percpu_counter stat[NR_WB_STAT_ITEMS];
 
-	unsigned long congested;	/* WB_[a]sync_congested flags */
-
 	unsigned long bw_time_stamp;	/* last time write bw is updated */
 	unsigned long dirtied_stamp;
 	unsigned long written_stamp;	/* pages written at bw_time_stamp */
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are


