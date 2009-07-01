From: akpm@linux-foundation.org
Subject: [merged] gpio-pl061-fix-probe-error-handling-code.patch removed from -mm tree
Date: Wed, 01 Jul 2009 10:27:28 -0700
Message-ID: <200907011727.n61HRSRw002291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbZGAR1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:27:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baruch@tkos.co.il, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpio: pl061: fix probe error handling code
has been removed from the -mm tree.  Its filename was
     gpio-pl061-fix-probe-error-handling-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: pl061: fix probe error handling code
From: Baruch Siach <baruch@tkos.co.il>

Note that IRQ has not been initialized when kmalloc() fails.

Also, use DECLARE_BITMAP() to make the code clearer.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pl061.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/gpio/pl061.c~gpio-pl061-fix-probe-error-handling-code drivers/gpio/pl061.c
--- a/drivers/gpio/pl061.c~gpio-pl061-fix-probe-error-handling-code
+++ a/drivers/gpio/pl061.c
@@ -221,7 +221,7 @@ static int __init pl061_probe(struct amb
 	struct pl061_gpio *chip;
 	struct list_head *chip_list;
 	int ret, irq, i;
-	static unsigned long init_irq[BITS_TO_LONGS(NR_IRQS)];
+	static DECLARE_BITMAP(init_irq, NR_IRQS);
 
 	pdata = dev->dev.platform_data;
 	if (pdata == NULL)
@@ -280,6 +280,7 @@ static int __init pl061_probe(struct amb
 	if (!test_and_set_bit(irq, init_irq)) { /* list initialized? */
 		chip_list = kmalloc(sizeof(*chip_list), GFP_KERNEL);
 		if (chip_list == NULL) {
+			clear_bit(irq, init_irq);
 			ret = -ENOMEM;
 			goto iounmap;
 		}
_

Patches currently in -mm which might be from baruch@tkos.co.il are

origin.patch

