From: akpm@linux-foundation.org
Subject: + drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc.patch added to -mm tree
Date: Tue, 31 Jul 2007 12:31:43 -0700
Message-ID: <200707311931.l6VJVhhK018546@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753432AbXGaTb5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 15:31:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, mark_salyzyn@adaptec.com


The patch titled
     drivers/scsi/dpt_i2o.c: kmalloc + memset conversion to kzalloc
has been added to the -mm tree.  Its filename is
     drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/scsi/dpt_i2o.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/dpt_i2o.c | 87632 -> 87457 (-175 bytes)
 drivers/scsi/dpt_i2o.o | 213064 -> 212324 (-740 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dpt_i2o.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff -puN drivers/scsi/dpt_i2o.c~drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/scsi/dpt_i2o.c
@@ -950,16 +950,14 @@ static int adpt_install_hba(struct scsi_
 	}
 	
 	// Allocate and zero the data structure
-	pHba = kmalloc(sizeof(adpt_hba), GFP_KERNEL);
-	if( pHba == NULL) {
-		if(msg_addr_virt != base_addr_virt){
+	pHba = kzalloc(sizeof(adpt_hba), GFP_KERNEL);
+	if (!pHba) {
+		if (msg_addr_virt != base_addr_virt)
 			iounmap(msg_addr_virt);
-		}
 		iounmap(base_addr_virt);
 		pci_release_regions(pDev);
 		return -ENOMEM;
 	}
-	memset(pHba, 0, sizeof(adpt_hba));
 
 	mutex_lock(&adpt_configuration_lock);
 
@@ -2667,14 +2665,13 @@ static s32 adpt_i2o_init_outbound_q(adpt
 
 	msg=(u32 __iomem *)(pHba->msg_addr_virt+m);
 
-	status = kmalloc(4,GFP_KERNEL|ADDR32);
-	if (status==NULL) {
+	status = kzalloc(4, GFP_KERNEL|ADDR32);
+	if (!status) {
 		adpt_send_nop(pHba, m);
 		printk(KERN_WARNING"%s: IOP reset failed - no free memory.\n",
 			pHba->name);
 		return -ENOMEM;
 	}
-	memset(status, 0, 4);
 
 	writel(EIGHT_WORD_MSG_SIZE| SGL_OFFSET_6, &msg[0]);
 	writel(I2O_CMD_OUTBOUND_INIT<<24 | HOST_TID<<12 | ADAPTER_TID, &msg[1]);
@@ -2713,12 +2710,11 @@ static s32 adpt_i2o_init_outbound_q(adpt
 
 	kfree(pHba->reply_pool);
 
-	pHba->reply_pool = kmalloc(pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4, GFP_KERNEL|ADDR32);
-	if(!pHba->reply_pool){
-		printk(KERN_ERR"%s: Could not allocate reply pool\n",pHba->name);
-		return -1;
+	pHba->reply_pool = kzalloc(pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4, GFP_KERNEL|ADDR32);
+	if (!pHba->reply_pool) {
+		printk(KERN_ERR "%s: Could not allocate reply pool\n", pHba->name);
+		return -ENOMEM;
 	}
-	memset(pHba->reply_pool, 0 , pHba->reply_fifo_size * REPLY_FRAME_SIZE * 4);
 
 	ptr = pHba->reply_pool;
 	for(i = 0; i < pHba->reply_fifo_size; i++) {
@@ -2929,12 +2925,11 @@ static int adpt_i2o_build_sys_table(void
 
 	kfree(sys_tbl);
 
-	sys_tbl = kmalloc(sys_tbl_len, GFP_KERNEL|ADDR32);
-	if(!sys_tbl) {
+	sys_tbl = kzalloc(sys_tbl_len, GFP_KERNEL|ADDR32);
+	if (!sys_tbl) {
 		printk(KERN_WARNING "SysTab Set failed. Out of memory.\n");	
 		return -ENOMEM;
 	}
-	memset(sys_tbl, 0, sys_tbl_len);
 
 	sys_tbl->num_entries = hba_count;
 	sys_tbl->version = I2OVERSION;
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

fs-9p-convc-error-path-fix.patch
mtd-add-module-license-to-mtdbdi.patch
mtd-remove-redundant-dead-code-from-physmap_ofc.patch
usb-remove-redundant-memset-from-amd5536udc.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
drivers-scsi-a4000tc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-sbus-char-bbc_envctrlc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-sbus-char-bbc_i2cc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-bvme6000_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-block-ccissc-kmalloc-memset-conversion-to-kzalloc.patch
fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-consolemapc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-block-cpqarrayc-better-error-handling-and-kmalloc-memset-conversion-to-kalloc.patch
drivers-pci-hotplug-cpqphp_ctrlc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-file-cryptcompressc-kmalloc-memset-conversion-to-kzalloc.patch
reiser4-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch
net-decnet-dn_routec-kmalloc-memset-conversion-to-kzalloc.patch
doc-firmware_sample_firmware_classc-kmalloc-memset-conversion-to-kzalloc.patch
include-asm-frv-thread_infoh-kmalloc-memset-conversion-to-kzalloc.patch
drivers-usb-misc-ftdi-elanc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-gdthc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
drivers-net-wan-hdlc_frc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-ide-arm-icsidec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-ide-scsic-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-init_superc-kmalloc-memset-conversion-to-kzalloc.patch
fs-autofs4-inodec-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-plugin-inode_ops_renamec-kmalloc-memset-conversion-to-kzalloc.patch
arch-x86_64-kernel-io_apicc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-char-ip2-ip2mainc-kmalloc-memset-conversion-to-kzalloc.patch
net-ipv4-ip_optionsc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-atm-iphasec-mostly-kmalloc-memset-conversion-to-kzalloc.patch
drivers-net-irda-irda-usbc-mostly-kmalloc-memset-conversion-to-kalloc.patch
fs-jbd2-journalc-kmalloc-memset-conversion-to-kzalloc.patch
fs-reiser4-ktxnmgrdc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-lpfc-lpfc_debugfsc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc.patch
drivers-scsi-lpfc-lpfc_scsic-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-megaraidc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-message-fusion-mptctlc-mostly-kmalloc-memset-conversion-to-kzalloc.patch
drivers-scsi-dpt_i2oc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mtd-inftlmountc-kmalloc-memset-conversion-to-kcalloc.patch
