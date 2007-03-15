From: akpm@linux-foundation.org
Subject: - usb-serial-regression-fix.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:59:53 -0800
Message-ID: <200703152159.l2FLxrF3027848@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42621 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbXCOWAE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 18:00:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: radford@blackbean.org, greg@kroah.com, mlord@pobox.com, mm-commits@vger.kernel.org


The patch titled
     usb-serial regression fix
has been removed from the -mm tree.  Its filename was
     usb-serial-regression-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: usb-serial regression fix
From: Jim Radford <radford@blackbean.org>

Revert d9a7ecacac5f8274d2afce09aadcf37bdb42b93a since it breaks drivers
that need to access the ->port[] array in shutdown (most of them).

Signed-off-by: Jim Radford <radford@blackbean.org>
Acked-by: Mark Lord <mlord@pobox.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/usb-serial.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/usb/serial/usb-serial.c~usb-serial-regression-fix drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~usb-serial-regression-fix
+++ a/drivers/usb/serial/usb-serial.c
@@ -138,6 +138,11 @@ static void destroy_serial(struct kref *
 
 	dbg("%s - %s", __FUNCTION__, serial->type->description);
 
+	serial->type->shutdown(serial);
+
+	/* return the minor range that this device had */
+	return_serial(serial);
+
 	for (i = 0; i < serial->num_ports; ++i)
 		serial->port[i]->open_count = 0;
 
@@ -148,12 +153,6 @@ static void destroy_serial(struct kref *
 			serial->port[i] = NULL;
 		}
 
-	if (serial->type->shutdown)
-		serial->type->shutdown(serial);
-
-	/* return the minor range that this device had */
-	return_serial(serial);
-
 	/* If this is a "fake" port, we have to clean it up here, as it will
 	 * not get cleaned up in port_release() as it was never registered with
 	 * the driver core */
_

Patches currently in -mm which might be from radford@blackbean.org are

origin.patch
