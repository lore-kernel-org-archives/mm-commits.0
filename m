From: akpm@linux-foundation.org
Subject: - omap-gpio-wrappers-tidy.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:23:35 -0800
Message-ID: <200702120723.l1C7NZu3024719@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44772 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932942AbXBLHXh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:23:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     omap-gpio-wrappers-tidy
has been removed from the -mm tree.  Its filename was
     omap-gpio-wrappers-tidy.patch

This patch was dropped because it was folded into omap-gpio-wrappers.patch

------------------------------------------------------
Subject: omap-gpio-wrappers-tidy
From: Andrew Morton <akpm@osdl.org>

What on earth?

Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/arch-omap/gpio.h |   30 ++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff -puN include/asm-arm/arch-omap/gpio.h~omap-gpio-wrappers-tidy include/asm-arm/arch-omap/gpio.h
--- a/include/asm-arm/arch-omap/gpio.h~omap-gpio-wrappers-tidy
+++ a/include/asm-arm/arch-omap/gpio.h
@@ -86,11 +86,14 @@ extern int omap_get_gpio_datain(int gpio
 #include <asm/errno.h>
 
 static inline int gpio_request(unsigned gpio, const char *label)
-	{ return omap_request_gpio(gpio); }
+{
+	return omap_request_gpio(gpio);
+}
 
 static inline void gpio_free(unsigned gpio)
-	{ omap_free_gpio(gpio); }
-
+{
+	omap_free_gpio(gpio);
+}
 
 static inline int __gpio_set_direction(unsigned gpio, int is_input)
 {
@@ -106,22 +109,31 @@ static inline int __gpio_set_direction(u
 }
 
 static inline int gpio_direction_input(unsigned gpio)
-	{ return __gpio_set_direction(gpio, 1); }
+{
+	return __gpio_set_direction(gpio, 1);
+}
 
 static inline int gpio_direction_output(unsigned gpio)
-	{ return __gpio_set_direction(gpio, 0); }
-
+{
+	return __gpio_set_direction(gpio, 0);
+}
 
 static inline int gpio_get_value(unsigned gpio)
-	{ return omap_get_gpio_datain(gpio); }
+{
+	return omap_get_gpio_datain(gpio);
+}
 
 static inline void gpio_set_value(unsigned gpio, int value)
-	{ omap_set_gpio_dataout(gpio, value); }
+{
+	omap_set_gpio_dataout(gpio, value);
+}
 
 #include <asm-generic/gpio.h>		/* cansleep wrappers */
 
 static inline int gpio_to_irq(unsigned gpio)
-	{ return OMAP_GPIO_IRQ(gpio); }
+{
+	return OMAP_GPIO_IRQ(gpio);
+}
 
 static inline int irq_to_gpio(unsigned irq)
 {
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
spi-controller-driver-for-omap-microwire.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
omap-gpio-wrappers.patch
omap-gpio-wrappers-tidy.patch
at91-gpio-wrappers-tidy.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-generalize-metadata-read-write-fix.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
