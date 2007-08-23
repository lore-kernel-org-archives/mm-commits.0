From: akpm@linux-foundation.org
Subject: + spi-driver-hotplug-coldplug-fixes-fix.patch added to -mm tree
Date: Thu, 23 Aug 2007 16:24:56 -0700
Message-ID: <200708232324.l7NNOuRi032341@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39466 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764539AbXHWXaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 19:30:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dbrownell@users.sourceforge.net


The patch titled
     spi: correct name for spi_txx9
has been added to the -mm tree.  Its filename is
     spi-driver-hotplug-coldplug-fixes-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: correct name for spi_txx9
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Correct the name of the spi_txx9 driver (and their in-tree user)
instead of MODULE_ALIAS workaround.  This would be preferable in the
long term.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/tx4938/toshiba_rbtx4938/setup.c |    2 +-
 drivers/spi/spi_txx9.c                    |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/mips/tx4938/toshiba_rbtx4938/setup.c~spi-driver-hotplug-coldplug-fixes-fix arch/mips/tx4938/toshiba_rbtx4938/setup.c
--- a/arch/mips/tx4938/toshiba_rbtx4938/setup.c~spi-driver-hotplug-coldplug-fixes-fix
+++ a/arch/mips/tx4938/toshiba_rbtx4938/setup.c
@@ -1115,7 +1115,7 @@ static void __init txx9_spi_init(unsigne
 			.flags	= IORESOURCE_IRQ,
 		},
 	};
-	platform_device_register_simple("txx9spi", 0,
+	platform_device_register_simple("spi_txx9", 0,
 					res, ARRAY_SIZE(res));
 }
 
diff -puN drivers/spi/spi_txx9.c~spi-driver-hotplug-coldplug-fixes-fix drivers/spi/spi_txx9.c
--- a/drivers/spi/spi_txx9.c~spi-driver-hotplug-coldplug-fixes-fix
+++ a/drivers/spi/spi_txx9.c
@@ -450,11 +450,10 @@ static int __exit txx9spi_remove(struct 
 	return 0;
 }
 
-MODULE_ALIAS("txx9spi");			/* for platform bus hotplug */
 static struct platform_driver txx9spi_driver = {
 	.remove = __exit_p(txx9spi_remove),
 	.driver = {
-		.name = "txx9spi",
+		.name = "spi_txx9",
 		.owner = THIS_MODULE,
 	},
 };
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

serial_txx9-fix-modem-control-line-handling.patch
correct-name-for-rtc-m41t80.patch
rtc-max6902-minor-fixes.patch
spi-driver-hotplug-coldplug-fixes-fix.patch
serial_txx9-cleanup-includes.patch
