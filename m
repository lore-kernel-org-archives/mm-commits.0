From: akpm@linux-foundation.org
Subject: - m68k-use-_ac-instead-of-ifdef-__assembly__.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:56:10 -0700
Message-ID: <200708242056.l7OKuArE014017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44138 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762847AbXHXVIT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:08:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     m68k: Use _AC() instead of #ifdef __ASSEMBLY__
has been removed from the -mm tree.  Its filename was
     m68k-use-_ac-instead-of-ifdef-__assembly__.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68k: Use _AC() instead of #ifdef __ASSEMBLY__
From: Geert Uytterhoeven <geert@linux-m68k.org>

m68k: Use _AC() instead of #ifdef __ASSEMBLY__ hackery when needed, remove
hackery when unused.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68k/page.h      |    8 +++-----
 include/asm-m68k/processor.h |    4 ----
 2 files changed, 3 insertions(+), 9 deletions(-)

diff -puN include/asm-m68k/page.h~m68k-use-_ac-instead-of-ifdef-__assembly__ include/asm-m68k/page.h
--- a/include/asm-m68k/page.h~m68k-use-_ac-instead-of-ifdef-__assembly__
+++ a/include/asm-m68k/page.h
@@ -4,17 +4,15 @@
 
 #ifdef __KERNEL__
 
+#include <linux/const.h>
+
 /* PAGE_SHIFT determines the page size */
 #ifndef CONFIG_SUN3
 #define PAGE_SHIFT	(12)
 #else
 #define PAGE_SHIFT	(13)
 #endif
-#ifdef __ASSEMBLY__
-#define PAGE_SIZE	(1 << PAGE_SHIFT)
-#else
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
-#endif
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #include <asm/setup.h>
diff -puN include/asm-m68k/processor.h~m68k-use-_ac-instead-of-ifdef-__assembly__ include/asm-m68k/processor.h
--- a/include/asm-m68k/processor.h~m68k-use-_ac-instead-of-ifdef-__assembly__
+++ a/include/asm-m68k/processor.h
@@ -38,12 +38,8 @@ static inline void wrusp(unsigned long u
 #ifndef CONFIG_SUN3
 #define TASK_SIZE	(0xF0000000UL)
 #else
-#ifdef __ASSEMBLY__
-#define TASK_SIZE	(0x0E000000)
-#else
 #define TASK_SIZE	(0x0E000000UL)
 #endif
-#endif
 
 /* This decides where the kernel will search for a free chunk of vm
  * space during mmap's.
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
