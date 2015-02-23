From: akpm@linux-foundation.org
Subject: + nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch added to -mm tree
Date: Mon, 23 Feb 2015 15:58:54 -0800
Message-ID: <54ebbebe.o+QkgoedIvLrI75Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbbBWX6z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 18:58:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, lftan@altera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: nios2: cpuinfo: remove use of seq_printf return value
has been added to the -mm tree.  Its filename is
     nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nios2-cpuinfo-remove-use-of-seq_printf-return-value.patch

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

