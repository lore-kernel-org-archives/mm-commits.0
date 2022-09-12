Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0916DECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiILDfo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiILDdo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CAA29CBE
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62C07B80C75
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE47C433D6;
        Mon, 12 Sep 2022 03:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953436;
        bh=xYkHDBcXHlKJmJfcT7Svj92KnFBLnG+q6wtsSVXl7m8=;
        h=Date:To:From:Subject:From;
        b=V0b4UQCxEjNYNpeJYsWcHW38wTKpyBwdturlGAxHqIKYeOjvMmxq2ig3EmT38MgNk
         ObdxNOqtbRNWTVM5rStT54aZvZptecD5nRHODDVy3yNWZ3yhwuXSLt0gCl5ARICFog
         9dsIXDVeIdbnYLoVdD97bBR1YBQ8B0I44eGJrhz4=
Date:   Sun, 11 Sep 2022 20:30:35 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ufs-replace-ll_rw_block.patch removed from -mm tree
Message-Id: <20220912033036.1CE47C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ufs: replace ll_rw_block()
has been removed from the -mm tree.  Its filename was
     ufs-replace-ll_rw_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: ufs: replace ll_rw_block()
Date: Thu, 1 Sep 2022 21:35:02 +0800

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO after wait_on_buffer() if the buffer has
been locked by others. So stop using ll_rw_block() in ufs.

Link: https://lkml.kernel.org/r/20220901133505.2510834-12-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/fs/ufs/balloc.c~ufs-replace-ll_rw_block
+++ a/fs/ufs/balloc.c
@@ -295,14 +295,10 @@ static void ufs_change_blocknr(struct in
 
 			if (!buffer_mapped(bh))
 					map_bh(bh, inode->i_sb, oldb + pos);
-			if (!buffer_uptodate(bh)) {
-				ll_rw_block(REQ_OP_READ, 1, &bh);
-				wait_on_buffer(bh);
-				if (!buffer_uptodate(bh)) {
-					ufs_error(inode->i_sb, __func__,
-						  "read of block failed\n");
-					break;
-				}
+			if (bh_read(bh, 0) < 0) {
+				ufs_error(inode->i_sb, __func__,
+					  "read of block failed\n");
+				break;
 			}
 
 			UFSD(" change from %llu to %llu, pos %u\n",
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


