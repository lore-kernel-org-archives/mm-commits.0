From: akpm@linux-foundation.org
Subject: - x86-misc-constifications.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:17:20 -0700
Message-ID: <200709202117.l8KLHKaI003072@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752089AbXITV21 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:28:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, mm-commits@vger.kernel.org


The patch titled
     x86: misc. constifications
has been removed from the -mm tree.  Its filename was
     x86-misc-constifications.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86: misc. constifications
From: "Jan Beulich" <jbeulich@novell.com>

Miscellaneous x86 stuff that can live in .rodata.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/alternative.c       |   30 ++++++++++++-------------
 arch/i386/kernel/smpboot.c           |    4 +--
 arch/i386/kernel/trampoline.S        |    4 +--
 arch/i386/mach-voyager/voyager_smp.c |    4 +--
 arch/x86_64/kernel/setup.c           |    4 +--
 arch/x86_64/kernel/smpboot.c         |    4 +--
 arch/x86_64/kernel/trampoline.S      |    7 +++++
 7 files changed, 31 insertions(+), 26 deletions(-)

diff -puN arch/i386/kernel/alternative.c~x86-misc-constifications arch/i386/kernel/alternative.c
--- a/arch/i386/kernel/alternative.c~x86-misc-constifications
+++ a/arch/i386/kernel/alternative.c
@@ -62,11 +62,11 @@ __setup("noreplace-paravirt", setup_nore
 /* Use inline assembly to define this because the nops are defined
    as inline assembly strings in the include files and we cannot
    get them easily into strings. */
-asm("\t.data\nintelnops: "
+asm("\t.section .rodata, \"a\"\nintelnops: "
 	GENERIC_NOP1 GENERIC_NOP2 GENERIC_NOP3 GENERIC_NOP4 GENERIC_NOP5 GENERIC_NOP6
 	GENERIC_NOP7 GENERIC_NOP8);
-extern unsigned char intelnops[];
-static unsigned char *intel_nops[ASM_NOP_MAX+1] = {
+extern const unsigned char intelnops[];
+static const unsigned char *const intel_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	intelnops,
 	intelnops + 1,
@@ -80,11 +80,11 @@ static unsigned char *intel_nops[ASM_NOP
 #endif
 
 #ifdef K8_NOP1
-asm("\t.data\nk8nops: "
+asm("\t.section .rodata, \"a\"\nk8nops: "
 	K8_NOP1 K8_NOP2 K8_NOP3 K8_NOP4 K8_NOP5 K8_NOP6
 	K8_NOP7 K8_NOP8);
-extern unsigned char k8nops[];
-static unsigned char *k8_nops[ASM_NOP_MAX+1] = {
+extern const unsigned char k8nops[];
+static const unsigned char *const k8_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	k8nops,
 	k8nops + 1,
@@ -98,11 +98,11 @@ static unsigned char *k8_nops[ASM_NOP_MA
 #endif
 
 #ifdef K7_NOP1
-asm("\t.data\nk7nops: "
+asm("\t.section .rodata, \"a\"\nk7nops: "
 	K7_NOP1 K7_NOP2 K7_NOP3 K7_NOP4 K7_NOP5 K7_NOP6
 	K7_NOP7 K7_NOP8);
-extern unsigned char k7nops[];
-static unsigned char *k7_nops[ASM_NOP_MAX+1] = {
+extern const unsigned char k7nops[];
+static const unsigned char *const k7_nops[ASM_NOP_MAX+1] = {
 	NULL,
 	k7nops,
 	k7nops + 1,
@@ -118,25 +118,25 @@ static unsigned char *k7_nops[ASM_NOP_MA
 #ifdef CONFIG_X86_64
 
 extern char __vsyscall_0;
-static inline unsigned char** find_nop_table(void)
+static inline const unsigned char*const * find_nop_table(void)
 {
 	return k8_nops;
 }
 
 #else /* CONFIG_X86_64 */
 
-static struct nop {
+static const struct nop {
 	int cpuid;
-	unsigned char **noptable;
+	const unsigned char *const *noptable;
 } noptypes[] = {
 	{ X86_FEATURE_K8, k8_nops },
 	{ X86_FEATURE_K7, k7_nops },
 	{ -1, NULL }
 };
 
-static unsigned char** find_nop_table(void)
+static const unsigned char*const * find_nop_table(void)
 {
-	unsigned char **noptable = intel_nops;
+	const unsigned char *const *noptable = intel_nops;
 	int i;
 
 	for (i = 0; noptypes[i].cpuid >= 0; i++) {
@@ -153,7 +153,7 @@ static unsigned char** find_nop_table(vo
 /* Use this to add nops to a buffer, then text_poke the whole buffer. */
 static void add_nops(void *insns, unsigned int len)
 {
-	unsigned char **noptable = find_nop_table();
+	const unsigned char *const *noptable = find_nop_table();
 
 	while (len > 0) {
 		unsigned int noplen = len;
diff -puN arch/i386/kernel/smpboot.c~x86-misc-constifications arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~x86-misc-constifications
+++ a/arch/i386/kernel/smpboot.c
@@ -110,8 +110,8 @@ u8 apicid_2_node[MAX_APICID];
  * Trampoline 80x86 program as an array.
  */
 
-extern unsigned char trampoline_data [];
-extern unsigned char trampoline_end  [];
+extern const unsigned char trampoline_data [];
+extern const unsigned char trampoline_end  [];
 static unsigned char *trampoline_base;
 static int trampoline_exec;
 
diff -puN arch/i386/kernel/trampoline.S~x86-misc-constifications arch/i386/kernel/trampoline.S
--- a/arch/i386/kernel/trampoline.S~x86-misc-constifications
+++ a/arch/i386/kernel/trampoline.S
@@ -36,11 +36,11 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 
-.data
-
 /* We can free up trampoline after bootup if cpu hotplug is not supported. */
 #ifndef CONFIG_HOTPLUG_CPU
 .section ".init.data","aw",@progbits
+#else
+.section .rodata,"a",@progbits
 #endif
 
 .code16
diff -puN arch/i386/mach-voyager/voyager_smp.c~x86-misc-constifications arch/i386/mach-voyager/voyager_smp.c
--- a/arch/i386/mach-voyager/voyager_smp.c~x86-misc-constifications
+++ a/arch/i386/mach-voyager/voyager_smp.c
@@ -442,8 +442,8 @@ static __u32 __init
 setup_trampoline(void)
 {
 	/* these two are global symbols in trampoline.S */
-	extern __u8 trampoline_end[];
-	extern __u8 trampoline_data[];
+	extern const __u8 trampoline_end[];
+	extern const __u8 trampoline_data[];
 
 	memcpy((__u8 *)trampoline_base, trampoline_data,
 	       trampoline_end - trampoline_data);
diff -puN arch/x86_64/kernel/setup.c~x86-misc-constifications arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~x86-misc-constifications
+++ a/arch/x86_64/kernel/setup.c
@@ -1028,7 +1028,7 @@ static int show_cpuinfo(struct seq_file 
 	 * applications want to get the raw CPUID data, they should access
 	 * /dev/cpu/<cpu_nr>/cpuid instead.
 	 */
-	static char *x86_cap_flags[] = {
+	static const char *const x86_cap_flags[] = {
 		/* Intel-defined */
 	        "fpu", "vme", "de", "pse", "tsc", "msr", "pae", "mce",
 	        "cx8", "apic", NULL, "sep", "mtrr", "pge", "mca", "cmov",
@@ -1082,7 +1082,7 @@ static int show_cpuinfo(struct seq_file 
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
 	};
-	static char *x86_power_flags[] = { 
+	static const char *const x86_power_flags[] = {
 		"ts",	/* temperature sensor */
 		"fid",  /* frequency id control */
 		"vid",  /* voltage id control */
diff -puN arch/x86_64/kernel/smpboot.c~x86-misc-constifications arch/x86_64/kernel/smpboot.c
--- a/arch/x86_64/kernel/smpboot.c~x86-misc-constifications
+++ a/arch/x86_64/kernel/smpboot.c
@@ -102,8 +102,8 @@ EXPORT_PER_CPU_SYMBOL(cpu_core_map);
  * Trampoline 80x86 program as an array.
  */
 
-extern unsigned char trampoline_data[];
-extern unsigned char trampoline_end[];
+extern const unsigned char trampoline_data[];
+extern const unsigned char trampoline_end[];
 
 /* State of each CPU */
 DEFINE_PER_CPU(int, cpu_state) = { 0 };
diff -puN arch/x86_64/kernel/trampoline.S~x86-misc-constifications arch/x86_64/kernel/trampoline.S
--- a/arch/x86_64/kernel/trampoline.S~x86-misc-constifications
+++ a/arch/x86_64/kernel/trampoline.S
@@ -33,7 +33,12 @@
 #include <asm/msr.h>
 #include <asm/segment.h>
 
-.data
+/* We can free up trampoline after bootup if cpu hotplug is not supported. */
+#ifndef CONFIG_HOTPLUG_CPU
+.section .init.data, "aw", @progbits
+#else
+.section .rodata, "a", @progbits
+#endif
 
 .code16
 
_

Patches currently in -mm which might be from jbeulich@novell.com are

tristate-choices-with-mixed-tristate-and-boolean.patch
fix-x86_64-mm-unwinder.patch
floppy-tolerate-dma-channel-unavailability.patch
cleanup-floppyh.patch
handle-recursive-calls-to-bust_spinlocks.patch
store-__setup_str_-in-a-more-compact-way.patch
constify-string-array-kparam-tracking-structures.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
pnp-dont-fail-device-init-if-no-dma-channel.patch
