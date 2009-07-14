From: akpm@linux-foundation.org
Subject: [merged] ti_usb_3410_5052c-fix-uninitialised-variable-in-ti_do_download.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:33:25 -0700
Message-ID: <200907142033.n6EKXP89013446@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756539AbZGNUdc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oliver@neukum.org, greg@kroah.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     ti_usb_3410_5052.c: fix uninitialised variable in ti_do_download
has been removed from the -mm tree.  Its filename was
     ti_usb_3410_5052c-fix-uninitialised-variable-in-ti_do_download.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ti_usb_3410_5052.c: fix uninitialised variable in ti_do_download
From: Oliver Neukum <oliver@neukum.org>

drivers/usb/serial/ti_usb_3410_5052.c: In function 'ti_startup':
drivers/usb/serial/ti_usb_3410_5052.c:1661: warning: 'status' may be used uninitialized in this function

Signed-off-by: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ti_usb_3410_5052.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/ti_usb_3410_5052.c~ti_usb_3410_5052c-fix-uninitialised-variable-in-ti_do_download drivers/usb/serial/ti_usb_3410_5052.c
--- a/drivers/usb/serial/ti_usb_3410_5052.c~ti_usb_3410_5052c-fix-uninitialised-variable-in-ti_do_download
+++ a/drivers/usb/serial/ti_usb_3410_5052.c
@@ -1657,7 +1657,7 @@ static int ti_do_download(struct usb_dev
 	u8 cs = 0;
 	int done;
 	struct ti_firmware_header *header;
-	int status;
+	int status = 0;
 	int len;
 
 	for (pos = sizeof(struct ti_firmware_header); pos < size; pos++)
_

Patches currently in -mm which might be from oliver@neukum.org are


