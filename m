From: akpm@linux-foundation.org
Subject: + it8761e_gpio-fix-bug-in-gpio-numbering.patch added to -mm tree
Date: Mon, 22 Mar 2010 13:58:48 -0700
Message-ID: <201003222058.o2MKwm5C026995@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137Ab0CVU65 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 16:58:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: denis@compulab.co.il, david-b@pacbell.net


The patch titled
     it8761e_gpio: fix bug in gpio numbering
has been added to the -mm tree.  Its filename is
     it8761e_gpio-fix-bug-in-gpio-numbering.patch

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
Subject: it8761e_gpio: fix bug in gpio numbering
From: Denis Turischev <denis@compulab.co.il>

-ENOCHANGELOG

Signed-off-by: Denis Turischev <denis@compulab.co.il>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/it8761e_gpio.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/gpio/it8761e_gpio.c~it8761e_gpio-fix-bug-in-gpio-numbering drivers/gpio/it8761e_gpio.c
--- a/drivers/gpio/it8761e_gpio.c~it8761e_gpio-fix-bug-in-gpio-numbering
+++ a/drivers/gpio/it8761e_gpio.c
@@ -80,8 +80,8 @@ static int it8761e_gpio_get(struct gpio_
 	u16 reg;
 	u8 bit;
 
-	bit = gpio_num % 7;
-	reg = (gpio_num >= 7) ? gpio_ba + 1 : gpio_ba;
+	bit = gpio_num % 8;
+	reg = (gpio_num >= 8) ? gpio_ba + 1 : gpio_ba;
 
 	return !!(inb(reg) & (1 << bit));
 }
@@ -91,8 +91,8 @@ static int it8761e_gpio_direction_in(str
 	u8 curr_dirs;
 	u8 io_reg, bit;
 
-	bit = gpio_num % 7;
-	io_reg = (gpio_num >= 7) ? GPIO2X_IO : GPIO1X_IO;
+	bit = gpio_num % 8;
+	io_reg = (gpio_num >= 8) ? GPIO2X_IO : GPIO1X_IO;
 
 	spin_lock(&sio_lock);
 
@@ -116,8 +116,8 @@ static void it8761e_gpio_set(struct gpio
 	u8 curr_vals, bit;
 	u16 reg;
 
-	bit = gpio_num % 7;
-	reg = (gpio_num >= 7) ? gpio_ba + 1 : gpio_ba;
+	bit = gpio_num % 8;
+	reg = (gpio_num >= 8) ? gpio_ba + 1 : gpio_ba;
 
 	spin_lock(&sio_lock);
 
@@ -135,8 +135,8 @@ static int it8761e_gpio_direction_out(st
 {
 	u8 curr_dirs, io_reg, bit;
 
-	bit = gpio_num % 7;
-	io_reg = (gpio_num >= 7) ? GPIO2X_IO : GPIO1X_IO;
+	bit = gpio_num % 8;
+	io_reg = (gpio_num >= 8) ? GPIO2X_IO : GPIO1X_IO;
 
 	it8761e_gpio_set(gc, gpio_num, val);
 
@@ -200,7 +200,7 @@ static int __init it8761e_gpio_init(void
 		return -EBUSY;
 
 	it8761e_gpio_chip.base = -1;
-	it8761e_gpio_chip.ngpio = 14;
+	it8761e_gpio_chip.ngpio = 16;
 
 	err = gpiochip_add(&it8761e_gpio_chip);
 	if (err < 0)
_

Patches currently in -mm which might be from denis@compulab.co.il are

it8761e_gpio-fix-bug-in-gpio-numbering.patch

