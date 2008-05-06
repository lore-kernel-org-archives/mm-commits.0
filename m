From: akpm@linux-foundation.org
Subject: + uml-use-page_size-in-linker-scripts.patch added to -mm tree
Date: Tue, 06 May 2008 13:49:35 -0700
Message-ID: <200805062049.m46KnZYa026594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763766AbYEFUuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 16:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, jdike@linux.intel.com, xiyou.wangcong@gmail.com


The patch titled
     uml: use PAGE_SIZE in linker scripts
has been added to the -mm tree.  Its filename is
     uml-use-page_size-in-linker-scripts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: use PAGE_SIZE in linker scripts
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch includes page.h header into liker scripts that allow us to use
PAGE_SIZE macro instead of numeric constant.

To be able to include page.h into linker scripts page.h is needed for some
modification - i.e.  we need to use __ASSEMBLY__ and _AC macro

[jdike@linux.intel.com - fixed conflict with as-layout.h]
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/as-layout.h |   14 +++++++-------
 arch/um/kernel/dyn.lds.S    |    7 ++++---
 arch/um/kernel/uml.lds.S    |    7 ++++---
 include/asm-um/page.h       |   17 +++++++++++------
 4 files changed, 26 insertions(+), 19 deletions(-)

diff -puN arch/um/include/as-layout.h~uml-use-page_size-in-linker-scripts arch/um/include/as-layout.h
--- a/arch/um/include/as-layout.h~uml-use-page_size-in-linker-scripts
+++ a/arch/um/include/as-layout.h
@@ -23,16 +23,16 @@
  */
 
 #ifdef __ASSEMBLY__
-#define _AC(X, Y)	(Y)
+#define _UML_AC(X, Y)	(Y)
 #else
-#define __AC(X, Y)	(X (Y))
-#define _AC(X, Y)	__AC(X, Y)
+#define __UML_AC(X, Y)	(X(Y))
+#define _UML_AC(X, Y)	__UML_AC(X, Y)
 #endif
 
-#define STUB_START _AC(, 0x100000)
-#define STUB_CODE _AC((unsigned long), STUB_START)
-#define STUB_DATA _AC((unsigned long), STUB_CODE + UM_KERN_PAGE_SIZE)
-#define STUB_END _AC((unsigned long), STUB_DATA + UM_KERN_PAGE_SIZE)
+#define STUB_START _UML_AC(, 0x100000)
+#define STUB_CODE _UML_AC((unsigned long), STUB_START)
+#define STUB_DATA _UML_AC((unsigned long), STUB_CODE + UM_KERN_PAGE_SIZE)
+#define STUB_END _UML_AC((unsigned long), STUB_DATA + UM_KERN_PAGE_SIZE)
 
 #ifndef __ASSEMBLY__
 
diff -puN arch/um/kernel/dyn.lds.S~uml-use-page_size-in-linker-scripts arch/um/kernel/dyn.lds.S
--- a/arch/um/kernel/dyn.lds.S~uml-use-page_size-in-linker-scripts
+++ a/arch/um/kernel/dyn.lds.S
@@ -1,4 +1,5 @@
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 OUTPUT_FORMAT(ELF_FORMAT)
 OUTPUT_ARCH(ELF_ARCH)
@@ -21,7 +22,7 @@ SECTIONS
 	_einittext = .;
   }
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
 
   /* Read-only sections, merged into text segment: */
   .hash           : { *(.hash) }
@@ -68,9 +69,9 @@ SECTIONS
     /* .gnu.warning sections are handled specially by elf32.em.  */
     *(.gnu.warning)
 
-    . = ALIGN(4096);
+    . = ALIGN(PAGE_SIZE);
   } =0x90909090
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .syscall_stub : {
 	__syscall_stub_start = .;
 	*(.__syscall_stub*)
diff -puN arch/um/kernel/uml.lds.S~uml-use-page_size-in-linker-scripts arch/um/kernel/uml.lds.S
--- a/arch/um/kernel/uml.lds.S~uml-use-page_size-in-linker-scripts
+++ a/arch/um/kernel/uml.lds.S
@@ -1,4 +1,5 @@
 #include <asm-generic/vmlinux.lds.h>
+#include <asm/page.h>
 
 OUTPUT_FORMAT(ELF_FORMAT)
 OUTPUT_ARCH(ELF_ARCH)
@@ -26,7 +27,7 @@ SECTIONS
 	INIT_TEXT
 	_einittext = .;
   }
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
 
   .text      :
   {
@@ -39,7 +40,7 @@ SECTIONS
     *(.gnu.linkonce.t*)
   }
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .syscall_stub : {
 	__syscall_stub_start = .;
 	*(.__syscall_stub*)
@@ -79,7 +80,7 @@ SECTIONS
   .sdata     : { *(.sdata) }
   _edata  =  .;
   PROVIDE (edata = .);
-  . = ALIGN(0x1000);
+  . = ALIGN(PAGE_SIZE);
   .sbss      :
   {
    __bss_start = .;
diff -puN include/asm-um/page.h~uml-use-page_size-in-linker-scripts include/asm-um/page.h
--- a/include/asm-um/page.h~uml-use-page_size-in-linker-scripts
+++ a/include/asm-um/page.h
@@ -7,16 +7,20 @@
 #ifndef __UM_PAGE_H
 #define __UM_PAGE_H
 
-struct page;
-
-#include <linux/types.h>
-#include <asm/vm-flags.h>
+#include <linux/const.h>
 
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 
+#ifndef __ASSEMBLY__
+
+struct page;
+
+#include <linux/types.h>
+#include <asm/vm-flags.h>
+
 /*
  * These are used to make use of C type-checking..
  */
@@ -120,4 +124,5 @@ extern struct page *arch_validate(struct
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
 
-#endif
+#endif	/* __ASSEMBLY__ */
+#endif	/* __UM_PAGE_H */
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
linux-next.patch
uml-use-page_size-in-linker-scripts.patch
cifs-find_unc-cleanup.patch
cifs-cifs_find_tcp_session-cleanup.patch
mips-elf-handling-use-selfmag-instead-of-numeric-constant.patch
module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch

