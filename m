From: akpm@linux-foundation.org
Subject: - drivers-edac-add-cell-xdr-memory-types.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:05:40 -0800
Message-ID: <200802080805.m1885LPe014328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49396 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761464AbYBHIUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers-edac: add Cell XDR memory types
has been removed from the -mm tree.  Its filename was
     drivers-edac-add-cell-xdr-memory-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers-edac: add Cell XDR memory types
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Add the definitions for the Rambus XDR memory type used by the Cell processor.
It's a pre-requisite for the followup Cell EDAC patch.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/edac_core.h     |    2 ++
 drivers/edac/edac_mc_sysfs.c |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/edac/edac_core.h~drivers-edac-add-cell-xdr-memory-types drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-add-cell-xdr-memory-types
+++ a/drivers/edac/edac_core.h
@@ -136,6 +136,7 @@ enum mem_type {
 	MEM_DDR2,		/* DDR2 RAM */
 	MEM_FB_DDR2,		/* fully buffered DDR2 */
 	MEM_RDDR2,		/* Registered DDR2 RAM */
+	MEM_XDR,		/* Rambus XDR */
 };
 
 #define MEM_FLAG_EMPTY		BIT(MEM_EMPTY)
@@ -152,6 +153,7 @@ enum mem_type {
 #define MEM_FLAG_DDR2           BIT(MEM_DDR2)
 #define MEM_FLAG_FB_DDR2        BIT(MEM_FB_DDR2)
 #define MEM_FLAG_RDDR2          BIT(MEM_RDDR2)
+#define MEM_FLAG_XDR            BIT(MEM_XDR)
 
 /* chipset Error Detection and Correction capabilities and mode */
 enum edac_type {
diff -puN drivers/edac/edac_mc_sysfs.c~drivers-edac-add-cell-xdr-memory-types drivers/edac/edac_mc_sysfs.c
--- a/drivers/edac/edac_mc_sysfs.c~drivers-edac-add-cell-xdr-memory-types
+++ a/drivers/edac/edac_mc_sysfs.c
@@ -73,7 +73,8 @@ static const char *mem_types[] = {
 	[MEM_RMBS] = "RMBS",
 	[MEM_DDR2] = "Unbuffered-DDR2",
 	[MEM_FB_DDR2] = "FullyBuffered-DDR2",
-	[MEM_RDDR2] = "Registered-DDR2"
+	[MEM_RDDR2] = "Registered-DDR2",
+	[MEM_XDR] = "XDR"
 };
 
 static const char *dev_types[] = {
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
add-remove_memory-for-ppc64-3.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
