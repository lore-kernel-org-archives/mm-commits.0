From: akpm@linux-foundation.org
Subject: + lm85-support-adt7468-chips.patch added to -mm tree
Date: Fri, 07 Nov 2008 11:21:26 -0800
Message-ID: <200811071921.mA7JLQon003308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752370AbYKGTVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Nov 2008 14:21:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, khali@linux-fr.org


The patch titled
     lm85: support adt7468 chips
has been added to the -mm tree.  Its filename is
     lm85-support-adt7468-chips.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lm85: support adt7468 chips
From: "Darrick J. Wong" <djwong@us.ibm.com>

The adt7468 is a follow-on to the adt7463, so plumb in adt7468 support
along the same code paths.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lm85.c |   52 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 6 deletions(-)

diff -puN drivers/hwmon/lm85.c~lm85-support-adt7468-chips drivers/hwmon/lm85.c
--- a/drivers/hwmon/lm85.c~lm85-support-adt7468-chips
+++ a/drivers/hwmon/lm85.c
@@ -39,7 +39,8 @@
 static const unsigned short normal_i2c[] = { 0x2c, 0x2d, 0x2e, I2C_CLIENT_END };
 
 /* Insmod parameters */
-I2C_CLIENT_INSMOD_6(lm85b, lm85c, adm1027, adt7463, emc6d100, emc6d102);
+I2C_CLIENT_INSMOD_7(lm85b, lm85c, adm1027, adt7463, adt7468, emc6d100,
+		    emc6d102);
 
 /* The LM85 registers */
 
@@ -59,6 +60,12 @@ I2C_CLIENT_INSMOD_6(lm85b, lm85c, adm102
 
 #define	LM85_REG_COMPANY		0x3e
 #define	LM85_REG_VERSTEP		0x3f
+
+#define	ADT7468_REG_CFG5		0x7c
+#define		ADT7468_OFF64		0x01
+#define	IS_ADT7468_OFF64(data)		\
+	((data)->type == adt7468 && !((data)->cfg5 & ADT7468_OFF64))
+
 /* These are the recognized values for the above regs */
 #define	LM85_COMPANY_NATIONAL		0x01
 #define	LM85_COMPANY_ANALOG_DEV		0x41
@@ -70,6 +77,8 @@ I2C_CLIENT_INSMOD_6(lm85b, lm85c, adm102
 #define	LM85_VERSTEP_ADM1027		0x60
 #define	LM85_VERSTEP_ADT7463		0x62
 #define	LM85_VERSTEP_ADT7463C		0x6A
+#define	LM85_VERSTEP_ADT7468_1		0x71
+#define	LM85_VERSTEP_ADT7468_2		0x72
 #define	LM85_VERSTEP_EMC6D100_A0        0x60
 #define	LM85_VERSTEP_EMC6D100_A1        0x61
 #define	LM85_VERSTEP_EMC6D102		0x65
@@ -306,6 +315,7 @@ struct lm85_data {
 	u8 vid;			/* Register value */
 	u8 vrm;			/* VRM version */
 	u32 alarms;		/* Register encoding, combined */
+	u8 cfg5;		/* Config Register 5 on ADT7468 */
 	struct lm85_autofan autofan[3];
 	struct lm85_zone zone[3];
 };
@@ -685,6 +695,9 @@ static ssize_t set_temp_min(struct devic
 	struct lm85_data *data = i2c_get_clientdata(client);
 	long val = simple_strtol(buf, NULL, 10);
 
+	if (IS_ADT7468_OFF64(data))
+		val += 64;
+
 	mutex_lock(&data->update_lock);
 	data->temp_min[nr] = TEMP_TO_REG(val);
 	lm85_write_value(client, LM85_REG_TEMP_MIN(nr), data->temp_min[nr]);
@@ -708,6 +721,9 @@ static ssize_t set_temp_max(struct devic
 	struct lm85_data *data = i2c_get_clientdata(client);
 	long val = simple_strtol(buf, NULL, 10);
 
+	if (IS_ADT7468_OFF64(data))
+		val += 64;
+
 	mutex_lock(&data->update_lock);
 	data->temp_max[nr] = TEMP_TO_REG(val);
 	lm85_write_value(client, LM85_REG_TEMP_MAX(nr), data->temp_max[nr]);
@@ -1163,6 +1179,10 @@ static int lm85_detect(struct i2c_client
 			case LM85_VERSTEP_ADT7463C:
 				kind = adt7463;
 				break;
+			case LM85_VERSTEP_ADT7468_1:
+			case LM85_VERSTEP_ADT7468_2:
+				kind = adt7468;
+				break;
 			}
 		} else if (company == LM85_COMPANY_SMSC) {
 			switch (verstep) {
@@ -1195,6 +1215,9 @@ static int lm85_detect(struct i2c_client
 	case adt7463:
 		type_name = "adt7463";
 		break;
+	case adt7468:
+		type_name = "adt7468";
+		break;
 	case emc6d100:
 		type_name = "emc6d100";
 		break;
@@ -1246,10 +1269,11 @@ static int lm85_probe(struct i2c_client 
 	if (err)
 		goto err_kfree;
 
-	/* The ADT7463 has an optional VRM 10 mode where pin 21 is used
+	/* The ADT7463/68 have an optional VRM 10 mode where pin 21 is used
 	   as a sixth digital VID input rather than an analog input. */
 	data->vid = lm85_read_value(client, LM85_REG_VID);
-	if (!(data->type == adt7463 && (data->vid & 0x80)))
+	if (!((data->type == adt7463 || data->type == adt7468) &&
+	    (data->vid & 0x80)))
 		if ((err = sysfs_create_group(&client->dev.kobj,
 					&lm85_group_in4)))
 			goto err_remove_files;
@@ -1357,7 +1381,8 @@ static struct lm85_data *lm85_update_dev
 		 * There are 2 additional resolution bits per channel and we
 		 * have room for 4, so we shift them to the left.
 		 */
-		if (data->type == adm1027 || data->type == adt7463) {
+		if (data->type == adm1027 || data->type == adt7463 ||
+		    data->type == adt7468) {
 			int ext1 = lm85_read_value(client,
 						   ADM1027_REG_EXTEND_ADC1);
 			int ext2 =  lm85_read_value(client,
@@ -1382,16 +1407,23 @@ static struct lm85_data *lm85_update_dev
 			    lm85_read_value(client, LM85_REG_FAN(i));
 		}
 
-		if (!(data->type == adt7463 && (data->vid & 0x80))) {
+		if (!((data->type == adt7463 || data->type == adt7468) &&
+		    (data->vid & 0x80))) {
 			data->in[4] = lm85_read_value(client,
 				      LM85_REG_IN(4));
 		}
 
+		if (data->type == adt7468)
+			data->cfg5 = lm85_read_value(client, ADT7468_REG_CFG5);
+
 		for (i = 0; i <= 2; ++i) {
 			data->temp[i] =
 			    lm85_read_value(client, LM85_REG_TEMP(i));
 			data->pwm[i] =
 			    lm85_read_value(client, LM85_REG_PWM(i));
+
+			if (IS_ADT7468_OFF64(data))
+				data->temp[i] -= 64;
 		}
 
 		data->alarms = lm85_read_value(client, LM85_REG_ALARM1);
@@ -1446,7 +1478,8 @@ static struct lm85_data *lm85_update_dev
 			    lm85_read_value(client, LM85_REG_FAN_MIN(i));
 		}
 
-		if (!(data->type == adt7463 && (data->vid & 0x80))) {
+		if (!((data->type == adt7463 || data->type == adt7468) &&
+		    (data->vid & 0x80))) {
 			data->in_min[4] = lm85_read_value(client,
 					  LM85_REG_IN_MIN(4));
 			data->in_max[4] = lm85_read_value(client,
@@ -1481,6 +1514,13 @@ static struct lm85_data *lm85_update_dev
 			    lm85_read_value(client, LM85_REG_AFAN_LIMIT(i));
 			data->zone[i].critical =
 			    lm85_read_value(client, LM85_REG_AFAN_CRITICAL(i));
+
+			if (IS_ADT7468_OFF64(data)) {
+				data->temp_min[i] -= 64;
+				data->temp_max[i] -= 64;
+				data->zone[i].limit -= 64;
+				data->zone[i].critical -= 64;
+			}
 		}
 
 		i = lm85_read_value(client, LM85_REG_AFAN_SPIKE1);
_

Patches currently in -mm which might be from djwong@us.ibm.com are

ibmpex-add-endian-annotation-to-extract_data-helper.patch
adt7462-new-hwmon-driver.patch
i5k_amb-load-automatically-on-all-5000-5400-chipsets.patch
adt7470-check-input-range-when-sysfs-files-are-written.patch
adt7473-check-inputs-from-sysfs-writes.patch
lm85-support-adt7468-chips.patch

