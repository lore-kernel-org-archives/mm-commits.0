From: akpm@linux-foundation.org
Subject: [merged] avr32-fix-build-error-in-atstk1006_defconfig.patch removed from -mm tree
Date: Mon, 22 Apr 2013 13:06:52 -0700
Message-ID: <20130422200652.840895A4278@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:42439 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab3DVUGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 22 Apr 2013 16:06:53 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so49551vcb.1
        for <mm-commits@vger.kernel.org>; Mon, 22 Apr 2013 13:06:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh.wu@atmel.com, David.Woodhouse@intel.com, artem.bityutskiy@linux.intel.com, egtvedt@samfundet.no, havard@skinnemoen.net, mm-commits@vger.kernel.org


The patch titled
     Subject: avr32: fix build error in atstk1006_defconfig
has been removed from the -mm tree.  Its filename was
     avr32-fix-build-error-in-atstk1006_defconfig.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Wu <josh.wu@atmel.com>
Subject: avr32: fix build error in atstk1006_defconfig

fixed the following compile error when use avr32 atstk1006_defconfig:
  drivers/mtd/nand/atmel_nand.c: In function 'pmecc_err_location':
  drivers/mtd/nand/atmel_nand.c:639: error: implicit declaration of function 'writel_relaxed'

which was introduced by 1c7b874d33 ("mtd: at91: atmel_nand: add
Programmable Multibit ECC controller support").  The PMECC for nand flash
code uses writel_relaxed().  But in avr32, there is no macro
"writel_relaxed" defined.

This patch add writex_relaxed macro definitions.

Signed-off-by: Josh Wu <josh.wu@atmel.com>
Acked-by: Havard Skinnemoen <havard@skinnemoen.net>
Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/include/asm/io.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/avr32/include/asm/io.h~avr32-fix-build-error-in-atstk1006_defconfig arch/avr32/include/asm/io.h
--- a/arch/avr32/include/asm/io.h~avr32-fix-build-error-in-atstk1006_defconfig
+++ a/arch/avr32/include/asm/io.h
@@ -165,6 +165,10 @@ BUILDIO_IOPORT(l, u32)
 #define readw_be			__raw_readw
 #define readl_be			__raw_readl
 
+#define writeb_relaxed			writeb
+#define writew_relaxed			writew
+#define writel_relaxed			writel
+
 #define writeb_be			__raw_writeb
 #define writew_be			__raw_writew
 #define writel_be			__raw_writel
_

Patches currently in -mm which might be from josh.wu@atmel.com are


