From: akpm@linux-foundation.org
Subject: - at91-gpio-wrappers-tidy.patch removed from -mm tree
Date: Sun, 11 Feb 2007 23:23:45 -0800
Message-ID: <200702120723.l1C7Nj7i024725@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44778 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932963AbXBLHXs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 02:23:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     at91-gpio-wrappers-tidy
has been removed from the -mm tree.  Its filename was
     at91-gpio-wrappers-tidy.patch

This patch was dropped because it was folded into at91-gpio-wrappers.patch

------------------------------------------------------
Subject: at91-gpio-wrappers-tidy
From: Andrew Morton <akpm@osdl.org>

Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/arch-at91rm9200/gpio.h |   25 +++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff -puN include/asm-arm/arch-at91rm9200/gpio.h~at91-gpio-wrappers-tidy include/asm-arm/arch-at91rm9200/gpio.h
--- a/include/asm-arm/arch-at91rm9200/gpio.h~at91-gpio-wrappers-tidy
+++ a/include/asm-arm/arch-at91rm9200/gpio.h
@@ -205,30 +205,39 @@ extern void at91_gpio_resume(void);
 #include <asm/errno.h>
 
 static inline int gpio_request(unsigned gpio, const char *label)
-	{ return 0; }
+{
+	return 0;
+}
 
 static inline void gpio_free(unsigned gpio)
-	{ }
-
+{
+}
 
 extern int gpio_direction_input(unsigned gpio);
 extern int gpio_direction_output(unsigned gpio);
 
 static inline int gpio_get_value(unsigned gpio)
-	{ return at91_get_gpio_value(gpio); }
+{
+	return at91_get_gpio_value(gpio);
+}
 
 static inline void gpio_set_value(unsigned gpio, int value)
-	{ (void) at91_set_gpio_value(gpio, value); }
+{
+	at91_set_gpio_value(gpio, value);
+}
 
 #include <asm-generic/gpio.h>		/* cansleep wrappers */
 
 static inline int gpio_to_irq(unsigned gpio)
-	{ return gpio; }
+{
+	return gpio;
+}
 
 static inline int irq_to_gpio(unsigned irq)
-	{ return irq; }
+{
+	return irq;
+}
 
 #endif	/* __ASSEMBLY__ */
 
 #endif
-
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
register_chrdev_region-dont-hand-out-the-local-experimental-majors.patch
register_blkdev-dont-hand-out-the-local-experimental-majors.patch
spi-controller-driver-for-omap-microwire.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
omap-gpio-wrappers.patch
at91-gpio-wrappers.patch
at91-gpio-wrappers-tidy.patch
ecryptfs-public-key-packet-management-slab-fix.patch
ecryptfs-generalize-metadata-read-write-fix.patch
dynamic-kernel-command-line-ia64-fix.patch
kvm-add-a-global-list-of-all-virtual-machines-tidy.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
mark-struct-file_operations-const-2-fix.patch
mark-struct-file_operations-const-4-fix.patch
