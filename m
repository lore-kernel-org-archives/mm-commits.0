From: akpm@linux-foundation.org
Subject: [merged] fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch removed from -mm tree
Date: Tue, 07 May 2013 10:46:15 -0700
Message-ID: <20130507174615.741615A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:53222 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab3EGRqQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:46:16 -0400
Received: by mail-qc0-f201.google.com with SMTP id c10so85030qcz.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:46:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clouds.yan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
has been removed from the -mm tree.  Its filename was
     fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yan Hong <clouds.yan@gmail.com>
Subject: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()

Its only caller evict() has promised a non-NULL inode->i_bdev.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN fs/block_dev.c~fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget fs/block_dev.c
--- a/fs/block_dev.c~fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget
+++ a/fs/block_dev.c
@@ -617,11 +617,9 @@ void bd_forget(struct inode *inode)
 	struct block_device *bdev = NULL;
 
 	spin_lock(&bdev_lock);
-	if (inode->i_bdev) {
-		if (!sb_is_blkdev_sb(inode->i_sb))
-			bdev = inode->i_bdev;
-		__bd_forget(inode);
-	}
+	if (!sb_is_blkdev_sb(inode->i_sb))
+		bdev = inode->i_bdev;
+	__bd_forget(inode);
 	spin_unlock(&bdev_lock);
 
 	if (bdev)
_

Patches currently in -mm which might be from clouds.yan@gmail.com are

origin.patch

