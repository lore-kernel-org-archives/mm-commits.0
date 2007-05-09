From: akpm@linux-foundation.org
Subject: - nbd-check-the-return-value-of-sysfs_create_file.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:12 -0700
Message-ID: <200705092150.l49LoCam002782@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755123AbXEIVuQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     nbd: check the return value of sysfs_create_file
has been removed from the -mm tree.  Its filename was
     nbd-check-the-return-value-of-sysfs_create_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nbd: check the return value of sysfs_create_file
From: WANG Cong <xiyou.wangcong@gmail.com>

[akpm@linux-foundation.org: fix it]
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN drivers/block/nbd.c~nbd-check-the-return-value-of-sysfs_create_file drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-check-the-return-value-of-sysfs_create_file
+++ a/drivers/block/nbd.c
@@ -366,20 +366,25 @@ static struct disk_attribute pid_attr = 
 	.show = pid_show,
 };
 
-static void nbd_do_it(struct nbd_device *lo)
+static int nbd_do_it(struct nbd_device *lo)
 {
 	struct request *req;
+	int ret;
 
 	BUG_ON(lo->magic != LO_MAGIC);
 
 	lo->pid = current->pid;
-	sysfs_create_file(&lo->disk->kobj, &pid_attr.attr);
+	ret = sysfs_create_file(&lo->disk->kobj, &pid_attr.attr);
+	if (ret) {
+		printk(KERN_ERR "nbd: sysfs_create_file failed!");
+		return ret;
+	}
 
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);
 
 	sysfs_remove_file(&lo->disk->kobj, &pid_attr.attr);
-	return;
+	return 0;
 }
 
 static void nbd_clear_que(struct nbd_device *lo)
@@ -569,7 +574,9 @@ static int nbd_ioctl(struct inode *inode
 	case NBD_DO_IT:
 		if (!lo->file)
 			return -EINVAL;
-		nbd_do_it(lo);
+		error = nbd_do_it(lo);
+		if (error)
+			return error;
 		/* on return tidy up in case we have a signal */
 		/* Forcibly shutdown the socket causing all listeners
 		 * to error
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
partitions-check-the-return-value-of-kobject_add-etc.patch
