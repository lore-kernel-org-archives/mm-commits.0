Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7234CECAAD3
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 19:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbiIATGw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233501AbiIATGs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 15:06:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE426DAE0
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 12:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEC3B61D84
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 19:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF48C433D7;
        Thu,  1 Sep 2022 19:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662059206;
        bh=s9Hftlv6QZOnvTPaGYs384JuhWhsBMcZNbPygkMfURg=;
        h=Date:To:From:Subject:From;
        b=HfiaceVFc8QVaKgM2aZJBIy4mKa6OgfwWavb7dfcaJ2oo+S2Bo611DDeg7okbzDqp
         spM0s/D/3T0RgHj/Q0l5htZXNzMR0qlPbPlK0nJCt8DG7BonAWBkkSlsIOlsBscs9Y
         xwiQB4ItD8QwXhj7BwcTboEYohA4dDjkDcwsc80w=
Date:   Thu, 01 Sep 2022 12:06:45 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, yi.zhang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ntfs3-replace-ll_rw_block.patch added to mm-unstable branch
Message-Id: <20220901190646.4BF48C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ntfs3: replace ll_rw_block()
has been added to the -mm mm-unstable branch.  Its filename is
     ntfs3-replace-ll_rw_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ntfs3-replace-ll_rw_block.patch

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
Subject: ntfs3: replace ll_rw_block()
Date: Thu, 1 Sep 2022 21:34:58 +0800

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO after wait_on_buffer() if the buffer has
been locked by others. So stop using ll_rw_block() in
ntfs_get_block_vbo().

Link: https://lkml.kernel.org/r/20220901133505.2510834-8-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs3/inode.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/ntfs3/inode.c~ntfs3-replace-ll_rw_block
+++ a/fs/ntfs3/inode.c
@@ -630,12 +630,9 @@ static noinline int ntfs_get_block_vbo(s
 			bh->b_size = block_size;
 			off = vbo & (PAGE_SIZE - 1);
 			set_bh_page(bh, page, off);
-			ll_rw_block(REQ_OP_READ, 1, &bh);
-			wait_on_buffer(bh);
-			if (!buffer_uptodate(bh)) {
-				err = -EIO;
+			err = bh_read(bh, 0);
+			if (err < 0)
 				goto out;
-			}
 			zero_user_segment(page, off + voff, off + block_size);
 		}
 	}
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

