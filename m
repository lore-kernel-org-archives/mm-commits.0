From: akpm@linux-foundation.org
Subject: + loopdev-ignore-negative-offset-when-calculate-loop-device-size.patch added to -mm tree
Date: Mon, 28 Jan 2013 16:40:26 -0800
Message-ID: <20130129004027.6105F31C25A@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:39225 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab3A2Ak2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 19:40:28 -0500
Received: by mail-ia0-f202.google.com with SMTP id p22so632719iad.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 16:40:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yan@linux.vnet.ibm.com, axboe@kernel.dk, hindessm@uk.ibm.com, knikanth@suse.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: loopdev: ignore negative offset when calculate loop device size
has been added to the -mm tree.  Its filename is
     loopdev-ignore-negative-offset-when-calculate-loop-device-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
block-use-i_size_write-in-bd_set_size.patch
block-remove-redundant-check-to-bd_openers.patch
loopdev-fix-a-deadlock.patch
loopdev-update-block-device-size-in-loop_set_status.patch
loopdev-move-common-code-into-loop_figure_size.patch
loopdev-remove-an-user-triggerable-oops.patch
loopdev-ignore-negative-offset-when-calculate-loop-device-size.patch

