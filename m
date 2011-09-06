From: akpm@linux-foundation.org
Subject: [merged] nbd-replace-sysfs_create_file-with-device_create_file.patch removed from -mm tree
Date: Tue, 06 Sep 2011 12:16:50 -0700
Message-ID: <201109061912.p86JCcKi022204@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543Ab1IFTMq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 15:12:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, Paul.Clements@steeleye.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     nbd: replace sysfs_create_file() with device_create_file()
has been removed from the -mm tree.  Its filename was
     nbd-replace-sysfs_create_file-with-device_create_file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: replace sysfs_create_file() with device_create_file()
From: WANG Cong <amwang@redhat.com>

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/block/nbd.c~nbd-replace-sysfs_create_file-with-device_create_file drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-replace-sysfs_create_file-with-device_create_file
+++ a/drivers/block/nbd.c
@@ -406,9 +406,9 @@ static int nbd_do_it(struct nbd_device *
 	BUG_ON(lo->magic != LO_MAGIC);
 
 	lo->pid = task_pid_nr(current);
-	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
+	ret = device_create_file(disk_to_dev(lo->disk), &pid_attr);
 	if (ret) {
-		printk(KERN_ERR "nbd: sysfs_create_file failed!");
+		printk(KERN_ERR "nbd: device_create_file failed!");
 		lo->pid = 0;
 		return ret;
 	}
@@ -416,7 +416,7 @@ static int nbd_do_it(struct nbd_device *
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);
 
-	sysfs_remove_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
+	device_remove_file(disk_to_dev(lo->disk), &pid_attr);
 	lo->pid = 0;
 	return 0;
 }
_

Patches currently in -mm which might be from amwang@redhat.com are

numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
linux-next.patch
sched-fix-a-memory-leak-in-__sdt_free.patch
sysctl-make-config_sysctl_syscall-default-to-n.patch

