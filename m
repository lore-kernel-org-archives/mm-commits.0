From: akpm@linux-foundation.org
Subject: - check-for-acpi-resource-conflicts-in-hwmon-drivers.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:16:12 -0800
Message-ID: <200802132016.m1DKGDZm011440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36505 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388AbYBMUZJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:25:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, lenb@kernel.org, mhoffman@lightlink.com, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     Check for ACPI resource conflicts in hwmon drivers
has been removed from the -mm tree.  Its filename was
     check-for-acpi-resource-conflicts-in-hwmon-drivers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Check for ACPI resource conflicts in hwmon drivers
From: Jean Delvare <jdelvare@suse.de>

Check for ACPI resource conflicts in hwmon drivers. I've included
all Super-I/O and PCI drivers.

I've voluntarily left out:
* Laptop specific and vendor-specific drivers: if they conflicted
  on any system, this would pretty much mean that they conflict on all
  systems, and we would know by now.
* Legacy ISA drivers (lm78 and w83781d): they only support chips found
  on old designs were ACPI either wasn't supported or didn't deal with
  thermal management.
* Drivers accessing the I/O resources indirectly (e.g. through SMBus):
  the check will be added where it belongs, i.e. in the bus drivers.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/dme1737.c    |    5 +++++
 drivers/hwmon/f71805f.c    |    5 +++++
 drivers/hwmon/f71882fg.c   |    5 +++++
 drivers/hwmon/it87.c       |    5 +++++
 drivers/hwmon/pc87360.c    |    6 ++++++
 drivers/hwmon/pc87427.c    |    5 +++++
 drivers/hwmon/sis5595.c    |    5 +++++
 drivers/hwmon/smsc47b397.c |    5 +++++
 drivers/hwmon/smsc47m1.c   |    5 +++++
 drivers/hwmon/via686a.c    |    5 +++++
 drivers/hwmon/vt1211.c     |    5 +++++
 drivers/hwmon/vt8231.c     |    5 +++++
 drivers/hwmon/w83627ehf.c  |    6 ++++++
 drivers/hwmon/w83627hf.c   |    5 +++++
 14 files changed, 72 insertions(+)

diff -puN drivers/hwmon/dme1737.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/dme1737.c
--- a/drivers/hwmon/dme1737.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/dme1737.c
@@ -34,6 +34,7 @@
 #include <linux/hwmon-vid.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 /* ISA device, if found */
@@ -2238,6 +2239,10 @@ static int __init dme1737_isa_device_add
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	if (!(pdev = platform_device_alloc("dme1737", addr))) {
 		printk(KERN_ERR "dme1737: Failed to allocate device.\n");
 		err = -ENOMEM;
diff -puN drivers/hwmon/f71805f.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/f71805f.c
--- a/drivers/hwmon/f71805f.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/f71805f.c
@@ -39,6 +39,7 @@
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
 #include <linux/ioport.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static unsigned short force_id;
@@ -1455,6 +1456,10 @@ static int __init f71805f_device_add(uns
 	}
 
 	res.name = pdev->name;
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit_device_put;
+
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
 		printk(KERN_ERR DRVNAME ": Device resource addition failed "
diff -puN drivers/hwmon/f71882fg.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/f71882fg.c
--- a/drivers/hwmon/f71882fg.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/f71882fg.c
@@ -27,6 +27,7 @@
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 #define DRVNAME "f71882fg"
@@ -898,6 +899,10 @@ static int __init f71882fg_device_add(un
 		return -ENOMEM;
 
 	res.name = f71882fg_pdev->name;
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		return err;
+
 	err = platform_device_add_resources(f71882fg_pdev, &res, 1);
 	if (err) {
 		printk(KERN_ERR DRVNAME ": Device resource addition failed\n");
diff -puN drivers/hwmon/it87.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/it87.c
--- a/drivers/hwmon/it87.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/it87.c
@@ -46,6 +46,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 #define DRVNAME "it87"
@@ -1487,6 +1488,10 @@ static int __init it87_device_add(unsign
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
diff -puN drivers/hwmon/pc87360.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/pc87360.c
--- a/drivers/hwmon/pc87360.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/pc87360.c
@@ -43,6 +43,7 @@
 #include <linux/hwmon-vid.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static u8 devid;
@@ -1425,6 +1426,11 @@ static int __init pc87360_device_add(uns
 			continue;
 		res.start = extra_isa[i];
 		res.end = extra_isa[i] + PC87360_EXTENT - 1;
+
+		err = acpi_check_resource_conflict(&res);
+		if (err)
+			goto exit_device_put;
+
 		err = platform_device_add_resources(pdev, &res, 1);
 		if (err) {
 			printk(KERN_ERR "pc87360: Device resource[%d] "
diff -puN drivers/hwmon/pc87427.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/pc87427.c
--- a/drivers/hwmon/pc87427.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/pc87427.c
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
 #include <linux/ioport.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static unsigned short force_id;
@@ -524,6 +525,10 @@ static int __init pc87427_device_add(uns
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
diff -puN drivers/hwmon/sis5595.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/sis5595.c
--- a/drivers/hwmon/sis5595.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/sis5595.c
@@ -62,6 +62,7 @@
 #include <linux/jiffies.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 
@@ -727,6 +728,10 @@ static int __devinit sis5595_device_add(
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc("sis5595", address);
 	if (!pdev) {
 		err = -ENOMEM;
diff -puN drivers/hwmon/smsc47b397.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/smsc47b397.c
--- a/drivers/hwmon/smsc47b397.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/smsc47b397.c
@@ -36,6 +36,7 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static unsigned short force_id;
@@ -303,6 +304,10 @@ static int __init smsc47b397_device_add(
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
diff -puN drivers/hwmon/smsc47m1.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/smsc47m1.c
--- a/drivers/hwmon/smsc47m1.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/smsc47m1.c
@@ -37,6 +37,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static unsigned short force_id;
@@ -686,6 +687,10 @@ static int __init smsc47m1_device_add(un
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
diff -puN drivers/hwmon/via686a.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/via686a.c
--- a/drivers/hwmon/via686a.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/via686a.c
@@ -41,6 +41,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 
@@ -755,6 +756,10 @@ static int __devinit via686a_device_add(
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc("via686a", address);
 	if (!pdev) {
 		err = -ENOMEM;
diff -puN drivers/hwmon/vt1211.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/vt1211.c
--- a/drivers/hwmon/vt1211.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/vt1211.c
@@ -32,6 +32,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/ioport.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static int uch_config = -1;
@@ -1259,6 +1260,10 @@ static int __init vt1211_device_add(unsi
 	}
 
 	res.name = pdev->name;
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto EXIT;
+
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
 		printk(KERN_ERR DRVNAME ": Device resource addition failed "
diff -puN drivers/hwmon/vt8231.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/vt8231.c
--- a/drivers/hwmon/vt8231.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/vt8231.c
@@ -35,6 +35,7 @@
 #include <linux/hwmon-vid.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static int force_addr;
@@ -858,6 +859,10 @@ static int __devinit vt8231_device_add(u
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc("vt8231", address);
 	if (!pdev) {
 		err = -ENOMEM;
diff -puN drivers/hwmon/w83627ehf.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/w83627ehf.c
--- a/drivers/hwmon/w83627ehf.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/w83627ehf.c
@@ -48,6 +48,7 @@
 #include <linux/hwmon-vid.h>
 #include <linux/err.h>
 #include <linux/mutex.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 #include "lm75.h"
 
@@ -1544,6 +1545,11 @@ static int __init sensors_w83627ehf_init
 	res.start = address + IOREGION_OFFSET;
 	res.end = address + IOREGION_OFFSET + IOREGION_LENGTH - 1;
 	res.flags = IORESOURCE_IO;
+
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	err = platform_device_add_resources(pdev, &res, 1);
 	if (err) {
 		printk(KERN_ERR DRVNAME ": Device resource addition failed "
diff -puN drivers/hwmon/w83627hf.c~check-for-acpi-resource-conflicts-in-hwmon-drivers drivers/hwmon/w83627hf.c
--- a/drivers/hwmon/w83627hf.c~check-for-acpi-resource-conflicts-in-hwmon-drivers
+++ a/drivers/hwmon/w83627hf.c
@@ -50,6 +50,7 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/ioport.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 #include "lm75.h"
 
@@ -1746,6 +1747,10 @@ static int __init w83627hf_device_add(un
 	};
 	int err;
 
+	err = acpi_check_resource_conflict(&res);
+	if (err)
+		goto exit;
+
 	pdev = platform_device_alloc(DRVNAME, address);
 	if (!pdev) {
 		err = -ENOMEM;
_

Patches currently in -mm which might be from jdelvare@suse.de are

check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
git-hwmon.patch
