From: akpm@linux-foundation.org
Subject: + gpio_free-might-sleep-arm-architecture.patch added to -mm tree
Date: Wed, 17 Sep 2008 14:40:10 -0700
Message-ID: <200809172140.m8HLeA0f031808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479AbYIQVkd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 17:40:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ukleinek@informatik.uni-freiburg.de, david-b@pacbell.net, linux@maxim.org.za, rmk+kernel@arm.linux.org.uk


The patch titled
     gpio_free might sleep, arm architecture
has been added to the -mm tree.  Its filename is
     gpio_free-might-sleep-arm-architecture.patch

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
Subject: gpio_free might sleep, arm architecture
=46rom: Uwe Kleine-K=F6nig <ukleinek@informatik.uni-freiburg.de>

According to the documentation gpio_free should only be called from tas=
k
context only.  To make this more explicit add a might sleep to all
implementations.

This patch changes the gpio_free implementations for the arm architectu=
re.
 DaVinci is skipped on purpose to simplify the merge process for patche=
s
switching it over to use gpiolib as per request by David Brownell.

Signed-off-by: Uwe Kleine-K=F6nig <ukleinek@informatik.uni-freiburg.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/include/mach/gpio.h   |    2 ++
 arch/arm/mach-imx/include/mach/gpio.h    |    3 +++
 arch/arm/mach-ixp4xx/include/mach/gpio.h |    3 +++
 arch/arm/mach-ks8695/include/mach/gpio.h |    3 +++
 arch/arm/mach-ns9xxx/gpio.c              |    2 ++
 arch/arm/mach-orion5x/gpio.c             |    2 ++
 6 files changed, 15 insertions(+)

diff -puN arch/arm/mach-at91/include/mach/gpio.h~gpio_free-might-sleep-=
arm-architecture arch/arm/mach-at91/include/mach/gpio.h
--- a/arch/arm/mach-at91/include/mach/gpio.h~gpio_free-might-sleep-arm-=
architecture
+++ a/arch/arm/mach-at91/include/mach/gpio.h
@@ -13,6 +13,7 @@
 #ifndef __ASM_ARCH_AT91RM9200_GPIO_H
 #define __ASM_ARCH_AT91RM9200_GPIO_H
=20
+#include <linux/kernel.h>
 #include <asm/irq.h>
=20
 #define PIN_BASE		NR_AIC_IRQS
@@ -220,6 +221,7 @@ static inline int gpio_request(unsigned=20
=20
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
 }
=20
 extern int gpio_direction_input(unsigned gpio);
diff -puN arch/arm/mach-imx/include/mach/gpio.h~gpio_free-might-sleep-a=
rm-architecture arch/arm/mach-imx/include/mach/gpio.h
--- a/arch/arm/mach-imx/include/mach/gpio.h~gpio_free-might-sleep-arm-a=
rchitecture
+++ a/arch/arm/mach-imx/include/mach/gpio.h
@@ -1,5 +1,6 @@
 #ifndef _IMX_GPIO_H
=20
+#include <linux/kernel.h>
 #include <mach/imx-regs.h>
=20
 #define IMX_GPIO_ALLOC_MODE_NORMAL	0
@@ -63,6 +64,8 @@ static inline int gpio_request(unsigned=20
=20
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
+
 	imx_gpio_free(gpio);
 }
=20
diff -puN arch/arm/mach-ixp4xx/include/mach/gpio.h~gpio_free-might-slee=
p-arm-architecture arch/arm/mach-ixp4xx/include/mach/gpio.h
--- a/arch/arm/mach-ixp4xx/include/mach/gpio.h~gpio_free-might-sleep-ar=
m-architecture
+++ a/arch/arm/mach-ixp4xx/include/mach/gpio.h
@@ -25,6 +25,7 @@
 #ifndef __ASM_ARCH_IXP4XX_GPIO_H
 #define __ASM_ARCH_IXP4XX_GPIO_H
=20
+#include <linux/kernel.h>
 #include <mach/hardware.h>
=20
 static inline int gpio_request(unsigned gpio, const char *label)
@@ -34,6 +35,8 @@ static inline int gpio_request(unsigned=20
=20
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
+
 	return;
 }
=20
diff -puN arch/arm/mach-ks8695/include/mach/gpio.h~gpio_free-might-slee=
p-arm-architecture arch/arm/mach-ks8695/include/mach/gpio.h
--- a/arch/arm/mach-ks8695/include/mach/gpio.h~gpio_free-might-sleep-ar=
m-architecture
+++ a/arch/arm/mach-ks8695/include/mach/gpio.h
@@ -11,6 +11,8 @@
 #ifndef __ASM_ARCH_GPIO_H_
 #define __ASM_ARCH_GPIO_H_
=20
+#include <linux/kernel.h>
+
 #define KS8695_GPIO_0		0
 #define KS8695_GPIO_1		1
 #define KS8695_GPIO_2		2
@@ -74,6 +76,7 @@ static inline int gpio_request(unsigned=20
=20
 static inline void gpio_free(unsigned int pin)
 {
+	might_sleep();
 }
=20
 #endif
diff -puN arch/arm/mach-ns9xxx/gpio.c~gpio_free-might-sleep-arm-archite=
cture arch/arm/mach-ns9xxx/gpio.c
--- a/arch/arm/mach-ns9xxx/gpio.c~gpio_free-might-sleep-arm-architectur=
e
+++ a/arch/arm/mach-ns9xxx/gpio.c
@@ -8,6 +8,7 @@
  * under the terms of the GNU General Public License version 2 as publ=
ished by
  * the Free Software Foundation.
  */
+#include <linux/kernel.h>
 #include <linux/compiler.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
@@ -63,6 +64,7 @@ EXPORT_SYMBOL(gpio_request);
=20
 void gpio_free(unsigned gpio)
 {
+	might_sleep();
 	clear_bit(gpio, gpiores);
 	return;
 }
diff -puN arch/arm/mach-orion5x/gpio.c~gpio_free-might-sleep-arm-archit=
ecture arch/arm/mach-orion5x/gpio.c
--- a/arch/arm/mach-orion5x/gpio.c~gpio_free-might-sleep-arm-architectu=
re
+++ a/arch/arm/mach-orion5x/gpio.c
@@ -165,6 +165,8 @@ EXPORT_SYMBOL(gpio_request);
=20
 void gpio_free(unsigned pin)
 {
+	might_sleep();
+
 	if (pin >=3D GPIO_MAX || !test_bit(pin, gpio_valid)) {
 		pr_debug("%s: invalid GPIO %d\n", __func__, pin);
 		return;
_

Patches currently in -mm which might be from ukleinek@informatik.uni-fr=
eiburg.de are

linux-next.patch
snd-aica-platform-driver-fix-section-mismatch.patch
gpio_free-might-sleep-generic-part.patch
gpio_free-might-sleep-arm-architecture.patch
gpio_free-might-sleep-mips-architecture.patch
gpio_free-might-sleep-blackfin-architecture.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
