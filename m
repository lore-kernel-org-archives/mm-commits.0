From: akpm@linux-foundation.org
Subject: + mfd-fix-twl4030-build-on-some-arm-variants.patch added to -mm tree
Date: Mon, 02 Feb 2009 15:48:52 -0800
Message-ID: <200902022348.n12NmqNf028130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308AbZBBXuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 18:50:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@sirena.org.uk, dbrownell@users.sourceforge.net, sameo@openedhand.com


The patch titled
     mfd: fix TWL4030 build on some ARM variants
has been added to the -mm tree.  Its filename is
     mfd-fix-twl4030-build-on-some-arm-variants.patch

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
Subject: mfd: fix TWL4030 build on some ARM variants
From: Mark Brown <broonie@sirena.org.uk>

Many ARM platforms do not provide a mach/cpu.h so rather than guarding the
use of that header with CONFIG_ARM guard it with the guards used when
testing for the OMAP variants in the body of the code.

Signed-off-by: Mark Brown <broonie@sirena.org.uk>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/twl4030-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/twl4030-core.c~mfd-fix-twl4030-build-on-some-arm-variants drivers/mfd/twl4030-core.c
--- a/drivers/mfd/twl4030-core.c~mfd-fix-twl4030-build-on-some-arm-variants
+++ a/drivers/mfd/twl4030-core.c
@@ -38,7 +38,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c/twl4030.h>
 
-#ifdef CONFIG_ARM
+#if defined(CONFIG_ARCH_OMAP2) || defined(CONFIG_ARCH_OMAP3)
 #include <mach/cpu.h>
 #endif
 
_

Patches currently in -mm which might be from broonie@sirena.org.uk are

mfd-fix-twl4030-build-on-some-arm-variants.patch

