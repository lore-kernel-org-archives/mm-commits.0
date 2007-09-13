From: akpm@linux-foundation.org
Subject: + v4l-fix-build-error-for-et61x251-driver.patch added to -mm tree
Date: Thu, 13 Sep 2007 15:48:54 -0700
Message-ID: <200709132248.l8DMmsGL009714@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbXIMWtf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 18:49:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aherrman@arcor.de, luca.risolia@studio.unibo.it, mchehab@infradead.org


The patch titled
     v4l: fix build error for et61x251 driver
has been added to the -mm tree.  Its filename is
     v4l-fix-build-error-for-et61x251-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: v4l: fix build error for et61x251 driver
From: Andreas Herrmann <aherrman@arcor.de>

Get rid of some v4l1 remainders to avoid kernel build errors if
V4L1_COMPAT is not selected:

  drivers/media/video/et61x251/et61x251_core.c: In et61x251_show_:
  drivers/media/video/et61x251/et61x251_core.c:718: error: implicit
    declaration of to_video_device

Fix as suggested by Luca Risolia <luca.risolia@studio.unibo.it>

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
Hacked-by: Luca Risolia <luca.risolia@studio.unibo.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/et61x251/et61x251_core.c |   24 +++++++++++------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff -puN drivers/media/video/et61x251/et61x251_core.c~v4l-fix-build-error-for-et61x251-driver drivers/media/video/et61x251/et61x251_core.c
--- a/drivers/media/video/et61x251/et61x251_core.c~v4l-fix-build-error-for-et61x251-driver
+++ a/drivers/media/video/et61x251/et61x251_core.c
@@ -714,7 +714,8 @@ static ssize_t et61x251_show_reg(struct 
 	if (mutex_lock_interruptible(&et61x251_sysfs_lock))
 		return -ERESTARTSYS;
 
-	cam = video_get_drvdata(to_video_device(cd));
+	cam = video_get_drvdata(container_of(cd, struct video_device,
+					     class_dev));
 	if (!cam) {
 		mutex_unlock(&et61x251_sysfs_lock);
 		return -ENODEV;
@@ -738,7 +739,8 @@ et61x251_store_reg(struct class_device* 
 	if (mutex_lock_interruptible(&et61x251_sysfs_lock))
 		return -ERESTARTSYS;
 
-	cam = video_get_drvdata(to_video_device(cd));
+	cam = video_get_drvdata(container_of(cd, struct video_device,
+					     class_dev));
 	if (!cam) {
 		mutex_unlock(&et61x251_sysfs_lock);
 		return -ENODEV;
@@ -770,7 +772,8 @@ static ssize_t et61x251_show_val(struct 
 	if (mutex_lock_interruptible(&et61x251_sysfs_lock))
 		return -ERESTARTSYS;
 
-	cam = video_get_drvdata(to_video_device(cd));
+	cam = video_get_drvdata(container_of(cd, struct video_device,
+					     class_dev));
 	if (!cam) {
 		mutex_unlock(&et61x251_sysfs_lock);
 		return -ENODEV;
@@ -802,7 +805,8 @@ et61x251_store_val(struct class_device* 
 	if (mutex_lock_interruptible(&et61x251_sysfs_lock))
 		return -ERESTARTSYS;
 
-	cam = video_get_drvdata(to_video_device(cd));
+	cam = video_get_drvdata(container_of(cd, struct video_device,
+					     class_dev));
 	if (!cam) {
 		mutex_unlock(&et61x251_sysfs_lock);
 		return -ENODEV;
@@ -838,7 +842,8 @@ static ssize_t et61x251_show_i2c_reg(str
 	if (mutex_lock_interruptible(&et61x251_sysfs_lock))
 		return -ERESTARTSYS;
 
-	cam = video_get_drvdata(to_video_device(cd));
+	cam = video_get_drvdata(container_of(cd, struct video_device,
+					     class_dev));
 	if (!cam) {
 		mutex_unlock(&et61x251_sysfs_lock);
 		return -ENODEV;
@@ -864,7 +869,8 @@ et61x251_store_i2c_reg(struct class_devi
 	if (mutex_lock_interruptible(&et61x251_sysfs_lock))
 		return -ERESTARTSYS;
 
-	cam = video_get_drvdata(to_video_device(cd));
+	cam = video_get_drvdata(container_of(cd, struct video_device,
+					     class_dev));
 	if (!cam) {
 		mutex_unlock(&et61x251_sysfs_lock);
 		return -ENODEV;
@@ -896,7 +902,8 @@ static ssize_t et61x251_show_i2c_val(str
 	if (mutex_lock_interruptible(&et61x251_sysfs_lock))
 		return -ERESTARTSYS;
 
-	cam = video_get_drvdata(to_video_device(cd));
+	cam = video_get_drvdata(container_of(cd, struct video_device,
+					     class_dev));
 	if (!cam) {
 		mutex_unlock(&et61x251_sysfs_lock);
 		return -ENODEV;
@@ -933,7 +940,8 @@ et61x251_store_i2c_val(struct class_devi
 	if (mutex_lock_interruptible(&et61x251_sysfs_lock))
 		return -ERESTARTSYS;
 
-	cam = video_get_drvdata(to_video_device(cd));
+	cam = video_get_drvdata(container_of(cd, struct video_device,
+					     class_dev));
 	if (!cam) {
 		mutex_unlock(&et61x251_sysfs_lock);
 		return -ENODEV;
_

Patches currently in -mm which might be from aherrman@arcor.de are

v4l-fix-build-error-for-et61x251-driver.patch
radeonfb-fix-setting-of-ppll_ref_div-for-rv370-5b60.patch
