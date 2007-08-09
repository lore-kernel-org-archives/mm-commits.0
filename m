From: akpm@linux-foundation.org
Subject: + mips-detect-bcm947xx-cpus.patch added to -mm tree
Date: Thu, 09 Aug 2007 13:40:32 -0700
Message-ID: <200708092040.l79KeWBS018426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755427AbXHIUvp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:51:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aurelien@aurel32.net, jolt@tuxbox.org, mb@bu3sch.de, nbd@openwrt.org, ralf@linux-mips.org


The patch titled
     MIPS: Detect BCM947xx CPUs
has been added to the -mm tree.  Its filename is
     mips-detect-bcm947xx-cpus.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MIPS: Detect BCM947xx CPUs
From: Aurelien Jarno <aurelien@aurel32.net>

Add a few constants for BCM947xx CPUs and detect them in cpu-probe.c and
tlbex.c.  Note that the BCM4710 does not support the wait instruction, this is
not a mistake in the code.

This part is not dependent of other patches (though useless without them), and
could already be merged in the current linux-mips git tree.

Cc: Michael Buesch <mb@bu3sch.de>
Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Florian Schirmer <jolt@tuxbox.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/kernel/cpu-probe.c |   20 ++++++++++++++++++++
 arch/mips/kernel/proc.c      |    2 ++
 arch/mips/mm/tlbex.c         |    2 ++
 include/asm-mips/bootinfo.h  |    6 ++++++
 include/asm-mips/cpu.h       |   12 ++++++++++--
 5 files changed, 40 insertions(+), 2 deletions(-)

diff -puN arch/mips/kernel/cpu-probe.c~mips-detect-bcm947xx-cpus arch/mips/kernel/cpu-probe.c
--- a/arch/mips/kernel/cpu-probe.c~mips-detect-bcm947xx-cpus
+++ a/arch/mips/kernel/cpu-probe.c
@@ -159,6 +159,7 @@ static inline void check_wait(void)
 	case CPU_5KC:
 	case CPU_25KF:
 	case CPU_PR4450:
+	case CPU_BCM3302:
 		cpu_wait = r4k_wait;
 		break;
 
@@ -786,6 +787,22 @@ static inline void cpu_probe_philips(str
 }
 
 
+static inline void cpu_probe_broadcom(struct cpuinfo_mips *c)
+{
+	decode_configs(c);
+	switch (c->processor_id & 0xff00) {
+	case PRID_IMP_BCM3302:
+		c->cputype = CPU_BCM3302;
+		break;
+	case PRID_IMP_BCM4710:
+		c->cputype = CPU_BCM4710;
+		break;
+	default:
+		c->cputype = CPU_UNKNOWN;
+		break;
+	}
+}
+
 __init void cpu_probe(void)
 {
 	struct cpuinfo_mips *c = &current_cpu_data;
@@ -808,6 +825,9 @@ __init void cpu_probe(void)
 	case PRID_COMP_SIBYTE:
 		cpu_probe_sibyte(c);
 		break;
+	case PRID_COMP_BROADCOM:
+		cpu_probe_broadcom(c);
+		break;
 	case PRID_COMP_SANDCRAFT:
 		cpu_probe_sandcraft(c);
 		break;
diff -puN arch/mips/kernel/proc.c~mips-detect-bcm947xx-cpus arch/mips/kernel/proc.c
--- a/arch/mips/kernel/proc.c~mips-detect-bcm947xx-cpus
+++ a/arch/mips/kernel/proc.c
@@ -82,6 +82,8 @@ static const char *cpu_name[] = {
 	[CPU_VR4181]	= "NEC VR4181",
 	[CPU_VR4181A]	= "NEC VR4181A",
 	[CPU_SR71000]	= "Sandcraft SR71000",
+	[CPU_BCM3302]	= "Broadcom BCM3302",
+	[CPU_BCM4710]	= "Broadcom BCM4710",
 	[CPU_PR4450]	= "Philips PR4450",
 	[CPU_LOONGSON2]	= "ICT Loongson-2",
 };
diff -puN arch/mips/mm/tlbex.c~mips-detect-bcm947xx-cpus arch/mips/mm/tlbex.c
--- a/arch/mips/mm/tlbex.c~mips-detect-bcm947xx-cpus
+++ a/arch/mips/mm/tlbex.c
@@ -893,6 +893,8 @@ static __init void build_tlb_write_entry
 	case CPU_4KSC:
 	case CPU_20KC:
 	case CPU_25KF:
+	case CPU_BCM3302:
+	case CPU_BCM4710:
 	case CPU_LOONGSON2:
 		tlbw(p);
 		break;
diff -puN include/asm-mips/bootinfo.h~mips-detect-bcm947xx-cpus include/asm-mips/bootinfo.h
--- a/include/asm-mips/bootinfo.h~mips-detect-bcm947xx-cpus
+++ a/include/asm-mips/bootinfo.h
@@ -208,6 +208,12 @@
 #define MACH_GROUP_WINDRIVER   28	/* Windriver boards */
 #define MACH_WRPPMC             1
 
+/*
+ * Valid machtype for group Broadcom
+ */
+#define MACH_GROUP_BRCM		23	/* Broadcom			*/
+#define  MACH_BCM947XX		1	/* Broadcom BCM947xx		*/
+
 #define CL_SIZE			COMMAND_LINE_SIZE
 
 const char *get_system_type(void);
diff -puN include/asm-mips/cpu.h~mips-detect-bcm947xx-cpus include/asm-mips/cpu.h
--- a/include/asm-mips/cpu.h~mips-detect-bcm947xx-cpus
+++ a/include/asm-mips/cpu.h
@@ -106,6 +106,13 @@
 #define PRID_IMP_SR71000        0x0400
 
 /*
+ * These are the PRID's for when 23:16 == PRID_COMP_BROADCOM
+ */
+
+#define PRID_IMP_BCM4710	0x4000
+#define PRID_IMP_BCM3302	0x9000
+
+/*
  * Definitions for 7:0 on legacy processors
  */
 
@@ -217,8 +224,9 @@
 #define CPU_R14000		64
 #define CPU_LOONGSON1           65
 #define CPU_LOONGSON2           66
-
-#define CPU_LAST		66
+#define CPU_BCM3302		67
+#define CPU_BCM4710		68
+#define CPU_LAST		68
 
 /*
  * ISA Level encodings
_

Patches currently in -mm which might be from aurelien@aurel32.net are

git-kvm.patch
mips-detect-bcm947xx-cpus.patch
mips-bcm947xx-support.patch
rfc-add-bcm947xx-to-kconfig.patch
mips-add-bcm947xx-to-makefile.patch
git-wireless.patch
