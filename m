From: akpm@linux-foundation.org
Subject: + sky2-fix-suspend-hibernation-shutdown-regression-with-wol-enabled-rev-2.patch added to -mm tree
Date: Mon, 11 Aug 2008 16:49:58 -0700
Message-ID: <200808112349.m7BNnwwU028492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115AbYHKXub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Aug 2008 19:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, stephen.hemminger@vyatta.com


The patch titled
     sky2: fix suspend/hibernation/shutdown regression with WOL enabled
has been added to the -mm tree.  Its filename is
     sky2-fix-suspend-hibernation-shutdown-regression-with-wol-enabled-rev-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
skge-adapt-skge-to-use-reworked-pci-pm.patch
sky2-fix-suspend-hibernation-shutdown-regression-with-wol-enabled-rev-2.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
shrink_slab-handle-bad-shrinkers.patch

