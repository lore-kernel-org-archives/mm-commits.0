From: akpm@linux-foundation.org
Subject: - pata_hpt37x-further-small-fixes.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:44:50 -0700
Message-ID: <200704302144.l3ULiogd015622@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423388AbXD3Vpb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:45:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pata_hpt37x: Further small fixes
has been removed from the -mm tree.  Its filename was
     pata_hpt37x-further-small-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pata_hpt37x: Further small fixes
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Further HPT37x changes

- No 66MHz 370/370A
- Remove dead special case check now we use the DPLL (as per the IDE driver)

Pointed out by Sergei

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_hpt37x.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff -puN drivers/ata/pata_hpt37x.c~pata_hpt37x-further-small-fixes drivers/ata/pata_hpt37x.c
--- a/drivers/ata/pata_hpt37x.c~pata_hpt37x-further-small-fixes
+++ a/drivers/ata/pata_hpt37x.c
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.4"
+#define DRV_VERSION	"0.6.5"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -130,7 +130,7 @@ static const struct hpt_chip hpt370 = {
 		hpt37x_timings_33,
 		NULL,
 		NULL,
-		hpt37x_timings_66
+		NULL
 	}
 };
 
@@ -141,7 +141,7 @@ static const struct hpt_chip hpt370a = {
 		hpt37x_timings_33,
 		NULL,
 		hpt37x_timings_50,
-		hpt37x_timings_66
+		NULL
 	}
 };
 
@@ -1019,8 +1019,8 @@ static int hpt37x_init_one(struct pci_de
 					return -ENODEV;
 				port = &info_hpt372;
 				chip_table = &hpt371;
-				/* Single channel device, paster is not present
-				   but the NIOS (or us for non x86) must mark it
+				/* Single channel device, master is not present
+				   but the BIOS (or us for non x86) must mark it
 				   absent */
 				pci_read_config_byte(dev, 0x50, &mcr1);
 				mcr1 &= ~0x04;
@@ -1132,16 +1132,11 @@ static int hpt37x_init_one(struct pci_de
 	} else {
 		port->private_data = (void *)chip_table->clocks[clock_slot];
 		/*
-		 *	Perform a final fixup. The 371 and 372 clock determines
-		 *	if UDMA133 is available. (FIXME: should we use DPLL then ?)
-		 */
+		 *	Perform a final fixup. Note that we will have used the
+		 *	DPLL on the HPT372 which means we don't have to worry
+		 *	about lack of UDMA133 support on lower clocks
+ 		 */
 
-		if (clock_slot == 2 && chip_table == &hpt372) {	/* 50Mhz */
-			printk(KERN_WARNING "pata_hpt37x: No UDMA133 support available with 50MHz bus clock.\n");
-			if (port == &info_hpt372)
-				port = &info_hpt372_50;
-			else BUG();
-		}
 		if (clock_slot < 2 && port == &info_hpt370)
 			port = &info_hpt370_33;
 		if (clock_slot < 2 && port == &info_hpt370a)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-agpgart.patch
git-dvb.patch
ata_timing-ensure-t-cycle-is-always-correct.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
sl82c105-switch-to-ref-counting-api.patch
git-r8169.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
pci-syscallc-switch-to-refcounting-api.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
driver_bfin_serial_core.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
protect-tty-drivers-list-with-tty_mutex.patch
fix-82875-pci-setup.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
remove-redundant-check-from-proc_sys_setattr.patch
apm-fix-incorrect-comment.patch
upper-32-bits.patch
console-utf-8-fixes.patch
add-pci_try_set_mwi.patch
edd-switch-to-refcounting-pci-apis.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
