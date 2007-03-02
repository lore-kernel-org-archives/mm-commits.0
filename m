From: akpm@linux-foundation.org
Subject: + x86_64-changes-to-x86_64-architecture-for.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:29:43 -0800
Message-ID: <200703022129.l22LThse019449@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41686 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965663AbXCBV3t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:29:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, ak@suse.de


The patch titled
     x86_64: changes to x86_64 architecture for alternative instruction improvements
has been added to the -mm tree.  Its filename is
     x86_64-changes-to-x86_64-architecture-for.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: changes to x86_64 architecture for alternative instruction improvements
From: Joerg Roedel <joerg.roedel@amd.com>

In this patch updates the x86_64 architecture to work with the changes to
alternative instructions in i386

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/lib/clear_page.S     |    3 ++
 arch/x86_64/lib/copy_page.S      |    3 ++
 arch/x86_64/lib/copy_user.S      |    3 ++
 arch/x86_64/lib/memcpy.S         |    3 ++
 arch/x86_64/lib/memset.S         |    3 ++
 include/asm-x86_64/alternative.h |   42 +++++++++++++++++++++++++++--
 6 files changed, 55 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/lib/clear_page.S~x86_64-changes-to-x86_64-architecture-for arch/x86_64/lib/clear_page.S
--- a/arch/x86_64/lib/clear_page.S~x86_64-changes-to-x86_64-architecture-for
+++ a/arch/x86_64/lib/clear_page.S
@@ -53,7 +53,10 @@ ENDPROC(clear_page)
 	.align 8
 	.quad clear_page
 	.quad 1b
+	.quad 0
 	.byte X86_FEATURE_REP_GOOD
+	.byte 0
 	.byte .Lclear_page_end - clear_page
 	.byte 2b - 1b
+	.byte 0
 	.previous
diff -puN arch/x86_64/lib/copy_page.S~x86_64-changes-to-x86_64-architecture-for arch/x86_64/lib/copy_page.S
--- a/arch/x86_64/lib/copy_page.S~x86_64-changes-to-x86_64-architecture-for
+++ a/arch/x86_64/lib/copy_page.S
@@ -113,7 +113,10 @@ ENDPROC(copy_page)
 	.align 8
 	.quad copy_page
 	.quad 1b
+	.quad 0
 	.byte X86_FEATURE_REP_GOOD
+	.byte 0
 	.byte .Lcopy_page_end - copy_page
 	.byte 2b - 1b
+	.byte 0
 	.previous
diff -puN arch/x86_64/lib/copy_user.S~x86_64-changes-to-x86_64-architecture-for arch/x86_64/lib/copy_user.S
--- a/arch/x86_64/lib/copy_user.S~x86_64-changes-to-x86_64-architecture-for
+++ a/arch/x86_64/lib/copy_user.S
@@ -27,9 +27,12 @@
 	.align 8
 	.quad  0b
 	.quad  2b
+	.quad  0
 	.byte  \feature		     /* when feature is set */
+	.byte  0
 	.byte  5
 	.byte  5
+	.byte  0
 	.previous
 	.endm
 
diff -puN arch/x86_64/lib/memcpy.S~x86_64-changes-to-x86_64-architecture-for arch/x86_64/lib/memcpy.S
--- a/arch/x86_64/lib/memcpy.S~x86_64-changes-to-x86_64-architecture-for
+++ a/arch/x86_64/lib/memcpy.S
@@ -123,7 +123,10 @@ ENDPROC(__memcpy)
 	.align 8
 	.quad memcpy
 	.quad 1b
+	.quad 0
 	.byte X86_FEATURE_REP_GOOD
+	.byte 0
 	.byte .Lfinal - memcpy
 	.byte 2b - 1b
+	.byte 0
 	.previous
diff -puN arch/x86_64/lib/memset.S~x86_64-changes-to-x86_64-architecture-for arch/x86_64/lib/memset.S
--- a/arch/x86_64/lib/memset.S~x86_64-changes-to-x86_64-architecture-for
+++ a/arch/x86_64/lib/memset.S
@@ -127,7 +127,10 @@ ENDPROC(__memset)
 	.align 8
 	.quad memset
 	.quad 1b
+	.quad 0
 	.byte X86_FEATURE_REP_GOOD
+	.byte 0
 	.byte .Lfinal - memset
 	.byte 2b - 1b
+	.byte 0
 	.previous
diff -puN include/asm-x86_64/alternative.h~x86_64-changes-to-x86_64-architecture-for include/asm-x86_64/alternative.h
--- a/include/asm-x86_64/alternative.h~x86_64-changes-to-x86_64-architecture-for
+++ a/include/asm-x86_64/alternative.h
@@ -10,11 +10,14 @@
 struct alt_instr {
 	u8 *instr; 		/* original instruction */
 	u8 *replacement;
+	u8 *replacement2;
 	u8  cpuid;		/* cpuid bit set for replacement */
+	u8  cpuid2;		/* cpuid bit set for replacement2 */
 	u8  instrlen;		/* length of original instruction */
 	u8  replacementlen; 	/* length of new instruction, <= instrlen */
-	u8  pad[5];
-};
+	u8  replacementlen2;
+	u8  pad[3];
+} __attribute__ ((packed));
 
 extern void apply_alternatives(struct alt_instr *start, struct alt_instr *end);
 
@@ -37,6 +40,12 @@ static inline void alternatives_smp_swit
 #endif
 
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
@@ -54,9 +63,12 @@ static inline void alternatives_smp_swit
 		      "  .align 8\n"				       \
 		      "  .quad 661b\n"            /* label */          \
 		      "  .quad 663f\n"		  /* new instruction */ \
+		      "  .quad 0x00\n"					\
 		      "  .byte %c0\n"             /* feature bit */    \
+		      "  .byte 0x00\n"					\
 		      "  .byte 662b-661b\n"       /* sourcelen */      \
 		      "  .byte 664f-663f\n"       /* replacementlen */ \
+		      "  .byte 0x00\n"					\
 		      ".previous\n"					\
 		      ".section .altinstr_replacement,\"ax\"\n"		\
 		      "663:\n\t" newinstr "\n664:\n"   /* replacement */ \
@@ -78,9 +90,12 @@ static inline void alternatives_smp_swit
 		      "  .align 8\n"					\
 		      "  .quad 661b\n"            /* label */		\
 		      "  .quad 663f\n"		  /* new instruction */	\
+		      "  .quad 0x00\n"					\
 		      "  .byte %c0\n"             /* feature bit */	\
+		      "  .byte 0x00\n"					\
 		      "  .byte 662b-661b\n"       /* sourcelen */	\
 		      "  .byte 664f-663f\n"       /* replacementlen */	\
+		      "  .byte 0x00\n"					\
 		      ".previous\n"					\
 		      ".section .altinstr_replacement,\"ax\"\n"		\
 		      "663:\n\t" newinstr "\n664:\n"   /* replacement */ \
@@ -93,14 +108,37 @@ static inline void alternatives_smp_swit
 		      "  .align 8\n"					\
 		      "  .quad 661b\n"            /* label */		\
 		      "  .quad 663f\n"		  /* new instruction */	\
+		      "  .quad 0x00\n"					\
 		      "  .byte %c[feat]\n"        /* feature bit */	\
+		      "  .byte 0x00\n"					\
 		      "  .byte 662b-661b\n"       /* sourcelen */	\
 		      "  .byte 664f-663f\n"       /* replacementlen */	\
+		      "  .byte 0x00\n"					\
 		      ".previous\n"					\
 		      ".section .altinstr_replacement,\"ax\"\n"		\
 		      "663:\n\t" newinstr "\n664:\n"   /* replacement */ \
 		      ".previous" : output : [feat] "i" (feature), ##input)
 
+/* Like alternative_io, but supports 2 possible alternatives */
+#define alternative_io_two(oldinstr, newinstr, feat, newinstr2, feat2,\
+		output, input...) \
+	asm volatile ("661:\n\t" oldinstr "\n662:\n"			\
+		      ".section .altinstructions,\"a\"\n"		\
+		      "  .align 8\n"					\
+		      "  .quad 661b\n"            /* label */		\
+		      "  .quad 663f\n"		  /* new instruction */	\
+		      "  .quad 665f\n"		  /* new instruction 2 */\
+		      "  .byte %c[f]\n"        /* feature bit */	\
+		      "  .byte %c[f2]\n"	  /* feature bit 2*/	\
+		      "  .byte 662b-661b\n"       /* sourcelen */	\
+		      "  .byte 664f-663f\n"       /* replacementlen */	\
+		      "  .byte 666f-665f\n"	  /* replacementlen 2 */\
+		      ".previous\n"					\
+		      ".section .altinstr_replacement,\"ax\"\n"		\
+		      "663:\n\t" newinstr "\n664:\n"  /* replacement */ \
+		      "665:\n\t" newinstr2 "\n666:\n" /* replacement2 */ \
+		      ".previous" : output : [f] "i" (feat), \
+			[f2] "i" (feat2),##input)
 /*
  * Alternative inline assembly for SMP.
  *
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

git-kvm.patch
remove-constant_tsc-reporting-from-proc-cpuinfo-power.patch
i386-extend-alternative-instructions-framework.patch
x86_64-changes-to-x86_64-architecture-for.patch
i386-add-the-x86_feature_sync_rdtsc-flag.patch
optimize-and-simplify-get_cycles_sync.patch
