From: akpm@linux-foundation.org
Subject: + usb-serial-fix-edgeport-regression-on-non-epic-devices.patch added to -mm tree
Date: Mon, 30 Jul 2007 15:51:49 -0700
Message-ID: <200707302251.l6UMpnIN002619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47183 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751888AbXG3Wwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 18:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akropel1@rochester.rr.com, Nick@NickAndBarb.net, greg@kroah.com, stable@kernel.org


The patch titled
     usb-serial: fix edgeport regression on non-EPiC devices
has been added to the -mm tree.  Its filename is
     usb-serial-fix-edgeport-regression-on-non-epic-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb-serial: fix edgeport regression on non-EPiC devices
From: Adam Kropelin <akropel1@rochester.rr.com>

Fix serious regression on non-EPiC edgeport usb-serial devices.  Baud rate
and MCR/LCR registers are not being written on these models due to apparent
copy-n-paste errors introduced with EPiC support.

Failure reported by Nick Pasich <Nick@NickAndBarb.net>.

Signed-off-by: Adam Kropelin <akropel1@rochester.rr.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/io_edgeport.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff -puN drivers/usb/serial/io_edgeport.c~usb-serial-fix-edgeport-regression-on-non-epic-devices drivers/usb/serial/io_edgeport.c
--- a/drivers/usb/serial/io_edgeport.c~usb-serial-fix-edgeport-regression-on-non-epic-devices
+++ a/drivers/usb/serial/io_edgeport.c
@@ -2366,9 +2366,8 @@ static int send_cmd_write_baud_rate (str
 	int status;
 	unsigned char number = edge_port->port->number - edge_port->port->serial->minor;
 
-	if ((!edge_serial->is_epic) ||
-	    ((edge_serial->is_epic) &&
-	     (!edge_serial->epic_descriptor.Supports.IOSPSetBaudRate))) {
+	if (edge_serial->is_epic &&
+	    !edge_serial->epic_descriptor.Supports.IOSPSetBaudRate) {
 		dbg("SendCmdWriteBaudRate - NOT Setting baud rate for port = %d, baud = %d",
 		    edge_port->port->number, baudRate);
 		return 0;
@@ -2461,18 +2460,16 @@ static int send_cmd_write_uart_register 
 
 	dbg("%s - write to %s register 0x%02x", (regNum == MCR) ? "MCR" : "LCR", __FUNCTION__, regValue);
 
-	if ((!edge_serial->is_epic) ||
-	    ((edge_serial->is_epic) &&
-	     (!edge_serial->epic_descriptor.Supports.IOSPWriteMCR) &&
-	     (regNum == MCR))) {
+	if (edge_serial->is_epic &&
+	    !edge_serial->epic_descriptor.Supports.IOSPWriteMCR &&
+	    regNum == MCR) {
 		dbg("SendCmdWriteUartReg - Not writing to MCR Register");
 		return 0;
 	}
 
-	if ((!edge_serial->is_epic) ||
-	    ((edge_serial->is_epic) &&
-	     (!edge_serial->epic_descriptor.Supports.IOSPWriteLCR) &&
-	     (regNum == LCR))) {
+	if (edge_serial->is_epic &&
+	    !edge_serial->epic_descriptor.Supports.IOSPWriteLCR &&
+	    regNum == LCR) {
 		dbg ("SendCmdWriteUartReg - Not writing to LCR Register");
 		return 0;
 	}
_

Patches currently in -mm which might be from akropel1@rochester.rr.com are

usb-serial-fix-edgeport-regression-on-non-epic-devices.patch
