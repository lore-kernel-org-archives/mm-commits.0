From: akpm@linux-foundation.org
Subject: + add-generic-gpio-support-to-x86.patch added to -mm tree
Date: Thu, 25 Oct 2007 14:23:41 -0700
Message-ID: <200710252123.l9PLNf4k024709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbXJYVYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 17:24:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: florian.fainelli@telecomint.eu, david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: add generic GPIO support
has been added to the -mm tree.  Its filename is
     add-generic-gpio-support-to-x86.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: add generic GPIO support
From: Florian Fainelli <florian.fainelli@telecomint.eu>

Add generic GPIO support to the x86 architecture.  We do the same as for MIPS,
we let the machine override the gpio callbacks and provide defaults one in
mach-generic.

Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig                   |    4 ++++
 include/asm-x86/gpio.h              |    6 ++++++
 include/asm-x86/mach-generic/gpio.h |   15 +++++++++++++++
 3 files changed, 25 insertions(+)

diff -puN arch/i386/Kconfig~add-generic-gpio-support-to-x86 arch/i386/Kconfig
--- a/arch/i386/Kconfig~add-generic-gpio-support-to-x86
+++ a/arch/i386/Kconfig
@@ -79,6 +79,10 @@ config GENERIC_BUG
 	default y
 	depends on BUG
 
+config GENERIC_GPIO
+	bool
+	default n
+
 config GENERIC_HWEIGHT
 	bool
 	default y
diff -puN /dev/null include/asm-x86/gpio.h
--- /dev/null
+++ a/include/asm-x86/gpio.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_I386_GPIO_H
+#define _ASM_I386_GPIO_H
+
+#include <gpio.h>
+
+#endif /* _ASM_I386_GPIO_H */
diff -puN /dev/null include/asm-x86/mach-generic/gpio.h
--- /dev/null
+++ a/include/asm-x86/mach-generic/gpio.h
@@ -0,0 +1,15 @@
+#ifndef __ASM_MACH_GENERIC_GPIO_H
+#define __ASM_MACH_GENERIC_GPIO_H
+
+int gpio_request(unsigned gpio, const char *label);
+void gpio_free(unsigned gpio);
+int gpio_direction_input(unsigned gpio);
+int gpio_direction_output(unsigned gpio, int value);
+int gpio_get_value(unsigned gpio);
+void gpio_set_value(unsigned gpio, int value);
+int gpio_to_irq(unsigned gpio);
+int irq_to_gpio(unsigned irq);
+
+#include <asm-generic/gpio.h>           /* cansleep wrappers */
+
+#endif /* __ASM_MACH_GENERIC_GPIO_H */
_

Patches currently in -mm which might be from florian.fainelli@telecomint.eu are

add-generic-gpio-support-to-x86.patch
pcih-add-pci-identifiers-for-the-rdc-devices.patch
add-support-for-the-rdc-r-321x-soc.patch
add-the-rdc-machine-specific-reboot-fixup.patch
