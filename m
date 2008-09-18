From: akpm@linux-foundation.org
Subject: + gpio_free-might-sleep-mips-architecture.patch added to -mm tree
Date: Thu, 18 Sep 2008 02:44:06 -0700
Message-ID: <200809180944.m8I9i7Bg025037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbYIRJpO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Sep 2008 05:45:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ukleinek@informatik.uni-freiburg.de, david-b@pacbell.net, ralf@linux-mips.org


The patch titled
     gpio_free might sleep, mips architecture
has been added to the -mm tree.  Its filename is
     gpio_free-might-sleep-mips-architecture.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gpio_free might sleep, mips architecture
=46rom: Uwe Kleine-K=F6nig <ukleinek@informatik.uni-freiburg.de>

According to the documentation gpio_free should only be called from tas=
k
context only.  To make this more explicit add a might sleep to all
implementations.

This patch changes the gpio_free implementations for the mips
architecture.

Signed-off-by: Uwe Kleine-K=F6nig <ukleinek@informatik.uni-freiburg.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-mips/mach-au1x00/gpio.h  |    2 ++
 include/asm-mips/mach-bcm47xx/gpio.h |    3 +++
 2 files changed, 5 insertions(+)

diff -puN include/asm-mips/mach-au1x00/gpio.h~gpio_free-might-sleep-mip=
s-architecture include/asm-mips/mach-au1x00/gpio.h
--- a/include/asm-mips/mach-au1x00/gpio.h~gpio_free-might-sleep-mips-ar=
chitecture
+++ a/include/asm-mips/mach-au1x00/gpio.h
@@ -1,6 +1,7 @@
 #ifndef _AU1XXX_GPIO_H_
 #define _AU1XXX_GPIO_H_
=20
+#include <linux/kernel.h>
 #include <linux/types.h>
=20
 #define AU1XXX_GPIO_BASE	200
@@ -31,6 +32,7 @@ static inline int gpio_request(unsigned=20
 static inline void gpio_free(unsigned gpio)
 {
 	/* Not yet implemented */
+	might_sleep();
 }
=20
 static inline int gpio_direction_input(unsigned gpio)
diff -puN include/asm-mips/mach-bcm47xx/gpio.h~gpio_free-might-sleep-mi=
ps-architecture include/asm-mips/mach-bcm47xx/gpio.h
--- a/include/asm-mips/mach-bcm47xx/gpio.h~gpio_free-might-sleep-mips-a=
rchitecture
+++ a/include/asm-mips/mach-bcm47xx/gpio.h
@@ -9,6 +9,8 @@
 #ifndef __BCM47XX_GPIO_H
 #define __BCM47XX_GPIO_H
=20
+#include <linux/kernel.h>
+
 #define BCM47XX_EXTIF_GPIO_LINES	5
 #define BCM47XX_CHIPCO_GPIO_LINES	16
=20
@@ -25,6 +27,7 @@ static inline int gpio_request(unsigned=20
=20
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
 }
=20
 static inline int gpio_to_irq(unsigned gpio)
_

Patches currently in -mm which might be from ukleinek@informatik.uni-fr=
eiburg.de are

linux-next.patch
snd-aica-platform-driver-fix-section-mismatch.patch
gpio_free-might-sleep-arm-architecture.patch
gpio_free-might-sleep-mips-architecture.patch
gpio_free-might-sleep-blackfin-architecture.patch
gpio_free-might-sleep-generic-part.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
