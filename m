From: akpm@linux-foundation.org
Subject: + nosave-consolidate-__nosave_beginend-in-asm-sectionsh.patch
 added to -mm tree
Date: Fri, 19 Sep 2014 16:09:31 -0700
Message-ID: <541cb7ab.wN3RI5Pla4VV9Akp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaISXJc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Sep 2014 19:09:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, benh@kernel.crashing.org, davem@davemloft.net, gxt@mprc.pku.edu.cn, hpa@zytor.com, linux@arm.linux.org.uk, mingo@redhat.com, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: nosave: consolidate __nosave_{begin,end} in <asm/sections.h>
has been added to the -mm tree.  Its filename is
     nosave-consolidate-__nosave_beginend-in-asm-sectionsh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nosave-consolidate-__nosave_beginend-in-asm-sectionsh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nosave-consolidate-__nosave_beginend-in-asm-sectionsh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: nosave: consolidate __nosave_{begin,end} in <asm/sections.h>

The different architectures used their own (and different) declarations:

    extern __visible const void __nosave_begin, __nosave_end;
    extern const void __nosave_begin, __nosave_end;
    extern long __nosave_begin, __nosave_end;

Consolidate them using the first variant in <asm/sections.h>.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/hibernate.c       |    3 +--
 arch/mips/include/asm/suspend.h   |    7 -------
 arch/mips/power/cpu.c             |    2 +-
 arch/powerpc/kernel/suspend.c     |    4 +---
 arch/s390/kernel/suspend.c        |    6 +-----
 arch/sh/include/asm/sections.h    |    1 -
 arch/sparc/power/hibernate.c      |    4 +---
 arch/unicore32/include/mach/pm.h  |    3 ---
 arch/unicore32/kernel/hibernate.c |    1 +
 arch/x86/power/hibernate_32.c     |    4 +---
 arch/x86/power/hibernate_64.c     |    4 +---
 include/asm-generic/sections.h    |    4 ++++
 12 files changed, 12 insertions(+), 31 deletions(-)

diff -puN arch/arm/kernel/hibernate.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh arch/arm/kernel/hibernate.c
--- a/arch/arm/kernel/hibernate.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh
+++ a/arch/arm/kernel/hibernate.c
@@ -21,8 +21,7 @@
 #include <asm/idmap.h>
 #include <asm/suspend.h>
 #include <asm/memory.h>
-
-extern const void __nosave_begin, __nosave_end;
+#include <asm/sections.h>
 
 int pfn_is_nosave(unsigned long pfn)
 {
diff -puN arch/mips/include/asm/suspend.h~nosave-consolidate-__nosave_beginend-in-asm-sectionsh /dev/null
--- a/arch/mips/include/asm/suspend.h
+++ /dev/null
@@ -1,7 +0,0 @@
-#ifndef __ASM_SUSPEND_H
-#define __ASM_SUSPEND_H
-
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
-
-#endif /* __ASM_SUSPEND_H */
diff -puN arch/mips/power/cpu.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh arch/mips/power/cpu.c
--- a/arch/mips/power/cpu.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh
+++ a/arch/mips/power/cpu.c
@@ -7,7 +7,7 @@
  * Author: Hu Hongbing <huhb@lemote.com>
  *	   Wu Zhangjin <wuzhangjin@gmail.com>
  */
-#include <asm/suspend.h>
+#include <asm/sections.h>
 #include <asm/fpu.h>
 #include <asm/dsp.h>
 
diff -puN arch/powerpc/kernel/suspend.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh arch/powerpc/kernel/suspend.c
--- a/arch/powerpc/kernel/suspend.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh
+++ a/arch/powerpc/kernel/suspend.c
@@ -9,9 +9,7 @@
 
 #include <linux/mm.h>
 #include <asm/page.h>
-
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
+#include <asm/sections.h>
 
 /*
  *	pfn_is_nosave - check if given pfn is in the 'nosave' section
diff -puN arch/s390/kernel/suspend.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh arch/s390/kernel/suspend.c
--- a/arch/s390/kernel/suspend.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh
+++ a/arch/s390/kernel/suspend.c
@@ -13,14 +13,10 @@
 #include <asm/ipl.h>
 #include <asm/cio.h>
 #include <asm/pci.h>
+#include <asm/sections.h>
 #include "entry.h"
 
 /*
- * References to section boundaries
- */
-extern const void __nosave_begin, __nosave_end;
-
-/*
  * The restore of the saved pages in an hibernation image will set
  * the change and referenced bits in the storage key for each page.
  * Overindication of the referenced bits after an hibernation cycle
diff -puN arch/sh/include/asm/sections.h~nosave-consolidate-__nosave_beginend-in-asm-sectionsh arch/sh/include/asm/sections.h
--- a/arch/sh/include/asm/sections.h~nosave-consolidate-__nosave_beginend-in-asm-sectionsh
+++ a/arch/sh/include/asm/sections.h
@@ -3,7 +3,6 @@
 
 #include <asm-generic/sections.h>
 
-extern long __nosave_begin, __nosave_end;
 extern long __machvec_start, __machvec_end;
 extern char __uncached_start, __uncached_end;
 extern char __start_eh_frame[], __stop_eh_frame[];
diff -puN arch/sparc/power/hibernate.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh arch/sparc/power/hibernate.c
--- a/arch/sparc/power/hibernate.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh
+++ a/arch/sparc/power/hibernate.c
@@ -9,11 +9,9 @@
 #include <asm/hibernate.h>
 #include <asm/visasm.h>
 #include <asm/page.h>
+#include <asm/sections.h>
 #include <asm/tlb.h>
 
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
-
 struct saved_context saved_context;
 
 /*
diff -puN arch/unicore32/include/mach/pm.h~nosave-consolidate-__nosave_beginend-in-asm-sectionsh arch/unicore32/include/mach/pm.h
--- a/arch/unicore32/include/mach/pm.h~nosave-consolidate-__nosave_beginend-in-asm-sectionsh
+++ a/arch/unicore32/include/mach/pm.h
@@ -36,8 +36,5 @@ extern int puv3_pm_enter(suspend_state_t
 /* Defined in hibernate_asm.S */
 extern int restore_image(pgd_t *resume_pg_dir, struct pbe *restore_pblist);
 
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
-
 extern struct pbe *restore_pblist;
 #endif
diff -puN arch/unicore32/kernel/hibernate.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh arch/unicore32/kernel/hibernate.c
--- a/arch/unicore32/kernel/hibernate.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh
+++ a/arch/unicore32/kernel/hibernate.c
@@ -18,6 +18,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
+#include <asm/sections.h>
 #include <asm/suspend.h>
 
 #include "mach/pm.h"
diff -puN arch/x86/power/hibernate_32.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh arch/x86/power/hibernate_32.c
--- a/arch/x86/power/hibernate_32.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh
+++ a/arch/x86/power/hibernate_32.c
@@ -13,13 +13,11 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mmzone.h>
+#include <asm/sections.h>
 
 /* Defined in hibernate_asm_32.S */
 extern int restore_image(void);
 
-/* References to section boundaries */
-extern const void __nosave_begin, __nosave_end;
-
 /* Pointer to the temporary resume page tables */
 pgd_t *resume_pg_dir;
 
diff -puN arch/x86/power/hibernate_64.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh arch/x86/power/hibernate_64.c
--- a/arch/x86/power/hibernate_64.c~nosave-consolidate-__nosave_beginend-in-asm-sectionsh
+++ a/arch/x86/power/hibernate_64.c
@@ -17,11 +17,9 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mtrr.h>
+#include <asm/sections.h>
 #include <asm/suspend.h>
 
-/* References to section boundaries */
-extern __visible const void __nosave_begin, __nosave_end;
-
 /* Defined in hibernate_asm_64.S */
 extern asmlinkage __visible int restore_image(void);
 
diff -puN include/asm-generic/sections.h~nosave-consolidate-__nosave_beginend-in-asm-sectionsh include/asm-generic/sections.h
--- a/include/asm-generic/sections.h~nosave-consolidate-__nosave_beginend-in-asm-sectionsh
+++ a/include/asm-generic/sections.h
@@ -3,6 +3,8 @@
 
 /* References to section boundaries */
 
+#include <linux/compiler.h>
+
 /*
  * Usage guidelines:
  * _text, _data: architecture specific, don't use them in arch-independent code
@@ -37,6 +39,8 @@ extern char __start_rodata[], __end_roda
 /* Start and end of .ctors section - used for constructor calls. */
 extern char __ctors_start[], __ctors_end[];
 
+extern __visible const void __nosave_begin, __nosave_end;
+
 /* function descriptor handling (if any).  Override
  * in asm/sections.h */
 #ifndef dereference_function_descriptor
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
mn10300-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
cris-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
m32r-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
score-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush.patch
m68k-call-find_vma-with-the-mmap_sem-held-in-sys_cacheflush-v2.patch
alpha-use-kbuild-logic-to-include-asm-generic-sectionsh.patch
include-linux-screen_infoh-remove-unused-orig_-macros.patch
nosave-consolidate-__nosave_beginend-in-asm-sectionsh.patch
printk-dont-bother-using-log_cpu_max_buf_shift-on-smp.patch
linux-next.patch

