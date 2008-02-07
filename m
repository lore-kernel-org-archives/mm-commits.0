From: akpm@linux-foundation.org
Subject: - fix-__const_udelay-declaration-and-definition-mismatches.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:23:27 -0800
Message-ID: <200802070023.m170N8Ew006500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50925 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933428AbYBGAq7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, hskinnemoen@atmel.com, jdike@linux.intel.com, lethal@linux-sh.org, mingo@elte.hu, takata@linux-m32r.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Fix __const_udelay declaration and definition mismatches
has been removed from the -mm tree.  Its filename was
     fix-__const_udelay-declaration-and-definition-mismatches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix __const_udelay declaration and definition mismatches
From: Jeff Dike <jdike@addtoit.com>

The declaration and implementation of __const_udelay use different
names for the parameter on a number of architectures:

include/asm-avr32/delay.h:15:extern void __const_udelay(unsigned long usecs);
arch/avr32/lib/delay.c:39:inline void __const_udelay(unsigned long xloops)

include/asm-sh/delay.h:15:extern void __const_udelay(unsigned long usecs);
arch/sh/lib/delay.c:22:inline void __const_udelay(unsigned long xloops)

include/asm-m32r/delay.h:15:extern void __const_udelay(unsigned long usecs);
arch/m32r/lib/delay.c:58:void __const_udelay(unsigned long xloops)

include/asm-x86/delay.h:16:extern void __const_udelay(unsigned long usecs);
arch/x86/lib/delay_32.c:82:inline void __const_udelay(unsigned long xloops)
arch/x86/lib/delay_64.c:46:inline void __const_udelay(unsigned long xloops)

The units of the parameter isn't usecs, so that name is definitely
wrong.  It's also not exactly loops, so I suppose xloops is an OK
name.

This patch changes these names from usecs to xloops.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-avr32/delay.h |    2 +-
 include/asm-m32r/delay.h  |    2 +-
 include/asm-sh/delay.h    |    2 +-
 include/asm-x86/delay.h   |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/asm-avr32/delay.h~fix-__const_udelay-declaration-and-definition-mismatches include/asm-avr32/delay.h
--- a/include/asm-avr32/delay.h~fix-__const_udelay-declaration-and-definition-mismatches
+++ a/include/asm-avr32/delay.h
@@ -12,7 +12,7 @@ extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
 extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
 #define udelay(n) (__builtin_constant_p(n) ? \
diff -puN include/asm-m32r/delay.h~fix-__const_udelay-declaration-and-definition-mismatches include/asm-m32r/delay.h
--- a/include/asm-m32r/delay.h~fix-__const_udelay-declaration-and-definition-mismatches
+++ a/include/asm-m32r/delay.h
@@ -12,7 +12,7 @@ extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
 extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
 #define udelay(n) (__builtin_constant_p(n) ? \
diff -puN include/asm-sh/delay.h~fix-__const_udelay-declaration-and-definition-mismatches include/asm-sh/delay.h
--- a/include/asm-sh/delay.h~fix-__const_udelay-declaration-and-definition-mismatches
+++ a/include/asm-sh/delay.h
@@ -12,7 +12,7 @@ extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
 extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
 #ifdef CONFIG_SUPERH32
diff -puN include/asm-x86/delay.h~fix-__const_udelay-declaration-and-definition-mismatches include/asm-x86/delay.h
--- a/include/asm-x86/delay.h~fix-__const_udelay-declaration-and-definition-mismatches
+++ a/include/asm-x86/delay.h
@@ -13,7 +13,7 @@ extern void __bad_ndelay(void);
 
 extern void __udelay(unsigned long usecs);
 extern void __ndelay(unsigned long nsecs);
-extern void __const_udelay(unsigned long usecs);
+extern void __const_udelay(unsigned long xloops);
 extern void __delay(unsigned long loops);
 
 /* 0x10c7 is 2**32 / 1000000 (rounded up) */
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
uml-runtime-host-vmsplit-detection.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-x86_64-should-copy-%fs-during-fork.patch
uml-fix-mm_context-memory-leak.patch
