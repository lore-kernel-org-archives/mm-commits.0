From: akpm@linux-foundation.org
Subject: - usb-add-support-for-tru-install-c-and-new-vid-pids.patch removed from -mm tree
Date: Thu, 07 Jun 2007 18:23:57 -0700
Message-ID: <200706080123.l581NvEh014819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57213 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934487AbXFHBYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2007 21:24:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@sierrawireless.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     USB: add support for TRU-install (C) and new VID/PIDs to Sierra Wireless driver
has been removed from the -mm tree.  Its filename was
     usb-add-support-for-tru-install-c-and-new-vid-pids.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: USB: add support for TRU-install (C) and new VID/PIDs to Sierra Wireless driver
From: Kevin Lloyd <linux@sierrawireless.com>

Add support for the new TRU-install (C) feature (without this support new
devices will not work), and add new UMTS device VID/PIDs.

Signed-off-by: Kevin Lloyd <linux@sierrawireless.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/sierra.c |  206 +++++++++++++++++-----------------
 drivers/usb/serial/sierra.h |   25 ++++
 2 files changed, 131 insertions(+), 100 deletions(-)

diff -puN drivers/usb/serial/sierra.c~usb-add-support-for-tru-install-c-and-new-vid-pids drivers/usb/serial/sierra.c
--- a/drivers/usb/serial/sierra.c~usb-add-support-for-tru-install-c-and-new-vid-pids
+++ a/drivers/usb/serial/sierra.c
@@ -1,6 +1,8 @@
 /*
   USB Driver for Sierra Wireless
 
+  Targeted for 2.6.22 kernel
+
   Copyright (C) 2006  Kevin Lloyd <linux@sierrawireless.com>
 
   IMPORTANT DISCLAIMER: This driver is not commercially supported by
@@ -15,9 +17,9 @@
 
 */
 
-#define DRIVER_VERSION "v.1.0.6"
+#define DRIVER_VERSION "v.1.2.3"
 #define DRIVER_AUTHOR "Kevin Lloyd <linux@sierrawireless.com>"
-#define DRIVER_DESC "USB Driver for Sierra Wireless USB modems"
+#define DRIVER_DESC "USB Driver for Sierra Wireless modems"
 
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
@@ -28,66 +30,53 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
+#include "sierra.h"
+
+static int debug;
 
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
 	{ USB_DEVICE(0x1199, 0x0018) },	/* Sierra Wireless MC5720 */
+	{ USB_DEVICE(0x0f30, 0x1b1d) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
 	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
 	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
-	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless AirCard 595U */
 	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
+	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless USB Dongle 595U*/
+
 	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
 	{ USB_DEVICE(0x1199, 0x6803) },	/* Sierra Wireless MC8765 */
-	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 */
+	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 & AC 875U */
 	{ USB_DEVICE(0x1199, 0x6820) },	/* Sierra Wireless AirCard 875 */
+	{ USB_DEVICE(0x1199, 0x6832) },	/* Sierra Wireless MC8780*/
+	{ USB_DEVICE(0x1199, 0x6833) },	/* Sierra Wireless MC8781*/
+	{ USB_DEVICE(0x1199, 0x6850) },	/* Sierra Wireless AirCard 880 */
+	{ USB_DEVICE(0x1199, 0x6851) },	/* Sierra Wireless AirCard 881 */
+	{ USB_DEVICE(0x1199, 0x6852) },	/* Sierra Wireless AirCard 880 E */
+	{ USB_DEVICE(0x1199, 0x6853) },	/* Sierra Wireless AirCard 881 E */
 
-	{ USB_DEVICE(0x1199, 0x0112) }, /* Sierra Wireless AirCard 580 */
-	{ USB_DEVICE(0x0F3D, 0x0112) }, /* AirPrime/Sierra PC 5220 */
-	{ }
-};
-MODULE_DEVICE_TABLE(usb, id_table);
+	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
+	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
 
-static struct usb_device_id id_table_1port [] = {
-	{ USB_DEVICE(0x1199, 0x0112) }, /* Sierra Wireless AirCard 580 */
-	{ USB_DEVICE(0x0F3D, 0x0112) }, /* AirPrime/Sierra PC 5220 */
-	{ }
-};
 
-static struct usb_device_id id_table_3port [] = {
-	{ USB_DEVICE(0x1199, 0x0017) },	/* Sierra Wireless EM5625 */
-	{ USB_DEVICE(0x1199, 0x0018) },	/* Sierra Wireless MC5720 */
-	{ USB_DEVICE(0x1199, 0x0218) },	/* Sierra Wireless MC5720 */
-	{ USB_DEVICE(0x1199, 0x0020) },	/* Sierra Wireless MC5725 */
-	{ USB_DEVICE(0x1199, 0x0019) },	/* Sierra Wireless AirCard 595 */
-	{ USB_DEVICE(0x1199, 0x0120) },	/* Sierra Wireless AirCard 595U */
-	{ USB_DEVICE(0x1199, 0x0021) },	/* Sierra Wireless AirCard 597E */
-	{ USB_DEVICE(0x1199, 0x6802) },	/* Sierra Wireless MC8755 */
-	{ USB_DEVICE(0x1199, 0x6804) },	/* Sierra Wireless MC8755 */
-	{ USB_DEVICE(0x1199, 0x6803) },	/* Sierra Wireless MC8765 */
-	{ USB_DEVICE(0x1199, 0x6812) },	/* Sierra Wireless MC8775 */
-	{ USB_DEVICE(0x1199, 0x6820) },	/* Sierra Wireless AirCard 875 */
+	{ USB_DEVICE(0x1199, 0x0FFF), .driver_info = DEVICE_INSTALLER},
 	{ }
 };
+MODULE_DEVICE_TABLE(usb, id_table);
+
+int sierra_probe(struct usb_interface *iface, const struct usb_device_id *id);
+int sierra_set_power_state(struct usb_device *udev, unsigned long swiState);
+int sierra_set_ms_mode(struct usb_device *udev, SWIMS_SET_MODE_VALUE eSocMode);
 
 static struct usb_driver sierra_driver = {
 	.name       = "sierra",
-	.probe      = usb_serial_probe,
+	.probe      = sierra_probe,
 	.disconnect = usb_serial_disconnect,
 	.id_table   = id_table,
 	.no_dynamic_id = 	1,
 };
 
-
-static int debug;
-
-/* per port private data */
-#define N_IN_URB	4
-#define N_OUT_URB	4
-#define IN_BUFLEN	4096
-#define OUT_BUFLEN	128
-
 struct sierra_port_private {
 	/* Input endpoints and buffer for this port */
 	struct urb *in_urbs[N_IN_URB];
@@ -399,8 +388,6 @@ static int sierra_open(struct usb_serial
 	struct usb_serial *serial = port->serial;
 	int i, err;
 	struct urb *urb;
-	int result;
-	__u16 set_mode_dzero = 0x0000;
 
 	portdata = usb_get_serial_port_data(port);
 
@@ -447,12 +434,6 @@ static int sierra_open(struct usb_serial
 
 	port->tty->low_latency = 1;
 
-	/* set mode to D0 */
-	result = usb_control_msg(serial->dev,
-				 usb_rcvctrlpipe(serial->dev, 0),
-				 0x00, 0x40, set_mode_dzero, 0, NULL,
-				 0, USB_CTRL_SET_TIMEOUT);
-
 	sierra_send_setup(port);
 
 	return (0);
@@ -623,47 +604,18 @@ static void sierra_shutdown(struct usb_s
 	}
 }
 
-static struct usb_serial_driver sierra_1port_device = {
+static struct usb_serial_driver sierra_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
-		.name =		"sierra1",
+		.name =		"sierra",
 	},
-	.description       = "Sierra USB modem (1 port)",
-	.id_table          = id_table_1port,
+	.description       = "Sierra USB modem",
+	.id_table          = id_table,
 	.usb_driver        = &sierra_driver,
 	.num_interrupt_in  = NUM_DONT_CARE,
-	.num_bulk_in       = 1,
-	.num_bulk_out      = 1,
-	.num_ports         = 1,
-	.open              = sierra_open,
-	.close             = sierra_close,
-	.write             = sierra_write,
-	.write_room        = sierra_write_room,
-	.chars_in_buffer   = sierra_chars_in_buffer,
-	.throttle          = sierra_rx_throttle,
-	.unthrottle        = sierra_rx_unthrottle,
-	.ioctl             = sierra_ioctl,
-	.set_termios       = sierra_set_termios,
-	.break_ctl         = sierra_break_ctl,
-	.tiocmget          = sierra_tiocmget,
-	.tiocmset          = sierra_tiocmset,
-	.attach            = sierra_startup,
-	.shutdown          = sierra_shutdown,
-	.read_int_callback = sierra_instat_callback,
-};
-
-static struct usb_serial_driver sierra_3port_device = {
-	.driver = {
-		.owner =	THIS_MODULE,
-		.name =		"sierra3",
-	},
-	.description       = "Sierra USB modem (3 port)",
-	.id_table          = id_table_3port,
-	.usb_driver        = &sierra_driver,
-	.num_interrupt_in  = NUM_DONT_CARE,
-	.num_bulk_in       = 3,
-	.num_bulk_out      = 3,
-	.num_ports         = 3,
+	.num_bulk_in       = DEF_NUM_PORTS,
+	.num_bulk_out      = DEF_NUM_PORTS,
+	.num_ports         = DEF_NUM_PORTS,
 	.open              = sierra_open,
 	.close             = sierra_close,
 	.write             = sierra_write,
@@ -685,35 +637,89 @@ static struct usb_serial_driver sierra_3
 static int __init sierra_init(void)
 {
 	int retval;
-	retval = usb_serial_register(&sierra_1port_device);
+	dbg ("%s", __FUNCTION__);
+
+	retval = usb_serial_register(&sierra_device);
 	if (retval)
-		goto failed_1port_device_register;
-	retval = usb_serial_register(&sierra_3port_device);
+		return retval;
+	retval = usb_register(&sierra_driver);
 	if (retval)
-		goto failed_3port_device_register;
+		usb_serial_deregister(&sierra_device);
+	return retval;
+}
 
+static void __exit sierra_exit(void)
+{
+	usb_deregister (&sierra_driver);
+	usb_serial_deregister(&sierra_device);
+}
 
-	retval = usb_register(&sierra_driver);
-	if (retval)
-		goto failed_driver_register;
 
-	info(DRIVER_DESC ": " DRIVER_VERSION);
+int sierra_probe(struct usb_interface *iface, const struct usb_device_id *id)
+{
+	int result;
+	struct usb_device *udev;
 
-	return 0;
+	udev = usb_get_dev(interface_to_usbdev(iface));
 
-failed_driver_register:
-	usb_serial_deregister(&sierra_3port_device);
-failed_3port_device_register:
-	usb_serial_deregister(&sierra_1port_device);
-failed_1port_device_register:
-	return retval;
+	/*Set Device mode to D0 */
+	sierra_set_power_state(udev, 0x0000);
+
+	/* Check if in installer mode */
+	if (id->driver_info == DEVICE_INSTALLER)
+	{
+		dbg("SWIMS: FOUND DEVICE(SW)\n");
+		result = sierra_set_ms_mode(udev, SWIMS_SET_MODE_Modem);
+		dbg("SWIMS: swich result: %d\n",result);
+		return result;
+	}
+	/* Check if composite deviec */
+	else if (id->driver_info == DEVICE_1_PORT)
+	{
+		dbg("SWI: MODEM (Comp) FOUND");
+		sierra_device.num_ports = 1;
+		sierra_device.num_bulk_in = 1;
+		sierra_device.num_bulk_out = 1;
+	}
+	else /* Device default */
+	{
+		dbg("SWI: MODEM FOUND");
+		sierra_device.num_ports = DEF_NUM_PORTS;
+		sierra_device.num_bulk_in = DEF_NUM_PORTS;
+		sierra_device.num_bulk_out = DEF_NUM_PORTS;
+	}
+
+	return usb_serial_probe(iface, id);
 }
 
-static void __exit sierra_exit(void)
+int sierra_set_power_state(struct usb_device *udev, unsigned long swiState)
 {
-	usb_deregister (&sierra_driver);
-	usb_serial_deregister(&sierra_1port_device);
-	usb_serial_deregister(&sierra_3port_device);
+	int result;
+	dbg("SWI: POWER STATE");
+	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			0x00,			/* __u8 request      */
+			0x40,			/* __u8 request type */
+			swiState,		/* __u16 value       */
+			0,			/* __u16 index       */
+			NULL,			/* void *data        */
+			0,			/* __u16 size 	     */
+			USB_CTRL_SET_TIMEOUT);	/* int timeout 	     */
+	return result;
+}
+
+int sierra_set_ms_mode(struct usb_device *udev, SWIMS_SET_MODE_VALUE eSocMode)
+{
+	int result;
+	dbg("SWIMS: MS SWITCH");
+	result = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			SWIMS_USB_REQUEST_SetMode,	/* __u8 request      */
+			SWIMS_USB_REQUEST_TYPE_SetMode,	/* __u8 request type */
+			eSocMode,			/* __u16 value       */
+			SWIMS_USB_INDEX_SetMode,	/* __u16 index       */
+			NULL,				/* void *data        */
+			0,				/* __u16 size 	     */
+			USB_CTRL_SET_TIMEOUT);		/* int timeout       */
+	return result;
 }
 
 module_init(sierra_init);
diff -puN /dev/null drivers/usb/serial/sierra.h
--- /dev/null
+++ a/drivers/usb/serial/sierra.h
@@ -0,0 +1,25 @@
+#ifndef _SIERRA_MS_H
+#define _SIERRA_MS_H
+
+#define SWIMS_USB_REQUEST_SetMode	0x0B
+#define SWIMS_USB_REQUEST_TYPE_SetMode	0x40
+#define SWIMS_USB_INDEX_SetMode		0x0000
+#define SWIMS_SET_MODE_Modem		0x0001
+
+typedef __u16  SWIMS_SET_MODE_VALUE;
+
+enum devicetype {
+ DEVICE_3_PORT = 0,
+ DEVICE_1_PORT = 1,
+ DEVICE_INSTALLER = 2,
+};
+
+/* per port private data */
+#define N_IN_URB	4
+#define N_OUT_URB	4
+#define IN_BUFLEN	4096
+#define OUT_BUFLEN	1024
+
+#define DEF_NUM_PORTS 3
+
+#endif
_

Patches currently in -mm which might be from linux@sierrawireless.com are

usb-add-support-for-tru-install-c-and-new-vid-pids.patch
