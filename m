From: akpm@linux-foundation.org
Subject: - usb-s3c2410_udc-minor-irq-handler-cleanups.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:49:26 -0800
Message-ID: <200711262149.lAQLnQwd024760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36657 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754357AbXKZV72 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:59:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, david-b@pacbell.net, greg@kroah.com, jgarzik@redhat.com, mm-commits@vger.kernel.org


The patch titled
     USB: s3c2410_udc: minor irq handler cleanups
has been removed from the -mm tree.  Its filename was
     usb-s3c2410_udc-minor-irq-handler-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: USB: s3c2410_udc: minor irq handler cleanups
From: Jeff Garzik <jeff@garzik.org>

- 'irq' argument is merely used in place of a constant; replace its usage
  with that constant.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/s3c2410_udc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/gadget/s3c2410_udc.c~usb-s3c2410_udc-minor-irq-handler-cleanups drivers/usb/gadget/s3c2410_udc.c
--- a/drivers/usb/gadget/s3c2410_udc.c~usb-s3c2410_udc-minor-irq-handler-cleanups
+++ a/drivers/usb/gadget/s3c2410_udc.c
@@ -893,7 +893,7 @@ static void s3c2410_udc_handle_ep(struct
 /*
  *	s3c2410_udc_irq - interrupt handler
  */
-static irqreturn_t s3c2410_udc_irq(int irq, void *_dev)
+static irqreturn_t s3c2410_udc_irq(int dummy, void *_dev)
 {
 	struct s3c2410_udc *dev = _dev;
 	int usb_status;
@@ -1016,7 +1016,7 @@ static irqreturn_t s3c2410_udc_irq(int i
 		}
 	}
 
-	dprintk(DEBUG_VERBOSE, "irq: %d s3c2410_udc_done.\n", irq);
+	dprintk(DEBUG_VERBOSE, "irq: %d s3c2410_udc_done.\n", IRQ_USBD);
 
 	/* Restore old index */
 	udc_write(idx, S3C2410_UDC_INDEX_REG);
_

Patches currently in -mm which might be from jeff@garzik.org are

git-arm.patch
powerpc-fix-typo-ifdef-ifndef.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
libata-add-toshiba-mk1637gsx-to-spurious-command-completion-list.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
pcmcia-net-use-roundup_pow_of_two-macro-instead-of-grotesque-loop.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-scsi-rc-fixes.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
scsi-gdth-kill-unneeded-irq-argument.patch
scsi-sym53c416-kill-pointless-irq-handler-loop-and-test.patch
scsi-ncr5380-minor-irq-handler-cleanups.patch
iommu-sg-merging-add-device_dma_parameters-structure.patch
iommu-sg-merging-pci-add-device_dma_parameters-support.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ppc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-ia64-make-sba_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-alpha-make-pci_iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-sparc64-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-parisc-make-iommu-respect-the-segment-size-limits.patch
iommu-sg-merging-call-blk_queue_segment_boundary-in-__scsi_alloc_queue.patch
iommu-sg-merging-sata_inic162x-use-pci_set_dma_max_seg_size.patch
iommu-sg-merging-aacraid-use-pci_set_dma_max_seg_size.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
libsas-use-new-ata-configuration-mechanism.patch
git-wireless.patch
tty-fix-tty-network-driver-interactions-with-tcget-tcset-calls-x86-fix.patch
pata_amd-pata_via-de-couple-programming-of-pio-mwdma-and-udma-timings.patch
fix-versus-precedence-in-various-places.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-pointless-casts-from-void-pointers.patch
i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch
