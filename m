From: akpm@linux-foundation.org
Subject: + vioc_irq-switch-to-pci-refcount-safe-api.patch added to -mm tree
Date: Sat, 28 Apr 2007 01:40:31 -0700
Message-ID: <200704280840.l3S8eVUa018200@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161681AbXD1Ikq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 04:40:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com, driver-support@fabric7.com, jeff@garzik.org, schidambaram@fabric7.com


The patch titled
     vioc_irq: Switch to pci refcount safe API
has been added to the -mm tree.  Its filename is
     vioc_irq-switch-to-pci-refcount-safe-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vioc_irq: Switch to pci refcount safe API
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Sriram Chidambaram <schidambaram@fabric7.com>
Cc: <driver-support@fabric7.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/vioc/vioc_irq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/net/vioc/vioc_irq.c~vioc_irq-switch-to-pci-refcount-safe-api drivers/net/vioc/vioc_irq.c
--- a/drivers/net/vioc/vioc_irq.c~vioc_irq-switch-to-pci-refcount-safe-api
+++ a/drivers/net/vioc/vioc_irq.c
@@ -233,9 +233,11 @@ static int get_pci_pin_irq(struct pci_de
 
 	devfn = PCI_DEVFN(slot, func);
 	/* Find pci_dev structure of the requested function */
-	dev = pci_find_slot(dev_in->bus->number, devfn);
+	dev = pci_get_bus_and_slot(dev_in->bus->number, devfn);
 	if (dev) {
-		return dev->irq;
+		int irq = dev->irq
+		pci_dev_put(dev);
+		return irq;
 	} else {
 		return VIOC_IRQ_NONE;
 	}
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

git-agpgart.patch
git-agp-build-fix.patch
git-powerpc.patch
git-libata-all.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
ata_timing-ensure-t-cycle-is-always-correct.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
pata_ali-more-work.patch
git-netdev-all.patch
serial-suppress-rts-assertion-with-disabled-crtscts.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
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
upper-32-bits.patch
console-utf-8-fixes.patch
add-pci_try_set_mwi.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
edd-switch-to-refcounting-pci-apis.patch
sl82c105-switch-to-ref-counting-api.patch
pci-syscallc-switch-to-refcounting-api.patch
plan-b-switch-to-refcounting-pci-api.patch
vioc_irq-switch-to-pci-refcount-safe-api.patch
