From: akpm@linux-foundation.org
Subject: - usb-fix-suspend-to-ram.patch removed from -mm tree
Date: Tue, 22 May 2007 13:57:05 -0700
Message-ID: <200705222057.l4MKv4N5009610@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49123 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756353AbXEVU6t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 16:58:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stern@rowland.harvard.edu, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: fix suspend-to-RAM
has been removed from the -mm tree.  Its filename was
     usb-fix-suspend-to-ram.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb: fix suspend-to-RAM
From: Alan Stern <stern@rowland.harvard.edu>

unchangelogged.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/usb.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/core/usb.c~usb-fix-suspend-to-ram drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c~usb-fix-suspend-to-ram
+++ a/drivers/usb/core/usb.c
@@ -205,7 +205,7 @@ struct device_type usb_device_type = {
 
 static int ksuspend_usb_init(void)
 {
-	ksuspend_usb_wq = create_singlethread_workqueue("ksuspend_usbd");
+	ksuspend_usb_wq = create_freezeable_workqueue("ksuspend_usbd");
 	if (!ksuspend_usb_wq)
 		return -ENOMEM;
 	return 0;
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

git-scsi-rc-fixes.patch
hisax-fix-error-checking-for-hisax_register.patch
