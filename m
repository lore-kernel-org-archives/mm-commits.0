From: akpm@linux-foundation.org
Subject: - dmfe-add-support-for-suspend-resume-fix.patch removed from -mm tree
Date: Tue, 06 Mar 2007 02:40:01 -0800
Message-ID: <200703061040.l26Ae15n019708@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34578 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752201AbXCFKk0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 05:40:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeff@garzik.org, maximlevitsky@gmail.com, val_henson@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     dmfe-add-support-for-suspend-resume-fix
has been removed from the -mm tree.  Its filename was
     dmfe-add-support-for-suspend-resume-fix.patch

This patch was dropped because it was folded into dmfe-add-support-for-suspend-resume.patch

------------------------------------------------------
Subject: dmfe-add-support-for-suspend-resume-fix
From: Andrew Morton <akpm@linux-foundation.org>

- Fix CONFIG_PM=n

- Fix coding style

Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Valerie Henson <val_henson@linux.intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tulip/dmfe.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff -puN drivers/net/tulip/dmfe.c~dmfe-add-support-for-suspend-resume-fix drivers/net/tulip/dmfe.c
--- a/drivers/net/tulip/dmfe.c~dmfe-add-support-for-suspend-resume-fix
+++ a/drivers/net/tulip/dmfe.c
@@ -2047,39 +2047,39 @@ static struct pci_device_id dmfe_pci_tbl
 MODULE_DEVICE_TABLE(pci, dmfe_pci_tbl);
 
 
-
+#ifdef CONFIG_PM
 static int dmfe_suspend(struct pci_dev *pci_dev, pm_message_t state)
 {
 	struct net_device *dev = pci_get_drvdata(pci_dev);
 	struct dmfe_board_info *db = netdev_priv(dev);
 
 	/* Disable upper layer interface */
-	netif_device_detach (dev);
+	netif_device_detach(dev);
 
 	/* Disable Tx/Rx */
 	db->cr6_data &= ~(CR6_RXSC | CR6_TXSC);
 	update_cr6(db->cr6_data, dev->base_addr);
 
 	/* Disable Interrupt */
-	outl (0, dev->base_addr + DCR7);
-	outl (inl (dev->base_addr + DCR5), dev->base_addr + DCR5);
+	outl(0, dev->base_addr + DCR7);
+	outl(inl (dev->base_addr + DCR5), dev->base_addr + DCR5);
 
 	/* Fre RX buffers */
-	dmfe_free_rxbuffer (db);
+	dmfe_free_rxbuffer(db);
 
 	/* Power down device*/
-	pci_set_power_state (pci_dev, pci_choose_state (pci_dev,state));
-	pci_save_state (pci_dev);
+	pci_set_power_state(pci_dev, pci_choose_state (pci_dev,state));
+	pci_save_state(pci_dev);
 
 	return 0;
 }
 
-static int dmfe_resume (struct pci_dev *pci_dev)
+static int dmfe_resume(struct pci_dev *pci_dev)
 {
-	struct net_device *dev = pci_get_drvdata (pci_dev);
+	struct net_device *dev = pci_get_drvdata(pci_dev);
 
 	pci_restore_state(pci_dev);
-	pci_set_power_state(pci_dev ,PCI_D0);
+	pci_set_power_state(pci_dev, PCI_D0);
 
 	/* Re-initilize DM910X board */
 	dmfe_init_dm910x(dev);
@@ -2089,6 +2089,10 @@ static int dmfe_resume (struct pci_dev *
 
 	return 0;
 }
+#else
+#define dmfe_suspend NULL
+#define dmfe_resume NULL
+#endif
 
 static struct pci_driver dmfe_driver = {
 	.name		= "dmfe",
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-build-with-config_no_idle_hz=n.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
gfs2-build-fix.patch
git-input.patch
git-md-accel-fixup.patch
git-mmc-fix-99.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
div64_64-common-code-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
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
