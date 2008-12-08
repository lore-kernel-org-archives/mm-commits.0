From: akpm@linux-foundation.org
Subject: - tty-sprogii-dcc-controller-identifiers.patch removed from -mm tree
Date: Mon, 08 Dec 2008 15:24:33 -0800
Message-ID: <200812082324.mB8NOX6i007058@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbYLHXeq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 18:34:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     tty: SprogII DCC controller identifiers
has been removed from the -mm tree.  Its filename was
     tty-sprogii-dcc-controller-identifiers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty: SprogII DCC controller identifiers
From: Alan Cox <alan@redhat.com>

Someone on rmweb reminded me this had been overlooked from ages ago..

Add the identifiers for the Sprog II USB. This is a DCC control interface
using the FTDI-SIO hardware: http://www.sprog-dcc.co.uk/. People have been
using it with insmod options for ages, this just puts it into the driver
data.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/ftdi_sio.c |    1 +
 drivers/usb/serial/ftdi_sio.h |    3 +++
 2 files changed, 4 insertions(+)

diff -puN drivers/usb/serial/ftdi_sio.c~tty-sprogii-dcc-controller-identifiers drivers/usb/serial/ftdi_sio.c
--- a/drivers/usb/serial/ftdi_sio.c~tty-sprogii-dcc-controller-identifiers
+++ a/drivers/usb/serial/ftdi_sio.c
@@ -166,6 +166,7 @@ static struct usb_device_id id_table_com
 	{ USB_DEVICE(FTDI_VID, FTDI_OPENDCC_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_IOBOARD_PID) },
 	{ USB_DEVICE(INTERBIOMETRICS_VID, INTERBIOMETRICS_MINI_IOBOARD_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_SPROG_II) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_632_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_634_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_XF_547_PID) },
diff -puN drivers/usb/serial/ftdi_sio.h~tty-sprogii-dcc-controller-identifiers drivers/usb/serial/ftdi_sio.h
--- a/drivers/usb/serial/ftdi_sio.h~tty-sprogii-dcc-controller-identifiers
+++ a/drivers/usb/serial/ftdi_sio.h
@@ -75,6 +75,9 @@
 /* OpenDCC (www.opendcc.de) product id */
 #define FTDI_OPENDCC_PID	0xBFD8
 
+/* Sprog II (Andrew Crosland's SprogII DCC interface) */
+#define FTDI_SPROG_II		0xF0C8
+
 /* www.crystalfontz.com devices - thanx for providing free devices for evaluation ! */
 /* they use the ftdi chipset for the USB interface and the vendor id is the same */
 #define FTDI_XF_632_PID 0xFC08	/* 632: 16x2 Character Display */
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
linux-next.patch

