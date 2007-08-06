From: akpm@linux-foundation.org
Subject: - drivers-mtd-inftlmountc-kmalloc-memset-conversion-to-kcalloc.patch removed from -mm tree
Date: Mon, 06 Aug 2007 00:53:31 -0700
Message-ID: <200708060753.l767rV2H016340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41185 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758583AbXHFHzu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 03:55:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     drivers/mtd/inftlmount.c: kmalloc + memset conversion to kcalloc
has been removed from the -mm tree.  Its filename was
     drivers-mtd-inftlmountc-kmalloc-memset-conversion-to-kcalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/mtd/inftlmount.c: kmalloc + memset conversion to kcalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/mtd/inftlmount.c | 23841 -> 23803 (-38 bytes)
 drivers/mtd/inftlmount.o | 47196 -> 46956 (-240 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/inftlmount.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/mtd/inftlmount.c~drivers-mtd-inftlmountc-kmalloc-memset-conversion-to-kcalloc drivers/mtd/inftlmount.c
--- a/drivers/mtd/inftlmount.c~drivers-mtd-inftlmountc-kmalloc-memset-conversion-to-kcalloc
+++ a/drivers/mtd/inftlmount.c
@@ -580,14 +580,13 @@ int INFTL_mount(struct INFTLrecord *s)
 	logical_block = block = BLOCK_NIL;
 
 	/* Temporary buffer to store ANAC numbers. */
-	ANACtable = kmalloc(s->nb_blocks * sizeof(u8), GFP_KERNEL);
+	ANACtable = kcalloc(s->nb_blocks, sizeof(u8), GFP_KERNEL);
 	if (!ANACtable) {
 		printk(KERN_WARNING "INFTL: allocation of ANACtable "
 				"failed (%zd bytes)\n",
 				s->nb_blocks * sizeof(u8));
 		return -ENOMEM;
 	}
-	memset(ANACtable, 0, s->nb_blocks);
 
 	/*
 	 * First pass is to explore each physical unit, and construct the
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

fs-cifs-connectc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-hw-handlerc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-path-selectorc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-tablec-kmalloc-memset-conversion-to-kzalloc.patch
drivers-md-dm-targetc-kmalloc-memset-conversion-to-kzalloc.patch
git-dvb.patch
drivers-input-serio-gscps2c-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-busc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-hostc-kmalloc-memset-conversion-to-kzalloc.patch
drivers-mmc-core-mmc_opsc-kmalloc-memset-conversion-to-kzalloc.patch
git-mtd.patch
mtd-add-module-license-to-mtdbdi.patch
usb-remove-redundant-memset-from-amd5536udc.patch
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
