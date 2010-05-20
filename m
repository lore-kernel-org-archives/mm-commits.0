From: akpm@linux-foundation.org
Subject: + rapidio-fix-maintenance-access-to-higher-memory-areas.patch added to -mm tree
Date: Thu, 20 May 2010 14:09:13 -0700
Message-ID: <201005202109.o4KL9DMd005394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757827Ab0ETVKR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 May 2010 17:10:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas.moll@sysgo.com, alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, mporter@kernel.crashing.org


The patch titled
     rapidio: fix maintenance access to higher memory areas
has been added to the -mm tree.  Its filename is
     rapidio-fix-maintenance-access-to-higher-memory-areas.patch

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
Subject: rapidio: fix maintenance access to higher memory areas
From: Thomas Moll <thomas.moll@sysgo.com>

Fix the maintenance access functions to farend RapidIO devices.
1. Fixed shift of the given offset, to open the maintenance window
2. Mask offset to limit access to the opened maintenance window
3. Added extended destid part to rowtear register, required for 16bit mode

This method is matching maintenance transactions generation described
by Freescale in the appnote AN2932. With this modification full access
to a 16MB maintenance window is possible, this patch is required for
IDT cps switches. For easier handling of the access routines, the
access was limited to aligned memory regions. This should be no problem
because all registers are 32bit wide.

Signed-off-by: Thomas Moll <thomas.moll@sysgo.com>
Tested-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/sysdev/fsl_rio.c |   37 +++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-fix-maintenance-access-to-higher-memory-areas arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-fix-maintenance-access-to-higher-memory-areas
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -1,6 +1,10 @@
 /*
  * Freescale MPC85xx/MPC86xx RapidIO support
  *
+ * Copyright 2009 Sysgo AG
+ * Thomas Moll <thomas.moll@sysgo.com>
+ * - fixed maintenance access routines, check for aligned access
+ *
  * Copyright 2009 Integrated Device Technology, Inc.
  * Alex Bounine <alexandre.bounine@idt.com>
  * - Added Port-Write message handling
@@ -371,10 +375,17 @@ fsl_rio_config_read(struct rio_mport *mp
 	pr_debug
 	    ("fsl_rio_config_read: index %d destid %d hopcount %d offset %8.8x len %d\n",
 	     index, destid, hopcount, offset, len);
+
+	/* 16MB maintenance window possible */
+	/* allow only aligned access to maintenance registers */
+	if (offset > (0x1000000 - len) || !IS_ALIGNED(offset, len))
+		return -EINVAL;
+
 	out_be32(&priv->maint_atmu_regs->rowtar,
-		 (destid << 22) | (hopcount << 12) | ((offset & ~0x3) >> 9));
+		 (destid << 22) | (hopcount << 12) | (offset >> 12));
+	out_be32(&priv->maint_atmu_regs->rowtear,  (destid >> 10));
 
-	data = (u8 *) priv->maint_win + offset;
+	data = (u8 *) priv->maint_win + (offset & (RIO_MAINT_WIN_SIZE - 1));
 	switch (len) {
 	case 1:
 		__fsl_read_rio_config(rval, data, err, "lbz");
@@ -382,9 +393,11 @@ fsl_rio_config_read(struct rio_mport *mp
 	case 2:
 		__fsl_read_rio_config(rval, data, err, "lhz");
 		break;
-	default:
+	case 4:
 		__fsl_read_rio_config(rval, data, err, "lwz");
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	if (err) {
@@ -419,10 +432,17 @@ fsl_rio_config_write(struct rio_mport *m
 	pr_debug
 	    ("fsl_rio_config_write: index %d destid %d hopcount %d offset %8.8x len %d val %8.8x\n",
 	     index, destid, hopcount, offset, len, val);
+
+	/* 16MB maintenance windows possible */
+	/* allow only aligned access to maintenance registers */
+	if (offset > (0x1000000 - len) || !IS_ALIGNED(offset, len))
+		return -EINVAL;
+
 	out_be32(&priv->maint_atmu_regs->rowtar,
-		 (destid << 22) | (hopcount << 12) | ((offset & ~0x3) >> 9));
+		 (destid << 22) | (hopcount << 12) | (offset >> 12));
+	out_be32(&priv->maint_atmu_regs->rowtear,  (destid >> 10));
 
-	data = (u8 *) priv->maint_win + offset;
+	data = (u8 *) priv->maint_win + (offset & (RIO_MAINT_WIN_SIZE - 1));
 	switch (len) {
 	case 1:
 		out_8((u8 *) data, val);
@@ -430,9 +450,11 @@ fsl_rio_config_write(struct rio_mport *m
 	case 2:
 		out_be16((u16 *) data, val);
 		break;
-	default:
+	case 4:
 		out_be32((u32 *) data, val);
 		break;
+	default:
+		return -EINVAL;
 	}
 
 	return 0;
@@ -1483,7 +1505,8 @@ int fsl_rio_setup(struct of_device *dev)
 
 	/* Configure maintenance transaction window */
 	out_be32(&priv->maint_atmu_regs->rowbar, law_start >> 12);
-	out_be32(&priv->maint_atmu_regs->rowar, 0x80077015);	/* 4M */
+	out_be32(&priv->maint_atmu_regs->rowar,
+		 0x80077000 | (ilog2(RIO_MAINT_WIN_SIZE) - 1));
 
 	priv->maint_win = ioremap(law_start, RIO_MAINT_WIN_SIZE);
 
_

Patches currently in -mm which might be from thomas.moll@sysgo.com are

rapidio-add-idt-cps-tsi-switches.patch
rapidio-add-switch-locking-during-discovery.patch
rapidio-add-port-write-handling-for-em.patch
rapidio-powerpc-85xx-add-port-write-message-handler-for-srio-port.patch
rapidio-powerpc-85xx-add-mchk-handler-for-srio-port.patch
rapidio-add-enabling-srio-port-rx-and-tx.patch
rapidio-fix-typos-and-minor-edits.patch
rapidio-add-debug-configuration-option.patch
rapidio-modify-initialization-of-switch-operations.patch
rapidio-add-switch-domain-routines.patch
rapidio-use-default-route-value-for-cps-switches.patch
rapidio-fix-maintenance-access-to-higher-memory-areas.patch

