From: akpm@linux-foundation.org
Subject: + xtensa-let-platform-override-kerneloffset.patch added to -mm tree
Date: Mon, 30 Mar 2009 17:00:45 -0700
Message-ID: <200903310000.n2V00jqh031549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51600 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761794AbZCaAEu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 20:04:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jw@emlix.com, chris@zankel.net, dg@emlix.com, os@emlix.com


The patch titled
     xtensa: let platform override KERNELOFFSET
has been added to the -mm tree.  Its filename is
     xtensa-let-platform-override-kerneloffset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

xtensa-enforce-slab-alignment-to-maximum-register-width.patch
xtensa-add-flat-support.patch
xtensa-add-flat-support-checkpatch-fixes.patch
xtensa-nommu-support.patch
xtensa-variant-specific-code.patch
xtensa-variant-irq-set-callbacks.patch
xtensa-s6000-variant-core-definitions.patch
xtensa-s6000-variant.patch
xtensa-s6000-gpio-driver.patch
xtensa-let-platform-override-kerneloffset.patch
xtensa-platform-stretch-s6105-eval-board.patch
xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
xtensa-s6105-specific-configuration-for-s6gmac.patch
xtensa-enable-s6gmac-in-s6105_defconfig.patch
flat-fix-data-sections-alignment.patch
flat-fix-data-sections-alignment-update.patch

