From: akpm@linux-foundation.org
Subject: + floppy-handle-device_create_file-failure-while-init.patch added to -mm tree
Date: Wed, 07 Mar 2007 14:19:29 -0800
Message-ID: <200703072219.l27MJUVk010931@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34431 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992668AbXCGWUM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 17:20:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dmonakhov@sw.ru, dmonakhov@openvz.org


The patch titled
     floppy: handle device_create_file() failure while init
has been added to the -mm tree.  Its filename is
     floppy-handle-device_create_file-failure-while-init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: floppy: handle device_create_file() failure while init
From: Dmitriy Monakhov <dmonakhov@sw.ru>

This patch kills the "ignoring return value of 'device_create_file'"
warning message.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/block/floppy.c~floppy-handle-device_create_file-failure-while-init drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-handle-device_create_file-failure-while-init
+++ a/drivers/block/floppy.c
@@ -4334,7 +4334,10 @@ static int __init floppy_init(void)
 		if (err)
 			goto out_flush_work;
 
-		device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
+		err = device_create_file(&floppy_device[drive].dev,&dev_attr_cmos);
+		if (err)
+			goto out_unreg_platform_dev;
+
 		/* to be cleaned up... */
 		disks[drive]->private_data = (void *)(long)drive;
 		disks[drive]->queue = floppy_queue;
@@ -4345,6 +4348,8 @@ static int __init floppy_init(void)
 
 	return 0;
 
+out_unreg_platform_dev:
+	platform_device_unregister(&floppy_device[drive]);
 out_flush_work:
 	flush_scheduled_work();
 	if (usage_count)
_

Patches currently in -mm which might be from dmonakhov@sw.ru are

git-libata-all.patch
freevxfs-possible-null-pointer-dereference-fix.patch
reiserfs-possible-null-pointer-dereference-during-resize.patch
ext3-dirindex-error-pointer-issues.patch
floppy-handle-device_create_file-failure-while-init.patch
