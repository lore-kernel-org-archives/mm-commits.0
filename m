From: akpm@linux-foundation.org
Subject: [merged] powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch
 removed from -mm tree
Date: Wed, 03 Aug 2016 11:14:41 -0700
Message-ID: <57a23491.0tLZ082ykW3aDYX2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758035AbcHCSOm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:14:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, andre.van.herk@prodrive-technologies.com, barry.wood@idt.com, benh@kernel.crashing.org, mpe@ellerman.id.au, mporter@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/fsl_rio: apply changes for RIO spec rev 3
has been removed from the -mm tree.  Its filename was
     powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: powerpc/fsl_rio: apply changes for RIO spec rev 3

- Remove check for parallel PHY
- Set LP-Serial Register Map type

[akpm@linux-foundation.org: fix build]
[alexandre.bounine@idt.com: fix build fix]
 Link: http://lkml.kernel.org/r/20160802184932.2755-1-alexandre.bounine@idt.com
Link: http://lkml.kernel.org/r/1469125134-16523-13-git-send-email-alexandre.bounine@idt.com
Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Barry Wood <barry.wood@idt.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

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
@@ -705,11 +697,9 @@ int fsl_rio_setup(struct platform_device
 			((i == 0) ? RIO_INB_ATMU_REGS_PORT1_OFFSET :
 			RIO_INB_ATMU_REGS_PORT2_OFFSET));
 
