From: akpm@linux-foundation.org
Subject: + spi-pxa2xx_spi-clock-resume-bugfix.patch added to -mm tree
Date: Tue, 29 Apr 2008 16:45:21 -0700
Message-ID: <200804292345.m3TNjLg2016351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbYD2Xp6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 19:45:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebenard@free.fr, dbrownell@users.sourceforge.net


The patch titled
     spi: pxa2xx_spi clock resume bugfix
has been added to the -mm tree.  Its filename is
     spi-pxa2xx_spi-clock-resume-bugfix.patch

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
Subject: spi: pxa2xx_spi clock resume bugfix
From: Eric BENARD <ebenard@free.fr>

There is a typo in pxa2xx_spi.c, comment says "Enable the SSP clock", code
says: clk_disable ...  so after resume, the SSP is dead.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-clock-resume-bugfix drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-clock-resume-bugfix
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1567,7 +1567,7 @@ static int pxa2xx_spi_resume(struct plat
 	int status = 0;
 
 	/* Enable the SSP clock */
-	clk_disable(ssp->clk);
+	clk_enable(ssp->clk);
 
 	/* Start the queue running */
 	status = start_queue(drv_data);
_

Patches currently in -mm which might be from ebenard@free.fr are

spi-pxa2xx_spi-clock-resume-bugfix.patch

