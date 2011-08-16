From: akpm@linux-foundation.org
Subject: + nbd-some-trivial-improvements.patch added to -mm tree
Date: Tue, 16 Aug 2011 09:41:02 -0700
Message-ID: <201108161638.p7GGc9Ag002988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46104 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab1HPQip (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 12:38:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, Paul.Clements@steeleye.com, gregkh@suse.de


The patch titled
     nbd: some trivial improvements
has been added to the -mm tree.  Its filename is
     nbd-some-trivial-improvements.patch

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

origin.patch
linux-next.patch
drm-add-missing-header-file-linuc-typesh.patch
nbd-some-trivial-improvements.patch

