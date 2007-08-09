From: akpm@linux-foundation.org
Subject: + drivers-net-remove-superfluous-memset.patch added to -mm tree
Date: Thu, 09 Aug 2007 12:42:42 -0700
Message-ID: <200708091942.l79JggYv016087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36538 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753959AbXHITmw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 15:42:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl


The patch titled
     drivers/net: remove superfluous memset
has been added to the -mm tree.  Its filename is
     drivers-net-remove-superfluous-memset.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/net: remove superfluous memset
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

	This patch covers something like this:

dev = alloc_*dev(...
...
priv = netdev_priv(dev);
memset(priv, 0, sizeof(*priv));

The memset() here is superfluous. alloc_netdev() uses kzalloc()
to allocate needed memory so there is no need to zero the priv region
twice.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/fs_enet/fs_enet-main.c   |    1 -
 drivers/net/myri10ge/myri10ge.c      |    1 -
 drivers/net/netxen/netxen_nic_main.c |    1 -
 drivers/net/sunlance.c               |    1 -
 drivers/net/usb/pegasus.c            |    1 -
 drivers/net/usb/rtl8150.c            |    1 -
 6 files changed, 6 deletions(-)

diff -puN drivers/net/fs_enet/fs_enet-main.c~drivers-net-remove-superfluous-memset drivers/net/fs_enet/fs_enet-main.c
--- a/drivers/net/fs_enet/fs_enet-main.c~drivers-net-remove-superfluous-memset
+++ a/drivers/net/fs_enet/fs_enet-main.c
@@ -962,7 +962,6 @@ static struct net_device *fs_init_instan
 	SET_MODULE_OWNER(ndev);
 
 	fep = netdev_priv(ndev);
-	memset(fep, 0, privsize);	/* clear everything */
 
 	fep->dev = dev;
 	dev_set_drvdata(dev, ndev);
diff -puN drivers/net/myri10ge/myri10ge.c~drivers-net-remove-superfluous-memset drivers/net/myri10ge/myri10ge.c
--- a/drivers/net/myri10ge/myri10ge.c~drivers-net-remove-superfluous-memset
+++ a/drivers/net/myri10ge/myri10ge.c
@@ -2852,7 +2852,6 @@ static int myri10ge_probe(struct pci_dev
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
 	mgp = netdev_priv(netdev);
-	memset(mgp, 0, sizeof(*mgp));
 	mgp->dev = netdev;
 	mgp->pdev = pdev;
 	mgp->csum_flag = MXGEFW_FLAGS_CKSUM;
diff -puN drivers/net/netxen/netxen_nic_main.c~drivers-net-remove-superfluous-memset drivers/net/netxen/netxen_nic_main.c
--- a/drivers/net/netxen/netxen_nic_main.c~drivers-net-remove-superfluous-memset
+++ a/drivers/net/netxen/netxen_nic_main.c
@@ -329,7 +329,6 @@ netxen_nic_probe(struct pci_dev *pdev, c
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
 	adapter = netdev->priv;
-	memset(adapter, 0 , sizeof(struct netxen_adapter));
 
 	adapter->ahw.pdev = pdev;
 	adapter->ahw.pci_func  = pci_func_id;
diff -puN drivers/net/sunlance.c~drivers-net-remove-superfluous-memset drivers/net/sunlance.c
--- a/drivers/net/sunlance.c~drivers-net-remove-superfluous-memset
+++ a/drivers/net/sunlance.c
@@ -1335,7 +1335,6 @@ static int __devinit sparc_lance_probe_o
 		return -ENOMEM;
 
 	lp = netdev_priv(dev);
-	memset(lp, 0, sizeof(*lp));
 
 	if (sparc_lance_debug && version_printed++ == 0)
 		printk (KERN_INFO "%s", version);
diff -puN drivers/net/usb/pegasus.c~drivers-net-remove-superfluous-memset drivers/net/usb/pegasus.c
--- a/drivers/net/usb/pegasus.c~drivers-net-remove-superfluous-memset
+++ a/drivers/net/usb/pegasus.c
@@ -1306,7 +1306,6 @@ static int pegasus_probe(struct usb_inte
 	}
 
 	pegasus = netdev_priv(net);
-	memset(pegasus, 0, sizeof (struct pegasus));
 	pegasus->dev_index = dev_index;
 	init_waitqueue_head(&pegasus->ctrl_wait);
 
diff -puN drivers/net/usb/rtl8150.c~drivers-net-remove-superfluous-memset drivers/net/usb/rtl8150.c
--- a/drivers/net/usb/rtl8150.c~drivers-net-remove-superfluous-memset
+++ a/drivers/net/usb/rtl8150.c
@@ -905,7 +905,6 @@ static int rtl8150_probe(struct usb_inte
 	}
 
 	dev = netdev_priv(netdev);
-	memset(dev, 0, sizeof(rtl8150_t));
 
 	dev->intr_buff = kmalloc(INTBUFSIZE, GFP_KERNEL);
 	if (!dev->intr_buff) {
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

emu10k1-remove-redundant-memset.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch
git-dvb.patch
drivers-media-video-arvc-fix-memset-in-ioctl.patch
drivers-media-video-videodevc-memset-fix.patch
drivers-media-video-zoran_driverc-fix-memset-in-ioctl.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
usb-remove-redundant-memset-from-amd5536udc.patch
drivers-net-remove-superfluous-memset.patch
drivers-net-wan-hdlc_frc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-net-irda-irda-usbc-mostly-kmalloc-memset-conversion-to-kalloc.patch
drivers-atm-iphasec-mostly-kmalloc-memset-conversion-to-kzalloc.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-bvme6000_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-megaraidc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
message-fusion-remove-redundant-memset.patch
drivers-block-ccissc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-block-cpqarrayc-better-error-handling-and-kmalloc-memset-conversion-to-kalloc.patch
drivers-usb-misc-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch
arch-x86_64-kernel-io_apicc-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-m32r-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
