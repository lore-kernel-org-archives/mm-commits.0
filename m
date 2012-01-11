From: akpm@linux-foundation.org
Subject: [merged] leds-convert-leds-dac124s085-to-module_spi_driver.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:30:21 -0800
Message-ID: <20120111213022.1BE565C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:62274 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab2AKVaY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:30:24 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so32568eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:30:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com, g.liakhovetski@gmx.de, hennerich@blackfin.uclinux.org, hzhuang1@marvell.com, mike@compulab.co.il, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds: convert leds-dac124s085 to module_spi_driver
has been removed from the -mm tree.  Its filename was
     leds-convert-leds-dac124s085-to-module_spi_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
