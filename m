From: akpm@linux-foundation.org
Subject: + floppy-fix-hibernation.patch added to -mm tree
Date: Tue, 02 Jun 2009 15:16:02 -0700
Message-ID: <200906022216.n52MG2WW021201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbZFBWQ2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2009 18:16:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, jens.axboe@oracle.com, mingo@elte.hu, rjw@sisk.pl


The patch titled
     floppy: fix hibernation
has been added to the -mm tree.  Its filename is
     floppy-fix-hibernation.patch

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
Subject: floppy: fix hibernation
From: Ondrej Zary <linux@rainbow-software.org>

Based on Ingo Molnar's patch from 2006, this makes the floppy work after
resume from hibernation, at least on my machine.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff -puN drivers/block/floppy.c~floppy-fix-hibernation drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-fix-hibernation
+++ a/drivers/block/floppy.c
@@ -4148,6 +4148,24 @@ static void floppy_device_release(struct
 {
 }
 
+static int floppy_resume(struct platform_device *dev)
+{
+	int fdc;
+
+	for (fdc = 0; fdc < N_FDC; fdc++)
+		if (FDCS->address != -1)
+			user_reset_fdc(-1, FD_RESET_ALWAYS, 0);
+
+	return 0;
+}
+
+static struct platform_driver floppy_driver = {
+	.resume = floppy_resume,
+	.driver = {
+		.name = "floppy",
+	},
+};
+
 static struct platform_device floppy_device[N_DRIVE];
 
 static struct kobject *floppy_find(dev_t dev, int *part, void *data)
@@ -4196,10 +4214,14 @@ static int __init floppy_init(void)
 	if (err)
 		goto out_put_disk;
 
+	err = platform_driver_register(&floppy_driver);
+	if (err)
+		goto out_unreg_blkdev;
+
 	floppy_queue = blk_init_queue(do_fd_request, &floppy_lock);
 	if (!floppy_queue) {
 		err = -ENOMEM;
-		goto out_unreg_blkdev;
+		goto out_unreg_driver;
 	}
 	blk_queue_max_sectors(floppy_queue, 64);
 
@@ -4346,6 +4368,8 @@ out_flush_work:
 out_unreg_region:
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
 	blk_cleanup_queue(floppy_queue);
+out_unreg_driver:
+	platform_driver_unregister(&floppy_driver);
 out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 out_put_disk:
@@ -4566,6 +4590,7 @@ static void __exit floppy_module_exit(vo
 
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
+	platform_driver_unregister(&floppy_driver);
 
 	for (drive = 0; drive < N_DRIVE; drive++) {
 		del_timer_sync(&motor_off_timer[drive]);
_

Patches currently in -mm which might be from linux@rainbow-software.org are

agpgart-detected-ali-m-chipset-with-m1621.patch
floppy-fix-hibernation.patch

