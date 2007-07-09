From: akpm@linux-foundation.org
Subject: - geode-basic-infrastructure-support-for-amd-geode-class-update.patch removed from -mm tree
Date: Mon, 09 Jul 2007 12:37:19 -0700
Message-ID: <200707091937.l69JbJKT004874@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59849 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753625AbXGITh1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 15:37:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, mm-commits@vger.kernel.org


The patch titled
     geode-basic-infrastructure-support-for-amd-geode-class update
has been removed from the -mm tree.  Its filename was
     geode-basic-infrastructure-support-for-amd-geode-class-update.patch

This patch was dropped because it was folded into geode-basic-infrastructure-support-for-amd-geode-class.patch

------------------------------------------------------
Subject: geode-basic-infrastructure-support-for-amd-geode-class update
From: Andres Salomon <dilinger@queued.net>

Here's an updated version of this patch that scripts/checkpatch.pl is happy
with.



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/geode.c |    7 +++----
 include/asm-i386/geode.h |    2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff -puN arch/i386/kernel/geode.c~geode-basic-infrastructure-support-for-amd-geode-class-update arch/i386/kernel/geode.c
--- a/arch/i386/kernel/geode.c~geode-basic-infrastructure-support-for-amd-geode-class-update
+++ a/arch/i386/kernel/geode.c
@@ -10,7 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/msr.h>
 #include <asm/geode.h>
 
@@ -37,7 +37,8 @@ static void __init init_lbars(void)
 			lbars[i].base = lo & 0x0000ffff;
 
 		if (lbars[i].base == 0)
-			printk(KERN_ERR "geode:  Couldn't initialize '%s'\n", lbars[i].name);
+			printk(KERN_ERR "geode:  Couldn't initialize '%s'\n",
+					lbars[i].name);
 	}
 }
 
@@ -106,7 +107,6 @@ void geode_gpio_set_irq(unsigned int gro
 
 	wrmsr(MSR_PIC_ZSEL_HIGH, lo, hi);
 }
-
 EXPORT_SYMBOL_GPL(geode_gpio_set_irq);
 
 void geode_gpio_setup_event(unsigned int gpio, int pair, int pme)
@@ -141,7 +141,6 @@ void geode_gpio_setup_event(unsigned int
 
 	outl(val, base + offset);
 }
-
 EXPORT_SYMBOL_GPL(geode_gpio_setup_event);
 
 static int __init geode_southbridge_init(void)
diff -puN include/asm-i386/geode.h~geode-basic-infrastructure-support-for-amd-geode-class-update include/asm-i386/geode.h
--- a/include/asm-i386/geode.h~geode-basic-infrastructure-support-for-amd-geode-class-update
+++ a/include/asm-i386/geode.h
@@ -11,7 +11,7 @@
 #define _ASM_GEODE_H_
 
 #include <asm/processor.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 /* Generic southbridge functions */
 
_

Patches currently in -mm which might be from dilinger@queued.net are

geode-basic-infrastructure-support-for-amd-geode-class.patch
geode-basic-infrastructure-support-for-amd-geode-class-update.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-support-for-geode-class-machines-update.patch
geode-mfgpt-clock-event-device-support.patch
geode-mfgpt-clock-event-device-support-update.patch
