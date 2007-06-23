From: akpm@linux-foundation.org
Subject: - x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs.patch removed from -mm tree
Date: Sat, 23 Jun 2007 16:58:23 -0700
Message-ID: <200706232358.l5NNwNlI030496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42418 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbXFWX6e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 19:58:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: suresh.b.siddha@intel.com, ak@suse.de, djwong@us.ibm.com, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     x86_64, irq: use mask/unmask and proper locking in fixup_irqs()
has been removed from the -mm tree.  Its filename was
     x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: x86_64, irq: use mask/unmask and proper locking in fixup_irqs()
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Force irq migration path during cpu offline, is not using proper locks and
irq_chip mask/unmask routines.  This will result in some races(especially
the device generating the interrupt can see some inconsistent state,
resulting in issues like stuck irq,..).

Appended patch fixes the issue by taking proper lock and encapsulating
irq_chip set_affinity() with a mask() before and an unmask() after.

This fixes a MSI irq stuck issue reported by Darrick Wong.

There are several more general bugs in this area(irq migration in the
process context). For example,

1. Possibility of missing edge triggered irq.
2. Reliable method of migrating level triggered irq in the process context.

We plan to look and close these in the near future.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Reported-by: Darrick Wong <djwong@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/irq.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/irq.c~x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs arch/x86_64/kernel/irq.c
--- a/arch/x86_64/kernel/irq.c~x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs
+++ a/arch/x86_64/kernel/irq.c
@@ -144,17 +144,41 @@ void fixup_irqs(cpumask_t map)
 
 	for (irq = 0; irq < NR_IRQS; irq++) {
 		cpumask_t mask;
+		int break_affinity = 0;
+		int set_affinity = 1;
+
 		if (irq == 2)
 			continue;
 
+		/* interrupt's are disabled at this point */
+		spin_lock(&irq_desc[irq].lock);
+
+		if (!irq_has_action(irq) ||
+		    cpus_equal(irq_desc[irq].affinity, map)) {
+			spin_unlock(&irq_desc[irq].lock);
+			continue;
+		}
+
 		cpus_and(mask, irq_desc[irq].affinity, map);
-		if (any_online_cpu(mask) == NR_CPUS) {
-			printk("Breaking affinity for irq %i\n", irq);
+		if (cpus_empty(mask)) {
+			break_affinity = 1;
 			mask = map;
 		}
+
+		irq_desc[irq].chip->mask(irq);
+
 		if (irq_desc[irq].chip->set_affinity)
 			irq_desc[irq].chip->set_affinity(irq, mask);
-		else if (irq_desc[irq].action && !(warned++))
+		else if (!(warned++))
+			set_affinity = 0;
+
+		irq_desc[irq].chip->unmask(irq);
+
+		spin_unlock(&irq_desc[irq].lock);
+
+		if (break_affinity && set_affinity)
+			printk("Broke affinity for irq %i\n", irq);
+		else if (!set_affinity)
 			printk("Cannot set affinity for irq %i\n", irq);
 	}
 
_

Patches currently in -mm which might be from suresh.b.siddha@intel.com are

x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs.patch
