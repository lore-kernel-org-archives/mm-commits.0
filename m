From: akpm@linux-foundation.org
Subject: [merged] quickcam_messengerc-possible-buffer-overflow-while-use-strncat.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:33:50 -0800
Message-ID: <200911302033.nAUKXoI5022063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751098AbZK3Uec (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:34:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: strakh@ispras.ru, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     quickcam_messenger.c: possible buffer overflow while use strncat
has been removed from the -mm tree.  Its filename was
     quickcam_messengerc-possible-buffer-overflow-while-use-strncat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quickcam_messenger.c: possible buffer overflow while use strncat
From: Alexander Strakh <strakh@ispras.ru>

In driver ./drivers/media/video/usbvideo/quickcam_messenger.c in line 91:

  91         usb_make_path(dev, cam->input_physname, sizeof(cam->input_physname));

After this line we use strncat:

  92         strncat(cam->input_physname, "/input0", sizeof(cam->input_physname));

where sizeof(cam->input_physname) returns length of cam->input_phisname
without length for null-symbol.  But this parameter must be - "maximum
numbers of bytes to copy", i.e.:
sizeof(cam->input_physname)-strlen(cam->input_physname)-1.

In this case, after call to usb_make_path the similar drivers use strlcat.

Like in: drivers/hid/usbhid/hid-core.c:
1152         usb_make_path(dev, hid->phys, sizeof(hid->phys));
1153         strlcat(hid->phys, "/input", sizeof(hid->phys));

Found by Linux Driver Verification Project.

Use strlcat instead of strncat.

Signed-off-by: Alexander Strakh <strakh@ispras.ru>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/usbvideo/quickcam_messenger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/usbvideo/quickcam_messenger.c~quickcam_messengerc-possible-buffer-overflow-while-use-strncat drivers/media/video/usbvideo/quickcam_messenger.c
--- a/drivers/media/video/usbvideo/quickcam_messenger.c~quickcam_messengerc-possible-buffer-overflow-while-use-strncat
+++ a/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -89,7 +89,7 @@ static void qcm_register_input(struct qc
 	int error;
 
 	usb_make_path(dev, cam->input_physname, sizeof(cam->input_physname));
-	strncat(cam->input_physname, "/input0", sizeof(cam->input_physname));
+	strlcat(cam->input_physname, "/input0", sizeof(cam->input_physname));
 
 	cam->input = input_dev = input_allocate_device();
 	if (!input_dev) {
_

Patches currently in -mm which might be from strakh@ispras.ru are

linux-next.patch
scsi_libc-avoid-calling-scsi_device_put-from-under-host_lock.patch

