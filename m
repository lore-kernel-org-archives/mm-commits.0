From: akpm@linux-foundation.org
Subject: [merged] input-elantechc-provide-a-workaround-for-jumpy-cursor-on-firmware-234.patch removed from -mm tree
Date: Mon, 20 Apr 2009 11:35:24 -0700
Message-ID: <200904201835.n3KIZO3k012321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754659AbZDTSiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Apr 2009 14:38:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@opmeer.net, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: elantech.c provide a workaround for jumpy cursor on firmwar=
e 2.34
has been removed from the -mm tree.  Its filename was
     input-elantechc-provide-a-workaround-for-jumpy-cursor-on-firmware-=
234.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: input: elantech.c provide a workaround for jumpy cursor on fir=
mware 2.34
=46rom: Arjan Opmeer <arjan@opmeer.net>

It seems that Elantech touchpad firmware version 2.34 on the Hercules
eCAF=C9 suffers from a problem where bogus coordinates get reported at =
the
beginning of a touch action.  This causes the mouse cursor or the scrol=
led
page to jump.

Included patch provides a workaround, enabled by default for firmware
version 2.34, that discards mouse packets that are likely to contain bo=
gus
coordinates.  To allow users of other firmware versions, that may also =
see
this problem, to experiment the workaround can be enabled and disabled =
via
a sysfs entry.

Signed-off-by: Arjan Opmeer <arjan@opmeer.net>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/input/elantech.txt |   20 +++++++++++++++++---
 drivers/input/mouse/elantech.c   |   29 +++++++++++++++++++++++++++--
 drivers/input/mouse/elantech.h   |    5 +++--
 3 files changed, 47 insertions(+), 7 deletions(-)

diff -puN Documentation/input/elantech.txt~input-elantechc-provide-a-wo=
rkaround-for-jumpy-cursor-on-firmware-234 Documentation/input/elantech.=
txt
--- a/Documentation/input/elantech.txt~input-elantechc-provide-a-workar=
ound-for-jumpy-cursor-on-firmware-234
+++ a/Documentation/input/elantech.txt
@@ -1,7 +1,7 @@
 Elantech Touchpad Driver
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
-	Copyright (C) 2007-2008 Arjan Opmeer <arjan@opmeer.net>
+	Copyright (C) 2007-2009 Arjan Opmeer <arjan@opmeer.net>
=20
 	Extra information for hardware version 1 found and
 	provided by Steve Havelka
@@ -64,8 +64,8 @@ completeness sake.
 2. Extra knobs
    ~~~~~~~~~~~
=20
-Currently the Linux Elantech touchpad driver provides two extra knobs =
under
-/sys/bus/serio/drivers/psmouse/serio? for the user.
+Currently the Linux Elantech touchpad driver provides three extra knob=
s
+under /sys/bus/serio/drivers/psmouse/serio? for the user.
=20
 * debug
=20
@@ -98,6 +98,20 @@ Currently the Linux Elantech touchpad dr
    bits. Hence checking is disabled by default. Currently even turning=
 it on
    will do nothing.
=20
+* jumpy_cursor
+
+   Turns a workaround for jumpy mouse cursor ON or OFF.
+
+   By echo "0" to to this file the workaround will be turned OFF. Any
+   non-zero value will turn it ON. For firmware version 2.34 the defau=
lt is
+   ON.
+
+   Firmware version 2.34 seems to suffer from a problem where in the
+   starting phase of a touch action bogus coordinates are reported. Th=
is
+   causes the mouse cursor or the scrolled page to jump. This knob ena=
bles a
+   workaround that discards mouse packets likely to contain bogus
+   coordinates.
+
=20
 //////////////////////////////////////////////////////////////////////=
///////
=20
diff -puN drivers/input/mouse/elantech.c~input-elantechc-provide-a-work=
around-for-jumpy-cursor-on-firmware-234 drivers/input/mouse/elantech.c
--- a/drivers/input/mouse/elantech.c~input-elantechc-provide-a-workarou=
nd-for-jumpy-cursor-on-firmware-234
+++ a/drivers/input/mouse/elantech.c
@@ -1,7 +1,7 @@
 /*
- * Elantech Touchpad driver (v5)
+ * Elantech Touchpad driver (v6)
  *
- * Copyright (C) 2007-2008 Arjan Opmeer <arjan@opmeer.net>
+ * Copyright (C) 2007-2009 Arjan Opmeer <arjan@opmeer.net>
  *
  * This program is free software; you can redistribute it and/or modif=
y it
  * under the terms of the GNU General Public License version 2 as publ=
ished
@@ -178,6 +178,7 @@ static void elantech_report_absolute_v1(
 	struct elantech_data *etd =3D psmouse->private;
 	unsigned char *packet =3D psmouse->packet;
 	int fingers;
+	static int old_fingers;
=20
 	if (etd->fw_version_maj =3D=3D 0x01) {
 		/* byte 0:  D   U  p1  p2   1  p3   R   L
@@ -190,6 +191,14 @@ static void elantech_report_absolute_v1(
 		fingers =3D (packet[0] & 0xc0) >> 6;
 	}
=20
+	if (etd->jumpy_cursor) {
+		/* Discard packets that are likely to have bogus coordinates */
+		if (fingers > old_fingers) {
+			elantech_debug("elantech.c: discarding packet\n");
+			goto discard_packet_v1;
+		}
+	}
+
 	input_report_key(dev, BTN_TOUCH, fingers !=3D 0);
=20
 	/* byte 2: x7  x6  x5  x4  x3  x2  x1  x0
@@ -216,6 +225,9 @@ static void elantech_report_absolute_v1(
 	}
=20
 	input_sync(dev);
+
+ discard_packet_v1:
+	old_fingers =3D fingers;
 }
=20
 /*
@@ -507,6 +519,7 @@ ELANTECH_INT_ATTR(reg_25, 0x25);
 ELANTECH_INT_ATTR(reg_26, 0x26);
 ELANTECH_INT_ATTR(debug, 0);
 ELANTECH_INT_ATTR(paritycheck, 0);
+ELANTECH_INT_ATTR(jumpy_cursor, 0);
=20
 static struct attribute *elantech_attrs[] =3D {
 	&psmouse_attr_reg_10.dattr.attr,
@@ -520,6 +533,7 @@ static struct attribute *elantech_attrs[
 	&psmouse_attr_reg_26.dattr.attr,
 	&psmouse_attr_debug.dattr.attr,
 	&psmouse_attr_paritycheck.dattr.attr,
+	&psmouse_attr_jumpy_cursor.dattr.attr,
 	NULL
 };
=20
@@ -662,6 +676,17 @@ int elantech_init(struct psmouse *psmous
 		param[0], param[1], param[2]);
 	etd->capabilities =3D param[0];
=20
+	/*
+	 * This firmware seems to suffer from misreporting coordinates when
+	 * a touch action starts causing the mouse cursor or scrolled page
+	 * to jump. Enable a workaround.
+	 */
+	if (etd->fw_version_maj =3D=3D 0x02 && etd->fw_version_min =3D=3D 0x2=
2) {
+		pr_info("elantech.c: firmware version 2.34 detected, "
+			"enabling jumpy cursor workaround\n");
+		etd->jumpy_cursor =3D 1;
+	}
+
 	if (elantech_set_absolute_mode(psmouse)) {
 		pr_err("elantech.c: failed to put touchpad into absolute mode.\n");
 		goto init_fail;
diff -puN drivers/input/mouse/elantech.h~input-elantechc-provide-a-work=
around-for-jumpy-cursor-on-firmware-234 drivers/input/mouse/elantech.h
--- a/drivers/input/mouse/elantech.h~input-elantechc-provide-a-workarou=
nd-for-jumpy-cursor-on-firmware-234
+++ a/drivers/input/mouse/elantech.h
@@ -1,7 +1,7 @@
 /*
- * Elantech Touchpad driver (v5)
+ * Elantech Touchpad driver (v6)
  *
- * Copyright (C) 2007-2008 Arjan Opmeer <arjan@opmeer.net>
+ * Copyright (C) 2007-2009 Arjan Opmeer <arjan@opmeer.net>
  *
  * This program is free software; you can redistribute it and/or modif=
y it
  * under the terms of the GNU General Public License version 2 as publ=
ished
@@ -104,6 +104,7 @@ struct elantech_data {
 	unsigned char fw_version_min;
 	unsigned char hw_version;
 	unsigned char paritycheck;
+	unsigned char jumpy_cursor;
 	unsigned char parity[256];
 };
=20
_

Patches currently in -mm which might be from arjan@opmeer.net are

linux-next.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
