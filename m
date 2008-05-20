From: akpm@linux-foundation.org
Subject: + gpiolib-fix-off-by-one-errors.patch added to -mm tree
Date: Tue, 20 May 2008 12:32:59 -0700
Message-ID: <200805201932.m4KJWxSl007598@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756044AbYETTe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 15:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xyzzy@speakeasy.org, dbrownell@users.sourceforge.net


The patch titled
     gpiolib: fix off by one errors
has been added to the -mm tree.  Its filename is
     gpiolib-fix-off-by-one-errors.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib: fix off by one errors
From: Trent Piepho <xyzzy@speakeasy.org>

The last gpio belonging to a chip is chip->base + chip->ngpios - 1.  Some
places in the code, but not all, forgot the critical minus one.

Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/gpio/gpiolib.c~gpiolib-fix-off-by-one-errors drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-fix-off-by-one-errors
+++ a/drivers/gpio/gpiolib.c
@@ -127,7 +127,7 @@ int __init gpiochip_reserve(int start, i
 	unsigned long flags;
 	int i;
 
-	if (!gpio_is_valid(start) || !gpio_is_valid(start + ngpio))
+	if (!gpio_is_valid(start) || !gpio_is_valid(start + ngpio - 1))
 		return -EINVAL;
 
 	spin_lock_irqsave(&gpio_lock, flags);
@@ -170,7 +170,7 @@ int gpiochip_add(struct gpio_chip *chip)
 	unsigned	id;
 	int		base = chip->base;
 
-	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio))
+	if ((!gpio_is_valid(base) || !gpio_is_valid(base + chip->ngpio - 1))
 			&& base >= 0) {
 		status = -EINVAL;
 		goto fail;
@@ -207,7 +207,7 @@ fail:
 	/* failures here can mean systems won't boot... */
 	if (status)
 		pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
-			chip->base, chip->base + chip->ngpio,
+			chip->base, chip->base + chip->ngpio - 1,
 			chip->label ? : "generic");
 	return status;
 }
_

Patches currently in -mm which might be from xyzzy@speakeasy.org are

gpiolib-fix-off-by-one-errors.patch

