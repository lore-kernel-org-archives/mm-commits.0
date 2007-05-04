From: akpm@linux-foundation.org
Subject: + nbd-check-the-return-value-of-sysfs_create_file.patch added to -mm tree
Date: Thu, 03 May 2007 23:15:23 -0700
Message-ID: <200705040615.l446FNFn030446@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581AbXEDGP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 02:15:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, paul.clements@steeleye.com


The patch titled
     nbd: check the return value of sysfs_create_file
has been added to the -mm tree.  Its filename is
     nbd-check-the-return-value-of-sysfs_create_file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nbd: check the return value of sysfs_create_file
From: WANG Cong <xiyou.wangcong@gmail.com>

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/nbd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/block/nbd.c~nbd-check-the-return-value-of-sysfs_create_file drivers/block/nbd.c
--- a/drivers/block/nbd.c~nbd-check-the-return-value-of-sysfs_create_file
+++ a/drivers/block/nbd.c
@@ -373,7 +373,10 @@ static void nbd_do_it(struct nbd_device 
 	BUG_ON(lo->magic != LO_MAGIC);
 
 	lo->pid = current->pid;
-	sysfs_create_file(&lo->disk->kobj, &pid_attr.attr);
+	if (sysfs_create_file(&lo->disk->kobj, &pid_attr.attr)) {
+		printk(KERN_ERR "nbd: sysfs_create_file failed!");
+		return;
+	}
 
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

partitions-check-the-return-value-of-kobject_add-etc.patch
nbd-check-the-return-value-of-sysfs_create_file.patch
nbd-check-the-return-value-of-sysfs_create_file-fix.patch
vt-add-color-support-to-the-underline-and-italic-attributes-fix-2.patch
