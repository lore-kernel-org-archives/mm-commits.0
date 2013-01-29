From: akpm@linux-foundation.org
Subject: + block-use-i_size_write-in-bd_set_size.patch added to -mm tree
Date: Mon, 28 Jan 2013 16:40:08 -0800
Message-ID: <20130129004009.675E031C25A@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:36077 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3A2AkK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Jan 2013 19:40:10 -0500
Received: by mail-oa0-f74.google.com with SMTP id h2so713031oag.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Jan 2013 16:40:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yan@linux.vnet.ibm.com, axboe@kernel.dk, hindessm@uk.ibm.com, knikanth@suse.de, viro@zeniv.linux.org.uk


The patch titled
     Subject: block: use i_size_write() in bd_set_size()
has been added to the -mm tree.  Its filename is
     block-use-i_size_write-in-bd_set_size.patch

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
Subject: block: use i_size_write() in bd_set_size()

blkdev_ioctl(GETBLKSIZE) uses i_size_read() to read size of block device. 
If we update block size directly, reader may see intermediate result in
some machines and configurations.  Use i_size_write() instead.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Guo Chao <yan@linux.vnet.ibm.com>
Cc: M. Hindess <hindessm@uk.ibm.com>
Cc: Nikanth Karthikesan <knikanth@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/block_dev.c~block-use-i_size_write-in-bd_set_size fs/block_dev.c
--- a/fs/block_dev.c~block-use-i_size_write-in-bd_set_size
+++ a/fs/block_dev.c
@@ -1033,7 +1033,9 @@ void bd_set_size(struct block_device *bd
 {
 	unsigned bsize = bdev_logical_block_size(bdev);
 
-	bdev->bd_inode->i_size = size;
+	mutex_lock(&bdev->bd_inode->i_mutex);
+	i_size_write(bdev->bd_inode, size);
+	mutex_unlock(&bdev->bd_inode->i_mutex);
 	while (bsize < PAGE_CACHE_SIZE) {
 		if (size & bsize)
 			break;
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

