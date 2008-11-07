From: akpm@linux-foundation.org
Subject: + i5k_amb-load-automatically-on-all-5000-5400-chipsets.patch added to -mm tree
Date: Fri, 07 Nov 2008 11:21:20 -0800
Message-ID: <200811071921.mA7JLKnx003295@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37602 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbYKGTVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Nov 2008 14:21:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, khali@linux-fr.org


The patch titled
     i5k_amb: load automatically on all 5000/5400 chipsets
has been added to the -mm tree.  Its filename is
     i5k_amb-load-automatically-on-all-5000-5400-chipsets.patch

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
@@ -490,6 +490,14 @@ static unsigned long chipset_ids[] = {
 	0
 };
 
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

ibmpex-add-endian-annotation-to-extract_data-helper.patch
adt7462-new-hwmon-driver.patch
i5k_amb-load-automatically-on-all-5000-5400-chipsets.patch
adt7470-check-input-range-when-sysfs-files-are-written.patch
adt7473-check-inputs-from-sysfs-writes.patch
lm85-support-adt7468-chips.patch

