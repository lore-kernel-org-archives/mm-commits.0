From: akpm@linux-foundation.org
Subject: + elantech-touchpad-driver.patch added to -mm tree
Date: Wed, 31 Oct 2007 13:57:02 -0700
Message-ID: <200710312057.l9VKv2BJ027690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53782 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324AbXJaU7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Oct 2007 16:59:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@opmeer.net, dtor@mail.ru, jkosina@suse.cz


The patch titled
     Elantech touchpad driver
has been added to the -mm tree.  Its filename is
     elantech-touchpad-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Elantech touchpad driver
From: Arjan Opmeer <arjan@opmeer.net>

- needs a changelog

- needs a signed-off-by:

Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/input/elantech.txt   |  172 +++++++++
 drivers/input/mouse/Kconfig        |   15 
 drivers/input/mouse/Makefile       |    1 
 drivers/input/mouse/elantech.c     |  485 +++++++++++++++++++++++++++
 drivers/input/mouse/elantech.h     |   82 ++++
 drivers/input/mouse/psmouse-base.c |   17 
 drivers/input/mouse/psmouse.h      |    1 
 7 files changed, 773 insertions(+)

diff -puN /dev/null Documentation/input/elantech.txt
--- /dev/null
+++ a/Documentation/input/elantech.txt
@@ -0,0 +1,172 @@
+Elantech Touchpad Driver
+========================
+        Copyright (C) 2007 Arjan Opmeer <arjan@opmeer.net>
+
+        Extra information found and provided by Steve Havelka
+
+Configuration of the touchpad is performed by writing values to registers
+found under sysfs entries /sys/bus/serio/drivers/psmouse/serio?/reg_*.
+
+E.g. to disable tapping while leaving the other settings to the default
+Windows driver value one would:
+
+   echo -n 0x32 > reg_10
+
+
+Registers
+~~~~~~~~~
+
+* reg_10        (Windows driver default value 0x12)
+
+   bit   7   6   5   4   3   2   1   0
+         B   C   T   D   L   A   S   E
+
+         E: 1 = enable smart edges in other cases
+         S: 1 = enable smart edges only when dragging
+         A: 1 = absolute mode (needs 4 byte packets, see reg_11)
+         L: 1 = enable drag lock (see reg_22)
+         D: 1 = disable dynamic resolution
+         T: 1 = disable tapping
+         C: 1 = enable corner tap
+         B: 1 = swap left and right button
+
+* reg_11        (Windows driver default value 0x8f)
+
+   bit   7   6   5   4   3   2   1   0
+         1   0   0   H   V   1   F   P
+
+         P: 1 = enable parity checking for relative mode
+         F: 1 = enable native 4 byte packet mode
+         V: 1 = enable vertical scroll area
+         H: 1 = enable horizonal scroll area
+
+
+* reg_20        (Windows driver default value 0x0a)
+
+         single finger width?
+
+* reg_21        (Windows driver default value 0x60)
+
+         scroll area width (small: 0x40 ... wide: 0xff)
+
+* reg_22        (Windows driver default value 0xff)
+
+         drag lock time out (short: 0x14 ... long: 0xfe; 0xff =never)
+
+* reg_23        (Windows driver default value 0x10)
+
+         tap make timeout?
+
+         Note: the Windows driver does not write this register
+
+* reg_24        (Windows driver default value 0x10)
+
+         tap release timeout?
+
+         Note: the Windows driver does not write this register
+
+* reg_25        (Windows driver default value 0x03)
+
+         smart edge cursor speed (0x02 = slow, 0x03 = medium, 0x04 = fast)
+
+* reg_26        (Windows driver default value 0x00 ?? )
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
+However, it can be configured to talk its native 4 byte relative mode and 4
+byte absolute mode both for which a dedicated driver is needed.
+
+
+Native 4 byte relative mode packet format
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+byte 0:
+   bit   7   6   5   4   3   2   1   0
+         c   c  p2  p1   1   M   R   L
+
+         L, R, M = 1 when Left, Right, Middle mouse button pressed
+            some models have M as byte 3 odd parity
+         when parity checking is enabled (P = 1):
+            p1 = byte 1 odd parity
+            p2 = byte 2 odd parity
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
+         w   h  n1  n0  d3  d2  d1  d0
+
+         when parity checking is enabled (P = 1):
+            normally:
+               d3..d0 = scroll wheel amount and direction
+                        positive = down or left
+                        negative = up or right
+            when corner tap detected:
+               d0 = 1 when top right corner tapped
+               d1 = 1 when bottom right corner tapped
+               d2 = 1 when bottom left corner tapped
+               d3 = 1 when top left corner tapped
+            n1..n0 = number of fingers on touchpad
+               not all models report this but map one, two and three
+               finger taps directly to L, M and R mouse buttons
+            w = 1 when wide finger touch?
+            h = 1 when horizontal scroll action
+         otherwise (P = 0):
+            all of byte 3 is vertical scroll amount and direction
+            negative = up
+            positive = down
+
+
+Native 4 byte absolute mode packet format
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+byte 0:
+   bit   7   6   5   4   3   2   1   0
+         D   U  p1  p2   1  p3   R   L
+
+         L, R = 1 when Left, Right mouse button pressed
+         p1..p3 = parity bit of bytes 1..3
+         D, U = 1 when rocker switch pressed Up, Down
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
diff -puN drivers/input/mouse/Kconfig~elantech-touchpad-driver drivers/input/mouse/Kconfig
--- a/drivers/input/mouse/Kconfig~elantech-touchpad-driver
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
diff -puN drivers/input/mouse/Makefile~elantech-touchpad-driver drivers/input/mouse/Makefile
--- a/drivers/input/mouse/Makefile~elantech-touchpad-driver
+++ a/drivers/input/mouse/Makefile
@@ -24,3 +24,4 @@ psmouse-$(CONFIG_MOUSE_PS2_LOGIPS2PP)	+=
 psmouse-$(CONFIG_MOUSE_PS2_LIFEBOOK)	+= lifebook.o
 psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)	+= trackpoint.o
 psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)	+= touchkit_ps2.o
+psmouse-$(CONFIG_MOUSE_PS2_ELANTECH)	+= elantech.o
diff -puN /dev/null drivers/input/mouse/elantech.c
--- /dev/null
+++ a/drivers/input/mouse/elantech.c
@@ -0,0 +1,485 @@
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
+/*
+ * Native absolute mode reporting has odd parity check on the last 3 bytes.
+ * Native relative mode can have odd parity checking on second and third byte,
+ * or last 3 bytes depending on model.
+ */
+static unsigned char parity[256];
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
+	if (psmouse_sliced_command(psmouse, ELANTECH_COMMAND_START) ||
+	    psmouse_sliced_command(psmouse, reg) ||
+	    psmouse_sliced_command(psmouse, val) ||
+	    ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSCALE11)) {
+		return -1;
+	}
+
+	return 0;
+}
+
+static void elantech_packet_dump(unsigned char *packet, int size)
+{
+	int	i;
+
+	printk(KERN_DEBUG "elantech.c: PS/2 packet [");
+	for (i = 0; i < size; i++)
+		printk("%s0x%02x ", (i) ? ", " : " ", packet[i]);
+	printk("]\n");
+}
+
+/*
+ * Report absolute mode input events
+ */
+static void elantech_report_absolute(struct psmouse *psmouse)
+{
+	struct elantech_data 	*etd = psmouse->private;
+	struct input_dev 	*dev = psmouse->dev;
+	unsigned char 		*packet = psmouse->packet;
+	int			fingers;
+
+	/* byte 0:  D   U  p1  p2   1  p3   R   L
+	 * byte 1:  f   0  th  tw  x9  x8  y9  y8
+	 * byte 2: x7  x6  x5  x4  x3  x2  x1  x0
+	 * byte 3: y7  y6  y5  y4  y3  y2  y1  y0 */
+	fingers = ((packet[1] & 0x80) >> 7) + ((packet[1] & 0x30) >> 4);
+	input_report_key(dev, BTN_TOUCH, fingers != 0);
+	if (fingers == 1) {
+		input_report_abs(dev, ABS_X,
+			((packet[1] & 0x0c) << 6) | packet[2]);
+		input_report_abs(dev, ABS_Y, ETP_YMAX -
+			(((packet[1] & 0x03) << 8) | packet[3]));
+	}
+	input_report_abs(dev, ABS_PRESSURE, (fingers) ? ETP_DEF_PRESSURE : 0);
+	input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
+	input_report_key(dev, BTN_TOOL_DOUBLETAP, fingers == 2);
+	input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
+	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
+	if (etd->capabilities & ETP_CAP_HAS_ROCKER) {
+		input_report_key(dev, BTN_FORWARD, packet[0] & 0x40); /* rocker up */
+		input_report_key(dev, BTN_BACK, packet[0] & 0x80); /* rocker down */
+	}
+}
+
+/*
+ * Report relative mode input events
+ */
+static void elantech_report_relative(struct psmouse *psmouse)
+{
+	struct elantech_data 	*etd = psmouse->private;
+	struct input_dev 	*dev = psmouse->dev;
+	unsigned char 		*packet = psmouse->packet;
+	int 			fingers, cornertap;
+
+	/* byte 0:  c   c  p2  p1   1   M   R   L
+	 * byte 1: dx7 dx6 dx5 dx4 dx3 dx2 dx1 dx0
+	 * byte 2: dy7 dy6 dy5 dy4 dy3 dy2 dy1 dy0
+	 * byte 3:  w   h  n1  n0  d3  d2  d1  d0 */
+	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
+	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
+
+	if (etd->capabilities & ETP_CAP_REPORTS_MIDDLE_BUTTON)
+		input_report_key(dev, BTN_MIDDLE, packet[0] & 0x04);
+
+	if (etd->capabilities & ETP_CAP_ALTERNATE_TAP_BITS) {
+		fingers = (packet[3] & 0x30) >> 4;
+		input_report_key(dev, BTN_LEFT, fingers == 1);
+		input_report_key(dev, BTN_MIDDLE, fingers == 2);
+		input_report_key(dev, BTN_RIGHT, fingers == 3);
+	}
+
+	cornertap = (((packet[0] & 0xc0) == 0xc0) && ((packet[1] & 0xf0) == 0xf0));
+	if (!cornertap) {
+		input_report_rel(dev, REL_X, (int) (packet[1] & 0x7f) -
+					     (int) (packet[1] & 0x80));
+		input_report_rel(dev, REL_Y, (int) (packet[2] & 0x80) -
+					     (int) (packet[2] & 0x7f));
+	}
+
+	/* No more information in 3 bytes */
+	if (!(etd->reg_11 & ETP_R11_4_BYTE_MODE))
+		return;
+
+	if (cornertap) {
+		input_report_key(dev, BTN_0, packet[3] & 0x01);	/* top right */
+		input_report_key(dev, BTN_1, packet[3] & 0x02);	/* bottom right */
+		input_report_key(dev, BTN_2, packet[3] & 0x04);	/* bottom left */
+		input_report_key(dev, BTN_3, packet[3] & 0x08);	/* top left */
+	}
+
+	if (etd->reg_11 & ETP_R11_PARITY_CHECKING) {
+		if (packet[3] & 0x0f) {
+			if (packet[3] & 0x40) {
+				input_report_rel(dev, REL_HWHEEL,
+					(int) (packet[3] & 0x08) -
+					(int) (packet[3] & 0x07));
+			} else {
+				input_report_rel(dev, REL_WHEEL,
+					(int) (packet[3] & 0x08) -
+					(int) (packet[3] & 0x07));
+			}
+		}
+	} else {
+		if (packet[3])
+			input_report_rel(dev, REL_WHEEL,
+				(int) (packet[3] & 0x80) -
+				(int) (packet[3] & 0x7f));
+	}
+}
+
+/*
+ * Process byte stream from mouse and interpret complete data packets
+ */
+static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
+{
+	struct elantech_data 	*etd = psmouse->private;
+	struct input_dev 	*dev = psmouse->dev;
+	unsigned char 		*packet = psmouse->packet;
+
+	if (psmouse->pktcnt < psmouse->pktsize)
+		return PSMOUSE_GOOD_DATA;
+
+	if (etd->debug)
+		elantech_packet_dump(packet, psmouse->pktsize);
+
+	if (etd->reg_10 & ETP_R10_ABSOLUTE_MODE) {
+		/* byte 0:  D   U  p1  p2   1  p3   R   L */
+		if ((parity[packet[1]] != ((packet[0] & 0x20) >> 5)) ||
+		    (parity[packet[2]] != ((packet[0] & 0x10) >> 4)) ||
+		    (parity[packet[3]] != ((packet[0] & 0x04) >> 2)))
+			return PSMOUSE_BAD_DATA;
+	} else if (etd->reg_11 & ETP_R11_PARITY_CHECKING) {
+		/* byte 0:  c   c  p2  p1   1   M   R   L */
+		if ((parity[packet[1]] != ((packet[0] & 0x10) >> 4)) ||
+		    (parity[packet[2]] != ((packet[0] & 0x20) >> 5)))
+			return PSMOUSE_BAD_DATA;
+		/* Parity bit has not been sacrificed as middle mouse button bit */
+		if (!(etd->capabilities & ETP_CAP_REPORTS_MIDDLE_BUTTON)) {
+			if (parity[packet[3]] != ((packet[0] & 0x04) >> 2))
+				return PSMOUSE_BAD_DATA;
+		}
+	}
+
+	if (etd->reg_10 & ETP_R10_ABSOLUTE_MODE) {
+		elantech_report_absolute(psmouse);
+	} else {
+		elantech_report_relative(psmouse);
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
+	/* Rocker button */
+	if (etd->capabilities & ETP_CAP_HAS_ROCKER) {
+		set_bit(BTN_FORWARD, dev->keybit);
+		set_bit(BTN_BACK, dev->keybit);
+	}
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
+	input_set_abs_params(dev, ABS_PRESSURE, 0, ETP_MAX_PRESSURE, 0, 0);
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
+	if (attr->reg == 0x10) {
+		/* Force on 4 byte mode when absolute mode gets selected */
+		if ((value & ETP_R10_ABSOLUTE_MODE) &&
+		   !(etd->reg_11 & ETP_R11_4_BYTE_MODE)) {
+			etd->reg_11 |= ETP_R11_4_BYTE_MODE;
+			elantech_write_reg(psmouse, 0x11, etd->reg_11);
+			psmouse->pktsize = 4;
+		}
+	} else if (attr->reg == 0x11) {
+		if (value & ETP_R11_4_BYTE_MODE)
+			psmouse->pktsize = 4;
+		else {
+			/* Force off absolute mode when 4 byte mode is no longer selected */
+			if (etd->reg_10 & ETP_R10_ABSOLUTE_MODE) {
+				etd->reg_10 ^= ETP_R10_ABSOLUTE_MODE;
+				elantech_write_reg(psmouse, 0x10, etd->reg_10);
+			}
+			psmouse->pktsize = 3;
+		}
+	}
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
+ELANTECH_INT_ATTR(debug, 0);
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
+	&psmouse_attr_debug.dattr.attr,
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
+	struct elantech_data 	*etd;
+	int			i, error;
+	unsigned char		param[3];
+
+	etd = kzalloc(sizeof(struct elantech_data), GFP_KERNEL);
+	psmouse->private = etd;
+	if (!etd)
+		return -1;
+
+	parity[0] = 1;
+	for (i = 1; i < 256; i++)
+		parity[i] = (parity[i & (i - 1)] ^ 1);
+
+	/*
+	 * Why does the Elantech Windows driver try this?
+	 * For now just report it and see if it makes sense
+	 * when more people use this driver
+	 */
+	if (!synaptics_send_cmd(psmouse, SYN_QUE_IDENTIFY, param))
+		pr_info("elantech.c: Synaptics identify query result 0x%02x, 0x%02x, 0x%02x.\n",
+			param[0], param[1], param[2]);
+	if (!synaptics_send_cmd(psmouse, SYN_QUE_MODES, param))
+		pr_info("elantech.c: Synaptics modes query result 0x%02x, 0x%02x, 0x%02x.\n",
+			param[0], param[1], param[2]);
+	if (!synaptics_send_cmd(psmouse, SYN_QUE_CAPABILITIES, param)) {
+		pr_info("elantech.c: Synaptics capabilities query result 0x%02x, 0x%02x, 0x%02x.\n",
+			param[0], param[1], param[2]);
+		etd->capabilities = param[0];
+	}
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
+		kfree(etd);
+		return -1;
+	}
+
+	return 0;
+}
diff -puN /dev/null drivers/input/mouse/elantech.h
--- /dev/null
+++ a/drivers/input/mouse/elantech.h
@@ -0,0 +1,82 @@
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
+/*
+ * Commands start with this value
+ */
+#define ELANTECH_COMMAND_START		0x11
+
+/*
+ * Register bitmasks
+ */
+#define ETP_R10_ABSOLUTE_MODE		0x04
+#define ETP_R11_PARITY_CHECKING		0x01
+#define ETP_R11_4_BYTE_MODE 		0x02
+
+/*
+ * Capability bitmasks
+ */
+#define ETP_CAP_REPORTS_MIDDLE_BUTTON	0x02
+#define ETP_CAP_HAS_ROCKER		0x04
+#define ETP_CAP_ALTERNATE_TAP_BITS	0x10
+
+/*
+ * One hard to find application note states that X axis range is 0 to 576
+ * and Y axis range is 0 to 384.
+ * Edge fuzz might be necessary because of bezel around the touchpad.
+ */
+#define ETP_EDGE_FUZZ			32
+
+#define ETP_XMIN 			(  0 + ETP_EDGE_FUZZ)
+#define ETP_XMAX 			(576 - ETP_EDGE_FUZZ)
+#define ETP_YMIN 			(  0 + ETP_EDGE_FUZZ)
+#define ETP_YMAX 			(384 - ETP_EDGE_FUZZ)
+
+/*
+ * It seems the touchpad does not report pressure.
+ * Just choose some values for compatibility with X Synaptics driver
+ */
+#define ETP_MAX_PRESSURE		127
+#define ETP_DEF_PRESSURE		64
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
+	unsigned char debug;
+	unsigned char capabilities;
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
diff -puN drivers/input/mouse/psmouse-base.c~elantech-touchpad-driver drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~elantech-touchpad-driver
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
diff -puN drivers/input/mouse/psmouse.h~elantech-touchpad-driver drivers/input/mouse/psmouse.h
--- a/drivers/input/mouse/psmouse.h~elantech-touchpad-driver
+++ a/drivers/input/mouse/psmouse.h
@@ -88,6 +88,7 @@ enum psmouse_type {
 	PSMOUSE_LIFEBOOK,
 	PSMOUSE_TRACKPOINT,
 	PSMOUSE_TOUCHKIT_PS2,
+	PSMOUSE_ELANTECH,
 	PSMOUSE_CORTRON,
 	PSMOUSE_AUTO		/* This one should always be last */
 };
_

Patches currently in -mm which might be from arjan@opmeer.net are

elantech-touchpad-driver.patch
