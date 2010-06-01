From: akpm@linux-foundation.org
Subject: + fbdev-fix-frame-buffer-devices-menu.patch added to -mm tree
Date: Tue, 01 Jun 2010 14:30:13 -0700
Message-ID: <201006012130.o51LUD8G019916@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754551Ab0FAVb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 17:31:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, baruch@tkos.co.il, davem@davemloft.net, s.hauer@pengutronix.de, u.kleine-koenig@pengutronix.de


The patch titled
     fbdev: fix frame buffer devices menu
has been added to the -mm tree.  Its filename is
     fbdev-fix-frame-buffer-devices-menu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: fbdev: fix frame buffer devices menu
=46rom: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Commit f601441916d1e19291d0b4f044b4a7551e2924d0 ("imxfb: add support fo=
r
i.MX25:) has inserted the symbol HAVE_FB_IMX, which does not depend on =
=46B
after the menuconfig FB.  This breaks the menu, presenting most of the
drivers outside of it, when using menuconfig.

Moving the symbol to the start of the file, just like HAVE_FB_ATMEL, fi=
xes
the problem without breaking it for iMX25 configurations (tested with
ARCH=3Darm, no build).

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Baruch Siach <baruch@tkos.co.il>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/Kconfig~fbdev-fix-frame-buffer-devices-menu dri=
vers/video/Kconfig
--- a/drivers/video/Kconfig~fbdev-fix-frame-buffer-devices-menu
+++ a/drivers/video/Kconfig
@@ -8,6 +8,9 @@ menu "Graphics support"
 config HAVE_FB_ATMEL
 	bool
=20
+config HAVE_FB_IMX
+	bool
+
 source "drivers/char/agp/Kconfig"
=20
 source "drivers/gpu/vga/Kconfig"
@@ -400,9 +403,6 @@ config FB_SA1100
 	  If you plan to use the LCD display with your SA-1100 system, say
 	  Y here.
=20
-config HAVE_FB_IMX
-	bool
