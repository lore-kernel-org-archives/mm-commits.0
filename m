From: akpm@linux-foundation.org
Subject: + mips-add-gpio-support-to-the-bcm947xx-platform-update.patch added to -mm tree
Date: Thu, 13 Sep 2007 14:35:20 -0700
Message-ID: <200709132135.l8DLZKbH007131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754355AbXIMVgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 17:36:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aurelien@aurel32.net, david-b@pacbell.net, geert@linux-m68k.org, mb@bu3sch.de, ralf@linux-mips.org


The patch titled
     mips-add-gpio-support-to-the-bcm947xx-platform update
has been added to the -mm tree.  Its filename is
     mips-add-gpio-support-to-the-bcm947xx-platform-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips-add-gpio-support-to-the-bcm947xx-platform update
From: Aurelien Jarno <aurelien@aurel32.net>

On Fri, Aug 17, 2007 at 09:00:31PM +0200, Michael Buesch wrote:
> On Friday 17 August 2007 20:56:42 David Brownell wrote:
> > On Friday 17 August 2007, akpm@linux-foundation.org wrote:
> >
> > > +static inline int gpio_to_irq(unsigned gpio)
> > > +{
> > > +	if (ssb_bcm947xx.chipco.dev)
> >
> > Looks like a runtime switch ... can this be done at
> > compile time instead?
>
> No, it's a runtime condition.
>
> > This idiom shows up in all of
> > these routines.  (ssb_bcm947xx isn't in kernel.org
> > code so Mr. Grep is no help yet.)  If not, these
> > might all be better as non-inlned functions.
>
> Yeah.

First of all, sorry for the delay. Please find below a new version of
the patch that takes into account your comments. The functions are not
inlined anymore and they check the gpio pin number.

Andrew, this patch replaces the patch called
mips-add-gpio-support-to-the-bcm947xx-platform.patch.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Brownell <david-b@pacbell.net>
Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/bcm947xx/Makefile           |    2 
 arch/mips/bcm947xx/gpio.c             |   79 ++++++++++++++++++++++++
 include/asm-mips/mach-bcm947xx/gpio.h |   58 ++++-------------
 3 files changed, 94 insertions(+), 45 deletions(-)

diff -puN arch/mips/bcm947xx/Makefile~mips-add-gpio-support-to-the-bcm947xx-platform-update arch/mips/bcm947xx/Makefile
--- a/arch/mips/bcm947xx/Makefile~mips-add-gpio-support-to-the-bcm947xx-platform-update
+++ a/arch/mips/bcm947xx/Makefile
@@ -3,4 +3,4 @@
 # under Linux.
 #
 
-obj-y := irq.o prom.o serial.o setup.o time.o
+obj-y := gpio.o irq.o prom.o serial.o setup.o time.o
diff -puN /dev/null arch/mips/bcm947xx/gpio.c
--- /dev/null
+++ a/arch/mips/bcm947xx/gpio.c
@@ -0,0 +1,79 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2007 Aurelien Jarno <aurelien@aurel32.net>
+ */
+
+#include <linux/ssb/ssb.h>
+#include <linux/ssb/ssb_driver_chipcommon.h>
+#include <linux/ssb/ssb_driver_extif.h>
+#include <asm/mach-bcm947xx/bcm947xx.h>
+#include <asm/mach-bcm947xx/gpio.h>
+
+int bcm947xx_gpio_to_irq(unsigned gpio)
+{
+	if (ssb_bcm947xx.chipco.dev)
+		return ssb_mips_irq(ssb_bcm947xx.chipco.dev) + 2;
+	else if (ssb_bcm947xx.extif.dev)
+		return ssb_mips_irq(ssb_bcm947xx.extif.dev) + 2;
+	else
+		return -EINVAL;
+}
+EXPORT_SYMBOL(bcm947xx_gpio_to_irq);
+
+int bcm947xx_gpio_get_value(unsigned gpio)
+{
+	if (ssb_bcm947xx.chipco.dev)
+		return ssb_chipco_gpio_in(&ssb_bcm947xx.chipco, 1 << gpio);
+	else if (ssb_bcm947xx.extif.dev)
+		return ssb_extif_gpio_in(&ssb_bcm947xx.extif, 1 << gpio);
+	else
+		return 0;
+}
+EXPORT_SYMBOL(bcm947xx_gpio_get_value);
+
+void bcm947xx_gpio_set_value(unsigned gpio, int value)
+{
+	if (ssb_bcm947xx.chipco.dev)
+		ssb_chipco_gpio_out(&ssb_bcm947xx.chipco,
+				    1 << gpio,
+				    value ? 1 << gpio : 0);
+	else if (ssb_bcm947xx.extif.dev)
+		ssb_extif_gpio_out(&ssb_bcm947xx.extif,
+				   1 << gpio,
+				   value ? 1 << gpio : 0);
+}
+EXPORT_SYMBOL(bcm947xx_gpio_set_value);
+
+int bcm947xx_gpio_direction_input(unsigned gpio)
+{
+	if (ssb_bcm947xx.chipco.dev && (gpio < BCM947XX_CHIPCO_GPIO_LINES))
+		ssb_chipco_gpio_outen(&ssb_bcm947xx.chipco,
+				      1 << gpio, 0);
+	else if (ssb_bcm947xx.extif.dev && (gpio < BCM947XX_EXTIF_GPIO_LINES))
+		ssb_extif_gpio_outen(&ssb_bcm947xx.extif,
+				     1 << gpio, 0);
+	else
+		return -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL(bcm947xx_gpio_direction_input);
+
+int bcm947xx_gpio_direction_output(unsigned gpio, int value)
+{
+	bcm947xx_gpio_set_value(gpio, value);
+
+	if (ssb_bcm947xx.chipco.dev && (gpio < BCM947XX_CHIPCO_GPIO_LINES))
+		ssb_chipco_gpio_outen(&ssb_bcm947xx.chipco,
+				      1 << gpio, 1 << gpio);
+	else if (ssb_bcm947xx.extif.dev && (gpio < BCM947XX_EXTIF_GPIO_LINES))
+		ssb_extif_gpio_outen(&ssb_bcm947xx.extif,
+				     1 << gpio, 1 << gpio);
+	else
+		return -EINVAL;
+	return 0;
+}
+EXPORT_SYMBOL(bcm947xx_gpio_direction_output);
+
diff -puN include/asm-mips/mach-bcm947xx/gpio.h~mips-add-gpio-support-to-the-bcm947xx-platform-update include/asm-mips/mach-bcm947xx/gpio.h
--- a/include/asm-mips/mach-bcm947xx/gpio.h~mips-add-gpio-support-to-the-bcm947xx-platform-update
+++ a/include/asm-mips/mach-bcm947xx/gpio.h
@@ -9,10 +9,14 @@
 #ifndef __BCM947XX_GPIO_H
 #define __BCM947XX_GPIO_H
 
-#include <linux/ssb/ssb.h>
-#include <linux/ssb/ssb_driver_chipcommon.h>
-#include <linux/ssb/ssb_driver_extif.h>
-#include <asm/mach-bcm947xx/bcm947xx.h>
+#define BCM947XX_EXTIF_GPIO_LINES	5
+#define BCM947XX_CHIPCO_GPIO_LINES	16
+
+extern int bcm947xx_gpio_to_irq(unsigned gpio);
+extern int bcm947xx_gpio_get_value(unsigned gpio);
+extern void bcm947xx_gpio_set_value(unsigned gpio, int value);
+extern int bcm947xx_gpio_direction_input(unsigned gpio);
+extern int bcm947xx_gpio_direction_output(unsigned gpio, int value);
 
 static inline int gpio_request(unsigned gpio, const char *label)
 {
@@ -25,64 +29,30 @@ static inline void gpio_free(unsigned gp
 
 static inline int gpio_to_irq(unsigned gpio)
 {
-	if (ssb_bcm947xx.chipco.dev)
-		return ssb_mips_irq(ssb_bcm947xx.chipco.dev) + 2;
-	else if (ssb_bcm947xx.extif.dev)
-		return ssb_mips_irq(ssb_bcm947xx.extif.dev) + 2;
-	else
-		return -EINVAL;
+	return bcm947xx_gpio_to_irq(gpio);
 }
 
 static inline int gpio_get_value(unsigned gpio)
 {
-	if (ssb_bcm947xx.chipco.dev)
-		return ssb_chipco_gpio_in(&ssb_bcm947xx.chipco, 1 << gpio);
-	else if (ssb_bcm947xx.extif.dev)
-		return ssb_extif_gpio_in(&ssb_bcm947xx.extif, 1 << gpio);
-	else
-		return 0;
+	return bcm947xx_gpio_get_value(gpio);
 }
 
 static inline void gpio_set_value(unsigned gpio, int value)
 {
-	if (ssb_bcm947xx.chipco.dev)
-		ssb_chipco_gpio_out(&ssb_bcm947xx.chipco,
-				    1 << gpio,
-				    value ? 1 << gpio : 0);
-	else if (ssb_bcm947xx.extif.dev)
-		ssb_extif_gpio_out(&ssb_bcm947xx.extif,
-				   1 << gpio,
-				   value ? 1 << gpio : 0);
+	bcm947xx_gpio_set_value(gpio, value);
 }
 
 static inline int gpio_direction_input(unsigned gpio)
 {
-	if (ssb_bcm947xx.chipco.dev)
-		ssb_chipco_gpio_outen(&ssb_bcm947xx.chipco,
-				      1 << gpio, 0);
-	else if (ssb_bcm947xx.extif.dev)
-		ssb_extif_gpio_outen(&ssb_bcm947xx.extif,
-				     1 << gpio, 0);
-	else
-		return -EINVAL;
-	return 0;
+	return bcm947xx_gpio_direction_input(gpio);
 }
 
 static inline int gpio_direction_output(unsigned gpio, int value)
 {
-	gpio_set_value(gpio, value);
-
-	if (ssb_bcm947xx.chipco.dev)
-		ssb_chipco_gpio_outen(&ssb_bcm947xx.chipco,
-				      1 << gpio, 1 << gpio);
-	else if (ssb_bcm947xx.extif.dev)
-		ssb_extif_gpio_outen(&ssb_bcm947xx.extif,
-				     1 << gpio, 1 << gpio);
-	else
-		return -EINVAL;
-	return 0;
+	return bcm947xx_gpio_direction_output(gpio, value);
 }
 
+
 /* cansleep wrappers */
 #include <asm-generic/gpio.h>
 
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-add-gpio-support-to-the-bcm947xx-platform-update.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
git-wireless.patch
move-mm_struct-and-vm_area_struct-fix.patch
