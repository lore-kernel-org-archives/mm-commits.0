From: akpm@linux-foundation.org
Subject: [merged] nbd-use-task_pid_nr-to-get-current-pid.patch removed from -mm tree
Date: Tue, 06 Sep 2011 12:16:47 -0700
Message-ID: <201109061912.p86JCZER022201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754501Ab1IFTMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Sep 2011 15:12:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, Paul.Clements@steeleye.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     nbd: use task_pid_nr() to get current pid
has been removed from the -mm tree.  Its filename was
     nbd-use-task_pid_nr-to-get-current-pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: use task_pid_nr() to get current pid
From: WANG Cong <amwang@redhat.com>

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/nbd.c~nbd-use-task_pid_nr-to-get-current-pid drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-use-task_pid_nr-to-get-current-pid
+++ a/drivers/block/nbd.c
@@ -405,7 +405,7 @@ static int nbd_do_it(struct nbd_device *
 
 	BUG_ON(lo->magic != LO_MAGIC);
 
-	lo->pid = current->pid;
+	lo->pid = task_pid_nr(current);
 	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
 	if (ret) {
 		printk(KERN_ERR "nbd: sysfs_create_file failed!");
_

Patches currently in -mm which might be from amwang@redhat.com are

numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled.patch
numa-fix-numa-compile-error-when-sysfs-and-procfs-are-disabled-fix.patch
linux-next.patch
sched-fix-a-memory-leak-in-__sdt_free.patch
sysctl-make-config_sysctl_syscall-default-to-n.patch

