From: akpm@linux-foundation.org
Subject: - drivers-block-ccissc-kmalloc-memset-conversion-to-kzalloc.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:13:30 -0700
Message-ID: <200708141913.l7EJDUAp016511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36908 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762791AbXHNTUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:20:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     drivers/block/cciss.c: kmalloc + memset conversion to kzalloc
has been removed from the -mm tree.  Its filename was
     drivers-block-ccissc-kmalloc-memset-conversion-to-kzalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/block/cciss.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/block/cciss.c | 104285 -> 104168 (-117 bytes)
 drivers/block/cciss.o | 277400 -> 277124 (-276 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/block/cciss.c~drivers-block-ccissc-kmalloc-memset-conversion-to-kzalloc drivers/block/cciss.c
--- a/drivers/block/cciss.c~drivers-block-ccissc-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/block/cciss.c
@@ -1977,12 +1977,13 @@ cciss_read_capacity(int ctlr, int logvol
 {
 	ReadCapdata_struct *buf;
 	int return_code;
-	buf = kmalloc(sizeof(ReadCapdata_struct), GFP_KERNEL);
-	if (buf == NULL) {
+
+	buf = kzalloc(sizeof(ReadCapdata_struct), GFP_KERNEL);
+	if (!buf) {
 		printk(KERN_WARNING "cciss: out of memory\n");
 		return;
 	}
-	memset(buf, 0, sizeof(ReadCapdata_struct));
+
 	if (withirq)
 		return_code = sendcmd_withirq(CCISS_READ_CAPACITY,
 				ctlr, buf, sizeof(ReadCapdata_struct),
@@ -2003,7 +2004,6 @@ cciss_read_capacity(int ctlr, int logvol
 		printk(KERN_INFO "      blocks= %llu block_size= %d\n",
 		(unsigned long long)*total_size+1, *block_size);
 	kfree(buf);
-	return;
 }
 
 static void
@@ -2011,12 +2011,13 @@ cciss_read_capacity_16(int ctlr, int log
 {
 	ReadCapdata_struct_16 *buf;
 	int return_code;
-	buf = kmalloc(sizeof(ReadCapdata_struct_16), GFP_KERNEL);
-	if (buf == NULL) {
+
+	buf = kzalloc(sizeof(ReadCapdata_struct_16), GFP_KERNEL);
+	if (!buf) {
 		printk(KERN_WARNING "cciss: out of memory\n");
 		return;
 	}
-	memset(buf, 0, sizeof(ReadCapdata_struct_16));
+
 	if (withirq) {
 		return_code = sendcmd_withirq(CCISS_READ_CAPACITY_16,
 			ctlr, buf, sizeof(ReadCapdata_struct_16),
@@ -2038,7 +2039,6 @@ cciss_read_capacity_16(int ctlr, int log
 	printk(KERN_INFO "      blocks= %llu block_size= %d\n",
 	       (unsigned long long)*total_size+1, *block_size);
 	kfree(buf);
-	return;
 }
 
 static int cciss_revalidate(struct gendisk *disk)
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
