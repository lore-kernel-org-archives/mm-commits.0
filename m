From: akpm@linux-foundation.org
Subject: + drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc.patch added to -mm tree
Date: Tue, 31 Jul 2007 12:30:16 -0700
Message-ID: <200707311930.l6VJUG0I018406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39784 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753605AbXGaThg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 15:37:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl


The patch titled
     drivers/scsi/lpfc/lpfc_init.c: kmalloc + memset conversion to kcalloc
has been added to the -mm tree.  Its filename is
     drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/scsi/lpfc/lpfc_init.c: kmalloc + memset conversion to kcalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/lpfc/lpfc_init.c | 65932 -> 65881 (-51 bytes)
 drivers/scsi/lpfc/lpfc_init.o | 219760 -> 219616 (-144 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_init.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_init.c~drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -1280,11 +1280,10 @@ lpfc_hba_init(struct lpfc_hba *phba, uin
 	uint32_t *HashWorking;
 	uint32_t *pwwnn = (uint32_t *) phba->wwnn;
 
-	HashWorking = kmalloc(80 * sizeof(uint32_t), GFP_KERNEL);
+	HashWorking = kcalloc(80, sizeof(uint32_t), GFP_KERNEL);
 	if (!HashWorking)
 		return;
 
-	memset(HashWorking, 0, (80 * sizeof(uint32_t)));
 	HashWorking[0] = HashWorking[78] = *pwwnn++;
 	HashWorking[1] = HashWorking[79] = *pwwnn;
 
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

fs-9p-convc-error-path-fix.patch
mtd-add-module-license-to-mtdbdi.patch
mtd-remove-redundant-dead-code-from-physmap_ofc.patch
usb-remove-redundant-memset-from-amd5536udc.patch
dont-optimise-away-baud-rate-changes-when-bother-is-used.patch
kmalloc-memset-conversion-co-kzalloc.patch
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
kmalloc-memset-conversion-to-kzalloc.patch
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
