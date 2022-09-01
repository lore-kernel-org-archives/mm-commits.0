Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA987ECAAD3
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 19:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbiIATHD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:07:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiIATGz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 15:06:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 993986EF33
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 12:06:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0671D61D96
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 19:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549C9C433C1;
        Thu,  1 Sep 2022 19:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662059213;
        bh=OVnfyUm3d4hWdAdTJ4dHVdA9kR6+kMY7fc+N3+yKSZE=;
        h=Date:To:From:Subject:From;
        b=vgRFuIRNSF2btWm73mCXZdA8EJybDk6ncskzPuOQWq0wP3w8/AsnwnqiSR26c8iG0
         PNv/8oNfKWva7kq2h4k4OfYPpbaNiqxhovTNbpOV/SqAGtwOjt6Pvmhvu516pmZAa6
         9hHR9LRjS+Wih9ySLSZm7btZERBhRgrC10Ju6iDM=
Date:   Thu, 01 Sep 2022 12:06:52 -0700
To:     mm-commits@vger.kernel.org, yi.zhang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + udf-replace-ll_rw_block.patch added to mm-unstable branch
Message-Id: <20220901190653.549C9C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: udf: replace ll_rw_block()
has been added to the -mm mm-unstable branch.  Its filename is
     udf-replace-ll_rw_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/udf-replace-ll_rw_block.patch

This patch will later appear in the mm-unstable branch at
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
From: Zhang Yi <yi.zhang@huawei.com>
Subject: udf: replace ll_rw_block()
Date: Thu, 1 Sep 2022 21:35:01 +0800

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO after wait_on_buffer() if the buffer has
been locked by others. So stop using ll_rw_block(). We also switch to
new bh_readahead_batch() helper for the buffer array readahead path.

Link: https://lkml.kernel.org/r/20220901133505.2510834-11-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/dir.c       |    2 +-
 fs/udf/directory.c |    2 +-
 fs/udf/inode.c     |    8 +-------
 3 files changed, 3 insertions(+), 9 deletions(-)

--- a/fs/udf/dir.c~udf-replace-ll_rw_block
+++ a/fs/udf/dir.c
@@ -130,7 +130,7 @@ static int udf_readdir(struct file *file
 					brelse(tmp);
 			}
 			if (num) {
-				ll_rw_block(REQ_OP_READ | REQ_RAHEAD, num, bha);
+				bh_readahead_batch(num, bha, REQ_RAHEAD);
 				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
--- a/fs/udf/directory.c~udf-replace-ll_rw_block
+++ a/fs/udf/directory.c
@@ -89,7 +89,7 @@ struct fileIdentDesc *udf_fileident_read
 					brelse(tmp);
 			}
 			if (num) {
-				ll_rw_block(REQ_OP_READ | REQ_RAHEAD, num, bha);
+				bh_readahead_batch(num, bha, REQ_RAHEAD);
 				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
--- a/fs/udf/inode.c~udf-replace-ll_rw_block
+++ a/fs/udf/inode.c
@@ -1211,13 +1211,7 @@ struct buffer_head *udf_bread(struct ino
 	if (!bh)
 		return NULL;
 
-	if (buffer_uptodate(bh))
-		return bh;
-
-	ll_rw_block(REQ_OP_READ, 1, &bh);
-
-	wait_on_buffer(bh);
-	if (buffer_uptodate(bh))
+	if (bh_read(bh, 0) >= 0)
 		return bh;
 
 	brelse(bh);
_

Patches currently in -mm which might be from yi.zhang@huawei.com are

fs-buffer-remove-__breadahead_gfp.patch
fs-buffer-add-some-new-buffer-read-helpers.patch
fs-buffer-replace-ll_rw_block.patch
gfs2-replace-ll_rw_block.patch
isofs-replace-ll_rw_block.patch
jbd2-replace-ll_rw_block.patch
ntfs3-replace-ll_rw_block.patch
ocfs2-replace-ll_rw_block.patch
reiserfs-replace-ll_rw_block.patch
udf-replace-ll_rw_block.patch
ufs-replace-ll_rw_block.patch
fs-buffer-remove-ll_rw_block-helper.patch
ext2-replace-bh_submit_read-helper-with-bh_read_locked.patch
fs-buffer-remove-bh_submit_read-helper.patch

