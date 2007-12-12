From: akpm@linux-foundation.org
Subject: + pcie-aer-dont-check-_osc-when-acpi-is-disabled.patch added to -mm tree
Date: Tue, 11 Dec 2007 20:43:52 -0800
Message-ID: <200712120443.lBC4hqVO025868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395AbXLLEn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 23:43:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, greg@kroah.com, kristen.c.accardi@intel.com, yinghai.lu@Sun.COM


The patch titled
     pcie AER: don't check _OSC when acpi is disabled
has been added to the -mm tree.  Its filename is
     pcie-aer-dont-check-_osc-when-acpi-is-disabled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pcie AER: don't check _OSC when acpi is disabled
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

When acpi=off and pci=nomsi, don't check _OSC in aer_osc_setup

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/aerdrv_acpi.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/pci/pcie/aer/aerdrv_acpi.c~pcie-aer-dont-check-_osc-when-acpi-is-disabled drivers/pci/pcie/aer/aerdrv_acpi.c
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c~pcie-aer-dont-check-_osc-when-acpi-is-disabled
+++ a/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -34,6 +34,9 @@ int aer_osc_setup(struct pcie_device *pc
 	acpi_handle handle = DEVICE_ACPI_HANDLE(&pdev->dev);
 	struct pci_bus *parent;
 
+	if (acpi_pci_disabled)
+		return -1;
+
 	while (!handle) {
 		if (!pdev || !pdev->bus->parent)
 			break;
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

git-cpufreq.patch
serial-keep-the-dtr-setting-for-serial-console.patch
git-x86.patch
kernel-printkc-concerns-about-the-console-handover.patch
pcie-aer-dont-check-_osc-when-acpi-is-disabled.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
