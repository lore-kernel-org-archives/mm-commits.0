From: akpm@linux-foundation.org
Subject: + bcm47xx-fix-gpio-api-return-codes.patch added to -mm tree
Date: Tue, 17 Feb 2009 16:29:47 -0800
Message-ID: <200902180029.n1I0Tlo1018326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50232 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbZBRAa6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 19:30:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mb@bu3sch.de, david-b@pacbell.net, ralf@linux-mips.org


The patch titled
     bcm47xx: fix GPIO API return codes
has been added to the -mm tree.  Its filename is
     bcm47xx-fix-gpio-api-return-codes.patch

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
Subject: bcm47xx: fix GPIO API return codes
From: Michael Buesch <mb@bu3sch.de>

The GPIO API is supposed to return 0 or a negative error code,
but the SSB GPIO functions return the bitmask of the GPIO register.
Fix this by ignoring the bitmask and always returning 0. The SSB GPIO functions can't fail.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/mach-bcm47xx/gpio.h |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN arch/mips/include/asm/mach-bcm47xx/gpio.h~bcm47xx-fix-gpio-api-return-codes arch/mips/include/asm/mach-bcm47xx/gpio.h
--- a/arch/mips/include/asm/mach-bcm47xx/gpio.h~bcm47xx-fix-gpio-api-return-codes
+++ a/arch/mips/include/asm/mach-bcm47xx/gpio.h
@@ -31,24 +31,28 @@ static inline void gpio_set_value(unsign
 
 static inline int gpio_direction_input(unsigned gpio)
 {
-	return ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 0);
+	ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 0);
+	return 0;
 }
 
 static inline int gpio_direction_output(unsigned gpio, int value)
 {
-	return ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 1 << gpio);
+	ssb_gpio_outen(&ssb_bcm47xx, 1 << gpio, 1 << gpio);
+	return 0;
 }
 
-static int gpio_intmask(unsigned gpio, int value)
+static inline int gpio_intmask(unsigned gpio, int value)
 {
-	return ssb_gpio_intmask(&ssb_bcm47xx, 1 << gpio,
-				value ? 1 << gpio : 0);
+	ssb_gpio_intmask(&ssb_bcm47xx, 1 << gpio,
+			 value ? 1 << gpio : 0);
+	return 0;
 }
 
-static int gpio_polarity(unsigned gpio, int value)
+static inline int gpio_polarity(unsigned gpio, int value)
 {
-	return ssb_gpio_polarity(&ssb_bcm47xx, 1 << gpio,
-				 value ? 1 << gpio : 0);
+	ssb_gpio_polarity(&ssb_bcm47xx, 1 << gpio,
+			  value ? 1 << gpio : 0);
+	return 0;
 }
 
 
_

Patches currently in -mm which might be from mb@bu3sch.de are

linux-next.patch
bcm47xx-fix-gpio-api-return-codes.patch

