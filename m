From: akpm@linux-foundation.org
Subject: + drivers-ide-arm-icsidec-kmalloc-memset-conversion-to-kzalloc.patch added to -mm tree
Date: Tue, 31 Jul 2007 12:29:50 -0700
Message-ID: <200707311929.l6VJToC1018361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754708AbXGaTiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 15:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: m.kozlowski@tuxland.pl, bzolnier@gmail.com, rmk@arm.linux.org.uk


The patch titled
     drivers/ide/arm/icside.c: kmalloc + memset conversion to kzalloc
has been added to the -mm tree.  Its filename is
     drivers-ide-arm-icsidec-kmalloc-memset-conversion-to-kzalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/ide/arm/icside.c: kmalloc + memset conversion to kzalloc
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Is this a bug?  In original verison memset cleared sizeof(state) bytes instead
of sizeof(*state).  If it was intentional then this patch is invalid.  If not
intentional -> valid :) Please review.

 drivers/ide/arm/icside.c | 18883 -> 18849 (-34 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/arm/icside.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/ide/arm/icside.c~drivers-ide-arm-icsidec-kmalloc-memset-conversion-to-kzalloc drivers/ide/arm/icside.c
--- a/drivers/ide/arm/icside.c~drivers-ide-arm-icsidec-kmalloc-memset-conversion-to-kzalloc
+++ a/drivers/ide/arm/icside.c
@@ -682,13 +682,12 @@ icside_probe(struct expansion_card *ec, 
 	if (ret)
 		goto out;
 
-	state = kmalloc(sizeof(struct icside_state), GFP_KERNEL);
+	state = kzalloc(sizeof(struct icside_state), GFP_KERNEL);
 	if (!state) {
 		ret = -ENOMEM;
 		goto release;
 	}
 
-	memset(state, 0, sizeof(state));
 	state->type	= ICS_TYPE_NOTYPE;
 	state->dev	= &ec->dev;
 
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
