From: akpm@linux-foundation.org
Subject: + macb-fix-speed-setting.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:30:06 -0800
Message-ID: <200802230730.m1N7Utg6017969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33430 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbYBWHyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:54:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, hskinnemoen@atmel.com, stable@kernel.org


The patch titled
     macb: fix speed setting
has been added to the -mm tree.  Its filename is
     macb-fix-speed-setting.patch

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

atmel_spi-fix-clock-polarity.patch
macb-fix-speed-setting.patch
git-watchdog.patch
