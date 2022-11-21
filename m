Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF81C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 21:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiKUVVv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 16:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiKUVVv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 16:21:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33236C7235
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 13:21:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D88F6B8162A
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 21:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972E0C433D6;
        Mon, 21 Nov 2022 21:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669065707;
        bh=SP+7h/pS5EmoicHEoorZ6HceGrv7MjyiG9hUTyyP2jw=;
        h=Date:To:From:Subject:From;
        b=lfvHBJIDgaguSQVTJgCxUvGufS7UJK5/HHPYXjCJpoRz8S88SDEIX5IU2Qk6kwyBc
         pb5vJiOZzxGbsVoNrpfuMl+hHgz1aqFO84jnLRo0PMX5ixL/6ihqmI8Zv6B3TABPEH
         Fkl5Zv8V/xVHO4etOCVACXZP3VMjxqiPoE6kfvo0=
Date:   Mon, 21 Nov 2022 13:21:46 -0800
To:     mm-commits@vger.kernel.org, liushixin2@huawei.com,
        konishi.ryusuke@gmail.com, chenzhongjin@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty-v3.patch added to mm-nonmm-unstable branch
Message-Id: <20221121212147.972E0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: Fix nilfs_sufile_mark_dirty() not set segment usage as dirty
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty-v3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty-v3.patch

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
nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty-v3.patch

