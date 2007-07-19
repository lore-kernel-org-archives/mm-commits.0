From: akpm@linux-foundation.org
Subject: - i386-ioapic-remove-old-irq-balancing-debug-cruft.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:11:04 -0700
Message-ID: <200707192011.l6JKB4cp020734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43145 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761915AbXGSUQu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefanr@s5r6.in-berlin.de, ak@suse.de, mingo@elte.hu, rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     i386 IOAPIC: remove old IRQ balancing debug cruft
has been removed from the -mm tree.  Its filename was
     i386-ioapic-remove-old-irq-balancing-debug-cruft.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 IOAPIC: remove old IRQ balancing debug cruft
From: Stefan Richter <stefanr@s5r6.in-berlin.de>

Dead or misnamed CONFIG_BALANCED_IRQ_DEBUG found by Robert P. J. Day.
It's not a Kconfig variable.

Since this debug code is ancient, I suggest to get rid of this
misleading CONFIG_ macro by deleting all of this debug code.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/io_apic.c |   24 ++----------------------
 1 files changed, 2 insertions(+), 22 deletions(-)

diff -puN arch/i386/kernel/io_apic.c~i386-ioapic-remove-old-irq-balancing-debug-cruft arch/i386/kernel/io_apic.c
--- a/arch/i386/kernel/io_apic.c~i386-ioapic-remove-old-irq-balancing-debug-cruft
+++ a/arch/i386/kernel/io_apic.c
@@ -353,14 +353,6 @@ static void set_ioapic_affinity_irq(unsi
 # include <linux/slab.h>		/* kmalloc() */
 # include <linux/timer.h>	/* time_after() */
  
-#ifdef CONFIG_BALANCED_IRQ_DEBUG
-#  define TDprintk(x...) do { printk("<%ld:%s:%d>: ", jiffies, __FILE__, __LINE__); printk(x); } while (0)
-#  define Dprintk(x...) do { TDprintk(x); } while (0)
-# else
-#  define TDprintk(x...) 
-#  define Dprintk(x...) 
-# endif
-
 #define IRQBALANCE_CHECK_ARCH -999
 #define MAX_BALANCED_IRQ_INTERVAL	(5*HZ)
 #define MIN_BALANCED_IRQ_INTERVAL	(HZ/2)
@@ -443,7 +435,7 @@ static inline void balance_irq(int cpu, 
 static inline void rotate_irqs_among_cpus(unsigned long useful_load_threshold)
 {
 	int i, j;
-	Dprintk("Rotating IRQs among CPUs.\n");
+
 	for_each_online_cpu(i) {
 		for (j = 0; j < NR_IRQS; j++) {
 			if (!irq_desc[j].action)
@@ -560,19 +552,11 @@ tryanothercpu:
 	max_loaded = tmp_loaded;	/* processor */
 	imbalance = (max_cpu_irq - min_cpu_irq) / 2;
 	
-	Dprintk("max_loaded cpu = %d\n", max_loaded);
-	Dprintk("min_loaded cpu = %d\n", min_loaded);
-	Dprintk("max_cpu_irq load = %ld\n", max_cpu_irq);
-	Dprintk("min_cpu_irq load = %ld\n", min_cpu_irq);
-	Dprintk("load imbalance = %lu\n", imbalance);
-
 	/* if imbalance is less than approx 10% of max load, then
 	 * observe diminishing returns action. - quit
 	 */
-	if (imbalance < (max_cpu_irq >> 3)) {
-		Dprintk("Imbalance too trivial\n");
+	if (imbalance < (max_cpu_irq >> 3))
 		goto not_worth_the_effort;
-	}
 
 tryanotherirq:
 	/* if we select an IRQ to move that can't go where we want, then
@@ -629,9 +613,6 @@ tryanotherirq:
 	cpus_and(tmp, target_cpu_mask, allowed_mask);
 
 	if (!cpus_empty(tmp)) {
-
-		Dprintk("irq = %d moved to cpu = %d\n",
-				selected_irq, min_loaded);
 		/* mark for change destination */
 		set_pending_irq(selected_irq, cpumask_of_cpu(min_loaded));
 
@@ -651,7 +632,6 @@ not_worth_the_effort:
 	 */
 	balanced_irq_interval = min((long)MAX_BALANCED_IRQ_INTERVAL,
 		balanced_irq_interval + BALANCED_IRQ_MORE_DELTA);	
-	Dprintk("IRQ worth rotating not found\n");
 	return;
 }
 
_

Patches currently in -mm which might be from stefanr@s5r6.in-berlin.de are

origin.patch
git-ieee1394.patch
