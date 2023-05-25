Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF792C77B7A
	for <mm-commits@archiver.kernel.org>; Thu, 25 May 2023 20:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjEYUn1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 May 2023 16:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjEYUn1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2023 16:43:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E770CE4A;
        Thu, 25 May 2023 13:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94C9361616;
        Thu, 25 May 2023 20:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAD3C433EF;
        Thu, 25 May 2023 20:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685047384;
        bh=KTRBm4xdSfgBR+pSkb5QVoPMlSvXsPPWRJF8UzFjmQE=;
        h=Date:To:From:Subject:From;
        b=tizy9saii70iE7qy9iVIyczeqvrCi6hozGiyb9SIaXJcixPFlJy7Tm6eKYhWH7IG1
         wwUKhAn0Br14H1YKtnjJpA3OKlkR4nsyF9hLhxqg/hruUbrcYESbbTGjFJMCKa6/6C
         INcfiEY2KRzIO+Z1Novh8WKEwpQnBwM9VpK69oOI=
Date:   Thu, 25 May 2023 13:43:03 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-possible-out-of-bounds-segment-allocation-in-resize-ioctl.patch added to mm-hotfixes-unstable branch
Message-Id: <20230525204303.EDAD3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix possible out-of-bounds segment allocation in resize ioctl
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-possible-out-of-bounds-segment-allocation-in-resize-ioctl.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-possible-out-of-bounds-segment-allocation-in-resize-ioctl.patch

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
Subject: nilfs2: fix possible out-of-bounds segment allocation in resize ioctl
Date: Wed, 24 May 2023 18:43:48 +0900

Syzbot reports that in its stress test for resize ioctl, the log writing
function nilfs_segctor_do_construct hits a WARN_ON in
nilfs_segctor_truncate_segments().

It turned out that there is a problem with the current implementation of
the resize ioctl, which changes the writable range on the device (the
range of allocatable segments) at the end of the resize process.

This order is necessary for file system expansion to avoid corrupting the
superblock at trailing edge.  However, in the case of a file system
shrink, if log writes occur after truncating out-of-bounds trailing
segments and before the resize is complete, segments may be allocated from
the truncated space.

The userspace resize tool was fine as it limits the range of allocatable
segments before performing the resize, but it can run into this issue if
the resize ioctl is called alone.

Fix this issue by changing nilfs_sufile_resize() to update the range of
allocatable segments immediately after successful truncation of segment
space in case of file system shrink.

Link: https://lkml.kernel.org/r/20230524094348.3784-1-konishi.ryusuke@gmail.com
Fixes: 4e33f9eab07e ("nilfs2: implement resize ioctl")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+33494cd0df2ec2931851@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000005434c405fbbafdc5@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sufile.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/nilfs2/sufile.c~nilfs2-fix-possible-out-of-bounds-segment-allocation-in-resize-ioctl
+++ a/fs/nilfs2/sufile.c
@@ -779,6 +779,15 @@ int nilfs_sufile_resize(struct inode *su
 			goto out_header;
 
 		sui->ncleansegs -= nsegs - newnsegs;
+
+		/*
+		 * If the sufile is successfully truncated, immediately adjust
+		 * the segment allocation space while locking the semaphore
+		 * "mi_sem" so that nilfs_sufile_alloc() never allocates
+		 * segments in the truncated space.
+		 */
+		sui->allocmax = newnsegs - 1;
+		sui->allocmin = 0;
 	}
 
 	kaddr = kmap_atomic(header_bh->b_page);
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-incomplete-buffer-cleanup-in-nilfs_btnode_abort_change_key.patch
nilfs2-fix-possible-out-of-bounds-segment-allocation-in-resize-ioctl.patch

