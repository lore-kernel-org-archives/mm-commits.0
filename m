From: akpm@linux-foundation.org
Subject: + arm64-switch-to-relative-exception-tables.patch added to -mm
 tree
Date: Wed, 27 Jan 2016 11:32:18 -0800
Message-ID: <56a91b42.mFVPotdZ3hOWFHH/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934530AbcA0TcU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 14:32:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: switch to relative exception tables
has been added to the -mm tree.  Its filename is
     arm64-switch-to-relative-exception-tables.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-switch-to-relative-exception-tables.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-switch-to-relative-exception-tables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: arm64: switch to relative exception tables

Instead of using absolute addresses for both the exception location and
the fixup, use offsets relative to the exception table entry values.  Not
only does this cut the size of the exception table in half, it is also a
prerequisite for KASLR, since absolute exception table entries are subject
to dynamic relocation, which is incompatible with the sorting of the
exception table that occurs at build time.

This patch also introduces the _ASM_EXTABLE preprocessor macro (which
exists on x86 as well) and its _asm_extable assembly counterpart, as
shorthands to emit exception table entries.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/assembler.h      |   15 ++++++++---
 arch/arm64/include/asm/futex.h          |   12 ++------
 arch/arm64/include/asm/uaccess.h        |   30 +++++++++++-----------
 arch/arm64/include/asm/word-at-a-time.h |    7 ++---
 arch/arm64/kernel/armv8_deprecated.c    |    7 +----
 arch/arm64/mm/extable.c                 |    2 -
 scripts/sortextable.c                   |    2 -
 7 files changed, 38 insertions(+), 37 deletions(-)

diff -puN arch/arm64/include/asm/assembler.h~arm64-switch-to-relative-exception-tables arch/arm64/include/asm/assembler.h
--- a/arch/arm64/include/asm/assembler.h~arm64-switch-to-relative-exception-tables
+++ a/arch/arm64/include/asm/assembler.h
@@ -94,12 +94,19 @@
 	dmb	\opt
 	.endm
 
+/*
+ * Emit an entry into the exception table
+ */
+	.macro		_asm_extable, from, to
+	.pushsection	__ex_table, "a"
+	.align		3
+	.long		(\from - .), (\to - .)
+	.popsection
+	.endm
+
 #define USER(l, x...)				\
 9999:	x;					\
-	.section __ex_table,"a";		\
-	.align	3;				\
-	.quad	9999b,l;			\
-	.previous
+	_asm_extable	9999b, l
 
 /*
  * Register aliases.
diff -puN arch/arm64/include/asm/futex.h~arm64-switch-to-relative-exception-tables arch/arm64/include/asm/futex.h
--- a/arch/arm64/include/asm/futex.h~arm64-switch-to-relative-exception-tables
+++ a/arch/arm64/include/asm/futex.h
@@ -42,10 +42,8 @@
 "4:	mov	%w0, %w5\n"						\
 "	b	3b\n"							\
 "	.popsection\n"							\
-"	.pushsection __ex_table,\"a\"\n"				\
-"	.align	3\n"							\
-"	.quad	1b, 4b, 2b, 4b\n"					\
-"	.popsection\n"							\
+	_ASM_EXTABLE(1b, 4b)						\
+	_ASM_EXTABLE(2b, 4b)						\
 	ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,		\
 		    CONFIG_ARM64_PAN)					\
 	: "=&r" (ret), "=&r" (oldval), "+Q" (*uaddr), "=&r" (tmp)	\
@@ -133,10 +131,8 @@ futex_atomic_cmpxchg_inatomic(u32 *uval,
 "4:	mov	%w0, %w6\n"
 "	b	3b\n"
 "	.popsection\n"
-"	.pushsection __ex_table,\"a\"\n"
-"	.align	3\n"
-"	.quad	1b, 4b, 2b, 4b\n"
-"	.popsection\n"
+	_ASM_EXTABLE(1b, 4b)
+	_ASM_EXTABLE(2b, 4b)
 	: "+r" (ret), "=&r" (val), "+Q" (*uaddr), "=&r" (tmp)
 	: "r" (oldval), "r" (newval), "Ir" (-EFAULT)
 	: "memory");
diff -puN arch/arm64/include/asm/uaccess.h~arm64-switch-to-relative-exception-tables arch/arm64/include/asm/uaccess.h
--- a/arch/arm64/include/asm/uaccess.h~arm64-switch-to-relative-exception-tables
+++ a/arch/arm64/include/asm/uaccess.h
@@ -36,11 +36,11 @@
 #define VERIFY_WRITE 1
 
 /*
- * The exception table consists of pairs of addresses: the first is the
- * address of an instruction that is allowed to fault, and the second is
- * the address at which the program should continue.  No registers are
- * modified, so it is entirely up to the continuation code to figure out
- * what to do.
+ * The exception table consists of pairs of relative offsets: the first
+ * is the relative offset to an instruction that is allowed to fault,
+ * and the second is the relative offset at which the program should
+ * continue. No registers are modified, so it is entirely up to the
+ * continuation code to figure out what to do.
  *
  * All the routines below use bits of fixup code that are out of line
  * with the main instruction path.  This means when everything is well,
@@ -50,9 +50,11 @@
 
 struct exception_table_entry
 {
-	unsigned long insn, fixup;
+	int insn, fixup;
 };
 
+#define ARCH_HAS_RELATIVE_EXTABLE
+
 extern int fixup_exception(struct pt_regs *regs);
 
 #define KERNEL_DS	(-1UL)
@@ -105,6 +107,12 @@ static inline void set_fs(mm_segment_t f
 #define access_ok(type, addr, size)	__range_ok(addr, size)
 #define user_addr_max			get_fs
 
+#define _ASM_EXTABLE(from, to)						\
+	"	.pushsection	__ex_table, \"a\"\n"			\
+	"	.align		3\n"					\
+	"	.long		(" #from " - .), (" #to " - .)\n"	\
+	"	.popsection\n"
+
 /*
  * The "__xxx" versions of the user access functions do not verify the address
  * space - it must have been done previously with a separate "access_ok()"
@@ -123,10 +131,7 @@ static inline void set_fs(mm_segment_t f
 	"	mov	%1, #0\n"					\
 	"	b	2b\n"						\
 	"	.previous\n"						\
-	"	.section __ex_table,\"a\"\n"				\
-	"	.align	3\n"						\
-	"	.quad	1b, 3b\n"					\
-	"	.previous"						\
+	_ASM_EXTABLE(1b, 3b)						\
 	: "+r" (err), "=&r" (x)						\
 	: "r" (addr), "i" (-EFAULT))
 
@@ -190,10 +195,7 @@ do {									\
 	"3:	mov	%w0, %3\n"					\
 	"	b	2b\n"						\
 	"	.previous\n"						\
-	"	.section __ex_table,\"a\"\n"				\
-	"	.align	3\n"						\
-	"	.quad	1b, 3b\n"					\
-	"	.previous"						\
+	_ASM_EXTABLE(1b, 3b)						\
 	: "+r" (err)							\
 	: "r" (x), "r" (addr), "i" (-EFAULT))
 
diff -puN arch/arm64/include/asm/word-at-a-time.h~arm64-switch-to-relative-exception-tables arch/arm64/include/asm/word-at-a-time.h
--- a/arch/arm64/include/asm/word-at-a-time.h~arm64-switch-to-relative-exception-tables
+++ a/arch/arm64/include/asm/word-at-a-time.h
@@ -16,6 +16,8 @@
 #ifndef __ASM_WORD_AT_A_TIME_H
 #define __ASM_WORD_AT_A_TIME_H
 
+#include <asm/uaccess.h>
+
 #ifndef __AARCH64EB__
 
 #include <linux/kernel.h>
@@ -81,10 +83,7 @@ static inline unsigned long load_unalign
 #endif
 	"	b	2b\n"
 	"	.popsection\n"
-	"	.pushsection __ex_table,\"a\"\n"
-	"	.align	3\n"
-	"	.quad	1b, 3b\n"
-	"	.popsection"
+	_ASM_EXTABLE(1b, 3b)
 	: "=&r" (ret), "=&r" (offset)
 	: "r" (addr), "Q" (*(unsigned long *)addr));
 
diff -puN arch/arm64/kernel/armv8_deprecated.c~arm64-switch-to-relative-exception-tables arch/arm64/kernel/armv8_deprecated.c
--- a/arch/arm64/kernel/armv8_deprecated.c~arm64-switch-to-relative-exception-tables
+++ a/arch/arm64/kernel/armv8_deprecated.c
@@ -297,11 +297,8 @@ static void __init register_insn_emulati
 	"4:	mov		%w0, %w5\n"			\
 	"	b		3b\n"				\
 	"	.popsection"					\
-	"	.pushsection	 __ex_table,\"a\"\n"		\
-	"	.align		3\n"				\
-	"	.quad		0b, 4b\n"			\
-	"	.quad		1b, 4b\n"			\
-	"	.popsection\n"					\
+	_ASM_EXTABLE(0b, 4b)					\
+	_ASM_EXTABLE(1b, 4b)					\
 	ALTERNATIVE("nop", SET_PSTATE_PAN(1), ARM64_HAS_PAN,	\
 		CONFIG_ARM64_PAN)				\
 	: "=&r" (res), "+r" (data), "=&r" (temp)		\
diff -puN arch/arm64/mm/extable.c~arm64-switch-to-relative-exception-tables arch/arm64/mm/extable.c
--- a/arch/arm64/mm/extable.c~arm64-switch-to-relative-exception-tables
+++ a/arch/arm64/mm/extable.c
@@ -11,7 +11,7 @@ int fixup_exception(struct pt_regs *regs
 
 	fixup = search_exception_tables(instruction_pointer(regs));
 	if (fixup)
-		regs->pc = fixup->fixup;
+		regs->pc = (unsigned long)&fixup->fixup + fixup->fixup;
 
 	return fixup != NULL;
 }
diff -puN scripts/sortextable.c~arm64-switch-to-relative-exception-tables scripts/sortextable.c
--- a/scripts/sortextable.c~arm64-switch-to-relative-exception-tables
+++ a/scripts/sortextable.c
@@ -282,12 +282,12 @@ do_file(char const *const fname)
 	case EM_386:
 	case EM_X86_64:
 	case EM_S390:
+	case EM_AARCH64:
 		custom_sort = sort_relative_table;
 		break;
 	case EM_ARCOMPACT:
 	case EM_ARCV2:
 	case EM_ARM:
-	case EM_AARCH64:
 	case EM_MICROBLAZE:
 	case EM_MIPS:
 	case EM_XTENSA:
_

Patches currently in -mm which might be from ard.biesheuvel@linaro.org are

extable-add-support-for-relative-extables-to-search-and-sort-routines.patch
alpha-extable-use-generic-search-and-sort-routines.patch
s390-extable-use-generic-search-and-sort-routines.patch
x86-extable-use-generic-search-and-sort-routines.patch
ia64-extable-use-generic-search-and-sort-routines.patch
arm64-switch-to-relative-exception-tables.patch
x86-kallsyms-disable-absolute-percpu-symbols-on-smp.patch
kallsyms-dont-overload-absolute-symbol-type-for-percpu-symbols.patch
kallsyms-add-support-for-relative-offsets-in-kallsyms-address-table.patch

