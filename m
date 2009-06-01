From: akpm@linux-foundation.org
Subject: + v4l-pwc-use-usb_interface-as-parent-not-usb_device.patch added to -mm tree
Date: Mon, 01 Jun 2009 14:49:22 -0700
Message-ID: <200906012149.n51LnM3K006142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458AbZFAVuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 17:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mzxreary@0pointer.de, kay.sievers@vrfy.org, mchehab@infradead.org


The patch titled
     V4L/pwc: use usb_interface as parent, not usb_device
has been added to the -mm tree.  Its filename is
     v4l-pwc-use-usb_interface-as-parent-not-usb_device.patch

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

v4l-pwc-use-usb_interface-as-parent-not-usb_device.patch
v4l-generate-key_camera-instead-of-btn_0-key-events-on-input-devices.patch

