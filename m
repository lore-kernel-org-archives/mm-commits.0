From: akpm@linux-foundation.org
Subject: + x86_64-fix-ia32_binfmtc-build-error.patch added to -mm tree
Date: Thu, 01 Mar 2007 15:10:31 -0800
Message-ID: <200703012310.l21NAVl2025449@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53245 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161169AbXCAXNy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 18:13:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, ak@suse.de


The patch titled
     x86_64: fix ia32_binfmt.c build error
has been added to the -mm tree.  Its filename is
     x86_64-fix-ia32_binfmtc-build-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: fix ia32_binfmt.c build error
From: Ralf Baechle <ralf@linux-mips.org>

Reorder code to avoid multiple inclusion of elf.h.

#undef several symbols to avoid build errors over redefinitions.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32_binfmt.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/ia32/ia32_binfmt.c~x86_64-fix-ia32_binfmtc-build-error arch/x86_64/ia32/ia32_binfmt.c
--- a/arch/x86_64/ia32/ia32_binfmt.c~x86_64-fix-ia32_binfmtc-build-error
+++ a/arch/x86_64/ia32/ia32_binfmt.c
@@ -5,6 +5,11 @@
  * This tricks binfmt_elf.c into loading 32bit binaries using lots 
  * of ugly preprocessor tricks. Talk about very very poor man's inheritance.
  */ 
+#define __ASM_X86_64_ELF_H 1
+
+#undef ELF_CLASS
+#define ELF_CLASS ELFCLASS32
+
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/rwsem.h>
@@ -50,9 +55,6 @@ struct elf_phdr; 
 #undef ELF_ARCH
 #define ELF_ARCH EM_386
 
-#undef ELF_CLASS
-#define ELF_CLASS ELFCLASS32
-
 #define ELF_DATA	ELFDATA2LSB
 
 #define USE_ELF_CORE_DUMP 1
@@ -136,7 +138,7 @@ struct elf_prpsinfo
 
 #define user user32
 
-#define __ASM_X86_64_ELF_H 1
+#undef elf_read_implies_exec
 #define elf_read_implies_exec(ex, executable_stack)     (executable_stack != EXSTACK_DISABLE_X)
 //#include <asm/ia32.h>
 #include <linux/elf.h>
_

Patches currently in -mm which might be from ralf@linux-mips.org are

serial-driver-pmc-msp71xx.patch
rm9000-serial-driver.patch
rm9000-serial-driver-tidy.patch
x86_64-fix-ia32_binfmtc-build-error.patch
simplify-the-stacktrace-code.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
local_t-mips-extension.patch
local_t-mips-extension-fix.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
