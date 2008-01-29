From: akpm@linux-foundation.org
Subject: - dmi-let-drivers-walk-the-dmi-table.patch removed from -mm tree
Date: Mon, 28 Jan 2008 17:50:45 -0800
Message-ID: <200801290150.m0T1ojq1027592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42627 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755814AbYA2B7U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 20:59:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     dmi: let drivers walk the DMI table
has been removed from the -mm tree.  Its filename was
     dmi-let-drivers-walk-the-dmi-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmi: let drivers walk the DMI table
From: Jean Delvare <khali@linux-fr.org>

Let drivers walk the DMI table for their own needs.  Some drivers need data
stored in OEM-specific DMI records for proper operation.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi_scan.c |   62 ++++++++++++++++++++++++++--------
 include/linux/dmi.h         |    4 +-
 2 files changed, 51 insertions(+), 15 deletions(-)

diff -puN drivers/firmware/dmi_scan.c~dmi-let-drivers-walk-the-dmi-table drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~dmi-let-drivers-walk-the-dmi-table
+++ a/drivers/firmware/dmi_scan.c
@@ -43,18 +43,12 @@ static char * __init dmi_string(const st
  *	We have to be cautious here. We have seen BIOSes with DMI pointers
  *	pointing to completely the wrong place for example
  */
-static int __init dmi_table(u32 base, int len, int num,
-			    void (*decode)(const struct dmi_header *))
+static void dmi_table(u8 *buf, int len, int num,
+		      void (*decode)(const struct dmi_header *))
 {
-	u8 *buf, *data;
+	u8 *data = buf;
 	int i = 0;
 
-	buf = dmi_ioremap(base, len);
-	if (buf == NULL)
-		return -1;
-
-	data = buf;
-
 	/*
 	 *	Stop when we see all the items the table claimed to have
 	 *	OR we run off the end of the table (also happens)
@@ -75,7 +69,23 @@ static int __init dmi_table(u32 base, in
 		data += 2;
 		i++;
 	}
-	dmi_iounmap(buf, len);
+}
+
+static u32 dmi_base;
+static u16 dmi_len;
+static u16 dmi_num;
+
+static int __init dmi_walk_early(void (*decode)(const struct dmi_header *))
+{
+	u8 *buf;
+
+	buf = dmi_ioremap(dmi_base, dmi_len);
+	if (buf == NULL)
+		return -1;
+
+	dmi_table(buf, dmi_len, dmi_num, decode);
+
+	dmi_iounmap(buf, dmi_len);
 	return 0;
 }
 
@@ -291,9 +301,9 @@ static int __init dmi_present(const char
 
 	memcpy_fromio(buf, p, 15);
 	if ((memcmp(buf, "_DMI_", 5) == 0) && dmi_checksum(buf)) {
-		u16 num = (buf[13] << 8) | buf[12];
-		u16 len = (buf[7] << 8) | buf[6];
-		u32 base = (buf[11] << 24) | (buf[10] << 16) |
+		dmi_num = (buf[13] << 8) | buf[12];
+		dmi_len = (buf[7] << 8) | buf[6];
+		dmi_base = (buf[11] << 24) | (buf[10] << 16) |
 			(buf[9] << 8) | buf[8];
 
 		/*
@@ -305,7 +315,7 @@ static int __init dmi_present(const char
 			       buf[14] >> 4, buf[14] & 0xF);
 		else
 			printk(KERN_INFO "DMI present.\n");
-		if (dmi_table(base,len, num, dmi_decode) == 0)
+		if (dmi_walk_early(dmi_decode) == 0)
 			return 0;
 	}
 	return 1;
@@ -508,3 +518,27 @@ int dmi_dump_entries(int entries)
 	}
 	return 0;
 }
+
+/**
+ *	dmi_walk - Walk the DMI table and get called back for every record
+ *	@decode: Callback function
+ *
+ *	Returns -1 when the DMI table can't be reached, 0 on success.
+ */
+int dmi_walk(void (*decode)(const struct dmi_header *))
+{
+	u8 *buf;
+
+	if (!dmi_available)
+		return -1;
+
+	buf = ioremap(dmi_base, dmi_len);
+	if (buf == NULL)
+		return -1;
+
+	dmi_table(buf, dmi_len, dmi_num, decode);
+
+	iounmap(buf);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dmi_walk);
diff -puN include/linux/dmi.h~dmi-let-drivers-walk-the-dmi-table include/linux/dmi.h
--- a/include/linux/dmi.h~dmi-let-drivers-walk-the-dmi-table
+++ a/include/linux/dmi.h
@@ -80,6 +80,7 @@ extern int dmi_get_year(int field);
 extern int dmi_name_in_vendors(const char *str);
 extern int dmi_available;
 extern int dmi_dump_entries(int entries);
+extern int dmi_walk(void (*decode)(const struct dmi_header *));
 
 #else
 
@@ -91,7 +92,8 @@ static inline int dmi_get_year(int year)
 static inline int dmi_name_in_vendors(const char *s) { return 0; }
 #define dmi_available 0
 static inline int dmi_dump_entries(int entries) { return -1; }
-
+static inline int dmi_walk(void (*decode)(const struct dmi_header *))
+	{ return -1; }
 #endif
 
 #endif	/* __DMI_H__ */
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
git-arm.patch
oz99x-i2c-button-and-led-support-driver.patch
oz99x-i2c-button-and-led-support-driver-update.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-1.patch
i2c-isp1301_omap-new-style-i2c-driver-updates-part-2.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip-fix.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-checkpatch-fixes.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-update.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-update-2.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
smbios-dmi-add-type-41-=-onboard-devices-extended-information.patch
