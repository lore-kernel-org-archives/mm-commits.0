From: akpm@linux-foundation.org
Subject: - usb-serial-whiteheat-convert-to-generic-boolean.patch removed from -mm tree
Date: Mon, 02 Apr 2007 16:04:09 -0700
Message-ID: <200704022304.l32N492T011961@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52013 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966078AbXDBXES (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 2 Apr 2007 19:04:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ricknu-0@student.ltu.se, greg@kroah.com, stuartm@connecttech.com, mm-commits@vger.kernel.org


The patch titled
     usb/serial/whiteheat: Convert to generic boolean
has been removed from the -mm tree.  Its filename was
     usb-serial-whiteheat-convert-to-generic-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb/serial/whiteheat: Convert to generic boolean
From: Richard Knutsson <ricknu-0@student.ltu.se>

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: Greg KH <greg@kroah.com>
Acked-by: Stuart MacDonald <stuartm@connecttech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/whiteheat.c |    8 ++++----
 drivers/usb/serial/whiteheat.h |    4 ----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/usb/serial/whiteheat.c~usb-serial-whiteheat-convert-to-generic-boolean drivers/usb/serial/whiteheat.c
--- a/drivers/usb/serial/whiteheat.c~usb-serial-whiteheat-convert-to-generic-boolean
+++ a/drivers/usb/serial/whiteheat.c
@@ -1109,7 +1109,7 @@ static int firm_send_command (struct usb
 	command_port = port->serial->port[COMMAND_PORT];
 	command_info = usb_get_serial_port_data(command_port);
 	spin_lock_irqsave(&command_info->lock, flags);
-	command_info->command_finished = FALSE;
+	command_info->command_finished = false;
 	
 	transfer_buffer = (__u8 *)command_port->write_urb->transfer_buffer;
 	transfer_buffer[0] = command;
@@ -1124,12 +1124,12 @@ static int firm_send_command (struct usb
 	spin_unlock_irqrestore(&command_info->lock, flags);
 
 	/* wait for the command to complete */
-	wait_event_interruptible_timeout(command_info->wait_command, 
-		(command_info->command_finished != FALSE), COMMAND_TIMEOUT);
+	wait_event_interruptible_timeout(command_info->wait_command,
+		(bool)command_info->command_finished, COMMAND_TIMEOUT);
 
 	spin_lock_irqsave(&command_info->lock, flags);
 
-	if (command_info->command_finished == FALSE) {
+	if (command_info->command_finished == false) {
 		dbg("%s - command timed out.", __FUNCTION__);
 		retval = -ETIMEDOUT;
 		goto exit;
diff -puN drivers/usb/serial/whiteheat.h~usb-serial-whiteheat-convert-to-generic-boolean drivers/usb/serial/whiteheat.h
--- a/drivers/usb/serial/whiteheat.h~usb-serial-whiteheat-convert-to-generic-boolean
+++ a/drivers/usb/serial/whiteheat.h
@@ -20,10 +20,6 @@
 #define __LINUX_USB_SERIAL_WHITEHEAT_H
 
 
-#define FALSE	0
-#define TRUE	1
-
-
 /* WhiteHEAT commands */
 #define WHITEHEAT_OPEN			1	/* open the port */
 #define WHITEHEAT_CLOSE			2	/* close the port */
_

Patches currently in -mm which might be from ricknu-0@student.ltu.se are

git-agpgart.patch
git-netdev-all.patch
git-scsi-misc.patch
drivers-scsi-aic7xxx_old-convert-to-generic-boolean-values.patch
