From: akpm@linux-foundation.org
Subject: [merged] sm501-fix-section-mismatches.patch removed from -mm tree
Date: Wed, 18 Feb 2009 02:14:07 -0800
Message-ID: <200902181014.n1IAE7EI006366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751882AbZBRKOq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 05:14:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     sm501: fix section mismatches
has been removed from the -mm tree.  Its filename was
     sm501-fix-section-mismatches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sm501: fix section mismatches
From: Alexey Dobriyan <adobriyan@gmail.com>

drv => driver renaming is needed otherwise modpost will spit false positives
re pointing to __devinit function from regular data.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/mfd/sm501.c~sm501-fix-section-mismatches drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~sm501-fix-section-mismatches
+++ a/drivers/mfd/sm501.c
@@ -1321,7 +1321,7 @@ static unsigned int sm501_mem_local[] = 
  * Common init code for an SM501
 */
 
-static int sm501_init_dev(struct sm501_devdata *sm)
+static int __devinit sm501_init_dev(struct sm501_devdata *sm)
 {
 	struct sm501_initdata *idata;
 	struct sm501_platdata *pdata;
@@ -1397,7 +1397,7 @@ static int sm501_init_dev(struct sm501_d
 	return 0;
 }
 
-static int sm501_plat_probe(struct platform_device *dev)
+static int __devinit sm501_plat_probe(struct platform_device *dev)
 {
 	struct sm501_devdata *sm;
 	int ret;
@@ -1586,8 +1586,8 @@ static struct sm501_platdata sm501_pci_p
 	.gpio_base	= -1,
 };
 
-static int sm501_pci_probe(struct pci_dev *dev,
-			   const struct pci_device_id *id)
+static int __devinit sm501_pci_probe(struct pci_dev *dev,
+				     const struct pci_device_id *id)
 {
 	struct sm501_devdata *sm;
 	int err;
@@ -1693,7 +1693,7 @@ static void sm501_dev_remove(struct sm50
 	sm501_gpio_remove(sm);
 }
 
-static void sm501_pci_remove(struct pci_dev *dev)
+static void __devexit sm501_pci_remove(struct pci_dev *dev)
 {
 	struct sm501_devdata *sm = pci_get_drvdata(dev);
 
@@ -1727,16 +1727,16 @@ static struct pci_device_id sm501_pci_tb
 
 MODULE_DEVICE_TABLE(pci, sm501_pci_tbl);
 
-static struct pci_driver sm501_pci_drv = {
+static struct pci_driver sm501_pci_driver = {
 	.name		= "sm501",
 	.id_table	= sm501_pci_tbl,
 	.probe		= sm501_pci_probe,
-	.remove		= sm501_pci_remove,
+	.remove		= __devexit_p(sm501_pci_remove),
 };
 
 MODULE_ALIAS("platform:sm501");
 
-static struct platform_driver sm501_plat_drv = {
+static struct platform_driver sm501_plat_driver = {
 	.driver		= {
 		.name	= "sm501",
 		.owner	= THIS_MODULE,
@@ -1749,14 +1749,14 @@ static struct platform_driver sm501_plat
 
 static int __init sm501_base_init(void)
 {
-	platform_driver_register(&sm501_plat_drv);
-	return pci_register_driver(&sm501_pci_drv);
+	platform_driver_register(&sm501_plat_driver);
+	return pci_register_driver(&sm501_pci_driver);
 }
 
 static void __exit sm501_base_exit(void)
 {
-	platform_driver_unregister(&sm501_plat_drv);
-	pci_unregister_driver(&sm501_pci_drv);
+	platform_driver_unregister(&sm501_plat_driver);
+	pci_unregister_driver(&sm501_pci_driver);
 }
 
 module_init(sm501_base_init);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags.patch
vfs-separate-fmode_pread-fmode_pwrite-into-separate-flags-fix.patch
seq_file-properly-cope-with-pread.patch
seq_file-properly-cope-with-pread-fix.patch
linux-next.patch
fs-proc-task_mmuc-fix-sparse-warnings.patch
proc-tty-add-struct-tty_operations-proc_fops.patch
proc-tty-switch-cyclades-to-proc_fops.patch
proc-tty-switch-ip2-to-proc_fops.patch
proc-tty-switch-istallion-to-proc_fops.patch
proc-tty-switch-synclink_cs-to-proc_fops.patch
proc-tty-switch-stallion-to-proc_fops.patch
proc-tty-switch-synclink-to-proc_fops.patch
proc-tty-switch-synclink_gt-to-proc_fops.patch
proc-tty-switch-synclinkmp-to-proc_fops.patch
proc-tty-switch-sdio_uart-to-proc_fops.patch
proc-tty-switch-serial_core-to-proc_fops.patch
proc-tty-switch-usb-serial-to-proc_fops.patch
proc-tty-switch-ircomm-to-proc_fops.patch
proc-tty-switch-amiserial-to-proc_fops.patch
proc-tty-switch-ia64-simserial-to-proc_fops.patch
proc-tty-switch-xtensa-iss-console-to-proc_fops.patch
proc-tty-remove-struct-tty_operations-read_proc.patch
eeepc-should-depend-on-input.patch
xtensa-fix-compilation-somewhat.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-export-statistics-for-softirq-to-proc-fix.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch

