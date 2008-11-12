From: akpm@linux-foundation.org
Subject: - i5k_amb-load-automatically-on-all-5000-5400-chipsets.patch removed from -mm tree
Date: Wed, 12 Nov 2008 13:53:44 -0800
Message-ID: <200811122153.mACLri0O007866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502AbYKLVx4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 16:53:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djwong@us.ibm.com, khali@linux-fr.org, mm-commits@vger.kernel.org


The patch titled
     i5k_amb: load automatically on all 5000/5400 chipsets
has been removed from the -mm tree.  Its filename was
     i5k_amb-load-automatically-on-all-5000-5400-chipsets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i5k_amb: load automatically on all 5000/5400 chipsets
From: "Darrick J. Wong" <djwong@us.ibm.com>

It turns out that we cannot create a pci_driver in this driver because PCI
will not call this module's probe function if the i5000-edac driver is
already loaded.  That said, we only want one value (AMBASE) from the PCI
config space.  Neither driver alters this value, so it's safe to read it. 
However, we still want the module aliases, so provide that.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/i5k_amb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/hwmon/i5k_amb.c~i5k_amb-load-automatically-on-all-5000-5400-chipsets drivers/hwmon/i5k_amb.c
--- a/drivers/hwmon/i5k_amb.c~i5k_amb-load-automatically-on-all-5000-5400-chipsets
+++ a/drivers/hwmon/i5k_amb.c
@@ -497,6 +497,14 @@ static struct pci_device_id i5k_amb_ids[
 };
 MODULE_DEVICE_TABLE(pci, i5k_amb_ids);
 
+static struct pci_device_id i5k_amb_ids[] __devinitdata = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5400_ERR) },
+	{ 0, },
+};
+
+MODULE_DEVICE_TABLE(pci, i5k_amb_ids);
+
 static int __devinit i5k_amb_probe(struct platform_device *pdev)
 {
 	struct i5k_amb_data *data;
_

Patches currently in -mm which might be from djwong@us.ibm.com are

fix-platform-drivers-that-crash-on-suspend-resume.patch
i5000-edac-hold-reference-to-mci-kobject.patch
adt7470-check-input-range-when-sysfs-files-are-written.patch
adt7473-check-inputs-from-sysfs-writes.patch
lm85-support-adt7468-chips.patch
adt7462-new-hwmon-driver.patch
ics932s401-new-driver.patch
linux-next.patch
i5k_amb-load-automatically-on-all-5000-5400-chipsets.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch

