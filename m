From: akpm@linux-foundation.org
Subject: + use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch added to -mm tree
Date: Tue, 08 May 2007 14:17:49 -0700
Message-ID: <200705082117.l48LHnsp001947@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031844AbXEHVSR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 17:18:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hskinnemoen@atmel.com, andrew@sanpeople.com, david-b@pacbell.net, nicolas.ferre@rfo.atmel.com


The patch titled
     Use common cpu_is_xxx() macros on AT91 and AVR32
has been added to the -mm tree.  Its filename is
     use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use common cpu_is_xxx() macros on AT91 and AVR32
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Several drivers shared between AT91 and AVR32 chips use cpu_is_xxx()
to handle CPU-specific differences. Currently, such code needs to be
inside #ifdef CONFIG_ARCH_AT91 because the macros don't exist on AVR32.

By defining the same macros on both AT91 and AVR32, these #ifdefs can
be eliminated. Since the macros will evaluate to a constant value for
CPUs that aren't supported by the current architecture, any code that
is only needed on AT91 will be optimized away on AVR32 and vice versa.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: David Brownell <david-b@pacbell.net>
Acked-by: Andrew Victor <andrew@sanpeople.com>
Cc: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/arch-at91/cpu.h     |    6 ++++
 include/asm-avr32/arch-at32ap/cpu.h |   33 ++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff -puN include/asm-arm/arch-at91/cpu.h~use-common-cpu_is_xxx-macros-on-at91-and-avr32 include/asm-arm/arch-at91/cpu.h
--- a/include/asm-arm/arch-at91/cpu.h~use-common-cpu_is_xxx-macros-on-at91-and-avr32
+++ a/include/asm-arm/arch-at91/cpu.h
@@ -68,4 +68,10 @@ static inline unsigned long at91_arch_id
 #define cpu_is_at91sam9263()	(0)
 #endif
 
+/*
+ * Since this is ARM, we will never run on any AVR32 CPU. But these
+ * definitions may reduce clutter in common drivers.
+ */
+#define cpu_is_at32ap7000()	(0)
+
 #endif
diff -puN /dev/null include/asm-avr32/arch-at32ap/cpu.h
--- /dev/null
+++ a/include/asm-avr32/arch-at32ap/cpu.h
@@ -0,0 +1,33 @@
+/*
+ * AVR32 and (fake) AT91 CPU identification
+ *
+ * Copyright (C) 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ASM_ARCH_CPU_H
+#define __ASM_ARCH_CPU_H
+
+/*
+ * Only AT32AP7000 is defined for now. We can identify the specific
+ * chip at runtime, but I'm not sure if it's really worth it.
+ */
+#ifdef CONFIG_CPU_AT32AP7000
+# define cpu_is_at32ap7000()	(1)
+#else
+# define cpu_is_at32ap7000()	(0)
+#endif
+
+/*
+ * Since this is AVR32, we will never run on any AT91 CPU. But these
+ * definitions may reduce clutter in common drivers.
+ */
+#define cpu_is_at91rm9200()	(0)
+#define cpu_is_at91sam9xe()	(0)
+#define cpu_is_at91sam9260()	(0)
+#define cpu_is_at91sam9261()	(0)
+#define cpu_is_at91sam9263()	(0)
+
+#endif /* __ASM_ARCH_CPU_H */
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-avr32.patch
use-common-cpu_is_xxx-macros-on-at91-and-avr32.patch
atmel_spi-remove-unnecessary-and-wrong-ifdefs.patch
markers-add-instrumentation-markers-menus-to-avr32.patch
