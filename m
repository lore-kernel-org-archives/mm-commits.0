From: akpm@linux-foundation.org
Subject: - mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:48 -0700
Message-ID: <200807252255.m6PMtmPi003007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753287AbYGYW4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:56:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, mm-commits@vger.kernel.org


The patch titled
     mfd: sm501 fix gpio number calculation for upper bank
has been removed from the -mm tree.  Its filename was
     mfd-sm501-fix-gpio-number-calculation-for-upper-bank.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: sm501 fix gpio number calculation for upper bank
From: Ben Dooks <ben-linux@fluff.org>

The sm501_gpio_pin2nr() routine returns the wrong values for gpios in the
upper bank.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/mfd/sm501.c~mfd-sm501-fix-gpio-number-calculation-for-upper-bank drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~mfd-sm501-fix-gpio-number-calculation-for-upper-bank
+++ a/drivers/mfd/sm501.c
@@ -1108,7 +1108,9 @@ static void sm501_gpio_remove(struct sm5
 static inline int sm501_gpio_pin2nr(struct sm501_devdata *sm, unsigned int pin)
 {
 	struct sm501_gpio *gpio = &sm->gpio;
-	return pin + (pin < 32) ? gpio->low.gpio.base : gpio->high.gpio.base;
+	int base = (pin < 32) ? gpio->low.gpio.base : gpio->high.gpio.base;
+
+	return (pin % 32) + base;
 }
 
 static inline int sm501_gpio_isregistered(struct sm501_devdata *sm)
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
resource-add-resource_size.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

