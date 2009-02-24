From: akpm@linux-foundation.org
Subject: [merged] drivers-net-tg3c-fix-confusion.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:32:48 -0800
Message-ID: <200902241932.n1OJWmdE004453@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752AbZBXTdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:33:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mcarlson@broadcom.com, mchan@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/tg3.c: fix &&/|| confusion
has been removed from the -mm tree.  Its filename was
     drivers-net-tg3c-fix-confusion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/tg3.c: fix &&/|| confusion
From: Roel Kluin <roel.kluin@gmail.com>

phyid can't be both TG3_PHY_OUI_1 and TG3_PHY_OUI_2 and TG3_PHY_OUI_3.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Matt Carlson <mcarlson@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tg3.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/tg3.c~drivers-net-tg3c-fix-confusion drivers/net/tg3.c
--- a/drivers/net/tg3.c~drivers-net-tg3c-fix-confusion
+++ a/drivers/net/tg3.c
@@ -2237,8 +2237,8 @@ static int tg3_set_power_state(struct tg
 			phyid = phydev->drv->phy_id & phydev->drv->phy_id_mask;
 			if (phyid != TG3_PHY_ID_BCMAC131) {
 				phyid &= TG3_PHY_OUI_MASK;
-				if (phyid == TG3_PHY_OUI_1 &&
-				    phyid == TG3_PHY_OUI_2 &&
+				if (phyid == TG3_PHY_OUI_1 ||
+				    phyid == TG3_PHY_OUI_2 ||
 				    phyid == TG3_PHY_OUI_3)
 					do_low_power = true;
 			}
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
scsi-ncr53c8xx-div-reaches-1.patch
drivers-scsi-pcmcia-nsp_csc-time_out-reaches-1.patch
mm-get_nid_for_pfn-returns-int.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch

