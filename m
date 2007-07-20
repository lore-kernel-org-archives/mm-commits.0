From: akpm@linux-foundation.org
Subject: + remove-unneded-lock_kernel-in-driver-block-loopc.patch added to -mm tree
Date: Thu, 19 Jul 2007 17:33:18 -0700
Message-ID: <200707200033.l6K0XIXb030888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36564 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755986AbXGTAdZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 20:33:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: diego@woitasen.com.ar


The patch titled
     Remove unneded lock_kernel() in driver/block/loop.c
has been added to the -mm tree.  Its filename is
     remove-unneded-lock_kernel-in-driver-block-loopc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove unneded lock_kernel() in driver/block/loop.c
From: Diego Woitasen <diego@woitasen.com.ar>

Signed-off-by: Diego Woitasen <diego@woitasen.com.ar>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    2 --
 1 files changed, 2 deletions(-)

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

remove-unneded-lock_kernel-in-driver-block-loopc.patch
