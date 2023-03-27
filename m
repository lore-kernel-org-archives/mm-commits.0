Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6D9C76195
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 20:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjC0UbK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 16:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjC0UbJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 16:31:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E43272E
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 13:31:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71D21614ED
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 20:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53E9C433EF;
        Mon, 27 Mar 2023 20:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679949066;
        bh=ofDdVZCieLy5K86n6+rmBQHzGhJLpcCu2xQFbY03tzQ=;
        h=Date:To:From:Subject:From;
        b=m5DPOJ1GIApWXssF70Fx0FmBn2wZu1xoPjQ2kcqVyEpi59V7cyRDlXG0jzUu4vkzX
         l60A23+1rbFLzrZraMmpXVOI109gUGTd5EIJIN2uPTfXBalB0+TrqVV2mLr1HpjlrI
         6WNaWHmYn7yaEWPkr5gmxx06d6ygJgGOEQiYqaUY=
Date:   Mon, 27 Mar 2023 13:31:06 -0700
To:     mm-commits@vger.kernel.org,
        syzbot+048585f3f4227bb2b49b@syzkaller.appspotmail.com,
        mail.dipanjan.das@gmail.com, konishi.ryusuke@gmail.com,
        glider@google.com, penguin-kernel@I-love.SAKURA.ne.jp,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-initialize-struct-nilfs_binfo_dat-bi_pad-field.patch added to mm-hotfixes-unstable branch
Message-Id: <20230327203106.C53E9C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: initialize "struct nilfs_binfo_dat"->bi_pad field
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-initialize-struct-nilfs_binfo_dat-bi_pad-field.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-initialize-struct-nilfs_binfo_dat-bi_pad-field.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

nilfs2-initialize-struct-nilfs_binfo_dat-bi_pad-field.patch

