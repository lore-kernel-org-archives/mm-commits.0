From: akpm@linux-foundation.org
Subject: + ppc-pci_32-stop-using-old-hotplug-unsafe-apis.patch added to -mm tree
Date: Mon, 23 Apr 2007 10:33:14 -0700
Message-ID: <200704231733.l3NHXEf2020592@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754076AbXDWRdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Apr 2007 13:33:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     PPC pci_32: Stop using old hotplug unsafe APIs
has been added to the -mm tree.  Its filename is
     ppc-pci_32-stop-using-old-hotplug-unsafe-apis.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PPC pci_32: Stop using old hotplug unsafe APIs
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

pci_find_slot isn't hot-plug safe.  Move this code to the pci hotplug safe
equivalent and hold a refcount properly while doinmg make_one_node_map.

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/pci_32.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/pci_32.c~ppc-pci_32-stop-using-old-hotplug-unsafe-apis arch/powerpc/kernel/pci_32.c
--- a/arch/powerpc/kernel/pci_32.c~ppc-pci_32-stop-using-old-hotplug-unsafe-apis
+++ a/arch/powerpc/kernel/pci_32.c
@@ -656,10 +656,13 @@ make_one_node_map(struct device_node* no
 		reg = of_get_property(node, "reg", NULL);
 		if (!reg)
 			continue;
-		dev = pci_find_slot(pci_bus, ((reg[0] >> 8) & 0xff));
-		if (!dev || !dev->subordinate)
+		dev = pci_get_bus_and_slot(pci_bus, ((reg[0] >> 8) & 0xff));
+		if (!dev || !dev->subordinate) {
+			pci_dev_put(dev);
 			continue;
+		}
 		make_one_node_map(node, dev->subordinate->number);
+		pci_dev_put(dev);
 	}
 }
 	
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
char-mxser_new-fix-recursive-locking.patch
char-mxser_new-fix-tiocmiwait.patch
char-mxser-fix-tiocmiwait.patch
ppc-pci_32-stop-using-old-hotplug-unsafe-apis.patch
git-libata-all.patch
pata_hpt37x-further-small-fixes.patch
pata_hpt3x2n-add-hpt371n-support-and-other-bits.patch
drivers-ata-pata_cmd640c-fix-build-with-config_pm=n.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma.patch
testing-patch-for-ali-pata-fixes-hopefully-for-the-problems-with-atapi-dma-fix.patch
git-netdev-all.patch
git-netdev-all-baycom_ser_fdx-fix.patch
pcmcia-irq-probe-can-be-done-without-risking-an-irq-storm.patch
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
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
revoke-core-code-revoke-no-revoke-for-nommu.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-arm.patch
