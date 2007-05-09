From: akpm@linux-foundation.org
Subject: - pad-irq_desc-to-internode-cacheline-size.patch removed from -mm tree
Date: Tue, 08 May 2007 19:49:19 -0700
Message-ID: <200705090249.l492nJsL009210@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42458 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969496AbXEICtd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:49:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kiran@scalex86.org, mingo@elte.hu, shai@scalex86.org, suresh.b.siddha@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Pad irq_desc to internode cacheline size
has been removed from the -mm tree.  Its filename was
     pad-irq_desc-to-internode-cacheline-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Pad irq_desc to internode cacheline size
From: Ravikiran G Thirumalai <kiran@scalex86.org>

We noticed a drop in n/w performance due to the irq_desc being cacheline
aligned rather than internode aligned.  We see 50% of expected performance
when two e1000 nics local to two different nodes have consecutive irq
descriptors allocated, due to false sharing.

Note that this patch does away with cacheline padding for the UP case, as
it does not seem useful for UP configurations.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h |    4 +---
 kernel/irq/handle.c |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN include/linux/irq.h~pad-irq_desc-to-internode-cacheline-size include/linux/irq.h
--- a/include/linux/irq.h~pad-irq_desc-to-internode-cacheline-size
+++ a/include/linux/irq.h
@@ -147,8 +147,6 @@ struct irq_chip {
  * @dir:		/proc/irq/ procfs entry
  * @affinity_entry:	/proc/irq/smp_affinity procfs entry on SMP
  * @name:		flow handler name for /proc/interrupts output
- *
- * Pad this out to 32 bytes for cache and indexing reasons.
  */
 struct irq_desc {
 	irq_flow_handler_t	handle_irq;
@@ -175,7 +173,7 @@ struct irq_desc {
 	struct proc_dir_entry	*dir;
 #endif
 	const char		*name;
-} ____cacheline_aligned;
+} ____cacheline_internodealigned_in_smp;
 
 extern struct irq_desc irq_desc[NR_IRQS];
 
diff -puN kernel/irq/handle.c~pad-irq_desc-to-internode-cacheline-size kernel/irq/handle.c
--- a/kernel/irq/handle.c~pad-irq_desc-to-internode-cacheline-size
+++ a/kernel/irq/handle.c
@@ -48,7 +48,7 @@ handle_bad_irq(unsigned int irq, struct 
  *
  * Controller mappings for all interrupt sources:
  */
-struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned = {
+struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	[0 ... NR_IRQS-1] = {
 		.status = IRQ_DISABLED,
 		.chip = &no_irq_chip,
_

Patches currently in -mm which might be from kiran@scalex86.org are

origin.patch
git-pciseg.patch
slab-leaks3-default-y.patch
