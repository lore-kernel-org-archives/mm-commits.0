From: akpm@linux-foundation.org
Subject: + fixed_phy-must-depend-on-phylib=y.patch added to -mm tree
Date: Fri, 29 Feb 2008 15:52:47 -0800
Message-ID: <200802292352.m1TNql8f027087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56825 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755593AbYB2Xxb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 18:53:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.bunk@movial.fi, jeff@garzik.org, olaf@aepfle.de


The patch titled
     FIXED_PHY must depend on PHYLIB=y
has been added to the -mm tree.  Its filename is
     fixed_phy-must-depend-on-phylib=y.patch

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
Subject: FIXED_PHY must depend on PHYLIB=y
From: Adrian Bunk <adrian.bunk@movial.fi>

Fix the following build error introduced by commit
a79d8e93d300adb84cccc38ac396cfb118c238ad and reported by Olaf Hering:

arch/powerpc/sysdev/built-in.o: In function `of_add_fixed_phys':
fsl_soc.c:(.init.text+0xd34): undefined reference to `fixed_phy_add'

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
Tested-by: Olaf Hering <olaf@aepfle.de>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/phy/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/net/phy/Kconfig~fixed_phy-must-depend-on-phylib=y drivers/net/phy/Kconfig
--- a/drivers/net/phy/Kconfig~fixed_phy-must-depend-on-phylib=y
+++ a/drivers/net/phy/Kconfig
@@ -67,6 +67,7 @@ config REALTEK_PHY
 
 config FIXED_PHY
 	bool "Driver for MDIO Bus/PHY emulation with fixed speed/link PHYs"
+	depends on PHYLIB=y
 	---help---
 	  Adds the platform "fixed" MDIO Bus to cover the boards that use
 	  PHYs that are not connected to the real MDIO bus.
_

Patches currently in -mm which might be from adrian.bunk@movial.fi are

fixed_phy-must-depend-on-phylib=y.patch

