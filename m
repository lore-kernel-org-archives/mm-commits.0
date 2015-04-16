From: akpm@linux-foundation.org
Subject: [merged]
 nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch removed from -mm
 tree
Date: Thu, 16 Apr 2015 09:55:22 -0700
Message-ID: <552fe97a.2oV5yjzGyyms/Yqd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43181 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbbDPQtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, lftan@altera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nios2: cpuinfo: remove use of seq_printf return value
has been removed from the -mm tree.  Its filename was
     nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: nios2: cpuinfo: remove use of seq_printf return value

The seq_printf return value, because it's frequently misused,
will eventually be converted to void.

See: commit 1f33c41c03da ("seq_file: Rename seq_overflow() to
     seq_has_overflowed() and make public")

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ley Foon Tan <lftan@altera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/kernel/cpuinfo.c |   77 ++++++++++++++++------------------
 1 file changed, 38 insertions(+), 39 deletions(-)

diff -puN arch/nios2/kernel/cpuinfo.c~nios2-cpuinfo-remove-use-of-seq_printf-return-value arch/nios2/kernel/cpuinfo.c
--- a/arch/nios2/kernel/cpuinfo.c~nios2-cpuinfo-remove-use-of-seq_printf-return-value
+++ a/arch/nios2/kernel/cpuinfo.c
@@ -126,47 +126,46 @@ void __init setup_cpuinfo(void)
  */
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
-	int count = 0;
 	const u32 clockfreq = cpuinfo.cpu_clock_freq;
 
-	count = seq_printf(m,
-			"CPU:\t\tNios II/%s\n"
-			"MMU:\t\t%s\n"
-			"FPU:\t\tnone\n"
-			"Clocking:\t%u.%02u MHz\n"
-			"BogoMips:\t%lu.%02lu\n"
-			"Calibration:\t%lu loops\n",
-			cpuinfo.cpu_impl,
-			cpuinfo.mmu ? "present" : "none",
-			clockfreq / 1000000, (clockfreq / 100000) % 10,
-			(loops_per_jiffy * HZ) / 500000,
-			((loops_per_jiffy * HZ) / 5000) % 100,
-			(loops_per_jiffy * HZ));
-
-	count += seq_printf(m,
-			"HW:\n"
-			" MUL:\t\t%s\n"
-			" MULX:\t\t%s\n"
-			" DIV:\t\t%s\n",
-			cpuinfo.has_mul ? "yes" : "no",
-			cpuinfo.has_mulx ? "yes" : "no",
-			cpuinfo.has_div ? "yes" : "no");
-
-	count += seq_printf(m,
-			"Icache:\t\t%ukB, line length: %u\n",
-			cpuinfo.icache_size >> 10,
-			cpuinfo.icache_line_size);
-
-	count += seq_printf(m,
-			"Dcache:\t\t%ukB, line length: %u\n",
-			cpuinfo.dcache_size >> 10,
-			cpuinfo.dcache_line_size);
-
-	count += seq_printf(m,
-			"TLB:\t\t%u ways, %u entries, %u PID bits\n",
-			cpuinfo.tlb_num_ways,
-			cpuinfo.tlb_num_entries,
-			cpuinfo.tlb_pid_num_bits);
+	seq_printf(m,
+		   "CPU:\t\tNios II/%s\n"
+		   "MMU:\t\t%s\n"
+		   "FPU:\t\tnone\n"
+		   "Clocking:\t%u.%02u MHz\n"
+		   "BogoMips:\t%lu.%02lu\n"
+		   "Calibration:\t%lu loops\n",
+		   cpuinfo.cpu_impl,
+		   cpuinfo.mmu ? "present" : "none",
+		   clockfreq / 1000000, (clockfreq / 100000) % 10,
+		   (loops_per_jiffy * HZ) / 500000,
+		   ((loops_per_jiffy * HZ) / 5000) % 100,
+		   (loops_per_jiffy * HZ));
+
+	seq_printf(m,
+		   "HW:\n"
+		   " MUL:\t\t%s\n"
+		   " MULX:\t\t%s\n"
+		   " DIV:\t\t%s\n",
+		   cpuinfo.has_mul ? "yes" : "no",
+		   cpuinfo.has_mulx ? "yes" : "no",
+		   cpuinfo.has_div ? "yes" : "no");
+
+	seq_printf(m,
+		   "Icache:\t\t%ukB, line length: %u\n",
+		   cpuinfo.icache_size >> 10,
+		   cpuinfo.icache_line_size);
+
+	seq_printf(m,
+		   "Dcache:\t\t%ukB, line length: %u\n",
+		   cpuinfo.dcache_size >> 10,
+		   cpuinfo.dcache_line_size);
+
+	seq_printf(m,
+		   "TLB:\t\t%u ways, %u entries, %u PID bits\n",
+		   cpuinfo.tlb_num_ways,
+		   cpuinfo.tlb_num_entries,
+		   cpuinfo.tlb_pid_num_bits);
 
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

