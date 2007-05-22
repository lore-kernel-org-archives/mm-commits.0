From: akpm@linux-foundation.org
Subject: - integrity-tpm-internal-kernel-interface.patch removed from -mm tree
Date: Tue, 22 May 2007 14:24:45 -0700
Message-ID: <200705222124.l4MLOjZU010127@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59423 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756030AbXEVV0Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 17:26:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, kjhall@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     integrity: TPM internal kernel interface
has been removed from the -mm tree.  Its filename was
     integrity-tpm-internal-kernel-interface.patch

This patch was dropped because this work seems to be stalled

------------------------------------------------------
Subject: integrity: TPM internal kernel interface
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Kylene Hall <kjhall@us.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |  264 ++++++++++++++++++++++++++++-----------
 drivers/char/tpm/tpm.h |    3 
 include/linux/tpm.h    |   60 ++++++++
 3 files changed, 257 insertions(+), 70 deletions(-)

diff -puN drivers/char/tpm/tpm.c~integrity-tpm-internal-kernel-interface drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~integrity-tpm-internal-kernel-interface
+++ a/drivers/char/tpm/tpm.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004 IBM Corporation
+ * Copyright (C) 2004,2007 IBM Corporation
  *
  * Authors:
  * Leendert van Doorn <leendert@watson.ibm.com>
@@ -26,6 +26,13 @@
 #include <linux/poll.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/crypto.h>
+#include <linux/fs.h>
+
+#include <asm/scatterlist.h>
 
 #include "tpm.h"
 
@@ -49,6 +56,8 @@ enum tpm_duration {
 static LIST_HEAD(tpm_chip_list);
 static DEFINE_SPINLOCK(driver_lock);
 static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
+#define TPM_CHIP_NUM_MASK       0x0000ffff
+#define TPM_CHIP_TYPE_SHIFT     16
 
 /*
  * Array with one entry per ordinal defining the maximum amount
@@ -321,7 +330,7 @@ static const u8 tpm_ordinal_duration[TPM
 
 static void user_reader_timeout(unsigned long ptr)
 {
-	struct tpm_chip *chip = (struct tpm_chip *) ptr;
+	struct tpm_chip *chip = (struct tpm_chip *)ptr;
 
 	schedule_work(&chip->work);
 }
@@ -337,10 +346,9 @@ static void timeout_work(struct work_str
 }
 
 /*
- * Returns max number of jiffies to wait
+ * tpm_calc_ordinal_duration - returns max number of jiffies to wait
  */
-unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip,
-					   u32 ordinal)
+unsigned long tpm_calc_ordinal_duration(struct tpm_chip *chip, u32 ordinal)
 {
 	int duration_idx = TPM_UNDEFINED;
 	int duration = 0;
@@ -363,10 +371,9 @@ unsigned long tpm_calc_ordinal_duration(
 EXPORT_SYMBOL_GPL(tpm_calc_ordinal_duration);
 
 /*
- * Internal kernel interface to transmit TPM commands
+ * tpm_transmit - internal kernel interface to transmit TPM commands
  */
-static ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
-			    size_t bufsiz)
+ssize_t tpm_transmit(struct tpm_chip * chip, char *buf, size_t bufsiz)
 {
 	ssize_t rc;
 	u32 count, ordinal;
@@ -385,8 +392,7 @@ static ssize_t tpm_transmit(struct tpm_c
 	mutex_lock(&chip->tpm_mutex);
 
 	if ((rc = chip->vendor.send(chip, (u8 *) buf, count)) < 0) {
-		dev_err(chip->dev,
-			"tpm_transmit: tpm_send: error %zd\n", rc);
+		dev_err(chip->dev, "tpm_transmit: tpm_send: error %zd\n", rc);
 		goto out;
 	}
 
@@ -418,12 +424,12 @@ static ssize_t tpm_transmit(struct tpm_c
 out_recv:
 	rc = chip->vendor.recv(chip, (u8 *) buf, bufsiz);
 	if (rc < 0)
-		dev_err(chip->dev,
-			"tpm_transmit: tpm_recv: error %zd\n", rc);
+		dev_err(chip->dev, "tpm_transmit: tpm_recv: error %zd\n", rc);
 out:
 	mutex_unlock(&chip->tpm_mutex);
 	return rc;
 }
+EXPORT_SYMBOL_GPL(tpm_transmit);
 
 #define TPM_DIGEST_SIZE 20
 #define TPM_ERROR_SIZE 10
@@ -471,13 +477,13 @@ static const u8 tpm_cap[] = {
 	0, 0, 1, 0		/* TPM_CAP_SUB_<TYPE> */
 };
 
-static ssize_t transmit_cmd(struct tpm_chip *chip, u8 *data, int len,
+static ssize_t transmit_cmd(struct tpm_chip *chip, u8 * data, int len,
 			    char *desc)
 {
 	int err;
 
 	len = tpm_transmit(chip, data, len);
-	if (len <  0)
+	if (len < 0)
 		return len;
 	if (len == TPM_ERROR_SIZE) {
 		err = be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX)));
@@ -497,7 +503,7 @@ void tpm_gen_interrupt(struct tpm_chip *
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_TIS_TIMEOUT;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the timeouts");
+			  "attempting to determine the timeouts");
 }
 EXPORT_SYMBOL_GPL(tpm_gen_interrupt);
 
@@ -512,7 +518,7 @@ void tpm_get_timeouts(struct tpm_chip *c
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_TIS_TIMEOUT;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the timeouts");
+			  "attempting to determine the timeouts");
 	if (rc)
 		goto duration;
 
@@ -544,7 +550,7 @@ duration:
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_TIS_DURATION;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the durations");
+			  "attempting to determine the durations");
 	if (rc)
 		return;
 
@@ -570,17 +576,20 @@ EXPORT_SYMBOL_GPL(tpm_get_timeouts);
 void tpm_continue_selftest(struct tpm_chip *chip)
 {
 	u8 data[] = {
-		0, 193,			/* TPM_TAG_RQU_COMMAND */
-		0, 0, 0, 10,		/* length */
-		0, 0, 0, 83,		/* TPM_ORD_GetCapability */
+		0, 193,		/* TPM_TAG_RQU_COMMAND */
+		0, 0, 0, 10,	/* length */
+		0, 0, 0, 83,	/* TPM_ORD_GetCapability */
 	};
 
 	tpm_transmit(chip, data, sizeof(data));
 }
 EXPORT_SYMBOL_GPL(tpm_continue_selftest);
 
-ssize_t tpm_show_enabled(struct device * dev, struct device_attribute * attr,
-			char *buf)
+/*
+ * tpm_show_enabled - determine the permanent disabled state
+ */
+ssize_t tpm_show_enabled(struct device *dev, struct device_attribute *attr,
+			 char *buf)
 {
 	u8 data[max_t(int, ARRAY_SIZE(tpm_cap), 35)];
 	ssize_t rc;
@@ -594,13 +603,16 @@ ssize_t tpm_show_enabled(struct device *
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_PERM;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attemtping to determine the permanent state");
+			  "attemtping to determine the permanent state");
 	if (rc)
 		return 0;
 	return sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_DISABLE_IDX]);
 }
 EXPORT_SYMBOL_GPL(tpm_show_enabled);
 
+/*
+ * tpm_show_active - determine the permanent inactive state
+ */
 ssize_t tpm_show_active(struct device * dev, struct device_attribute * attr,
 			char *buf)
 {
@@ -616,15 +628,18 @@ ssize_t tpm_show_active(struct device * 
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_PERM;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attemtping to determine the permanent state");
+			  "attemtping to determine the permanent state");
 	if (rc)
 		return 0;
 	return sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_INACTIVE_IDX]);
 }
 EXPORT_SYMBOL_GPL(tpm_show_active);
 
+/*
+ * tpm_show_owned - determine the owner state
+ */
 ssize_t tpm_show_owned(struct device * dev, struct device_attribute * attr,
-			char *buf)
+		       char *buf)
 {
 	u8 data[sizeof(tpm_cap)];
 	ssize_t rc;
@@ -638,15 +653,18 @@ ssize_t tpm_show_owned(struct device * d
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_OWNER;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the owner state");
+			  "attempting to determine the owner state");
 	if (rc)
 		return 0;
 	return sprintf(buf, "%d\n", data[TPM_GET_CAP_RET_BOOL_1_IDX]);
 }
 EXPORT_SYMBOL_GPL(tpm_show_owned);
 
+/*
+ * tpm_show_temp_deactivated - determine the temporary inactive state
+ */
 ssize_t tpm_show_temp_deactivated(struct device * dev,
-				struct device_attribute * attr, char *buf)
+				  struct device_attribute * attr, char *buf)
 {
 	u8 data[sizeof(tpm_cap)];
 	ssize_t rc;
@@ -660,13 +678,14 @@ ssize_t tpm_show_temp_deactivated(struct
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_VOL;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the temporary state");
+			  "attempting to determine the temporary state");
 	if (rc)
 		return 0;
 	return sprintf(buf, "%d\n", data[TPM_GET_CAP_TEMP_INACTIVE_IDX]);
 }
 EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
 
+#define READ_PCR_RESULT_SIZE 30
 static const u8 pcrread[] = {
 	0, 193,			/* TPM_TAG_RQU_COMMAND */
 	0, 0, 0, 14,		/* length */
@@ -677,7 +696,8 @@ static const u8 pcrread[] = {
 ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
-	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(pcrread)), 30)];
+	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(pcrread)),
+		READ_PCR_RESULT_SIZE)];
 	ssize_t rc;
 	int i, j, num_pcrs;
 	__be32 index;
@@ -692,7 +712,7 @@ ssize_t tpm_show_pcrs(struct device *dev
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_PCR;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the number of PCRS");
+			  "attempting to determine the number of PCRS");
 	if (rc)
 		return 0;
 
@@ -702,7 +722,7 @@ ssize_t tpm_show_pcrs(struct device *dev
 		index = cpu_to_be32(i);
 		memcpy(data + 10, &index, 4);
 		rc = transmit_cmd(chip, data, sizeof(data),
-				"attempting to read a PCR");
+				  "attempting to read a PCR");
 		if (rc)
 			goto out;
 		str += sprintf(str, "PCR-%02d: ", i);
@@ -715,6 +735,102 @@ out:
 }
 EXPORT_SYMBOL_GPL(tpm_show_pcrs);
 
+/*
+ * tpm_chip_lookup - return tpm_chip for given chip number and type
+ */
+static struct tpm_chip *tpm_chip_lookup(int chip_num, int chip_typ)
+{
+	struct tpm_chip *pos;
+
+	spin_lock(&driver_lock);
+	list_for_each_entry(pos, &tpm_chip_list, list)
+	    if ((chip_num == TPM_ANY_NUM || pos->dev_num == chip_num)
+		&& (chip_typ == TPM_ANY_TYPE)) {
+		spin_unlock(&driver_lock);
+		return pos;
+	}
+
+	spin_unlock(&driver_lock);
+	return NULL;
+}
+
+/**
+ * tpm_pcr_read - read a pcr value
+ * @chip_id: 	tpm chip identifier
+ * 		Upper 2 bytes: ANY, HW_ONLY or SW_ONLY
+ * 		Lower 2 bytes: tpm idx # or AN&
+ * @pcr_idx:	pcr idx to retrieve
+ * @res_buf: 	TPM_PCR value
+ * @res_buf_size: 20 bytes (or NULL if you don't care)
+ */
+int tpm_pcr_read(u32 chip_id, int pcr_idx, u8 * res_buf, int res_buf_size)
+{
+	u8 data[READ_PCR_RESULT_SIZE];
+	int rc;
+	__be32 index;
+	int chip_num = chip_id & TPM_CHIP_NUM_MASK;
+	struct tpm_chip *chip;
+
+	if (res_buf && res_buf_size < TPM_DIGEST_SIZE)
+		return -ENOSPC;
+
+	if ((chip = tpm_chip_lookup(chip_num,
+				    chip_id >> TPM_CHIP_TYPE_SHIFT)) == NULL)
+		return -ENODEV;
+
+	memcpy(data, pcrread, sizeof(pcrread));
+	index = cpu_to_be32(pcr_idx);
+	memcpy(data + 10, &index, 4);
+	rc = tpm_transmit(chip, data, sizeof(data));
+	if (rc > 0)
+		rc = be32_to_cpu(*((u32 *) (data + 6)));
+
+	if (rc == 0 && res_buf)
+		memcpy(res_buf, data + 10, TPM_DIGEST_SIZE);
+
+	return rc;
+
+}
+EXPORT_SYMBOL_GPL(tpm_pcr_read);
+
+#define EXTEND_PCR_SIZE 34
+static const u8 pcrextend[] = {
+	0, 193,			/* TPM_TAG_RQU_COMMAND */
+	0, 0, 0, 34,		/* length */
+	0, 0, 0, 20,		/* TPM_ORD_Extend */
+	0, 0, 0, 0		/* PCR index */
+};
+
+/**
+ * tpm_pcr_extend - extend pcr value with hash
+ * @chip_id: 	tpm chip identifier
+ * 		Upper 2 bytes: ANY, HW_ONLY or SW_ONLY
+ * 		Lower 2 bytes: tpm idx # or AN&
+ * @pcr_idx:	pcr idx to extend
+ * @hash: 	hash value used to extend pcr value
+ */
+int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8 * hash)
+{
+	u8 data[EXTEND_PCR_SIZE];
+	int rc;
+	__be32 index;
+	int chip_num = chip_id & TPM_CHIP_NUM_MASK;
+	struct tpm_chip *chip;
+
+	if ((chip = tpm_chip_lookup(chip_num,
+				    chip_id >> TPM_CHIP_TYPE_SHIFT)) == NULL)
+		return -ENODEV;
+
+	memcpy(data, pcrextend, sizeof(pcrextend));
+	index = cpu_to_be32(pcr_idx);
+	memcpy(data + 10, &index, 4);
+	memcpy(data + 14, hash, TPM_DIGEST_SIZE);
+	if ((rc = tpm_transmit(chip, data, sizeof(data))) > 0)
+		rc = be32_to_cpu(*((u32 *) (data + 6)));
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_pcr_extend);
+
 #define  READ_PUBEK_RESULT_SIZE 314
 static const u8 readpubek[] = {
 	0, 193,			/* TPM_TAG_RQU_COMMAND */
@@ -722,6 +838,9 @@ static const u8 readpubek[] = {
 	0, 0, 0, 124,		/* TPM_ORD_ReadPubek */
 };
 
+/*
+ * tpm_show_pubek - returns the tpm's public endorcement key
+ */
 ssize_t tpm_show_pubek(struct device *dev, struct device_attribute *attr,
 		       char *buf)
 {
@@ -741,13 +860,13 @@ ssize_t tpm_show_pubek(struct device *de
 	memcpy(data, readpubek, sizeof(readpubek));
 
 	err = transmit_cmd(chip, data, READ_PUBEK_RESULT_SIZE,
-			"attempting to read the PUBEK");
+			   "attempting to read the PUBEK");
 	if (err)
 		goto out;
 
 	/* 
 	   ignore header 10 bytes
-	   algorithm 32 bits (1 == RSA )
+	   algorithm 32 bits (1 == RSA)
 	   encscheme 16 bits
 	   sigscheme 16 bits
 	   parameters (RSA 12->bytes: keybit, #primes, expbit)  
@@ -756,17 +875,16 @@ ssize_t tpm_show_pubek(struct device *de
 	   ignore checksum 20 bytes
 	 */
 
-	str +=
-	    sprintf(str,
-		    "Algorithm: %02X %02X %02X %02X\nEncscheme: %02X %02X\n"
-		    "Sigscheme: %02X %02X\nParameters: %02X %02X %02X %02X"
-		    " %02X %02X %02X %02X %02X %02X %02X %02X\n"
-		    "Modulus length: %d\nModulus: \n",
-		    data[10], data[11], data[12], data[13], data[14],
-		    data[15], data[16], data[17], data[22], data[23],
-		    data[24], data[25], data[26], data[27], data[28],
-		    data[29], data[30], data[31], data[32], data[33],
-		    be32_to_cpu(*((__be32 *) (data + 34))));
+	str += sprintf(str,
+		       "Algorithm: %02X %02X %02X %02X\nEncscheme: %02X %02X\n"
+		       "Sigscheme: %02X %02X\nParameters: %02X %02X %02X %02X"
+		       " %02X %02X %02X %02X %02X %02X %02X %02X\n"
+		       "Modulus length: %d\nModulus: \n",
+		       data[10], data[11], data[12], data[13], data[14],
+		       data[15], data[16], data[17], data[22], data[23],
+		       data[24], data[25], data[26], data[27], data[28],
+		       data[29], data[30], data[31], data[32], data[33],
+		       be32_to_cpu(*((__be32 *) (data + 34))));
 
 	for (i = 0; i < 256; i++) {
 		str += sprintf(str, "%02X ", data[i + 38]);
@@ -791,10 +909,14 @@ static const u8 cap_version[] = {
 	0, 0, 0, 0
 };
 
+/*
+ * tpm_show_caps - returns the manufacturer and chip version
+ */
 ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
-	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(cap_version)), 30)];
+	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap),
+			       ARRAY_SIZE(cap_version)), 30)];
 	ssize_t rc;
 	char *str = buf;
 
@@ -807,34 +929,39 @@ ssize_t tpm_show_caps(struct device *dev
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_MANUFACTURER;
 
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the manufacturer");
+			  "attempting to determine the manufacturer");
 	if (rc)
 		return 0;
 
 	str += sprintf(str, "Manufacturer: 0x%x\n",
-		       be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX))));
+		       be32_to_cpu(*((__be32 *) (data +
+						 TPM_GET_CAP_RET_UINT32_1_IDX))));
 
 	memcpy(data, cap_version, sizeof(cap_version));
 	data[CAP_VERSION_IDX] = CAP_VERSION_1_1;
 	rc = transmit_cmd(chip, data, sizeof(data),
-			"attempting to determine the 1.1 version");
+			  "attempting to determine the 1.1 version");
 	if (rc)
 		goto out;
 
 	str += sprintf(str,
 		       "TCG version: %d.%d\nFirmware version: %d.%d\n",
-		       (int) data[14], (int) data[15], (int) data[16],
-		       (int) data[17]);
+		       (int)data[14], (int)data[15], (int)data[16],
+		       (int)data[17]);
 
 out:
 	return str - buf;
 }
 EXPORT_SYMBOL_GPL(tpm_show_caps);
 
+/*
+ * tpm_show_caps_1_2 - returns the manufacturer and chip 1.2 version
+ */
 ssize_t tpm_show_caps_1_2(struct device * dev,
 			  struct device_attribute * attr, char *buf)
 {
-	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(cap_version)), 30)];
+	u8 data[max_t
+		(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(cap_version)), 30)];
 	ssize_t len;
 	char *str = buf;
 
@@ -846,8 +973,7 @@ ssize_t tpm_show_caps_1_2(struct device 
 	data[TPM_CAP_IDX] = TPM_CAP_PROP;
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_MANUFACTURER;
 
-	if ((len = tpm_transmit(chip, data, sizeof(data))) <=
-	    TPM_ERROR_SIZE) {
+	if ((len = tpm_transmit(chip, data, sizeof(data))) <= TPM_ERROR_SIZE) {
 		dev_dbg(chip->dev, "A TPM error (%d) occurred "
 			"attempting to determine the manufacturer\n",
 			be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX))));
@@ -855,30 +981,32 @@ ssize_t tpm_show_caps_1_2(struct device 
 	}
 
 	str += sprintf(str, "Manufacturer: 0x%x\n",
-		       be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX))));
+		       be32_to_cpu(*((__be32 *) (data +
+						 TPM_GET_CAP_RET_UINT32_1_IDX))));
 
 	memcpy(data, cap_version, sizeof(cap_version));
 	data[CAP_VERSION_IDX] = CAP_VERSION_1_2;
 
-	if ((len = tpm_transmit(chip, data, sizeof(data))) <=
-	    TPM_ERROR_SIZE) {
+	if ((len = tpm_transmit(chip, data, sizeof(data))) <= TPM_ERROR_SIZE) {
 		dev_err(chip->dev, "A TPM error (%d) occurred "
 			"attempting to determine the 1.2 version\n",
 			be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX))));
 		goto out;
 	}
-	str += sprintf(str,
-		       "TCG version: %d.%d\nFirmware version: %d.%d\n",
-		       (int) data[16], (int) data[17], (int) data[18],
-		       (int) data[19]);
+	str += sprintf(str, "TCG version: %d.%d\nFirmware version: %d.%d\n",
+		       (int)data[16], (int)data[17], (int)data[18],
+		       (int)data[19]);
 
 out:
 	return str - buf;
 }
 EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
 
-ssize_t tpm_store_cancel(struct device *dev, struct device_attribute *attr,
-			const char *buf, size_t count)
+/*
+ * tpm_store_cancel - cancel the current tpm operation
+ */
+ssize_t tpm_store_cancel(struct device * dev, struct device_attribute * attr,
+			 const char *buf, size_t count)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	if (chip == NULL)
@@ -973,8 +1101,7 @@ ssize_t tpm_write(struct file *file, con
 	if (in_size > TPM_BUFSIZE)
 		in_size = TPM_BUFSIZE;
 
-	if (copy_from_user
-	    (chip->data_buffer, (void __user *) buf, in_size)) {
+	if (copy_from_user(chip->data_buffer, (void __user *)buf, in_size)) {
 		mutex_unlock(&chip->buffer_mutex);
 		return -EFAULT;
 	}
@@ -992,8 +1119,8 @@ ssize_t tpm_write(struct file *file, con
 }
 EXPORT_SYMBOL_GPL(tpm_write);
 
-ssize_t tpm_read(struct file *file, char __user *buf,
-		 size_t size, loff_t *off)
+ssize_t tpm_read(struct file * file, char __user * buf,
+		 size_t size, loff_t * off)
 {
 	struct tpm_chip *chip = file->private_data;
 	int ret_size;
@@ -1114,7 +1241,7 @@ struct tpm_chip *tpm_register_hardware(s
 	INIT_WORK(&chip->work, timeout_work);
 
 	setup_timer(&chip->user_read_timer, user_reader_timeout,
-			(unsigned long)chip);
+		    (unsigned long)chip);
 
 	memcpy(&chip->vendor, entry, sizeof(struct tpm_vendor_specific));
 
@@ -1140,8 +1267,7 @@ struct tpm_chip *tpm_register_hardware(s
 	if (misc_register(&chip->vendor.miscdev)) {
 		dev_err(chip->dev,
 			"unable to misc_register %s, minor %d\n",
-			chip->vendor.miscdev.name,
-			chip->vendor.miscdev.minor);
+			chip->vendor.miscdev.name, chip->vendor.miscdev.minor);
 		put_device(dev);
 		clear_bit(chip->dev_num, dev_mask);
 		kfree(chip);
diff -puN drivers/char/tpm/tpm.h~integrity-tpm-internal-kernel-interface drivers/char/tpm/tpm.h
--- a/drivers/char/tpm/tpm.h~integrity-tpm-internal-kernel-interface
+++ a/drivers/char/tpm/tpm.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2004 IBM Corporation
+ * Copyright (C) 2004, 2007 IBM Corporation
  *
  * Authors:
  * Leendert van Doorn <leendert@watson.ibm.com>
@@ -26,6 +26,7 @@
 #include <linux/miscdevice.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/tpm.h>
 
 enum tpm_timeout {
 	TPM_TIMEOUT = 5,	/* msecs */
diff -puN /dev/null include/linux/tpm.h
--- /dev/null
+++ a/include/linux/tpm.h
@@ -0,0 +1,60 @@
+/*
+ * Copyright (C) 2004,2007 IBM Corporation
+ *
+ * Authors:
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Dave Safford <safford@watson.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ *
+ * Maintained by: <tpmdd_devel@lists.sourceforge.net>
+ *
+ * Device driver for TCG/TCPA TPM (trusted platform module).
+ * Specifications at www.trustedcomputinggroup.org
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+#ifndef __LINUX_TPM_H__
+#define __LINUX_TPM_H__
+
+#define PCI_DEVICE_ID_AMD_8111_LPC    0x7468
+
+/*
+ * Chip type is one of these values in the upper two bytes of chip_id
+ */
+enum tpm_chip_type {
+	TPM_HW_TYPE = 0x0,
+	TPM_SW_TYPE = 0x1,
+	TPM_ANY_TYPE = 0xFFFF,
+};
+
+/*
+ * Chip num is this value or a valid tpm idx in lower two bytes of chip_id
+ */
+enum tpm_chip_num {
+	TPM_ANY_NUM = 0xFFFF,
+};
+
+
+#if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
+
+extern int tpm_pcr_read(u32 chip_id, int pcr_idx, u8* res_buf, int res_buf_size);
+extern int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8* hash);
+#else
+static inline int tpm_pcr_read(u32 chip_id, int pcr_idx, u8* res_buf,
+				int res_buf_size)
+{
+	return -ENODEV;
+}
+
+static inline int tpm_pcr_extend(u32 chip_id, int pcr_idx, const u8* hash)
+{
+	return -ENODEV;
+}
+#endif
+#endif
+
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

integrity-tpm-internal-kernel-interface.patch
ibac-patch.patch
