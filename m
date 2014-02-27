From: akpm@linux-foundation.org
Subject: [merged] asm-systemh-arm-delete-asm-systemh.patch removed from
 -mm tree
Date: Thu, 27 Feb 2014 12:23:42 -0800
Message-ID: <530f9ece.Y09WQNTeV9QsqYL/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaB0UXn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Feb 2014 15:23:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de, dhowells@redhat.com

Subject: [merged] asm-systemh-arm-delete-asm-systemh.patch removed from -mm tree
To: dhowells@redhat.com,arnd@arndb.de,linux@arm.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 27 Feb 2014 12:23:42 -0800


The patch titled
     Subject: asm/system.h: arm: delete asm/system.h
has been removed from the -mm tree.  Its filename was
     asm-systemh-arm-delete-asm-systemh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: asm/system.h: arm: delete asm/system.h

Delete ARM's asm/system.h.  It's the last holdout and should be got rid of.

This builds for defconfig, lpc32xx_defconfig, exynos_defconfig + XEN, the
previous changed to a Gemini system and an omap3 config with TI_DAVINCI_EMAC.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/jump_label.h  |    1 -
 arch/arm/include/asm/sync_bitops.h |    1 -
 arch/arm/include/asm/system.h      |    7 -------
 arch/arm/mach-gemini/idle.c        |    2 +-
 arch/arm/mach-omap2/am35xx-emac.c  |    1 -
 drivers/usb/gadget/lpc32xx_udc.c   |    1 -
 6 files changed, 1 insertion(+), 12 deletions(-)

diff -puN arch/arm/include/asm/jump_label.h~asm-systemh-arm-delete-asm-systemh arch/arm/include/asm/jump_label.h
--- a/arch/arm/include/asm/jump_label.h~asm-systemh-arm-delete-asm-systemh
+++ a/arch/arm/include/asm/jump_label.h
@@ -4,7 +4,6 @@
 #ifdef __KERNEL__
 
 #include <linux/types.h>
-#include <asm/system.h>
 
 #define JUMP_LABEL_NOP_SIZE 4
 
diff -puN arch/arm/include/asm/sync_bitops.h~asm-systemh-arm-delete-asm-systemh arch/arm/include/asm/sync_bitops.h
--- a/arch/arm/include/asm/sync_bitops.h~asm-systemh-arm-delete-asm-systemh
+++ a/arch/arm/include/asm/sync_bitops.h
@@ -2,7 +2,6 @@
 #define __ASM_SYNC_BITOPS_H__
 
 #include <asm/bitops.h>
-#include <asm/system.h>
 
 /* sync_bitops functions are equivalent to the SMP implementation of the
  * original functions, independently from CONFIG_SMP being defined.
diff -puN arch/arm/include/asm/system.h~asm-systemh-arm-delete-asm-systemh /dev/null
--- a/arch/arm/include/asm/system.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/* FILE TO BE DELETED. DO NOT ADD STUFF HERE! */
-#include <asm/barrier.h>
-#include <asm/compiler.h>
-#include <asm/cmpxchg.h>
-#include <asm/switch_to.h>
-#include <asm/system_info.h>
-#include <asm/system_misc.h>
diff -puN arch/arm/mach-gemini/idle.c~asm-systemh-arm-delete-asm-systemh arch/arm/mach-gemini/idle.c
--- a/arch/arm/mach-gemini/idle.c~asm-systemh-arm-delete-asm-systemh
+++ a/arch/arm/mach-gemini/idle.c
@@ -3,7 +3,7 @@
  */
 
 #include <linux/init.h>
-#include <asm/system.h>
+#include <asm/system_misc.h>
 #include <asm/proc-fns.h>
 
 static void gemini_idle(void)
diff -puN arch/arm/mach-omap2/am35xx-emac.c~asm-systemh-arm-delete-asm-systemh arch/arm/mach-omap2/am35xx-emac.c
--- a/arch/arm/mach-omap2/am35xx-emac.c~asm-systemh-arm-delete-asm-systemh
+++ a/arch/arm/mach-omap2/am35xx-emac.c
@@ -17,7 +17,6 @@
 
 #include <linux/err.h>
 #include <linux/davinci_emac.h>
-#include <asm/system.h>
 #include "omap_device.h"
 #include "am35xx.h"
 #include "control.h"
diff -puN drivers/usb/gadget/lpc32xx_udc.c~asm-systemh-arm-delete-asm-systemh drivers/usb/gadget/lpc32xx_udc.c
--- a/drivers/usb/gadget/lpc32xx_udc.c~asm-systemh-arm-delete-asm-systemh
+++ a/drivers/usb/gadget/lpc32xx_udc.c
@@ -55,7 +55,6 @@
 #include <mach/hardware.h>
 #include <linux/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include <mach/platform.h>
 #include <mach/irqs.h>
_

Patches currently in -mm which might be from dhowells@redhat.com are

fs-cachefiles-use-add_to_page_cache_lru.patch
lglock-map-to-spinlock-when-config_smp.patch
linux-next.patch
asm-systemh-clean-asm-systemh-from-docs.patch
asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch
mutex-subsystem-synchro-test-module.patch

