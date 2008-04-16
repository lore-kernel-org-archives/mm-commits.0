From: akpm@linux-foundation.org
Subject: - acpi-unneccessary-to-scan-the-pci-bus-already-scanned.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:27 -0700
Message-ID: <200804162255.m3GMtRAO011125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbYDPW4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yakui.zhao@intel.com, greg@kroah.com, lenb@kernel.org, mingo@elte.hu, muli@il.ibm.com, stian@jordet.net, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     acpi: unneccessary to scan the PCI bus already scanned
has been removed from the -mm tree.  Its filename was
     acpi-unneccessary-to-scan-the-pci-bus-already-scanned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: unneccessary to scan the PCI bus already scanned
From: <yakui.zhao@intel.com>


http://bugzilla.kernel.org/show_bug.cgi?id=10124

this change:

      commit 08f1c192c3c32797068bfe97738babb3295bbf42
      Author: Muli Ben-Yehuda <muli@il.ibm.com>
      Date:   Sun Jul 22 00:23:39 2007 +0300

         x86-64: introduce struct pci_sysdata to facilitate sharing of ->sysdata

         This patch introduces struct pci_sysdata to x86 and x86-64, and
         converts the existing two users (NUMA, Calgary) to use it.

         This lays the groundwork for having other users of sysdata, such as
         the PCI domains work.

         The Calgary bits are tested, the NUMA bits just look ok.

replaces pcibios_scan_root by pci_scan_bus_parented...

but in pcibios_scan_root we have a check about scanned busses.

Cc: <yakui.zhao@intel.com>
Cc: Stian Jordet <stian@jordet.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/pci/pci.c |    7 ++++++-
 arch/x86/pci/acpi.c |   17 +++++++++++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)

diff -puN arch/ia64/pci/pci.c~acpi-unneccessary-to-scan-the-pci-bus-already-scanned arch/ia64/pci/pci.c
--- a/arch/ia64/pci/pci.c~acpi-unneccessary-to-scan-the-pci-bus-already-scanned
+++ a/arch/ia64/pci/pci.c
@@ -362,7 +362,12 @@ pci_acpi_scan_root(struct acpi_device *d
 	info.name = name;
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, add_window,
 			&info);
-
+	/*
+	 * See arch/x86/pci/acpi.c.
+	 * The desired pci bus might already be scanned in a quirk. We
+	 * should handle the case here, but it appears that IA64 hasn't
+	 * such quirk. So we just ignore the case now.
+	 */
 	pbus = pci_scan_bus_parented(NULL, bus, &pci_root_ops, controller);
 	if (pbus)
 		pcibios_setup_root_windows(pbus, controller);
diff -puN arch/x86/pci/acpi.c~acpi-unneccessary-to-scan-the-pci-bus-already-scanned arch/x86/pci/acpi.c
--- a/arch/x86/pci/acpi.c~acpi-unneccessary-to-scan-the-pci-bus-already-scanned
+++ a/arch/x86/pci/acpi.c
@@ -219,8 +219,21 @@ struct pci_bus * __devinit pci_acpi_scan
 	if (pxm >= 0)
 		sd->node = pxm_to_node(pxm);
 #endif
+	/*
+	 * Maybe the desired pci bus has been already scanned. In such case
+	 * it is unnecessary to scan the pci bus with the given domain,busnum.
+	 */
+	bus = pci_find_bus(domain, busnum);
+	if (bus) {
+		/*
+		 * If the desired bus exits, the content of bus->sysdata will
+		 * be replaced by sd.
+		 */
+		memcpy(bus->sysdata, sd, sizeof(*sd));
+		kfree(sd);
+	} else
+		bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
 
-	bus = pci_scan_bus_parented(NULL, busnum, &pci_root_ops, sd);
 	if (!bus)
 		kfree(sd);
 
@@ -228,7 +241,7 @@ struct pci_bus * __devinit pci_acpi_scan
 	if (bus != NULL) {
 		if (pxm >= 0) {
 			printk("bus %d -> pxm %d -> node %d\n",
-				busnum, pxm, sd->node);
+				busnum, pxm, pxm_to_node(pxm));
 		}
 	}
 #endif
_

Patches currently in -mm which might be from yakui.zhao@intel.com are

origin.patch
git-acpi.patch
acpi-check-a-return-value-correctly-in-acpi_power_get_context.patch
rtc-add-the-support-for-alarm-time-relative-to-current-time-in-sysfs.patch

