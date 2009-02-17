From: akpm@linux-foundation.org
Subject: + mfd-fix-section-mismatch-in-sm501c.patch added to -mm tree
Date: Tue, 17 Feb 2009 15:57:18 -0800
Message-ID: <200902172357.n1HNvIse004530@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbZBQX5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Feb 2009 18:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, sameo@openedhand.com


The patch titled
     mfd: fix section mismatch in sm501.c
has been added to the -mm tree.  Its filename is
     mfd-fix-section-mismatch-in-sm501c.patch

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

linux-next.patch
kernel-auditscc-fix-warning.patch
mfd-fix-section-mismatch-in-sm501c.patch
kmemleak-fix-section-mismatch-in-kmemleakc.patch

