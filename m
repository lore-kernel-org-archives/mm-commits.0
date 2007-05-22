From: akpm@linux-foundation.org
Subject: - fix-kmalloc0-in-arch-ia64-pci-pcic.patch removed from -mm tree
Date: Tue, 22 May 2007 13:56:50 -0700
Message-ID: <200705222056.l4MKun3R009589@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50630 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755873AbXEVU64 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 16:58:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaneshige.kenji@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     fix kmalloc(0) in arch/ia64/pci/pci.c
has been removed from the -mm tree.  Its filename was
     fix-kmalloc0-in-arch-ia64-pci-pcic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix kmalloc(0) in arch/ia64/pci/pci.c
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Hiroyuki Kamezawa reported the problem that pci_acpi_scan_root() of
ia64 might call kmalloc_node() with zero size.

Currently ia64's pci_acpi_scan_root() assumes that _CRS method of root
bridge has at least one resource window. But, the root bridges that
has no resource window must be taken into account.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/pci/pci.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/ia64/pci/pci.c~fix-kmalloc0-in-arch-ia64-pci-pcic arch/ia64/pci/pci.c
--- a/arch/ia64/pci/pci.c~fix-kmalloc0-in-arch-ia64-pci-pcic
+++ a/arch/ia64/pci/pci.c
@@ -354,10 +354,13 @@ pci_acpi_scan_root(struct acpi_device *d
 
 	acpi_walk_resources(device->handle, METHOD_NAME__CRS, count_window,
 			&windows);
-	controller->window = kmalloc_node(sizeof(*controller->window) * windows,
-			GFP_KERNEL, controller->node);
-	if (!controller->window)
-		goto out2;
+	if (windows) {
+		controller->window =
+			kmalloc_node(sizeof(*controller->window) * windows,
+				     GFP_KERNEL, controller->node);
+		if (!controller->window)
+			goto out2;
+	}
 
 	name = kmalloc(16, GFP_KERNEL);
 	if (!name)
_

Patches currently in -mm which might be from kaneshige.kenji@jp.fujitsu.com are

git-ia64.patch
