From: akpm@linux-foundation.org
Subject: - pci-dont-load-acpi_php-when-acpi-is-disabled.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:43 -0800
Message-ID: <200802232023.m1NKNh19013566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763211AbYBWU30 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yinghai.Lu@Sun.COM, greg@kroah.com, kristen.c.accardi@intel.com, yinghai.lu@Sun.COM, mm-commits@vger.kernel.org


The patch titled
     pci: don't load acpi_php when acpi is disabled
has been removed from the -mm tree.  Its filename was
     pci-dont-load-acpi_php-when-acpi-is-disabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: don't load acpi_php when acpi is disabled
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

When acpi=off and pci=nomsi, don't load acpiphp.

Fixes this:

pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
ACPI Exception (utmutex-0263): AE_BAD_PARAMETER, Thread
FFFF81103CC54000 could not acquire Mutex [1] [20070126]

[akpm@linux-foundation.org: export acpi_pci_disabled for acpiphp.ko]
[akpm@linux-foundation.org: fix return statement]
Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/boot.c        |    3 ++-
 drivers/pci/hotplug/acpiphp_core.c |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

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
+		return;
+
 	/* deallocate internal data structures etc. */
 	acpiphp_glue_exit();
 }
diff -puN arch/x86/kernel/acpi/boot.c~pci-dont-load-acpi_php-when-acpi-is-disabled arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c~pci-dont-load-acpi_php-when-acpi-is-disabled
+++ a/arch/x86/kernel/acpi/boot.c
@@ -72,7 +72,8 @@ static inline int acpi_madt_oem_check(ch
 #define PREFIX			"ACPI: "
 
 int acpi_noirq;				/* skip ACPI IRQ initialization */
-int acpi_pci_disabled __initdata;	/* skip ACPI PCI scan and IRQ initialization */
+int acpi_pci_disabled;			/* skip ACPI PCI scan and IRQ initialization */
+EXPORT_SYMBOL(acpi_pci_disabled);
 int acpi_ht __initdata = 1;	/* enable HT */
 
 int acpi_lapic;
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

origin.patch
git-scsi-rc-fixes.patch
git-x86.patch
