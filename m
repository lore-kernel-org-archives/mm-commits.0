From: akpm@linux-foundation.org
Subject: + pata_sis-fix-oops-on-boot.patch added to -mm tree
Date: Thu, 19 Apr 2007 14:57:54 -0700
Message-ID: <200704192157.l3JLvsI9032094@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbXDSV6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 17:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     pata_sis: Fix oops on boot
has been added to the -mm tree.  Its filename is
     pata_sis-fix-oops-on-boot.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_sis: Fix oops on boot
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

A small number of SiS setups require special handling (not many judging by
how long this dumb bug survived).  A couple of Fedora 7 devel testers hit
an Oops on pata_sis loading which is caused by terminal confusion between
chipset as 'the chipset we have found' and chipset as 'array iterator'

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_sis.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/ata/pata_sis.c~pata_sis-fix-oops-on-boot drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~pata_sis-fix-oops-on-boot
+++ a/drivers/ata/pata_sis.c
@@ -831,6 +831,7 @@ static int sis_init_one (struct pci_dev 
 	struct ata_port_info *port;
 	struct pci_dev *host = NULL;
 	struct sis_chipset *chipset = NULL;
+	struct sis_chipset *sets;
 
 	static struct sis_chipset sis_chipsets[] = {
 
@@ -885,10 +886,11 @@ static int sis_init_one (struct pci_dev 
 
 	/* We have to find the bridge first */
 
-	for (chipset = &sis_chipsets[0]; chipset->device; chipset++) {
-		host = pci_get_device(PCI_VENDOR_ID_SI, chipset->device, NULL);
+	for (sets = &sis_chipsets[0]; sets->device; sets++) {
+		host = pci_get_device(PCI_VENDOR_ID_SI, sets->device, NULL);
 		if (host != NULL) {
-			if (chipset->device == 0x630) {	/* SIS630 */
+			chipset = sets;			/* Match found */
+			if (sets->device == 0x630) {	/* SIS630 */
 				u8 host_rev;
 				pci_read_config_byte(host, PCI_REVISION_ID, &host_rev);
 				if (host_rev >= 0x30)	/* 630 ET */
@@ -899,7 +901,7 @@ static int sis_init_one (struct pci_dev 
 	}
 
 	/* Look for concealed bridges */
-	if (host == NULL) {
+	if (chipset == NULL) {
 		/* Second check */
 		u32 idemisc;
 		u16 trueid;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
git-netdev-all.patch
pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
pata_sis-fix-oops-on-boot.patch
driver_bfin_serial_core.patch
driver_bfin_serial_core-update.patch
documentation-ask-driver-writers-to-provide-pm-support.patch
tty-clarify-documentation-of-write.patch
tty-i386-x86_64-arbitary-speed-support.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
tty-remove-unnecessary-export-of-proc_clear_tty.patch
tty-simplify-calling-of-put_pid.patch
tty-introduce-no_tty-and-use-it-in-selinux.patch
tty-in-tiocsctty-when-we-steal-a-tty-hang-it-up.patch
protect-tty-drivers-list-with-tty_mutex.patch
fix-82875-pci-setup.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
remove-redundant-check-from-proc_sys_setattr.patch
apm-fix-incorrect-comment.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
