From: akpm@linux-foundation.org
Subject: + usb-serial-secret-patch.patch added to -mm tree
Date: Wed, 28 Feb 2007 22:47:57 -0800
Message-ID: <200703010647.l216lvo2006753@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57966 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932700AbXCAGsE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 01:48:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oliver@neukum.org, greg@kroah.com, web.alexander@web.de


The patch titled
     usb-serial: secret patch
has been added to the -mm tree.  Its filename is
     usb-serial-secret-patch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/serial/usb-serial.c~usb-serial-secret-patch drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~usb-serial-secret-patch
+++ a/drivers/usb/serial/usb-serial.c
@@ -826,7 +826,6 @@ int usb_serial_probe(struct usb_interfac
 			num_ports = type->num_ports;
 	}
 
-	serial->minor = minor;
 	serial->num_ports = num_ports;
 	serial->num_bulk_in = num_bulk_in;
 	serial->num_bulk_out = num_bulk_out;
@@ -980,6 +979,7 @@ int usb_serial_probe(struct usb_interfac
 		dev_err(&interface->dev, "No more free serial devices\n");
 		goto probe_error;
 	}
+	serial->minor = minor;
 
 	/* register all of the individual ports with the driver core */
 	for (i = 0; i < num_ports; ++i) {
_

Patches currently in -mm which might be from oliver@neukum.org are

usb-serial-secret-patch.patch
