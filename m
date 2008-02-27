From: akpm@linux-foundation.org
Subject: - macb-fix-speed-setting.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:16:38 -0800
Message-ID: <200802272216.m1RMGcA0000729@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47336 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759279AbYB0WR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:17:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, hskinnemoen@atmel.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     macb: fix speed setting
has been removed from the -mm tree.  Its filename was
     macb-fix-speed-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: macb: fix speed setting
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Fix NCFGR.SPD setting on 10Mbps.  This bug was introduced by conversion to
generic PHY layer in kernel 2.6.23.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/macb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/macb.c~macb-fix-speed-setting drivers/net/macb.c
--- a/drivers/net/macb.c~macb-fix-speed-setting
+++ a/drivers/net/macb.c
@@ -148,7 +148,7 @@ static void macb_handle_link_change(stru
 
 			if (phydev->duplex)
 				reg |= MACB_BIT(FD);
-			if (phydev->speed)
+			if (phydev->speed == SPEED_100)
 				reg |= MACB_BIT(SPD);
 
 			macb_writel(bp, NCFGR, reg);
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

git-net.patch
