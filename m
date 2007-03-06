From: akpm@linux-foundation.org
Subject: - usb-serial-secret-patch.patch removed from -mm tree
Date: Mon, 05 Mar 2007 21:44:51 -0800
Message-ID: <200703060544.l265ip3i013644@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51958 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932654AbXCFFo5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 00:44:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oliver@neukum.org, greg@kroah.com, web.alexander@web.de, mm-commits@vger.kernel.org


The patch titled
     usb-serial: secret patch
has been removed from the -mm tree.  Its filename was
     usb-serial-secret-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb-serial: secret patch
From: Oliver Neukum <oliver@neukum.org>

> http://bugzilla.kernel.org/show_bug.cgi?id=8094
>
>            Summary: ipaq oops on connecting  "Vodafone VPA-II"
>     Kernel Version: 2.6.21-rc1-git1
>             Status: NEW
>           Severity: normal
>              Owner: greg@kroah.com
>          Submitter: web.alexander@web.de

Most likely a known bug I caused. This should help.



akpm:

	- it is unknown what this patch does
	- it _seems_ that it prevents the oops, but that's not clear
	- The post-2.6.18 regression appears to still be unfixed.

Cc: Greg KH <greg@kroah.com>
Cc: Alexander Weber <web.alexander@web.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/usb-serial.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/usb-serial.c~usb-serial-secret-patch drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~usb-serial-secret-patch
+++ a/drivers/usb/serial/usb-serial.c
@@ -827,7 +827,6 @@ int usb_serial_probe(struct usb_interfac
 			num_ports = type->num_ports;
 	}
 
-	serial->minor = minor;
 	serial->num_ports = num_ports;
 	serial->num_bulk_in = num_bulk_in;
 	serial->num_bulk_out = num_bulk_out;
@@ -981,6 +980,7 @@ int usb_serial_probe(struct usb_interfac
 		dev_err(&interface->dev, "No more free serial devices\n");
 		goto probe_error;
 	}
+	serial->minor = minor;
 
 	/* register all of the individual ports with the driver core */
 	for (i = 0; i < num_ports; ++i) {
_

Patches currently in -mm which might be from oliver@neukum.org are
