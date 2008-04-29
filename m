From: akpm@linux-foundation.org
Subject: - check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:13:22 -0700
Message-ID: <200804290513.m3T5DMtQ002457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470AbYD2FNx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:13:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdelvare@suse.de, lenb@kernel.org, mhoffman@lightlink.com, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     Check for ACPI resource conflicts in i2c bus drivers
has been removed from the -mm tree.  Its filename was
     check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Check for ACPI resource conflicts in i2c bus drivers
From: Jean Delvare <jdelvare@suse.de>

Check for ACPI resource conflicts in i2c bus drivers. I've included
all recent SMBus master drivers for PC hardware.

I've voluntarily left out:
* Drivers that don't run on PCs: they can't conflict with ACPI.
* Bit-banged bus device drivers: it's very unlikely that ACPI would
  deal with such buses.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/i2c/busses/i2c-ali1535.c |    6 ++++++
 drivers/i2c/busses/i2c-ali1563.c |    5 +++++
 drivers/i2c/busses/i2c-ali15x3.c |    5 +++++
 drivers/i2c/busses/i2c-amd756.c  |    6 ++++++
 drivers/i2c/busses/i2c-amd8111.c |    5 +++++
 drivers/i2c/busses/i2c-i801.c    |    5 +++++
 drivers/i2c/busses/i2c-nforce2.c |    6 ++++++
 drivers/i2c/busses/i2c-piix4.c   |    4 ++++
 drivers/i2c/busses/i2c-sis5595.c |    6 ++++++
 drivers/i2c/busses/i2c-sis630.c  |    6 ++++++
 drivers/i2c/busses/i2c-sis96x.c  |    5 +++++
 drivers/i2c/busses/i2c-viapro.c  |    5 +++++
 12 files changed, 64 insertions(+)

diff -puN drivers/i2c/busses/i2c-ali1535.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers drivers/i2c/busses/i2c-ali1535.c
--- a/drivers/i2c/busses/i2c-ali1535.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers
+++ a/drivers/i2c/busses/i2c-ali1535.c
@@ -61,6 +61,7 @@
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 
@@ -159,6 +160,11 @@ static int ali1535_setup(struct pci_dev 
 		goto exit;
 	}
 
+	retval = acpi_check_region(ali1535_smba, ALI1535_SMB_IOSIZE,
+				   ali1535_driver.name);
+	if (retval)
+		goto exit;
+
 	if (!request_region(ali1535_smba, ALI1535_SMB_IOSIZE,
 			    ali1535_driver.name)) {
 		dev_err(&dev->dev, "ALI1535_smb region 0x%x already in use!\n",
diff -puN drivers/i2c/busses/i2c-ali1563.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers drivers/i2c/busses/i2c-ali1563.c
--- a/drivers/i2c/busses/i2c-ali1563.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers
+++ a/drivers/i2c/busses/i2c-ali1563.c
@@ -21,6 +21,7 @@
 #include <linux/i2c.h>
 #include <linux/pci.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 
 #define ALI1563_MAX_TIMEOUT	500
 #define	ALI1563_SMBBA		0x80
@@ -345,6 +346,10 @@ static int __devinit ali1563_setup(struc
 		}
 	}
 
+	if (acpi_check_region(ali1563_smba, ALI1563_SMB_IOSIZE,
+			      ali1563_pci_driver.name))
+		goto Err;
+
 	if (!request_region(ali1563_smba, ALI1563_SMB_IOSIZE,
 			    ali1563_pci_driver.name)) {
 		dev_err(&dev->dev, "Could not allocate I/O space at 0x%04x\n",
diff -puN drivers/i2c/busses/i2c-ali15x3.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers drivers/i2c/busses/i2c-ali15x3.c
--- a/drivers/i2c/busses/i2c-ali15x3.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers
+++ a/drivers/i2c/busses/i2c-ali15x3.c
@@ -68,6 +68,7 @@
 #include <linux/delay.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 /* ALI15X3 SMBus address offsets */
@@ -166,6 +167,10 @@ static int ali15x3_setup(struct pci_dev 
 	if(force_addr)
 		ali15x3_smba = force_addr & ~(ALI15X3_SMB_IOSIZE - 1);
 
+	if (acpi_check_region(ali15x3_smba, ALI15X3_SMB_IOSIZE,
+			      ali15x3_driver.name))
+		return -EBUSY;
+
 	if (!request_region(ali15x3_smba, ALI15X3_SMB_IOSIZE,
 			    ali15x3_driver.name)) {
 		dev_err(&ALI15X3_dev->dev,
diff -puN drivers/i2c/busses/i2c-amd756.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers drivers/i2c/busses/i2c-amd756.c
--- a/drivers/i2c/busses/i2c-amd756.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers
+++ a/drivers/i2c/busses/i2c-amd756.c
@@ -45,6 +45,7 @@
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 /* AMD756 SMBus address offsets */
@@ -368,6 +369,11 @@ static int __devinit amd756_probe(struct
 		amd756_ioport += SMB_ADDR_OFFSET;
 	}
 
+	error = acpi_check_region(amd756_ioport, SMB_IOSIZE,
+				  amd756_driver.name);
+	if (error)
+		return error;
+
 	if (!request_region(amd756_ioport, SMB_IOSIZE, amd756_driver.name)) {
 		dev_err(&pdev->dev, "SMB region 0x%x already in use!\n",
 			amd756_ioport);
diff -puN drivers/i2c/busses/i2c-amd8111.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers drivers/i2c/busses/i2c-amd8111.c
--- a/drivers/i2c/busses/i2c-amd8111.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers
+++ a/drivers/i2c/busses/i2c-amd8111.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 MODULE_LICENSE("GPL");
@@ -359,6 +360,10 @@ static int __devinit amd8111_probe(struc
 	smbus->base = pci_resource_start(dev, 0);
 	smbus->size = pci_resource_len(dev, 0);
 
+	error = acpi_check_resource_conflict(&dev->resource[0]);
+	if (error)
+		goto out_kfree;
+
 	if (!request_region(smbus->base, smbus->size, amd8111_driver.name)) {
 		error = -EBUSY;
 		goto out_kfree;
diff -puN drivers/i2c/busses/i2c-i801.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers drivers/i2c/busses/i2c-i801.c
--- a/drivers/i2c/busses/i2c-i801.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers
+++ a/drivers/i2c/busses/i2c-i801.c
@@ -64,6 +64,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 /* I801 SMBus address offsets */
@@ -639,6 +640,10 @@ static int __devinit i801_probe(struct p
 		goto exit;
 	}
 
+	err = acpi_check_resource_conflict(&dev->resource[SMBBAR]);
+	if (err)
+		goto exit;
+
 	err = pci_request_region(dev, SMBBAR, i801_driver.name);
 	if (err) {
 		dev_err(&dev->dev, "Failed to request SMBus region "
diff -puN drivers/i2c/busses/i2c-nforce2.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers drivers/i2c/busses/i2c-nforce2.c
--- a/drivers/i2c/busses/i2c-nforce2.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers
+++ a/drivers/i2c/busses/i2c-nforce2.c
@@ -50,6 +50,7 @@
 #include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 MODULE_LICENSE("GPL");
@@ -315,6 +316,11 @@ static int __devinit nforce2_probe_smb (
 		smbus->size = 64;
 	}
 
+	error = acpi_check_region(smbus->base, smbus->size,
+				  nforce2_driver.name);
+	if (error)
+		return -1;
+
 	if (!request_region(smbus->base, smbus->size, nforce2_driver.name)) {
 		dev_err(&smbus->adapter.dev, "Error requesting region %02x .. %02X for %s\n",
 			smbus->base, smbus->base+smbus->size-1, name);
diff -puN drivers/i2c/busses/i2c-piix4.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers drivers/i2c/busses/i2c-piix4.c
--- a/drivers/i2c/busses/i2c-piix4.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers
+++ a/drivers/i2c/busses/i2c-piix4.c
@@ -40,6 +40,7 @@
 #include <linux/init.h>
 #include <linux/apm_bios.h>
 #include <linux/dmi.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 
@@ -147,6 +148,9 @@ static int __devinit piix4_setup(struct 
 		}
 	}
 
+	if (acpi_check_region(piix4_smba, SMBIOSIZE, piix4_driver.name))
+		return -EBUSY;
+
 	if (!request_region(piix4_smba, SMBIOSIZE, piix4_driver.name)) {
 		dev_err(&PIIX4_dev->dev, "SMB region 0x%x already in use!\n",
 			piix4_smba);
diff -puN drivers/i2c/busses/i2c-sis5595.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers drivers/i2c/busses/i2c-sis5595.c
--- a/drivers/i2c/busses/i2c-sis5595.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers
+++ a/drivers/i2c/busses/i2c-sis5595.c
@@ -62,6 +62,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static int blacklist[] = {
@@ -174,6 +175,11 @@ static int sis5595_setup(struct pci_dev 
 
 	/* NB: We grab just the two SMBus registers here, but this may still
 	 * interfere with ACPI :-(  */
+	retval = acpi_check_region(sis5595_base + SMB_INDEX, 2,
+				   sis5595_driver.name);
+	if (retval)
+		return retval;
+
 	if (!request_region(sis5595_base + SMB_INDEX, 2,
 			    sis5595_driver.name)) {
 		dev_err(&SIS5595_dev->dev, "SMBus registers 0x%04x-0x%04x already in use!\n",
diff -puN drivers/i2c/busses/i2c-sis630.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers drivers/i2c/busses/i2c-sis630.c
--- a/drivers/i2c/busses/i2c-sis630.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers
+++ a/drivers/i2c/busses/i2c-sis630.c
@@ -55,6 +55,7 @@
 #include <linux/ioport.h>
 #include <linux/init.h>
 #include <linux/i2c.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 /* SIS630 SMBus registers */
@@ -433,6 +434,11 @@ static int sis630_setup(struct pci_dev *
 
 	dev_dbg(&sis630_dev->dev, "ACPI base at 0x%04x\n", acpi_base);
 
+	retval = acpi_check_region(acpi_base + SMB_STS, SIS630_SMB_IOREGION,
+				   sis630_driver.name);
+	if (retval)
+		goto exit;
+
 	/* Everything is happy, let's grab the memory and set things up. */
 	if (!request_region(acpi_base + SMB_STS, SIS630_SMB_IOREGION,
 			    sis630_driver.name)) {
diff -puN drivers/i2c/busses/i2c-sis96x.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers drivers/i2c/busses/i2c-sis96x.c
--- a/drivers/i2c/busses/i2c-sis96x.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers
+++ a/drivers/i2c/busses/i2c-sis96x.c
@@ -40,6 +40,7 @@
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 /* base address register in PCI config space */
@@ -286,6 +287,10 @@ static int __devinit sis96x_probe(struct
 	dev_info(&dev->dev, "SiS96x SMBus base address: 0x%04x\n",
 			sis96x_smbus_base);
 
+	retval = acpi_check_resource_conflict(&dev->resource[SIS96x_BAR]);
+	if (retval)
+		return retval;
+
 	/* Everything is happy, let's grab the memory and set things up. */
 	if (!request_region(sis96x_smbus_base, SMB_IOSIZE,
 			    sis96x_driver.name)) {
diff -puN drivers/i2c/busses/i2c-viapro.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers drivers/i2c/busses/i2c-viapro.c
--- a/drivers/i2c/busses/i2c-viapro.c~check-for-acpi-resource-conflicts-in-i2c-bus-drivers
+++ a/drivers/i2c/busses/i2c-viapro.c
@@ -50,6 +50,7 @@
 #include <linux/ioport.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/acpi.h>
 #include <asm/io.h>
 
 static struct pci_dev *vt596_pdev;
@@ -354,6 +355,10 @@ static int __devinit vt596_probe(struct 
 	}
 
 found:
+	error = acpi_check_region(vt596_smba, 8, vt596_driver.name);
+	if (error)
+		return error;
+
 	if (!request_region(vt596_smba, 8, vt596_driver.name)) {
 		dev_err(&pdev->dev, "SMBus region 0x%x already in use!\n",
 			vt596_smba);
_

Patches currently in -mm which might be from jdelvare@suse.de are

check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
git-hwmon.patch

