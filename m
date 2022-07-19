Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D07C43334
	for <mm-commits@archiver.kernel.org>; Tue, 19 Jul 2022 23:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237631AbiGSXiP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Jul 2022 19:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbiGSXiO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2022 19:38:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C534E60F
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 16:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8ECE4B81DA0
        for <mm-commits@vger.kernel.org>; Tue, 19 Jul 2022 23:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CDEC341C6;
        Tue, 19 Jul 2022 23:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658273891;
        bh=35R3QYiuZyc/4szlG97iTBE47QifczEQCcxmVZQ2LMU=;
        h=Date:To:From:Subject:From;
        b=NDWZ4k0wQiz2JZBPc6Y04v6V6gCpa/UomKbo8R0ZTyjtu4sPeEP5Nq7UzKV3vre9u
         oyCWj9Eh7f/38Wi4oHZZ2kv8RChjp2F5LHOpzDGKW6JEMcGQXOD22BsxaiS05QpnX+
         7e99cIPuqaVvtyTSa1rbgwmyvYEzrjYpfED/fse4=
Date:   Tue, 19 Jul 2022 16:38:10 -0700
To:     mm-commits@vger.kernel.org, neilb@suse.de, jack@suse.cz,
        xiujianfeng@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + bdi-remove-enum-wb_congested_state.patch added to mm-nonmm-unstable branch
Message-Id: <20220719233811.20CDEC341C6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: bdi: remove enum wb_congested_state
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     bdi-remove-enum-wb_congested_state.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/bdi-remove-enum-wb_congested_state.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: bdi: remove enum wb_congested_state
Date: Tue, 19 Jul 2022 16:33:49 +0800

enum wb_congested_state and the member 'congested' in bdi_writeback are
useless since commit a88f2096d5a2 ("remove congestion tracking
framework"), so remove it.

Link: https://lkml.kernel.org/r/20220719083349.87547-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: Jan Kara <jack@suse.cz>
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

writeback-cleanup-inode_to_wb_is_valid.patch
bdi-remove-enum-wb_congested_state.patch

