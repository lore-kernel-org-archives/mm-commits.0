From: akpm@linux-foundation.org
Subject: - spi-driver-hotplug-coldplug-fixes-fix.patch removed from -mm tree
Date: Fri, 31 Aug 2007 09:55:58 -0700
Message-ID: <200708311655.l7VGtwBb017445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36263 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760616AbXHaQ4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 12:56:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: correct name for spi_txx9
has been removed from the -mm tree.  Its filename was
     spi-driver-hotplug-coldplug-fixes-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1108,7 +1108,7 @@ static void __init txx9_spi_init(unsigne
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

origin.patch
git-mips.patch
serial_txx9-cleanup-includes.patch
