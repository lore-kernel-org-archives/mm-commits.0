From: akpm@linux-foundation.org
Subject: + savagefb-fix-ddc-for-savage-4.patch added to -mm tree
Date: Tue, 07 Sep 2010 16:42:35 -0700
Message-ID: <201009072342.o87NgZgl013666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756897Ab0IGXnG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 19:43:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org


The patch titled
     savagefb: fix DDC for Savage 4
has been added to the -mm tree.  Its filename is
     savagefb-fix-ddc-for-savage-4.patch

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
Subject: savagefb: fix DDC for Savage 4
From: Ondrej Zary <linux@rainbow-software.org>

I tested savagefb on 3 different Savage 4 cards:
Diamond Stealth III S520
Number Nine SR9
Datapath Horizon 2S (two savage chips on a PCI card)

it worked except the DDC which did not work on any of them.

Looking at the BIOS code, it does not use MMIO register 0xff20 but CRT
register 0xa0 or 0xb1 - depending on the chip revision and something in
register 0xa6.  With this patch, DDC works fine on all 3 cards (even on
the second head of Horizon 2S - although it does not display anything as
it's misconfigured because of missing BIOS).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/savage/savagefb-i2c.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/video/savage/savagefb-i2c.c~savagefb-fix-ddc-for-savage-4 drivers/video/savage/savagefb-i2c.c
--- a/drivers/video/savage/savagefb-i2c.c~savagefb-fix-ddc-for-savage-4
+++ a/drivers/video/savage/savagefb-i2c.c
@@ -181,6 +181,15 @@ void savagefb_create_i2c_busses(struct f
 		par->chan.algo.getscl = prosavage_gpio_getscl;
 		break;
 	case FB_ACCEL_SAVAGE4:
+		par->chan.reg = CR_SERIAL1;
+		if (par->pcidev->revision > 1 && !(VGArCR(0xa6, par) & 0x40))
+			par->chan.reg = CR_SERIAL2;
+		par->chan.ioaddr      = par->mmio.vbase;
+		par->chan.algo.setsda = prosavage_gpio_setsda;
+		par->chan.algo.setscl = prosavage_gpio_setscl;
+		par->chan.algo.getsda = prosavage_gpio_getsda;
+		par->chan.algo.getscl = prosavage_gpio_getscl;
+		break;
 	case FB_ACCEL_SAVAGE2000:
 		par->chan.reg         = 0xff20;
 		par->chan.ioaddr      = par->mmio.vbase;
_

Patches currently in -mm which might be from linux@rainbow-software.org are

swap-revert-special-hibernation-allocation.patch
swap-prevent-reuse-during-hibernation.patch
savagefb-fix-ddc-for-savage-4.patch
cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch
isofs-work-around-for-rock-ridgejoliet-cds-with-empty-iso-root-directory.patch

