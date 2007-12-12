From: akpm@linux-foundation.org
Subject: + pci-dont-load-acpi_php-when-acpi-is-disabled.patch added to -mm tree
Date: Tue, 11 Dec 2007 21:55:16 -0800
Message-ID: <200712120555.lBC5tGbk028449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751899AbXLLFzU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Dec 2007 00:55:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, greg@kroah.com, kristen.c.accardi@intel.com, yinghai.lu@Sun.COM


The patch titled
     pci: don't load acpi_php when acpi is disabled
has been added to the -mm tree.  Its filename is
     pci-dont-load-acpi_php-when-acpi-is-disabled.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pci: don't load acpi_php when acpi is disabled
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

When acpi=off and pci=nomsi, don't load acpiphp.

Fixes this:

AER service couldn't init device 0000:00:0a.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:0e.0:pcie01 - no _OSC support
AER service couldn't init device 0000:00:0f.0:pcie01 - no _OSC support
AER service couldn't init device 0000:80:0b.0:pcie01 - no _OSC support
AER service couldn't init device 0000:80:0e.0:pcie01 - no _OSC support
AER service couldn't init device 0000:80:0f.0:pcie01 - no _OSC support

pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread
FFFF81103CC54000 could not acquire Mutex [1] [20070126]

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/acpiphp_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/pci/hotplug/acpiphp_core.c~pci-dont-load-acpi_php-when-acpi-is-disabled drivers/pci/hotplug/acpiphp_core.c
--- a/drivers/pci/hotplug/acpiphp_core.c~pci-dont-load-acpi_php-when-acpi-is-disabled
+++ a/drivers/pci/hotplug/acpiphp_core.c
@@ -392,6 +392,9 @@ static int __init acpiphp_init(void)
 {
 	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
+	if (acpi_pci_disabled)
+		return 0;
+
 	acpiphp_debug = debug;
 
 	/* read all the ACPI info from the system */
@@ -401,6 +404,9 @@ static int __init acpiphp_init(void)
 
 static void __exit acpiphp_exit(void)
 {
+	if (acpi_pci_disabled)
+		return 0;
+
 	/* deallocate internal data structures etc. */
 	acpiphp_glue_exit();
 }
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

git-cpufreq.patch
serial-keep-the-dtr-setting-for-serial-console.patch
pcie-aer-dont-check-_osc-when-acpi-is-disabled.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
git-x86.patch
kernel-printkc-concerns-about-the-console-handover.patch
