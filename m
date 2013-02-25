From: akpm@linux-foundation.org
Subject: [merged] loopdev-ignore-negative-offset-when-calculate-loop-device-size.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:56:47 -0800
Message-ID: <20130225205647.C13FF31C1FC@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:51667 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3BYU4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:56:49 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so159600yen.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:56:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yan@linux.vnet.ibm.com, axboe@kernel.dk, hindessm@uk.ibm.com, knikanth@suse.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: loopdev: ignore negative offset when calculate loop device size
has been removed from the -mm tree.  Its filename was
     loopdev-ignore-negative-offset-when-calculate-loop-device-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guo Chao <yan@linux.vnet.ibm.com>
Subject: loopdev: ignore negative offset when calculate loop device size

Negative offset may cause loop device size larger than backing file
size.

 $ fallocate -l 1M a
 $ losetup --offset 0xffffffffffff0000 /dev/loop0 a
 $ blockdev --getsize64 /dev/loop0
 1114112
 $ ls -l a
 -rw-r--r-- 1 root root 1048576 Jan 23 12:46 a
 $ cat /dev/loop0
 cat: /dev/loop0: Input/output error

It makes no sense to do that. Only apply offset when it's positive.

Fix a typo in the comment by the way.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Guo Chao <yan@linux.vnet.ibm.com>
Cc: M. Hindess <hindessm@uk.ibm.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/block/loop.c~loopdev-ignore-negative-offset-when-calculate-loop-device-size drivers/block/loop.c
--- a/drivers/block/loop.c~loopdev-ignore-negative-offset-when-calculate-loop-device-size
+++ a/drivers/block/loop.c
@@ -162,12 +162,13 @@ static struct loop_func_table *xfer_func
 
 static loff_t get_size(loff_t offset, loff_t sizelimit, struct file *file)
 {
-	loff_t size, loopsize;
+	loff_t loopsize;
 
 	/* Compute loopsize in bytes */
-	size = i_size_read(file->f_mapping->host);
-	loopsize = size - offset;
-	/* offset is beyond i_size, wierd but possible */
+	loopsize = i_size_read(file->f_mapping->host);
+	if (offset > 0)
+		loopsize -= offset;
+	/* offset is beyond i_size, weird but possible */
 	if (loopsize < 0)
 		return 0;
 
_

Patches currently in -mm which might be from yan@linux.vnet.ibm.com are

linux-next.patch

