From: akpm@linux-foundation.org
Subject: + microblaze-mb-remove-use-of-seq_printf-return-value.patch added to -mm tree
Date: Mon, 23 Feb 2015 15:58:52 -0800
Message-ID: <54ebbebc.P+QgQHa14ARC9OSP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbbBWX6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:58:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: mb: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     microblaze-mb-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/microblaze-mb-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/microblaze-mb-remove-use-of-seq_printf-return-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: microblaze: mb: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/microblaze/kernel/cpu/mb.c |  153 ++++++++++++++----------------
 1 file changed, 75 insertions(+), 78 deletions(-)

diff -puN arch/microblaze/kernel/cpu/mb.c~microblaze-mb-remove-use-of-seq_printf-return-value arch/microblaze/kernel/cpu/mb.c
--- a/arch/microblaze/kernel/cpu/mb.c~microblaze-mb-remove-use-of-seq_printf-return-value
+++ a/arch/microblaze/kernel/cpu/mb.c
@@ -27,7 +27,6 @@
 
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
-	int count = 0;
 	char *fpga_family = "Unknown";
 	char *cpu_ver = "Unknown";
 	int i;
@@ -48,91 +47,89 @@ static int show_cpuinfo(struct seq_file
 		}
 	}
 
-	count = seq_printf(m,
-			"CPU-Family:	MicroBlaze\n"
-			"FPGA-Arch:	%s\n"
-			"CPU-Ver:	%s, %s endian\n"
-			"CPU-MHz:	%d.%02d\n"
-			"BogoMips:	%lu.%02lu\n",
-			fpga_family,
-			cpu_ver,
-			cpuinfo.endian ? "little" : "big",
-			cpuinfo.cpu_clock_freq /
-			1000000,
-			cpuinfo.cpu_clock_freq %
-			1000000,
-			loops_per_jiffy / (500000 / HZ),
-			(loops_per_jiffy / (5000 / HZ)) % 100);
-
-	count += seq_printf(m,
-		"HW:\n Shift:\t\t%s\n"
-		" MSR:\t\t%s\n"
-		" PCMP:\t\t%s\n"
-		" DIV:\t\t%s\n",
-		(cpuinfo.use_instr & PVR0_USE_BARREL_MASK) ? "yes" : "no",
-		(cpuinfo.use_instr & PVR2_USE_MSR_INSTR) ? "yes" : "no",
-		(cpuinfo.use_instr & PVR2_USE_PCMP_INSTR) ? "yes" : "no",
-		(cpuinfo.use_instr & PVR0_USE_DIV_MASK) ? "yes" : "no");
-
-	count += seq_printf(m,
-			" MMU:\t\t%x\n",
-			cpuinfo.mmu);
-
-	count += seq_printf(m,
-		" MUL:\t\t%s\n"
-		" FPU:\t\t%s\n",
-		(cpuinfo.use_mult & PVR2_USE_MUL64_MASK) ? "v2" :
-			(cpuinfo.use_mult & PVR0_USE_HW_MUL_MASK) ? "v1" : "no",
-		(cpuinfo.use_fpu & PVR2_USE_FPU2_MASK) ? "v2" :
-			(cpuinfo.use_fpu & PVR0_USE_FPU_MASK) ? "v1" : "no");
-
-	count += seq_printf(m,
-		" Exc:\t\t%s%s%s%s%s%s%s%s\n",
-		(cpuinfo.use_exc & PVR2_OPCODE_0x0_ILL_MASK) ? "op0x0 " : "",
-		(cpuinfo.use_exc & PVR2_UNALIGNED_EXC_MASK) ? "unal " : "",
-		(cpuinfo.use_exc & PVR2_ILL_OPCODE_EXC_MASK) ? "ill " : "",
-		(cpuinfo.use_exc & PVR2_IOPB_BUS_EXC_MASK) ? "iopb " : "",
-		(cpuinfo.use_exc & PVR2_DOPB_BUS_EXC_MASK) ? "dopb " : "",
-		(cpuinfo.use_exc & PVR2_DIV_ZERO_EXC_MASK) ? "zero " : "",
-		(cpuinfo.use_exc & PVR2_FPU_EXC_MASK) ? "fpu " : "",
-		(cpuinfo.use_exc & PVR2_USE_FSL_EXC) ? "fsl " : "");
-
-	count += seq_printf(m,
-			"Stream-insns:\t%sprivileged\n",
-			cpuinfo.mmu_privins ? "un" : "");
+	seq_printf(m,
+		   "CPU-Family:	MicroBlaze\n"
+		   "FPGA-Arch:	%s\n"
+		   "CPU-Ver:	%s, %s endian\n"
+		   "CPU-MHz:	%d.%02d\n"
+		   "BogoMips:	%lu.%02lu\n",
+		   fpga_family,
+		   cpu_ver,
+		   cpuinfo.endian ? "little" : "big",
+		   cpuinfo.cpu_clock_freq / 1000000,
+		   cpuinfo.cpu_clock_freq % 1000000,
+		   loops_per_jiffy / (500000 / HZ),
+		   (loops_per_jiffy / (5000 / HZ)) % 100);
+
+	seq_printf(m,
+		   "HW:\n Shift:\t\t%s\n"
+		   " MSR:\t\t%s\n"
+		   " PCMP:\t\t%s\n"
+		   " DIV:\t\t%s\n",
+		   (cpuinfo.use_instr & PVR0_USE_BARREL_MASK) ? "yes" : "no",
+		   (cpuinfo.use_instr & PVR2_USE_MSR_INSTR) ? "yes" : "no",
+		   (cpuinfo.use_instr & PVR2_USE_PCMP_INSTR) ? "yes" : "no",
+		   (cpuinfo.use_instr & PVR0_USE_DIV_MASK) ? "yes" : "no");
+
+	seq_printf(m, " MMU:\t\t%x\n", cpuinfo.mmu);
+
+	seq_printf(m,
+		   " MUL:\t\t%s\n"
+		   " FPU:\t\t%s\n",
+		   (cpuinfo.use_mult & PVR2_USE_MUL64_MASK) ? "v2" :
+		   (cpuinfo.use_mult & PVR0_USE_HW_MUL_MASK) ? "v1" : "no",
+		   (cpuinfo.use_fpu & PVR2_USE_FPU2_MASK) ? "v2" :
+		   (cpuinfo.use_fpu & PVR0_USE_FPU_MASK) ? "v1" : "no");
+
+	seq_printf(m,
+		   " Exc:\t\t%s%s%s%s%s%s%s%s\n",
+		   (cpuinfo.use_exc & PVR2_OPCODE_0x0_ILL_MASK) ? "op0x0 " : "",
+		   (cpuinfo.use_exc & PVR2_UNALIGNED_EXC_MASK) ? "unal " : "",
+		   (cpuinfo.use_exc & PVR2_ILL_OPCODE_EXC_MASK) ? "ill " : "",
+		   (cpuinfo.use_exc & PVR2_IOPB_BUS_EXC_MASK) ? "iopb " : "",
+		   (cpuinfo.use_exc & PVR2_DOPB_BUS_EXC_MASK) ? "dopb " : "",
+		   (cpuinfo.use_exc & PVR2_DIV_ZERO_EXC_MASK) ? "zero " : "",
+		   (cpuinfo.use_exc & PVR2_FPU_EXC_MASK) ? "fpu " : "",
+		   (cpuinfo.use_exc & PVR2_USE_FSL_EXC) ? "fsl " : "");
+
+	seq_printf(m,
+		   "Stream-insns:\t%sprivileged\n",
+		   cpuinfo.mmu_privins ? "un" : "");
 
 	if (cpuinfo.use_icache)
-		count += seq_printf(m,
-				"Icache:\t\t%ukB\tline length:\t%dB\n",
-				cpuinfo.icache_size >> 10,
-				cpuinfo.icache_line_length);
+		seq_printf(m,
+			   "Icache:\t\t%ukB\tline length:\t%dB\n",
+			   cpuinfo.icache_size >> 10,
+			   cpuinfo.icache_line_length);
 	else
-		count += seq_printf(m, "Icache:\t\tno\n");
+	x	seq_puts(m, "Icache:\t\tno\n");
 
 	if (cpuinfo.use_dcache) {
-		count += seq_printf(m,
-				"Dcache:\t\t%ukB\tline length:\t%dB\n",
-				cpuinfo.dcache_size >> 10,
-				cpuinfo.dcache_line_length);
-		seq_printf(m, "Dcache-Policy:\t");
+		seq_printf(m,
+			   "Dcache:\t\t%ukB\tline length:\t%dB\n",
+			   cpuinfo.dcache_size >> 10,
+			   cpuinfo.dcache_line_length);
+		seq_puts(m, "Dcache-Policy:\t");
 		if (cpuinfo.dcache_wb)
-			count += seq_printf(m, "write-back\n");
+			seq_puts(m, "write-back\n");
 		else
-			count += seq_printf(m, "write-through\n");
-	} else
-		count += seq_printf(m, "Dcache:\t\tno\n");
-
-	count += seq_printf(m,
-			"HW-Debug:\t%s\n",
-			cpuinfo.hw_debug ? "yes" : "no");
-
-	count += seq_printf(m,
-			"PVR-USR1:\t%02x\n"
-			"PVR-USR2:\t%08x\n",
-			cpuinfo.pvr_user1,
-			cpuinfo.pvr_user2);
+			seq_puts(m, "write-through\n");
+	} else {
+		seq_puts(m, "Dcache:\t\tno\n");
+	}
+
+	seq_printf(m,
+		   "HW-Debug:\t%s\n",
+		   cpuinfo.hw_debug ? "yes" : "no");
+
+	seq_printf(m,
+		   "PVR-USR1:\t%02x\n"
+		   "PVR-USR2:\t%08x\n",
+		   cpuinfo.pvr_user1,
+		   cpuinfo.pvr_user2);
+
+	seq_printf(m, "Page size:\t%lu\n", PAGE_SIZE);
 
-	count += seq_printf(m, "Page size:\t%lu\n", PAGE_SIZE);
 	return 0;
 }
 
_

Patches currently in -mm which might be from joe@perches.com are

staging-lustre-convert-return-seq_printf-uses.patch
staging-lustre-convert-seq_-hash-functions-to-return-void.patch
staging-lustre-convert-uses-of-int-rc-=-seq_printf.patch
staging-lustre-convert-remaining-uses-of-=-seq_printf.patch
x86-mtrr-if-remove-use-of-seq_printf-return-value.patch
power-wakeup-remove-use-of-seq_printf-return-value.patch
rtc-remove-use-of-seq_printf-return-value.patch
ipc-remove-use-of-seq_printf-return-value.patch
pxa27x_udc-remove-use-of-seq_printf-return-value.patch
microblaze-mb-remove-use-of-seq_printf-return-value.patch
nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
arm-plat-pxa-remove-use-of-seq_printf-return-value.patch
openrisc-remove-use-of-seq_printf-return-value.patch
cris-remove-use-of-seq_printf-return-value.patch
mfd-ab8500-debugfs-remove-use-of-seq_printf-return-value.patch
staging-i2o-remove-use-of-seq_printf-return-value.patch
staging-rtl8192x-remove-use-of-seq_printf-return-value.patch
s390-remove-use-of-seq_printf-return-value.patch
i8k-remove-use-of-seq_printf-return-value.patch
watchdog-bcm281xx-remove-use-of-seq_printf-return-value.patch
proc-remove-use-of-seq_printf-return-value.patch
cgroup-remove-use-of-seq_printf-return-value.patch
tracing-remove-use-of-seq_printf-return-value.patch
lru_cache-remove-use-of-seq_printf-return-value.patch
parisc-remove-use-of-seq_printf-return-value.patch
regulator-dbx500-remove-use-of-seq_puts-seq_printf-return-value.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
linux-next.patch

