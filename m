From: akpm@linux-foundation.org
Subject: + sigma-firmware-loader-for-analog-devices-sigmastudio-v2.patch added to -mm tree
Date: Thu, 20 Jan 2011 16:11:45 -0800
Message-ID: <201101210011.p0L0BjHM010822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752121Ab1AUAMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Jan 2011 19:12:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     sigma-firmware-loader-for-analog-devices-sigmastudio-v2
has been added to the -mm tree.  Its filename is
     sigma-firmware-loader-for-analog-devices-sigmastudio-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: sigma-firmware-loader-for-analog-devices-sigmastudio-v2
=46rom: Mike Frysinger <vapier@gentoo.org>

address feedback from Andrew

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/sigma.c |   67 +++++++++++++++++++------------------
 include/linux/sigma.h    |   10 ++---
 2 files changed, 41 insertions(+), 36 deletions(-)

diff -puN drivers/firmware/sigma.c~sigma-firmware-loader-for-analog-dev=
ices-sigmastudio-v2 drivers/firmware/sigma.c
--- a/drivers/firmware/sigma.c~sigma-firmware-loader-for-analog-devices=
-sigmastudio-v2
+++ a/drivers/firmware/sigma.c
@@ -1,9 +1,9 @@
 /*
  * Load Analog Devices SigmaStudio firmware files
  *
-=C2=A0* Copyright 2009 Analog Devices Inc.
-=C2=A0*
-=C2=A0* Licensed under the GPL-2 or later.
+ * Copyright 2009-2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
  */
=20
 #include <linux/crc32.h>
@@ -14,7 +14,8 @@
 #include <linux/sigma.h>
=20
 /* Return: 0=3D=3DOK, <0=3D=3Derror, =3D1 =3D=3Dno more actions */
-int process_sigma_action(struct i2c_client *client, struct sigma_firmw=
are *ssfw)
+static int
+process_sigma_action(struct i2c_client *client, struct sigma_firmware =
*ssfw)
 {
 	struct sigma_action *sa =3D (void *)(ssfw->fw->data + ssfw->pos);
 	size_t len =3D sigma_action_len(sa);
@@ -24,27 +25,27 @@ int process_sigma_action(struct i2c_clie
 		sa->instr, sa->addr, len);
=20
 	switch (sa->instr) {
-		case SIGMA_ACTION_WRITEXBYTES:
-		case SIGMA_ACTION_WRITESINGLE:
-		case SIGMA_ACTION_WRITESAFELOAD:
-			if (ssfw->fw->size < ssfw->pos + len)
-				return -EINVAL;
-			ret =3D i2c_master_send(client, (void *)&sa->addr, len);
-			if (ret < 0)
-				return -EINVAL;
-			break;
-
-		case SIGMA_ACTION_DELAY:
-			ret =3D 0;
-			udelay(len);
-			len =3D 0;
-			break;
+	case SIGMA_ACTION_WRITEXBYTES:
+	case SIGMA_ACTION_WRITESINGLE:
+	case SIGMA_ACTION_WRITESAFELOAD:
+		if (ssfw->fw->size < ssfw->pos + len)
+			return -EINVAL;
+		ret =3D i2c_master_send(client, (void *)&sa->addr, len);
+		if (ret < 0)
+			return -EINVAL;
+		break;
=20
-		case SIGMA_ACTION_END:
-			return 1;
+	case SIGMA_ACTION_DELAY:
+		ret =3D 0;
+		udelay(len);
+		len =3D 0;
+		break;
=20
-		default:
-			return -EINVAL;
+	case SIGMA_ACTION_END:
+		return 1;
+
+	default:
+		return -EINVAL;
 	}
=20
 	/* when arrive here ret=3D0 or sent data */
@@ -52,7 +53,8 @@ int process_sigma_action(struct i2c_clie
 	return ssfw->pos =3D=3D ssfw->fw->size;
 }
=20
-int process_sigma_actions(struct i2c_client *client, struct sigma_firm=
ware *ssfw)
+static int
+process_sigma_actions(struct i2c_client *client, struct sigma_firmware=
 *ssfw)
 {
 	pr_debug("%s: processing %p\n", __func__, ssfw);
=20
@@ -72,6 +74,7 @@ int process_sigma_firmware(struct i2c_cl
 	struct sigma_firmware_header *ssfw_head;
 	struct sigma_firmware ssfw;
 	const struct firmware *fw;
+	u32 crc;
=20
 	pr_debug("%s: loading firmware %s\n", __func__, name);
=20
@@ -84,16 +87,18 @@ int process_sigma_firmware(struct i2c_cl
 	ssfw.fw =3D fw;
=20
 	/* then verify the header */
-	if (fw->size < sizeof(*ssfw_head)) {
-		ret =3D -ENODATA;
+	ret =3D -EINVAL;
+	if (fw->size < sizeof(*ssfw_head))
 		goto done;
-	}
+
 	ssfw_head =3D (void *)fw->data;
-	if (memcmp(ssfw_head->magic, SIGMA_MAGIC, ARRAY_SIZE(ssfw_head->magic=
))) {
-		ret =3D -EINVAL;
+	if (memcmp(ssfw_head->magic, SIGMA_MAGIC, ARRAY_SIZE(ssfw_head->magic=
)))
+		goto done;
+
+	crc =3D crc32(0, fw->data, fw->size);
+	pr_debug("%s: crc=3D%x\n", __func__, crc);
+	if (crc !=3D ssfw_head->crc)
 		goto done;
-	}
-	pr_debug("%s: crc=3D%x\n", __func__, crc32(0, fw->data, fw->size));
=20
 	ssfw.pos =3D sizeof(*ssfw_head);
=20
diff -puN include/linux/sigma.h~sigma-firmware-loader-for-analog-device=
s-sigmastudio-v2 include/linux/sigma.h
--- a/include/linux/sigma.h~sigma-firmware-loader-for-analog-devices-si=
gmastudio-v2
+++ a/include/linux/sigma.h
@@ -1,9 +1,9 @@
 /*
  * Load firmware files from Analog Devices SigmaStudio
  *
-=C2=A0* Copyright 2009 Analog Devices Inc.
-=C2=A0*
-=C2=A0* Licensed under the GPL-2 or later.
+ * Copyright 2009-2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
  */
=20
 #ifndef __SIGMA_FIRMWARE_H__
@@ -12,6 +12,8 @@
 #include <linux/firmware.h>
 #include <linux/types.h>
=20
+struct i2c_client;
+
 #define SIGMA_MAGIC "ADISIGM"
=20
 struct sigma_firmware {
@@ -53,8 +55,6 @@ static inline size_t sigma_action_size(s
 	return sizeof(*sa) + payload_len + (payload_len % 2);
 }
=20
-struct i2c_client;
