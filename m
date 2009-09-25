From: akpm@linux-foundation.org
Subject: [to-be-updated] asus_atk0110-add-support-for-asus-p7p55d.patch removed from -mm tree
Date: Fri, 25 Sep 2009 11:17:10 -0700
Message-ID: <200909251817.n8PIHApN006663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166AbZIYSRc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Sep 2009 14:17:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kronos.it@gmail.com, hancockrwd@gmail.com, hdegoede@redhat.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     asus_atk0110: add support for Asus P7P55D
has been removed from the -mm tree.  Its filename was
     asus_atk0110-add-support-for-asus-p7p55d.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asus_atk0110: add support for Asus P7P55D
From: Luca Tettamanti <kronos.it@gmail.com>

With P7P55D (and newer) boards Asus extended the output buffer (ASBF)
making the driver unable to read the data from the sensors.  Change the
driver to use dynamic buffers (allocated by ACPI core); the return value
is cached, so the number of memory allocations is very low.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Tested-by: Robert Hancock <hancockrwd@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/asus_atk0110.c |   50 ++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff -puN drivers/hwmon/asus_atk0110.c~asus_atk0110-add-support-for-asus-p7p55d drivers/hwmon/asus_atk0110.c
--- a/drivers/hwmon/asus_atk0110.c~asus_atk0110-add-support-for-asus-p7p55d
+++ a/drivers/hwmon/asus_atk0110.c
@@ -129,9 +129,15 @@ struct atk_sensor_data {
 	char const *acpi_name;
 };
 
-struct atk_acpi_buffer_u64 {
-	union acpi_object buf;
-	u64 value;
+/* Return buffer format:
+ * [0-3] "value" is valid flag
+ * [4-7] value
+ * [8- ] unknown stuff on newer mobos
+ */
+struct atk_acpi_ret_buffer {
+	u32 flags;
+	u32 value;
+	u8 data[];
 };
 
 static int atk_add(struct acpi_device *device);
@@ -446,8 +452,10 @@ static int atk_read_value_new(struct atk
 	struct acpi_object_list params;
 	struct acpi_buffer ret;
 	union acpi_object id;
-	struct atk_acpi_buffer_u64 tmp;
+	union acpi_object *obj;
+	struct atk_acpi_ret_buffer *buf;
 	acpi_status status;
+	int err = 0;
 
 	id.type = ACPI_TYPE_INTEGER;
 	id.integer.value = sensor->id;
@@ -455,11 +463,7 @@ static int atk_read_value_new(struct atk
 	params.count = 1;
 	params.pointer = &id;
 
-	tmp.buf.type = ACPI_TYPE_BUFFER;
-	tmp.buf.buffer.pointer = (u8 *)&tmp.value;
-	tmp.buf.buffer.length = sizeof(u64);
-	ret.length = sizeof(tmp);
-	ret.pointer = &tmp;
+	ret.length = ACPI_ALLOCATE_BUFFER;
 
 	status = acpi_evaluate_object_typed(data->read_handle, NULL, &params,
 			&ret, ACPI_TYPE_BUFFER);
@@ -468,23 +472,31 @@ static int atk_read_value_new(struct atk
 				acpi_format_exception(status));
 		return -EIO;
 	}
+	obj = ret.pointer;
 
-	/* Return buffer format:
-	 * [0-3] "value" is valid flag
-	 * [4-7] value
-	 */
-	if (!(tmp.value & 0xffffffff)) {
+	/* Sanity check */
+	if (obj->buffer.length < 8) {
+		dev_warn(dev, "Unexpected ASBF length: %u\n",
+				obj->buffer.length);
+		err = -EIO;
+		goto out;
+	}
+	buf = (struct atk_acpi_ret_buffer *)obj->buffer.pointer;
+
+	if (!buf->flags) {
 		/* The reading is not valid, possible causes:
 		 * - sensor failure
 		 * - enumeration was FUBAR (and we didn't notice)
 		 */
-		dev_info(dev, "Failure: %#llx\n", tmp.value);
-		return -EIO;
+		dev_warn(dev, "Failure: %#x\n", buf->flags);
+		err = -EIO;
+		goto out;
 	}
 
-	*value = (tmp.value & 0xffffffff00000000ULL) >> 32;
