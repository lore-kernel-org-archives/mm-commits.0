From: akpm@linux-foundation.org
Subject: + cell-cbe_cpufreq-fix-latency-measurement.patch added to -mm tree
Date: Wed, 18 Jul 2007 12:51:52 -0700
Message-ID: <200707181951.l6IJpqic025901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56471 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599AbXGRTwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 15:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krafft@de.ibm.com, arnd.bergmann@de.ibm.com


The patch titled
     cell: cbe_cpufreq: fix latency measurement
has been added to the -mm tree.  Its filename is
     cell-cbe_cpufreq-fix-latency-measurement.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cell: cbe_cpufreq: fix latency measurement
From: Christian Krafft <krafft@de.ibm.com>

This patch fixes the debug code that calculates the transition time when
changing the slow modes on a Cell BE cpu.

Signed-off-by: Christian Krafft <krafft@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/cell/cbe_cpufreq.c |   25 +++++++++++++-------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff -puN arch/powerpc/platforms/cell/cbe_cpufreq.c~cell-cbe_cpufreq-fix-latency-measurement arch/powerpc/platforms/cell/cbe_cpufreq.c
--- a/arch/powerpc/platforms/cell/cbe_cpufreq.c~cell-cbe_cpufreq-fix-latency-measurement
+++ a/arch/powerpc/platforms/cell/cbe_cpufreq.c
@@ -81,7 +81,7 @@ static int set_pmode_pmi(int cpu, unsign
 	int ret;
 	pmi_message_t pmi_msg;
 #ifdef DEBUG
-	u64 time;
+	long time;
 #endif
 
 	pmi_msg.type = PMI_TYPE_FREQ_CHANGE;
@@ -89,7 +89,7 @@ static int set_pmode_pmi(int cpu, unsign
 	pmi_msg.data2 = pmode;
 
 #ifdef DEBUG
-	time = (u64) get_cycles();
+	time = jiffies;
 #endif
 
 	pmi_send_message(pmi_msg);
@@ -98,9 +98,9 @@ static int set_pmode_pmi(int cpu, unsign
 	pr_debug("PMI returned slow mode %d\n", ret);
 
 #ifdef DEBUG
-	time = (u64) get_cycles() - time; /* actual cycles (not cpu cycles!) */
-	time = 1000000000 * time / CLOCK_TICK_RATE; /* time in ns (10^-9) */
-	pr_debug("had to wait %lu ns for a transition\n", time);
+	time = jiffies - time; /* actual cycles (not cpu cycles!) */
+	time = jiffies_to_msecs(time);
+	pr_debug("had to wait %lu ms for a transition using PMI.\n", time);
 #endif
 	return ret;
 }
@@ -123,15 +123,18 @@ static int set_pmode_reg(int cpu, unsign
 	struct cbe_mic_tm_regs __iomem *mic_tm_regs;
 	u64 flags;
 	u64 value;
+#ifdef DEBUG
+	long time;
+#endif
 
 	local_irq_save(flags);
 
 	mic_tm_regs = cbe_get_cpu_mic_tm_regs(cpu);
 	pmd_regs = cbe_get_cpu_pmd_regs(cpu);
 
-	pr_debug("pm register is mapped at %p\n", &pmd_regs->pmcr);
-	pr_debug("mic register is mapped at %p\n", &mic_tm_regs->slow_fast_timer_0);
-
+#ifdef DEBUG
+	time = jiffies;
+#endif
 	out_be64(&mic_tm_regs->slow_fast_timer_0, MIC_Slow_Fast_Timer_table[pmode]);
 	out_be64(&mic_tm_regs->slow_fast_timer_1, MIC_Slow_Fast_Timer_table[pmode]);
 
@@ -146,6 +149,7 @@ static int set_pmode_reg(int cpu, unsign
 
 	out_be64(&pmd_regs->pmcr, value);
 
+#ifdef DEBUG
 	/* wait until new pmode appears in status register */
 	value = in_be64(&pmd_regs->pmsr) & 0x07;
 	while(value != pmode) {
@@ -153,6 +157,11 @@ static int set_pmode_reg(int cpu, unsign
 		value = in_be64(&pmd_regs->pmsr) & 0x07;
 	}
 
+	time = jiffies - time;
+	time = jiffies_to_msecs(time);
+	pr_debug("had to wait %lu ms for a transition using " \
+		 "the pervasive unit.\n", time);
+#endif
 	local_irq_restore(flags);
 
 	return 0;
_

Patches currently in -mm which might be from krafft@de.ibm.com are

cell-pmi-remove-support-for-mutiple-devices.patch
cell-cbe_cpufreq-fix-latency-measurement.patch
cell-cbe_cpufreq-fix-initialization.patch
cell-cbe_cpufreq-fix-minor-issues.patch
cell-cbe_cpufreq-reorganize-code.patch
cell-fix-cbe_cpufreq-for-legacy-slof-tree.patch
cell-fix-cbe_regc-for-legacy-slof-tree.patch
cell-fix-cbe_thermal-for-legacy-slof-tree.patch
cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch
powerpc-sysfs-fix-compiler-warning.patch
