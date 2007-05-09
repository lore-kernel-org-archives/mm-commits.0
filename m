From: akpm@linux-foundation.org
Subject: - floppy-handle-device_create_file-failure-while-init.patch removed from -mm tree
Date: Tue, 08 May 2007 19:46:15 -0700
Message-ID: <200705090246.l492kFOY008828@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934142AbXEICqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@sw.ru, dmonakhov@openvz.org, mm-commits@vger.kernel.org


The patch titled
     floppy: handle device_create_file() failure while init
has been removed from the -mm tree.  Its filename was
     floppy-handle-device_create_file-failure-while-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: floppy: handle device_create_file() failure while init
From: Dmitriy Monakhov <dmonakhov@sw.ru>

This patch kills the "ignoring return value of 'device_create_file'"
warning message.

Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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

origin.patch
