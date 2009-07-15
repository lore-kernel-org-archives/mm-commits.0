From: akpm@linux-foundation.org
Subject: + edac-mpc85xx-add-mpc83xx-support.patch added to -mm tree
Date: Wed, 15 Jul 2009 12:53:08 -0700
Message-ID: <200907151953.n6FJr8DW021112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756204AbZGOTxs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Jul 2009 15:53:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com, galak@gate.crashing.org, iws@ovro.caltech.edu


The patch titled
     edac: mpc85xx add mpc83xx support
has been added to the -mm tree.  Its filename is
     edac-mpc85xx-add-mpc83xx-support.patch

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
Subject: edac: mpc85xx add mpc83xx support
From: Doug Thompson <dougthompson@xmission.com>

Add support for the Freescale MPC83xx memory controller to the existing
driver for the Freescale MPC85xx memory controller.  The only difference
between the two processors are in the CS_BNDS register parsing code, which
has been changed so it will work on both processors.

The L2 cache controller does not exist on the MPC83xx, but the OF
subsystem will not use the driver if the device is not present in the OF
device tree.

I had to change the nr_pages calculation to make the math work out.  I
checked it on my board and did the math by hand for a 64GB 85xx using 64K
pages.  In both cases, nr_pages * PAGE_SIZE comes out to the correct
value.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig        |    6 +++---
 drivers/edac/mpc85xx_edac.c |   28 +++++++++++++++++++---------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff -puN drivers/edac/Kconfig~edac-mpc85xx-add-mpc83xx-support drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-mpc85xx-add-mpc83xx-support
+++ a/drivers/edac/Kconfig
@@ -176,11 +176,11 @@ config EDAC_I5100
 	  San Clemente MCH.
 
 config EDAC_MPC85XX
-	tristate "Freescale MPC85xx"
-	depends on EDAC_MM_EDAC && FSL_SOC && MPC85xx
+	tristate "Freescale MPC83xx / MPC85xx"
+	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || MPC85xx)
 	help
 	  Support for error detection and correction on the Freescale
-	  MPC8560, MPC8540, MPC8548
+	  MPC8349, MPC8560, MPC8540, MPC8548
 
 config EDAC_MV64X60
 	tristate "Marvell MV64x60"
diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-mpc83xx-support drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-mpc83xx-support
+++ a/drivers/edac/mpc85xx_edac.c
@@ -41,7 +41,9 @@ static u32 orig_pci_err_en;
 #endif
 
 static u32 orig_l2_err_disable;
+#ifdef CONFIG_MPC85xx
 static u32 orig_hid1[2];
+#endif
 
 /************************ MC SYSFS parts ***********************************/
 
@@ -789,19 +791,20 @@ static void __devinit mpc85xx_init_csrow
 		csrow = &mci->csrows[index];
 		cs_bnds = in_be32(pdata->mc_vbase + MPC85XX_MC_CS_BNDS_0 +
 				  (index * MPC85XX_MC_CS_BNDS_OFS));
-		start = (cs_bnds & 0xfff0000) << 4;
-		end = ((cs_bnds & 0xfff) << 20);
-		if (start)
-			start |= 0xfffff;
-		if (end)
-			end |= 0xfffff;
+
+		start = (cs_bnds & 0xffff0000) >> 16;
+		end   = (cs_bnds & 0x0000ffff);
 
 		if (start == end)
 			continue;	/* not populated */
 
+		start <<= (24 - PAGE_SHIFT);
+		end   <<= (24 - PAGE_SHIFT);
+		end    |= (1 << (24 - PAGE_SHIFT)) - 1;
+
 		csrow->first_page = start >> PAGE_SHIFT;
 		csrow->last_page = end >> PAGE_SHIFT;
-		csrow->nr_pages = csrow->last_page + 1 - csrow->first_page;
+		csrow->nr_pages = end + 1 - start;
 		csrow->grain = 8;
 		csrow->mtype = mtype;
 		csrow->dtype = DEV_UNKNOWN;
@@ -985,6 +988,7 @@ static struct of_device_id mpc85xx_mc_er
 	{ .compatible = "fsl,mpc8560-memory-controller", },
 	{ .compatible = "fsl,mpc8568-memory-controller", },
 	{ .compatible = "fsl,mpc8572-memory-controller", },
+	{ .compatible = "fsl,mpc8349-memory-controller", },
 	{ .compatible = "fsl,p2020-memory-controller", },
 	{},
 };
@@ -1001,13 +1005,13 @@ static struct of_platform_driver mpc85xx
 		   },
 };
 
-
+#ifdef CONFIG_MPC85xx
 static void __init mpc85xx_mc_clear_rfxe(void *data)
 {
 	orig_hid1[smp_processor_id()] = mfspr(SPRN_HID1);
 	mtspr(SPRN_HID1, (orig_hid1[smp_processor_id()] & ~0x20000));
 }
-
+#endif
 
 static int __init mpc85xx_mc_init(void)
 {
@@ -1040,26 +1044,32 @@ static int __init mpc85xx_mc_init(void)
 		printk(KERN_WARNING EDAC_MOD_STR "PCI fails to register\n");
 #endif
 
+#ifdef CONFIG_MPC85xx
 	/*
 	 * need to clear HID1[RFXE] to disable machine check int
 	 * so we can catch it
 	 */
 	if (edac_op_state == EDAC_OPSTATE_INT)
 		on_each_cpu(mpc85xx_mc_clear_rfxe, NULL, 0);
+#endif
 
 	return 0;
 }
 
 module_init(mpc85xx_mc_init);
 
+#ifdef CONFIG_MPC85xx
 static void __exit mpc85xx_mc_restore_hid1(void *data)
 {
 	mtspr(SPRN_HID1, orig_hid1[smp_processor_id()]);
 }
+#endif
 
 static void __exit mpc85xx_mc_exit(void)
 {
+#ifdef CONFIG_MPC85xx
 	on_each_cpu(mpc85xx_mc_restore_hid1, NULL, 0);
+#endif
 #ifdef CONFIG_PCI
 	of_unregister_platform_driver(&mpc85xx_pci_err_driver);
 #endif
_

Patches currently in -mm which might be from dougthompson@xmission.com are

edac-mpc85xx-add-p2020ds-support.patch
edac-mpc85xx-add-mpc83xx-support.patch
edac-x83-fix-mchbar-high-register-addr.patch
edac-fix-resource-size-calculation.patch

