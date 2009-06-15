From: akpm@linux-foundation.org
Subject: + gpio-driver-for-primecell-pl061-gpio-controller-v5.patch added to -mm tree
Date: Mon, 15 Jun 2009 14:37:06 -0700
Message-ID: <200906152137.n5FLb66s031699@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759923AbZFOViB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 17:38:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: baruch@tkos.co.il, david-b@pacbell.net, rmk@arm.linux.org.uk


The patch titled
     gpio-driver-for-primecell-pl061-gpio-controller-v5
has been added to the -mm tree.  Its filename is
     gpio-driver-for-primecell-pl061-gpio-controller-v5.patch

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
gpio-driver-for-primecell-pl061-gpio-controller-v4.patch
gpio-driver-for-primecell-pl061-gpio-controller-v5.patch

