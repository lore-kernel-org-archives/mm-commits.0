From: akpm@linux-foundation.org
Subject: + fix-sysfs-rom-file-creation-for-bios-rom-shadows.patch added to -mm tree
Date: Sun, 25 Mar 2007 01:34:20 -0800
Message-ID: <200703250934.l2P9YK6S024798@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37504 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933307AbXCYJeZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 05:34:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, greg@kroah.com


The patch titled
     fix sysfs rom file creation for BIOS ROM shadows
has been added to the -mm tree.  Its filename is
     fix-sysfs-rom-file-creation-for-bios-rom-shadows.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix sysfs rom file creation for BIOS ROM shadows
From: Jesse Barnes <jbarnes@virtuousgeek.org>

At one time, if a BIOS ROM shadow was detected for the boot video device
(stored at offset 0xc0000), we'd set a special resource flag,
IORESOURCE_ROM_SHADOW, so that the sysfs ROM file code could handle it
properly.  That broke along the way somewhere though, so current kernels
will be missing 'rom' files in sysfs if the video device doesn't have an
explicit ROM BAR.

This patch fixes the regression by moving the video fixup quirk to a little
later in the boot cycle (to avoid having its work undone by PCI resource
allocation) and checking in the PCI sysfs code whether a rom file should be
created due to a shadow resource, which is also moved to a little later in
the boot cycle so it will occur after the video fixup.  Tested and works on
my i386 test box.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/fixup.c   |    2 +-
 drivers/pci/pci-sysfs.c |    5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/i386/pci/fixup.c~fix-sysfs-rom-file-creation-for-bios-rom-shadows arch/i386/pci/fixup.c
--- a/arch/i386/pci/fixup.c~fix-sysfs-rom-file-creation-for-bios-rom-shadows
+++ a/arch/i386/pci/fixup.c
@@ -354,7 +354,7 @@ static void __devinit pci_fixup_video(st
 		printk(KERN_DEBUG "Boot video device is %s\n", pci_name(pdev));
 	}
 }
-DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
+DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, pci_fixup_video);
 
 /*
  * Some Toshiba laptops need extra code to enable their TI TSB43AB22/A.
diff -puN drivers/pci/pci-sysfs.c~fix-sysfs-rom-file-creation-for-bios-rom-shadows drivers/pci/pci-sysfs.c
--- a/drivers/pci/pci-sysfs.c~fix-sysfs-rom-file-creation-for-bios-rom-shadows
+++ a/drivers/pci/pci-sysfs.c
@@ -620,7 +620,8 @@ int __must_check pci_create_sysfs_dev_fi
 		goto err_bin_file;
 
 	/* If the device has a ROM, try to expose it in sysfs. */
-	if (pci_resource_len(pdev, PCI_ROM_RESOURCE)) {
+	if (pci_resource_len(pdev, PCI_ROM_RESOURCE) ||
+	    (pdev->resource[PCI_ROM_RESOURCE].flags & IORESOURCE_ROM_SHADOW)) {
 		rom_attr = kzalloc(sizeof(*rom_attr), GFP_ATOMIC);
 		if (rom_attr) {
 			pdev->rom_attr = rom_attr;
@@ -695,4 +696,4 @@ static int __init pci_sysfs_init(void)
 	return 0;
 }
 
-__initcall(pci_sysfs_init);
+late_initcall(pci_sysfs_init);
_

Patches currently in -mm which might be from jbarnes@virtuousgeek.org are

fix-sysfs-rom-file-creation-for-bios-rom-shadows.patch
