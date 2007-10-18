From: akpm@linux-foundation.org
Subject: - remove-unneded-lock_kernel-in-driver-block-loopc.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:19 -0700
Message-ID: <200710180653.l9I6rJ1F030429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53961 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761245AbXJRHjF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:39:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: diego@woitasen.com.ar, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     Remove unneeded lock_kernel() in driver/block/loop.c
has been removed from the -mm tree.  Its filename was
     remove-unneded-lock_kernel-in-driver-block-loopc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove unneeded lock_kernel() in driver/block/loop.c
From: Diego Woitasen <diego@woitasen.com.ar>

Signed-off-by: Diego Woitasen <diego@woitasen.com.ar>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/block/loop.c~remove-unneded-lock_kernel-in-driver-block-loopc drivers/block/loop.c
--- a/drivers/block/loop.c~remove-unneded-lock_kernel-in-driver-block-loopc
+++ a/drivers/block/loop.c
@@ -1285,7 +1285,6 @@ static long lo_compat_ioctl(struct file 
 	struct loop_device *lo = inode->i_bdev->bd_disk->private_data;
 	int err;
 
-	lock_kernel();
 	switch(cmd) {
 	case LOOP_SET_STATUS:
 		mutex_lock(&lo->lo_ctl_mutex);
@@ -1311,7 +1310,6 @@ static long lo_compat_ioctl(struct file 
 		err = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
 	return err;
 }
 #endif
_

Patches currently in -mm which might be from diego@woitasen.com.ar are

origin.patch
