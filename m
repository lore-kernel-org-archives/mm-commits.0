From: akpm@linux-foundation.org
Subject: - first-stab-at-elantech-touchpad-driver-for-26226-testers.patch removed from -mm tree
Date: Wed, 31 Oct 2007 13:55:56 -0700
Message-ID: <200710312055.l9VKtutq027650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50790 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758697AbXJaU4y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 16:56:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@opmeer.net, dtor@mail.ru, jkosina@suse.cz, mm-commits@vger.kernel.org


The patch titled
     First stab at Elantech touchpad driver
has been removed from the -mm tree.  Its filename was
     first-stab-at-elantech-touchpad-driver-for-26226-testers.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: First stab at Elantech touchpad driver
From: Arjan Opmeer <arjan@opmeer.net>

This is a first stab at a Linux driver for the Elantech touchpad as found
on some laptops (e.g.  MSI MS-1035 aka L725).

Insight in the protocol and configuration options came from investigating
the behaviour of the Windows Elantech touchpad driver in a Qemu instance by
logging the PS/2 data stream and observing the changes it made to the
Windows registry.

By using the serio_raw driver, replaying the logged PS/2 sequences and
studying the resulting output the protocol became clear enough to be able
to write this driver and its documentation.

However, all this is only tested on one laptop and might include false
assumptions or ommisions.  Therefore testers are needed that are willing to
try the included patch and see whether things work as expected.

The driver defaults to relative mode for now as I haven't been able to get
absolute mode working properly.  I believe abolute mode is necessary for
interfacing with the X11 synaptics driver so people with more understanding
of the intricacies of absolute mode are also very much invited to look at
the code.

For configuring the touchpad the driver exposes configuration registers it
knows about via sysfs entries.  By writing values or toggling bits certain
aspects of the touchpad operation can be influenced.  For now this means
fiddling with bits and reading and writing hex values to sysfs entries. 
Maybe that in the future a nicer interface can be devised?

Also, I have documented the registers as far as I have been able to find
out.  Corrections or additions in this area are certainly appreciated.

The included patch is against kernel 2.6.22.6 in the hope of reaching more
testers than those that run the bleeding edge rc kernels.

[akpm@linux-foundation.org: cleanups]
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/input/elantech.txt   |  152 +++++++++++
 drivers/input/mouse/Kconfig        |   15 +
 drivers/input/mouse/Makefile       |    1 
 drivers/input/mouse/elantech.c     |  363 +++++++++++++++++++++++++++
 drivers/input/mouse/elantech.h     |   44 +++
 drivers/input/mouse/psmouse-base.c |   17 +
 drivers/input/mouse/psmouse.h      |    1 
 7 files changed, 593 insertions(+)

diff -puN /dev/null Documentation/input/elantech.txt
--- /dev/null
+++ a/Documentation/input/elantech.txt
@@ -0,0 +1,152 @@
+Elantech Touchpad Driver
+========================
+	Copyright (C) 2007 Arjan Opmeer <arjan@opmeer.net>
+
+
+Configuration of the touchpad is performed by writing register values to the
+corresponding sysfs entries found under /sys/bus/serio/drivers/psmouse/serioX
+
+
+Registers
+---------
+
+* reg_10	(Windows driver default value 0x12)
+
+   bit   7   6   5   4   3   2   1   0
+         0   C   T   D   L   R   S   E
+
+         E: 1 = enable smart edges in other cases
+         S: 1 = enable smart edges only when dragging
+         R: 1 = raw mode (needs 4 byte packets, see reg_11)
+         L: 1 = enable drag lock (see reg_22)
+         D: 1 = disable dynamic resolution
+         T: 1 = disable tapping
+         C: 1 = enable corner tap
+
+* reg_11	(Windows driver default value 0x8f)
+
+   bit   7   6   5   4   3   2   1   0
+         1   0   0   H   V   1   P   N
+
+         N: 1 = bit 4 or 5 of byte 0 is 1 (non null top nibble ?)
+         P: 1 = enable native 4 byte packet mode (forced on by driver)
+         V: 1 = enable vertical scroll area
+         H: 1 = enable horizonal scroll area
+
+
+* reg_20	(Windows driver default value 0x0a)
+
+         single finger width?
+
+* reg_21	(Windows driver default value 0x60)
+
+         scroll area width (small: 0x40 ... wide: 0xff)
+
+* reg_22	(Windows driver default value 0xff)
+
+         drag lock time out (short: 0x14 ... long: 0xfe; 0xff =never)
+
+* reg_23	(Windows driver default value 0x10)
+
+         tap make timeout?
+
+         Note: the Windows driver does not write this register
+
+* reg_24	(Windows driver default value 0x10)
+
+         tap release timeout?
+
+         Note: the Windows driver does not write this register
+
+* reg_25	(Windows driver default value 0x03)
+
+         smart edge cursor speed (0x02 = slow, 0x03 = medium, 0x04 = fast)
+
+* reg_26	(Windows driver default value 0x00 ?? )
+
+         smart edge activation area width?
+
+         Note: the Windows driver does not write this register
+         Note: the Windows driver default value of 0x00 disables smart edges
+               when it would get written
+         Note: the Windows driver sets bit 0 of the registry value to disable
+               tapping when typing, but never actually writes the register.
+               Only used as an internal driver flag?
+
+
+
+Initially the Elantouch Touchpad is in emulation mode and reports 3 byte
+standard PS/2 packets and hence works with a standard mouse driver.
+However, it can be configured to talk its native 4 byte mode and a raw 4
+byte absolute mode both for which a dedicated driver is needed.
+
+
+Native 4 byte relative mode packet format
+-----------------------------------------
+
+byte 0:
+   bit   7   6   5   4   3   2   1   0
+         c   c   ?   ?   1   M   R   L
+
+         L, R, M = 1 when Left, Right, Middle mouse button pressed
+         c = 1 when corner tap detected
+
+byte 1:
+   bit   7   6   5   4   3   2   1   0
+        dx7 dx6 dx5 dx4 dx3 dx2 dx1 dx0
+
+         dx7..dx0 = x movement;   positive = right, negative = left
+         byte 1 = 0xf0 when corner tap detected
+
+byte 2:
+   bit   7   6   5   4   3   2   1   0
+        dy7 dy6 dy5 dy4 dy3 dy2 dy1 dy0
+
+         dy7..dy0 = y movement;   positive = up,    negative = down
+
+byte 3:
+   bit   7   6   5   4   3   2   1   0
+         w   h   0   0  d3  d2  d1  d0
+
+         normally:
+            d3..d0 = scroll wheel amount and direction
+                     positive = down or left
+                     negative = up or right
+         when corner tap detected:
+            d0 = 1 when top right corner tapped
+            d1 = 1 when bottom right corner tapped
+            d2 = 1 when bottom left corner tapped
+            d3 = 1 when top left corner tapped
+         w = 1 when wide finger touch?
+         h = 1 when horizontal scroll action
+
+
+Native 4 byte raw absolute mode packet format
+---------------------------------------------
+
+byte 0:
+   bit   7   6   5   4   3   2   1   0
+         0   0  z2  z1   1  z0   R   L
+
+         L, R = 1 when Left, Right mouse button pressed
+         z2..z0 = some touch weigth?
+
+byte 1:
+   bit   7   6   5   4   3   2   1   0
+         f   0  th  tw  x9  x8  y9  y8
+
+         tw = 1 when two finger touch
+         th = 1 when three finger touch
+         f  = 1 when finger touch
+
+byte 2:
+   bit   7   6   5   4   3   2   1   0
+        x7  x6  x5  x4  x3  x2  x1  x0
+
+         x9..x0 = absolute x value (horizontal)
+
+byte 3:
+   bit   7   6   5   4   3   2   1   0
+        y7  y6  y5  y4  y3  y2  y1  y0
+
+         y9..y0 = absolute y value (vertical)
diff -puN drivers/input/mouse/Kconfig~first-stab-at-elantech-touchpad-driver-for-26226-testers drivers/input/mouse/Kconfig
--- a/drivers/input/mouse/Kconfig~first-stab-at-elantech-touchpad-driver-for-26226-testers
+++ a/drivers/input/mouse/Kconfig
@@ -96,6 +96,21 @@ config MOUSE_PS2_TOUCHKIT
 
 	  If unsure, say N.
 
+config MOUSE_PS2_ELANTECH
+	bool "Elantech PS/2 protocol extension"
+	depends on MOUSE_PS2
+	help
+	  Say Y here if you have an Elantech PS/2 touchpad connected
+	  to your system.
+
+	  If unsure, say N.
+
+	  This driver exposes some configuration registers via sysfs
+	  entries.
+
+	  For further information, see
+	  <file:Documentation/input/elantech.txt>.
+
 config MOUSE_SERIAL
 	tristate "Serial mouse"
 	select SERIO
diff -puN drivers/input/mouse/Makefile~first-stab-at-elantech-touchpad-driver-for-26226-testers drivers/input/mouse/Makefile
--- a/drivers/input/mouse/Makefile~first-stab-at-elantech-touchpad-driver-for-26226-testers
+++ a/drivers/input/mouse/Makefile
@@ -24,3 +24,4 @@ psmouse-$(CONFIG_MOUSE_PS2_LOGIPS2PP)	+=
 psmouse-$(CONFIG_MOUSE_PS2_LIFEBOOK)	+= lifebook.o
 psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)	+= trackpoint.o
 psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)	+= touchkit_ps2.o
+psmouse-$(CONFIG_MOUSE_PS2_ELANTECH)	+= elantech.o
diff -puN /dev/null drivers/input/mouse/elantech.c
--- /dev/null
+++ a/drivers/input/mouse/elantech.c
@@ -0,0 +1,363 @@
+/*
+ * Elantech Touchpad driver
+ *
+ * Copyright (C) 2007 Arjan Opmeer <arjan@opmeer.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * Trademarks are the property of their respective owners.
+ */
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/serio.h>
+#include <linux/libps2.h>
+#include "psmouse.h"
+#include "synaptics.h"
+#include "elantech.h"
+
+#define ETP_RAW_MODE 		0x04
+#define ETP_4_BYTE_MODE 	0x02
+
+/* These values work with the touchpad on my laptop. Do they need adjustment? */
+#define ETP_XMIN 		32
+#define ETP_XMAX 		0x240
+#define ETP_YMIN 		32
+#define ETP_YMAX 		0x160
+
+/*
+ * Send a synaptics style special commands
+ */
+static int synaptics_send_cmd(struct psmouse *psmouse, unsigned char c, unsigned char *param)
+{
+	if (psmouse_sliced_command(psmouse, c))
+		return -1;
+	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO))
+		return -1;
+	return 0;
+}
+
+/*
+ * Send an Elantech style special command to write a register with a value
+ */
+static int elantech_write_reg(struct psmouse *psmouse, unsigned char reg, unsigned char val)
+{
+	if ((reg < 0x10) || (reg > 0x26))
+		return -1;
+	if ((reg > 0x11) && (reg < 0x20))
+		return -1;
+
+	if (psmouse_sliced_command(psmouse, ELANTECH_COMMAND) ||
+	    psmouse_sliced_command(psmouse, reg) ||
+	    psmouse_sliced_command(psmouse, val) ||
+	    ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSCALE11)) {
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Process byte stream from mouse and interpret complete data packages
+ */
+static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
+{
+	struct elantech_data 	*etd = psmouse->private;
+	struct input_dev 	*dev = psmouse->dev;
+	unsigned char 		*packet = psmouse->packet;
+	unsigned int 		z;
+
+	if (psmouse->pktcnt < 4)
+		return PSMOUSE_GOOD_DATA;
+
+	if (etd->reg_10 & ETP_RAW_MODE) {
+		/*
+		 * What to do with this value? It varies too wildly to work
+		 * as a useful z distance
+		 */
+		z = ((packet[0] & 0x30) >> 3) | ((packet[0] & 0x04) >> 2);
+		input_report_key(dev, BTN_TOUCH, packet[1] & 0x80);
+		if ((packet[1] & 0x30) == 0) {
+			input_report_abs(dev, ABS_X,
+				((packet[1] & 0x0c) << 6) | packet[2]);
+			input_report_abs(dev, ABS_Y,
+				ETP_YMIN + ETP_YMAX -
+				(((packet[1] & 0x03) << 8) | packet[3]));
+		}
+		input_report_key(dev, BTN_TOOL_FINGER,    packet[1] & 0x80);
+		input_report_key(dev, BTN_TOOL_DOUBLETAP, packet[1] & 0x10);
+		input_report_key(dev, BTN_TOOL_TRIPLETAP, packet[1] & 0x20);
+		input_report_key(dev, BTN_LEFT,  packet[0] & 0x01);
+		input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
+	} else {
+		input_report_key(dev, BTN_LEFT,   packet[0] & 0x01);
+		input_report_key(dev, BTN_MIDDLE, packet[0] & 0x04);
+		input_report_key(dev, BTN_RIGHT,  packet[0] & 0x02);
+
+		if ((packet[0] & 0xc0) && (packet[1] & 0xf0)) {
+			input_report_key(dev, BTN_0, packet[3] & 0x01);	/* top right */
+			input_report_key(dev, BTN_1, packet[3] & 0x02);	/* bottom right */
+			input_report_key(dev, BTN_2, packet[3] & 0x04);	/* bottom left */
+			input_report_key(dev, BTN_3, packet[3] & 0x08);	/* top left */
+		} else if (packet[3] & 0x0f) {
+			if (packet[3] & 0x40)
+				input_report_rel(dev, REL_HWHEEL,
+					(int) (packet[3] & 0x08) -
+					(int) (packet[3] & 0x07));
+			else
+				input_report_rel(dev, REL_WHEEL,
+					(int) (packet[3] & 0x08) -
+					(int) (packet[3] & 0x07));
+		}
+
+		if (packet[1])
+			input_report_rel(dev, REL_X,
+				(int) (packet[1] & 0x7f) -
+				(int) (packet[1] & 0x80));
+		if (packet[2])
+			input_report_rel(dev, REL_Y,
+				(int) (packet[2] & 0x80) -
+				(int) (packet[2] & 0x7f));
+	}
+
+	input_sync(dev);
+
+	return PSMOUSE_FULL_PACKET;
+}
+
+/*
+ * Initialise the touchpad to a default state. Because we don't know (yet)
+ * how to read registers we need to write some default values so we can
+ * report their contents when asked to.
+ */
+static void elantech_set_defaults(struct psmouse *psmouse)
+{
+	struct elantech_data 	*etd = psmouse->private;
+	struct input_dev 	*dev = psmouse->dev;
+
+	/*
+	 * For now, use the Elantech Windows driver default values
+	 */
+	etd->reg_10 = 0x12;
+	elantech_write_reg(psmouse, 0x10, etd->reg_10);
+	etd->reg_11 = 0x8f;
+	elantech_write_reg(psmouse, 0x11, etd->reg_11);
+	etd->reg_20 = 0x0a;
+	elantech_write_reg(psmouse, 0x20, etd->reg_20);
+	etd->reg_21 = 0x60;
+	elantech_write_reg(psmouse, 0x21, etd->reg_21);
+	etd->reg_22 = 0xff;
+	elantech_write_reg(psmouse, 0x22, etd->reg_22);
+	/*
+	 * However, the Windows driver mentions registers 23, 24 and 26
+	 * but seems to never actually write them
+	 */
+	etd->reg_23 = 0x10;
+	/*
+	 * elantech_write_reg(psmouse, 0x23, etd->reg_23);
+	 */
+	etd->reg_24 = 0x10;
+	/*
+	 * elantech_write_reg(psmouse, 0x24, etd->reg_24);
+	 */
+	etd->reg_25 = 0x03;
+	elantech_write_reg(psmouse, 0x25, etd->reg_25);
+	/*
+	 * The Windows driver default value of 0x00 seems wrong as it
+	 * disables smart edge cursor movement
+	 */
+	etd->reg_26 = 0x00;
+	/*
+	 * elantech_write_reg(psmouse, 0x26, etd->reg_26);
+	 */
+
+	set_bit(EV_KEY, dev->evbit);
+	set_bit(BTN_LEFT, dev->keybit);
+	set_bit(BTN_MIDDLE, dev->keybit);
+	set_bit(BTN_RIGHT, dev->keybit);
+
+	set_bit(BTN_TOUCH, dev->keybit);
+	set_bit(BTN_TOOL_FINGER, dev->keybit);
+	set_bit(BTN_TOOL_DOUBLETAP, dev->keybit);
+	set_bit(BTN_TOOL_TRIPLETAP, dev->keybit);
+
+	/* Corner taps */
+	set_bit(BTN_0, dev->keybit);
+	set_bit(BTN_1, dev->keybit);
+	set_bit(BTN_2, dev->keybit);
+	set_bit(BTN_3, dev->keybit);
+
+	set_bit(EV_REL, dev->evbit);
+	set_bit(REL_X, dev->relbit);
+	set_bit(REL_Y, dev->relbit);
+	set_bit(REL_WHEEL, dev->relbit);
+	set_bit(REL_HWHEEL, dev->relbit);
+
+	set_bit(EV_ABS, dev->evbit);
+	input_set_abs_params(dev, ABS_X, ETP_XMIN, ETP_XMAX, 0, 0);
+	input_set_abs_params(dev, ABS_Y, ETP_YMIN, ETP_YMAX, 0, 0);
+}
+
+struct elantech_attr_data {
+	size_t		field_offset;
+	unsigned char	reg;
+};
+
+/*
+ * Display a register value by reading a sysfs entry
+ */
+static ssize_t elantech_show_int_attr(struct psmouse *psmouse, void *data, char *buf)
+{
+	struct elantech_data		*etd = psmouse->private;
+	struct elantech_attr_data	*attr = data;
+	unsigned char			*reg = (unsigned char *)
+						etd + attr->field_offset;
+
+	return sprintf(buf, "0x%02x\n", *reg);
+}
+
+/*
+ * Write a register value by writing a sysfs entry
+ */
+static ssize_t elantech_set_int_attr(struct psmouse *psmouse, void *data,
+						const char *buf, size_t count)
+{
+	struct elantech_data 		*etd = psmouse->private;
+	struct elantech_attr_data 	*attr = data;
+	unsigned char 			*reg = (unsigned char *)
+						etd + attr->field_offset;
+	unsigned long			value;
+	char				*rest;
+
+	value = simple_strtoul(buf, &rest, 16);
+	if (*rest || value > 255)
+		return -EINVAL;
+
+	/* Force 4 byte packet mode because driver expects this */
+	if (attr->reg == 0x11)
+		value |= ETP_4_BYTE_MODE;
+
+	*reg = value;
+	elantech_write_reg(psmouse, attr->reg, value);
+
+	return count;
+}
+
+#define ELANTECH_INT_ATTR(_name, _register)				\
+	static struct elantech_attr_data elantech_attr_##_name = {	\
+		.field_offset = offsetof(struct elantech_data, _name),	\
+		.reg = _register,					\
+	};								\
+	PSMOUSE_DEFINE_ATTR(_name, S_IWUSR | S_IRUGO,			\
+			    &elantech_attr_##_name,			\
+			    elantech_show_int_attr,			\
+			    elantech_set_int_attr)
+
+ELANTECH_INT_ATTR(reg_10, 0x10);
+ELANTECH_INT_ATTR(reg_11, 0x11);
+ELANTECH_INT_ATTR(reg_20, 0x20);
+ELANTECH_INT_ATTR(reg_21, 0x21);
+ELANTECH_INT_ATTR(reg_22, 0x22);
+ELANTECH_INT_ATTR(reg_23, 0x23);
+ELANTECH_INT_ATTR(reg_24, 0x24);
+ELANTECH_INT_ATTR(reg_25, 0x25);
+ELANTECH_INT_ATTR(reg_26, 0x26);
+
+static struct attribute *elantech_attrs[] = {
+	&psmouse_attr_reg_10.dattr.attr,
+	&psmouse_attr_reg_11.dattr.attr,
+	&psmouse_attr_reg_20.dattr.attr,
+	&psmouse_attr_reg_21.dattr.attr,
+	&psmouse_attr_reg_22.dattr.attr,
+	&psmouse_attr_reg_23.dattr.attr,
+	&psmouse_attr_reg_24.dattr.attr,
+	&psmouse_attr_reg_25.dattr.attr,
+	&psmouse_attr_reg_26.dattr.attr,
+	NULL
+};
+
+static struct attribute_group elantech_attr_group = {
+	.attrs = elantech_attrs,
+};
+
+/*
+ * Clean up sysfs entries when disconnecting
+ */
+static void elantech_disconnect(struct psmouse *psmouse)
+{
+	sysfs_remove_group(&psmouse->ps2dev.serio->dev.kobj,
+				&elantech_attr_group);
+	kfree(psmouse->private);
+	psmouse->private = NULL;
+}
+
+/*
+ * Use magic knock to detect Elantech touchpad
+ */
+int elantech_detect(struct psmouse *psmouse, int set_properties)
+{
+	struct ps2dev	*ps2dev = &psmouse->ps2dev;
+	unsigned char	param[3];
+
+	ps2_command(ps2dev,  NULL, PSMOUSE_CMD_DISABLE);
+	ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11);
+	ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11);
+	ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11);
+	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
+
+	if ((param[0] != 0x3c) || (param[1] != 0x03) || (param[2] != 0xc8)) {
+		pr_info("elantech.c: unexpected magic knock result 0x%02x, 0x%02x, 0x%02x.\n",
+			param[0], param[1], param[2]);
+		return -1;
+	}
+	/* Why does the Elantech Windows driver try this?
+	 * For now just report it and see if it makes sense
+	 * when more people use this driver
+	 */
+	if (!synaptics_send_cmd(psmouse, SYN_QUE_MODEL, param))
+		pr_info("elantech.c: Synaptics identify query result 0x%02x, 0x%02x, 0x%02x.\n",
+			param[0], param[1], param[2]);
+	if (!synaptics_send_cmd(psmouse, SYN_QUE_CAPABILITIES, param))
+		pr_info("elantech.c: Synaptics capabilities query result 0x%02x, 0x%02x, 0x%02x.\n",
+			param[0], param[1], param[2]);
+
+	if (set_properties) {
+		psmouse->vendor = "Elantech";
+		psmouse->name = "Touchpad";
+	}
+
+	return 0;
+}
+
+/*
+ * Initialize the touchpad and create sysfs entries
+ */
+int elantech_init(struct psmouse *psmouse)
+{
+	struct elantech_data 	*priv;
+	int			error;
+
+	priv = kzalloc(sizeof(struct elantech_data), GFP_KERNEL);
+	psmouse->private = priv;
+	if (!priv)
+		return -1;
+
+	elantech_set_defaults(psmouse);
+
+	psmouse->protocol_handler = elantech_process_byte;
+	psmouse->disconnect = elantech_disconnect;
+	psmouse->pktsize = 4;
+
+	error = sysfs_create_group(&psmouse->ps2dev.serio->dev.kobj,
+					&elantech_attr_group);
+	if (error) {
+		printk(KERN_ERR "elantech.c: failed to create sysfs attributes, error: %d\n",
+			error);
+		kfree(priv);
+		return -1;
+	}
+
+	return 0;
+}
diff -puN /dev/null drivers/input/mouse/elantech.h
--- /dev/null
+++ a/drivers/input/mouse/elantech.h
@@ -0,0 +1,44 @@
+/*
+ * Elantech Touchpad driver
+ *
+ * Copyright (C) 2007 Arjan Opmeer <arjan@opmeer.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * Trademarks are the property of their respective owners.
+ */
+
+#ifndef _ELANTECH_H
+#define _ELANTECH_H
+
+#define ELANTECH_COMMAND	0x11	/* Commands start with this value */
+
+struct elantech_data {
+	unsigned char reg_10;
+	unsigned char reg_11;
+	unsigned char reg_20;
+	unsigned char reg_21;
+	unsigned char reg_22;
+	unsigned char reg_23;
+	unsigned char reg_24;
+	unsigned char reg_25;
+	unsigned char reg_26;
+};
+
+#ifdef CONFIG_MOUSE_PS2_ELANTECH
+int elantech_detect(struct psmouse *psmouse, int set_properties);
+int elantech_init(struct psmouse *psmouse);
+#else
+static inline int elantech_detect(struct psmouse *psmouse, int set_properties)
+{
+	return -ENOSYS;
+}
+static inline int elantech_init(struct psmouse *psmouse)
+{
+	return -ENOSYS;
+}
+#endif /* CONFIG_MOUSE_PS2_ELANTECH */
+
+#endif
diff -puN drivers/input/mouse/psmouse-base.c~first-stab-at-elantech-touchpad-driver-for-26226-testers drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~first-stab-at-elantech-touchpad-driver-for-26226-testers
+++ a/drivers/input/mouse/psmouse-base.c
@@ -29,6 +29,7 @@
 #include "lifebook.h"
 #include "trackpoint.h"
 #include "touchkit_ps2.h"
+#include "elantech.h"
 
 #define DRIVER_DESC	"PS/2 mouse driver"
 
@@ -654,6 +655,13 @@ static int psmouse_extensions(struct psm
 	ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_RESET_DIS);
 	psmouse_reset(psmouse);
 
+	if (elantech_detect(psmouse, set_properties) == 0) {
+		if (max_proto > PSMOUSE_IMEX) {
+			if (!set_properties || elantech_init(psmouse) == 0)
+				return PSMOUSE_ELANTECH;
+		}
+	}
+
 	if (max_proto >= PSMOUSE_IMEX && im_explorer_detect(psmouse, set_properties) == 0)
 		return PSMOUSE_IMEX;
 
@@ -763,6 +771,15 @@ static const struct psmouse_protocol psm
 		.detect		= touchkit_ps2_detect,
 	},
 #endif
+#ifdef CONFIG_MOUSE_PS2_ELANTECH
+	{
+		.type		= PSMOUSE_ELANTECH,
+		.name		= "ETPS/2",
+		.alias		= "elantech",
+		.detect		= elantech_detect,
+		.init		= elantech_init,
+	},
+#endif
 	{
 		.type		= PSMOUSE_CORTRON,
 		.name		= "CortronPS/2",
diff -puN drivers/input/mouse/psmouse.h~first-stab-at-elantech-touchpad-driver-for-26226-testers drivers/input/mouse/psmouse.h
--- a/drivers/input/mouse/psmouse.h~first-stab-at-elantech-touchpad-driver-for-26226-testers
+++ a/drivers/input/mouse/psmouse.h
@@ -89,6 +89,7 @@ enum psmouse_type {
 	PSMOUSE_TRACKPOINT,
 	PSMOUSE_TOUCHKIT_PS2,
 	PSMOUSE_CORTRON,
+	PSMOUSE_ELANTECH,
 	PSMOUSE_AUTO		/* This one should always be last */
 };
 
_

Patches currently in -mm which might be from arjan@opmeer.net are

first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
