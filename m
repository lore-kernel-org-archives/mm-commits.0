From: akpm@linux-foundation.org
Subject: - acpi-fix-bug-10124.patch removed from -mm tree
Date: Sat, 05 Apr 2008 23:58:16 -0700
Message-ID: <200804060658.m366wGeq011024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751015AbYDFG6m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 6 Apr 2008 02:58:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yakui.zhao@intel.com, greg@kroah.com, lenb@kernel.org, stian@jordet.net, mm-commits@vger.kernel.org


The patch titled
     acpi: fix bug 10124
has been removed from the -mm tree.  Its filename was
     acpi-fix-bug-10124.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: fix bug 10124


Unchangelogged patch, taken from
http://bugzilla.kernel.org/show_bug.cgi?id=10124

Cc: <yakui.zhao@intel.com>
Cc: Stian Jordet <stian@jordet.net>
Cc: Len Brown <lenb@kernel.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/pci/pci.c |    7 ++++++-
 arch/x86/pci/acpi.c |   17 +++++++++++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)

diff -puN arch/ia64/pci/pci.c~acpi-fix-bug-10124 arch/ia64/pci/pci.c
--- a/arch/ia64/pci/pci.c~acpi-fix-bug-10124
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
diff -puN arch/x86/pci/acpi.c~acpi-fix-bug-10124 arch/x86/pci/acpi.c
--- a/arch/x86/pci/acpi.c~acpi-fix-bug-10124
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

acpi-fix-bug-10124.patch

