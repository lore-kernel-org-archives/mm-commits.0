From: akpm@osdl.org
Subject: + cxacru-poll-for-device-status-more-frequently.patch added to -mm tree
Date: Wed, 31 Jan 2007 15:43:16 -0800
Message-ID: <200701312343.l0VNhGlX030256@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59152 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161086AbXAaXoD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 18:44:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: simon@arlott.org, greg@kroah.com, simon@fire.lp0.eu


The patch titled
     cxacru: poll for device status more frequently
has been added to the -mm tree.  Its filename is
     cxacru-poll-for-device-status-more-frequently.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

usbatm-allow-sub-drivers-to-handle-calls-to-atm_proc_read.patch
cxacru-poll-for-device-status-more-frequently.patch
cxacru-store-all-device-status-information-and-report-it-when-atm_proc_read-is-called.patch
