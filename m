From: akpm@linux-foundation.org
Subject: + fix-kmalloc0-in-arch-ia64-pci-pcic.patch added to -mm tree
Date: Mon, 21 May 2007 18:39:00 -0700
Message-ID: <200705220139.l4M1cxOf025047@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41604 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757546AbXEVBl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 21:41:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaneshige.kenji@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, tony.luck@intel.com


The patch titled
     fix kmalloc(0) in arch/ia64/pci/pci.c
has been added to the -mm tree.  Its filename is
     fix-kmalloc0-in-arch-ia64-pci-pcic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

fix-kmalloc0-in-arch-ia64-pci-pcic.patch
