From: akpm@linux-foundation.org
Subject: - i5k_amb-support-intel-5400-chipset.patch removed from -mm tree
Date: Tue, 27 May 2008 00:26:49 -0700
Message-ID: <200805270726.m4R7Qn6U014704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756409AbYE0HgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 03:36:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     i5k_amb: support Intel 5400 chipset
has been removed from the -mm tree.  Its filename was
     i5k_amb-support-intel-5400-chipset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i5k_amb: support Intel 5400 chipset
From: "Darrick J. Wong" <djwong@us.ibm.com>

Minor rework to support the Intel 5400 chipset.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/i5k_amb.c |   39 +++++++++++++++++++++++++++++++++-----
 include/linux/pci_ids.h |    3 ++
 2 files changed, 37 insertions(+), 5 deletions(-)

diff -puN drivers/hwmon/i5k_amb.c~i5k_amb-support-intel-5400-chipset drivers/hwmon/i5k_amb.c
--- a/drivers/hwmon/i5k_amb.c~i5k_amb-support-intel-5400-chipset
+++ a/drivers/hwmon/i5k_amb.c
@@ -111,6 +111,7 @@ struct i5k_amb_data {
 	void __iomem *amb_mmio;
 	struct i5k_device_attribute *attrs;
 	unsigned int num_attrs;
+	unsigned long chipset_id;
 };
 
 static ssize_t show_name(struct device *dev, struct device_attribute *devattr,
@@ -382,7 +383,8 @@ err:
 	return res;
 }
 
-static int __devinit i5k_find_amb_registers(struct i5k_amb_data *data)
+static int __devinit i5k_find_amb_registers(struct i5k_amb_data *data,
+					    unsigned long devid)
 {
 	struct pci_dev *pcidev;
 	u32 val32;
@@ -390,7 +392,7 @@ static int __devinit i5k_find_amb_regist
 
 	/* Find AMB register memory space */
 	pcidev = pci_get_device(PCI_VENDOR_ID_INTEL,
-				PCI_DEVICE_ID_INTEL_5000_ERR,
+				devid,
 				NULL);
 	if (!pcidev)
 		return -ENODEV;
@@ -409,6 +411,8 @@ static int __devinit i5k_find_amb_regist
 		goto out;
 	}
 
+	data->chipset_id = devid;
+
 	res = 0;
 out:
 	pci_dev_put(pcidev);
@@ -441,10 +445,30 @@ out:
 	return res;
 }
 
+static unsigned long i5k_channel_pci_id(struct i5k_amb_data *data,
+					unsigned long channel)
+{
+	switch (data->chipset_id) {
+	case PCI_DEVICE_ID_INTEL_5000_ERR:
+		return PCI_DEVICE_ID_INTEL_5000_FBD0 + channel;
+	case PCI_DEVICE_ID_INTEL_5400_ERR:
+		return PCI_DEVICE_ID_INTEL_5400_FBD0 + channel;
+	default:
+		BUG();
+	}
+}
+
+static unsigned long chipset_ids[] = {
+	PCI_DEVICE_ID_INTEL_5000_ERR,
+	PCI_DEVICE_ID_INTEL_5400_ERR,
+	0
+};
+
 static int __devinit i5k_amb_probe(struct platform_device *pdev)
 {
 	struct i5k_amb_data *data;
 	struct resource *reso;
+	int i;
 	int res = -ENODEV;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
@@ -452,19 +476,24 @@ static int __devinit i5k_amb_probe(struc
 		return -ENOMEM;
 
 	/* Figure out where the AMB registers live */
-	res = i5k_find_amb_registers(data);
+	i = 0;
+	do {
+		res = i5k_find_amb_registers(data, chipset_ids[i]);
+		i++;
+	} while (res && chipset_ids[i]);
+
 	if (res)
 		goto err;
 
 	/* Copy the DIMM presence map for the first two channels */
 	res = i5k_channel_probe(&data->amb_present[0],
-				PCI_DEVICE_ID_INTEL_5000_FBD0);
+				i5k_channel_pci_id(data, 0));
 	if (res)
 		goto err;
 
 	/* Copy the DIMM presence map for the optional second two channels */
 	i5k_channel_probe(&data->amb_present[2],
-			  PCI_DEVICE_ID_INTEL_5000_FBD1);
+			  i5k_channel_pci_id(data, 1));
 
 	/* Set up resource regions */
 	reso = request_mem_region(data->amb_base, data->amb_len, DRVNAME);
diff -puN include/linux/pci_ids.h~i5k_amb-support-intel-5400-chipset include/linux/pci_ids.h
--- a/include/linux/pci_ids.h~i5k_amb-support-intel-5400-chipset
+++ a/include/linux/pci_ids.h
@@ -2383,6 +2383,9 @@
 #define PCI_DEVICE_ID_INTEL_ICH10_4	0x3a30
 #define PCI_DEVICE_ID_INTEL_ICH10_5	0x3a60
 #define PCI_DEVICE_ID_INTEL_IOAT_SNB	0x402f
+#define PCI_DEVICE_ID_INTEL_5400_ERR	0x4030
+#define PCI_DEVICE_ID_INTEL_5400_FBD0	0x4035
+#define PCI_DEVICE_ID_INTEL_5400_FBD1	0x4036
 #define PCI_DEVICE_ID_INTEL_IOAT_SCNB	0x65ff
 #define PCI_DEVICE_ID_INTEL_TOLAPAI_0	0x5031
 #define PCI_DEVICE_ID_INTEL_TOLAPAI_1	0x5032
_

Patches currently in -mm which might be from djwong@us.ibm.com are

linux-next.patch

