From: akpm@linux-foundation.org
Subject: [merged] drivers-usb-gadget-s3c-hsotgc-missing-parentheses.patch removed from -mm tree
Date: Mon, 20 Jul 2009 12:00:22 -0700
Message-ID: <200907201900.n6KJ0MPN013610@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57868 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbZGTTBY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Jul 2009 15:01:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, ben@simtec.co.uk, david-b@pacbell.net, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/gadget/s3c-hsotg.c: missing parentheses
has been removed from the -mm tree.  Its filename was
     drivers-usb-gadget-s3c-hsotgc-missing-parentheses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/gadget/s3c-hsotg.c: missing parentheses
From: Roel Kluin <roel.kluin@gmail.com>

Add missing parentheses

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/s3c-hsotg.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/usb/gadget/s3c-hsotg.c~drivers-usb-gadget-s3c-hsotgc-missing-parentheses drivers/usb/gadget/s3c-hsotg.c
--- a/drivers/usb/gadget/s3c-hsotg.c~drivers-usb-gadget-s3c-hsotgc-missing-parentheses
+++ a/drivers/usb/gadget/s3c-hsotg.c
@@ -2392,7 +2392,7 @@ static int s3c_hsotg_corereset(struct s3
 		grstctl = readl(hsotg->regs + S3C_GRSTCTL);
 	} while (!(grstctl & S3C_GRSTCTL_CSftRst) && timeout-- > 0);
 
-	if (!grstctl & S3C_GRSTCTL_CSftRst) {
+	if (!(grstctl & S3C_GRSTCTL_CSftRst)) {
 		dev_err(hsotg->dev, "Failed to get CSftRst asserted\n");
 		return -EINVAL;
 	}
@@ -2514,8 +2514,8 @@ int usb_gadget_register_driver(struct us
 	 * DMA mode we may need this. */
 	writel(S3C_DOEPMSK_SetupMsk | S3C_DOEPMSK_AHBErrMsk |
 	       S3C_DOEPMSK_EPDisbldMsk |
-	       using_dma(hsotg) ? (S3C_DIEPMSK_XferComplMsk |
-				   S3C_DIEPMSK_TimeOUTMsk) : 0,
+	       (using_dma(hsotg) ? (S3C_DIEPMSK_XferComplMsk |
+				   S3C_DIEPMSK_TimeOUTMsk) : 0),
 	       hsotg->regs + S3C_DOEPMSK);
 
 	writel(0, hsotg->regs + S3C_DAINTMSK);
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch
ext4-remove-redundant-test-on-unsigned.patch
drivers-scsi-fnic-fnic_scsic-clean-up.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
adfs-remove-redundant-test-on-unsigned.patch

