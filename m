From: akpm@linux-foundation.org
Subject: [merged]
 microblaze-mb-remove-use-of-seq_printf-return-value.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 09:55:20 -0700
Message-ID: <552fe978.4S/J4xViVhq29+b3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbDPQtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, monstr@monstr.eu, mm-commits@vger.kernel.org


The patch titled
     Subject: microblaze: mb: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     microblaze-mb-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
+		seq_puts(m, "Icache:\t\tno\n");
 
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

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
lib-vsprintfc-even-faster-decimal-conversion.patch
mm-utilc-add-kstrimdup.patch
checkpatch-improve-no-space-is-necessary-after-a-cast-test.patch
checkpatch-add-spell-checking-of-email-subject-line.patch
checkpatch-spell-check-reudce.patch
checkpatch-add-optional-codespell-dictionary-to-find-more-typos.patch
checkpatch-match-more-world-writable-permissions.patch
checkpatch-match-more-world-writable-permissions-fix.patch
checkpatch-improve-return-negative-errno-check.patch
checkpatch-add-test-for-repeated-const-uses.patch
checkpatch-dont-ask-for-asm-fileh-to-linux-fileh-unconditionally.patch
checkpatch-submittingpatches-suggest-line-wrapping-commit-messages-at-75-columns.patch
checkpatch-add-define-foo-string-long-line-exception.patch
checkpatch-add-uart_ops-to-normally-const-structs.patch
checkpatch-add-prefer-array_size-test.patch
checkpatch-improve-operator-spacing-check.patch
checkpatch-add-a-test-for-const-with-__read_mostly-uses.patch
checkpatchpl-new-instances-of-enosys-are-errors.patch
errnoh-improve-enosyss-comment.patch
checkpatch-fix-fix-use-with-a-patch-of-multiple-files.patch
checkpatch-avoid-spaces-required-around-that-false-positive.patch
rtc-use-more-standard-kernel-logging-styles.patch
adfs-returning-correct-return-values.patch
linux-next.patch
proc-show-locks-in-proc-pid-fdinfo-x.patch
proc-show-locks-in-proc-pid-fdinfo-x-v2.patch

