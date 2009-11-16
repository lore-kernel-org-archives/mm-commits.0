From: akpm@linux-foundation.org
Subject: + m68k-dont-export-static-inline-functions.patch added to -mm tree
Date: Mon, 16 Nov 2009 14:57:09 -0800
Message-ID: <200911162257.nAGMv9xD017165@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868AbZKPW5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Nov 2009 17:57:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, geert@linux-m68k.org, jochen@scram.de, rusty@rustcorp.com.au, zippel@linux-m68k.org


The patch titled
     m68k: don't export static inline functions
has been added to the -mm tree.  Its filename is
     m68k-dont-export-static-inline-functions.patch

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

fcntl-use-consistent-values-for-f_etown_ex.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
m68k-dont-export-static-inline-functions.patch

