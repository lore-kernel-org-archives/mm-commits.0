From: akpm@linux-foundation.org
Subject: + usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch added to -mm tree
Date: Thu, 15 May 2008 17:02:05 -0700
Message-ID: <200805160002.m4G025ar017286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228AbYEPACe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 20:02:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cooloney@kernel.org, david-b@pacbell.net, gregkh@suse.de, harvey.harrison@gmail.com, jie.zhang@analog.com, stern@rowland.harvard.edu


The patch titled
     usb/host: use get/put_unaligned_* helpers to fix more potential unaligned issues.
has been added to the -mm tree.  Its filename is
     usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb/host: use get/put_unaligned_* helpers to fix more potential unaligned issues.
From: Bryan Wu <cooloney@kernel.org>

Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/isp116x-hcd.c |    4 ++--
 drivers/usb/host/uhci-hub.c    |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/usb/host/isp116x-hcd.c~usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues drivers/usb/host/isp116x-hcd.c
--- a/drivers/usb/host/isp116x-hcd.c~usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues
+++ a/drivers/usb/host/isp116x-hcd.c
@@ -1024,7 +1024,7 @@ static int isp116x_hub_control(struct us
 		break;
 	case GetHubStatus:
 		DBG("GetHubStatus\n");
-		*(__le32 *) buf = 0;
+		put_unaligned_le32(0, buf);
 		break;
 	case GetPortStatus:
 		DBG("GetPortStatus\n");
@@ -1033,7 +1033,7 @@ static int isp116x_hub_control(struct us
 		spin_lock_irqsave(&isp116x->lock, flags);
 		tmp = isp116x_read_reg32(isp116x, (--wIndex) ? HCRHPORT2 : HCRHPORT1);
 		spin_unlock_irqrestore(&isp116x->lock, flags);
-		*(__le32 *) buf = cpu_to_le32(tmp);
+		put_unaligned_le32(tmp, buf);
 		DBG("GetPortStatus: port[%d]  %08x\n", wIndex + 1, tmp);
 		break;
 	case ClearPortFeature:
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

origin.patch
video-logo-add-support-for-blackfin-linux-logo-for-framebuffer-console.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
git-watchdog.patch

