From: akpm@linux-foundation.org
Subject: + gpiolib-fix-have_gpio_lib-leftovers-in-asm-generic-gpioh.patch added to -mm tree
Date: Fri, 24 Sep 2010 15:43:20 -0700
Message-ID: <201009242243.o8OMhKe2029725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755016Ab0IXWnz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Sep 2010 18:43:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cbouatmailru@gmail.com, david-b@pacbell.net


The patch titled
     gpiolib: fix HAVE_GPIO_LIB leftovers in asm-generic/gpio.h
has been added to the -mm tree.  Its filename is
     gpiolib-fix-have_gpio_lib-leftovers-in-asm-generic-gpioh.patch

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
Subject: gpiolib: fix HAVE_GPIO_LIB leftovers in asm-generic/gpio.h
From: Anton Vorontsov <cbouatmailru@gmail.com>

commit 7444a72effa632fcd8edc566f88 ("gpiolib: allow user-selection")
removed HAVE_GPIO_LIB Kconfig symbol, but the header file still uses the
name [to confuse readers wrt #ifdef/#else/#endif location].

The real Kconfig symbol nowadays is CONFIG_GPIOLIB.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/gpio.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/gpio.h~gpiolib-fix-have_gpio_lib-leftovers-in-asm-generic-gpioh include/asm-generic/gpio.h
--- a/include/asm-generic/gpio.h~gpiolib-fix-have_gpio_lib-leftovers-in-asm-generic-gpioh
+++ a/include/asm-generic/gpio.h
@@ -210,7 +210,7 @@ extern void gpio_unexport(unsigned gpio)
 
 #endif	/* CONFIG_GPIO_SYSFS */
 
-#else	/* !CONFIG_HAVE_GPIO_LIB */
+#else	/* !CONFIG_GPIOLIB */
 
 static inline int gpio_is_valid(int number)
 {
@@ -239,7 +239,7 @@ static inline void gpio_set_value_cansle
 	gpio_set_value(gpio, value);
 }
 
-#endif /* !CONFIG_HAVE_GPIO_LIB */
+#endif /* !CONFIG_GPIOLIB */
 
 #ifndef CONFIG_GPIO_SYSFS
 
_

Patches currently in -mm which might be from cbouatmailru@gmail.com are

linux-next.patch
mtdpart-memory-accessor-interface-for-mtd-layer.patch
drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units.patch
gpio-add-driver-for-basic-memory-mapped-gpio-controllers.patch
gpiolib-fix-have_gpio_lib-leftovers-in-asm-generic-gpioh.patch

