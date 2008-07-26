From: akpm@linux-foundation.org
Subject: - tpm-increase-size-of-internal-tpm-response-buffers.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:56 -0700
Message-ID: <200807262113.m6QLDumV019639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756400AbYGZVTx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:19:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin_obara@users.sourceforge.net, kjhall@us.ibm.com, tpm@selhorst.net, mm-commits@vger.kernel.org


The patch titled
     tpm: increase size of internal TPM response buffers
has been removed from the -mm tree.  Its filename was
     tpm-increase-size-of-internal-tpm-response-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tpm: increase size of internal TPM response buffers
From: Marcin Obara <marcin_obara@users.sourceforge.net>

This patch increases size of driver internal response buffers.  Some TPM
responses defined in TCG TPM Specification Version 1.2 Revision 103 have
increased size and do not fit previously defined buffers.  Some TPM
responses do not have fixed size, so bigger response buffers have to be
allocated.  200B buffers should be enough.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: Marcel Selhorst <tpm@selhorst.net>
Cc: Kylene Jo Hall <kjhall@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tpm/tpm.c |  124 +++++++++++++++++++++++++++++----------
 1 file changed, 93 insertions(+), 31 deletions(-)

diff -puN drivers/char/tpm/tpm.c~tpm-increase-size-of-internal-tpm-response-buffers drivers/char/tpm/tpm.c
--- a/drivers/char/tpm/tpm.c~tpm-increase-size-of-internal-tpm-response-buffers
+++ a/drivers/char/tpm/tpm.c
@@ -580,91 +580,133 @@ void tpm_continue_selftest(struct tpm_ch
 }
 EXPORT_SYMBOL_GPL(tpm_continue_selftest);
 
+#define  TPM_INTERNAL_RESULT_SIZE 200
+
 ssize_t tpm_show_enabled(struct device * dev, struct device_attribute * attr,
 			char *buf)
 {
-	u8 data[max_t(int, ARRAY_SIZE(tpm_cap), 35)];
+	u8 *data;
 	ssize_t rc;
 
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	if (chip == NULL)
 		return -ENODEV;
 
+	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	memcpy(data, tpm_cap, sizeof(tpm_cap));
 	data[TPM_CAP_IDX] = TPM_CAP_FLAG;
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_PERM;
 
-	rc = transmit_cmd(chip, data, sizeof(data),
-			"attemtping to determine the permanent state");
-	if (rc)
+	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
+			"attemtping to determine the permanent enabled state");
+	if (rc) {
+		kfree(data);
 		return 0;
-	return sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_DISABLE_IDX]);
+	}
+
+	rc = sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_DISABLE_IDX]);
+
+	kfree(data);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_show_enabled);
 
 ssize_t tpm_show_active(struct device * dev, struct device_attribute * attr,
 			char *buf)
 {
-	u8 data[max_t(int, ARRAY_SIZE(tpm_cap), 35)];
+	u8 *data;
 	ssize_t rc;
 
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	if (chip == NULL)
 		return -ENODEV;
 
+	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	memcpy(data, tpm_cap, sizeof(tpm_cap));
 	data[TPM_CAP_IDX] = TPM_CAP_FLAG;
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_PERM;
 
-	rc = transmit_cmd(chip, data, sizeof(data),
-			"attemtping to determine the permanent state");
-	if (rc)
+	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
+			"attemtping to determine the permanent active state");
+	if (rc) {
+		kfree(data);
 		return 0;
-	return sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_INACTIVE_IDX]);
+	}
+
+	rc = sprintf(buf, "%d\n", !data[TPM_GET_CAP_PERM_INACTIVE_IDX]);
+
+	kfree(data);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_show_active);
 
 ssize_t tpm_show_owned(struct device * dev, struct device_attribute * attr,
 			char *buf)
 {
-	u8 data[sizeof(tpm_cap)];
+	u8 *data;
 	ssize_t rc;
 
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	if (chip == NULL)
 		return -ENODEV;
 
+	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	memcpy(data, tpm_cap, sizeof(tpm_cap));
 	data[TPM_CAP_IDX] = TPM_CAP_PROP;
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_OWNER;
 
-	rc = transmit_cmd(chip, data, sizeof(data),
+	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
 			"attempting to determine the owner state");
-	if (rc)
+	if (rc) {
+		kfree(data);
 		return 0;
-	return sprintf(buf, "%d\n", data[TPM_GET_CAP_RET_BOOL_1_IDX]);
+	}
+
+	rc = sprintf(buf, "%d\n", data[TPM_GET_CAP_RET_BOOL_1_IDX]);
+
+	kfree(data);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_show_owned);
 
 ssize_t tpm_show_temp_deactivated(struct device * dev,
 				struct device_attribute * attr, char *buf)
 {
-	u8 data[sizeof(tpm_cap)];
+	u8 *data;
 	ssize_t rc;
 
 	struct tpm_chip *chip = dev_get_drvdata(dev);
 	if (chip == NULL)
 		return -ENODEV;
 
+	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	memcpy(data, tpm_cap, sizeof(tpm_cap));
 	data[TPM_CAP_IDX] = TPM_CAP_FLAG;
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_FLAG_VOL;
 
-	rc = transmit_cmd(chip, data, sizeof(data),
+	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
 			"attempting to determine the temporary state");
-	if (rc)
+	if (rc) {
+		kfree(data);
 		return 0;
-	return sprintf(buf, "%d\n", data[TPM_GET_CAP_TEMP_INACTIVE_IDX]);
+	}
+
+	rc = sprintf(buf, "%d\n", data[TPM_GET_CAP_TEMP_INACTIVE_IDX]);
+
+	kfree(data);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(tpm_show_temp_deactivated);
 
@@ -678,7 +720,7 @@ static const u8 pcrread[] = {
 ssize_t tpm_show_pcrs(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
-	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(pcrread)), 30)];
+	u8 *data;
 	ssize_t rc;
 	int i, j, num_pcrs;
 	__be32 index;
@@ -688,21 +730,27 @@ ssize_t tpm_show_pcrs(struct device *dev
 	if (chip == NULL)
 		return -ENODEV;
 
+	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	memcpy(data, tpm_cap, sizeof(tpm_cap));
 	data[TPM_CAP_IDX] = TPM_CAP_PROP;
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_PCR;
 
-	rc = transmit_cmd(chip, data, sizeof(data),
+	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
 			"attempting to determine the number of PCRS");
-	if (rc)
+	if (rc) {
+		kfree(data);
 		return 0;
+	}
 
 	num_pcrs = be32_to_cpu(*((__be32 *) (data + 14)));
 	for (i = 0; i < num_pcrs; i++) {
 		memcpy(data, pcrread, sizeof(pcrread));
 		index = cpu_to_be32(i);
 		memcpy(data + 10, &index, 4);
-		rc = transmit_cmd(chip, data, sizeof(data),
+		rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
 				"attempting to read a PCR");
 		if (rc)
 			goto out;
@@ -712,6 +760,7 @@ ssize_t tpm_show_pcrs(struct device *dev
 		str += sprintf(str, "\n");
 	}
 out:
+	kfree(data);
 	return str - buf;
 }
 EXPORT_SYMBOL_GPL(tpm_show_pcrs);
@@ -795,7 +844,7 @@ static const u8 cap_version[] = {
 ssize_t tpm_show_caps(struct device *dev, struct device_attribute *attr,
 		      char *buf)
 {
-	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(cap_version)), 30)];
+	u8 *data;
 	ssize_t rc;
 	char *str = buf;
 
@@ -803,21 +852,27 @@ ssize_t tpm_show_caps(struct device *dev
 	if (chip == NULL)
 		return -ENODEV;
 
+	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	memcpy(data, tpm_cap, sizeof(tpm_cap));
 	data[TPM_CAP_IDX] = TPM_CAP_PROP;
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_MANUFACTURER;
 
-	rc = transmit_cmd(chip, data, sizeof(data),
+	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
 			"attempting to determine the manufacturer");
-	if (rc)
+	if (rc) {
+		kfree(data);
 		return 0;
+	}
 
 	str += sprintf(str, "Manufacturer: 0x%x\n",
 		       be32_to_cpu(*((__be32 *) (data + TPM_GET_CAP_RET_UINT32_1_IDX))));
 
 	memcpy(data, cap_version, sizeof(cap_version));
 	data[CAP_VERSION_IDX] = CAP_VERSION_1_1;
-	rc = transmit_cmd(chip, data, sizeof(data),
+	rc = transmit_cmd(chip, data, TPM_INTERNAL_RESULT_SIZE,
 			"attempting to determine the 1.1 version");
 	if (rc)
 		goto out;
@@ -828,6 +883,7 @@ ssize_t tpm_show_caps(struct device *dev
 		       (int) data[17]);
 
 out:
+	kfree(data);
 	return str - buf;
 }
 EXPORT_SYMBOL_GPL(tpm_show_caps);
@@ -835,7 +891,7 @@ EXPORT_SYMBOL_GPL(tpm_show_caps);
 ssize_t tpm_show_caps_1_2(struct device * dev,
 			  struct device_attribute * attr, char *buf)
 {
-	u8 data[max_t(int, max(ARRAY_SIZE(tpm_cap), ARRAY_SIZE(cap_version)), 30)];
+	u8 *data;
 	ssize_t len;
 	char *str = buf;
 
@@ -843,15 +899,20 @@ ssize_t tpm_show_caps_1_2(struct device 
 	if (chip == NULL)
 		return -ENODEV;
 
+	data = kzalloc(TPM_INTERNAL_RESULT_SIZE, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
 	memcpy(data, tpm_cap, sizeof(tpm_cap));
 	data[TPM_CAP_IDX] = TPM_CAP_PROP;
 	data[TPM_CAP_SUBCAP_IDX] = TPM_CAP_PROP_MANUFACTURER;
 
-	if ((len = tpm_transmit(chip, data, sizeof(data))) <=
-	    TPM_ERROR_SIZE) {
+	len = tpm_transmit(chip, data, TPM_INTERNAL_RESULT_SIZE);
+	if (len <= TPM_ERROR_SIZE) {
 		dev_dbg(chip->dev, "A TPM error (%d) occurred "
 			"attempting to determine the manufacturer\n",
 			be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX))));
+		kfree(data);
 		return 0;
 	}
 
@@ -861,8 +922,8 @@ ssize_t tpm_show_caps_1_2(struct device 
 	memcpy(data, cap_version, sizeof(cap_version));
 	data[CAP_VERSION_IDX] = CAP_VERSION_1_2;
 
-	if ((len = tpm_transmit(chip, data, sizeof(data))) <=
-	    TPM_ERROR_SIZE) {
+	len = tpm_transmit(chip, data, TPM_INTERNAL_RESULT_SIZE);
+	if (len <= TPM_ERROR_SIZE) {
 		dev_err(chip->dev, "A TPM error (%d) occurred "
 			"attempting to determine the 1.2 version\n",
 			be32_to_cpu(*((__be32 *) (data + TPM_RET_CODE_IDX))));
@@ -874,6 +935,7 @@ ssize_t tpm_show_caps_1_2(struct device 
 		       (int) data[19]);
 
 out:
+	kfree(data);
 	return str - buf;
 }
 EXPORT_SYMBOL_GPL(tpm_show_caps_1_2);
_

Patches currently in -mm which might be from marcin_obara@users.sourceforge.net are

origin.patch
tpm-correct-tpm-timeouts-to-jiffies-conversion.patch

