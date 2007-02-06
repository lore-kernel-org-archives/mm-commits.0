From: akpm@linux-foundation.org
Subject: - cxacru-poll-for-device-status-more-frequently.patch removed from -mm tree
Date: Mon, 05 Feb 2007 16:39:58 -0800
Message-ID: <200702060041.l160f1KF005183@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41879 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965378AbXBFAlX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 19:41:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: simon@arlott.org, greg@kroah.com, simon@fire.lp0.eu, mm-commits@vger.kernel.org


The patch titled
     cxacru: poll for device status more frequently
has been removed from the -mm tree.  Its filename was
     cxacru-poll-for-device-status-more-frequently.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: cxacru: poll for device status more frequently
From: Simon Arlott <simon@arlott.org>

The device is only polled for status every 5 seconds yet status updates occur
as often as every second - when the line is down the status changes between
"down" and "attempting to activate" every 2 seconds.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/usb/atm/cxacru.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/atm/cxacru.c~cxacru-poll-for-device-status-more-frequently drivers/usb/atm/cxacru.c
--- a/drivers/usb/atm/cxacru.c~cxacru-poll-for-device-status-more-frequently
+++ a/drivers/usb/atm/cxacru.c
@@ -64,7 +64,7 @@ static const char cxacru_driver_name[] =
 #define SDRAM_ENA	0x1
 
 #define CMD_TIMEOUT	2000	/* msecs */
-#define POLL_INTERVAL	5000	/* msecs */
+#define POLL_INTERVAL	500	/* msecs */
 
 /* commands for interaction with the modem through the control channel before
  * firmware is loaded  */
_

Patches currently in -mm which might be from simon@arlott.org are
