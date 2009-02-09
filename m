From: akpm@linux-foundation.org
Subject: [merged] radeonfb-fix-resume-from-d3cold-on-some-platforms.patch removed from -mm tree
Date: Mon, 09 Feb 2009 12:05:17 -0800
Message-ID: <200902092005.n19K5HEF024240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922AbZBIUL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 15:11:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, geert@linux-m68k.org, khc@pm.waw.pl, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     radeonfb: fix resume from D3Cold on some platforms
has been removed from the -mm tree.  Its filename was
     radeonfb-fix-resume-from-d3cold-on-some-platforms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: radeonfb: fix resume from D3Cold on some platforms
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

For historical reason, this driver used its own saving/restoring of the
PCI config space, and used the state of it on resume as an indication as
to whether it needed to re-POST the chip or not.

This methods breaks with the later core changes since the core will have
restored things for us.

This patch fixes it by removing that custom code, using standard core
methods to save/restore state, and testing for the need to re-POST by
comparing the content of a few key PLL registers.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_pm.c |   85 +++++++-------------------------
 drivers/video/aty/radeonfb.h  |    2 
 2 files changed, 20 insertions(+), 67 deletions(-)

diff -puN drivers/video/aty/radeon_pm.c~radeonfb-fix-resume-from-d3cold-on-some-platforms drivers/video/aty/radeon_pm.c
--- a/drivers/video/aty/radeon_pm.c~radeonfb-fix-resume-from-d3cold-on-some-platforms
+++ a/drivers/video/aty/radeon_pm.c
@@ -2509,9 +2509,7 @@ static void radeon_reinitialize_QW(struc
 
 static void radeon_set_suspend(struct radeonfb_info *rinfo, int suspend)
 {
-	u16 pwr_cmd;
 	u32 tmp;
-	int i;
 
 	if (!rinfo->pm_reg)
 		return;
@@ -2557,32 +2555,14 @@ static void radeon_set_suspend(struct ra
 			}
 		}
 
-		for (i = 0; i < 64; ++i)
-			pci_read_config_dword(rinfo->pdev, i * 4,
-					      &rinfo->cfg_save[i]);
-
 		/* Switch PCI power management to D2. */
 		pci_disable_device(rinfo->pdev);
-		for (;;) {
-			pci_read_config_word(
-				rinfo->pdev, rinfo->pm_reg+PCI_PM_CTRL,
-				&pwr_cmd);
-			if (pwr_cmd & 2)
-				break;			
-			pci_write_config_word(
-				rinfo->pdev, rinfo->pm_reg+PCI_PM_CTRL,
-				(pwr_cmd & ~PCI_PM_CTRL_STATE_MASK) | 2);
-			mdelay(500);
-		}
+		pci_save_state(rinfo->pdev);
+		pci_set_power_state(rinfo->pdev, PCI_D2);
 	} else {
 		printk(KERN_DEBUG "radeonfb (%s): switching to D0 state...\n",
 		       pci_name(rinfo->pdev));
 
-		/* Switch back PCI powermanagment to D0 */
-		mdelay(200);
-		pci_write_config_word(rinfo->pdev, rinfo->pm_reg+PCI_PM_CTRL, 0);
-		mdelay(500);
-
 		if (rinfo->family <= CHIP_FAMILY_RV250) {
 			/* Reset the SDRAM controller  */
 			radeon_pm_full_reset_sdram(rinfo);
@@ -2598,37 +2578,10 @@ static void radeon_set_suspend(struct ra
 	}
 }
 
-static int radeon_restore_pci_cfg(struct radeonfb_info *rinfo)
-{
-	int i;
-	static u32 radeon_cfg_after_resume[64];
-
-	for (i = 0; i < 64; ++i)
-		pci_read_config_dword(rinfo->pdev, i * 4,
-				      &radeon_cfg_after_resume[i]);
-
-	if (radeon_cfg_after_resume[PCI_BASE_ADDRESS_0/4]
-	    == rinfo->cfg_save[PCI_BASE_ADDRESS_0/4])
-		return 0;	/* assume everything is ok */
-
-	for (i = PCI_BASE_ADDRESS_0/4; i < 64; ++i) {
-		if (radeon_cfg_after_resume[i] != rinfo->cfg_save[i])
-			pci_write_config_dword(rinfo->pdev, i * 4,
-					       rinfo->cfg_save[i]);
-	}
-	pci_write_config_word(rinfo->pdev, PCI_CACHE_LINE_SIZE,
-			      rinfo->cfg_save[PCI_CACHE_LINE_SIZE/4]);
-	pci_write_config_word(rinfo->pdev, PCI_COMMAND,
-			      rinfo->cfg_save[PCI_COMMAND/4]);
-	return 1;
-}
-
-
 int radeonfb_pci_suspend(struct pci_dev *pdev, pm_message_t mesg)
 {
         struct fb_info *info = pci_get_drvdata(pdev);
         struct radeonfb_info *rinfo = info->par;
-	int i;
 
 	if (mesg.event == pdev->dev.power.power_state.event)
 		return 0;
@@ -2674,6 +2627,11 @@ int radeonfb_pci_suspend(struct pci_dev 
 	pmac_suspend_agp_for_card(pdev);
 #endif /* CONFIG_PPC_PMAC */
 
+	/* It's unclear whether or when the generic code will do that, so let's
+	 * do it ourselves. We save state before we do any power management
+	 */
+	pci_save_state(pdev);
+
 	/* If we support wakeup from poweroff, we save all regs we can including cfg
 	 * space
 	 */
@@ -2698,9 +2656,6 @@ int radeonfb_pci_suspend(struct pci_dev 
 			mdelay(20);
 			OUTREG(LVDS_GEN_CNTL, INREG(LVDS_GEN_CNTL) & ~(LVDS_DIGON));
 		}
-		// FIXME: Use PCI layer
-		for (i = 0; i < 64; ++i)
-			pci_read_config_dword(pdev, i * 4, &rinfo->cfg_save[i]);
 		pci_disable_device(pdev);
 	}
 	/* If we support D2, we go to it (should be fixed later with a flag forcing
@@ -2717,6 +2672,13 @@ int radeonfb_pci_suspend(struct pci_dev 
 	return 0;
 }
 
+static int radeon_check_power_loss(struct radeonfb_info *rinfo)
+{
+	return rinfo->save_regs[4] != INPLL(CLK_PIN_CNTL) ||
+	       rinfo->save_regs[2] != INPLL(MCLK_CNTL) ||
+	       rinfo->save_regs[3] != INPLL(SCLK_CNTL);
+}
+
 int radeonfb_pci_resume(struct pci_dev *pdev)
 {
         struct fb_info *info = pci_get_drvdata(pdev);
@@ -2735,20 +2697,13 @@ int radeonfb_pci_resume(struct pci_dev *
 	printk(KERN_DEBUG "radeonfb (%s): resuming from state: %d...\n",
 	       pci_name(pdev), pdev->dev.power.power_state.event);
 
-
-	if (pci_enable_device(pdev)) {
-		rc = -ENODEV;
-		printk(KERN_ERR "radeonfb (%s): can't enable PCI device !\n",
-		       pci_name(pdev));
-		goto bail;
-	}
-	pci_set_master(pdev);
-
+	/* PCI state will have been restored by the core, so
+	 * we should be in D0 now with our config space fully
+	 * restored
+	 */
 	if (pdev->dev.power.power_state.event == PM_EVENT_SUSPEND) {
-		/* Wakeup chip. Check from config space if we were powered off
-		 * (todo: additionally, check CLK_PIN_CNTL too)
-		 */
-		if ((rinfo->pm_mode & radeon_pm_off) && radeon_restore_pci_cfg(rinfo)) {
+		/* Wakeup chip */
+		if ((rinfo->pm_mode & radeon_pm_off) && radeon_check_power_loss(rinfo)) {
 			if (rinfo->reinit_func != NULL)
 				rinfo->reinit_func(rinfo);
 			else {
diff -puN drivers/video/aty/radeonfb.h~radeonfb-fix-resume-from-d3cold-on-some-platforms drivers/video/aty/radeonfb.h
--- a/drivers/video/aty/radeonfb.h~radeonfb-fix-resume-from-d3cold-on-some-platforms
+++ a/drivers/video/aty/radeonfb.h
@@ -361,8 +361,6 @@ struct radeonfb_info {
 #ifdef CONFIG_FB_RADEON_I2C
 	struct radeon_i2c_chan 	i2c[4];
 #endif
-
-	u32			cfg_save[64];
 };
 
 
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

linux-next.patch
arch-powerpc-eliminate-double-sizeof.patch
arch-powerpc-eliminate-double-sizeof-checkpatch-fixes.patch
aty128fb-properly-save-pci-state-before-changing-pci-pm-level-fix.patch
powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
spi_mpc83xx-fix-sparse-warnings.patch
spi_mpc83xx-rework-chip-selects-handling.patch
spi_mpc83xx-add-of-platform-driver-bindings.patch
powerpc-add-mmc-spi-slot-bindings.patch
powerpc-83xx-add-mmc-spi-support-via-the-device-tree-for-mpc8323e-rdb.patch
powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards.patch
atyfb-fix-header-file-trailing-whitespace.patch
edac-new-ppc4xx-driver-module.patch
edac-new-ppc4xx-driver-module-update.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes.patch
edac-new-ppc4xx-driver-module-update-checkpatch-fixes-checkpatch-fixes.patch

