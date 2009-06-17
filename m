From: akpm@linux-foundation.org
Subject: [merged] v4l-pwc-use-usb_interface-as-parent-not-usb_device.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:40:06 -0700
Message-ID: <200906171840.n5HIe6aN006107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756774AbZFQSrA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:47:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mzxreary@0pointer.de, kay.sievers@vrfy.org, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     V4L/pwc: use usb_interface as parent, not usb_device
has been removed from the -mm tree.  Its filename was
     v4l-pwc-use-usb_interface-as-parent-not-usb_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: V4L/pwc: use usb_interface as parent, not usb_device
From: Lennart Poettering <mzxreary@0pointer.de>

The current code creates a sysfs device path where the video4linux device
is child of the usb device itself instead of the interface it belongs to. 
That is evil and confuses udev.

This patch does basically the same thing as Kay's similar patch for the
ov511 driver:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ce96d0a44a4f8d1bb3dc12b5e98cb688c1bc730d

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Lennart Poettering <mzxreary@0pointer.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/pwc/pwc-if.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/pwc/pwc-if.c~v4l-pwc-use-usb_interface-as-parent-not-usb_device drivers/media/video/pwc/pwc-if.c
--- a/drivers/media/video/pwc/pwc-if.c~v4l-pwc-use-usb_interface-as-parent-not-usb_device
+++ a/drivers/media/video/pwc/pwc-if.c
@@ -1783,7 +1783,7 @@ static int usb_pwc_probe(struct usb_inte
 		return -ENOMEM;
 	}
 	memcpy(pdev->vdev, &pwc_template, sizeof(pwc_template));
-	pdev->vdev->parent = &(udev->dev);
+	pdev->vdev->parent = &intf->dev;
 	strcpy(pdev->vdev->name, name);
 	video_set_drvdata(pdev->vdev, pdev);
 
_

Patches currently in -mm which might be from mzxreary@0pointer.de are

origin.patch
linux-next.patch

