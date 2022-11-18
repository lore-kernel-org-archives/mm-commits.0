Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C9F8C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 18 Nov 2022 22:12:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiKRWMt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Nov 2022 17:12:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiKRWMm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2022 17:12:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3D3E007
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 14:12:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D54CB82529
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 22:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6DBC433D6;
        Fri, 18 Nov 2022 22:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668809558;
        bh=LPKtkcKf+/3X9e1hK/cnUGWX/EXHJ1W6P6F4Hj6UL6s=;
        h=Date:To:From:Subject:From;
        b=Jd2b3jkSAMhMdr6EuFgTfqcPH315wSzETOR22kR6VQrPSrtpNw8PIdj8foDkKPf51
         4S5jbICk+QtFLyhJ3d17xGF2gESPVwaqKQcyHvq3ApRAWq6C+znIAIe2tuzn8wKyfJ
         8APO9Uvl6u04Ig4qvWcHYLGYGU28WGpQpTkUDaBM=
Date:   Fri, 18 Nov 2022 14:12:37 -0800
To:     mm-commits@vger.kernel.org, konishi.ryusuke@gmail.com,
        chenzhongjin@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty.patch added to mm-nonmm-unstable branch
Message-Id: <20221118221237.EA6DBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix nilfs_sufile_mark_dirty() not set segment usage as dirty
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty.patch

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
Subject: nilfs2: fix nilfs_sufile_mark_dirty() not set segment usage as dirty
Date: Fri, 18 Nov 2022 14:33:04 +0800

In nilfs_sufile_mark_dirty(), the buffer and inode are set dirty, but
nilfs_segment_usage is not set dirty, which makes it can be found by
nilfs_sufile_alloc() because it checks nilfs_segment_usage_clean(su).

This will cause the problem reported by syzkaller:
https://syzkaller.appspot.com/bug?id=c7c4748e11ffcc367cef04f76e02e931833cbd24

It's because the case starts with segbuf1.segnum = 3, nextnum = 4, and
nilfs_sufile_alloc() not called to allocate a new segment.

The first time nilfs_segctor_extend_segments() allocated segment
segbuf2.segnum = segbuf1.nextnum = 4, then nilfs_sufile_alloc() found
nextnextnum = 4 segment because its su is not set dirty.  So
segbuf2.nextnum = 4, which causes next segbuf3.segnum = 4.

sb_getblk() will get same bh for segbuf2 and segbuf3, and this bh is added
to both buffer lists of two segbuf.  It makes the list head of second list
linked to the first one.  When iterating the first one, it will access and
deref the head of second, which causes NULL pointer dereference.

Link: https://lkml.kernel.org/r/20221118063304.140187-1-chenzhongjin@huawei.com
Fixes: 9ff05123e3bf ("nilfs2: segment constructor")
Reported-by: syzbot+77e4f0...@syzkaller.appspotmail.com
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/nilfs2/sufile.c~nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty
+++ a/fs/nilfs2/sufile.c
@@ -495,12 +495,18 @@ void nilfs_sufile_do_free(struct inode *
 int nilfs_sufile_mark_dirty(struct inode *sufile, __u64 segnum)
 {
 	struct buffer_head *bh;
+	void *kaddr;
+	struct nilfs_segment_usage *su;
 	int ret;
 
 	ret = nilfs_sufile_get_segment_usage_block(sufile, segnum, 0, &bh);
 	if (!ret) {
 		mark_buffer_dirty(bh);
 		nilfs_mdt_mark_dirty(sufile);
+		kaddr = kmap_atomic(bh->b_page);
+		su = nilfs_sufile_block_get_segment_usage(sufile, segnum, bh, kaddr);
+		nilfs_segment_usage_set_dirty(su);
+		kunmap_atomic(kaddr);
 		brelse(bh);
 	}
 	return ret;
_

Patches currently in -mm which might be from chenzhongjin@huawei.com are

nilfs2-fix-nilfs_sufile_mark_dirty-not-set-segment-usage-as-dirty.patch

