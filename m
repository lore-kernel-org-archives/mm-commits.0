From: akpm@linux-foundation.org
Subject: + dmfe-add-support-for-suspend-resume-fix.patch added to -mm tree
Date: Thu, 15 Feb 2007 22:11:32 -0800
Message-ID: <200702160611.l1G6BWD5021597@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52740 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423316AbXBPGLk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 01:11:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jeff@garzik.org, maximlevitsky@gmail.com, val_henson@linux.intel.com


The patch titled
     dmfe-add-support-for-suspend-resume-fix
has been added to the -mm tree.  Its filename is
     dmfe-add-support-for-suspend-resume-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-acpi.patch
git-agpgart.patch
git-arm.patch
git-cpufreq.patch
powerpc-rtas-msi-support-fix.patch
git-dvb.patch
sis-warning-fixes.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler-tidy.patch
git-md-accel-fixes.patch
git-md-accel-warning-fixes.patch
git-md-accel-fix.patch
git-mips-fixup.patch
git-mtd.patch
git-netdev-all.patch
e1000-fix-shared-interrupt-warning-message-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
git-backlight.patch
git-sh.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-unionfs-fixup.patch
before-x86_64-mm-mmconfig-share.patch
after-before-x86_64-mm-mmconfig-share.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
kprobes-list-all-active-probes-in-the-system.patch
reduce-size-of-task_struct-on-64-bit-machines-fix.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-epoll-compat-code-to-kernel-compatc-tidy.patch
genalloc-warning-fixes.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
revert-x86_64-mm-putreg-check.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
git-gccbug-fixup.patch
