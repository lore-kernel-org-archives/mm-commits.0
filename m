From: akpm@linux-foundation.org
Subject: [merged] fat-notify-when-discard-is-not-supported.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:08:40 -0800
Message-ID: <20121218200840.B1BB082004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:51586 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2LRUIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:08:41 -0500
Received: by mail-ye0-f202.google.com with SMTP id l7so125901yen.5
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:08:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: notify when discard is not supported
has been removed from the -mm tree.  Its filename was
     fat-notify-when-discard-is-not-supported.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: fat: notify when discard is not supported

Change fatfs so that a warning is emitted when an attempt is made to mount
a filesystem with the unsupported `discard' option.

ext4 aready does this: http://patchwork.ozlabs.org/patch/192668/

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN fs/fat/inode.c~fat-notify-when-discard-is-not-supported fs/fat/inode.c
--- a/fs/fat/inode.c~fat-notify-when-discard-is-not-supported
+++ a/fs/fat/inode.c
@@ -26,6 +26,7 @@
 #include <linux/writeback.h>
 #include <linux/log2.h>
 #include <linux/hash.h>
+#include <linux/blkdev.h>
 #include <asm/unaligned.h>
 #include "fat.h"
 
@@ -1431,6 +1432,14 @@ int fat_fill_super(struct super_block *s
 		goto out_fail;
 	}
 
+	if (sbi->options.discard) {
+		struct request_queue *q = bdev_get_queue(sb->s_bdev);
+		if (!blk_queue_discard(q))
+			fat_msg(sb, KERN_WARNING,
+					"mounting with \"discard\" option, but "
+					"the device does not support discard");
+	}
+
 	return 0;
 
 out_invalid:
_

Patches currently in -mm which might be from linkinjeon@gmail.com are

origin.patch
linux-next.patch

