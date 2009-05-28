From: akpm@linux-foundation.org
Subject: + gpio-max7301-add-missing-__devexit-marking.patch added to -mm tree
Date: Wed, 27 May 2009 23:20:58 -0700
Message-ID: <200905280620.n4S6KwfJ031320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbZE1GVM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 02:21:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, david-b@pacbell.net, dbaryshkov@gmail.com, j.beisert@pengutronix.de


The patch titled
     gpio: max7301: add missing __devexit marking
has been added to the -mm tree.  Its filename is
     gpio-max7301-add-missing-__devexit-marking.patch

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
Subject: gpio: max7301: add missing __devexit marking
From: Mike Frysinger <vapier@gentoo.org>

The remove member of the spi_driver max7301_driver uses __devexit_p(), so
the remove function itself should be marked with __devexit.  Even more so
considering the probe function is marked with __devinit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Juergen Beisert <j.beisert@pengutronix.de>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max7301.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpio/max7301.c~gpio-max7301-add-missing-__devexit-marking drivers/gpio/max7301.c
--- a/drivers/gpio/max7301.c~gpio-max7301-add-missing-__devexit-marking
+++ a/drivers/gpio/max7301.c
@@ -287,7 +287,7 @@ exit_destroy:
 	return ret;
 }
 
-static int max7301_remove(struct spi_device *spi)
+static int __devexit max7301_remove(struct spi_device *spi)
 {
 	struct max7301 *ts;
 	int ret;
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch
pcmcia-yenta-add-missing-__devexit-marking.patch
plat_nand-add-missing-__devexit_p.patch
irda-new-blackfin-on-chip-sir-irda-driver.patch
drivers-char-rtc-disable-legacy-rtc-driver-on-blackfin-systems.patch
gpio-max7301-add-missing-__devexit-marking.patch

