From: akpm@linux-foundation.org
Subject: + x86-multi-byte-single-instruction-nops.patch added to -mm tree
Date: Sat, 15 Sep 2007 01:33:30 -0700
Message-ID: <200709150833.l8F8XUiE025483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXIOIdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 15 Sep 2007 04:33:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jbeulich@novell.com


The patch titled
     x86: multi-byte single instruction NOPs
has been added to the -mm tree.  Its filename is
     x86-multi-byte-single-instruction-nops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86: multi-byte single instruction NOPs
From: "Jan Beulich" <jbeulich@novell.com>

Add support for and use the multi-byte NOPs recently documented to be
available on all PentiumPro and later processors.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c |   23 ++++++++++++++++++++++-
 include/asm-i386/processor.h   |   22 ++++++++++++++++++++++
 include/asm-x86_64/processor.h |   22 ++++++++++++++++++++++
 3 files changed, 66 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/alternative.c~x86-multi-byte-single-instruction-nops arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~x86-multi-byte-single-instruction-nops
+++ a/arch/i386/kernel/alternative.c
@@ -115,12 +115,31 @@ static const unsigned char *const k7_nop
 };
 #endif
 
+#ifdef P6_NOP1
+asm("\t.section .rodata, \"a\"\np6nops: "
+	P6_NOP1 P6_NOP2 P6_NOP3 P6_NOP4 P6_NOP5 P6_NOP6
+	P6_NOP7 P6_NOP8);
+extern const unsigned char p6nops[];
+static const unsigned char *const p6_nops[ASM_NOP_MAX+1] = {
+	NULL,
+	p6nops,
+	p6nops + 1,
+	p6nops + 1 + 2,
+	p6nops + 1 + 2 + 3,
+	p6nops + 1 + 2 + 3 + 4,
+	p6nops + 1 + 2 + 3 + 4 + 5,
+	p6nops + 1 + 2 + 3 + 4 + 5 + 6,
+	p6nops + 1 + 2 + 3 + 4 + 5 + 6 + 7,
+};
+#endif
+
 #ifdef CONFIG_X86_64
 
 extern char __vsyscall_0;
 static inline const unsigned char*const * find_nop_table(void)
 {
-	return k8_nops;
+	return boot_cpu_data.x86_vendor != X86_VENDOR_INTEL ||
+	       boot_cpu_data.x86 < 6 ? k8_nops : p6_nops;
 }
 
 #else /* CONFIG_X86_64 */
@@ -131,6 +150,8 @@ static const struct nop {
 } noptypes[] = {
 	{ X86_FEATURE_K8, k8_nops },
 	{ X86_FEATURE_K7, k7_nops },
+	{ X86_FEATURE_P4, p6_nops },
+	{ X86_FEATURE_P3, p6_nops },
 	{ -1, NULL }
 };
 
diff -puN include/asm-i386/processor.h~x86-multi-byte-single-instruction-nops include/asm-i386/processor.h
--- a/include/asm-i386/processor.h~x86-multi-byte-single-instruction-nops
+++ a/include/asm-i386/processor.h
@@ -685,6 +685,17 @@ void ler_enable(void);
 #define K7_NOP7        ".byte 0x8D,0x04,0x05,0,0,0,0\n"
 #define K7_NOP8        K7_NOP7 ASM_NOP1
 
+/* P6 nops */
+/* uses eax dependencies (Intel-recommended choice) */
+#define P6_NOP1	GENERIC_NOP1
+#define P6_NOP2	".byte 0x66,0x90\n"
+#define P6_NOP3	".byte 0x0f,0x1f,0x00\n"
+#define P6_NOP4	".byte 0x0f,0x1f,0x40,0\n"
+#define P6_NOP5	".byte 0x0f,0x1f,0x44,0x00,0\n"
+#define P6_NOP6	".byte 0x66,0x0f,0x1f,0x44,0x00,0\n"
+#define P6_NOP7	".byte 0x0f,0x1f,0x80,0,0,0,0\n"
+#define P6_NOP8	".byte 0x0f,0x1f,0x84,0x00,0,0,0,0\n"
+
 #ifdef CONFIG_MK8
 #define ASM_NOP1 K8_NOP1
 #define ASM_NOP2 K8_NOP2
@@ -703,6 +714,17 @@ void ler_enable(void);
 #define ASM_NOP6 K7_NOP6
 #define ASM_NOP7 K7_NOP7
 #define ASM_NOP8 K7_NOP8
+#elif defined(CONFIG_M686) || defined(CONFIG_MPENTIUMII) || \
+      defined(CONFIG_MPENTIUMIII) || defined(CONFIG_MPENTIUMM) || \
+      defined(CONFIG_MCORE2) || defined(CONFIG_PENTIUM4)
+#define ASM_NOP1 P6_NOP1
+#define ASM_NOP2 P6_NOP2
+#define ASM_NOP3 P6_NOP3
+#define ASM_NOP4 P6_NOP4
+#define ASM_NOP5 P6_NOP5
+#define ASM_NOP6 P6_NOP6
+#define ASM_NOP7 P6_NOP7
+#define ASM_NOP8 P6_NOP8
 #else
 #define ASM_NOP1 GENERIC_NOP1
 #define ASM_NOP2 GENERIC_NOP2
diff -puN include/asm-x86_64/processor.h~x86-multi-byte-single-instruction-nops include/asm-x86_64/processor.h
--- a/include/asm-x86_64/processor.h~x86-multi-byte-single-instruction-nops
+++ a/include/asm-x86_64/processor.h
@@ -338,6 +338,16 @@ DECLARE_PER_CPU(u32, ler_msr);
 extern int ler_enabled;
 void ler_enable(void);
 
+#if defined(CONFIG_MPSC) || defined(CONFIG_MCORE2)
+#define ASM_NOP1 P6_NOP1
+#define ASM_NOP2 P6_NOP2
+#define ASM_NOP3 P6_NOP3
+#define ASM_NOP4 P6_NOP4
+#define ASM_NOP5 P6_NOP5
+#define ASM_NOP6 P6_NOP6
+#define ASM_NOP7 P6_NOP7
+#define ASM_NOP8 P6_NOP8
+#else
 #define ASM_NOP1 K8_NOP1
 #define ASM_NOP2 K8_NOP2
 #define ASM_NOP3 K8_NOP3
@@ -346,6 +356,7 @@ void ler_enable(void);
 #define ASM_NOP6 K8_NOP6
 #define ASM_NOP7 K8_NOP7
 #define ASM_NOP8 K8_NOP8
+#endif
 
 /* Opteron nops */
 #define K8_NOP1 ".byte 0x90\n"
@@ -357,6 +368,17 @@ void ler_enable(void);
 #define K8_NOP7	K8_NOP4 K8_NOP3
 #define K8_NOP8	K8_NOP4 K8_NOP4
 
+/* P6 nops */
+/* uses eax dependencies (Intel-recommended choice) */
+#define P6_NOP1	".byte 0x90\n"
+#define P6_NOP2	".byte 0x66,0x90\n"
+#define P6_NOP3	".byte 0x0f,0x1f,0x00\n"
+#define P6_NOP4	".byte 0x0f,0x1f,0x40,0\n"
+#define P6_NOP5	".byte 0x0f,0x1f,0x44,0x00,0\n"
+#define P6_NOP6	".byte 0x66,0x0f,0x1f,0x44,0x00,0\n"
+#define P6_NOP7	".byte 0x0f,0x1f,0x80,0,0,0,0\n"
+#define P6_NOP8	".byte 0x0f,0x1f,0x84,0x00,0,0,0,0\n"
+
 #define ASM_NOP_MAX 8
 
 /* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
_

Patches currently in -mm which might be from jbeulich@novell.com are

intel_cacheinfo-adjustmentspatch.patch
tristate-choices-with-mixed-tristate-and-boolean.patch
fix-x86_64-mm-unwinder.patch
x86-misc-constifications.patch
x86-constify-stacktrace_ops.patch
x86-constify-wd_ops.patch
x86-multi-byte-single-instruction-nops.patch
floppy-tolerate-dma-channel-unavailability.patch
cleanup-floppyh.patch
handle-recursive-calls-to-bust_spinlocks.patch
store-__setup_str_-in-a-more-compact-way.patch
constify-string-array-kparam-tracking-structures.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
