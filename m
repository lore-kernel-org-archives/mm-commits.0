From: akpm@linux-foundation.org
Subject: + uml-borrow-consth-techniques.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:29:20 -0800
Message-ID: <200711060229.lA62TKRP031857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbXKFC3e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:29:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, geert@linux-m68k.org, jdike@linux.intel.com


The patch titled
     uml: borrow const.h techniques
has been added to the -mm tree.  Its filename is
     uml-borrow-consth-techniques.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: borrow const.h techniques
From: Jeff Dike <jdike@addtoit.com>

Suggested by Geert Uytterhoeven - use const.h to get constants that are usable
in both C and assembly.  I can't include it directly since this code can't
include kernel headers.  const.h is also for numeric constants that can be
typed by tacking a "UL" or similar on the end.  The constants here have to be
typed by casting them.

So, the relevant parts of const.h are copied here and modified in order to
allow the constants to be uncasted in assembly and casted in C.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/as-layout.h |   34 +++++++++++++++++++++-------------
 arch/um/sys-i386/stub.S     |    8 ++++----
 arch/um/sys-x86_64/stub.S   |    8 ++++----
 3 files changed, 29 insertions(+), 21 deletions(-)

diff -puN arch/um/include/as-layout.h~uml-borrow-consth-techniques arch/um/include/as-layout.h
--- a/arch/um/include/as-layout.h~uml-borrow-consth-techniques
+++ a/arch/um/include/as-layout.h
@@ -10,23 +10,31 @@
 #include "kern_constants.h"
 
 /*
- * Assembly doesn't want any casting, but C does, so define these
- * without casts here, and define new symbols with casts inside the C
- * section.
+ * Stolen from linux/const.h, which can't be directly included since
+ * this is used in userspace code, which has no access to the kernel
+ * headers.  Changed to be suitable for adding casts to the start,
+ * rather than "UL" to the end.
  */
-#define ASM_STUB_CODE (UML_CONFIG_TOP_ADDR - 2 * UM_KERN_PAGE_SIZE)
-#define ASM_STUB_DATA (UML_CONFIG_TOP_ADDR - UM_KERN_PAGE_SIZE)
-#define ASM_STUB_START ASM_STUB_CODE
 
-/*
- * This file is included by the assembly stubs, which just want the
- * definitions above.
+/* Some constant macros are used in both assembler and
+ * C code.  Therefore we cannot annotate them always with
+ * 'UL' and other type specifiers unilaterally.  We
+ * use the following macros to deal with this.
  */
-#ifndef __ASSEMBLY__
 
-#define STUB_CODE ((unsigned long) ASM_STUB_CODE)
-#define STUB_DATA ((unsigned long) ASM_STUB_DATA)
-#define STUB_START ((unsigned long) ASM_STUB_START)
+#ifdef __ASSEMBLY__
+#define _AC(X, Y)	(Y)
+#else
+#define __AC(X, Y)	(X (Y))
+#define _AC(X, Y)	__AC(X, Y)
+#endif
+
+#define STUB_CODE _AC((unsigned long), \
+		      UML_CONFIG_TOP_ADDR - 2 * UM_KERN_PAGE_SIZE)
+#define STUB_DATA _AC((unsigned long), UML_CONFIG_TOP_ADDR - UM_KERN_PAGE_SIZE)
+#define STUB_START _AC(, STUB_CODE)
+
+#ifndef __ASSEMBLY__
 
 #include "sysdep/ptrace.h"
 
diff -puN arch/um/sys-i386/stub.S~uml-borrow-consth-techniques arch/um/sys-i386/stub.S
--- a/arch/um/sys-i386/stub.S~uml-borrow-consth-techniques
+++ a/arch/um/sys-i386/stub.S
@@ -7,7 +7,7 @@
 	.globl batch_syscall_stub
 batch_syscall_stub:
 	/* load pointer to first operation */
-	mov	$(ASM_STUB_DATA+8), %esp
+	mov	$(STUB_DATA+8), %esp
 
 again:
 	/* load length of additional data */
@@ -15,12 +15,12 @@ again:
 
 	/* if(length == 0) : end of list */
 	/* write possible 0 to header */
-	mov	%eax, ASM_STUB_DATA+4
+	mov	%eax, STUB_DATA+4
 	cmpl	$0, %eax
 	jz	done
 
 	/* save current pointer */
-	mov	%esp, ASM_STUB_DATA+4
+	mov	%esp, STUB_DATA+4
 
 	/* skip additional data */
 	add	%eax, %esp
@@ -46,7 +46,7 @@ again:
 
 done:
 	/* save return value */
-	mov	%eax, ASM_STUB_DATA
+	mov	%eax, STUB_DATA
 
 	/* stop */
 	int3
diff -puN arch/um/sys-x86_64/stub.S~uml-borrow-consth-techniques arch/um/sys-x86_64/stub.S
--- a/arch/um/sys-x86_64/stub.S~uml-borrow-consth-techniques
+++ a/arch/um/sys-x86_64/stub.S
@@ -8,18 +8,18 @@ syscall_stub:
 	/* We don't have 64-bit constants, so this constructs the address
 	 * we need.
 	 */
-	movq	$(ASM_STUB_DATA >> 32), %rbx
+	movq	$(STUB_DATA >> 32), %rbx
 	salq	$32, %rbx
-	movq	$(ASM_STUB_DATA & 0xffffffff), %rcx
+	movq	$(STUB_DATA & 0xffffffff), %rcx
 	or	%rcx, %rbx
 	movq	%rax, (%rbx)
 	int3
 
 	.globl batch_syscall_stub
 batch_syscall_stub:
-	mov	$(ASM_STUB_DATA >> 32), %rbx
+	mov	$(STUB_DATA >> 32), %rbx
 	sal	$32, %rbx
-	mov	$(ASM_STUB_DATA & 0xffffffff), %rax
+	mov	$(STUB_DATA & 0xffffffff), %rax
 	or	%rax, %rbx
 	/* load pointer to first operation */
 	mov	%rbx, %rsp
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-correctly-strip-kernel-defines-from-userspace-cflags.patch
git-kvm.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
