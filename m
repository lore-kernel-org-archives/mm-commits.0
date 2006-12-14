From: akpm@osdl.org
Subject: + tgafb-fix-the-pci-id-table.patch added to -mm tree
Date: Thu, 14 Dec 2006 13:32:55 -0800
Message-ID: <200612142132.kBELWtIt028240@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:60301 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932932AbWLNVdQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 16:33:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, adaplas@pol.net, jsimmons@infradead.org


The patch titled
     tgafb: Fix the PCI ID table
has been added to the -mm tree.  Its filename is
     tgafb-fix-the-pci-id-table.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tgafb: Fix the PCI ID table
From: "Maciej W. Rozycki" <macro@linux-mips.org>

The end marker is missing from the driver's PCI ID table.  This set of
changes adds the marker, switches to using PCI_DEVICE() and records the
table for the use in a module.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: James Simmons <jsimmons@infradead.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/video/tgafb.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

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

i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch
tgafb-fix-the-pci-id-table.patch

