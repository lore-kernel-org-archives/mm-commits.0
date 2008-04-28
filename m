From: akpm@linux-foundation.org
Subject: - lxfb-add-power-management-functionality-update.patch removed from -mm tree
Date: Mon, 28 Apr 2008 00:02:03 -0700
Message-ID: <200804280702.m3S724Sj013107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932157AbYD1HCh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 03:02:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, adaplas@pol.net, dilinger@debian.org, jordan.crouse@amd.com, mm-commits@vger.kernel.org


The patch titled
      lxfb-add-power-management-functionality update
has been removed from the -mm tree.  Its filename was
     lxfb-add-power-management-functionality-update.patch

This patch was dropped because it was folded into lxfb-add-power-management-functionality.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject:  lxfb-add-power-management-functionality update
From: Andres Salomon <dilinger@queued.net>

This drops the power_state stuff from the patch.  Can you please replace the
original patch with this one?  Thanks!

This adds the ability to suspend/resume the lxfb driver, which includes:
  - Register and palette saving code; registers are stored in lxfb_par.
    A few MSR values are saved as well.
  - lx_powerup and lx_powerdown functions which restore/save registers and
    enable/disable graphic engines.
  - lxfb_suspend/lxfb_resume

Originally based on a patch by Jordan Crouse.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/geode/lxfb_core.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/video/geode/lxfb_core.c~lxfb-add-power-management-functionality-update drivers/video/geode/lxfb_core.c
--- a/drivers/video/geode/lxfb_core.c~lxfb-add-power-management-functionality-update
+++ a/drivers/video/geode/lxfb_core.c
@@ -433,9 +433,6 @@ static int lxfb_suspend(struct pci_dev *
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
 
-	if (pdev->dev.power.power_state.event == state.event)
-		return 0;
-
 	if (state.event == PM_EVENT_SUSPEND) {
 		acquire_console_sem();
 		lx_powerdown(info);
@@ -446,7 +443,6 @@ static int lxfb_suspend(struct pci_dev *
 	/* there's no point in setting PCI states; we emulate PCI, so
 	 * we don't end up getting power savings anyways */
 
-	pdev->dev.power.power_state = state;
 	return 0;
 }
 
@@ -464,8 +460,6 @@ static int lxfb_resume(struct pci_dev *p
 
 	fb_set_suspend(info, 0);
 	release_console_sem();
-
-	pdev->dev.power.power_state = PMSG_ON;
 	return 0;
 }
 #else
_

Patches currently in -mm which might be from dilinger@queued.net are

x86-geode-msr-cleanup.patch
x86-geode-add-virtual-systems-architecture-detection.patch
gxfb-use-pci_device-for-gxfbs-pci-device-table.patch
gxfb-replace-fbsize-config-option-with-a-module-parameter.patch
gxfb-create-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
gxfb-clean-up-register-definitions.patch
gxfb-move-msr-bit-fields-into-gxfbh.patch
gxfb-stop-sharing-code-with-gx1fb.patch
gxfb-add-power-management-functionality.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch.patch
lxfb-create-gp-dc-vp-fp-specific-handlers-rather-than-using-readl-writel.patch
lxfb-clean-up-register-definitions.patch
lxfb-clean-up-final-bits-of-df_regs.patch
lxfb-rearrange-rename-msr-bitfields.patch
lxfb-add-power-management-functionality.patch
lxfb-add-power-management-functionality-update.patch
lxfb-rename-kernel-arg-fbsize-to-vram.patch
lxfb-disable-suspend-vt-switch-by-default.patch
lxfb-gxfb-when-blanking-with-fb_blank_powerdown-also-turn-off-the-crt.patch
gxfb-lxfb-use-vsa-definitions-when-fetching-framebuffer-size.patch
gxfb-lxfb-detect-framebuffer-size-using-an-msr-if-vsa2-isnt-available.patch
olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers.patch
olpc-gxfb-lxfb-add-dcon-panel-modes-to-framebuffer-drivers-section-fix.patch

