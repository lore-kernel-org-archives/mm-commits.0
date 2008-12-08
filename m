From: akpm@linux-foundation.org
Subject: + sm501-fix-section-mismatches.patch added to -mm tree
Date: Mon, 08 Dec 2008 13:49:51 -0800
Message-ID: <200812082149.mB8LnpTs014475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36079 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752541AbYLHVvD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Dec 2008 16:51:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, ben-linux@fluff.org


The patch titled
     sm501: fix section mismatches
has been added to the -mm tree.  Its filename is
     sm501-fix-section-mismatches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1295,7 +1295,7 @@ static unsigned int sm501_mem_local[] = 
  * Common init code for an SM501
 */
 
-static int sm501_init_dev(struct sm501_devdata *sm)
+static int __devinit sm501_init_dev(struct sm501_devdata *sm)
 {
 	struct sm501_initdata *idata;
 	struct sm501_platdata *pdata;
@@ -1371,7 +1371,7 @@ static int sm501_init_dev(struct sm501_d
 	return 0;
 }
 
-static int sm501_plat_probe(struct platform_device *dev)
+static int __devinit sm501_plat_probe(struct platform_device *dev)
 {
 	struct sm501_devdata *sm;
 	int ret;
@@ -1560,8 +1560,8 @@ static struct sm501_platdata sm501_pci_p
 	.gpio_base	= -1,
 };
 
-static int sm501_pci_probe(struct pci_dev *dev,
-			   const struct pci_device_id *id)
+static int __devinit sm501_pci_probe(struct pci_dev *dev,
+				     const struct pci_device_id *id)
 {
 	struct sm501_devdata *sm;
 	int err;
@@ -1667,7 +1667,7 @@ static void sm501_dev_remove(struct sm50
 	sm501_gpio_remove(sm);
 }
 
-static void sm501_pci_remove(struct pci_dev *dev)
+static void __devexit sm501_pci_remove(struct pci_dev *dev)
 {
 	struct sm501_devdata *sm = pci_get_drvdata(dev);
 
@@ -1701,16 +1701,16 @@ static struct pci_device_id sm501_pci_tb
 
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
@@ -1723,14 +1723,14 @@ static struct platform_driver sm501_plat
 
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

pagemap-fix-32-bit-pagemap-regression.patch
linux-next.patch
kconfig-add-module_name-shortcut.patch
proc-move-inode-comment-text-file-to-source-file.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
vfs-fix-switch_names-breakage-in-short-to-short-case.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
remove-remaining-unwinder-code.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
sm501-fix-section-mismatches.patch
ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback.patch

