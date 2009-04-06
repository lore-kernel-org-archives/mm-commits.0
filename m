From: akpm@linux-foundation.org
Subject: [merged] xtensa-let-platform-override-kerneloffset.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:39:42 -0700
Message-ID: <200904061939.n36Jdgtv013991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54985 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757456AbZDFTnw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:43:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jw@emlix.com, chris@zankel.net, dg@emlix.com, os@emlix.com, mm-commits@vger.kernel.org


The patch titled
     xtensa: let platform override KERNELOFFSET
has been removed from the -mm tree.  Its filename was
     xtensa-let-platform-override-kerneloffset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa: let platform override KERNELOFFSET
From: Johannes Weiner <jw@emlix.com>

The linker script should not assume a fix offset in memory for the
kernel, this is platform-specific, so let the platform set it.

Signed-off-by: Johannes Weiner <jw@emlix.com>
Cc: Oskar Schirmer <os@emlix.com>
Cc: Daniel Glockner <dg@emlix.com>
Cc: Christian Zankel <chris@zankel.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/kernel/vmlinux.lds.S |    3 +++
 1 file changed, 3 insertions(+)

diff -puN arch/xtensa/kernel/vmlinux.lds.S~xtensa-let-platform-override-kerneloffset arch/xtensa/kernel/vmlinux.lds.S
--- a/arch/xtensa/kernel/vmlinux.lds.S~xtensa-let-platform-override-kerneloffset
+++ a/arch/xtensa/kernel/vmlinux.lds.S
@@ -17,6 +17,7 @@
 #include <asm-generic/vmlinux.lds.h>
 
 #include <variant/core.h>
+#include <platform/hardware.h>
 OUTPUT_ARCH(xtensa)
 ENTRY(_start)
 
@@ -26,7 +27,9 @@ jiffies = jiffies_64 + 4;
 jiffies = jiffies_64;
 #endif
 
+#ifndef KERNELOFFSET
 #define KERNELOFFSET 0xd0001000
+#endif
 
 /* Note: In the following macros, it would be nice to specify only the
    vector name and section kind and construct "sym" and "section" using
_

Patches currently in -mm which might be from jw@emlix.com are

origin.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-variant-specific-code.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch

