From: akpm@linux-foundation.org
Subject: + i5k_amb-provide-labels-for-temperature-sensors.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:51:01 -0700
Message-ID: <200807310351.m6V3p11Z002494@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44141 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760382AbYGaDv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, khali@linux-fr.org, mhoffman@lightlink.com


The patch titled
     i5k_amb: provide labels for temperature sensors
has been added to the -mm tree.  Its filename is
     i5k_amb-provide-labels-for-temperature-sensors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i5k_amb: provide labels for temperature sensors
From: "Darrick J. Wong" <djwong@us.ibm.com>

Export the sensor -> channel/dimm mapping in tempX_label.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/i5k_amb.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN drivers/hwmon/i5k_amb.c~i5k_amb-provide-labels-for-temperature-sensors drivers/hwmon/i5k_amb.c
--- a/drivers/hwmon/i5k_amb.c~i5k_amb-provide-labels-for-temperature-sensors
+++ a/drivers/hwmon/i5k_amb.c
@@ -81,6 +81,8 @@ static unsigned long amb_reg_temp(unsign
 #define MAX_AMBS_PER_CHANNEL		16
 #define MAX_AMBS			(MAX_MEM_CHANNELS * \
 					 MAX_AMBS_PER_CHANNEL)
+#define CHANNEL_SHIFT			4
+#define DIMM_MASK			0xF
 /*
  * Ugly hack: For some reason the highest bit is set if there
  * are _any_ DIMMs in the channel.  Attempting to read from
@@ -89,7 +91,7 @@ static unsigned long amb_reg_temp(unsign
  * might prevent us from seeing the 16th DIMM in the channel.
  */
 #define REAL_MAX_AMBS_PER_CHANNEL	15
-#define KNOBS_PER_AMB			5
+#define KNOBS_PER_AMB			6
 
 static unsigned long amb_num_from_reg(unsigned int byte_num, unsigned int bit)
 {
@@ -238,6 +240,16 @@ static ssize_t show_amb_temp(struct devi
 		500 * amb_read_byte(data, amb_reg_temp(attr->index)));
 }
 
+static ssize_t show_label(struct device *dev,
+			  struct device_attribute *devattr,
+			  char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+
+	return sprintf(buf, "Ch. %d DIMM %d\n", attr->index >> CHANNEL_SHIFT,
+		       attr->index & DIMM_MASK);
+}
+
 static int __devinit i5k_amb_hwmon_init(struct platform_device *pdev)
 {
 	int i, j, k, d = 0;
@@ -268,6 +280,20 @@ static int __devinit i5k_amb_hwmon_init(
 				continue;
 			d++;
 
+			/* sysfs label */
+			iattr = data->attrs + data->num_attrs;
+			snprintf(iattr->name, AMB_SYSFS_NAME_LEN,
+				 "temp%d_label", d);
+			iattr->s_attr.dev_attr.attr.name = iattr->name;
+			iattr->s_attr.dev_attr.attr.mode = S_IRUGO;
+			iattr->s_attr.dev_attr.show = show_label;
+			iattr->s_attr.index = k;
+			res = device_create_file(&pdev->dev,
+						 &iattr->s_attr.dev_attr);
+			if (res)
+				goto exit_remove;
+			data->num_attrs++;
+
 			/* Temperature sysfs knob */
 			iattr = data->attrs + data->num_attrs;
 			snprintf(iattr->name, AMB_SYSFS_NAME_LEN,
_

Patches currently in -mm which might be from djwong@us.ibm.com are

linux-next.patch
i5k_amb-provide-labels-for-temperature-sensors.patch

