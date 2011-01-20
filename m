From: akpm@linux-foundation.org
Subject: + sigma-firmware-loader-for-analog-devices-sigmastudio.patch added to -mm tree
Date: Wed, 19 Jan 2011 16:38:33 -0800
Message-ID: <201101200038.p0K0cXMe012944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754675Ab1ATAig (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 19:38:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org


The patch titled
     sigma-firmware: loader for Analog Devices' SigmaStudio
has been added to the -mm tree.  Its filename is
     sigma-firmware-loader-for-analog-devices-sigmastudio.patch

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
Subject: sigma-firmware: loader for Analog Devices' SigmaStudio
=46rom: Mike Frysinger <vapier@gentoo.org>

Analog Devices' SigmaStudio can produce firmware blobs for devices with
these DSPs embedded (like some audio codecs).  Allow these device drive=
rs
to easily parse and load them.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/Kconfig  |   12 +++
 drivers/firmware/Makefile |    1=20
 drivers/firmware/sigma.c  |  110 ++++++++++++++++++++++++++++++++++++
 include/linux/sigma.h     |   60 +++++++++++++++++++
 4 files changed, 183 insertions(+)

diff -puN drivers/firmware/Kconfig~sigma-firmware-loader-for-analog-dev=
ices-sigmastudio drivers/firmware/Kconfig
--- a/drivers/firmware/Kconfig~sigma-firmware-loader-for-analog-devices=
-sigmastudio
+++ a/drivers/firmware/Kconfig
@@ -134,4 +134,16 @@ config ISCSI_IBFT
 	  detect iSCSI boot parameters dynamically during system boot, say Y.
 	  Otherwise, say N.
=20
+config SIGMA
+	tristate "SigmaStudio firmware loader"
+	depends on I2C
+	select CRC32
+	default n
+	help
+	  Enable helper functions for working with Analog Devices SigmaDSP
+	  parts and binary firmwares produced by Analog Devices SigmaStudio.
+
+	  If unsure, say N here.  Drivers that need these helpers will select
+	  this option automatically.
+
 endmenu
diff -puN drivers/firmware/Makefile~sigma-firmware-loader-for-analog-de=
vices-sigmastudio drivers/firmware/Makefile
--- a/drivers/firmware/Makefile~sigma-firmware-loader-for-analog-device=
s-sigmastudio
+++ a/drivers/firmware/Makefile
@@ -11,3 +11,4 @@ obj-$(CONFIG_DMIID)		+=3D dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+=3D iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+=3D iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+=3D memmap.o
+obj-$(CONFIG_SIGMA)		+=3D sigma.o
diff -puN /dev/null drivers/firmware/sigma.c
--- /dev/null
+++ a/drivers/firmware/sigma.c
@@ -0,0 +1,110 @@
+/*
+ * Load Analog Devices SigmaStudio firmware files
+ *
+=C2=A0* Copyright 2009 Analog Devices Inc.
+=C2=A0*
+=C2=A0* Licensed under the GPL-2 or later.
+ */
+
+#include <linux/crc32.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/sigma.h>
+
+/* Return: 0=3D=3DOK, <0=3D=3Derror, =3D1 =3D=3Dno more actions */
+int process_sigma_action(struct i2c_client *client, struct sigma_firmw=
are *ssfw)
+{
+	struct sigma_action *sa =3D (void *)(ssfw->fw->data + ssfw->pos);
+	size_t len =3D sigma_action_len(sa);
+	int ret =3D 0;
+
+	pr_debug("%s: instr:%i addr:%#x len:%zu\n", __func__,
+		sa->instr, sa->addr, len);
+
+	switch (sa->instr) {
+		case SIGMA_ACTION_WRITEXBYTES:
+		case SIGMA_ACTION_WRITESINGLE:
+		case SIGMA_ACTION_WRITESAFELOAD:
+			if (ssfw->fw->size < ssfw->pos + len)
+				return -EINVAL;
+			ret =3D i2c_master_send(client, (void *)&sa->addr, len);
+			if (ret < 0)
+				return -EINVAL;
+			break;
+
+		case SIGMA_ACTION_DELAY:
+			ret =3D 0;
+			udelay(len);
+			len =3D 0;
+			break;
+
+		case SIGMA_ACTION_END:
+			return 1;
+
+		default:
+			return -EINVAL;
+	}
+
+	/* when arrive here ret=3D0 or sent data */
+	ssfw->pos +=3D sigma_action_size(sa, len);
+	return ssfw->pos =3D=3D ssfw->fw->size;
+}
+
+int process_sigma_actions(struct i2c_client *client, struct sigma_firm=
ware *ssfw)
+{
+	pr_debug("%s: processing %p\n", __func__, ssfw);
+
+	while (1) {
+		int ret =3D process_sigma_action(client, ssfw);
+		pr_debug("%s: action returned %i\n", __func__, ret);
+		if (ret =3D=3D 1)
+			return 0;
+		else if (ret)
+			return ret;
+	}
+}
+
+int process_sigma_firmware(struct i2c_client *client, const char *name=
)
+{
+	int ret;
+	struct sigma_firmware_header *ssfw_head;
+	struct sigma_firmware ssfw;
+	const struct firmware *fw;
+
+	pr_debug("%s: loading firmware %s\n", __func__, name);
+
+	/* first load the blob */
+	ret =3D request_firmware(&fw, name, &client->dev);
+	if (ret) {
+		pr_debug("%s: request_firmware() failed with %i\n", __func__, ret);
+		return ret;
+	}
+	ssfw.fw =3D fw;
+
+	/* then verify the header */
+	if (fw->size < sizeof(*ssfw_head)) {
+		ret =3D -ENODATA;
+		goto done;
+	}
+	ssfw_head =3D (void *)fw->data;
+	if (memcmp(ssfw_head->magic, SIGMA_MAGIC, ARRAY_SIZE(ssfw_head->magic=
))) {
+		ret =3D -EINVAL;
+		goto done;
+	}
+	pr_debug("%s: crc=3D%x\n", __func__, crc32(0, fw->data, fw->size));
+
+	ssfw.pos =3D sizeof(*ssfw_head);
+
+	/* finally process all of the actions */
+	ret =3D process_sigma_actions(client, &ssfw);
+
+ done:
+	release_firmware(fw);
+
+	pr_debug("%s: loaded %s\n", __func__, name);
+
+	return ret;
+}
+EXPORT_SYMBOL(process_sigma_firmware);
diff -puN /dev/null include/linux/sigma.h
--- /dev/null
+++ a/include/linux/sigma.h
@@ -0,0 +1,60 @@
+/*
+ * Load firmware files from Analog Devices SigmaStudio
+ *
+=C2=A0* Copyright 2009 Analog Devices Inc.
+=C2=A0*
+=C2=A0* Licensed under the GPL-2 or later.
+ */
+
+#ifndef __SIGMA_FIRMWARE_H__
+#define __SIGMA_FIRMWARE_H__
+
+#include <linux/firmware.h>
+#include <linux/types.h>
+
+#define SIGMA_MAGIC "ADISIGM"
+
+struct sigma_firmware {
+	const struct firmware *fw;
+	size_t pos;
+};
+
+struct sigma_firmware_header {
+	unsigned char magic[7];
+	u8 version;
+	u32 crc;
+};
+
+enum {
+	SIGMA_ACTION_WRITEXBYTES =3D 0,
+	SIGMA_ACTION_WRITESINGLE,
+	SIGMA_ACTION_WRITESAFELOAD,
+	SIGMA_ACTION_DELAY,
+	SIGMA_ACTION_PLLWAIT,
+	SIGMA_ACTION_NOOP,
+	SIGMA_ACTION_END,
+};
+
+struct sigma_action {
+	u8 instr;
+	u8 len_hi;
+	u16 len;
+	u16 addr;
+	unsigned char payload[];
+};
+
+static inline u32 sigma_action_len(struct sigma_action *sa)
+{
+	return (sa->len_hi << 16) | sa->len;
+}
+
+static inline size_t sigma_action_size(struct sigma_action *sa, u32 pa=
yload_len)
+{
+	return sizeof(*sa) + payload_len + (payload_len % 2);
+}
+
+struct i2c_client;
+
+extern int process_sigma_firmware(struct i2c_client *client, const cha=
r *name);
+
+#endif
_

Patches currently in -mm which might be from vapier@gentoo.org are

linux-next.patch
llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg.patch
llist-lib-add-lock-less-null-terminated-single-list.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch
sigma-firmware-loader-for-analog-devices-sigmastudio.patch
sigma-firmware-loader-for-analog-devices-sigmastudio-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
