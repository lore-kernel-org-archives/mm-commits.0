From: akpm@linux-foundation.org
Subject: - vioc_irq-switch-to-pci-refcount-safe-api.patch removed from -mm tree
Date: Mon, 30 Apr 2007 14:36:53 -0700
Message-ID: <200704302136.l3ULarnB015483@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423696AbXD3Vhk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 17:37:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, driver-support@fabric7.com, jeff@garzik.org, schidambaram@fabric7.com, mm-commits@vger.kernel.org


The patch titled
     vioc_irq: Switch to pci refcount safe API
has been removed from the -mm tree.  Its filename was
     vioc_irq-switch-to-pci-refcount-safe-api.patch

This patch was dropped because it is obsolete

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
+		int irq = dev->irq;
+		pci_dev_put(dev);
+		return irq;
 	} else {
 		return VIOC_IRQ_NONE;
 	}
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
vioc_irq-switch-to-pci-refcount-safe-api.patch
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
