From: akpm@linux-foundation.org
Subject: + add-sny6001-device-handling-sonypi-reimplementation.patch added to -mm tree
Date: Fri, 06 Apr 2007 18:32:28 -0700
Message-ID: <200704070132.l371WS5t024866@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41986 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964888AbXDGBeW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 21:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: malattia@linux.it, lenb@kernel.org, stelian@popies.net


The patch titled
     sony-laptop: add SNY6001 device handling (sonypi reimplementation)
has been added to the -mm tree.  Its filename is
     add-sny6001-device-handling-sonypi-reimplementation.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: sony-laptop: add SNY6001 device handling (sonypi reimplementat=
ion)
=46rom: Mattia Dongili <malattia@linux.it>

Reimplement sonypi using ACPI only functions.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>
Cc: Stelian Pop <stelian@popies.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sony-laptop.c | 1085 ++++++++++++++++++++++++++++++++++-
 1 file changed, 1072 insertions(+), 13 deletions(-)

diff -puN drivers/misc/sony-laptop.c~add-sny6001-device-handling-sonypi=
-reimplementation drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~add-sny6001-device-handling-sonypi-rei=
mplementation
+++ a/drivers/misc/sony-laptop.c
@@ -1,5 +1,5 @@
 /*
- * ACPI Sony Notebook Control Driver (SNC)
+ * ACPI Sony Notebook Control Driver (SNC and SPIC)
  *
  * Copyright (C) 2004-2005 Stelian Pop <stelian@popies.net>
  * Copyright (C) 2007 Mattia Dongili <malattia@linux.it>
@@ -7,6 +7,25 @@
  * Parts of this driver inspired from asus_acpi.c and ibm_acpi.c
  * which are copyrighted by their respective authors.
  *
+ * The SNY6001 driver part is based on the sonypi driver which include=
s
+ * material from:
+ *
+ * Copyright (C) 2001-2005 Stelian Pop <stelian@popies.net>
+ *
+ * Copyright (C) 2005 Narayanan R S <nars@kadamba.org>
+ *
+ * Copyright (C) 2001-2002 Alc=F4ve <www.alcove.com>
+ *
+ * Copyright (C) 2001 Michael Ashley <m.ashley@unsw.edu.au>
+ *
+ * Copyright (C) 2001 Junichi Morita <jun1m@mars.dti.ne.jp>
+ *
+ * Copyright (C) 2000 Takaya Kinjo <t-kinjo@tc4.so-net.ne.jp>
+ *
+ * Copyright (C) 2000 Andrew Tridgell <tridge@valinux.com>
+ *
+ * Earlier work by Werner Almesberger, Paul `Rusty' Russell and Paul M=
ackerras.
+ *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License as published b=
y
  * the Free Software Foundation; either version 2 of the License, or
@@ -31,32 +50,65 @@
 #include <linux/backlight.h>
 #include <linux/platform_device.h>
 #include <linux/err.h>
+#include <linux/dmi.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/input.h>
+#include <linux/kfifo.h>
+#include <linux/workqueue.h>
+#include <linux/acpi.h>
 #include <acpi/acpi_drivers.h>
 #include <acpi/acpi_bus.h>
 #include <asm/uaccess.h>
+#include <linux/sonypi.h>
=20
-#define LOG_PFX			KERN_WARNING "sony-laptop: "
+#define DRV_PFX			"sony-laptop: "
+#define LOG_PFX			KERN_WARNING DRV_PFX
 #define dprintk(msg...)		do {			\
-	if (debug) printk(KERN_WARNING LOG_PFX  msg);	\
+	if (debug) printk(LOG_PFX  msg);		\
 } while (0)
=20
-#define SONY_NC_CLASS		"sony"
+#define SONY_LAPTOP_DRIVER_VERSION	"0.5"
+
+#define SONY_NC_CLASS		"sony-nc"
 #define SONY_NC_HID		"SNY5001"
-#define SONY_NC_DRIVER_NAME	"ACPI Sony Notebook Control Driver v0.4"
+#define SONY_NC_DRIVER_NAME	"Sony Notebook Control"
=20
-/* the device uses 1-based values, while the backlight subsystem uses
-   0-based values */
-#define SONY_MAX_BRIGHTNESS	8
+#define SONY_PIC_CLASS		"sony-pic"
+#define SONY_PIC_HID		"SNY6001"
+#define SONY_PIC_DRIVER_NAME	"Sony Programmable IO Control"
=20
 MODULE_AUTHOR("Stelian Pop, Mattia Dongili");
-MODULE_DESCRIPTION(SONY_NC_DRIVER_NAME);
+MODULE_DESCRIPTION("Sony laptop extras driver (SPIC and SNC ACPI devic=
e)");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(SONY_LAPTOP_DRIVER_VERSION);
=20
 static int debug;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, "set this to 1 (and RTFM) if you want to help =
"
 		 "the development of this driver");
=20
+static int no_spic;		/* =3D 0 */
+module_param(no_spic, int, 0444);
+MODULE_PARM_DESC(no_spic,
+		 "set this if you don't want to enable the SPIC device");
+
+static int compat;		/* =3D 0 */
+module_param(compat, int, 0444);
+MODULE_PARM_DESC(compat,
+		 "set this if you want to enable backward compatibility mode");
+
+static int force_jog;		/* =3D 0 */
+module_param(force_jog, int, 0444);
+MODULE_PARM_DESC(force_jog,
+		 "set this if the driver doesn't detect your jogdial");
+
+static unsigned long mask =3D 0xffffffff;
+module_param(mask, ulong, 0644);
+MODULE_PARM_DESC(mask,
+		 "set this to the mask of event you want to enable (see doc)");
+
 /*********** Platform Device ***********/
=20
 static atomic_t sony_pf_users =3D ATOMIC_INIT(0);
@@ -115,6 +167,13 @@ static void sony_pf_remove(void)
=20
 /*********** SNC (SNY5001) Device ***********/
=20
+/* the device uses 1-based values, while the backlight subsystem uses
+   0-based values */
+#define SONY_MAX_BRIGHTNESS	8
+
+#define SNC_VALIDATE_IN		0
+#define SNC_VALIDATE_OUT	1
+
 static ssize_t sony_nc_sysfs_show(struct device *, struct device_attri=
bute *,
 			      char *);
 static ssize_t sony_nc_sysfs_store(struct device *, struct device_attr=
ibute *,
@@ -122,9 +181,6 @@ static ssize_t sony_nc_sysfs_store(struc
 static int boolean_validate(const int, const int);
 static int brightness_default_validate(const int, const int);
=20
-#define SNC_VALIDATE_IN		0
-#define SNC_VALIDATE_OUT	1
-
 struct sony_nc_value {
 	char *name;		/* name of the entry */
 	char **acpiget;		/* names of the ACPI get function */
@@ -420,6 +476,7 @@ static int sony_nc_add(struct acpi_devic
 	struct sony_nc_value *item;
=20
 	sony_nc_acpi_device =3D device;
+	strcpy(acpi_device_class(device), "sony/hotkey");
=20
 	sony_nc_acpi_handle =3D device->handle;
=20
@@ -555,6 +612,7 @@ static struct acpi_driver sony_nc_driver
 	.name =3D SONY_NC_DRIVER_NAME,
 	.class =3D SONY_NC_CLASS,
 	.ids =3D SONY_NC_HID,
+	.owner =3D THIS_MODULE,
 	.ops =3D {
 		.add =3D sony_nc_add,
 		.remove =3D sony_nc_remove,
@@ -562,14 +620,1015 @@ static struct acpi_driver sony_nc_driver
 		},
 };
=20
+/*********** SPIC (SNY6001) Device ***********/
+
+#define SONYPI_DEVICE_TYPE1	0x00000001
+#define SONYPI_DEVICE_TYPE2	0x00000002
+#define SONYPI_DEVICE_TYPE3	0x00000004
+
+#define SONY_EC_JOGB		0x82
+#define SONY_EC_JOGB_MASK	0x02
+
+#define SONY_PIC_EV_MASK	0xff
+
+#define SONYPI_BUF_SIZE	128
+
+struct sony_pic_ioport {
+	struct acpi_resource_io	io;
+	struct list_head	list;
+};
+
+struct sony_pic_irq {
+	struct acpi_resource_irq	irq;
+	struct list_head		list;
+};
+
+struct sony_pic_dev {
+	int			model;
+	struct acpi_device	*acpi_dev;
+	struct sony_pic_irq	*cur_irq;
+	struct sony_pic_ioport	*cur_ioport;
+	struct list_head	interrupts;
+	struct list_head	ioports;
+
+	struct input_dev	*input_jog_dev;
+	struct input_dev	*input_key_dev;
+	struct kfifo		*input_fifo;
+	spinlock_t		input_fifo_lock;
+	struct workqueue_struct	*sony_pic_wq;
+};
+
+static struct sony_pic_dev spic_dev =3D {
+	.interrupts	=3D LIST_HEAD_INIT(spic_dev.interrupts),
+	.ioports	=3D LIST_HEAD_INIT(spic_dev.ioports),
+};
+
+/* Event masks */
+#define SONYPI_JOGGER_MASK			0x00000001
+#define SONYPI_CAPTURE_MASK			0x00000002
+#define SONYPI_FNKEY_MASK			0x00000004
+#define SONYPI_BLUETOOTH_MASK			0x00000008
+#define SONYPI_PKEY_MASK			0x00000010
+#define SONYPI_BACK_MASK			0x00000020
+#define SONYPI_HELP_MASK			0x00000040
+#define SONYPI_LID_MASK				0x00000080
+#define SONYPI_ZOOM_MASK			0x00000100
+#define SONYPI_THUMBPHRASE_MASK			0x00000200
+#define SONYPI_MEYE_MASK			0x00000400
+#define SONYPI_MEMORYSTICK_MASK			0x00000800
+#define SONYPI_BATTERY_MASK			0x00001000
+#define SONYPI_WIRELESS_MASK			0x00002000
+
+struct sonypi_event {
+	u8	data;
+	u8	event;
+};
+
+/* The set of possible button release events */
+static struct sonypi_event sonypi_releaseev[] =3D {
+	{ 0x00, SONYPI_EVENT_ANYBUTTON_RELEASED },
+	{ 0, 0 }
+};
+
+/* The set of possible jogger events  */
+static struct sonypi_event sonypi_joggerev[] =3D {
+	{ 0x1f, SONYPI_EVENT_JOGDIAL_UP },
+	{ 0x01, SONYPI_EVENT_JOGDIAL_DOWN },
+	{ 0x5f, SONYPI_EVENT_JOGDIAL_UP_PRESSED },
+	{ 0x41, SONYPI_EVENT_JOGDIAL_DOWN_PRESSED },
+	{ 0x1e, SONYPI_EVENT_JOGDIAL_FAST_UP },
+	{ 0x02, SONYPI_EVENT_JOGDIAL_FAST_DOWN },
+	{ 0x5e, SONYPI_EVENT_JOGDIAL_FAST_UP_PRESSED },
+	{ 0x42, SONYPI_EVENT_JOGDIAL_FAST_DOWN_PRESSED },
+	{ 0x1d, SONYPI_EVENT_JOGDIAL_VFAST_UP },
+	{ 0x03, SONYPI_EVENT_JOGDIAL_VFAST_DOWN },
+	{ 0x5d, SONYPI_EVENT_JOGDIAL_VFAST_UP_PRESSED },
+	{ 0x43, SONYPI_EVENT_JOGDIAL_VFAST_DOWN_PRESSED },
+	{ 0x40, SONYPI_EVENT_JOGDIAL_PRESSED },
+	{ 0, 0 }
+};
+
+/* The set of possible capture button events */
+static struct sonypi_event sonypi_captureev[] =3D {
+	{ 0x05, SONYPI_EVENT_CAPTURE_PARTIALPRESSED },
+	{ 0x07, SONYPI_EVENT_CAPTURE_PRESSED },
+	{ 0x01, SONYPI_EVENT_CAPTURE_PARTIALRELEASED },
+	{ 0, 0 }
+};
+
+/* The set of possible fnkeys events */
+static struct sonypi_event sonypi_fnkeyev[] =3D {
+	{ 0x10, SONYPI_EVENT_FNKEY_ESC },
+	{ 0x11, SONYPI_EVENT_FNKEY_F1 },
+	{ 0x12, SONYPI_EVENT_FNKEY_F2 },
+	{ 0x13, SONYPI_EVENT_FNKEY_F3 },
+	{ 0x14, SONYPI_EVENT_FNKEY_F4 },
+	{ 0x15, SONYPI_EVENT_FNKEY_F5 },
+	{ 0x16, SONYPI_EVENT_FNKEY_F6 },
+	{ 0x17, SONYPI_EVENT_FNKEY_F7 },
+	{ 0x18, SONYPI_EVENT_FNKEY_F8 },
+	{ 0x19, SONYPI_EVENT_FNKEY_F9 },
+	{ 0x1a, SONYPI_EVENT_FNKEY_F10 },
+	{ 0x1b, SONYPI_EVENT_FNKEY_F11 },
+	{ 0x1c, SONYPI_EVENT_FNKEY_F12 },
+	{ 0x1f, SONYPI_EVENT_FNKEY_RELEASED },
+	{ 0x21, SONYPI_EVENT_FNKEY_1 },
+	{ 0x22, SONYPI_EVENT_FNKEY_2 },
+	{ 0x31, SONYPI_EVENT_FNKEY_D },
+	{ 0x32, SONYPI_EVENT_FNKEY_E },
+	{ 0x33, SONYPI_EVENT_FNKEY_F },
+	{ 0x34, SONYPI_EVENT_FNKEY_S },
+	{ 0x35, SONYPI_EVENT_FNKEY_B },
+	{ 0x36, SONYPI_EVENT_FNKEY_ONLY },
+	{ 0, 0 }
+};
+
+/* The set of possible program key events */
+static struct sonypi_event sonypi_pkeyev[] =3D {
+	{ 0x01, SONYPI_EVENT_PKEY_P1 },
+	{ 0x02, SONYPI_EVENT_PKEY_P2 },
+	{ 0x04, SONYPI_EVENT_PKEY_P3 },
+	{ 0x5c, SONYPI_EVENT_PKEY_P1 },
+	{ 0, 0 }
+};
+
+/* The set of possible bluetooth events */
+static struct sonypi_event sonypi_blueev[] =3D {
+	{ 0x55, SONYPI_EVENT_BLUETOOTH_PRESSED },
+	{ 0x59, SONYPI_EVENT_BLUETOOTH_ON },
+	{ 0x5a, SONYPI_EVENT_BLUETOOTH_OFF },
+	{ 0, 0 }
+};
+
+/* The set of possible wireless events */
+static struct sonypi_event sonypi_wlessev[] =3D {
+	{ 0x59, SONYPI_EVENT_WIRELESS_ON },
+	{ 0x5a, SONYPI_EVENT_WIRELESS_OFF },
+	{ 0, 0 }
+};
+
+/* The set of possible back button events */
+static struct sonypi_event sonypi_backev[] =3D {
+	{ 0x20, SONYPI_EVENT_BACK_PRESSED },
+	{ 0, 0 }
+};
+
+/* The set of possible help button events */
+static struct sonypi_event sonypi_helpev[] =3D {
+	{ 0x3b, SONYPI_EVENT_HELP_PRESSED },
+	{ 0, 0 }
+};
+
+
+/* The set of possible lid events */
+static struct sonypi_event sonypi_lidev[] =3D {
+	{ 0x51, SONYPI_EVENT_LID_CLOSED },
+	{ 0x50, SONYPI_EVENT_LID_OPENED },
+	{ 0, 0 }
+};
+
+/* The set of possible zoom events */
+static struct sonypi_event sonypi_zoomev[] =3D {
+	{ 0x39, SONYPI_EVENT_ZOOM_PRESSED },
+	{ 0, 0 }
+};
+
+/* The set of possible thumbphrase events */
+static struct sonypi_event sonypi_thumbphraseev[] =3D {
+	{ 0x3a, SONYPI_EVENT_THUMBPHRASE_PRESSED },
+	{ 0, 0 }
+};
+
+/* The set of possible motioneye camera events */
+static struct sonypi_event sonypi_meyeev[] =3D {
+	{ 0x00, SONYPI_EVENT_MEYE_FACE },
+	{ 0x01, SONYPI_EVENT_MEYE_OPPOSITE },
+	{ 0, 0 }
+};
+
+/* The set of possible memorystick events */
+static struct sonypi_event sonypi_memorystickev[] =3D {
+	{ 0x53, SONYPI_EVENT_MEMORYSTICK_INSERT },
+	{ 0x54, SONYPI_EVENT_MEMORYSTICK_EJECT },
+	{ 0, 0 }
+};
+
+/* The set of possible battery events */
+static struct sonypi_event sonypi_batteryev[] =3D {
+	{ 0x20, SONYPI_EVENT_BATTERY_INSERT },
+	{ 0x30, SONYPI_EVENT_BATTERY_REMOVE },
+	{ 0, 0 }
+};
+
+static struct sonypi_eventtypes {
+	int			model;
+	u8			data;
+	unsigned long		mask;
+	struct sonypi_event *	events;
+} sony_pic_eventtypes[] =3D {
+	{ SONYPI_DEVICE_TYPE1, 0, 0xffffffff, sonypi_releaseev },
+	{ SONYPI_DEVICE_TYPE1, 0x70, SONYPI_MEYE_MASK, sonypi_meyeev },
+	{ SONYPI_DEVICE_TYPE1, 0x30, SONYPI_LID_MASK, sonypi_lidev },
+	{ SONYPI_DEVICE_TYPE1, 0x60, SONYPI_CAPTURE_MASK, sonypi_captureev },
+	{ SONYPI_DEVICE_TYPE1, 0x10, SONYPI_JOGGER_MASK, sonypi_joggerev },
+	{ SONYPI_DEVICE_TYPE1, 0x20, SONYPI_FNKEY_MASK, sonypi_fnkeyev },
+	{ SONYPI_DEVICE_TYPE1, 0x30, SONYPI_BLUETOOTH_MASK, sonypi_blueev },
+	{ SONYPI_DEVICE_TYPE1, 0x40, SONYPI_PKEY_MASK, sonypi_pkeyev },
+	{ SONYPI_DEVICE_TYPE1, 0x30, SONYPI_MEMORYSTICK_MASK, sonypi_memoryst=
ickev },
+	{ SONYPI_DEVICE_TYPE1, 0x40, SONYPI_BATTERY_MASK, sonypi_batteryev },
+
+	{ SONYPI_DEVICE_TYPE2, 0, 0xffffffff, sonypi_releaseev },
+	{ SONYPI_DEVICE_TYPE2, 0x38, SONYPI_LID_MASK, sonypi_lidev },
+	{ SONYPI_DEVICE_TYPE2, 0x11, SONYPI_JOGGER_MASK, sonypi_joggerev },
+	{ SONYPI_DEVICE_TYPE2, 0x61, SONYPI_CAPTURE_MASK, sonypi_captureev },
+	{ SONYPI_DEVICE_TYPE2, 0x21, SONYPI_FNKEY_MASK, sonypi_fnkeyev },
+	{ SONYPI_DEVICE_TYPE2, 0x31, SONYPI_BLUETOOTH_MASK, sonypi_blueev },
+	{ SONYPI_DEVICE_TYPE2, 0x08, SONYPI_PKEY_MASK, sonypi_pkeyev },
+	{ SONYPI_DEVICE_TYPE2, 0x11, SONYPI_BACK_MASK, sonypi_backev },
+	{ SONYPI_DEVICE_TYPE2, 0x21, SONYPI_HELP_MASK, sonypi_helpev },
+	{ SONYPI_DEVICE_TYPE2, 0x21, SONYPI_ZOOM_MASK, sonypi_zoomev },
+	{ SONYPI_DEVICE_TYPE2, 0x20, SONYPI_THUMBPHRASE_MASK, sonypi_thumbphr=
aseev },
+	{ SONYPI_DEVICE_TYPE2, 0x31, SONYPI_MEMORYSTICK_MASK, sonypi_memoryst=
ickev },
+	{ SONYPI_DEVICE_TYPE2, 0x41, SONYPI_BATTERY_MASK, sonypi_batteryev },
+	{ SONYPI_DEVICE_TYPE2, 0x31, SONYPI_PKEY_MASK, sonypi_pkeyev },
+
+	{ SONYPI_DEVICE_TYPE3, 0, 0xffffffff, sonypi_releaseev },
+	{ SONYPI_DEVICE_TYPE3, 0x21, SONYPI_FNKEY_MASK, sonypi_fnkeyev },
+	{ SONYPI_DEVICE_TYPE3, 0x31, SONYPI_WIRELESS_MASK, sonypi_wlessev },
+	{ SONYPI_DEVICE_TYPE3, 0x31, SONYPI_MEMORYSTICK_MASK, sonypi_memoryst=
ickev },
+	{ SONYPI_DEVICE_TYPE3, 0x41, SONYPI_BATTERY_MASK, sonypi_batteryev },
+	{ SONYPI_DEVICE_TYPE3, 0x31, SONYPI_PKEY_MASK, sonypi_pkeyev },
+	{ 0 }
+};
+
+static int sony_pic_detect_device_type(void)
+{
+	struct pci_dev *pcidev;
+	int model =3D 0;
+
+	if ((pcidev =3D pci_get_device(PCI_VENDOR_ID_INTEL,
+				     PCI_DEVICE_ID_INTEL_82371AB_3, NULL)))
+		model =3D SONYPI_DEVICE_TYPE1;
+
+	else if ((pcidev =3D pci_get_device(PCI_VENDOR_ID_INTEL,
+					  PCI_DEVICE_ID_INTEL_ICH6_1, NULL)))
+		model =3D SONYPI_DEVICE_TYPE3;
+
+	else if ((pcidev =3D pci_get_device(PCI_VENDOR_ID_INTEL,
+					  PCI_DEVICE_ID_INTEL_ICH7_1, NULL)))
+		model =3D SONYPI_DEVICE_TYPE3;
+
+	else
+		model =3D SONYPI_DEVICE_TYPE2;
+
+	if (pcidev)
+		pci_dev_put(pcidev);
+
+	printk(KERN_INFO DRV_PFX "detected Type%d model\n",
+			model =3D=3D SONYPI_DEVICE_TYPE1 ? 1 :
+			model =3D=3D SONYPI_DEVICE_TYPE2 ? 2 : 3);
+	return model;
+}
+
+#define ITERATIONS_LONG		10000
+#define ITERATIONS_SHORT	10
+#define wait_on_command(command, iterations) {				\
+	unsigned int n =3D iterations;					\
+	while (--n && (command))					\
+		udelay(1);						\
+	if (!n)								\
+		dprintk("command failed at %s : %s (line %d)\n",	\
+				__FILE__, __FUNCTION__, __LINE__);	\
+}
+
+static u8 sony_pic_call1(u8 dev)
+{
+	u8 v1, v2;
+
+	wait_on_command(inb_p(spic_dev.cur_ioport->io.minimum + 4) & 2,
+			ITERATIONS_LONG);
+	outb(dev, spic_dev.cur_ioport->io.minimum + 4);
+	v1 =3D inb_p(spic_dev.cur_ioport->io.minimum + 4);
+	v2 =3D inb_p(spic_dev.cur_ioport->io.minimum);
+	dprintk("sony_pic_call1: 0x%.4x\n", (v2 << 8) | v1);
+	return v2;
+}
+
+static u8 sony_pic_call2(u8 dev, u8 fn)
+{
+	u8 v1;
+
+	wait_on_command(inb_p(spic_dev.cur_ioport->io.minimum + 4) & 2,
+			ITERATIONS_LONG);
+	outb(dev, spic_dev.cur_ioport->io.minimum + 4);
+	wait_on_command(inb_p(spic_dev.cur_ioport->io.minimum + 4) & 2,
+			ITERATIONS_LONG);
+	outb(fn, spic_dev.cur_ioport->io.minimum);
+	v1 =3D inb_p(spic_dev.cur_ioport->io.minimum);
+	dprintk("sony_pic_call2: 0x%.4x\n", v1);
+	return v1;
+}
+
+/*****************
+ *
+ * INPUT Device
+ *
+ *****************/
+struct sony_pic_keypress {
+	struct input_dev *dev;
+	int key;
+};
+
+/* Correspondance table between sonypi events and input layer events *=
/
+static struct {
+	int sonypiev;
+	int inputev;
+} sony_pic_inputkeys[] =3D {
+	{ SONYPI_EVENT_CAPTURE_PRESSED,	 	KEY_CAMERA },
+	{ SONYPI_EVENT_FNKEY_ONLY, 		KEY_FN },
+	{ SONYPI_EVENT_FNKEY_ESC, 		KEY_FN_ESC },
+	{ SONYPI_EVENT_FNKEY_F1, 		KEY_FN_F1 },
+	{ SONYPI_EVENT_FNKEY_F2, 		KEY_FN_F2 },
+	{ SONYPI_EVENT_FNKEY_F3, 		KEY_FN_F3 },
+	{ SONYPI_EVENT_FNKEY_F4, 		KEY_FN_F4 },
+	{ SONYPI_EVENT_FNKEY_F5, 		KEY_FN_F5 },
+	{ SONYPI_EVENT_FNKEY_F6, 		KEY_FN_F6 },
+	{ SONYPI_EVENT_FNKEY_F7, 		KEY_FN_F7 },
+	{ SONYPI_EVENT_FNKEY_F8, 		KEY_FN_F8 },
+	{ SONYPI_EVENT_FNKEY_F9,		KEY_FN_F9 },
+	{ SONYPI_EVENT_FNKEY_F10,		KEY_FN_F10 },
+	{ SONYPI_EVENT_FNKEY_F11, 		KEY_FN_F11 },
+	{ SONYPI_EVENT_FNKEY_F12,		KEY_FN_F12 },
+	{ SONYPI_EVENT_FNKEY_1, 		KEY_FN_1 },
+	{ SONYPI_EVENT_FNKEY_2, 		KEY_FN_2 },
+	{ SONYPI_EVENT_FNKEY_D,			KEY_FN_D },
+	{ SONYPI_EVENT_FNKEY_E,			KEY_FN_E },
+	{ SONYPI_EVENT_FNKEY_F,			KEY_FN_F },
+	{ SONYPI_EVENT_FNKEY_S,			KEY_FN_S },
+	{ SONYPI_EVENT_FNKEY_B,			KEY_FN_B },
+	{ SONYPI_EVENT_BLUETOOTH_PRESSED, 	KEY_BLUE },
+	{ SONYPI_EVENT_BLUETOOTH_ON, 		KEY_BLUE },
+	{ SONYPI_EVENT_PKEY_P1, 		KEY_PROG1 },
+	{ SONYPI_EVENT_PKEY_P2, 		KEY_PROG2 },
+	{ SONYPI_EVENT_PKEY_P3, 		KEY_PROG3 },
+	{ SONYPI_EVENT_BACK_PRESSED, 		KEY_BACK },
+	{ SONYPI_EVENT_HELP_PRESSED, 		KEY_HELP },
+	{ SONYPI_EVENT_ZOOM_PRESSED, 		KEY_ZOOM },
+	{ SONYPI_EVENT_THUMBPHRASE_PRESSED, 	BTN_THUMB },
+	{ 0, 0 },
+};
+
+/* release buttons after a short delay if pressed */
+static void do_sony_pic_release_key(struct work_struct *work)
+{
+	struct sony_pic_keypress kp;
+
+	while (kfifo_get(spic_dev.input_fifo, (unsigned char *)&kp,
+			 sizeof(kp)) =3D=3D sizeof(kp)) {
+		msleep(10);
+		input_report_key(kp.dev, kp.key, 0);
+		input_sync(kp.dev);
+	}
+}
+static DECLARE_WORK(sony_pic_release_key_work,
+		do_sony_pic_release_key);
+
+/* forward event to the input subsytem */
+static void sony_pic_report_input_event(u8 event)
+{
+	struct input_dev *jog_dev =3D spic_dev.input_jog_dev;
+	struct input_dev *key_dev =3D spic_dev.input_key_dev;
+	struct sony_pic_keypress kp =3D { NULL };
+	int i;
+
+	if (event =3D=3D SONYPI_EVENT_FNKEY_RELEASED) {
+		/* Nothing, not all VAIOs generate this event */
+		return;
+	}
+
+	/* report jog_dev events */
+	if (jog_dev) {
+		switch (event) {
+		case SONYPI_EVENT_JOGDIAL_UP:
+		case SONYPI_EVENT_JOGDIAL_UP_PRESSED:
+			input_report_rel(jog_dev, REL_WHEEL, 1);
+			input_sync(jog_dev);
+			return;
+
+		case SONYPI_EVENT_JOGDIAL_DOWN:
+		case SONYPI_EVENT_JOGDIAL_DOWN_PRESSED:
+			input_report_rel(jog_dev, REL_WHEEL, -1);
+			input_sync(jog_dev);
+			return;
+
+		default:
+			break;
+		}
+	}
+
+	switch (event) {
+	case SONYPI_EVENT_JOGDIAL_PRESSED:
+		kp.key =3D BTN_MIDDLE;
+		kp.dev =3D jog_dev;
+		break;
+
+	default:
+		for (i =3D 0; sony_pic_inputkeys[i].sonypiev; i++)
+			if (event =3D=3D sony_pic_inputkeys[i].sonypiev) {
+				kp.dev =3D key_dev;
+				kp.key =3D sony_pic_inputkeys[i].inputev;
+				break;
+			}
+		break;
+	}
+
+	if (kp.dev) {
+		input_report_key(kp.dev, kp.key, 1);
+		input_sync(kp.dev);
+		kfifo_put(spic_dev.input_fifo,
+			  (unsigned char *)&kp, sizeof(kp));
+
+		if (!work_pending(&sony_pic_release_key_work))
+			queue_work(spic_dev.sony_pic_wq,
+					&sony_pic_release_key_work);
+	}
+}
+
+static int sony_pic_setup_input(void)
+{
+	struct input_dev *jog_dev;
+	struct input_dev *key_dev;
+	int i;
+	int error;
+	u8 jog_present =3D 0;
+
+	/* kfifo */
+	spin_lock_init(&spic_dev.input_fifo_lock);
+	spic_dev.input_fifo =3D
+		kfifo_alloc(SONYPI_BUF_SIZE, GFP_KERNEL,
+			    &spic_dev.input_fifo_lock);
+	if (IS_ERR(spic_dev.input_fifo)) {
+		printk(KERN_ERR "sonypi: kfifo_alloc failed\n");
+		return PTR_ERR(spic_dev.input_fifo);
+	}
+
+	/* init workqueue */
+	spic_dev.sony_pic_wq =3D create_singlethread_workqueue("sony-pic");
+	if (!spic_dev.sony_pic_wq) {
+		printk(KERN_ERR DRV_PFX
+				"Unabe to create workqueue.\n");
+		error =3D -ENXIO;
+		goto err_free_kfifo;
+	}
+
+	/* input keys */
+	key_dev =3D input_allocate_device();
+	if (!key_dev) {
+		error =3D -ENOMEM;
+		goto err_destroy_wq;
+	}
+
+	key_dev->name =3D "Sony Vaio Keys";
+	key_dev->id.bustype =3D BUS_ISA;
+	key_dev->id.vendor =3D PCI_VENDOR_ID_SONY;
+
+	/* Initialize the Input Drivers: special keys */
+	key_dev->evbit[0] =3D BIT(EV_KEY);
+	for (i =3D 0; sony_pic_inputkeys[i].sonypiev; i++)
+		if (sony_pic_inputkeys[i].inputev)
+			set_bit(sony_pic_inputkeys[i].inputev, key_dev->keybit);
+
+	error =3D input_register_device(key_dev);
+	if (error)
+		goto err_free_keydev;
+
+	spic_dev.input_key_dev =3D key_dev;
+
+	/* jogdial - really reliable ? */
+	ec_read(SONY_EC_JOGB, &jog_present);
+	if (jog_present & SONY_EC_JOGB_MASK || force_jog) {
+		jog_dev =3D input_allocate_device();
+		if (!jog_dev) {
+			error =3D -ENOMEM;
+			goto err_unregister_keydev;
+		}
+
+		jog_dev->name =3D "Sony Vaio Jogdial";
+		jog_dev->id.bustype =3D BUS_ISA;
+		jog_dev->id.vendor =3D PCI_VENDOR_ID_SONY;
+
+		jog_dev->evbit[0] =3D BIT(EV_KEY) | BIT(EV_REL);
+		jog_dev->keybit[LONG(BTN_MOUSE)] =3D BIT(BTN_MIDDLE);
+		jog_dev->relbit[0] =3D BIT(REL_WHEEL);
+
+		error =3D input_register_device(jog_dev);
+		if (error)
+			goto err_free_jogdev;
+
+		spic_dev.input_jog_dev =3D jog_dev;
+	}
+
+	return 0;
+
+err_free_jogdev:
+	input_free_device(jog_dev);
+
+err_unregister_keydev:
+	input_unregister_device(key_dev);
+	/* to avoid kref underflow below at input_free_device */
+	key_dev =3D NULL;
+
+err_free_keydev:
+	input_free_device(key_dev);
+
+err_destroy_wq:
+	destroy_workqueue(spic_dev.sony_pic_wq);
+
+err_free_kfifo:
+	kfifo_free(spic_dev.input_fifo);
+
+	return error;
+}
+
+static void sony_pic_remove_input(void)
+{
+	/* flush workqueue first */
+	flush_workqueue(spic_dev.sony_pic_wq);
+
+	/* destroy input devs */
+	input_unregister_device(spic_dev.input_key_dev);
+	spic_dev.input_key_dev =3D NULL;
+
+	if (spic_dev.input_jog_dev) {
+		input_unregister_device(spic_dev.input_jog_dev);
+		spic_dev.input_jog_dev =3D NULL;
+	}
+
+	destroy_workqueue(spic_dev.sony_pic_wq);
+	kfifo_free(spic_dev.input_fifo);
+}
+
+/********************
+ *
+ * ACPI callbacks
+ *
+ ********************/
+static acpi_status
+sony_pic_read_possible_resource(struct acpi_resource *resource, void *=
context)
+{
+	u32 i;
+	struct sony_pic_dev *dev =3D (struct sony_pic_dev *)context;
+
+	switch (resource->type) {
+	case ACPI_RESOURCE_TYPE_START_DEPENDENT:
+	case ACPI_RESOURCE_TYPE_END_DEPENDENT:
+		return AE_OK;
+
+	case ACPI_RESOURCE_TYPE_IRQ:
+		{
+			struct acpi_resource_irq *p =3D &resource->data.irq;
+			struct sony_pic_irq *interrupt =3D NULL;
+			if (!p || !p->interrupt_count) {
+				/*
+				 * IRQ descriptors may have no IRQ# bits set,
+				 * particularly those those w/ _STA disabled
+				 */
+				dprintk("Blank IRQ resource\n");
+				return AE_OK;
+			}
+			for (i =3D 0; i < p->interrupt_count; i++) {
+				if (!p->interrupts[i]) {
+					printk(KERN_WARNING DRV_PFX
+							"Invalid IRQ %d\n",
+							p->interrupts[i]);
+					continue;
+				}
+				interrupt =3D kzalloc(sizeof(*interrupt),
+						GFP_KERNEL);
+				if (!interrupt)
+					return AE_ERROR;
+
+				list_add(&interrupt->list, &dev->interrupts);
+				interrupt->irq.triggering =3D p->triggering;
+				interrupt->irq.polarity =3D p->polarity;
+				interrupt->irq.sharable =3D p->sharable;
+				interrupt->irq.interrupt_count =3D 1;
+				interrupt->irq.interrupts[0] =3D p->interrupts[i];
+			}
+			return AE_OK;
+		}
+	case ACPI_RESOURCE_TYPE_IO:
+		{
+			struct acpi_resource_io *io =3D &resource->data.io;
+			struct sony_pic_ioport *ioport =3D NULL;
+			if (!io) {
+				dprintk("Blank IO resource\n");
+				return AE_OK;
+			}
+
+			ioport =3D kzalloc(sizeof(*ioport), GFP_KERNEL);
+			if (!ioport)
+				return AE_ERROR;
+
+			list_add(&ioport->list, &dev->ioports);
+			memcpy(&ioport->io, io, sizeof(*io));
+			return AE_OK;
+		}
+	default:
+		dprintk("Resource %d isn't an IRQ nor an IO port\n",
+				resource->type);
+
+	case ACPI_RESOURCE_TYPE_END_TAG:
+		return AE_OK;
+	}
+	return AE_CTRL_TERMINATE;
+}
+
+static int sony_pic_possible_resources(struct acpi_device *device)
+{
+	int result =3D 0;
+	acpi_status status =3D AE_OK;
+
+	if (!device)
+		return -EINVAL;
+
+	/* get device status */
+	/* see acpi_pci_link_get_current acpi_pci_link_get_possible */
+	dprintk("Evaluating _STA\n");
+	result =3D acpi_bus_get_status(device);
+	if (result) {
+		printk(KERN_WARNING DRV_PFX "Unable to read status\n");
+		goto end;
+	}
+
+	if (!device->status.enabled)
+		dprintk("Device disabled\n");
+	else
+		dprintk("Device enabled\n");
+
+	/*
+	 * Query and parse 'method'
+	 */
+	dprintk("Evaluating %s\n", METHOD_NAME__PRS);
+	status =3D acpi_walk_resources(device->handle, METHOD_NAME__PRS,
+			sony_pic_read_possible_resource, &spic_dev);
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_WARNING DRV_PFX
+				"Failure evaluating %s\n",
+				METHOD_NAME__PRS);
+		result =3D -ENODEV;
+	}
+end:
+	return result;
+}
+
+/*
+ *  Disable the spic device by calling its _DIS method
+ */
+static int sony_pic_disable(struct acpi_device *device)
+{
+	if (ACPI_FAILURE(acpi_evaluate_object(device->handle, "_DIS", 0, NULL=
)))
+		return -ENXIO;
+
+	dprintk("Device disabled\n");
+	return 0;
+}
+
+
+/*
+ *  Based on drivers/acpi/pci_link.c:acpi_pci_link_set
+ *
+ *  Call _SRS to set current resources
+ */
+static int sony_pic_enable(struct acpi_device *device,
+		struct sony_pic_ioport *ioport, struct sony_pic_irq *irq)
+{
+	acpi_status status;
+	int result =3D 0;
+	struct {
+		struct acpi_resource io_res;
+		struct acpi_resource irq_res;
+		struct acpi_resource end;
+	} *resource;
+	struct acpi_buffer buffer =3D { 0, NULL };
+
+	if (!ioport || !irq)
+		return -EINVAL;
+
+	/* init acpi_buffer */
+	resource =3D kzalloc(sizeof(*resource) + 1, GFP_KERNEL);
+	if (!resource)
+		return -ENOMEM;
+
+	buffer.length =3D sizeof(*resource) + 1;
+	buffer.pointer =3D resource;
+
+	/* setup io resource */
+	resource->io_res.type =3D ACPI_RESOURCE_TYPE_IO;
+	resource->io_res.length =3D sizeof(struct acpi_resource);
+	memcpy(&resource->io_res.data.io, &ioport->io,
+			sizeof(struct acpi_resource_io));
+
+	/* setup irq resource */
+	resource->irq_res.type =3D ACPI_RESOURCE_TYPE_IRQ;
+	resource->irq_res.length =3D sizeof(struct acpi_resource);
+	memcpy(&resource->irq_res.data.irq, &irq->irq,
+			sizeof(struct acpi_resource_irq));
+	/* we requested a shared irq */
+	resource->irq_res.data.irq.sharable =3D ACPI_SHARED;
+
+	resource->end.type =3D ACPI_RESOURCE_TYPE_END_TAG;
+
+	/* Attempt to set the resource */
+	dprintk("Evaluating _SRS\n");
+	status =3D acpi_set_current_resources(device->handle, &buffer);
+
+	/* check for total failure */
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_ERR DRV_PFX "Error evaluating _SRS");
+		result =3D -ENODEV;
+		goto end;
+	}
+
+	/* Necessary device initializations calls (from sonypi) */
+	sony_pic_call1(0x82);
+	sony_pic_call2(0x81, 0xff);
+	sony_pic_call1(compat ? 0x92 : 0x82);
+
+end:
+	kfree(resource);
+	return result;
+}
+
+/*****************
+ *
+ * ISR: some event is available
+ *
+ *****************/
+static irqreturn_t sony_pic_irq(int irq, void *dev_id)
+{
+	int i, j;
+	u32 port_val =3D 0;
+	u8 ev =3D 0;
+	u8 data_mask =3D 0;
+	u8 device_event =3D 0;
+
+	struct sony_pic_dev *dev =3D (struct sony_pic_dev *) dev_id;
+
+	acpi_os_read_port(dev->cur_ioport->io.minimum, &port_val,
+			dev->cur_ioport->io.address_length);
+	ev =3D port_val & SONY_PIC_EV_MASK;
+	data_mask =3D 0xff & (port_val >> (dev->cur_ioport->io.address_length=
 - 8));
+
+	dprintk("event (0x%.8x [%.2x] [%.2x]) at port 0x%.4x\n",
+			port_val, ev, data_mask, dev->cur_ioport->io.minimum);
+
+	if (ev =3D=3D 0x00 || ev =3D=3D 0xff)
+		return IRQ_HANDLED;
+
+	for (i =3D 0; sony_pic_eventtypes[i].model; i++) {
+
+		if (spic_dev.model !=3D sony_pic_eventtypes[i].model)
+			continue;
+
+		if ((data_mask & sony_pic_eventtypes[i].data) !=3D
+		    sony_pic_eventtypes[i].data)
+			continue;
+
+		if (!(mask & sony_pic_eventtypes[i].mask))
+			continue;
+
+		for (j =3D 0; sony_pic_eventtypes[i].events[j].event; j++) {
+			if (ev =3D=3D sony_pic_eventtypes[i].events[j].data) {
+				device_event =3D
+					sony_pic_eventtypes[i].events[j].event;
+				goto found;
+			}
+		}
+	}
+	return IRQ_HANDLED;
+
+found:
+	sony_pic_report_input_event(device_event);
+	acpi_bus_generate_event(spic_dev.acpi_dev, 1, device_event);
+
+	return IRQ_HANDLED;
+}
+
+/*****************
+ *
+ *  ACPI driver
+ *
+ *****************/
+static int sony_pic_remove(struct acpi_device *device, int type)
+{
+	struct sony_pic_ioport *io, *tmp_io;
+	struct sony_pic_irq *irq, *tmp_irq;
+
+	if (sony_pic_disable(device)) {
+		printk(KERN_ERR DRV_PFX "Couldn't disable device.\n");
+		return -ENXIO;
+	}
+
+	free_irq(spic_dev.cur_irq->irq.interrupts[0], &spic_dev);
+	release_region(spic_dev.cur_ioport->io.minimum,
+			spic_dev.cur_ioport->io.address_length);
+
+	sony_pic_remove_input();
+
+	list_for_each_entry_safe(io, tmp_io, &spic_dev.ioports, list) {
+		list_del(&io->list);
+		kfree(io);
+	}
+	list_for_each_entry_safe(irq, tmp_irq, &spic_dev.interrupts, list) {
+		list_del(&irq->list);
+		kfree(irq);
+	}
+	spic_dev.cur_ioport =3D NULL;
+	spic_dev.cur_irq =3D NULL;
+
+	dprintk("removed.\n");
+	return 0;
+}
+
+static int sony_pic_add(struct acpi_device *device)
+{
+	int result;
+	struct sony_pic_ioport *io, *tmp_io;
+	struct sony_pic_irq *irq, *tmp_irq;
+
+	printk(KERN_INFO DRV_PFX
+		"Sony Programmable I/O Controller Driver v%s.\n",
+		SONY_LAPTOP_DRIVER_VERSION);
+
+	spic_dev.acpi_dev =3D device;
+	strcpy(acpi_device_class(device), "sony/hotkey");
+	spic_dev.model =3D sony_pic_detect_device_type();
+
+	/* read _PRS resources */
+	result =3D sony_pic_possible_resources(device);
+	if (result) {
+		printk(KERN_ERR DRV_PFX
+				"Unabe to read possible resources.\n");
+		goto err_free_resources;
+	}
+
+	/* setup input devices and helper fifo */
+	result =3D sony_pic_setup_input();
+	if (result) {
+		printk(KERN_ERR DRV_PFX
+				"Unabe to create input devices.\n");
+		goto err_free_resources;
+	}
+
+	/* request io port */
+	list_for_each_entry(io, &spic_dev.ioports, list) {
+		if (request_region(io->io.minimum, io->io.address_length,
+					"Sony Programable I/O Device")) {
+			dprintk("I/O port: 0x%.4x (0x%.4x) + 0x%.2x\n",
+					io->io.minimum, io->io.maximum,
+					io->io.address_length);
+			spic_dev.cur_ioport =3D io;
+			break;
+		}
+	}
+	if (!spic_dev.cur_ioport) {
+		printk(KERN_ERR DRV_PFX "Failed to request_region.\n");
+		result =3D -ENODEV;
+		goto err_remove_input;
+	}
+
+	/* request IRQ */
+	list_for_each_entry(irq, &spic_dev.interrupts, list) {
+		if (!request_irq(irq->irq.interrupts[0], sony_pic_irq,
+					IRQF_SHARED, "sony-laptop", &spic_dev)) {
+			dprintk("IRQ: %d - triggering: %d - "
+					"polarity: %d - shr: %d\n",
+					irq->irq.interrupts[0],
+					irq->irq.triggering,
+					irq->irq.polarity,
+					irq->irq.sharable);
+			spic_dev.cur_irq =3D irq;
+			break;
+		}
+	}
+	if (!spic_dev.cur_irq) {
+		printk(KERN_ERR DRV_PFX "Failed to request_irq.\n");
+		result =3D -ENODEV;
+		goto err_release_region;
+	}
+
+	/* set resource status _SRS */
+	result =3D sony_pic_enable(device, spic_dev.cur_ioport, spic_dev.cur_=
irq);
+	if (result) {
+		printk(KERN_ERR DRV_PFX "Couldn't enable device.\n");
+		goto err_free_irq;
+	}
+
+	return 0;
+
+err_free_irq:
+	free_irq(spic_dev.cur_irq->irq.interrupts[0], &spic_dev);
+
+err_release_region:
+	release_region(spic_dev.cur_ioport->io.minimum,
+			spic_dev.cur_ioport->io.address_length);
+
+err_remove_input:
+	sony_pic_remove_input();
+
+err_free_resources:
+	list_for_each_entry_safe(io, tmp_io, &spic_dev.ioports, list) {
+		list_del(&io->list);
+		kfree(io);
+	}
+	list_for_each_entry_safe(irq, tmp_irq, &spic_dev.interrupts, list) {
+		list_del(&irq->list);
+		kfree(irq);
+	}
+	spic_dev.cur_ioport =3D NULL;
+	spic_dev.cur_irq =3D NULL;
+
+	return result;
+}
+
+static int sony_pic_suspend(struct acpi_device *device, pm_message_t s=
tate)
+{
+	if (sony_pic_disable(device))
+		return -ENXIO;
+	return 0;
+}
+
+static int sony_pic_resume(struct acpi_device *device)
+{
+	sony_pic_enable(device, spic_dev.cur_ioport, spic_dev.cur_irq);
+	return 0;
+}
+
+static struct acpi_driver sony_pic_driver =3D {
+	.name =3D SONY_PIC_DRIVER_NAME,
+	.class =3D SONY_PIC_CLASS,
+	.ids =3D SONY_PIC_HID,
+	.owner =3D THIS_MODULE,
+	.ops =3D {
+		.add =3D sony_pic_add,
+		.remove =3D sony_pic_remove,
+		.suspend =3D sony_pic_suspend,
+		.resume =3D sony_pic_resume,
+		},
+};
+
+static struct dmi_system_id __initdata sonypi_dmi_table[] =3D {
+	{
+		.ident =3D "Sony Vaio",
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PCG-"),
+		},
+	},
+	{
+		.ident =3D "Sony Vaio",
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-"),
+		},
+	},
+	{ }
+};
+
 static int __init sony_laptop_init(void)
 {
-	return acpi_bus_register_driver(&sony_nc_driver);
+	int result;
+
+	if (!no_spic && dmi_check_system(sonypi_dmi_table)) {
+		result =3D acpi_bus_register_driver(&sony_pic_driver);
+		if (result) {
+			printk(KERN_ERR DRV_PFX
+					"Unable to register SPIC driver.");
+			goto out;
+		}
+	}
+
+	result =3D acpi_bus_register_driver(&sony_nc_driver);
+	if (result) {
+		printk(KERN_ERR DRV_PFX "Unable to register SNC driver.");
+		goto out_unregister_pic;
+	}
+
+	return 0;
+
+out_unregister_pic:
+	if (!no_spic)
+		acpi_bus_unregister_driver(&sony_pic_driver);
+out:
+	return result;
 }
=20
 static void __exit sony_laptop_exit(void)
 {
 	acpi_bus_unregister_driver(&sony_nc_driver);
+	if (!no_spic)
+		acpi_bus_unregister_driver(&sony_pic_driver);
 }
=20
 module_init(sony_laptop_init);
_

Patches currently in -mm which might be from malattia@linux.it are

remove-acpi-references-from-variable-and-function-names.patch
prepare-the-platform-driver-for-multiple-users.patch
add-debug-macros-also-used-by-the-sonypi-reimplementation.patch
add-sny6001-device-handling-sonypi-reimplementation.patch
unify-the-input-subsystem-event-forwarding.patch
additional-platform-attributes-coming-from-sny6001.patch
sanitize-printks.patch
update-documentation-and-kconfig-help.patch
git-cpufreq.patch
