From: akpm@linux-foundation.org
Subject: + powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch added to -mm tree
Date: Thu, 21 Jul 2016 11:40:38 -0700
Message-ID: <57911726.oz/8kNelL5r20cCS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbcGUSkj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Jul 2016 14:40:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, benh@kernel.crashing.org, mpe@ellerman.id.au, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fsl_rio: apply changes for RIO spec rev 3
has been added to the -mm tree.  Its filename is
     powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: powerpc/fsl_rio: apply changes for RIO spec rev 3

- Remove check for parallel PHY
- Set LP-Serial Register Map type

Link: http://lkml.kernel.org/r/1469125134-16523-13-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3 arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -643,19 +643,11 @@ int fsl_rio_setup(struct platform_device
 		port->ops = ops;
 		port->priv = priv;
 		port->phys_efptr = 0x100;
+		port->phys_rmap = 1;
 		priv->regs_win = rio_regs_win;
 
-		/* Probe the master port phy type */
 		ccsr = in_be32(priv->regs_win + RIO_CCSR + i*0x20);
-		port->phy_type = (ccsr & 1) ? RIO_PHY_SERIAL : RIO_PHY_PARALLEL;
-		if (port->phy_type == RIO_PHY_PARALLEL) {
-			dev_err(&dev->dev, "RIO: Parallel PHY type, unsupported port type!\n");
-			release_resource(&port->iores);
-			kfree(priv);
-			kfree(port);
-			continue;
-		}
-		dev_info(&dev->dev, "RapidIO PHY type: Serial\n");
+
 		/* Checking the port training status */
 		if (in_be32((priv->regs_win + RIO_ESCSR + i*0x20)) & 1) {
 			dev_err(&dev->dev, "Port %d is not ready. "
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-add-rapidio-channelized-messaging-driver.patch
rapidio-documentation-fix-mangled-paragraph-in-mport_cdev.patch
rapidio-fix-return-value-description-for-dma_prep-functions.patch
rapidio-tsi721_dma-add-channel-mask-and-queue-size-parameters.patch
rapidio-tsi721-add-pcie-mrrs-override-parameter.patch
rapidio-tsi721-add-messaging-mbox-selector-parameter.patch
rapidio-tsi721_dma-advance-queue-processing-from-transfer-submit-call.patch
rapidio-fix-error-handling-in-mbox-request-release-functions.patch
rapidio-idt_gen2-fix-locking-warning.patch
rapidio-change-inbound-window-size-type-to-u64.patch
rapidio-modify-for-rev3-specification-changes.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
rapidio-switches-add-driver-for-idt-gen3-switches.patch

