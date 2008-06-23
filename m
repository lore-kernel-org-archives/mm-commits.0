From: akpm@linux-foundation.org
Subject: - usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:02:29 -0700
Message-ID: <200806232102.m5NL2TUg016080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756924AbYFWVC4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:02:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cooloney@kernel.org, david-b@pacbell.net, gregkh@suse.de, harvey.harrison@gmail.com, jie.zhang@analog.com, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     usb/host: use get/put_unaligned_* helpers to fix more potential unaligned issues.
has been removed from the -mm tree.  Its filename was
     usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb/host: use get/put_unaligned_* helpers to fix more potential unaligned issues.
From: Bryan Wu <cooloney@kernel.org>

[akpm@linux-foundation.org: drivers/usb/host/isp116x-hcd.c needs unaligned.h]
[akpm@linux-foundation.org: drivers/usb/host/uhci-hcd.c needs unaligned.h]
Reviewed-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/isp116x-hcd.c |    5 +++--
 drivers/usb/host/uhci-hcd.c    |    1 +
 drivers/usb/host/uhci-hub.c    |    6 +++---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/usb/host/isp116x-hcd.c~usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues drivers/usb/host/isp116x-hcd.c
--- a/drivers/usb/host/isp116x-hcd.c~usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues
+++ a/drivers/usb/host/isp116x-hcd.c
@@ -68,6 +68,7 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
+#include <asm/unaligned.h>
 #include <asm/system.h>
 #include <asm/byteorder.h>
 
@@ -1024,7 +1025,7 @@ static int isp116x_hub_control(struct us
 		break;
 	case GetHubStatus:
 		DBG("GetHubStatus\n");
-		*(__le32 *) buf = 0;
+		put_unaligned_le32(0, buf);
 		break;
 	case GetPortStatus:
 		DBG("GetPortStatus\n");
@@ -1033,7 +1034,7 @@ static int isp116x_hub_control(struct us
 		spin_lock_irqsave(&isp116x->lock, flags);
 		tmp = isp116x_read_reg32(isp116x, (--wIndex) ? HCRHPORT2 : HCRHPORT1);
 		spin_unlock_irqrestore(&isp116x->lock, flags);
-		*(__le32 *) buf = cpu_to_le32(tmp);
+		put_unaligned_le32(tmp, buf);
 		DBG("GetPortStatus: port[%d]  %08x\n", wIndex + 1, tmp);
 		break;
 	case ClearPortFeature:
diff -puN drivers/usb/host/uhci-hcd.c~usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues drivers/usb/host/uhci-hcd.c
--- a/drivers/usb/host/uhci-hcd.c~usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues
+++ a/drivers/usb/host/uhci-hcd.c
@@ -42,6 +42,7 @@
 #include <linux/dmi.h>
 
 #include <asm/uaccess.h>
+#include <asm/unaligned.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/system.h>
diff -puN drivers/usb/host/uhci-hub.c~usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues drivers/usb/host/uhci-hub.c
--- a/drivers/usb/host/uhci-hub.c~usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues
+++ a/drivers/usb/host/uhci-hub.c
@@ -253,7 +253,7 @@ static int uhci_hub_control(struct usb_h
 	switch (typeReq) {
 
 	case GetHubStatus:
-		*(__le32 *)buf = cpu_to_le32(0);
+		put_unaligned_le32(0, buf);
 		OK(4);		/* hub power */
 	case GetPortStatus:
 		if (port >= uhci->rh_numports)
@@ -306,8 +306,8 @@ static int uhci_hub_control(struct usb_h
 			dev_dbg(uhci_dev(uhci), "port %d portsc %04x,%02x\n",
 					wIndex, status, lstatus);
 
-		*(__le16 *)buf = cpu_to_le16(wPortStatus);
-		*(__le16 *)(buf + 2) = cpu_to_le16(wPortChange);
+		put_unaligned_le16(wPortStatus, buf);
+		put_unaligned_le16(wPortChange, buf + 2);
 		OK(4);
 	case SetHubFeature:		/* We don't implement these */
 	case ClearHubFeature:
_

Patches currently in -mm which might be from cooloney@kernel.org are

linux-next.patch
mtd-m25p80-fix-bug-atmel-spi-flash-fails-to-be-copied-to.patch

