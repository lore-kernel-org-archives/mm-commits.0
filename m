From: akpm@linux-foundation.org
Subject: - drivers-block-cpqarrayc-better-error-handling-and-kmalloc-memset-conversion-to-kalloc.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:13:32 -0700
Message-ID: <200708141913.l7EJDWbK016514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36517 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933593AbXHNTVJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, jens.axboe@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/cpqarray.c: better error handling and kmalloc + memset conversion to k[cz]alloc
has been removed from the -mm tree.  Its filename was
     drivers-block-cpqarrayc-better-error-handling-and-kmalloc-memset-conversion-to-kalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/block/cpqarray.c: better error handling and kmalloc + memset conversion to k[cz]alloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

This patch removes some redundant casts, does the kmalloc + memset to
k[cz]alloc conversion and it changes the error path to use goto (to avoid code
duplication).

 drivers/block/cpqarray.c | 49567 -> 48623 (-944 bytes)
 drivers/block/cpqarray.o | 178820 -> 178288 (-532 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cpqarray.c |   78 ++++++++++++-------------------------
 1 files changed, 26 insertions(+), 52 deletions(-)

diff -puN drivers/block/cpqarray.c~drivers-block-cpqarrayc-better-error-handling-and-kmalloc-memset-conversion-to-kalloc drivers/block/cpqarray.c
--- a/drivers/block/cpqarray.c~drivers-block-cpqarrayc-better-error-handling-and-kmalloc-memset-conversion-to-kalloc
+++ a/drivers/block/cpqarray.c
@@ -420,18 +420,17 @@ static int __init cpqarray_register_ctlr
 			goto Enomem2;
 	}
 
-	hba[i]->cmd_pool = (cmdlist_t *)pci_alloc_consistent(
+	hba[i]->cmd_pool = pci_alloc_consistent(
 		hba[i]->pci_dev, NR_CMDS * sizeof(cmdlist_t),
 		&(hba[i]->cmd_pool_dhandle));
-	hba[i]->cmd_pool_bits = kmalloc(
-		((NR_CMDS+BITS_PER_LONG-1)/BITS_PER_LONG)*sizeof(unsigned long),
+	hba[i]->cmd_pool_bits = kcalloc(
+		(NR_CMDS+BITS_PER_LONG-1)/BITS_PER_LONG, sizeof(unsigned long),
 		GFP_KERNEL);
 
 	if (!hba[i]->cmd_pool_bits || !hba[i]->cmd_pool)
 			goto Enomem1;
 
 	memset(hba[i]->cmd_pool, 0, NR_CMDS * sizeof(cmdlist_t));
-	memset(hba[i]->cmd_pool_bits, 0, ((NR_CMDS+BITS_PER_LONG-1)/BITS_PER_LONG)*sizeof(unsigned long));
 	printk(KERN_INFO "cpqarray: Finding drives on %s",
 		hba[i]->devname);
 
@@ -1660,45 +1659,30 @@ static void getgeometry(int ctlr)
 
 	info_p->log_drv_map = 0;	
 	
-	id_ldrive = kmalloc(sizeof(id_log_drv_t), GFP_KERNEL);
-	if(id_ldrive == NULL)
-	{
+	id_ldrive = kzalloc(sizeof(id_log_drv_t), GFP_KERNEL);
+	if (!id_ldrive)	{
 		printk( KERN_ERR "cpqarray:  out of memory.\n");
-		return;
+		goto err_0;
 	}
 
-	id_ctlr_buf = kmalloc(sizeof(id_ctlr_t), GFP_KERNEL);
-	if(id_ctlr_buf == NULL)
-	{
-		kfree(id_ldrive);
+	id_ctlr_buf = kzalloc(sizeof(id_ctlr_t), GFP_KERNEL);
+	if (!id_ctlr_buf) {
 		printk( KERN_ERR "cpqarray:  out of memory.\n");
-		return;
+		goto err_1;
 	}
 
-	id_lstatus_buf = kmalloc(sizeof(sense_log_drv_stat_t), GFP_KERNEL);
-	if(id_lstatus_buf == NULL)
-	{
-		kfree(id_ctlr_buf);
-		kfree(id_ldrive);
+	id_lstatus_buf = kzalloc(sizeof(sense_log_drv_stat_t), GFP_KERNEL);
+	if (!id_lstatus_buf) {
 		printk( KERN_ERR "cpqarray:  out of memory.\n");
-		return;
+		goto err_2;
 	}
 
-	sense_config_buf = kmalloc(sizeof(config_t), GFP_KERNEL);
-	if(sense_config_buf == NULL)
-	{
-		kfree(id_lstatus_buf);
-		kfree(id_ctlr_buf);
-		kfree(id_ldrive);
+	sense_config_buf = kzalloc(sizeof(config_t), GFP_KERNEL);
+	if (!sense_config_buf) {
 		printk( KERN_ERR "cpqarray:  out of memory.\n");
-		return;
+		goto err_3;
 	}
 
-	memset(id_ldrive, 0, sizeof(id_log_drv_t));
-	memset(id_ctlr_buf, 0, sizeof(id_ctlr_t));
-	memset(id_lstatus_buf, 0, sizeof(sense_log_drv_stat_t));
-	memset(sense_config_buf, 0, sizeof(config_t));
-
 	info_p->phys_drives = 0;
 	info_p->log_drv_map = 0;
 	info_p->drv_assign_map = 0;
@@ -1712,13 +1696,8 @@ static void getgeometry(int ctlr)
 		 * so the idastubopen will fail on all logical drives
 		 * on the controller.
 		 */
-		 /* Free all the buffers and return */ 
 		printk(KERN_ERR "cpqarray: error sending ID controller\n");
-		kfree(sense_config_buf);
-                kfree(id_lstatus_buf);
-                kfree(id_ctlr_buf);
-                kfree(id_ldrive);
-                return;
+                goto err_4;
         }
 
 	info_p->log_drives = id_ctlr_buf->nr_drvs;
@@ -1764,12 +1743,7 @@ static void getgeometry(int ctlr)
 				" failed to report status of logical drive %d\n"
 			 "Access to this controller has been disabled\n",
 				ctlr, log_unit);
-			/* Free all the buffers and return */
-                	kfree(sense_config_buf);
-                	kfree(id_lstatus_buf);
-                	kfree(id_ctlr_buf);
-                	kfree(id_ldrive);
-                	return;
+                	goto err_4;
 		}
 		/*
 		   Make sure the logical drive is configured
@@ -1798,14 +1772,8 @@ static void getgeometry(int ctlr)
 				 sizeof(config_t), 0, 0, log_unit);
 				if (ret_code == IO_ERROR) {
 					info_p->log_drv_map = 0;
-					/* Free all the buffers and return */
                 			printk(KERN_ERR "cpqarray: error sending sense config\n");
-                			kfree(sense_config_buf);
-                			kfree(id_lstatus_buf);
-                			kfree(id_ctlr_buf);
-                			kfree(id_ldrive);
-                			return;
-
+                			goto err_4;
 				}
 
 				info_p->phys_drives =
@@ -1820,12 +1788,18 @@ static void getgeometry(int ctlr)
 			log_index = log_index + 1;
 		}		/* end of if logical drive configured */
 	}			/* end of for log_unit */
+
+	/* Free all the buffers and return */
+err_4:
 	kfree(sense_config_buf);
-  	kfree(id_ldrive);
+err_3:
   	kfree(id_lstatus_buf);
+err_2:
 	kfree(id_ctlr_buf);
+err_1:
+  	kfree(id_ldrive);
+err_0:
 	return;
-
 }
 
 static void __exit cpqarray_exit(void)
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
git-alsa.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
git-mmc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
git-netdev-all.patch
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
drivers-usb-misc-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch
usb-remove-redundant-memset-from-amd5536udc.patch
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
