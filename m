From: akpm@linux-foundation.org
Subject: + misc-tifm_7xx1-replace-deprecated-irq-flag.patch added to -mm tree
Date: Tue, 29 May 2007 16:07:07 -0700
Message-ID: <200705292307.l4TN77vR013946@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbXE2XHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 19:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, oakad@yahoo.com


The patch titled
     misc/tifm_7xx1: replace deprecated irq flag
has been added to the -mm tree.  Its filename is
     misc-tifm_7xx1-replace-deprecated-irq-flag.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: misc/tifm_7xx1: replace deprecated irq flag
From: Jeff Garzik <jeff@garzik.org>

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/tifm_7xx1.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/tifm_7xx1.c~misc-tifm_7xx1-replace-deprecated-irq-flag drivers/misc/tifm_7xx1.c
--- a/drivers/misc/tifm_7xx1.c~misc-tifm_7xx1-replace-deprecated-irq-flag
+++ a/drivers/misc/tifm_7xx1.c
@@ -343,7 +343,7 @@ static int tifm_7xx1_probe(struct pci_de
 	if (!fm->addr)
 		goto err_out_free;
 
-	rc = request_irq(dev->irq, tifm_7xx1_isr, SA_SHIRQ, DRIVER_NAME, fm);
+	rc = request_irq(dev->irq, tifm_7xx1_isr, IRQF_SHARED, DRIVER_NAME, fm);
 	if (rc)
 		goto err_out_unmap;
 
_

Patches currently in -mm which might be from jeff@garzik.org are

pci-quirks-fix-msi-disabling-on-rs400-200-and-rs480.patch
git-ieee1394.patch
git-libata-all.patch
git-ubi.patch
git-netdev-all.patch
8139too-force-media-setting-fix.patch
blackfin-on-chip-ethernet-mac-controller-driver.patch
use-menuconfig-objects-ii-netdev-general100mbit.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
atm-fix-warning.patch
git-ioat.patch
remove-pci_dac_dma_-apis.patch
git-pciseg.patch
pci-device-ensure-sysdata-initialised-v2.patch
s390-spinlock-initializer-cleanup.patch
git-scsi-misc.patch
pci-x-pci-express-read-control-interfaces-e1000.patch
add-select-phylib-to-the-ucc_geth-kconfig-option.patch
potential-parse-error-in-ifdef.patch
e1000-restore-netif_poll_enable-call-but-make-sure-irqs-are-off.patch
misc-tifm_7xx1-replace-deprecated-irq-flag.patch
lguest-the-guest-code-tidyups-update.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups-update.patch
git-gccbug.patch
