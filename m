From: akpm@linux-foundation.org
Subject: [merged] pci-dont-use-dmi_name_in_vendors-in-quirk.patch removed from -mm tree
Date: Mon, 23 May 2011 12:14:10 -0700
Message-ID: <201105231912.p4NJCrRW005804@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757126Ab1EWTOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 May 2011 15:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, andi@firstfloor.org, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci: don't use dmi_name_in_vendors() in quirk
has been removed from the -mm tree.  Its filename was
     pci-dont-use-dmi_name_in_vendors-in-quirk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: don't use dmi_name_in_vendors() in quirk
From: Jean Delvare <khali@linux-fr.org>

Don't use the costly dmi_name_in_vendors() when we know the string we are
looking for can only be in the DMI board name field.  This is more robust
and, more importantly, much faster.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/quirks.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/pci/quirks.c~pci-dont-use-dmi_name_in_vendors-in-quirk drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~pci-dont-use-dmi_name_in_vendors-in-quirk
+++ a/drivers/pci/quirks.c
@@ -2349,8 +2349,11 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_A
  */
 static void __devinit nvenet_msi_disable(struct pci_dev *dev)
 {
-	if (dmi_name_in_vendors("P5N32-SLI PREMIUM") ||
-	    dmi_name_in_vendors("P5N32-E SLI")) {
+	const char *board_name = dmi_get_system_info(DMI_BOARD_NAME);
+
+	if (board_name &&
+	    (strstr(board_name, "P5N32-SLI PREMIUM") ||
+	     strstr(board_name, "P5N32-E SLI"))) {
 		dev_info(&dev->dev,
 			 "Disabling msi for MCP55 NIC on P5N32-SLI\n");
 		dev->no_msi = 1;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
drivers-firmware-dmi_scanc-make-dmi_name_in_vendors-more-focused.patch

