From: akpm@linux-foundation.org
Subject: + scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:45:48 -0700
Message-ID: <200710292145.l9TLjmE5024874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60741 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124AbXJ2Vqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:46:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, James.Bottomley@steeleye.com, jgarzik@redhat.com, willy@debian.org


The patch titled
     SCSI/sym53c416: kill pointless irq handler loop and test
has been added to the -mm tree.  Its filename is
     scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SCSI/sym53c416: kill pointless irq handler loop and test
From: Jeff Garzik <jeff@garzik.org>

- kill pointless irq handler loop to find base address, it is already
  passed to irq handler via Scsi_Host.

- kill now-pointless !base test.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sym53c416.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN drivers/scsi/sym53c416.c~scsi-sym53c416-kill-pointless-irq-handler-loop-and-test drivers/scsi/sym53c416.c
--- a/drivers/scsi/sym53c416.c~scsi-sym53c416-kill-pointless-irq-handler-loop-and-test
+++ a/drivers/scsi/sym53c416.c
@@ -328,27 +328,13 @@ static __inline__ unsigned int sym53c416
 static irqreturn_t sym53c416_intr_handle(int irq, void *dev_id)
 {
 	struct Scsi_Host *dev = dev_id;
-	int base = 0;
+	int base = dev->io_port;
 	int i;
 	unsigned long flags = 0;
 	unsigned char status_reg, pio_int_reg, int_reg;
 	struct scatterlist *sg;
 	unsigned int tot_trans = 0;
 
-	/* We search the base address of the host adapter which caused the interrupt */
-	/* FIXME: should pass dev_id sensibly as hosts[i] */
-	for(i = 0; i < host_index && !base; i++)
-		if(irq == hosts[i].irq)
-			base = hosts[i].base;
-	/* If no adapter found, we cannot handle the interrupt. Leave a message */
-	/* and continue. This should never happen...                            */
-	if(!base)
-	{
-		printk(KERN_ERR "sym53c416: No host adapter defined for interrupt %d\n", irq);
-		return IRQ_NONE;
-	}
-	/* Now we have the base address and we can start handling the interrupt */
-
 	spin_lock_irqsave(dev->host_lock,flags);
 	status_reg = inb(base + STATUS_REG);
 	pio_int_reg = inb(base + PIO_INT_REG);
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-arm.patch
media-video-planb-fix-obvious-interrupt-handling-bugs.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-scsi-misc-vs-git-libata-all.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
scsi-gdth-kill-unneeded-irq-argument.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch
git-wireless.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
