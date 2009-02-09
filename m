From: akpm@linux-foundation.org
Subject: [merged] aty128fb-properly-save-pci-state-before-changing-pci-pm-level.patch removed from -mm tree
Date: Mon, 09 Feb 2009 12:05:15 -0800
Message-ID: <200902092005.n19K5FfU024175@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809AbZBIUL0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Feb 2009 15:11:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, geert@linux-m68k.org, khc@pm.waw.pl, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     aty128fb: properly save PCI state before changing PCI PM level
has been removed from the -mm tree.  Its filename was
     aty128fb-properly-save-pci-state-before-changing-pci-pm-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aty128fb: properly save PCI state before changing PCI PM level
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

This fixes aty128fb to properly save the PCI config space -before- it
potentially switches the PM state of the chip.  This avoids a warning with
the new PM core and is the right thing to do anyway.

I also replaced the hand-coded switch to D2 with a call to the genericc
pci_set_power_state() and removed the code that switches it back to D0
since the generic code is doing that for us nowadays.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/aty128fb.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff -puN drivers/video/aty/aty128fb.c~aty128fb-properly-save-pci-state-before-changing-pci-pm-level drivers/video/aty/aty128fb.c
--- a/drivers/video/aty/aty128fb.c~aty128fb-properly-save-pci-state-before-changing-pci-pm-level
+++ a/drivers/video/aty/aty128fb.c
@@ -2374,6 +2374,8 @@ static void aty128_set_suspend(struct at
 	/* Set the chip into the appropriate suspend mode (we use D2,
 	 * D3 would require a complete re-initialisation of the chip,
 	 * including PCI config registers, clocks, AGP configuration, ...)
+	 *
+	 * For resume, the core will have already brought us back to D0
 	 */
 	if (suspend) {
 		/* Make sure CRTC2 is reset. Remove that the day we decide to
@@ -2391,17 +2393,9 @@ static void aty128_set_suspend(struct at
 		aty_st_le32(BUS_CNTL1, 0x00000010);
 		aty_st_le32(MEM_POWER_MISC, 0x0c830000);
 		mdelay(100);
-		pci_read_config_word(pdev, par->pm_reg+PCI_PM_CTRL, &pwr_command);
+
 		/* Switch PCI power management to D2 */
-		pci_write_config_word(pdev, par->pm_reg+PCI_PM_CTRL,
-			(pwr_command & ~PCI_PM_CTRL_STATE_MASK) | 2);
-		pci_read_config_word(pdev, par->pm_reg+PCI_PM_CTRL, &pwr_command);
-	} else {
-		/* Switch back PCI power management to D0 */
-		mdelay(100);
-		pci_write_config_word(pdev, par->pm_reg+PCI_PM_CTRL, 0);
-		pci_read_config_word(pdev, par->pm_reg+PCI_PM_CTRL, &pwr_command);
-		mdelay(100);
+		pci_set_power_state(pdev, PCI_D2);
 	}
 }
 
@@ -2410,6 +2404,12 @@ static int aty128_pci_suspend(struct pci
 	struct fb_info *info = pci_get_drvdata(pdev);
 	struct aty128fb_par *par = info->par;
 
+	/* Because we may change PCI D state ourselves, we need to
+	 * first save the config space content so the core can
+	 * restore it properly on resume.
+	 */
+	pci_save_state(pdev);
+
 	/* We don't do anything but D2, for now we return 0, but
 	 * we may want to change that. How do we know if the BIOS
 	 * can properly take care of D3 ? Also, with swsusp, we
@@ -2476,6 +2476,11 @@ static int aty128_do_resume(struct pci_d
 	if (pdev->dev.power.power_state.event == PM_EVENT_ON)
 		return 0;
 
+	/* PCI state will have been restored by the core, so
+	 * we should be in D0 now with our config space fully
+	 * restored
+	 */
+
 	/* Wakeup chip */
 	aty128_set_suspend(par, 0);
 	par->asleep = 0;
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

