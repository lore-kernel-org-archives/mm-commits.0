From: akpm@linux-foundation.org
Subject: + avr32-fix-build-error-in-atstk1006_defconfig.patch added to -mm tree
Date: Mon, 15 Apr 2013 13:40:54 -0700
Message-ID: <20130415204054.7E3BF31C0F7@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:34394 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3DOUkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 16:40:55 -0400
Received: by mail-gg0-f202.google.com with SMTP id q1so508080ggn.3
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 13:40:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh.wu@atmel.com, David.Woodhouse@intel.com, artem.bityutskiy@linux.intel.com, egtvedt@samfundet.no, havard@skinnemoen.net


The patch titled
     Subject: avr32: fix build error in atstk1006_defconfig
has been added to the -mm tree.  Its filename is
     avr32-fix-build-error-in-atstk1006_defconfig.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

avr32-fix-build-error-in-atstk1006_defconfig.patch

