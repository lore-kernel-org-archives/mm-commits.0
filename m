Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC39C77B72
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 01:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbjDFBHS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 21:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234328AbjDFBHP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 21:07:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0877A9A
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 18:07:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF14F642A8
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 01:07:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10330C433D2;
        Thu,  6 Apr 2023 01:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680743220;
        bh=zqIJEG3t0Qo2OMtF4oYDqVYiQiDKAJOJZgU72JBMBlw=;
        h=Date:To:From:Subject:From;
        b=IbRbBxNcvHSsUyt2Nkw95cxvWDxeNLins0fBGrDnfbTiKFYbAbqnKSR1oOZ8K2cCT
         X5wyaRlrSGVKRz+wqo7+ALvKOKjMiaDG6f/nz5H/SkhcD2xHzRWJo051Gxt5KlqAQB
         UDk1ZY5N8s34BX6mLiPcy35m+ydy+O/S0J0qXUQQ=
Date:   Wed, 05 Apr 2023 18:06:59 -0700
To:     mm-commits@vger.kernel.org,
        syzbot+048585f3f4227bb2b49b@syzkaller.appspotmail.com,
        mail.dipanjan.das@gmail.com, konishi.ryusuke@gmail.com,
        glider@google.com, penguin-kernel@I-love.SAKURA.ne.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-initialize-struct-nilfs_binfo_dat-bi_pad-field.patch removed from -mm tree
Message-Id: <20230406010700.10330C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: initialize "struct nilfs_binfo_dat"->bi_pad field
has been removed from the -mm tree.  Its filename was
     nilfs2-initialize-struct-nilfs_binfo_dat-bi_pad-field.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: nilfs2: initialize "struct nilfs_binfo_dat"->bi_pad field
Date: Mon, 27 Mar 2023 00:21:46 +0900

nilfs_btree_assign_p() and nilfs_direct_assign_p() are not initializing
"struct nilfs_binfo_dat"->bi_pad field, causing uninit-value reports when
being passed to CRC function.

Link: https://lkml.kernel.org/r/20230326152146.15872-1-konishi.ryusuke@gmail.com
Reported-by: syzbot <syzbot+048585f3f4227bb2b49b@syzkaller.appspotmail.com>
  Link: https://syzkaller.appspot.com/bug?extid=048585f3f4227bb2b49b
Reported-by: Dipanjan Das <mail.dipanjan.das@gmail.com>
  Link: https://lkml.kernel.org/r/CANX2M5bVbzRi6zH3PTcNE_31TzerstOXUa9Bay4E6y6dX23_pg@mail.gmail.com
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c  |    1 +
 fs/nilfs2/direct.c |    1 +
 2 files changed, 2 insertions(+)

--- a/fs/nilfs2/btree.c~nilfs2-initialize-struct-nilfs_binfo_dat-bi_pad-field
+++ a/fs/nilfs2/btree.c
@@ -2219,6 +2219,7 @@ static int nilfs_btree_assign_p(struct n
 	/* on-disk format */
 	binfo->bi_dat.bi_blkoff = cpu_to_le64(key);
 	binfo->bi_dat.bi_level = level;
+	memset(binfo->bi_dat.bi_pad, 0, sizeof(binfo->bi_dat.bi_pad));
 
 	return 0;
 }
--- a/fs/nilfs2/direct.c~nilfs2-initialize-struct-nilfs_binfo_dat-bi_pad-field
+++ a/fs/nilfs2/direct.c
@@ -314,6 +314,7 @@ static int nilfs_direct_assign_p(struct
 
 	binfo->bi_dat.bi_blkoff = cpu_to_le64(key);
 	binfo->bi_dat.bi_level = 0;
+	memset(binfo->bi_dat.bi_pad, 0, sizeof(binfo->bi_dat.bi_pad));
 
 	return 0;
 }
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

mm-page_alloc-fix-potential-deadlock-on-zonelist_update_seq-seqlock.patch

