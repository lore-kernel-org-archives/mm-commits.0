From: akpm@linux-foundation.org
Subject: [merged] nbd-replace-some-printk-with-dev_warn-and-dev_info.patch removed from -mm tree
Date: Tue, 06 Sep 2011 12:16:56 -0700
Message-ID: <201109061912.p86JCi7w022218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501Ab1IFTMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 15:12:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, Paul.Clements@steeleye.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     nbd: replace some printk with dev_warn() and dev_info()
has been removed from the -mm tree.  Its filename was
     nbd-replace-some-printk-with-dev_warn-and-dev_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: replace some printk with dev_warn() and dev_info()
From: WANG Cong <amwang@redhat.com>

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/block/nbd.c~nbd-replace-some-printk-with-dev_warn-and-dev_info drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-replace-some-printk-with-dev_warn-and-dev_info
+++ a/drivers/block/nbd.c
@@ -127,8 +127,7 @@ static void sock_shutdown(struct nbd_dev
 	if (lock)
 		mutex_lock(&lo->tx_lock);
 	if (lo->sock) {
-		printk(KERN_WARNING "%s: shutting down socket\n",
-			lo->disk->disk_name);
+		dev_warn(disk_to_dev(lo->disk), "shutting down socket\n");
 		kernel_sock_shutdown(lo->sock, SHUT_RDWR);
 		lo->sock = NULL;
 	}
@@ -576,7 +575,7 @@ static int __nbd_ioctl(struct block_devi
 	case NBD_DISCONNECT: {
 		struct request sreq;
 
-	        printk(KERN_INFO "%s: NBD_DISCONNECT\n", lo->disk->disk_name);
+	        dev_info(disk_to_dev(lo->disk), "NBD_DISCONNECT\n");
 
 		blk_rq_init(NULL, &sreq);
 		sreq.cmd_type = REQ_TYPE_SPECIAL;
@@ -674,7 +673,7 @@ static int __nbd_ioctl(struct block_devi
 		file = lo->file;
 		lo->file = NULL;
 		nbd_clear_que(lo);
-		printk(KERN_WARNING "%s: queue cleared\n", lo->disk->disk_name);
+		dev_warn(disk_to_dev(lo->disk), "queue cleared\n");
 		if (file)
 			fput(file);
 		lo->bytesize = 0;
@@ -694,8 +693,8 @@ static int __nbd_ioctl(struct block_devi
 		return 0;
 
 	case NBD_PRINT_DEBUG:
-		printk(KERN_INFO "%s: next = %p, prev = %p, head = %p\n",
-			bdev->bd_disk->disk_name,
+		dev_info(disk_to_dev(lo->disk),
+			"next = %p, prev = %p, head = %p\n",
 			lo->queue_head.next, lo->queue_head.prev,
 			&lo->queue_head);
 		return 0;
_

Patches currently in -mm which might be from amwang@redhat.com are

numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
linux-next.patch
sched-fix-a-memory-leak-in-__sdt_free.patch
sysctl-make-config_sysctl_syscall-default-to-n.patch

