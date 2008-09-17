From: akpm@linux-foundation.org
Subject: + elantech-touchpad-driver-update.patch added to -mm tree
Date: Wed, 17 Sep 2008 13:03:31 -0700
Message-ID: <200809172003.m8HK3VPe028041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892AbYIQUEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 16:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@opmeer.net, dtor@mail.ru, jkosina@suse.cz


The patch titled
     input: Update Elantech touchpad driver to v5 for kernel 2.6.27-rc5-mm1
has been added to the -mm tree.  Its filename is
     elantech-touchpad-driver-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: Update Elantech touchpad driver to v5 for kernel 2.6.27-rc5-mm1
From: Arjan Opmeer <arjan@opmeer.net>

Update the Elantech touchpad driver to v5

- Put the Elantech entry last in the psmouse_protocols[] list as it is also
  the last one in the psmouse_type enum.
- Remove support for relative mode. The driver now always uses the touchpad
  in absolute mode.
- Add support for the new Elantech touchpad model as found in the EeePC that
  uses a new protocol.

Signed-off-by: Arjan Opmeer <arjan@opmeer.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/input/elantech.txt   |  383 ++++++++++++---
 drivers/input/mouse/elantech.c     |  657 +++++++++++++++++----------
 drivers/input/mouse/elantech.h     |   83 ++-
 drivers/input/mouse/psmouse-base.c |   12 
 4 files changed, 797 insertions(+), 338 deletions(-)

diff -puN Documentation/input/elantech.txt~elantech-touchpad-driver-update Documentation/input/elantech.txt
--- a/Documentation/input/elantech.txt~elantech-touchpad-driver-update
+++ a/Documentation/input/elantech.txt
@@ -1,27 +1,125 @@
 Elantech Touchpad Driver
 ========================
-        Copyright (C) 2007 Arjan Opmeer <arjan@opmeer.net>
 
-        Extra information found and provided by Steve Havelka
+	Copyright (C) 2007-2008 Arjan Opmeer <arjan@opmeer.net>
 
-Configuration of the touchpad is performed by writing values to registers
-found under sysfs entries /sys/bus/serio/drivers/psmouse/serio?/reg_*.
+	Extra information for hardware version 1 found and
+	provided by Steve Havelka
 
-E.g. to disable tapping while leaving the other settings to the default
-Windows driver value one would:
+	Version 2 (EeePC) hardware support based on patches
+	received from Woody at Xandros and forwarded to me
+	by user StewieGriffin at the eeeuser.com forum
 
-   echo -n 0x32 > reg_10
 
+Contents
+~~~~~~~~
 
-Registers
-~~~~~~~~~
+ 1. Introduction
+ 2. Extra knobs
+ 3. Hardware version 1
+    3.1 Registers
+    3.2 Native relative mode 4 byte packet format
+    3.3 Native absolute mode 4 byte packet format
+ 4. Hardware version 2
+    4.1 Registers
+    4.2 Native absolute mode 6 byte packet format
+        4.2.1 One finger touch
+        4.2.2 Two finger touch
 
-* reg_10        (Windows driver default value 0x12)
+
+
+1. Introduction
+   ~~~~~~~~~~~~
+
+Currently the Linux Elantech touchpad driver is aware of two different
+hardware versions unimaginatively called version 1 and version 2. Version 1
+is found in "older" laptops and uses 4 bytes per packet. Version 2 seems to
+be introduced with the EeePC and uses 6 bytes per packet.
+
+The driver tries to support both hardware versions and should be compatible
+with the Xorg Synaptics touchpad driver and its graphical configuration
+utilities.
+
+Additionally the operation of the touchpad can be altered by adjusting the
+contents of some of its internal registers. These registers are represented
+by the driver as sysfs entries under /sys/bus/serio/drivers/psmouse/serio?
+that can be read from and written to.
+
+Currently only the registers for hardware version 1 are somewhat understood.
+Hardware version 2 seems to use some of the same registers but it is not
+known whether the bits in the registers represent the same thing or might
+have changed their meaning.
+
+On top of that, some register settings have effect only when the touchpad is
+in relative mode and not in absolute mode. As the Linux Elantech touchpad
+driver always puts the hardware into absolute mode not all information
+mentioned below can be used immediately. But because there is no freely
+available Elantech documentation the information is provided here anyway for
+completeness sake.
+
+
+/////////////////////////////////////////////////////////////////////////////
+
+
+2. Extra knobs
+   ~~~~~~~~~~~
+
+Currently the Linux Elantech touchpad driver provides two extra knobs under
+/sys/bus/serio/drivers/psmouse/serio? for the user.
+
+* debug
+
+   Turn different levels of debugging ON or OFF.
+
+   By echoing "0" to this file all debugging will be turned OFF.
+
+   Currently a value of "1" will turn on some basic debugging and a value of
+   "2" will turn on packet debugging. For hardware version 1 the default is
+   OFF. For version 2 the default is "1".
+
+   Turning packet debugging on will make the driver dump every packet
+   received to the syslog before processing it. Be warned that this can
+   generate quite a lot of data!
+
+* paritycheck
+
+   Turns parity checking ON or OFF.
+
+   By echoing "0" to this file parity checking will be turned OFF. Any
+   non-zero value will turn it ON. For hardware version 1 the default is ON.
+   For version 2 the default it is OFF.
+
+   Hardware version 1 provides basic data integrity verification by
+   calculating a parity bit for the last 3 bytes of each packet. The driver
+   can check these bits and reject any packet that appears corrupted. Using
+   this knob you can bypass that check.
+
+   It is not known yet whether hardware version 2 provides the same parity
+   bits. Hence checking is disabled by default. Currently even turning it on
+   will do nothing.
+
+
+/////////////////////////////////////////////////////////////////////////////
+
+
+3. Hardware version 1
+   ==================
+
+3.1 Registers
+    ~~~~~~~~~
+
+By echoing a hexadecimal value to a register it contents can be altered.
+
+For example:
+
+   echo -n 0x16 > reg_10
+
+* reg_10
 
    bit   7   6   5   4   3   2   1   0
          B   C   T   D   L   A   S   E
 
-         E: 1 = enable smart edges in other cases
+         E: 1 = enable smart edges unconditionally
          S: 1 = enable smart edges only when dragging
          A: 1 = absolute mode (needs 4 byte packets, see reg_11)
          L: 1 = enable drag lock (see reg_22)
@@ -30,7 +128,7 @@ Registers
          C: 1 = enable corner tap
          B: 1 = swap left and right button
 
-* reg_11        (Windows driver default value 0x8f)
+* reg_11
 
    bit   7   6   5   4   3   2   1   0
          1   0   0   H   V   1   F   P
@@ -38,68 +136,49 @@ Registers
          P: 1 = enable parity checking for relative mode
          F: 1 = enable native 4 byte packet mode
          V: 1 = enable vertical scroll area
-         H: 1 = enable horizonal scroll area
+         H: 1 = enable horizontal scroll area
 
-
-* reg_20        (Windows driver default value 0x0a)
+* reg_20
 
          single finger width?
 
-* reg_21        (Windows driver default value 0x60)
+* reg_21
 
          scroll area width (small: 0x40 ... wide: 0xff)
 
-* reg_22        (Windows driver default value 0xff)
+* reg_22
 
-         drag lock time out (short: 0x14 ... long: 0xfe; 0xff =never)
+         drag lock time out (short: 0x14 ... long: 0xfe;
+                             0xff = tap again to release)
 
-* reg_23        (Windows driver default value 0x10)
+* reg_23
 
          tap make timeout?
 
-         Note: the Windows driver does not write this register
-
-* reg_24        (Windows driver default value 0x10)
+* reg_24
 
          tap release timeout?
 
-         Note: the Windows driver does not write this register
-
-* reg_25        (Windows driver default value 0x03)
+* reg_25
 
          smart edge cursor speed (0x02 = slow, 0x03 = medium, 0x04 = fast)
 
-* reg_26        (Windows driver default value 0x00 ?? )
+* reg_26
 
          smart edge activation area width?
 
-         Note: the Windows driver does not write this register
-         Note: the Windows driver default value of 0x00 disables smart edges
-               when it would get written
-         Note: the Windows driver sets bit 0 of the registry value to disable
-               tapping when typing, but never actually writes the register.
-               Only used as an internal driver flag?
-
 
-
-Initially the Elantouch Touchpad is in emulation mode and reports 3 byte
-standard PS/2 packets and hence works with a standard mouse driver.
-However, it can be configured to talk its native 4 byte relative mode and 4
-byte absolute mode both for which a dedicated driver is needed.
-
-
-Native 4 byte relative mode packet format
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+3.2 Native relative mode 4 byte packet format
+    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 byte 0:
    bit   7   6   5   4   3   2   1   0
          c   c  p2  p1   1   M   R   L
 
          L, R, M = 1 when Left, Right, Middle mouse button pressed
-            some models have M as byte 3 odd parity
-         when parity checking is enabled (P = 1):
-            p1 = byte 1 odd parity
-            p2 = byte 2 odd parity
+            some models have M as byte 3 odd parity bit
+         when parity checking is enabled (reg_11, P = 1):
+            p1..p2 = byte 1 and 2 odd parity bit
          c = 1 when corner tap detected
 
 byte 1:
@@ -116,48 +195,73 @@ byte 2:
          dy7..dy0 = y movement;   positive = up,    negative = down
 
 byte 3:
-   bit   7   6   5   4   3   2   1   0
-         w   h  n1  n0  d3  d2  d1  d0
+   parity checking enabled (reg_11, P = 1):
+
+      bit   7   6   5   4   3   2   1   0
+            w   h  n1  n0  ds3 ds2 ds1 ds0
 
-         when parity checking is enabled (P = 1):
             normally:
-               d3..d0 = scroll wheel amount and direction
-                        positive = down or left
-                        negative = up or right
+               ds3..ds0 = scroll wheel amount and direction
+                          positive = down or left
+                          negative = up or right
             when corner tap detected:
-               d0 = 1 when top right corner tapped
-               d1 = 1 when bottom right corner tapped
-               d2 = 1 when bottom left corner tapped
-               d3 = 1 when top left corner tapped
+               ds0 = 1 when top right corner tapped
+               ds1 = 1 when bottom right corner tapped
+               ds2 = 1 when bottom left corner tapped
+               ds3 = 1 when top left corner tapped
             n1..n0 = number of fingers on touchpad
-               not all models report this but map one, two and three
-               finger taps directly to L, M and R mouse buttons
-            w = 1 when wide finger touch?
+               only models with firmware 2.x report this, models with
+               firmware 1.x seem to map one, two and three finger taps
+               directly to L, M and R mouse buttons
             h = 1 when horizontal scroll action
-         otherwise (P = 0):
-            all of byte 3 is vertical scroll amount and direction
-            negative = up
-            positive = down
+            w = 1 when wide finger touch?
+
+   otherwise (reg_11, P = 0):
+
+      bit   7   6   5   4   3   2   1   0
+           ds7 ds6 ds5 ds4 ds3 ds2 ds1 ds0
 
+            ds7..ds0 = vertical scroll amount and direction
+                       negative = up
+                       positive = down
 
-Native 4 byte absolute mode packet format
-~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+3.3 Native absolute mode 4 byte packet format
+    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 byte 0:
-   bit   7   6   5   4   3   2   1   0
-         D   U  p1  p2   1  p3   R   L
+   firmware version 1.x:
 
-         L, R = 1 when Left, Right mouse button pressed
-         p1..p3 = parity bit of bytes 1..3
-         D, U = 1 when rocker switch pressed Up, Down
+      bit   7   6   5   4   3   2   1   0
+            D   U  p1  p2   1  p3   R   L
+
+            L, R = 1 when Left, Right mouse button pressed
+            p1..p3 = byte 1..3 odd parity bit
+            D, U = 1 when rocker switch pressed Up, Down
+
+   firmware version 2.x:
+
+      bit   7   6   5   4   3   2   1   0
+           n1  n0  p2  p1   1  p3   R   L
+
+            L, R = 1 when Left, Right mouse button pressed
+            p1..p3 = byte 1..3 odd parity bit
+            n1..n0 = number of fingers on touchpad
 
 byte 1:
-   bit   7   6   5   4   3   2   1   0
-         f   0  th  tw  x9  x8  y9  y8
+   firmware version 1.x:
+
+      bit   7   6   5   4   3   2   1   0
+            f   0  th  tw  x9  x8  y9  y8
+
+            tw = 1 when two finger touch
+            th = 1 when three finger touch
+            f  = 1 when finger touch
 
-         tw = 1 when two finger touch
-         th = 1 when three finger touch
-         f  = 1 when finger touch
+   firmware version 2.x:
+
+      bit   7   6   5   4   3   2   1   0
+            .   .   .   .  x9  x8  y9  y8
 
 byte 2:
    bit   7   6   5   4   3   2   1   0
@@ -170,3 +274,132 @@ byte 3:
         y7  y6  y5  y4  y3  y2  y1  y0
 
          y9..y0 = absolute y value (vertical)
+
+
+/////////////////////////////////////////////////////////////////////////////
+
+
+4. Hardware version 2
+   ==================
+
+
+4.1 Registers
+    ~~~~~~~~~
+
+By echoing a hexadecimal value to a register it contents can be altered.
+
+For example:
+
+   echo -n 0x56 > reg_10
+
+* reg_10
+
+   bit   7   6   5   4   3   2   1   0
+         0   1   0   1   0   1   D   0
+
+         D: 1 = enable drag and drop
+
+* reg_11
+
+   bit   7   6   5   4   3   2   1   0
+         1   0   0   0   S   0   1   0
+
+         S: 1 = enable vertical scroll
+
+* reg_21
+
+         unknown (0x00)
+
+* reg_22
+
+         drag and drop release time out (short: 0x70 ... long 0x7e;
+                                   0x7f = never i.e. tap again to release)
+
+
+4.2 Native absolute mode 6 byte packet format
+    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+4.2.1 One finger touch
+      ~~~~~~~~~~~~~~~~
+
+byte 0:
+
+   bit   7   6   5   4   3   2   1   0
+        n1  n0   .   .   .   .   R   L
+
+         L, R = 1 when Left, Right mouse button pressed
+         n1..n0 = numbers of fingers on touchpad
+
+byte 1:
+
+   bit   7   6   5   4   3   2   1   0
+        x15 x14 x13 x12 x11 x10 x9  x8
+
+byte 2:
+
+   bit   7   6   5   4   3   2   1   0
+        x7  x6  x5  x4  x4  x2  x1  x0
+
+         x15..x0 = absolute x value (horizontal)
+
+byte 3:
+
+   bit   7   6   5   4   3   2   1   0
+         .   .   .   .   .   .   .   .
+
+byte 4:
+
+   bit   7   6   5   4   3   2   1   0
+        y15 y14 y13 y12 y11 y10 y8  y8
+
+byte 5:
+
+   bit   7   6   5   4   3   2   1   0
+        y7  y6  y5  y4  y3  y2  y1  y0
+
+         y15..y0 = absolute y value (vertical)
+
+
+4.2.2 Two finger touch
+      ~~~~~~~~~~~~~~~~
+
+byte 0:
+
+   bit   7   6   5   4   3   2   1   0
+        n1  n0  ay8 ax8  .   .   R   L
+
+         L, R = 1 when Left, Right mouse button pressed
+         n1..n0 = numbers of fingers on touchpad
+
+byte 1:
+
+   bit   7   6   5   4   3   2   1   0
+        ax7 ax6 ax5 ax4 ax3 ax2 ax1 ax0
+
+         ax8..ax0 = first finger absolute x value
+
+byte 2:
+
+   bit   7   6   5   4   3   2   1   0
+        ay7 ay6 ay5 ay4 ay3 ay2 ay1 ay0
+
+         ay8..ay0 = first finger absolute y value
+
+byte 3:
+
+   bit   7   6   5   4   3   2   1   0
+         .   .  by8 bx8  .   .   .   .
+
+byte 4:
+
+   bit   7   6   5   4   3   2   1   0
+        bx7 bx6 bx5 bx4 bx3 bx2 bx1 bx0
+
+         bx8..bx0 = second finger absolute x value
+
+byte 5:
+
+   bit   7   6   5   4   3   2   1   0
+        by7 by8 by5 by4 by3 by2 by1 by0
+
+         by8..by0 = second finger absolute y value
diff -puN drivers/input/mouse/elantech.c~elantech-touchpad-driver-update drivers/input/mouse/elantech.c
--- a/drivers/input/mouse/elantech.c~elantech-touchpad-driver-update
+++ a/drivers/input/mouse/elantech.c
@@ -1,7 +1,7 @@
 /*
- * Elantech Touchpad driver
+ * Elantech Touchpad driver (v5)
  *
- * Copyright (C) 2007 Arjan Opmeer <arjan@opmeer.net>
+ * Copyright (C) 2007-2008 Arjan Opmeer <arjan@opmeer.net>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -10,53 +10,151 @@
  * Trademarks are the property of their respective owners.
  */
 
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/input.h>
 #include <linux/serio.h>
 #include <linux/libps2.h>
 #include "psmouse.h"
-#include "synaptics.h"
 #include "elantech.h"
 
+/* Quickest way to access etd->debug in the macro below */
+static struct elantech_data *etd;
+
+#define elantech_debug(format, arg...)				\
+	do {							\
+		if (etd->debug)					\
+			printk(KERN_DEBUG format, ##arg);	\
+	} while (0)
+
+/*
+ * Send a Synaptics style sliced query command
+ */
+static int synaptics_send_cmd(struct psmouse *psmouse, unsigned char c,
+				unsigned char *param)
+{
+	if (psmouse_sliced_command(psmouse, c) ||
+	    ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO)) {
+		pr_err("elantech.c: synaptics_send_cmd query 0x%02x failed.\n", c);
+		return -1;
+	}
+
+	return 0;
+}
+
 /*
- * Native absolute mode reporting has odd parity check on the last 3 bytes.
- * Native relative mode can have odd parity checking on second and third byte,
- * or last 3 bytes depending on model.
+ * A retrying version of ps2_command
  */
-static unsigned char parity[256];
+static int elantech_ps2_command(struct ps2dev *ps2dev, unsigned char *param,
+				int command)
+{
+	int	rc;
+	int	tries = ETP_PS2_COMMAND_TRIES;
+
+	do {
+		rc = ps2_command(ps2dev, param, command);
+		if (rc == 0)
+			break;
+		tries--;
+		elantech_debug("elantech.c: retrying ps2 command 0x%02x (%d).\n",
+			command, tries);
+		msleep(ETP_PS2_COMMAND_DELAY);
+	} while (tries > 0);
+
+	if (rc)
+		pr_err("elantech.c: ps2 command 0x%02x failed.\n", command);
+
+	return rc;
+}
 
 /*
- * Send a synaptics style special commands
+ * Send an Elantech style special command to read a value from a register
  */
-static int synaptics_send_cmd(struct psmouse *psmouse, unsigned char c, unsigned char *param)
+static int elantech_read_reg(struct psmouse *psmouse, unsigned char reg,
+				unsigned char *val)
 {
-	if (psmouse_sliced_command(psmouse, c))
+	struct ps2dev		*ps2dev = &psmouse->ps2dev;
+	unsigned char		param[3];
+	int			rc = 0;
+
+	if ((reg < 0x10) || (reg > 0x26))
 		return -1;
-	if (ps2_command(&psmouse->ps2dev, param, PSMOUSE_CMD_GETINFO))
+	if ((reg > 0x11) && (reg < 0x20))
 		return -1;
-	return 0;
+
+	switch (etd->hw_version) {
+	case 1:
+		if (psmouse_sliced_command(psmouse, ETP_REGISTER_READ) ||
+		    psmouse_sliced_command(psmouse, reg) ||
+		    ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO)) {
+			rc = -1;
+		}
+		break;
+	case 2:
+		if (elantech_ps2_command(ps2dev,  NULL, ETP_PS2_CUSTOM_COMMAND) ||
+		    elantech_ps2_command(ps2dev,  NULL, ETP_REGISTER_READ) ||
+		    elantech_ps2_command(ps2dev,  NULL, ETP_PS2_CUSTOM_COMMAND) ||
+		    elantech_ps2_command(ps2dev,  NULL, reg) ||
+		    elantech_ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO)) {
+			rc = -1;
+		}
+		break;
+	}
+
+	if (rc)
+		pr_err("elantech.c: failed to read register 0x%02x.\n", reg);
+	else
+		*val = param[0];
+
+	return rc;
 }
 
 /*
  * Send an Elantech style special command to write a register with a value
  */
-static int elantech_write_reg(struct psmouse *psmouse, unsigned char reg, unsigned char val)
+static int elantech_write_reg(struct psmouse *psmouse, unsigned char reg,
+				unsigned char val)
 {
+	struct ps2dev		*ps2dev = &psmouse->ps2dev;
+	int			rc = 0;
+
 	if ((reg < 0x10) || (reg > 0x26))
 		return -1;
 	if ((reg > 0x11) && (reg < 0x20))
 		return -1;
 
-	if (psmouse_sliced_command(psmouse, ELANTECH_COMMAND_START) ||
-	    psmouse_sliced_command(psmouse, reg) ||
-	    psmouse_sliced_command(psmouse, val) ||
-	    ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_SETSCALE11)) {
-		return -1;
+	switch (etd->hw_version) {
+	case 1:
+		if (psmouse_sliced_command(psmouse, ETP_REGISTER_WRITE) ||
+		    psmouse_sliced_command(psmouse, reg) ||
+		    psmouse_sliced_command(psmouse, val) ||
+		    ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11)) {
+			rc = -1;
+		}
+		break;
+	case 2:
+		if (elantech_ps2_command(ps2dev, NULL, ETP_PS2_CUSTOM_COMMAND) ||
+		    elantech_ps2_command(ps2dev, NULL, ETP_REGISTER_WRITE) ||
+		    elantech_ps2_command(ps2dev, NULL, ETP_PS2_CUSTOM_COMMAND) ||
+		    elantech_ps2_command(ps2dev, NULL, reg) ||
+		    elantech_ps2_command(ps2dev, NULL, ETP_PS2_CUSTOM_COMMAND) ||
+		    elantech_ps2_command(ps2dev, NULL, val) ||
+		    elantech_ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11)) {
+			rc = -1;
+		}
+		break;
 	}
 
-	return 0;
+	if (rc)
+		pr_err("elantech.c: failed to write register 0x%02x with value 0x%02x.\n",
+			reg, val);
+
+	return rc;
 }
 
+/*
+ * Dump a complete mouse movement packet to the syslog
+ */
 static void elantech_packet_dump(unsigned char *packet, int size)
 {
 	int	i;
@@ -68,25 +166,33 @@ static void elantech_packet_dump(unsigne
 }
 
 /*
- * Report absolute mode input events
+ * Interpret complete data packets and report absolute mode input events for
+ * hardware version 1. (4 byte packets)
  */
-static void elantech_report_absolute(struct psmouse *psmouse)
+static void elantech_report_absolute_v1(struct psmouse *psmouse)
 {
-	struct elantech_data 	*etd = psmouse->private;
 	struct input_dev 	*dev = psmouse->dev;
 	unsigned char 		*packet = psmouse->packet;
 	int			fingers;
 
-	/* byte 0:  D   U  p1  p2   1  p3   R   L
-	 * byte 1:  f   0  th  tw  x9  x8  y9  y8
-	 * byte 2: x7  x6  x5  x4  x3  x2  x1  x0
-	 * byte 3: y7  y6  y5  y4  y3  y2  y1  y0 */
-	fingers = ((packet[1] & 0x80) >> 7) + ((packet[1] & 0x30) >> 4);
+	if (etd->fw_version_maj == 0x01) {
+		/* byte 0:  D   U  p1  p2   1  p3   R   L
+		   byte 1:  f   0  th  tw  x9  x8  y9  y8 */
+		fingers = ((packet[1] & 0x80) >> 7) +
+				((packet[1] & 0x30) >> 4);
+	} else {
+		/* byte 0: n1  n0  p2  p1   1  p3   R   L
+		   byte 1:  0   0   0   0  x9  x8  y9  y8 */
+		fingers = (packet[0] & 0xc0) >> 6;
+	}
+
 	input_report_key(dev, BTN_TOUCH, fingers != 0);
-	if (fingers == 1) {
+	/* byte 2: x7  x6  x5  x4  x3  x2  x1  x0
+	   byte 3: y7  y6  y5  y4  y3  y2  y1  y0 */
+	if (fingers) {
 		input_report_abs(dev, ABS_X,
 			((packet[1] & 0x0c) << 6) | packet[2]);
-		input_report_abs(dev, ABS_Y, ETP_YMAX -
+		input_report_abs(dev, ABS_Y, ETP_YMAX_V1 -
 			(((packet[1] & 0x03) << 8) | packet[3]));
 	}
 	input_report_abs(dev, ABS_PRESSURE, (fingers) ? ETP_DEF_PRESSURE : 0);
@@ -95,115 +201,118 @@ static void elantech_report_absolute(str
 	input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
 	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
 	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
-	if (etd->capabilities & ETP_CAP_HAS_ROCKER) {
-		input_report_key(dev, BTN_FORWARD, packet[0] & 0x40); /* rocker up */
-		input_report_key(dev, BTN_BACK, packet[0] & 0x80); /* rocker down */
+	if ((etd->fw_version_maj == 0x01) &&
+	    (etd->capabilities & ETP_CAP_HAS_ROCKER)) {
+		/* rocker up */
+		input_report_key(dev, BTN_FORWARD, packet[0] & 0x40);
+		/* rocker down */
+		input_report_key(dev, BTN_BACK, packet[0] & 0x80);
 	}
 }
 
 /*
- * Report relative mode input events
+ * Interpret complete data packets and report absolute mode input events for
+ * hardware version 2. (6 byte packets)
  */
-static void elantech_report_relative(struct psmouse *psmouse)
+static void elantech_report_absolute_v2(struct psmouse *psmouse)
 {
-	struct elantech_data 	*etd = psmouse->private;
 	struct input_dev 	*dev = psmouse->dev;
 	unsigned char 		*packet = psmouse->packet;
-	int 			fingers, cornertap;
+	int			fingers, x1, y1, x2, y2;
 
-	/* byte 0:  c   c  p2  p1   1   M   R   L
-	 * byte 1: dx7 dx6 dx5 dx4 dx3 dx2 dx1 dx0
-	 * byte 2: dy7 dy6 dy5 dy4 dy3 dy2 dy1 dy0
-	 * byte 3:  w   h  n1  n0  d3  d2  d1  d0 */
+	/* byte 0: n1  n0   .   .   .   .   R   L */
+	fingers = (packet[0] & 0xc0) >> 6;
+	input_report_key(dev, BTN_TOUCH, fingers != 0);
+	switch (fingers) {
+	case 1:
+		/* byte 1: x15 x14 x13 x12 x11 x10 x9  x8
+		   byte 2: x7  x6  x5  x4  x4  x2  x1  x0 */
+		input_report_abs(dev, ABS_X, (packet[1] << 8) | packet[2]);
+		/* byte 4: y15 y14 y13 y12 y11 y10 y8  y8
+		   byte 5: y7  y6  y5  y4  y3  y2  y1  y0 */
+		input_report_abs(dev, ABS_Y, ETP_YMAX_V2 -
+			((packet[4] << 8) | packet[5]));
+		break;
+	case 2:
+		/* The coordinate of each finger is reported separately with
+		   a lower resolution for two finger touches */
+		/* byte 0:  .   .  ay8 ax8  .   .   .   .
+		   byte 1: ax7 ax6 ax5 ax4 ax3 ax2 ax1 ax0 */
+		x1 = ((packet[0] & 0x10) << 4) | packet[1];
+		/* byte 2: ay7 ay6 ay5 ay4 ay3 ay2 ay1 ay0 */
+		y1 = ETP_2FT_YMAX - (((packet[0] & 0x20) << 3) | packet[2]);
+		/* byte 3:  .   .  by8 bx8  .   .   .   .
+		   byte 4: bx7 bx6 bx5 bx4 bx3 bx2 bx1 bx0 */
+		x2 = ((packet[3] & 0x10) << 4) | packet[4];
+		/* byte 5: by7 by8 by5 by4 by3 by2 by1 by0 */
+		y2 = ETP_2FT_YMAX - (((packet[3] & 0x20) << 3) | packet[5]);
+		/* For compatibility with the X Synaptics driver scale up one
+		   coordinate and report as ordinary mouse movent */
+		input_report_abs(dev, ABS_X, x1 << 2);
+		input_report_abs(dev, ABS_Y, y1 << 2);
+		/* For compatibility with the proprietary X Elantech driver
+		   report both coordinates as hat coordinates */
+		input_report_abs(dev, ABS_HAT0X, x1);
+		input_report_abs(dev, ABS_HAT0Y, y1);
+		input_report_abs(dev, ABS_HAT1X, x2);
+		input_report_abs(dev, ABS_HAT1Y, y2);
+		break;
+	}
+	input_report_abs(dev, ABS_PRESSURE, (fingers) ? ETP_DEF_PRESSURE : 0);
+	input_report_key(dev, BTN_TOOL_FINGER, fingers == 1);
+	input_report_key(dev, BTN_TOOL_DOUBLETAP, fingers == 2);
+	input_report_key(dev, BTN_TOOL_TRIPLETAP, fingers == 3);
 	input_report_key(dev, BTN_LEFT, packet[0] & 0x01);
 	input_report_key(dev, BTN_RIGHT, packet[0] & 0x02);
-
-	if (etd->capabilities & ETP_CAP_REPORTS_MIDDLE_BUTTON)
-		input_report_key(dev, BTN_MIDDLE, packet[0] & 0x04);
-
-	if (etd->capabilities & ETP_CAP_ALTERNATE_TAP_BITS) {
-		fingers = (packet[3] & 0x30) >> 4;
-		input_report_key(dev, BTN_LEFT, fingers == 1);
-		input_report_key(dev, BTN_MIDDLE, fingers == 2);
-		input_report_key(dev, BTN_RIGHT, fingers == 3);
-	}
-
-	cornertap = (((packet[0] & 0xc0) == 0xc0) && ((packet[1] & 0xf0) == 0xf0));
-	if (!cornertap) {
-		input_report_rel(dev, REL_X, (int) (packet[1] & 0x7f) -
-					     (int) (packet[1] & 0x80));
-		input_report_rel(dev, REL_Y, (int) (packet[2] & 0x80) -
-					     (int) (packet[2] & 0x7f));
-	}
-
-	/* No more information in 3 bytes */
-	if (!(etd->reg_11 & ETP_R11_4_BYTE_MODE))
-		return;
-
-	if (cornertap) {
-		input_report_key(dev, BTN_0, packet[3] & 0x01);	/* top right */
-		input_report_key(dev, BTN_1, packet[3] & 0x02);	/* bottom right */
-		input_report_key(dev, BTN_2, packet[3] & 0x04);	/* bottom left */
-		input_report_key(dev, BTN_3, packet[3] & 0x08);	/* top left */
-	}
-
-	if (etd->reg_11 & ETP_R11_PARITY_CHECKING) {
-		if (packet[3] & 0x0f) {
-			if (packet[3] & 0x40) {
-				input_report_rel(dev, REL_HWHEEL,
-					(int) (packet[3] & 0x08) -
-					(int) (packet[3] & 0x07));
-			} else {
-				input_report_rel(dev, REL_WHEEL,
-					(int) (packet[3] & 0x08) -
-					(int) (packet[3] & 0x07));
-			}
-		}
-	} else {
-		if (packet[3])
-			input_report_rel(dev, REL_WHEEL,
-				(int) (packet[3] & 0x80) -
-				(int) (packet[3] & 0x7f));
-	}
 }
 
 /*
- * Process byte stream from mouse and interpret complete data packets
+ * Process byte stream from mouse and handle complete packets
  */
 static psmouse_ret_t elantech_process_byte(struct psmouse *psmouse)
 {
-	struct elantech_data 	*etd = psmouse->private;
 	struct input_dev 	*dev = psmouse->dev;
 	unsigned char 		*packet = psmouse->packet;
+	unsigned char		p1, p2, p3;
 
 	if (psmouse->pktcnt < psmouse->pktsize)
 		return PSMOUSE_GOOD_DATA;
 
-	if (etd->debug)
+	if (etd->debug > 1)
 		elantech_packet_dump(packet, psmouse->pktsize);
 
-	if (etd->reg_10 & ETP_R10_ABSOLUTE_MODE) {
-		/* byte 0:  D   U  p1  p2   1  p3   R   L */
-		if ((parity[packet[1]] != ((packet[0] & 0x20) >> 5)) ||
-		    (parity[packet[2]] != ((packet[0] & 0x10) >> 4)) ||
-		    (parity[packet[3]] != ((packet[0] & 0x04) >> 2)))
-			return PSMOUSE_BAD_DATA;
-	} else if (etd->reg_11 & ETP_R11_PARITY_CHECKING) {
-		/* byte 0:  c   c  p2  p1   1   M   R   L */
-		if ((parity[packet[1]] != ((packet[0] & 0x10) >> 4)) ||
-		    (parity[packet[2]] != ((packet[0] & 0x20) >> 5)))
-			return PSMOUSE_BAD_DATA;
-		/* Parity bit has not been sacrificed as middle mouse button bit */
-		if (!(etd->capabilities & ETP_CAP_REPORTS_MIDDLE_BUTTON)) {
-			if (parity[packet[3]] != ((packet[0] & 0x04) >> 2))
+	if (etd->paritycheck) {
+		switch (etd->hw_version) {
+		case 1:
+			/* Parity bits are placed differently */
+			if (etd->fw_version_maj == 0x01) {
+				/* byte 0:  D   U  p1  p2   1  p3   R   L */
+				p1 = (packet[0] & 0x20) >> 5;
+				p2 = (packet[0] & 0x10) >> 4;
+			} else {
+				/* byte 0: n1  n0  p2  p1   1  p3   R   L */
+				p1 = (packet[0] & 0x10) >> 4;
+				p2 = (packet[0] & 0x20) >> 5;
+			}
+			p3 = (packet[0] & 0x04) >> 2;
+			if ((etd->parity[packet[1]] != p1) ||
+			    (etd->parity[packet[2]] != p2) ||
+			    (etd->parity[packet[3]] != p3))
 				return PSMOUSE_BAD_DATA;
+			break;
+		case 2:
+			/* Does version 2 hardware have parity bits? */
+			break;
 		}
 	}
 
-	if (etd->reg_10 & ETP_R10_ABSOLUTE_MODE) {
-		elantech_report_absolute(psmouse);
-	} else {
-		elantech_report_relative(psmouse);
+	switch (etd->hw_version) {
+	case 1:
+		elantech_report_absolute_v1(psmouse);
+		break;
+	case 2:
+		elantech_report_absolute_v2(psmouse);
+		break;
 	}
 
 	input_sync(dev);
@@ -212,54 +321,69 @@ static psmouse_ret_t elantech_process_by
 }
 
 /*
- * Initialise the touchpad to a default state. Because we don't know (yet)
- * how to read registers we need to write some default values so we can
- * report their contents when asked to.
+ * Put the touchpad into absolute mode
  */
-static void elantech_set_defaults(struct psmouse *psmouse)
+static int elantech_set_absolute_mode(struct psmouse *psmouse)
 {
-	struct elantech_data 	*etd = psmouse->private;
-	struct input_dev 	*dev = psmouse->dev;
+	int		rc = 0;
+	unsigned char	val;
+	int		tries = ETP_READ_BACK_TRIES;
+
+	switch (etd->hw_version) {
+	case 1:
+		etd->reg_10 = 0x16;
+		etd->reg_11 = 0x8f;
+		if (elantech_write_reg(psmouse, 0x10, etd->reg_10) ||
+		    elantech_write_reg(psmouse, 0x11, etd->reg_11)) {
+			rc = -1;
+		}
+		break;
+	case 2:
+					/* Windows driver values */
+		etd->reg_10 = 0x54;
+		etd->reg_11 = 0x88;	/* 0x8a */
+		etd->reg_21 = 0x60;	/* 0x00 */
+		if (elantech_write_reg(psmouse, 0x10, etd->reg_10) ||
+		    elantech_write_reg(psmouse, 0x11, etd->reg_11) ||
+		    elantech_write_reg(psmouse, 0x21, etd->reg_21)) {
+			rc = -1;
+			break;
+		}
+		/*
+		 * Read back reg 0x10. The touchpad is probably initalising
+		 * and not ready until we read back the value we just wrote.
+		 */
+		do {
+			rc = elantech_read_reg(psmouse, 0x10, &val);
+			if (rc == 0)
+				break;
+			tries--;
+			elantech_debug("elantech.c: retrying read (%d).\n",
+				tries);
+			msleep(ETP_READ_BACK_DELAY);
+		} while (tries > 0);
+		if (rc)
+			pr_err("elantech.c: failed to read back register 0x10.\n");
+		break;
+	}
+
+	if (rc)
+		pr_err("elantech.c: failed to initialise registers.\n");
 
-	/*
-	 * For now, use the Elantech Windows driver default values
-	 */
-	etd->reg_10 = 0x12;
-	elantech_write_reg(psmouse, 0x10, etd->reg_10);
-	etd->reg_11 = 0x8f;
-	elantech_write_reg(psmouse, 0x11, etd->reg_11);
-	etd->reg_20 = 0x0a;
-	elantech_write_reg(psmouse, 0x20, etd->reg_20);
-	etd->reg_21 = 0x60;
-	elantech_write_reg(psmouse, 0x21, etd->reg_21);
-	etd->reg_22 = 0xff;
-	elantech_write_reg(psmouse, 0x22, etd->reg_22);
-	/*
-	 * However, the Windows driver mentions registers 23, 24 and 26
-	 * but seems to never actually write them
-	 */
-	etd->reg_23 = 0x10;
-	/*
-	 * elantech_write_reg(psmouse, 0x23, etd->reg_23);
-	 */
-	etd->reg_24 = 0x10;
-	/*
-	 * elantech_write_reg(psmouse, 0x24, etd->reg_24);
-	 */
-	etd->reg_25 = 0x03;
-	elantech_write_reg(psmouse, 0x25, etd->reg_25);
-	/*
-	 * The Windows driver default value of 0x00 seems wrong as it
-	 * disables smart edge cursor movement
-	 */
-	etd->reg_26 = 0x00;
-	/*
-	 * elantech_write_reg(psmouse, 0x26, etd->reg_26);
-	 */
+	return rc;
+}
+
+/*
+ * Set the appropriate event bits for the input subsystem
+ */
+static void elantech_set_input_params(struct psmouse *psmouse)
+{
+	struct input_dev 	*dev = psmouse->dev;
 
 	set_bit(EV_KEY, dev->evbit);
+	set_bit(EV_ABS, dev->evbit);
+
 	set_bit(BTN_LEFT, dev->keybit);
-	set_bit(BTN_MIDDLE, dev->keybit);
 	set_bit(BTN_RIGHT, dev->keybit);
 
 	set_bit(BTN_TOUCH, dev->keybit);
@@ -267,27 +391,26 @@ static void elantech_set_defaults(struct
 	set_bit(BTN_TOOL_DOUBLETAP, dev->keybit);
 	set_bit(BTN_TOOL_TRIPLETAP, dev->keybit);
 
-	/* Rocker button */
-	if (etd->capabilities & ETP_CAP_HAS_ROCKER) {
-		set_bit(BTN_FORWARD, dev->keybit);
-		set_bit(BTN_BACK, dev->keybit);
-	}
-
-	/* Corner taps */
-	set_bit(BTN_0, dev->keybit);
-	set_bit(BTN_1, dev->keybit);
-	set_bit(BTN_2, dev->keybit);
-	set_bit(BTN_3, dev->keybit);
-
-	set_bit(EV_REL, dev->evbit);
-	set_bit(REL_X, dev->relbit);
-	set_bit(REL_Y, dev->relbit);
-	set_bit(REL_WHEEL, dev->relbit);
-	set_bit(REL_HWHEEL, dev->relbit);
+	switch (etd->hw_version) {
+	case 1:
+		/* Rocker button */
+		if ((etd->fw_version_maj == 0x01) &&
+		    (etd->capabilities & ETP_CAP_HAS_ROCKER)) {
+			set_bit(BTN_FORWARD, dev->keybit);
+			set_bit(BTN_BACK, dev->keybit);
+		}
+		input_set_abs_params(dev, ABS_X, ETP_XMIN_V1, ETP_XMAX_V1, 0, 0);
+		input_set_abs_params(dev, ABS_Y, ETP_YMIN_V1, ETP_YMAX_V1, 0, 0);
+		break;
+	case 2:
+		input_set_abs_params(dev, ABS_X, ETP_XMIN_V2, ETP_XMAX_V2, 0, 0);
+		input_set_abs_params(dev, ABS_Y, ETP_YMIN_V2, ETP_YMAX_V2, 0, 0);
+		input_set_abs_params(dev, ABS_HAT0X, ETP_2FT_XMIN, ETP_2FT_XMAX, 0, 0);
+		input_set_abs_params(dev, ABS_HAT0Y, ETP_2FT_YMIN, ETP_2FT_YMAX, 0, 0);
+		input_set_abs_params(dev, ABS_HAT1X, ETP_2FT_XMIN, ETP_2FT_XMAX, 0, 0);
+		input_set_abs_params(dev, ABS_HAT1Y, ETP_2FT_YMIN, ETP_2FT_YMAX, 0, 0);
+	}
 
-	set_bit(EV_ABS, dev->evbit);
-	input_set_abs_params(dev, ABS_X, ETP_XMIN, ETP_XMAX, 0, 0);
-	input_set_abs_params(dev, ABS_Y, ETP_YMIN, ETP_YMAX, 0, 0);
 	input_set_abs_params(dev, ABS_PRESSURE, 0, ETP_MAX_PRESSURE, 0, 0);
 }
 
@@ -299,14 +422,19 @@ struct elantech_attr_data {
 /*
  * Display a register value by reading a sysfs entry
  */
-static ssize_t elantech_show_int_attr(struct psmouse *psmouse, void *data, char *buf)
+static ssize_t elantech_show_int_attr(struct psmouse *psmouse, void *data,
+					char *buf)
 {
 	struct elantech_data		*etd = psmouse->private;
 	struct elantech_attr_data	*attr = data;
 	unsigned char			*reg = (unsigned char *)
 						etd + attr->field_offset;
+	int				rc = 0;
 
-	return sprintf(buf, "0x%02x\n", *reg);
+	if (attr->reg)
+		rc = elantech_read_reg(psmouse, attr->reg, reg);
+
+	return sprintf(buf, "0x%02x\n", (attr->reg && rc) ? -1 : *reg);
 }
 
 /*
@@ -315,40 +443,34 @@ static ssize_t elantech_show_int_attr(st
 static ssize_t elantech_set_int_attr(struct psmouse *psmouse, void *data,
 						const char *buf, size_t count)
 {
-	struct elantech_data 		*etd = psmouse->private;
-	struct elantech_attr_data 	*attr = data;
+	struct elantech_attr_data	*attr = data;
 	unsigned char 			*reg = (unsigned char *)
 						etd + attr->field_offset;
 	unsigned long			value;
-	char				*rest;
+	int				err;
 
-	value = simple_strtoul(buf, &rest, 16);
-	if (*rest || value > 255)
+	err = strict_strtoul(buf, 16, &value);
+	if (err)
+		return err;
+	if (value > 0xff)
 		return -EINVAL;
 
-	if (attr->reg == 0x10) {
-		/* Force on 4 byte mode when absolute mode gets selected */
-		if ((value & ETP_R10_ABSOLUTE_MODE) &&
-		   !(etd->reg_11 & ETP_R11_4_BYTE_MODE)) {
-			etd->reg_11 |= ETP_R11_4_BYTE_MODE;
-			elantech_write_reg(psmouse, 0x11, etd->reg_11);
-			psmouse->pktsize = 4;
-		}
-	} else if (attr->reg == 0x11) {
-		if (value & ETP_R11_4_BYTE_MODE)
-			psmouse->pktsize = 4;
-		else {
-			/* Force off absolute mode when 4 byte mode is no longer selected */
-			if (etd->reg_10 & ETP_R10_ABSOLUTE_MODE) {
-				etd->reg_10 ^= ETP_R10_ABSOLUTE_MODE;
-				elantech_write_reg(psmouse, 0x10, etd->reg_10);
-			}
-			psmouse->pktsize = 3;
-		}
+	/* Do we need to preserve some bits for version 2 hardware too? */
+	if (etd->hw_version == 1) {
+		if (attr->reg == 0x10)
+			/* Force absolute mode always on */
+			value |= ETP_R10_ABSOLUTE_MODE;
+		else if (attr->reg == 0x11)
+			/* Force 4 byte mode always on */
+			value |= ETP_R11_4_BYTE_MODE;
 	}
 
-	*reg = value;
-	elantech_write_reg(psmouse, attr->reg, value);
+	if (attr->reg) {
+		if (elantech_write_reg(psmouse, attr->reg, value) == 0)
+			*reg = value;
+	} else {
+		*reg = value;
+	}
 
 	return count;
 }
@@ -373,6 +495,7 @@ ELANTECH_INT_ATTR(reg_24, 0x24);
 ELANTECH_INT_ATTR(reg_25, 0x25);
 ELANTECH_INT_ATTR(reg_26, 0x26);
 ELANTECH_INT_ATTR(debug, 0);
+ELANTECH_INT_ATTR(paritycheck, 0);
 
 static struct attribute *elantech_attrs[] = {
 	&psmouse_attr_reg_10.dattr.attr,
@@ -385,6 +508,7 @@ static struct attribute *elantech_attrs[
 	&psmouse_attr_reg_25.dattr.attr,
 	&psmouse_attr_reg_26.dattr.attr,
 	&psmouse_attr_debug.dattr.attr,
+	&psmouse_attr_paritycheck.dattr.attr,
 	NULL
 };
 
@@ -393,17 +517,6 @@ static struct attribute_group elantech_a
 };
 
 /*
- * Clean up sysfs entries when disconnecting
- */
-static void elantech_disconnect(struct psmouse *psmouse)
-{
-	sysfs_remove_group(&psmouse->ps2dev.serio->dev.kobj,
-				&elantech_attr_group);
-	kfree(psmouse->private);
-	psmouse->private = NULL;
-}
-
-/*
  * Use magic knock to detect Elantech touchpad
  */
 int elantech_detect(struct psmouse *psmouse, int set_properties)
@@ -411,12 +524,19 @@ int elantech_detect(struct psmouse *psmo
 	struct ps2dev	*ps2dev = &psmouse->ps2dev;
 	unsigned char	param[3];
 
-	ps2_command(ps2dev,  NULL, PSMOUSE_CMD_DISABLE);
-	ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11);
-	ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11);
-	ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11);
-	ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO);
+	if (ps2_command(ps2dev,  NULL, PSMOUSE_CMD_DISABLE) ||
+	    ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11) ||
+	    ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11) ||
+	    ps2_command(ps2dev,  NULL, PSMOUSE_CMD_SETSCALE11) ||
+	    ps2_command(ps2dev, param, PSMOUSE_CMD_GETINFO)) {
+		pr_err("elantech.c: sending Elantech magic knock failed.\n");
+		return -1;
+	}
 
+	/*
+	 * Report this in case there are Elantech models that use a different
+	 * set of magic numbers
+	 */
 	if ((param[0] != 0x3c) || (param[1] != 0x03) || (param[2] != 0xc8)) {
 		pr_info("elantech.c: unexpected magic knock result 0x%02x, 0x%02x, 0x%02x.\n",
 			param[0], param[1], param[2]);
@@ -432,54 +552,111 @@ int elantech_detect(struct psmouse *psmo
 }
 
 /*
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
+ * Put the touchpad back into absolute mode when reconnecting
+ */
+static int elantech_reconnect(struct psmouse *psmouse)
+{
+	if (elantech_detect(psmouse, 0))
+		return -1;
+
+	if (elantech_set_absolute_mode(psmouse)) {
+		pr_err("elantech.c: failed to put touchpad back into absolute mode.\n");
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
  * Initialize the touchpad and create sysfs entries
  */
 int elantech_init(struct psmouse *psmouse)
 {
-	struct elantech_data 	*etd;
-	int			i, error;
-	unsigned char		param[3];
+	int		i, error;
+	unsigned char	param[3];
 
 	etd = kzalloc(sizeof(struct elantech_data), GFP_KERNEL);
 	psmouse->private = etd;
 	if (!etd)
 		return -1;
 
-	parity[0] = 1;
+	etd->parity[0] = 1;
 	for (i = 1; i < 256; i++)
-		parity[i] = (parity[i & (i - 1)] ^ 1);
+		etd->parity[i] = (etd->parity[i & (i - 1)] ^ 1);
 
 	/*
-	 * Why does the Elantech Windows driver try this?
-	 * For now just report it and see if it makes sense
-	 * when more people use this driver
+	 * Find out what version hardware this is
 	 */
-	if (!synaptics_send_cmd(psmouse, SYN_QUE_IDENTIFY, param))
-		pr_info("elantech.c: Synaptics identify query result 0x%02x, 0x%02x, 0x%02x.\n",
-			param[0], param[1], param[2]);
-	if (!synaptics_send_cmd(psmouse, SYN_QUE_MODES, param))
-		pr_info("elantech.c: Synaptics modes query result 0x%02x, 0x%02x, 0x%02x.\n",
-			param[0], param[1], param[2]);
-	if (!synaptics_send_cmd(psmouse, SYN_QUE_CAPABILITIES, param)) {
-		pr_info("elantech.c: Synaptics capabilities query result 0x%02x, 0x%02x, 0x%02x.\n",
-			param[0], param[1], param[2]);
-		etd->capabilities = param[0];
+	if (synaptics_send_cmd(psmouse, ETP_FW_VERSION_QUERY, param)) {
+		pr_err("elantech.c: failed to query firmware version.\n");
+		goto init_fail;
+	}
+	pr_info("elantech.c: Elantech version query result 0x%02x, 0x%02x, 0x%02x.\n",
+		param[0], param[1], param[2]);
+	etd->fw_version_maj = param[0];
+	etd->fw_version_min = param[2];
+
+	/*
+	 * Assume every version greater than this is new EeePC style
+	 * hardware with 6 byte packets
+	 */
+	if ((etd->fw_version_maj >= 0x02) && (etd->fw_version_min >= 0x30)) {
+		etd->hw_version = 2;
+		/* For now show extra debug information */
+		etd->debug = 1;
+		/* Don't know how to do parity checking for version 2 */
+		etd->paritycheck = 0;
+	} else {
+		etd->hw_version = 1;
+		etd->paritycheck = 1;
 	}
+	pr_info("elantech.c: assuming hardware version %d, firmware version %d.%d\n",
+		etd->hw_version, etd->fw_version_maj, etd->fw_version_min);
 
-	elantech_set_defaults(psmouse);
+	if (synaptics_send_cmd(psmouse, ETP_CAPABILITIES_QUERY, param)) {
+		pr_err("elantech.c: failed to query capabilities.\n");
+		goto init_fail;
+	}
+	pr_info("elantech.c: Synaptics capabilities query result 0x%02x, 0x%02x, 0x%02x.\n",
+		param[0], param[1], param[2]);
+	etd->capabilities = param[0];
 
-	psmouse->protocol_handler = elantech_process_byte;
-	psmouse->disconnect = elantech_disconnect;
-	psmouse->pktsize = 4;
+	if (elantech_set_absolute_mode(psmouse)) {
+		pr_err("elantech.c: failed to put touchpad into absolute mode.\n");
+		goto init_fail;
+	}
+	elantech_set_input_params(psmouse);
 
 	error = sysfs_create_group(&psmouse->ps2dev.serio->dev.kobj,
 					&elantech_attr_group);
 	if (error) {
-		printk(KERN_ERR "elantech.c: failed to create sysfs attributes, error: %d\n",
+		pr_err("elantech.c: failed to create sysfs attributes, error: %d.\n",
 			error);
-		kfree(etd);
-		return -1;
+		goto init_fail;
 	}
 
+	psmouse->protocol_handler = elantech_process_byte;
+	psmouse->disconnect = elantech_disconnect;
+	psmouse->reconnect = elantech_reconnect;
+	if (etd->hw_version == 2)
+		psmouse->pktsize = 6;
+	else
+		psmouse->pktsize = 4;
+
 	return 0;
+
+init_fail:
+	kfree(etd);
+	return -1;
 }
diff -puN drivers/input/mouse/elantech.h~elantech-touchpad-driver-update drivers/input/mouse/elantech.h
--- a/drivers/input/mouse/elantech.h~elantech-touchpad-driver-update
+++ a/drivers/input/mouse/elantech.h
@@ -1,7 +1,7 @@
 /*
- * Elantech Touchpad driver
+ * Elantech Touchpad driver (v5)
  *
- * Copyright (C) 2007 Arjan Opmeer <arjan@opmeer.net>
+ * Copyright (C) 2007-2008 Arjan Opmeer <arjan@opmeer.net>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2 as published
@@ -14,42 +14,86 @@
 #define _ELANTECH_H
 
 /*
- * Commands start with this value
+ * Command values for Synaptics style queries
  */
-#define ELANTECH_COMMAND_START		0x11
+#define ETP_FW_VERSION_QUERY		0x01
+#define ETP_CAPABILITIES_QUERY		0x02
 
 /*
- * Register bitmasks
+ * Command values for register reading or writing
+ */
+#define ETP_REGISTER_READ		0x10
+#define ETP_REGISTER_WRITE		0x11
+
+/*
+ * Hardware version 2 custom PS/2 command value
+ */
+#define ETP_PS2_CUSTOM_COMMAND		0xf8
+
+/*
+ * Times to retry a ps2_command and millisecond delay between tries
+ */
+#define ETP_PS2_COMMAND_TRIES		3
+#define ETP_PS2_COMMAND_DELAY		500
+
+/*
+ * Times to try to read back a register and millisecond delay between tries
+ */
+#define ETP_READ_BACK_TRIES		5
+#define ETP_READ_BACK_DELAY		2000
+
+/*
+ * Register bitmasks for hardware version 1
  */
 #define ETP_R10_ABSOLUTE_MODE		0x04
-#define ETP_R11_PARITY_CHECKING		0x01
 #define ETP_R11_4_BYTE_MODE 		0x02
 
 /*
  * Capability bitmasks
  */
-#define ETP_CAP_REPORTS_MIDDLE_BUTTON	0x02
 #define ETP_CAP_HAS_ROCKER		0x04
-#define ETP_CAP_ALTERNATE_TAP_BITS	0x10
 
 /*
  * One hard to find application note states that X axis range is 0 to 576
- * and Y axis range is 0 to 384.
- * Edge fuzz might be necessary because of bezel around the touchpad.
+ * and Y axis range is 0 to 384 for harware version 1.
+ * Edge fuzz might be necessary because of bezel around the touchpad
+ */
+#define ETP_EDGE_FUZZ_V1		32
+
+#define ETP_XMIN_V1 			(  0 + ETP_EDGE_FUZZ_V1)
+#define ETP_XMAX_V1 			(576 - ETP_EDGE_FUZZ_V1)
+#define ETP_YMIN_V1 			(  0 + ETP_EDGE_FUZZ_V1)
+#define ETP_YMAX_V1 			(384 - ETP_EDGE_FUZZ_V1)
+
+/*
+ * It seems the resolution for hardware version 2 doubled.
+ * Hence the X and Y ranges are doubled too.
+ * The bezel around the pad also appears to be smaller
+ */
+#define ETP_EDGE_FUZZ_V2		8
+
+#define ETP_XMIN_V2 			(   0 + ETP_EDGE_FUZZ_V2)
+#define ETP_XMAX_V2 			(1152 - ETP_EDGE_FUZZ_V2)
+#define ETP_YMIN_V2 			(   0 + ETP_EDGE_FUZZ_V2)
+#define ETP_YMAX_V2 			( 768 - ETP_EDGE_FUZZ_V2)
+
+/*
+ * For two finger touches the coordinate of each finger gets reported
+ * separately but with reduced resolution.
  */
-#define ETP_EDGE_FUZZ			32
+#define ETP_2FT_FUZZ			4
 
-#define ETP_XMIN 			(  0 + ETP_EDGE_FUZZ)
-#define ETP_XMAX 			(576 - ETP_EDGE_FUZZ)
-#define ETP_YMIN 			(  0 + ETP_EDGE_FUZZ)
-#define ETP_YMAX 			(384 - ETP_EDGE_FUZZ)
+#define ETP_2FT_XMIN			(  0 + ETP_2FT_FUZZ)
+#define ETP_2FT_XMAX			(288 - ETP_2FT_FUZZ)
+#define ETP_2FT_YMIN			(  0 + ETP_2FT_FUZZ)
+#define ETP_2FT_YMAX			(192 - ETP_2FT_FUZZ)
 
 /*
  * It seems the touchpad does not report pressure.
  * Just choose some values for compatibility with X Synaptics driver
  */
-#define ETP_MAX_PRESSURE		127
-#define ETP_DEF_PRESSURE		64
+#define ETP_MAX_PRESSURE		255
+#define ETP_DEF_PRESSURE		128
 
 struct elantech_data {
 	unsigned char reg_10;
@@ -63,6 +107,11 @@ struct elantech_data {
 	unsigned char reg_26;
 	unsigned char debug;
 	unsigned char capabilities;
+	unsigned char fw_version_maj;
+	unsigned char fw_version_min;
+	unsigned char hw_version;
+	unsigned char paritycheck;
+	unsigned char parity[256];
 };
 
 #ifdef CONFIG_MOUSE_PS2_ELANTECH
diff -puN drivers/input/mouse/psmouse-base.c~elantech-touchpad-driver-update drivers/input/mouse/psmouse-base.c
--- a/drivers/input/mouse/psmouse-base.c~elantech-touchpad-driver-update
+++ a/drivers/input/mouse/psmouse-base.c
@@ -770,6 +770,12 @@ static const struct psmouse_protocol psm
 		.detect		= touchkit_ps2_detect,
 	},
 #endif
+	{
+		.type		= PSMOUSE_CORTRON,
+		.name		= "CortronPS/2",
+		.alias		= "cortps",
+		.detect		= cortron_detect,
+	},
 #ifdef CONFIG_MOUSE_PS2_ELANTECH
 	{
 		.type		= PSMOUSE_ELANTECH,
@@ -780,12 +786,6 @@ static const struct psmouse_protocol psm
 	},
 #endif
 	{
-		.type		= PSMOUSE_CORTRON,
-		.name		= "CortronPS/2",
-		.alias		= "cortps",
-		.detect		= cortron_detect,
-	},
-	{
 		.type		= PSMOUSE_AUTO,
 		.name		= "auto",
 		.alias		= "any",
_

Patches currently in -mm which might be from arjan@opmeer.net are

elantech-touchpad-driver.patch
elantech-touchpad-driver-update.patch

