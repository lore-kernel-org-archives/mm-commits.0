From: akpm@linux-foundation.org
Subject: [merged] it8761e_gpio-fix-bug-in-gpio-numbering.patch removed from -mm tree
Date: Wed, 12 May 2010 10:58:01 -0400
Message-ID: <201005121759.o4CHxTA4011512@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353Ab0ELSAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 14:00:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: denis@compulab.co.il, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     it8761e_gpio: fix bug in gpio numbering
has been removed from the -mm tree.  Its filename was
     it8761e_gpio-fix-bug-in-gpio-numbering.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: it8761e_gpio: fix bug in gpio numbering
From: Denis Turischev <denis@compulab.co.il>

The SIO chip contains 16 possible gpio lines, not 14.  The schematic was
not read carefully.

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

origin.patch

