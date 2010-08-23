From: akpm@linux-foundation.org
Subject: + cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch added to -mm tree
Date: Mon, 23 Aug 2010 12:33:19 -0700
Message-ID: <201008231933.o7NJXJ9R010514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509Ab0HWTd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 15:33:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: linux@rainbow-software.org, rmk@arm.linux.org.uk


The patch titled
     cyber2000fb: avoid palette corruption at higher clocks
has been added to the -mm tree.  Its filename is
     cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch

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
Subject: cyber2000fb: avoid palette corruption at higher clocks
From: Ondrej Zary <linux@rainbow-software.org>

When 1280x1024@75Hz mode is set, console palette is not set properly -
sometimes the background is white, sometimes yellow and text colors are
also messed up.  This does not happen at 1280x1024@60Hz and below.

It seems that the HW needs some time before setting the palette - maybe
the PLL needs more time to lock at higher speeds.  This patch fixes the
problem but without knowing what register to check for PLL lock(?), the
delay might be excessive.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/cyber2000fb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/video/cyber2000fb.c~cyber2000fb-avoid-palette-corruption-at-higher-clocks drivers/video/cyber2000fb.c
--- a/drivers/video/cyber2000fb.c~cyber2000fb-avoid-palette-corruption-at-higher-clocks
+++ a/drivers/video/cyber2000fb.c
@@ -502,6 +502,9 @@ static void cyber2000fb_set_timing(struc
 	cyber2000_grphw(0xb9, 0x80, cfb);
 	cyber2000_grphw(0xb9, 0x00, cfb);
 
+	/* wait (for the PLL?) to avoid palette corruption at higher clocks */
+	msleep(1000);
+
 	cfb->ramdac_ctrl = hw->ramdac;
 	cyber2000fb_write_ramdac_ctrl(cfb);
 
_

Patches currently in -mm which might be from linux@rainbow-software.org are

cyber2000fb-avoid-palette-corruption-at-higher-clocks.patch

