From: akpm@linux-foundation.org
Subject: + drivers-usb-gadget-s3c-hsotgc-missing-parentheses.patch added to -mm tree
Date: Wed, 15 Jul 2009 12:32:04 -0700
Message-ID: <200907151932.n6FJW4tn021184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756134AbZGOTdF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 15:33:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, ben@simtec.co.uk, david-b@pacbell.net, gregkh@suse.de


The patch titled
     drivers/usb/gadget/s3c-hsotg.c: missing parentheses
has been added to the -mm tree.  Its filename is
     drivers-usb-gadget-s3c-hsotgc-missing-parentheses.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
drivers-usb-host-xhci-dbgc-less-and-greater-than-confusion.patch
drivers-usb-gadget-s3c-hsotgc-missing-parentheses.patch
dynamic-debug-fix-typo.patch
drivers-gpu-drm-ttm-ttm_bo_vmc-fix-misplaced-parentheses.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m32r-remove-redundant-tests-on-unsigned.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
platinumfb-misplaced-parenthesis.patch
adfs-remove-redundant-test-on-unsigned.patch

