From: akpm@osdl.org
Subject: - nbd-show-nbd-client-pid-in-sysfs.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:23 -0800
Message-ID: <200612072317.kB7NHNMa030923@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53815 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163830AbWLGXR1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paul.clements@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     nbd: show nbd client pid in sysfs
has been removed from the -mm tree.  Its filename was
     nbd-show-nbd-client-pid-in-sysfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nbd: show nbd client pid in sysfs
From: Paul Clements <paul.clements@steeleye.com>

Allow nbd to expose the nbd-client daemon's PID in /sys/block/nbd<x>/pid. 
This is helpful for tracking connection status of a device and for
determining which nbd devices are currently in use.

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/block/nbd.c |   16 ++++++++++++++++
 include/linux/nbd.h |    1 +
 2 files changed, 17 insertions(+)

diff -puN drivers/block/nbd.c~nbd-show-nbd-client-pid-in-sysfs drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-show-nbd-client-pid-in-sysfs
+++ a/drivers/block/nbd.c
@@ -355,14 +355,30 @@ harderror:
 	return NULL;
 }
 
+static ssize_t pid_show(struct gendisk *disk, char *page)
+{
+	return sprintf(page, "%ld\n",
+		(long) ((struct nbd_device *)disk->private_data)->pid);
+}
+
+static struct disk_attribute pid_attr = {
+	.attr = { .name = "pid", .mode = S_IRUGO },
+	.show = pid_show,
+};
+
 static void nbd_do_it(struct nbd_device *lo)
 {
 	struct request *req;
 
 	BUG_ON(lo->magic != LO_MAGIC);
 
+	lo->pid = current->pid;
+	sysfs_create_file(&lo->disk->kobj, &pid_attr.attr);
+
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);
+
+	sysfs_remove_file(&lo->disk->kobj, &pid_attr.attr);
 	return;
 }
 
diff -puN include/linux/nbd.h~nbd-show-nbd-client-pid-in-sysfs include/linux/nbd.h
--- a/include/linux/nbd.h~nbd-show-nbd-client-pid-in-sysfs
+++ a/include/linux/nbd.h
@@ -64,6 +64,7 @@ struct nbd_device {
 	struct gendisk *disk;
 	int blksize;
 	u64 bytesize;
+	pid_t pid; /* pid of nbd-client, if attached */
 };
 
 #endif
_

Patches currently in -mm which might be from paul.clements@steeleye.com are

origin.patch

