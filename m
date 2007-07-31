From: akpm@linux-foundation.org
Subject: - usb_serial_suspend-buggy-code.patch removed from -mm tree
Date: Mon, 30 Jul 2007 23:33:38 -0700
Message-ID: <200707310633.l6V6XcHR019723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbXGaGe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 02:34:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oneukum@suse.de, bunk@stusta.de, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb_serial_suspend(): fix error return
has been removed from the -mm tree.  Its filename was
     usb_serial_suspend-buggy-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb_serial_suspend(): fix error return
From: Oliver Neukum <oneukum@suse.de>

Adrian said:

> Commit ec22559e0b7a05283a3413bda5d177e42c950e23 added the following
> function to drivers/usb/serial/usb-serial.c:
>
[..]
>
> The Coverity checker spotted the inconsequent NULL checking for "serial".
>
> Looking at the code it also doesn't seem to have been intended to always
> return 0.

Coverity is right. The check for NULL is wrongly done and the error
return is lost.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/usb-serial.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN drivers/usb/serial/usb-serial.c~usb_serial_suspend-buggy-code drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~usb_serial_suspend-buggy-code
+++ a/drivers/usb/serial/usb-serial.c
@@ -1077,16 +1077,17 @@ int usb_serial_suspend(struct usb_interf
 	struct usb_serial_port *port;
 	int i, r = 0;
 
-	if (serial) {
-		for (i = 0; i < serial->num_ports; ++i) {
-			port = serial->port[i];
-			if (port)
-				kill_traffic(port);
-		}
+	if (!serial) /* device has been disconnected */
+		return 0;
+
+	for (i = 0; i < serial->num_ports; ++i) {
+		port = serial->port[i];
+		if (port)
+			kill_traffic(port);
 	}
 
 	if (serial->type->suspend)
-		serial->type->suspend(serial, message);
+		r = serial->type->suspend(serial, message);
 
 	return r;
 }
_

Patches currently in -mm which might be from oneukum@suse.de are

origin.patch
git-hid.patch
