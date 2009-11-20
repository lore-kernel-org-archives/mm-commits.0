From: akpm@linux-foundation.org
Subject: [merged] m68k-dont-export-static-inline-functions.patch removed from -mm tree
Date: Fri, 20 Nov 2009 11:31:00 -0800
Message-ID: <200911201931.nAKJV0w3012037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbZKTTbv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 14:31:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, geert@linux-m68k.org, jochen@scram.de, rusty@rustcorp.com.au, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: don't export static inline functions
has been removed from the -mm tree.  Its filename was
     m68k-dont-export-static-inline-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68k: don't export static inline functions
From: Stephen Rothwell <sfr@canb.auug.org.au>

These now cause errors due to changes present in linux-next:

(__ksymtab_sorted+0x1258): undefined reference to `dio_dev_driver'
(__ksymtab_sorted+0x4d48): undefined reference to `zorro_dev_driver'

Neither of these functions is used anywhere in the kernel anyway.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Jochen Friedrich <jochen@scram.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dio/dio-driver.c     |    1 -
 drivers/zorro/zorro-driver.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN drivers/dio/dio-driver.c~m68k-dont-export-static-inline-functions drivers/dio/dio-driver.c
--- a/drivers/dio/dio-driver.c~m68k-dont-export-static-inline-functions
+++ a/drivers/dio/dio-driver.c
@@ -140,5 +140,4 @@ postcore_initcall(dio_driver_init);
 EXPORT_SYMBOL(dio_match_device);
 EXPORT_SYMBOL(dio_register_driver);
 EXPORT_SYMBOL(dio_unregister_driver);
-EXPORT_SYMBOL(dio_dev_driver);
 EXPORT_SYMBOL(dio_bus_type);
diff -puN drivers/zorro/zorro-driver.c~m68k-dont-export-static-inline-functions drivers/zorro/zorro-driver.c
--- a/drivers/zorro/zorro-driver.c~m68k-dont-export-static-inline-functions
+++ a/drivers/zorro/zorro-driver.c
@@ -156,5 +156,4 @@ postcore_initcall(zorro_driver_init);
 EXPORT_SYMBOL(zorro_match_device);
 EXPORT_SYMBOL(zorro_register_driver);
 EXPORT_SYMBOL(zorro_unregister_driver);
-EXPORT_SYMBOL(zorro_dev_driver);
 EXPORT_SYMBOL(zorro_bus_type);
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch

