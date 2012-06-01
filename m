From: akpm@linux-foundation.org
Subject: [merged] drivers-message-fusion-use-pci_dev-revision.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:32:55 -0700
Message-ID: <20120601193255.6268FA013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:52540 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757729Ab2FATc5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:32:57 -0400
Received: by eaao13 with SMTP id o13so111891eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:32:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sshtylyov@ru.mvista.com, Nagalakshmi.Nandigama@lsi.com, auke-jan.h.kok@intel.com, eric.moore@lsi.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/message/fusion: use pci_dev->revision
has been removed from the -mm tree.  Its filename was
     drivers-message-fusion-use-pci_dev-revision.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: drivers/message/fusion: use pci_dev->revision

This driver uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so it
wasn't converted by 44c10138fd4bbc ("PCI: Change all drivers to use
pci_device->revision").

In one case, it even reads PCI revision ID without using it -- that code
is now removed...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Acked-by: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: Eric Moore <eric.moore@lsi.com>
Acked-by: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.c |   12 ++++--------
 drivers/message/fusion/mptctl.c  |    4 +---
 2 files changed, 5 insertions(+), 11 deletions(-)

diff -puN drivers/message/fusion/mptbase.c~drivers-message-fusion-use-pci_dev-revision drivers/message/fusion/mptbase.c
--- a/drivers/message/fusion/mptbase.c~drivers-message-fusion-use-pci_dev-revision
+++ a/drivers/message/fusion/mptbase.c
@@ -1653,7 +1653,6 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 	unsigned long	 port;
 	u32		 msize;
 	u32		 psize;
-	u8		 revision;
 	int		 r = -ENODEV;
 	struct pci_dev *pdev;
 
@@ -1670,8 +1669,6 @@ mpt_mapresources(MPT_ADAPTER *ioc)
 		return r;
 	}
 
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
-
 	if (sizeof(dma_addr_t) > 4) {
 		const uint64_t required_mask = dma_get_required_mask
 		    (&pdev->dev);
@@ -1779,7 +1776,6 @@ mpt_attach(struct pci_dev *pdev, const s
 	MPT_ADAPTER	*ioc;
 	u8		 cb_idx;
 	int		 r = -ENODEV;
-	u8		 revision;
 	u8		 pcixcmd;
 	static int	 mpt_ids = 0;
 #ifdef CONFIG_PROC_FS
@@ -1887,8 +1883,8 @@ mpt_attach(struct pci_dev *pdev, const s
 	dinitprintk(ioc, printk(MYIOC_s_INFO_FMT "facts @ %p, pfacts[0] @ %p\n",
 	    ioc->name, &ioc->facts, &ioc->pfacts[0]));
 
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
-	mpt_get_product_name(pdev->vendor, pdev->device, revision, ioc->prod_name);
+	mpt_get_product_name(pdev->vendor, pdev->device, pdev->revision,
+			     ioc->prod_name);
 
 	switch (pdev->device)
 	{
@@ -1903,7 +1899,7 @@ mpt_attach(struct pci_dev *pdev, const s
 		break;
 
 	case MPI_MANUFACTPAGE_DEVICEID_FC929X:
-		if (revision < XL_929) {
+		if (pdev->revision < XL_929) {
 			/* 929X Chip Fix. Set Split transactions level
 		 	* for PCIX. Set MOST bits to zero.
 		 	*/
@@ -1934,7 +1930,7 @@ mpt_attach(struct pci_dev *pdev, const s
 		/* 1030 Chip Fix. Disable Split transactions
 		 * for PCIX. Set MOST bits to zero if Rev < C0( = 8).
 		 */
-		if (revision < C0_1030) {
+		if (pdev->revision < C0_1030) {
 			pci_read_config_byte(pdev, 0x6a, &pcixcmd);
 			pcixcmd &= 0x8F;
 			pci_write_config_byte(pdev, 0x6a, pcixcmd);
diff -puN drivers/message/fusion/mptctl.c~drivers-message-fusion-use-pci_dev-revision drivers/message/fusion/mptctl.c
--- a/drivers/message/fusion/mptctl.c~drivers-message-fusion-use-pci_dev-revision
+++ a/drivers/message/fusion/mptctl.c
@@ -1250,7 +1250,6 @@ mptctl_getiocinfo (unsigned long arg, un
 	int			iocnum;
 	unsigned int		port;
 	int			cim_rev;
-	u8			revision;
 	struct scsi_device 	*sdev;
 	VirtDevice		*vdevice;
 
@@ -1324,8 +1323,7 @@ mptctl_getiocinfo (unsigned long arg, un
 	pdev = (struct pci_dev *) ioc->pcidev;
 
 	karg->pciId = pdev->device;
-	pci_read_config_byte(pdev, PCI_CLASS_REVISION, &revision);
-	karg->hwRev = revision;
+	karg->hwRev = pdev->revision;
 	karg->subSystemDevice = pdev->subsystem_device;
 	karg->subSystemVendor = pdev->subsystem_vendor;
 
_

Patches currently in -mm which might be from sshtylyov@ru.mvista.com are

origin.patch
clk-add-non-config_have_clk-routines.patch
clk-remove-redundant-depends-on-from-drivers-kconfig.patch
i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch
usb-marvell-remove-conditional-compilation-of-clk-code.patch
usb-musb-remove-conditional-compilation-of-clk-code.patch
ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch
net-c_can-remove-conditional-compilation-of-clk-code.patch
net-stmmac-remove-conditional-compilation-of-clk-code.patch
gadget-m66592-remove-conditional-compilation-of-clk-code.patch
gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch
usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch

