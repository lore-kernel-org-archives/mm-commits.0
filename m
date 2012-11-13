From: akpm@linux-foundation.org
Subject: + fat-notify-when-discard-is-not-supported.patch added to -mm tree
Date: Tue, 13 Nov 2012 15:55:28 -0800
Message-ID: <20121113235529.216FE5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:50787 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab2KMXzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Nov 2012 18:55:31 -0500
Received: by mail-ea0-f202.google.com with SMTP id f11so226702eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Nov 2012 15:55:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linkinjeon@gmail.com, amit.sahrawat83@gmail.com, hirofumi@mail.parknet.co.jp


The patch titled
     Subject: fat: notify when discard is not supported
has been added to the -mm tree.  Its filename is
     fat-notify-when-discard-is-not-supported.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
writeback-remove-nr_pages_dirtied-arg-from-balance_dirty_pages_ratelimited_nr.patch
fat-notify-when-discard-is-not-supported.patch

