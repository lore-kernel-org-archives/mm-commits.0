From: akpm@linux-foundation.org
Subject: - add-generic-gpio-support-to-x86.patch removed from -mm tree
Date: Mon, 29 Oct 2007 22:08:05 -0700
Message-ID: <200710300508.l9U585cp010237@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40252 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033AbXJ3FIe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 01:08:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: florian.fainelli@telecomint.eu, david-b@pacbell.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: add generic GPIO support
has been removed from the -mm tree.  Its filename was
     add-generic-gpio-support-to-x86.patch

This patch was dropped because an updated version will be merged

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

 arch/x86/Kconfig.i386               |    4 ++++
 include/asm-x86/gpio.h              |    6 ++++++
 include/asm-x86/mach-generic/gpio.h |   15 +++++++++++++++
 3 files changed, 25 insertions(+)

diff -puN arch/x86/Kconfig.i386~add-generic-gpio-support-to-x86 arch/x86/Kconfig.i386
--- a/arch/x86/Kconfig.i386~add-generic-gpio-support-to-x86
+++ a/arch/x86/Kconfig.i386
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

git-watchdog.patch
add-generic-gpio-support-to-x86.patch
pci-add-pci-identifiers-for-the-rdc-devices.patch
x86-add-support-for-the-rdc-r-321x-soc.patch
add-the-rdc-machine-specific-reboot-fixup.patch
