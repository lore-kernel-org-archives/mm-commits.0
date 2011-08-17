From: akpm@linux-foundation.org
Subject: [alternative-merged] nbd-some-trivial-improvements.patch removed from -mm tree
Date: Wed, 17 Aug 2011 13:25:01 -0700
Message-ID: <201108172025.p7HKP1Ew026117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753730Ab1HQUZh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 16:25:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, Paul.Clements@steeleye.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     nbd: some trivial improvements
has been removed from the -mm tree.  Its filename was
     nbd-some-trivial-improvements.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nbd: some trivial improvements
From: Amerigo Wang <amwang@redhat.com>

1) use task_pid_nr(current) to get the pid of current process,

2) replace sysfs_create_file() with device_create_file()

3) lower the loglevel of an error message.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/block/nbd.c~nbd-some-trivial-improvements drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-some-trivial-improvements
+++ a/drivers/block/nbd.c
@@ -405,10 +405,10 @@ static int nbd_do_it(struct nbd_device *
 
 	BUG_ON(lo->magic != LO_MAGIC);
 
-	lo->pid = current->pid;
-	ret = sysfs_create_file(&disk_to_dev(lo->disk)->kobj, &pid_attr.attr);
+	lo->pid = task_pid_nr(current);
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
@@ -745,7 +745,7 @@ static int __init nbd_init(void)
 	BUILD_BUG_ON(sizeof(struct nbd_request) != 28);
 
 	if (max_part < 0) {
-		printk(KERN_CRIT "nbd: max_part must be >= 0\n");
+		printk(KERN_ERR "nbd: max_part must be >= 0\n");
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
drm-add-missing-header-file-linuc-typesh.patch
nbd-use-task_pid_nr-to-get-current-pid.patch
nbd-replace-sysfs_create_file-with-device_create_file.patch
nbd-replace-printk-kern_err-with-dev_err.patch
nbd-lower-the-loglevel-of-an-error-message.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info.patch
nbd-replace-some-printk-with-dev_warn-and-dev_info-checkpatch-fixes.patch

