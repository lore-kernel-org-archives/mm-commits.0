From: akpm@linux-foundation.org
Subject: + fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch added to -mm tree
Date: Wed, 26 Sep 2012 13:17:19 -0700
Message-ID: <20120926201719.AF2A8100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:54224 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2IZURU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 16:17:20 -0400
Received: by vcbfy27 with SMTP id fy27so120617vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 13:17:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clouds.yan@gmail.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/block_dev.c: no need to check inode->i_bdev in bd_forget()
has been added to the -mm tree.  Its filename is
     fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -669,11 +669,9 @@ void bd_forget(struct inode *inode)
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

fs-block_devc-need-not-to-check-inode-i_bdev-in-bd_forget.patch
proc-return-enomem-when-inode-allocation-failed.patch
proc-no-need-to-initialize-proc_inode-fd-in-proc_get_inode.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch

