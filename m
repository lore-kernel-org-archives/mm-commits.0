From: akpm@linux-foundation.org
Subject: + scsi-ncr5380-minor-irq-handler-cleanups.patch added to -mm tree
Date: Mon, 29 Oct 2007 15:30:38 -0700
Message-ID: <200710292230.l9TMUcJX029111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58815 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393AbXJ2Wa6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 18:30:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, James.Bottomley@steeleye.com, jgarzik@redhat.com


The patch titled
     SCSI/NCR5380: minor irq handler cleanups
has been added to the -mm tree.  Its filename is
     scsi-ncr5380-minor-irq-handler-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SCSI/NCR5380: minor irq handler cleanups
From: Jeff Garzik <jeff@garzik.org>

* remove unnecessary cast

* remove unnecessary use of 'irq' function arg

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/NCR5380.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/NCR5380.c~scsi-ncr5380-minor-irq-handler-cleanups drivers/scsi/NCR5380.c
--- a/drivers/scsi/NCR5380.c~scsi-ncr5380-minor-irq-handler-cleanups
+++ a/drivers/scsi/NCR5380.c
@@ -1157,16 +1157,17 @@ static void NCR5380_main(struct work_str
  *	Locks: takes the needed instance locks
  */
 
-static irqreturn_t NCR5380_intr(int irq, void *dev_id) 
+static irqreturn_t NCR5380_intr(int dummy, void *dev_id)
 {
 	NCR5380_local_declare();
-	struct Scsi_Host *instance = (struct Scsi_Host *)dev_id;
+	struct Scsi_Host *instance = dev_id;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
 	int done;
 	unsigned char basr;
 	unsigned long flags;
 
-	dprintk(NDEBUG_INTR, ("scsi : NCR5380 irq %d triggered\n", irq));
+	dprintk(NDEBUG_INTR, ("scsi : NCR5380 irq %d triggered\n",
+		instance->irq));
 
 	do {
 		done = 1;
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
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
scsi-ncr5380-minor-irq-handler-cleanups.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
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
