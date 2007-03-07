From: akpm@linux-foundation.org
Subject: - revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:22:55 -0800
Message-ID: <200703070422.l274MtbK019024@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47249 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515AbXCGEYr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:24:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeff@garzik.org, samuel.thibault@ens-lyon.org, stable@kernel.org, thomas@archlinux.org, val_henson@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     revert "drivers/net/tulip/dmfe: support basic carrier detection"
has been removed from the -mm tree.  Its filename was
     revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: revert "drivers/net/tulip/dmfe: support basic carrier detection"
From: Andrew Morton <akpm@linux-foundation.org>

Revert 7628b0a8c01a02966d2228bdf741ddedb128e8f8.  Thomas Bachler
reports:

  Commit 7628b0a8c01a02966d2228bdf741ddedb128e8f8 (drivers/net/tulip/dmfe:
  support basic carrier detection) breaks networking on my Davicom DM9009. 
  ethtool always reports there is no link.  tcpdump shows incoming packets,
  but TX is disabled.  Reverting the above patch fixes the problem.


Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Valerie Henson <val_henson@linux.intel.com>
Cc: Thomas Bachler <thomas@archlinux.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/dmfe.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN drivers/net/tulip/dmfe.c~revert-drivers-net-tulip-dmfe-support-basic-carrier-detection drivers/net/tulip/dmfe.c
--- a/drivers/net/tulip/dmfe.c~revert-drivers-net-tulip-dmfe-support-basic-carrier-detection
+++ a/drivers/net/tulip/dmfe.c
@@ -187,7 +187,7 @@ struct rx_desc {
 struct dmfe_board_info {
 	u32 chip_id;			/* Chip vendor/Device ID */
 	u32 chip_revision;		/* Chip revision */
-	struct DEVICE *dev;		/* net device */
+	struct DEVICE *next_dev;	/* next device */
 	struct pci_dev *pdev;		/* PCI device */
 	spinlock_t lock;
 
@@ -399,8 +399,6 @@ static int __devinit dmfe_init_one (stru
 	/* Init system & device */
 	db = netdev_priv(dev);
 
-	db->dev = dev;
-
 	/* Allocate Tx/Rx descriptor memory */
 	db->desc_pool_ptr = pci_alloc_consistent(pdev, sizeof(struct tx_desc) * DESC_ALL_CNT + 0x20, &db->desc_pool_dma_ptr);
 	db->buf_pool_ptr = pci_alloc_consistent(pdev, TX_BUF_ALLOC * TX_DESC_CNT + 4, &db->buf_pool_dma_ptr);
@@ -428,7 +426,6 @@ static int __devinit dmfe_init_one (stru
 	dev->poll_controller = &poll_dmfe;
 #endif
 	dev->ethtool_ops = &netdev_ethtool_ops;
-	netif_carrier_off(db->dev);
 	spin_lock_init(&db->lock);
 
 	pci_read_config_dword(pdev, 0x50, &pci_pmr);
@@ -1053,7 +1050,6 @@ static void netdev_get_drvinfo(struct ne
 
 static const struct ethtool_ops netdev_ethtool_ops = {
 	.get_drvinfo		= netdev_get_drvinfo,
-	.get_link               = ethtool_op_get_link,
 };
 
 /*
@@ -1148,7 +1144,6 @@ static void dmfe_timer(unsigned long dat
 		/* Link Failed */
 		DMFE_DBUG(0, "Link Failed", tmp_cr12);
 		db->link_failed = 1;
-		netif_carrier_off(db->dev);
 
 		/* For Force 10/100M Half/Full mode: Enable Auto-Nego mode */
 		/* AUTO or force 1M Homerun/Longrun don't need */
@@ -1171,8 +1166,6 @@ static void dmfe_timer(unsigned long dat
 			if ( (db->media_mode & DMFE_AUTO) &&
 				dmfe_sense_speed(db) )
 				db->link_failed = 1;
-			else
-				netif_carrier_on(db->dev);
 			dmfe_process_mode(db);
 			/* SHOW_MEDIA_TYPE(db->op_mode); */
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
git-md-accel-fixup.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
