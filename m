From: akpm@linux-foundation.org
Subject: + uml-handle-block-device-hotplug-errors.patch added to -mm tree
Date: Tue, 06 Mar 2007 17:23:47 -0800
Message-ID: <200703070123.l271NmBB015413@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41995 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161130AbXCGBXv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 20:23:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com


The patch titled
     uml: handle block device hotplug errors
has been added to the -mm tree.  Its filename is
     uml-handle-block-device-hotplug-errors.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: handle block device hotplug errors
From: Jeff Dike <jdike@addtoit.com>

If a disk fails to open, i.e.  its host file doesn't exist, it won't be
removable because the hot-unplug code checks the existence of its gendisk. 
This won't exist because it is only allocated for successfully opened disks. 
Thus, a typo on the command line can result in a unusable and unfixable disk.

This is fixed by freeing the gendisk if it's there, but not letting that
affect the removal.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/ubd_kern.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-handle-block-device-hotplug-errors arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-handle-block-device-hotplug-errors
+++ a/arch/um/drivers/ubd_kern.c
@@ -790,14 +790,12 @@ static int ubd_id(char **str, int *start
 
 static int ubd_remove(int n, char **error_out)
 {
+	struct gendisk *disk;
 	struct ubd *ubd_dev;
 	int err = -ENODEV;
 
 	mutex_lock(&ubd_lock);
 
-	if(ubd_gendisk[n] == NULL)
-		goto out;
-
 	ubd_dev = &ubd_devs[n];
 
 	if(ubd_dev->file == NULL)
@@ -808,9 +806,12 @@ static int ubd_remove(int n, char **erro
 	if(ubd_dev->count > 0)
 		goto out;
 
-	del_gendisk(ubd_gendisk[n]);
-	put_disk(ubd_gendisk[n]);
-	ubd_gendisk[n] = NULL;
+ 	disk = ubd_gendisk[n];
+ 	ubd_gendisk[n] = NULL;
+	if(disk != NULL){
+		del_gendisk(disk);
+		put_disk(disk);
+	}
 
 	if(fake_gendisk[n] != NULL){
 		del_gendisk(fake_gendisk[n]);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-audith-needs-linux-typesh.patch
uml-fix-formatting-violations-in-signal-delivery-code.patch
uml-add-a-debugging-message.patch
uml-comment-the-initialization-of-a-global.patch
uml-hostfs-fix-double-free.patch
uml-hostfs-make-hostfs=-option-work-as-a-jail-as-intended.patch
uml-fix-a-memory-leak-in-the-multicast-driver.patch
uml-remove-dead-code-about-os_usr1_signal-and-os_usr1_process.patch
uml-mark-both-consoles-as-con_anytime.patch
uml-fix-confusion-irq-early-reenabling.patch
uml-activate_fd-return-enomem-only-when-appropriate.patch
uml-fix-errno-usage.patch
div64_64-common-code.patch
remove-hardcoding-of-hard_smp_processor_id-on-up.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-mark-tt-mode-code-for-future-removal.patch
uml-print-coredump-limits.patch
uml-handle-block-device-hotplug-errors.patch
uml-driver-formatting-fixes.patch
uml-driver-formatting-fixes-fix.patch
uml-fix-prototypes.patch
