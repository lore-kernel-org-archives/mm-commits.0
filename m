From: akpm@linux-foundation.org
Subject: + usb-s3c2410_udc-minor-irq-handler-cleanups.patch added to -mm tree
Date: Mon, 29 Oct 2007 14:47:24 -0700
Message-ID: <200710292147.l9TLlOQ2024983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33995 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbXJ2Vru (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 17:47:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff@garzik.org, david-b@pacbell.net, greg@kroah.com, jgarzik@redhat.com


The patch titled
     USB: s3c2410_udc: minor irq handler cleanups
has been added to the -mm tree.  Its filename is
     usb-s3c2410_udc-minor-irq-handler-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
