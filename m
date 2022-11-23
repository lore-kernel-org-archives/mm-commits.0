Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A095CC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 23 Nov 2022 02:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbiKWCsc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Nov 2022 21:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiKWCsc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Nov 2022 21:48:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F986C728
        for <mm-commits@vger.kernel.org>; Tue, 22 Nov 2022 18:48:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 118D6B81E57
        for <mm-commits@vger.kernel.org>; Wed, 23 Nov 2022 02:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC99AC433D6;
        Wed, 23 Nov 2022 02:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669171708;
        bh=K3eeMHRlyrrW5Jg1zkBJDhKrkOHML0xk8EMFh8CKgxA=;
        h=Date:To:From:Subject:From;
        b=NulDDj1sJEQFRZwBeRT++WHgvewiU564GKNYlpg2Uxc3nGbOZFGaQOuvvZ0whV8/8
         y15AxBGOK/jvzTUUxFzNCM6vZLtqANDHrN67edWtrIOfsYchPGeRSBC2/1qSGorunh
         5CFvsZbq2c5Em5KTxt+GxfhxThYwE4lNpSL3nKm8=
Date:   Tue, 22 Nov 2022 18:48:27 -0800
To:     mm-commits@vger.kernel.org, liushixin2@huawei.com,
        konishi.ryusuke@gmail.com, chenzhongjin@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty-v3.patch removed from -mm tree
Message-Id: <20221123024828.BC99AC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: Fix nilfs_sufile_mark_dirty() not set segment usage as dirty
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty-v3.patch

This patch was dropped because it was folded into nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty.patch

------------------------------------------------------
From: Chen Zhongjin <chenzhongjin@huawei.com>
Subject: nilfs2: Fix nilfs_sufile_mark_dirty() not set segment usage as dirty
Date: Mon, 21 Nov 2022 17:11:41 +0800

add lock protection per Ryusuke

Link: https://lkml.kernel.org/r/20221121091141.214703-1-chenzhongjin@huawei.com
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Cc: stable@vger.kernel.org
Reported-by: syzbot+77e4f005cb899d4268d1@syzkaller.appspotmail.com
Reported-by: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nilfs2/sufile.c~nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty-v3
+++ a/fs/nilfs2/sufile.c
@@ -499,6 +499,7 @@ int nilfs_sufile_mark_dirty(struct inode
 	struct nilfs_segment_usage *su;
 	int ret;
 
+	down_write(&NILFS_MDT(sufile)->mi_sem);
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
 	if (!ret) {
 		mark_buffer_dirty(bh);
@@ -509,6 +510,7 @@ int nilfs_sufile_mark_dirty(struct inode
 		kunmap_atomic(kaddr);
 		brelse(bh);
 	}
+	up_write(&NILFS_MDT(sufile)->mi_sem);
 	return ret;
 }
 
_

Patches currently in -mm which might be from chenzhongjin@huawei.com are

nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty.patch

