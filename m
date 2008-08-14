From: akpm@linux-foundation.org
Subject: - sky2-fix-suspend-hibernation-shutdown-regression-with-wol-enabled-rev-2.patch removed from -mm tree
Date: Thu, 14 Aug 2008 16:54:20 -0700
Message-ID: <200808142354.m7ENsKfR003929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752119AbYHNXyc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 19:54:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, shemminger@vyatta.com, mm-commits@vger.kernel.org


The patch titled
     sky2: fix suspend/hibernation/shutdown regression with WOL enabled
has been removed from the -mm tree.  Its filename was
     sky2-fix-suspend-hibernation-shutdown-regression-with-wol-enabled-rev-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sky2: fix suspend/hibernation/shutdown regression with WOL enabled
From: "Rafael J. Wysocki" <rjw@sisk.pl>

On my test box with the Asus M3A32-MVP main board there is a regression
from 2.6.26 related to suspend, hibernation and shutdown.  Namely, if
Wake-on-LAN is enabled with 'ethtool -s eth0 wol g', the box hangs solid
during all of these operations, while executing either sky2_suspend(), or
sky2_shutdown().  This patch fixes it for me.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Stephen Hemminger <stephen.hemminger@vyatta.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sky2.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/net/sky2.c~sky2-fix-suspend-hibernation-shutdown-regression-with-wol-enabled-rev-2 drivers/net/sky2.c
--- a/drivers/net/sky2.c~sky2-fix-suspend-hibernation-shutdown-regression-with-wol-enabled-rev-2
+++ a/drivers/net/sky2.c
@@ -666,11 +666,16 @@ static void sky2_phy_power_down(struct s
 
 	if (hw->chip_id != CHIP_ID_YUKON_EC) {
 		if (hw->chip_id == CHIP_ID_YUKON_EC_U) {
-			ctrl = gm_phy_read(hw, port, PHY_MARV_PHY_CTRL);
+			/* select page 2 to access MAC control register */
+			gm_phy_write(hw, port, PHY_MARV_EXT_ADR, 2);
 
+			ctrl = gm_phy_read(hw, port, PHY_MARV_PHY_CTRL);
 			/* enable Power Down */
 			ctrl |= PHY_M_PC_POW_D_ENA;
 			gm_phy_write(hw, port, PHY_MARV_PHY_CTRL, ctrl);
+
+			/* set page register back to 0 */
+			gm_phy_write(hw, port, PHY_MARV_EXT_ADR, 0);
 		}
 
 		/* set IEEE compatible Power Down Mode (dev. #4.99) */
_

Patches currently in -mm which might be from rjw@sisk.pl are

suspend-fix-section-mismatch-warning-register_nosave_region.patch
kexec-jump-clean-up-ifdef-and-comments.patch
kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch
kexec-jump-check-code-size-in-control-page.patch
kexec-jump-check-code-size-in-control-page-fix.patch
kexec-jump-remove-duplication-of-kexec_restart_prepare.patch
kexec-jump-in-sync-with-hibernation-implementation.patch
kexec-jump-__ftrace_enabled_save-restore.patch
kexec-jump-fix-for-ftrace.patch
linux-next.patch
git-net.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-make-refrigerator-always-available.patch
container-freezer-skip-frozen-cgroups-during-power-management-resume.patch
shrink_slab-handle-bad-shrinkers.patch

