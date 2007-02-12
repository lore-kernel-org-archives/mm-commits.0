From: akpm@linux-foundation.org
Subject: - tgafb-fix-the-pci-id-table.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:49:30 -0800
Message-ID: <200702122249.l1CMnUho014122@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45941 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030437AbXBLWwz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:52:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: macro@linux-mips.org, adaplas@pol.net, jsimmons@infradead.org, mm-commits@vger.kernel.org


The patch titled
     tgafb: Fix the PCI ID table
has been removed from the -mm tree.  Its filename was
     tgafb-fix-the-pci-id-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tgafb: Fix the PCI ID table
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The end marker is missing from the driver's PCI ID table.  This set of
changes adds the marker, switches to using PCI_DEVICE() and records the
table for the use in a module.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/tgafb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/video/tgafb.c~tgafb-fix-the-pci-id-table drivers/video/tgafb.c
--- a/drivers/video/tgafb.c~tgafb-fix-the-pci-id-table
+++ a/drivers/video/tgafb.c
@@ -71,9 +71,10 @@ static struct fb_ops tgafb_ops = {
  */
 
 static struct pci_device_id const tgafb_pci_table[] = {
-	{ PCI_VENDOR_ID_DEC, PCI_DEVICE_ID_DEC_TGA, PCI_ANY_ID, PCI_ANY_ID,
-	  0, 0, 0 }
+	{ PCI_DEVICE(PCI_VENDOR_ID_DEC, PCI_DEVICE_ID_DEC_TGA) },
+	{ }
 };
+MODULE_DEVICE_TABLE(pci, tgafb_pci_table);
 
 static struct pci_driver tgafb_driver = {
 	.name			= "tgafb",
_

Patches currently in -mm which might be from macro@linux-mips.org are

origin.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
