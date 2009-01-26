From: akpm@linux-foundation.org
Subject: [merged] pci-msi-bugfix-utilize-for-msi_capability_init.patch removed from -mm tree
Date: Mon, 26 Jan 2009 11:04:15 -0800
Message-ID: <200901261904.n0QJ4FFO029720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56091 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883AbZAZTKe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 14:10:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seto.hidetoshi@jp.fujitsu.com, albcamus@gmail.com, jbarnes@virtuousgeek.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pci/msi: bugfix/utilize for msi_capability_init()
has been removed from the -mm tree.  Its filename was
     pci-msi-bugfix-utilize-for-msi_capability_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci/msi: bugfix/utilize for msi_capability_init()
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

Fix a bug and do some cleanup.

bug:
	commit 5993760f7fc75b77e4701f1e56dc84c0d6cf18d5
	had a wrong change (since is_64 is boolean[0|1]):

-               pci_write_config_dword(dev,
-                       msi_mask_bits_reg(pos, is_64bit_address(control)),
-                       maskbits);
+               pci_write_config_dword(dev, entry->msi_attrib.is_64, maskbits);

utilize:
	Unify separated if (entry->msi_attrib.maskbit) statements.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc "Jike Song" <albcamus@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN drivers/pci/msi.c~pci-msi-bugfix-utilize-for-msi_capability_init drivers/pci/msi.c
--- a/drivers/pci/msi.c~pci-msi-bugfix-utilize-for-msi_capability_init
+++ a/drivers/pci/msi.c
@@ -398,21 +398,19 @@ static int msi_capability_init(struct pc
 	entry->msi_attrib.masked = 1;
 	entry->msi_attrib.default_irq = dev->irq;	/* Save IOAPIC IRQ */
 	entry->msi_attrib.pos = pos;
-	if (entry->msi_attrib.maskbit) {
-		entry->mask_base = (void __iomem *)(long)msi_mask_bits_reg(pos,
-				entry->msi_attrib.is_64);
-	}
 	entry->dev = dev;
 	if (entry->msi_attrib.maskbit) {
-		unsigned int maskbits, temp;
+		unsigned int base, maskbits, temp;
+
+		base = msi_mask_bits_reg(pos, entry->msi_attrib.is_64);
+		entry->mask_base = (void __iomem *)(long)base;
+
 		/* All MSIs are unmasked by default, Mask them all */
-		pci_read_config_dword(dev,
-			msi_mask_bits_reg(pos, entry->msi_attrib.is_64),
-			&maskbits);
+		pci_read_config_dword(dev, base, &maskbits);
 		temp = (1 << multi_msi_capable(control));
 		temp = ((temp - 1) & ~temp);
 		maskbits |= temp;
-		pci_write_config_dword(dev, entry->msi_attrib.is_64, maskbits);
+		pci_write_config_dword(dev, base, maskbits);
 		entry->msi_attrib.maskbits_mask = temp;
 	}
 	list_add_tail(&entry->list, &dev->msi_list);
_

Patches currently in -mm which might be from seto.hidetoshi@jp.fujitsu.com are

linux-next.patch

