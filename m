From: akpm@linux-foundation.org
Subject: [merged] usbtouchscreen-add-nexio-or-inexio-support.patch removed from -mm tree
Date: Fri, 05 Feb 2010 11:58:36 -0800
Message-ID: <201002051958.o15Jwa7M017879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38225 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933838Ab0BET66 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 14:58:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rainbow-software.org, daniel.ritz@gmx.ch, ddstreet@ieee.org, dmitry.torokhov@gmail.com, floe@butterbrot.org, greg@kroah.com, jim-linux@nurd.se, oliver@neukum.org, mm-commits@vger


The patch titled
     usbtouchscreen: add NEXIO (or iNexio) support
has been removed from the -mm tree.  Its filename was
     usbtouchscreen-add-nexio-or-inexio-support.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: usbtouchscreen: add NEXIO (or iNexio) support
=46rom: Ondrej Zary <linux@rainbow-software.org>

Add support for NEXIO (or iNexio) USB touchscreens to usbtouchscreen
driver.  Tested with NEX170MRT 17" LCD monitor with integrated touchscr=
een
(with xserver-xorg-input-evtouch 0.8.8-1):

T: =A0Bus=3D02 Lev=3D01 Prnt=3D01 Port=3D01 Cnt=3D01 Dev#=3D 54 Spd=3D1=
2 =A0MxCh=3D 0
D: =A0Ver=3D 1.10 Cls=3D02(comm.) Sub=3D00 Prot=3D00 MxPS=3D 8 #Cfgs=3D=
 =A01
P: =A0Vendor=3D1870 ProdID=3D0001 Rev=3D 1.00
S: =A0Manufacturer=3DiNexio
S: =A0Product=3DiNexio USB
C:* #Ifs=3D 2 Cfg#=3D 1 Atr=3Dc0 MxPwr=3D500mA
I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D02(comm.) Sub=3D02 Prot=3D00 Driv=
er=3D(none)
E: =A0Ad=3D83(I) Atr=3D03(Int.) MxPS=3D =A0 8 Ivl=3D255ms
I:* If#=3D 1 Alt=3D 0 #EPs=3D 2 Cls=3D0a(data ) Sub=3D00 Prot=3D00 Driv=
er=3D(none)
E: =A0Ad=3D01(O) Atr=3D02(Bulk) MxPS=3D =A064 Ivl=3D0ms
E: =A0Ad=3D82(I) Atr=3D02(Bulk) MxPS=3D =A064 Ivl=3D0ms

No datasheet is available, this was written by capturing some data with
SniffUSB in Windows: http://www.rainbow-software.org/linux_files/nexio/

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jim Persson <jim-linux@nurd.se>
Cc: Florian Echtler <floe@butterbrot.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oliver@neukum.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/Kconfig          |    5=20
 drivers/input/touchscreen/usbtouchscreen.c |  229 +++++++++++++++++++
 2 files changed, 234 insertions(+)

diff -puN drivers/input/touchscreen/Kconfig~usbtouchscreen-add-nexio-or=
-inexio-support drivers/input/touchscreen/Kconfig
--- a/drivers/input/touchscreen/Kconfig~usbtouchscreen-add-nexio-or-ine=
xio-support
+++ a/drivers/input/touchscreen/Kconfig
@@ -549,6 +549,11 @@ config TOUCHSCREEN_USB_ETT_TC5UH
 	bool "ET&T TC5UH touchscreen controler support" if EMBEDDED
 	depends on TOUCHSCREEN_USB_COMPOSITE
=20
+config TOUCHSCREEN_USB_NEXIO
+	default y
+	bool "NEXIO/iNexio device support" if EMBEDDED
+	depends on TOUCHSCREEN_USB_COMPOSITE
+
 config TOUCHSCREEN_TOUCHIT213
 	tristate "Sahara TouchIT-213 touchscreen"
 	select SERIO
diff -puN drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-add=
-nexio-or-inexio-support drivers/input/touchscreen/usbtouchscreen.c
--- a/drivers/input/touchscreen/usbtouchscreen.c~usbtouchscreen-add-nex=
io-or-inexio-support
+++ a/drivers/input/touchscreen/usbtouchscreen.c
@@ -15,6 +15,7 @@
  *  - GoTop Super_Q2/GogoPen/PenPower tablets
  *  - JASTEC USB touch controller/DigiTech DTR-02U
  *  - Zytronic capacitive touchscreen
+ *  - NEXIO/iNexio
  *
  * Copyright (C) 2004-2007 by Daniel Ritz <daniel.ritz@gmx.ch>
  * Copyright (C) by Todd E. Johnson (mtouchusb.c)
@@ -95,6 +96,7 @@ struct usbtouch_device_info {
=20
 	int  (*read_data)   (struct usbtouch_usb *usbtouch, unsigned char *pk=
t);
 	int  (*init)        (struct usbtouch_usb *usbtouch);
+	void (*exit)	    (struct usbtouch_usb *usbtouch);
 };
=20
 /* a usbtouch device */
@@ -109,6 +111,7 @@ struct usbtouch_usb {
 	struct usbtouch_device_info *type;
 	char name[128];
 	char phys[64];
+	void *priv;
=20
 	int x, y;
 	int touch, press;
@@ -133,6 +136,7 @@ enum {
 	DEVTYPE_E2I,
 	DEVTYPE_ZYTRONIC,
 	DEVTYPE_TC5UH,
+	DEVTYPE_NEXIO,
 };
=20
 #define USB_DEVICE_HID_CLASS(vend, prod) \
@@ -222,6 +226,14 @@ static const struct usb_device_id usbtou
 	{USB_DEVICE(0x0664, 0x0309), .driver_info =3D DEVTYPE_TC5UH},
 #endif
=20
+#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
+	/* data interface only */
+	{USB_DEVICE_AND_INTERFACE_INFO(0x10f0, 0x2002, 0x0a, 0x00, 0x00),
+		.driver_info =3D DEVTYPE_NEXIO},
+	{USB_DEVICE_AND_INTERFACE_INFO(0x1870, 0x0001, 0x0a, 0x00, 0x00),
+		.driver_info =3D DEVTYPE_NEXIO},
+#endif
+
 	{}
 };
=20
@@ -692,6 +704,211 @@ static int zytronic_read_data(struct usb
 #endif
=20
 /*********************************************************************=
********
+ * NEXIO Part
+ */
+#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
+
+#define NEXIO_TIMEOUT	5000
+#define NEXIO_BUFSIZE	1024
+#define NEXIO_THRESHOLD	50
+
+struct nexio_priv {
+	struct urb *ack;
+	unsigned char *ack_buf;
+};
+
+struct nexio_touch_packet {
+	u8	flags;		/* 0xe1 =3D touch, 0xe1 =3D release */
+	__be16	data_len;	/* total bytes of touch data */
+	__be16	x_len;		/* bytes for X axis */
+	__be16	y_len;		/* bytes for Y axis */
+	u8	data[];
+} __attribute__ ((packed));
+
+static unsigned char nexio_ack_pkt[2] =3D { 0xaa, 0x02 };
+static unsigned char nexio_init_pkt[4] =3D { 0x82, 0x04, 0x0a, 0x0f };
+
+static int nexio_init(struct usbtouch_usb *usbtouch)
+{
+	struct usb_device *dev =3D interface_to_usbdev(usbtouch->interface);
+	struct usb_host_interface *interface =3D usbtouch->interface->cur_alt=
setting;
+	struct nexio_priv *priv;
+	int ret =3D -ENOMEM;
+	int actual_len, i;
+	unsigned char *buf;
+	char *firmware_ver =3D NULL, *device_name =3D NULL;
+	int input_ep =3D 0, output_ep =3D 0;
+
+	/* find first input and output endpoint */
+	for (i =3D 0; i < interface->desc.bNumEndpoints; i++) {
+		if (!input_ep &&
+		    usb_endpoint_dir_in(&interface->endpoint[i].desc))
+			input_ep =3D interface->endpoint[i].desc.bEndpointAddress;
+		if (!output_ep &&
+		    usb_endpoint_dir_out(&interface->endpoint[i].desc))
+			output_ep =3D interface->endpoint[i].desc.bEndpointAddress;
+	}
+	if (!input_ep || !output_ep)
+		return -ENXIO;
+
+	buf =3D kmalloc(NEXIO_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		goto out_buf;
+	/* two empty reads */
+	for (i =3D 0; i < 2; i++) {
+		ret =3D usb_bulk_msg(dev, usb_rcvbulkpipe(dev, input_ep),
+				   buf, NEXIO_BUFSIZE, &actual_len,
+				   NEXIO_TIMEOUT);
+		if (ret < 0)
+			goto out_buf;
+	}
+	/* send init command */
+	memcpy(buf, nexio_init_pkt, sizeof(nexio_init_pkt));
+	ret =3D usb_bulk_msg(dev, usb_sndbulkpipe(dev, output_ep),
+			   buf, sizeof(nexio_init_pkt), &actual_len,
+			   NEXIO_TIMEOUT);
+	if (ret < 0)
+		goto out_buf;
+	/* read replies */
+	for (i =3D 0; i < 3; i++) {
+		memset(buf, 0, NEXIO_BUFSIZE);
+		ret =3D usb_bulk_msg(dev, usb_rcvbulkpipe(dev, input_ep),
+				   buf, NEXIO_BUFSIZE, &actual_len,
+				   NEXIO_TIMEOUT);
+		if (ret < 0 || actual_len < 1 || buf[1] !=3D actual_len)
+			continue;
+		switch (buf[0]) {
+			case 0x83:	/* firmware version */
+				if (!firmware_ver)
+					firmware_ver =3D kstrdup(&buf[2],
+							       GFP_KERNEL);
+				break;
+			case 0x84:	/* device name */
+				if (!device_name)
+					device_name =3D kstrdup(&buf[2],
+							      GFP_KERNEL);
+				break;
+		}
+	}
+	printk(KERN_INFO "Nexio device: %s, firmware version: %s\n",
+	       device_name, firmware_ver);
+	kfree(firmware_ver);
+	kfree(device_name);
+
+	/* prepare ACK URB */
+	ret =3D -ENOMEM;
+	usbtouch->priv =3D kmalloc(sizeof(struct nexio_priv), GFP_KERNEL);
+	if (!usbtouch->priv)
+		goto out_buf;
+	priv =3D usbtouch->priv;
+	priv->ack_buf =3D kmalloc(sizeof(nexio_ack_pkt), GFP_KERNEL);
+	if (!priv->ack_buf)
+		goto err_priv;
+	memcpy(priv->ack_buf, nexio_ack_pkt, sizeof(nexio_ack_pkt));
+	priv->ack =3D usb_alloc_urb(0, GFP_KERNEL);
+	if (!priv->ack) {
+		dbg("%s - usb_alloc_urb failed: usbtouch->ack", __func__);
+		goto err_ack_buf;
+	}
+	usb_fill_bulk_urb(priv->ack, dev, usb_sndbulkpipe(dev, output_ep),
+			  priv->ack_buf, sizeof(priv->ack_buf), NULL,
+			  usbtouch);
+	ret =3D 0;
+	goto out_buf;
+err_ack_buf:
+	kfree(priv->ack_buf);
+err_priv:
+	kfree(priv);
+out_buf:
+	kfree(buf);
+	return ret;
+}
+
+static void nexio_exit(struct usbtouch_usb *usbtouch)
+{
+	struct nexio_priv *priv =3D usbtouch->priv;
+
+	usb_kill_urb(priv->ack);
+	usb_free_urb(priv->ack);
+	kfree(priv);
+}
+
+static int nexio_read_data(struct usbtouch_usb *usbtouch, unsigned cha=
r *pkt)
+{
+	int x, y, begin_x, begin_y, end_x, end_y, w, h, ret;
+	struct nexio_touch_packet *packet =3D (void *) pkt;
+	struct nexio_priv *priv =3D usbtouch->priv;
+
+	/* got touch data? */
+	if ((pkt[0] & 0xe0) !=3D 0xe0)
+		return 0;
+
+	/* send ACK */
+	ret =3D usb_submit_urb(priv->ack, GFP_ATOMIC);
+
+	if (!usbtouch->type->max_xc) {
+		usbtouch->type->max_xc =3D 2 * be16_to_cpu(packet->x_len);
+		input_set_abs_params(usbtouch->input, ABS_X, 0,
+				     2 * be16_to_cpu(packet->x_len), 0, 0);
+		usbtouch->type->max_yc =3D 2 * be16_to_cpu(packet->y_len);
+		input_set_abs_params(usbtouch->input, ABS_Y, 0,
+				     2 * be16_to_cpu(packet->y_len), 0, 0);
+	}
+	/* The device reports state of IR sensors on X and Y axes.
+	 * Each byte represents "darkness" percentage (0-100) of one element.
+	 * 17" touchscreen reports only 64 x 52 bytes so the resolution is lo=
w.
+	 * This also means that there's a limited multi-touch capability but
+	 * it's disabled (and untested) here as there's no X driver for that.
+	 */
+	begin_x =3D end_x =3D begin_y =3D end_y =3D -1;
+	for (x =3D 0; x < be16_to_cpu(packet->x_len); x++) {
+		if (begin_x =3D=3D -1 && packet->data[x] > NEXIO_THRESHOLD) {
+			begin_x =3D x;
+			continue;
+		}
+		if (end_x =3D=3D -1 && begin_x !=3D -1 && packet->data[x] < NEXIO_TH=
RESHOLD) {
+			end_x =3D x - 1;
+			for (y =3D be16_to_cpu(packet->x_len);
+			     y < be16_to_cpu(packet->data_len); y++) {
+				if (begin_y =3D=3D -1 && packet->data[y] > NEXIO_THRESHOLD) {
+					begin_y =3D y - be16_to_cpu(packet->x_len);
+					continue;
+				}
+				if (end_y =3D=3D -1 &&
+				    begin_y !=3D -1 && packet->data[y] < NEXIO_THRESHOLD) {
+					end_y =3D y - 1 - be16_to_cpu(packet->x_len);
+					w =3D end_x - begin_x;
+					h =3D end_y - begin_y;
+					/* multi-touch */
+/*					input_report_abs(usbtouch->input,
+						    ABS_MT_TOUCH_MAJOR, max(w,h));
+					input_report_abs(usbtouch->input,
+						    ABS_MT_TOUCH_MINOR, min(x,h));
+					input_report_abs(usbtouch->input,
+						    ABS_MT_POSITION_X, 2*begin_x+w);
+					input_report_abs(usbtouch->input,
+						    ABS_MT_POSITION_Y, 2*begin_y+h);
+					input_report_abs(usbtouch->input,
+						    ABS_MT_ORIENTATION, w > h);
+					input_mt_sync(usbtouch->input);*/
+					/* single touch */
+					usbtouch->x =3D 2 * begin_x + w;
+					usbtouch->y =3D 2 * begin_y + h;
+					usbtouch->touch =3D packet->flags & 0x01;
+					begin_y =3D end_y =3D -1;
+					return 1;
+				}
+			}
+			begin_x =3D end_x =3D -1;
+		}
+
+	}
+	return 0;
+}
+#endif
+
+
+/*********************************************************************=
********
  * the different device descriptors
  */
 #ifdef MULTI_PACKET
@@ -875,6 +1092,16 @@ static struct usbtouch_device_info usbto
 		.read_data	=3D tc5uh_read_data,
 	},
 #endif
+
+#ifdef CONFIG_TOUCHSCREEN_USB_NEXIO
+	[DEVTYPE_NEXIO] =3D {
+		.rept_size	=3D 128,
+		.irq_always	=3D true,
+		.read_data	=3D nexio_read_data,
+		.init		=3D nexio_init,
+		.exit		=3D nexio_exit,
+	},
+#endif
 };
=20
=20
@@ -1196,6 +1423,8 @@ static void usbtouch_disconnect(struct u
 	/* this will stop IO via close */
 	input_unregister_device(usbtouch->input);
 	usb_free_urb(usbtouch->irq);
+	if (usbtouch->type->exit)
+		usbtouch->type->exit(usbtouch);
 	usbtouch_free_buffers(interface_to_usbdev(intf), usbtouch);
 	kfree(usbtouch);
 }
_

Patches currently in -mm which might be from linux@rainbow-software.org=
 are

linux-next.patch
g_ncr5380-remove-misleading-pnp-error-message.patch
g_ncr5380-fix-broken-mmio-compilation.patch
g_ncr5380-fix-missing-pnp_device_detach-and-scsi_unregister-on-rmmod.pa=
tch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
