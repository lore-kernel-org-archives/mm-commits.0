Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF46DEE49A8
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:47:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbjHUUrn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjHUUr0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69005139;
        Mon, 21 Aug 2023 13:47:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F114564AFC;
        Mon, 21 Aug 2023 20:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52808C433C8;
        Mon, 21 Aug 2023 20:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650835;
        bh=EV2/bo+oaJZJIm2bSjMvs6SVWVtVEkbXdMeQRMslWr0=;
        h=Date:To:From:Subject:From;
        b=B9Jf3RiirvcptzuEp9uH/L7a39TBkY4ZkNW1J6MSIE25+qwfX1pnnSxb6vt8ZpPBm
         k1YeS0vLep+2Y3x4MP6DmCyDIQd2bGziCdOX1/2kJjIm8Rm1Fmt1QQ/lA5sTbVRO1e
         dWImnSsj3672nCwp1HCXI6fI1tiXsanMMAR7yyd0=
Date:   Mon, 21 Aug 2023 13:47:14 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        konishi.ryusuke@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-fix-warning-in-mark_buffer_dirty-due-to-discarded-buffer-reuse.patch removed from -mm tree
Message-Id: <20230821204715.52808C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: fix WARNING in mark_buffer_dirty due to discarded buffer reuse
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-warning-in-mark_buffer_dirty-due-to-discarded-buffer-reuse.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix WARNING in mark_buffer_dirty due to discarded buffer reuse
Date: Fri, 18 Aug 2023 22:18:04 +0900

A syzbot stress test using a corrupted disk image reported that
mark_buffer_dirty() called from __nilfs_mark_inode_dirty() or
nilfs_palloc_commit_alloc_entry() may output a kernel warning, and can
panic if the kernel is booted with panic_on_warn.

This is because nilfs2 keeps buffer pointers in local structures for some
metadata and reuses them, but such buffers may be forcibly discarded by
nilfs_clear_dirty_page() in some critical situations.

This issue is reported to appear after commit 28a65b49eb53 ("nilfs2: do
not write dirty data after degenerating to read-only"), but the issue has
potentially existed before.

Fix this issue by checking the uptodate flag when attempting to reuse an
internally held buffer, and reloading the metadata instead of reusing the
buffer if the flag was lost.

Link: https://lkml.kernel.org/r/20230818131804.7758-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+cdfcae656bac88ba0e2d@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/0000000000003da75f05fdeffd12@google.com
Fixes: 8c26c4e2694a ("nilfs2: fix issue with flush kernel thread after remount in RO mode because of driver's internal error or metadata corruption")
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org> # 3.10+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |    3 ++-
 fs/nilfs2/inode.c |    7 +++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/alloc.c~nilfs2-fix-warning-in-mark_buffer_dirty-due-to-discarded-buffer-reuse
+++ a/fs/nilfs2/alloc.c
@@ -205,7 +205,8 @@ static int nilfs_palloc_get_block(struct
 	int ret;
 
 	spin_lock(lock);
-	if (prev->bh && blkoff == prev->blkoff) {
+	if (prev->bh && blkoff == prev->blkoff &&
+	    likely(buffer_uptodate(prev->bh))) {
 		get_bh(prev->bh);
 		*bhp = prev->bh;
 		spin_unlock(lock);
--- a/fs/nilfs2/inode.c~nilfs2-fix-warning-in-mark_buffer_dirty-due-to-discarded-buffer-reuse
+++ a/fs/nilfs2/inode.c
@@ -1025,7 +1025,7 @@ int nilfs_load_inode_block(struct inode
 	int err;
 
 	spin_lock(&nilfs->ns_inode_lock);
-	if (ii->i_bh == NULL) {
+	if (ii->i_bh == NULL || unlikely(!buffer_uptodate(ii->i_bh))) {
 		spin_unlock(&nilfs->ns_inode_lock);
 		err = nilfs_ifile_get_inode_block(ii->i_root->ifile,
 						  inode->i_ino, pbh);
@@ -1034,7 +1034,10 @@ int nilfs_load_inode_block(struct inode
 		spin_lock(&nilfs->ns_inode_lock);
 		if (ii->i_bh == NULL)
 			ii->i_bh = *pbh;
-		else {
+		else if (unlikely(!buffer_uptodate(ii->i_bh))) {
+			__brelse(ii->i_bh);
+			ii->i_bh = *pbh;
+		} else {
 			brelse(*pbh);
 			*pbh = ii->i_bh;
 		}
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


