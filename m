From: akpm@linux-foundation.org
Subject: - eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch removed from -mm tree
Date: Fri, 28 Sep 2007 22:51:51 -0700
Message-ID: <200709290551.l8T5ppNg002621@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41011 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964AbXI2Fvy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 29 Sep 2007 01:51:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     eepro100: Avoid potential NULL pointer deref in speedo_init_rx_ring()
has been removed from the -mm tree.  Its filename was
     eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: eepro100: Avoid potential NULL pointer deref in speedo_init_rx_ring()
From: Jesper Juhl <jesper.juhl@gmail.com>

In a low memory situation, if you are very unlucky, the speedo_init_rx_ring()
function may cause a NULL pointer deref.

The problem is in the case where we can't allocate even a single skb for
the RX ring.  In this case 'last_rxf' will be NULL when we break out of
the loop and the line
    last_rxf->status = cpu_to_le32(0xC0000002);	/* '2' is flag value only. */
will cause a NULL pointer dereference.

To fix this properly we need to be return an error from speedo_init_rx_ring()
and have the caller (speedo_open()) catch and propagate the error, as well as
undo anything done to setup the device so far.

This patch adds a check to catch the unlucky case of not even a single skb
being available and adds code in the caller to catch the error and release the
device properly.

For a user who hits this problem, this makes the difference between her device
not being opened and a kernel crash.  Clearly a non functional NIC if
preferable to a kernel crash - especially since setting up the device can
easily be retried later after freeing up some memory; a kernel crash is not as
easy to recover from.

The problem was initially spotted by the Coverity checker.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/eepro100.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff -puN drivers/net/eepro100.c~eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring drivers/net/eepro100.c
--- a/drivers/net/eepro100.c~eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring
+++ a/drivers/net/eepro100.c
@@ -482,7 +482,7 @@ static void mdio_write(struct net_device
 static int speedo_open(struct net_device *dev);
 static void speedo_resume(struct net_device *dev);
 static void speedo_timer(unsigned long data);
-static void speedo_init_rx_ring(struct net_device *dev);
+static int speedo_init_rx_ring(struct net_device *dev);
 static void speedo_tx_timeout(struct net_device *dev);
 static int speedo_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static void speedo_refill_rx_buffers(struct net_device *dev, int force);
@@ -974,9 +974,8 @@ speedo_open(struct net_device *dev)
 
 	/* .. we can safely take handler calls during init. */
 	retval = request_irq(dev->irq, &speedo_interrupt, IRQF_SHARED, dev->name, dev);
-	if (retval) {
-		return retval;
-	}
+	if (retval)
+		goto out;
 
 	dev->if_port = sp->default_port;
 
@@ -998,7 +997,9 @@ speedo_open(struct net_device *dev)
 	}
 #endif
 
-	speedo_init_rx_ring(dev);
+	retval = speedo_init_rx_ring(dev);
+	if (retval)
+		goto out_rx_init_err;
 
 	/* Fire up the hardware. */
 	iowrite16(SCBMaskAll, ioaddr + SCBCmd);
@@ -1037,7 +1038,12 @@ speedo_open(struct net_device *dev)
 	if ((sp->phy[0] & 0x8000) == 0)
 		mdio_read(dev, sp->phy[0] & 0x1f, MII_BMCR);
 
-	return 0;
+ out:
+	return retval;
+ out_rx_init_err:
+	free_irq(dev->irq, dev);
+	pci_set_power_state(sp->pdev, PCI_D2);
+	goto out;
 }
 
 /* Start the chip hardware after a full reset. */
@@ -1240,7 +1246,7 @@ static void speedo_show_state(struct net
 }
 
 /* Initialize the Rx and Tx rings, along with various 'dev' bits. */
-static void
+static int
 speedo_init_rx_ring(struct net_device *dev)
 {
 	struct speedo_private *sp = netdev_priv(dev);
@@ -1280,6 +1286,10 @@ speedo_init_rx_ring(struct net_device *d
 		pci_dma_sync_single_for_device(sp->pdev, sp->rx_ring_dma[i],
 									   sizeof(struct RxFD), PCI_DMA_TODEVICE);
 	}
+	/* If we failed to allocate even a single skb we need to bail out. */
+	if (!last_rxf)
+		return -ENOMEM;
+
 	sp->dirty_rx = (unsigned int)(i - RX_RING_SIZE);
 	/* Mark the last entry as end-of-list. */
 	last_rxf->status = cpu_to_le32(0xC0000002);	/* '2' is flag value only. */
@@ -1287,6 +1297,8 @@ speedo_init_rx_ring(struct net_device *d
 								   sizeof(struct RxFD), PCI_DMA_TODEVICE);
 	sp->last_rxf = last_rxf;
 	sp->last_rxf_dma = last_rxf_dma;
+
+	return 0;
 }
 
 static void speedo_purge_tx(struct net_device *dev)
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

git-alsa.patch
fix-use-after-free--double-free-bug-in-amd_create_gatt_pages--amd_free_gatt_pages.patch
git-cifs.patch
git-powerpc.patch
mga_dma-return-err-not-just-zero-from-mga_do_cleanup_dma.patch
git-dvb.patch
git-gfs2-nmw.patch
git-kbuild.patch
git-mtd.patch
git-ubi.patch
git-net.patch
eepro100-avoid-potential-null-pointer-deref-in-speedo_init_rx_ring.patch
avoid-possible-null-pointer-deref-in-3c359-driver.patch
git-backlight.patch
clean-up-duplicate-includes-in-include-linux-nfs_fsh.patch
clean-up-duplicate-includes-in-fs-ntfs.patch
git-scsi-misc.patch
fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function.patch
git-xfs.patch
clean-up-duplicate-includes-in-include-linux-memory_hotplugh.patch
clean-up-duplicate-includes-in-mm.patch
mm-no-need-to-cast-vmalloc-return-value-in-zone_wait_table_init.patch
uml-remove-unneeded-void-cast.patch
clean-up-duplicate-includes-in-drivers-char.patch
clean-up-duplicate-includes-in-drivers-w1.patch
clean-up-duplicate-includes-in-fs.patch
clean-up-duplicate-includes-in-fs-ecryptfs.patch
clean-up-duplicate-includes-in-kernel.patch
avoid-a-small-unlikely-memory-leak-in-proc_read_escd.patch
docs-ramdisk-initrd-initramfs-corrections.patch
clean-up-duplicate-includes-in-drivers-spi.patch
fix-possible-null-deref-on-low-memory-condition-in-capidrvcsend_message.patch
isdn-guard-against-a-potential-null-pointer-dereference-in-old_capi_manufacturer.patch
fbdev-update-documentation-fb-00-index.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
clean-up-duplicate-includes-in-documentation.patch
add-a-missing-00-index-file-for-documentation-vm.patch
add-a-missing-00-index-file-for-documentation-vm-fix.patch
add-a-00-index-file-to-documentation-mips.patch
add-a-00-index-file-to-documentation-sysctl.patch
add-a-00-index-file-to-documentation-telephony.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci.patch
mxser-fix-compiler-warning-when-building-withoug-config_pci-fix.patch
cyclades-avoid-label-defined-but-not-used-warning.patch
