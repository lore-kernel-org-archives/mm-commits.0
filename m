From: akpm@linux-foundation.org
Subject: + nbd-replace-some-printk-with-dev_warn-and-dev_info.patch added to -mm tree
Date: Wed, 17 Aug 2011 13:23:19 -0700
Message-ID: <201108172023.p7HKNJAh026027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38054 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923Ab1HQUXv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 16:23:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, Paul.Clements@steeleye.com, axboe@kernel.dk


The patch titled
     nbd: replace some printk with dev_warn() and dev_info()
has been added to the -mm tree.  Its filename is
     nbd-replace-some-printk-with-dev_warn-and-dev_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
drm-add-missing-header-file-linuc-typesh.patch
nbd-use-task_pid_nr-to-get-current-pid.patch
nbd-replace-sysfs_create_file-with-device_create_file.patch
nbd-replace-printk-kern_err-with-dev_err.patch
nbd-lower-the-loglevel-of-an-error-message.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info.patch
nbd-some-trivial-improvements.patch

