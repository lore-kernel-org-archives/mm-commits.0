From: akpm@linux-foundation.org
Subject: + dmi-id-fix-for-__you_cannot_kmalloc_that_much-failure.patch added to -mm tree
Date: Tue, 08 Jan 2008 02:12:55 -0800
Message-ID: <200801081012.m08ACZBM006634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750707AbYAHKMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2008 05:12:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, airlied@linux.ie


The patch titled
     dmi-id: fix for __you_cannot_kmalloc_that_much failure
has been added to the -mm tree.  Its filename is
     dmi-id-fix-for-__you_cannot_kmalloc_that_much-failure.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmi-id: fix for __you_cannot_kmalloc_that_much failure
From: Jean Delvare <khali@linux-fr.org>

gcc 3.2 has a hard time coping with the code in dmi_id_init():

drivers/built-in.o(.init.text+0x789e): In function `dmi_id_init':
: undefined reference to `__you_cannot_kmalloc_that_much'
make: *** [.tmp_vmlinux1] Error 1

Moving half of the code to a separate function seems to help.  This is a
no-op for gcc 4.1 which will successfully inline the code anyway.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi-id.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff -puN drivers/firmware/dmi-id.c~dmi-id-fix-for-__you_cannot_kmalloc_that_much-failure drivers/firmware/dmi-id.c
--- a/drivers/firmware/dmi-id.c~dmi-id-fix-for-__you_cannot_kmalloc_that_much-failure
+++ a/drivers/firmware/dmi-id.c
@@ -175,12 +175,11 @@ static struct device *dmi_dev;
 
 extern int dmi_available;
 
-static int __init dmi_id_init(void)
+/* In a separate function to keep gcc 3.2 happy - do NOT merge this in
+   dmi_id_init! */
+static void __init dmi_id_init_attr_table(void)
 {
-	int ret, i;
-
-	if (!dmi_available)
-		return -ENODEV;
+	int i;
 
 	/* Not necessarily all DMI fields are available on all
 	 * systems, hence let's built an attribute table of just
@@ -205,6 +204,16 @@ static int __init dmi_id_init(void)
 	ADD_DMI_ATTR(chassis_serial,    DMI_CHASSIS_SERIAL);
 	ADD_DMI_ATTR(chassis_asset_tag, DMI_CHASSIS_ASSET_TAG);
 	sys_dmi_attributes[i++] = &sys_dmi_modalias_attr.attr;
+}
+
+static int __init dmi_id_init(void)
+{
+	int ret;
+
+	if (!dmi_available)
+		return -ENODEV;
+
+	dmi_id_init_attr_table();
 
 	ret = class_register(&dmi_class);
 	if (ret)
_

Patches currently in -mm which might be from khali@linux-fr.org are

dmi-id-fix-for-__you_cannot_kmalloc_that_much-failure.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
export-acpi_check_resource_conflict.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
git-arm.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
oz99x-i2c-button-and-led-support-driver.patch
oz99x-i2c-button-and-led-support-driver-update.patch
git-hwmon.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
rtc-add-support-for-the-s-35390a-rtc-chip-update.patch
