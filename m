From: akpm@linux-foundation.org
Subject: - i386-extend-alternative-instructions-framework.patch removed from -mm tree
Date: Thu, 26 Apr 2007 13:46:08 -0700
Message-ID: <200704262046.l3QKk87M011102@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031502AbXDZUqS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 16:46:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, ak@suse.de, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     i386: extend alternative instructions framework
has been removed from the -mm tree.  Its filename was
     i386-extend-alternative-instructions-framework.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: i386: extend alternative instructions framework
From: Joerg Roedel <joerg.roedel@amd.com>

This series of patches extend the alternative instructions framework on i386
and x86_64 architectures to support two alternative instruction replacements. 
This code is used together with the introduction of the X86_FEATURE_SYNC_RDTSC
flag on i386 to simplify and optimize the get_cycles_sync() function.  The
optimization changes this function to use RDTSCP instead of CPUID;RDTSC if
this instruction is available.  Don't use CPUID there is really important if
the kernel runs as a KVM guest, because this instruction is intercepted and
causes an expensive VMEXIT.


This patch extends the alternative instructions framework to support 2
alternative instructions.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |   21 +++++++++++-----
 include/asm-i386/alternative.h |   40 +++++++++++++++++++++++++++++--
 2 files changed, 53 insertions(+), 8 deletions(-)

diff -puN arch/i386/kernel/alternative.c~i386-extend-alternative-instructions-framework arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~i386-extend-alternative-instructions-framework
+++ a/arch/i386/kernel/alternative.c
@@ -162,14 +162,23 @@ extern u8 *__smp_locks[], *__smp_locks_e
 void apply_alternatives(struct alt_instr *start, struct alt_instr *end)
 {
 	struct alt_instr *a;
-	u8 *instr;
+	u8 *instr, *replacement;
+	u8 replacementlen;
 	int diff;
 
 	DPRINTK("%s: alt table %p -> %p\n", __FUNCTION__, start, end);
 	for (a = start; a < end; a++) {
-		BUG_ON(a->replacementlen > a->instrlen);
-		if (!boot_cpu_has(a->cpuid))
+		if (boot_cpu_has(a->cpuid)) {
+			replacement = a->replacement;
+			replacementlen = a->replacementlen;
+		} else if ((a->replacementlen2 > 0) &&
+			   (boot_cpu_has(a->cpuid2))) {
+			replacement = a->replacement2;
+			replacementlen = a->replacementlen2;
+		} else
 			continue;
+
+		BUG_ON(replacementlen > a->instrlen);
 		instr = a->instr;
 #ifdef CONFIG_X86_64
 		/* vsyscall code is not mapped yet. resolve it manually. */
@@ -179,9 +188,9 @@ void apply_alternatives(struct alt_instr
 				__FUNCTION__, a->instr, instr);
 		}
 #endif
-		memcpy(instr, a->replacement, a->replacementlen);
-		diff = a->instrlen - a->replacementlen;
-		nop_out(instr + a->replacementlen, diff);
+		memcpy(instr, replacement, replacementlen);
+		diff = a->instrlen - replacementlen;
+		nop_out(instr + replacementlen, diff);
 	}
 }
 
diff -puN include/asm-i386/alternative.h~i386-extend-alternative-instructions-framework include/asm-i386/alternative.h
--- a/include/asm-i386/alternative.h~i386-extend-alternative-instructions-framework
+++ a/include/asm-i386/alternative.h
@@ -8,11 +8,14 @@
 struct alt_instr {
 	u8 *instr; 		/* original instruction */
 	u8 *replacement;
+	u8 *replacement2;
 	u8  cpuid;		/* cpuid bit set for replacement */
+	u8  cpuid2;		/* cpuid bit set for replacement2 */
 	u8  instrlen;		/* length of original instruction */
 	u8  replacementlen; 	/* length of new instruction, <= instrlen */
-	u8  pad;
-};
+	u8  replacementlen2;
+	u8  pad[3];
+}  __attribute__ ((packed));
 
 extern void alternative_instructions(void);
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
@@ -33,6 +36,12 @@ static inline void alternatives_smp_swit
 #endif	/* CONFIG_SMP */
 
 /*
+ * use this macro(s) if you need more than one output parameter
+ * in alternative_io_*
+ */
+#define ASM_OUTPUT2(a, b) a, b
+
+/*
  * Alternative instructions for different CPU types or capabilities.
  *
  * This allows to use optimized instructions even on generic binary
@@ -50,9 +59,12 @@ static inline void alternatives_smp_swit
 		      "  .align 4\n"					\
 		      "  .long 661b\n"            /* label */		\
 		      "  .long 663f\n"		  /* new instruction */	\
+		      "  .long 0x00\n"					\
 		      "  .byte %c0\n"             /* feature bit */	\
+		      "  .byte 0x00\n"					\
 		      "  .byte 662b-661b\n"       /* sourcelen */	\
 		      "  .byte 664f-663f\n"       /* replacementlen */	\
+		      "  .byte 0x00\n"					\
 		      ".previous\n"					\
 		      ".section .altinstr_replacement,\"ax\"\n"		\
 		      "663:\n\t" newinstr "\n664:\n"   /* replacement */\
@@ -74,14 +86,38 @@ static inline void alternatives_smp_swit
 		      "  .align 4\n"					\
 		      "  .long 661b\n"            /* label */		\
 		      "  .long 663f\n"		  /* new instruction */ \
+		      "  .long 0x00\n"					\
 		      "  .byte %c0\n"             /* feature bit */	\
+		      "  .byte 0x00\n"					\
 		      "  .byte 662b-661b\n"       /* sourcelen */	\
 		      "  .byte 664f-663f\n"       /* replacementlen */ 	\
+		      "  .byte 0x00\n"					\
 		      ".previous\n"					\
 		      ".section .altinstr_replacement,\"ax\"\n"		\
 		      "663:\n\t" newinstr "\n664:\n"   /* replacement */\
 		      ".previous" :: "i" (feature), ##input)
 
+/* Like alternative_io, but supports 2 possible alternatives */
+#define alternative_io_two(oldinstr, newinstr, feat, newinstr2, feat2,\
+		output, input...) \
+	asm volatile ("661:\n\t" oldinstr "\n662:\n"                    \
+		      ".section .altinstructions,\"a\"\n"               \
+		      "  .align 4\n"                                    \
+		      "  .long 661b\n"            /* label */           \
+		      "  .long 663f\n"            /* new instruction */ \
+		      "  .long 665f\n"            /* new instruction 2 */\
+		      "  .byte %c[f]\n"        /* feature bit */        \
+		      "  .byte %c[f2]\n"          /* feature bit 2*/    \
+		      "  .byte 662b-661b\n"       /* sourcelen */       \
+		      "  .byte 664f-663f\n"       /* replacementlen */  \
+		      "  .byte 666f-665f\n"       /* replacementlen 2 */\
+		      ".previous\n"                                     \
+		      ".section .altinstr_replacement,\"ax\"\n"         \
+		      "663:\n\t" newinstr "\n664:\n"  /* replacement */ \
+		      "665:\n\t" newinstr2 "\n666:\n" /* replacement2 */ \
+		      ".previous" : output : [f] "i" (feat), \
+		      [f2] "i" (feat2),##input)
+
 /*
  * Alternative inline assembly for SMP.
  *
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

git-kvm.patch
i386-extend-alternative-instructions-framework.patch
x86_64-changes-to-x86_64-architecture-for.patch
