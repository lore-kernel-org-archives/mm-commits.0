From: akpm@linux-foundation.org
Subject: [folded] gpio-driver-for-primecell-pl061-gpio-controller-v5.patch removed from -mm tree
Date: Wed, 17 Jun 2009 15:45:40 -0700
Message-ID: <200906172245.n5HMjegO005932@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39561 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760385AbZFQWrC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 18:47:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: baruch@tkos.co.il, david-b@pacbell.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     gpio-driver-for-primecell-pl061-gpio-controller-v5
has been removed from the -mm tree.  Its filename was
     gpio-driver-for-primecell-pl061-gpio-controller-v5.patch

This patch was dropped because it was folded into gpio-driver-for-primecell-pl061-gpio-controller.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio-driver-for-primecell-pl061-gpio-controller-v5
From: Baruch Siach <baruch@tkos.co.il>

Changes in v5:
	- Use resource_size() as suggested by Linus Walleij
	- Add a comment about the list member of pl061_gpio

Cc: David Brownell <david-b@pacbell.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/pl061.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN drivers/gpio/pl061.c~gpio-driver-for-primecell-pl061-gpio-controller-v5 drivers/gpio/pl061.c
--- a/drivers/gpio/pl061.c~gpio-driver-for-primecell-pl061-gpio-controller-v5
+++ a/drivers/gpio/pl061.c
@@ -36,9 +36,12 @@
 
 #define PL061_GPIO_NR	8
 
-#define PL061_REG_SIZE	(4*1024)
-
 struct pl061_gpio {
+	/* We use a list of pl061_gpio structs for each trigger IRQ in the main
+	 * interrupts controller of the system. We need this to support systems
+	 * in which more that one PL061s are connected to the same IRQ. The ISR
+	 * interates through this list to find the source of the interrupt.
+	 */
 	struct list_head	list;
 
 	/* Each of the two spinlocks protects a different set of hardware
@@ -238,12 +241,13 @@ static int __init pl061_probe(struct amb
 	if (chip == NULL)
 		return -ENOMEM;
 
-	if (!request_mem_region(dev->res.start, PL061_REG_SIZE, "pl061")) {
+	if (!request_mem_region(dev->res.start,
+				resource_size(&dev->res), "pl061")) {
 		ret = -EBUSY;
 		goto free_mem;
 	}
 
-	chip->base = ioremap(dev->res.start, PL061_REG_SIZE);
+	chip->base = ioremap(dev->res.start, resource_size(&dev->res));
 	if (chip->base == NULL) {
 		ret = -ENOMEM;
 		goto release_region;
@@ -308,7 +312,7 @@ static int __init pl061_probe(struct amb
 iounmap:
 	iounmap(chip->base);
 release_region:
-	release_mem_region(dev->res.start, PL061_REG_SIZE);
+	release_mem_region(dev->res.start, resource_size(&dev->res));
 free_mem:
 	kfree(chip);
 
_

Patches currently in -mm which might be from baruch@tkos.co.il are

origin.patch
gpio-driver-for-primecell-pl061-gpio-controller.patch
gpio-driver-for-primecell-pl061-gpio-controller-v5.patch

