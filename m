From: akpm@linux-foundation.org
Subject: + leds-convert-leds-dac124s085-to-module_spi_driver.patch added to -mm tree
Date: Mon, 28 Nov 2011 15:27:40 -0800
Message-ID: <201111282327.pASNRff5005820@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:64479 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab1K1X1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 18:27:45 -0500
Received: by eeuu44 with SMTP id u44so50018eeu.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 15:27:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com, g.liakhovetski@gmx.de, hennerich@blackfin.uclinux.org, hzhuang1@marvell.com, mike@compulab.co.il, rpurdie@rpsys.net


The patch titled
     Subject: leds: convert leds-dac124s085 to module_spi_driver
has been added to the -mm tree.  Its filename is
     leds-convert-leds-dac124s085-to-module_spi_driver.patch

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
From: Axel Lin <axel.lin@gmail.com>
Subject: leds: convert leds-dac124s085 to module_spi_driver

Factor out some boilerplate code for spi driver registration into
module_spi_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Haojian Zhuang <hzhuang1@marvell.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
Cc: Mike Rapoport <mike@compulab.co.il>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-dac124s085.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/leds/leds-dac124s085.c~leds-convert-leds-dac124s085-to-module_spi_driver drivers/leds/leds-dac124s085.c
--- a/drivers/leds/leds-dac124s085.c~leds-convert-leds-dac124s085-to-module_spi_driver
+++ a/drivers/leds/leds-dac124s085.c
@@ -131,18 +131,7 @@ static struct spi_driver dac124s085_driv
 	},
 };
 
-static int __init dac124s085_leds_init(void)
-{
-	return spi_register_driver(&dac124s085_driver);
-}
-
-static void __exit dac124s085_leds_exit(void)
-{
-	spi_unregister_driver(&dac124s085_driver);
-}
