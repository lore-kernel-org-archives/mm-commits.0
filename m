From: akpm@linux-foundation.org
Subject: - usb-debug-port-converter-does-not-accept-more-than-8-byte-packets.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:47:26 -0700
Message-ID: <200807020747.m627lQ13005648@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611AbYGBHr6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:47:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dared1st@yahoo.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     usb: debug port converter does not accept more than 8 byte packets
has been removed from the -mm tree.  Its filename was
     usb-debug-port-converter-does-not-accept-more-than-8-byte-packets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: usb: debug port converter does not accept more than 8 byte packets
From: Aleksey Gorelov <dared1st@yahoo.com>

USB debug port only supports 8 byte rx/tx packets.  Although spec implies
that "if a packet larger than eight bytes is received from the remote
computer, the device must break the larger packet into eight-byte packets
before sending the data to the Debug Port", the real PLX NET20DC device
does not handle it right - data is corrupted on debug port end if serial
interface sends >8 byte urbs.

The patch fixes the issue by limiting the tx urb to 8 byte.

Signed-off-by: Aleks Gorelov <dared1st@yahoo.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/usb_debug.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/usb/serial/usb_debug.c~usb-debug-port-converter-does-not-accept-more-than-8-byte-packets drivers/usb/serial/usb_debug.c
--- a/drivers/usb/serial/usb_debug.c~usb-debug-port-converter-does-not-accept-more-than-8-byte-packets
+++ a/drivers/usb/serial/usb_debug.c
@@ -15,6 +15,8 @@
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
 
+#define USB_DEBUG_MAX_PACKET_SIZE	8
+
 static struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x0525, 0x127a) },
 	{ },
@@ -29,6 +31,12 @@ static struct usb_driver debug_driver = 
 	.no_dynamic_id = 	1,
 };
 
+int usb_debug_open (struct usb_serial_port *port, struct file *filp)
+{
+	port->bulk_out_size = USB_DEBUG_MAX_PACKET_SIZE;
+	return usb_serial_generic_open(port, filp);
+}
+
 static struct usb_serial_driver debug_device = {
 	.driver = {
 		.owner =	THIS_MODULE,
@@ -36,6 +44,7 @@ static struct usb_serial_driver debug_de
 	},
 	.id_table =		id_table,
 	.num_ports =		1,
+	.open =            usb_debug_open,
 };
 
 static int __init debug_init(void)
_

Patches currently in -mm which might be from dared1st@yahoo.com are

linux-next.patch

