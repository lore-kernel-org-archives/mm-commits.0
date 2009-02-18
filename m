From: akpm@linux-foundation.org
Subject: [merged] mfd-fix-section-mismatch-in-sm501c.patch removed from -mm tree
Date: Wed, 18 Feb 2009 02:14:10 -0800
Message-ID: <200902181014.n1IAEAh1006387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59272 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbZBRKON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 05:14:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rakib.mullick@gmail.com, sameo@openedhand.com, mm-commits@vger.kernel.org


The patch titled
     mfd: fix section mismatch in sm501.c
has been removed from the -mm tree.  Its filename was
     mfd-fix-section-mismatch-in-sm501c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mfd: fix section mismatch in sm501.c
From: Rakib Mullick <rakib.mullick@gmail.com>

Fix the following warning, caused due to a call from function
sm501_register_gpio() to a function sm501_gpio_register_chip() which is
marked as __devinit function.

  LD      drivers/mfd/built-in.o
WARNING: drivers/mfd/built-in.o(.text+0x16ca): Section mismatch in
reference from the function sm501_register_gpio() to the function
.devinit.text:sm501_gpio_register_chip()
The function sm501_register_gpio() references
the function __devinit sm501_gpio_register_chip().
This is often because sm501_register_gpio lacks a __devinit
annotation or the annotation of sm501_gpio_register_chip is wrong.

WARNING: drivers/mfd/built-in.o(.text+0x1706): Section mismatch in
reference from the function sm501_register_gpio() to the function
.devinit.text:sm501_gpio_register_chip()
The function sm501_register_gpio() references
the function __devinit sm501_gpio_register_chip().
This is often because sm501_register_gpio lacks a __devinit
annotation or the annotation of sm501_gpio_register_chip is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mfd/sm501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mfd/sm501.c~mfd-fix-section-mismatch-in-sm501c drivers/mfd/sm501.c
--- a/drivers/mfd/sm501.c~mfd-fix-section-mismatch-in-sm501c
+++ a/drivers/mfd/sm501.c
@@ -1050,7 +1050,7 @@ static int __devinit sm501_gpio_register
 	return gpiochip_add(gchip);
 }
 
-static int sm501_register_gpio(struct sm501_devdata *sm)
+static int __devinit sm501_register_gpio(struct sm501_devdata *sm)
 {
 	struct sm501_gpio *gpio = &sm->gpio;
 	resource_size_t iobase = sm->io_res->start + SM501_GPIO;
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

origin.patch
linux-next.patch
kernel-auditscc-fix-warning.patch
kmemleak-fix-section-mismatch-in-kmemleakc.patch

