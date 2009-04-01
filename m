From: akpm@linux-foundation.org
Subject: [merged] bcm47xx-fix-gpio-api-return-codes.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:50 -0700
Message-ID: <200904011839.n31IdoZc008824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759730AbZDASoJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:44:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mb@bu3sch.de, david-b@pacbell.net, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     bcm47xx: fix GPIO API return codes
has been removed from the -mm tree.  Its filename was
     bcm47xx-fix-gpio-api-return-codes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
spi-gpio-allow-operation-without-cs-signal.patch

