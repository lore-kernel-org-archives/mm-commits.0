From: akpm@linux-foundation.org
Subject: [merged] sigma-firmware-loader-for-analog-devices-sigmastudio.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:40:12 -0700
Message-ID: <201103232043.p2NKhmG0028993@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600Ab1CWUy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:54:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     sigma-firmware: loader for Analog Devices' SigmaStudio
has been removed from the -mm tree.  Its filename was
     sigma-firmware-loader-for-analog-devices-sigmastudio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sigma-firmware: loader for Analog Devices' SigmaStudio
From: Mike Frysinger <vapier@gentoo.org>

Analog Devices' SigmaStudio can produce firmware blobs for devices with
these DSPs embedded (like some audio codecs).  Allow these device drivers
to easily parse and load them.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/Kconfig  |   12 +++
 drivers/firmware/Makefile |    1 
 drivers/firmware/sigma.c  |  115 ++++++++++++++++++++++++++++++++++++
 include/linux/sigma.h     |   60 ++++++++++++++++++
 4 files changed, 188 insertions(+)

diff -puN drivers/firmware/Kconfig~sigma-firmware-loader-for-analog-devices-sigmastudio drivers/firmware/Kconfig
--- a/drivers/firmware/Kconfig~sigma-firmware-loader-for-analog-devices-sigmastudio
+++ a/drivers/firmware/Kconfig
@@ -145,4 +145,16 @@ config ISCSI_IBFT
 	  detect iSCSI boot parameters dynamically during system boot, say Y.
 	  Otherwise, say N.
 
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
diff -puN drivers/firmware/Makefile~sigma-firmware-loader-for-analog-devices-sigmastudio drivers/firmware/Makefile
--- a/drivers/firmware/Makefile~sigma-firmware-loader-for-analog-devices-sigmastudio
+++ a/drivers/firmware/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_DMIID)		+= dmi-id.o
 obj-$(CONFIG_ISCSI_IBFT_FIND)	+= iscsi_ibft_find.o
 obj-$(CONFIG_ISCSI_IBFT)	+= iscsi_ibft.o
 obj-$(CONFIG_FIRMWARE_MEMMAP)	+= memmap.o
+obj-$(CONFIG_SIGMA)		+= sigma.o
diff -puN /dev/null drivers/firmware/sigma.c
--- /dev/null
+++ a/drivers/firmware/sigma.c
@@ -0,0 +1,115 @@
+/*
+ * Load Analog Devices SigmaStudio firmware files
+ *
+ * Copyright 2009-2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/crc32.h>
+#include <linux/delay.h>
+#include <linux/firmware.h>
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/sigma.h>
+
+/* Return: 0==OK, <0==error, =1 ==no more actions */
+static int
+process_sigma_action(struct i2c_client *client, struct sigma_firmware *ssfw)
+{
+	struct sigma_action *sa = (void *)(ssfw->fw->data + ssfw->pos);
+	size_t len = sigma_action_len(sa);
+	int ret = 0;
+
+	pr_debug("%s: instr:%i addr:%#x len:%zu\n", __func__,
+		sa->instr, sa->addr, len);
+
+	switch (sa->instr) {
+	case SIGMA_ACTION_WRITEXBYTES:
+	case SIGMA_ACTION_WRITESINGLE:
+	case SIGMA_ACTION_WRITESAFELOAD:
+		if (ssfw->fw->size < ssfw->pos + len)
+			return -EINVAL;
+		ret = i2c_master_send(client, (void *)&sa->addr, len);
+		if (ret < 0)
+			return -EINVAL;
+		break;
+
+	case SIGMA_ACTION_DELAY:
+		ret = 0;
+		udelay(len);
+		len = 0;
+		break;
+
+	case SIGMA_ACTION_END:
+		return 1;
+
+	default:
+		return -EINVAL;
+	}
+
+	/* when arrive here ret=0 or sent data */
+	ssfw->pos += sigma_action_size(sa, len);
+	return ssfw->pos == ssfw->fw->size;
+}
+
+static int
+process_sigma_actions(struct i2c_client *client, struct sigma_firmware *ssfw)
+{
+	pr_debug("%s: processing %p\n", __func__, ssfw);
+
+	while (1) {
+		int ret = process_sigma_action(client, ssfw);
+		pr_debug("%s: action returned %i\n", __func__, ret);
+		if (ret == 1)
+			return 0;
+		else if (ret)
+			return ret;
+	}
+}
+
+int process_sigma_firmware(struct i2c_client *client, const char *name)
+{
+	int ret;
+	struct sigma_firmware_header *ssfw_head;
+	struct sigma_firmware ssfw;
+	const struct firmware *fw;
+	u32 crc;
+
+	pr_debug("%s: loading firmware %s\n", __func__, name);
+
+	/* first load the blob */
+	ret = request_firmware(&fw, name, &client->dev);
+	if (ret) {
+		pr_debug("%s: request_firmware() failed with %i\n", __func__, ret);
+		return ret;
+	}
+	ssfw.fw = fw;
+
+	/* then verify the header */
+	ret = -EINVAL;
+	if (fw->size < sizeof(*ssfw_head))
+		goto done;
+
+	ssfw_head = (void *)fw->data;
+	if (memcmp(ssfw_head->magic, SIGMA_MAGIC, ARRAY_SIZE(ssfw_head->magic)))
+		goto done;
+
+	crc = crc32(0, fw->data, fw->size);
+	pr_debug("%s: crc=%x\n", __func__, crc);
+	if (crc != ssfw_head->crc)
+		goto done;
+
+	ssfw.pos = sizeof(*ssfw_head);
+
+	/* finally process all of the actions */
+	ret = process_sigma_actions(client, &ssfw);
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
+ * Copyright 2009-2011 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#ifndef __SIGMA_FIRMWARE_H__
+#define __SIGMA_FIRMWARE_H__
+
+#include <linux/firmware.h>
+#include <linux/types.h>
+
+struct i2c_client;
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
+	SIGMA_ACTION_WRITEXBYTES = 0,
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
+static inline size_t sigma_action_size(struct sigma_action *sa, u32 payload_len)
+{
+	return sizeof(*sa) + payload_len + (payload_len % 2);
+}
+
+extern int process_sigma_firmware(struct i2c_client *client, const char *name);
+
+#endif
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
backlight-new-driver-for-the-adp8870-backlight-devices.patch
linux-next.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch

