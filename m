From: akpm@linux-foundation.org
Subject: + mousedev-fix-2.patch added to -mm tree
Date: Tue, 24 Apr 2007 23:03:20 -0700
Message-ID: <200704250603.l3P63KEp028265@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423216AbXDYGD0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 02:03:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@insightbb.com, dtor@mail.ru


The patch titled
     mousedev fix 2
has been added to the -mm tree.  Its filename is
     mousedev-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mousedev fix 2
From: Dmitry Torokhov <dtor@insightbb.com>

I was relying on implicit pinning of parent device via kobjectb/sysfs but
your tree may not pin it anymore.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mousedev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/input/mousedev.c~mousedev-fix-2 drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~mousedev-fix-2
+++ a/drivers/input/mousedev.c
@@ -368,6 +368,7 @@ static void mousedev_free(struct device 
 {
 	struct mousedev *mousedev = container_of(dev, struct mousedev, dev);
 
+	put_device(mousedev->dev.parent);
 	mousedev_table[mousedev->minor] = NULL;
 	kfree(mousedev);
 }
@@ -729,7 +730,7 @@ static struct mousedev *mousedev_create(
 		sizeof(mousedev->dev.bus_id));
 	mousedev->dev.class = &input_class;
 	if (dev)
-		mousedev->dev.parent = &dev->dev;
+		mousedev->dev.parent = get_device(&dev->dev);
 	mousedev->dev.devt = MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + minor);
 	mousedev->dev.release = mousedev_free;
 	device_initialize(&mousedev->dev);
_

Patches currently in -mm which might be from dtor@insightbb.com are

git-input.patch
input-convert-from-class-devices-to-standard-devices.patch
input-evdev-implement-proper-locking.patch
mousedev-fix.patch
mousedev-fix-2.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes.patch
input-rfkill-add-support-for-input-key-to-control-wireless-radio-fixes-fix.patch
