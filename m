From: akpm@linux-foundation.org
Subject: + m68k-use-_ac-instead-of-ifdef-__assembly__.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:18:18 -0700
Message-ID: <200708152118.l7FLIISM015475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48885 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761072AbXHOVTJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:19:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org


The patch titled
     m68k: Use _AC() instead of #ifdef __ASSEMBLY__
has been added to the -mm tree.  Its filename is
     m68k-use-_ac-instead-of-ifdef-__assembly__.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

m68k-asm-pageh-needs-linux-compilerh.patch
m68k-kill-superfluous-extern.patch
m68k-remove-unnecessary-m68k_memoffset-export-and-init.patch
remove-dead-code-in-via-pmu68k.patch
m68k-use-_ac-instead-of-ifdef-__assembly__.patch
m68k-enable-arbitary-speed-tty-support.patch
m68k-dont-include-rodata-into-text-segment.patch
m68k-fix-a-few-hickups-in-drivers-scsi-kconfig.patch
zorro-make-sysfs-config-attribute-read-only.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons-declaration-visible.patch
m68k-mac-make-mac_hid_mouse_emulate_buttons.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
