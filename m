Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A30CC7EE22
	for <mm-commits@archiver.kernel.org>; Tue,  2 May 2023 19:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjEBTZD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 15:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjEBTY4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 15:24:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596421FFC;
        Tue,  2 May 2023 12:24:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C900E6230D;
        Tue,  2 May 2023 19:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F159C433EF;
        Tue,  2 May 2023 19:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683055493;
        bh=Ct2Ib8npwvMrBUx8QME4uTsT6Qdmq50GzbkA7FfZVls=;
        h=Date:To:From:Subject:From;
        b=yl0D2Pam5pYFloGLVXolMBN9sysQhSzOVFjywOJt+XingHIQ7YIlL4e6RgIx2gLUo
         N+6Idxlvv4iFURtryN5gauOIqxJOmmKkchsUlB/V98AhCyy5fcZgxcV6DAX59+hoAS
         j2ZDdg6+Z2phqjFBaZU1JtMq6kFm9AU+nG4Vxc4g=
Date:   Tue, 02 May 2023 12:24:52 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-infinite-loop-in-nilfs_mdt_get_block.patch added to mm-hotfixes-unstable branch
Message-Id: <20230502192453.2F159C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix infinite loop in nilfs_mdt_get_block()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-infinite-loop-in-nilfs_mdt_get_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-infinite-loop-in-nilfs_mdt_get_block.patch

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
Subject: nilfs2: fix infinite loop in nilfs_mdt_get_block()
Date: Mon, 1 May 2023 04:30:46 +0900

If the disk image that nilfs2 mounts is corrupted and a virtual block
address obtained by block lookup for a metadata file is invalid,
nilfs_bmap_lookup_at_level() may return the same internal return code as
-ENOENT, meaning the block does not exist in the metadata file.

This duplication of return codes confuses nilfs_mdt_get_block(), causing
it to read and create a metadata block indefinitely.

In particular, if this happens to the inode metadata file, ifile,
semaphore i_rwsem can be left held, causing task hangs in lock_mount.

Fix this issue by making nilfs_bmap_lookup_at_level() treat virtual block
address translation failures with -ENOENT as metadata corruption instead
of returning the error code.

Link: https://lkml.kernel.org/r/20230430193046.6769-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+221d75710bde87fa0e97@syzkaller.appspotmail.com
  Link: https://syzkaller.appspot.com/bug?extid=221d75710bde87fa0e97
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/bmap.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/fs/nilfs2/bmap.c~nilfs2-fix-infinite-loop-in-nilfs_mdt_get_block
+++ a/fs/nilfs2/bmap.c
@@ -67,20 +67,28 @@ int nilfs_bmap_lookup_at_level(struct ni
 
 	down_read(&bmap->b_sem);
 	ret = bmap->b_ops->bop_lookup(bmap, key, level, ptrp);
-	if (ret < 0) {
-		ret = nilfs_bmap_convert_error(bmap, __func__, ret);
+	if (ret < 0)
 		goto out;
-	}
+
 	if (NILFS_BMAP_USE_VBN(bmap)) {
 		ret = nilfs_dat_translate(nilfs_bmap_get_dat(bmap), *ptrp,
 					  &blocknr);
 		if (!ret)
 			*ptrp = blocknr;
+		else if (ret == -ENOENT) {
+			/*
+			 * If there was no valid entry in DAT for the block
+			 * address obtained by b_ops->bop_lookup, then pass
+			 * internal code -EINVAL to nilfs_bmap_convert_error
+			 * to treat it as metadata corruption.
+			 */
+			ret = -EINVAL;
+		}
 	}
 
  out:
 	up_read(&bmap->b_sem);
-	return ret;
+	return nilfs_bmap_convert_error(bmap, __func__, ret);
 }
 
 int nilfs_bmap_lookup_contig(struct nilfs_bmap *bmap, __u64 key, __u64 *ptrp,
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-infinite-loop-in-nilfs_mdt_get_block.patch

