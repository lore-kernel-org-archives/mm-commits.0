Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07468C19F20
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 20:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbjEBUpl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 16:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjEBUpk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 16:45:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBACB198C;
        Tue,  2 May 2023 13:45:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 774A160DC6;
        Tue,  2 May 2023 20:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB66DC433EF;
        Tue,  2 May 2023 20:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683060337;
        bh=BwELPqrPdDL4NB2yfXbUq1+GIe4byaSVg3tFkAaACxw=;
        h=Date:To:From:Subject:From;
        b=mmCmGvDxePKzS8urqM2iTs91s3TBYh2JbsRdpjiF+5CIobPFM0XvUg9noXzcRyjBu
         OodVXo8TBx97BAK0OuWXcuUZyyxPq3ZDAudUhXNz6oSQXqnUNrCbT+Y230HNYLJQMS
         30hyGP7kpPETZvKJ7aXVAIE6LsHcvaJz7pxcj2RE=
Date:   Tue, 02 May 2023 13:45:36 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-do-not-write-dirty-data-after-degenerating-to-read-only.patch added to mm-hotfixes-unstable branch
Message-Id: <20230502204537.CB66DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: do not write dirty data after degenerating to read-only
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-do-not-write-dirty-data-after-degenerating-to-read-only.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-do-not-write-dirty-data-after-degenerating-to-read-only.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: do not write dirty data after degenerating to read-only
Date: Thu, 27 Apr 2023 10:15:26 +0900

According to syzbot's report, mark_buffer_dirty() called from
nilfs_segctor_do_construct() outputs a warning with some patterns after
nilfs2 detects metadata corruption and degrades to read-only mode.

After such read-only degeneration, page cache data may be cleared through
nilfs_clear_dirty_page() which may also clear the uptodate flag for their
buffer heads.  However, even after the degeneration, log writes are still
performed by unmount processing etc., which causes mark_buffer_dirty() to
be called for buffer heads without the "uptodate" flag and causes the
warning.

Since any writes should not be done to a read-only file system in the
first place, this fixes the warning in mark_buffer_dirty() by letting
nilfs_segctor_do_construct() abort early if in read-only mode.

This also changes the retry check of nilfs_segctor_write_out() to avoid
unnecessary log write retries if it detects -EROFS that
nilfs_segctor_do_construct() returned.

Link: https://lkml.kernel.org/r/20230427011526.13457-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+2af3bc9585be7f23f290@syzkaller.appspotmail.com
  Link: https://syzkaller.appspot.com/bug?extid=2af3bc9585be7f23f290
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/segment.c~nilfs2-do-not-write-dirty-data-after-degenerating-to-read-only
+++ a/fs/nilfs2/segment.c
@@ -2041,6 +2041,9 @@ static int nilfs_segctor_do_construct(st
 	struct the_nilfs *nilfs = sci->sc_super->s_fs_info;
 	int err;
 
+	if (sb_rdonly(sci->sc_super))
+		return -EROFS;
+
 	nilfs_sc_cstage_set(sci, NILFS_ST_INIT);
 	sci->sc_cno = nilfs->ns_cno;
 
@@ -2724,7 +2727,7 @@ static void nilfs_segctor_write_out(stru
 
 		flush_work(&sci->sc_iput_work);
 
-	} while (ret && retrycount-- > 0);
+	} while (ret && ret != -EROFS && retrycount-- > 0);
 }
 
 /**
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-infinite-loop-in-nilfs_mdt_get_block.patch
nilfs2-do-not-write-dirty-data-after-degenerating-to-read-only.patch

