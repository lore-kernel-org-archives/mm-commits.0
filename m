From: akpm@linux-foundation.org
Subject: [folded-merged] misc-generic-on-chip-sram-allocation-driver-fix.patch removed from -mm tree
Date: Mon, 29 Apr 2013 15:58:52 -0700
Message-ID: <20130429225852.B7D8831C07C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:49431 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab3D2W6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Apr 2013 18:58:53 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so475514ggc.0
        for <mm-commits@vger.kernel.org>; Mon, 29 Apr 2013 15:58:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, p.zabel@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: misc-generic-on-chip-sram-allocation-driver-fix
has been removed from the -mm tree.  Its filename was
     misc-generic-on-chip-sram-allocation-driver-fix.patch

This patch was dropped because it was folded into misc-generic-on-chip-sram-allocation-driver.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: misc-generic-on-chip-sram-allocation-driver-fix

fix Kconfig text, make sram_init static

Cc: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    6 +++---
 drivers/misc/sram.c  |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/misc/Kconfig~misc-generic-on-chip-sram-allocation-driver-fix drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~misc-generic-on-chip-sram-allocation-driver-fix
+++ a/drivers/misc/Kconfig
@@ -523,9 +523,9 @@ config SRAM
 	depends on HAS_IOMEM
 	select GENERIC_ALLOCATOR
 	help
-	  This driver allows to declare a memory region to be managed
-	  by the genalloc API. It is supposed to be used for small
-	  on-chip SRAM areas found on many SoCs.
+	  This driver allows you to declare a memory region to be managed by
+	  the genalloc API. It is supposed to be used for small on-chip SRAM
+	  areas found on many SoCs.
 
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
diff -puN drivers/misc/sram.c~misc-generic-on-chip-sram-allocation-driver-fix drivers/misc/sram.c
--- a/drivers/misc/sram.c~misc-generic-on-chip-sram-allocation-driver-fix
+++ a/drivers/misc/sram.c
@@ -113,7 +113,7 @@ static struct platform_driver sram_drive
 	.remove = sram_remove,
 };
 
-int __init sram_init(void)
+static int __init sram_init(void)
 {
 	return platform_driver_register(&sram_driver);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are


