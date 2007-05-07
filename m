From: akpm@linux-foundation.org
Subject: - qla1280-use-dma_64bit_mask-instead-of-0ull.patch removed from -mm tree
Date: Sun, 06 May 2007 23:52:10 -0700
Message-ID: <200705070652.l476qANS020627@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754075AbXEGGwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 02:52:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     qla1280: use DMA_64BIT_MASK instead of ~0ULL
has been removed from the -mm tree.  Its filename was
     qla1280-use-dma_64bit_mask-instead-of-0ull.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: qla1280: use DMA_64BIT_MASK instead of ~0ULL
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

QLA1280: call pci_set_dma_mask with DMA_64BIT_MASK instead of  ~0ULL

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/qla1280.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/qla1280.c~qla1280-use-dma_64bit_mask-instead-of-0ull drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c~qla1280-use-dma_64bit_mask-instead-of-0ull
+++ a/drivers/scsi/qla1280.c
@@ -4293,7 +4293,7 @@ qla1280_probe_one(struct pci_dev *pdev, 
 	ha->devnum = devnum;	/* specifies microcode load address */
 
 #ifdef QLA_64BIT_PTR
-	if (pci_set_dma_mask(ha->pdev, (dma_addr_t) ~ 0ULL)) {
+	if (pci_set_dma_mask(ha->pdev, DMA_64BIT_MASK)) {
 		if (pci_set_dma_mask(ha->pdev, DMA_32BIT_MASK)) {
 			printk(KERN_WARNING "scsi(%li): Unable to set a "
 			       "suitable DMA mask - aborting\n", ha->host_no);
_

Patches currently in -mm which might be from matthias.kaehlcke@gmail.com are

origin.patch
include-kern_-constant-in-printk-calls-in-mm-slabc.patch
srmcons-fix-kmallocgfp_kernel-inside-spinlock.patch
kcopyd-use-mutex-instead-of-semaphore.patch
power-management-use-mutexes-instead-of-semaphores.patch
sysdev-use-mutex-instead-of-semaphore.patch
git-dvb.patch
scx200-use-mutex-instead-of-semaphore.patch
use-mutex-instead-of-binary-semaphore-in-idt77252-driver.patch
git-scsi-misc.patch
use-mutex-instead-of-binary-semaphore-in-cdu-31a-driver.patch
use-mutex-instead-of-semaphore-in-sbpcd-driver.patch
use-mutex-instead-of-semaphore-in-berkshire-usb-pc-watchdog-driver.patch
git-watchdog.patch
use-mutex-instead-of-semaphore-in-rocketport-driver.patch
use-mutex-instead-of-semaphore-in-tpm-driver.patch
use-mutex-instead-of-semaphore-in-hdaps-driver.patch
use-mutex-instead-of-semaphore-for-misc-char-devices.patch
fix-spinlock-usage-in-hysdn_log_close.patch
use-mutex-instead-of-semaphore-in-capi-20-interface.patch
use-mutex-instead-of-semaphore-in-virtual-console-driver.patch
