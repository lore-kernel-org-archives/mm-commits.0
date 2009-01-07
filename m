From: akpm@linux-foundation.org
Subject: - remove-linux-hardirqh-from-asm-generic-localh.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:16:03 -0800
Message-ID: <200901072216.n07MG3iI015808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760003AbZAGWQV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:16:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rmk+kernel@arm.linux.org.uk, adobriyan@gmail.com, kosaki.motohiro@jp.fujitsu.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     remove linux/hardirq.h from asm-generic/local.h
has been removed from the -mm tree.  Its filename was
     remove-linux-hardirqh-from-asm-generic-localh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove linux/hardirq.h from asm-generic/local.h
From: Russell King <rmk+kernel@arm.linux.org.uk>

While looking at reducing the amount of architecture namespace pollution
in the generic kernel, I found that asm/irq.h is included in the vast
majority of compilations on ARM (around 650 files.)

Since asm/irq.h includes a sub-architecture include file on ARM, this
causes a negative impact on the ccache's ability to re-use the build
results from other sub-architectures, so we have a desire to reduce the
dependencies on asm/irq.h.

It turns out that a major cause of this is the needless include of
linux/hardirq.h into asm-generic/local.h.  The patch below removes this
include, resulting in some 250 to 300 files (around half) of the kernel
then omitting asm/irq.h.

My test builds still succeed, provided two ARM files are fixed
(arch/arm/kernel/traps.c and arch/arm/mm/fault.c) - so there may be
negative impacts for this on other architectures.

Note that x86 does not include asm/irq.h nor linux/hardirq.h in its
asm/local.h, so this patch can be viewed as bringing the generic version
into line with the x86 version.

[kosaki.motohiro@jp.fujitsu.com: add #include <linux/irqflags.h> to acpi/processor_idle.c]
[adobriyan@gmail.com: fix sparc64]
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/traps.c     |    1 +
 arch/sh/kernel/traps_32.c     |    1 +
 drivers/acpi/processor_idle.c |    1 +
 include/asm-generic/local.h   |    1 -
 4 files changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/avr32/kernel/traps.c~remove-linux-hardirqh-from-asm-generic-localh arch/avr32/kernel/traps.c
--- a/arch/avr32/kernel/traps.c~remove-linux-hardirqh-from-asm-generic-localh
+++ a/arch/avr32/kernel/traps.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/bug.h>
+#include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
 #include <linux/kdebug.h>
diff -puN arch/sh/kernel/traps_32.c~remove-linux-hardirqh-from-asm-generic-localh arch/sh/kernel/traps_32.c
--- a/arch/sh/kernel/traps_32.c~remove-linux-hardirqh-from-asm-generic-localh
+++ a/arch/sh/kernel/traps_32.c
@@ -13,6 +13,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
+#include <linux/hardirq.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
diff -puN drivers/acpi/processor_idle.c~remove-linux-hardirqh-from-asm-generic-localh drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~remove-linux-hardirqh-from-asm-generic-localh
+++ a/drivers/acpi/processor_idle.c
@@ -41,6 +41,7 @@
 #include <linux/pm_qos_params.h>
 #include <linux/clockchips.h>
 #include <linux/cpuidle.h>
+#include <linux/irqflags.h>
 
 /*
  * Include the apic definitions for x86 to have the APIC timer related defines
diff -puN include/asm-generic/local.h~remove-linux-hardirqh-from-asm-generic-localh include/asm-generic/local.h
--- a/include/asm-generic/local.h~remove-linux-hardirqh-from-asm-generic-localh
+++ a/include/asm-generic/local.h
@@ -2,7 +2,6 @@
 #define _ASM_GENERIC_LOCAL_H
 
 #include <linux/percpu.h>
-#include <linux/hardirq.h>
 #include <asm/atomic.h>
 #include <asm/types.h>
 
_

Patches currently in -mm which might be from rmk+kernel@arm.linux.org.uk are

origin.patch
linux-next.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch

