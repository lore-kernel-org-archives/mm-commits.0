From: akpm@linux-foundation.org
Subject: - uml-handle-block-device-hotplug-errors.patch removed from -mm tree
Date: Mon, 07 May 2007 17:06:04 -0700
Message-ID: <200705080006.l48064ql009148@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967374AbXEHAG0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:06:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: handle block device hotplug errors
has been removed from the -mm tree.  Its filename was
     uml-handle-block-device-hotplug-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -puN arch/um/drivers/ubd_kern.c~uml-handle-block-device-hotplug-errors arch/um/drivers/ubd_kern.c
--- a/arch/um/drivers/ubd_kern.c~uml-handle-block-device-hotplug-errors
+++ a/arch/um/drivers/ubd_kern.c
@@ -788,14 +788,12 @@ static int ubd_id(char **str, int *start
 
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
@@ -806,9 +804,12 @@ static int ubd_remove(int n, char **erro
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
uml-hostfs-style-fixes.patch
uml-an-idle-system-should-have-zero-load-average.patch
remove-tas.patch
x86-create-asm-cmpxchgh.patch
uml-network-and-pcap-cleanup.patch
uml-pcap-devices-should-get-macs-from-command-line.patch
