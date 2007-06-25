From: akpm@linux-foundation.org
Subject: + x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs-v2.patch added to -mm tree
Date: Mon, 25 Jun 2007 16:50:13 -0700
Message-ID: <200706252350.l5PNoEhF014130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43258 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbXFYXue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 19:50:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: suresh.b.siddha@intel.com, ak@suse.de, djwong@us.ibm.com, ebiederm@xmission.com, rjw@sisk.pl


The patch titled
     x86_64, irq: use mask/unmask and proper locking in fixup_irqs()
has been added to the -mm tree.  Its filename is
     x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Eric says:
	In addition even with the fix from Suresh there is still at least one
	nasty hardware race in fixup_irqs().   However we exercise that code
	path rarely enough that we are unlikely to hit it in the real world,
	and that race seems to have existed since the code was merged.  And a
	fix for that is not coming soon as it is an open investigation area
	if we can fix irq migration to work outside of irq context or if
	we have to rework the requirements imposed by the generic cpu hotplug
	and layer on fixup_irqs().  So this may come up again.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Reported-by: Darrick Wong <djwong@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/irq.c |   32 +++++++++++++++++++++++++++++---
 1 files changed, 29 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/irq.c~x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs-v2 arch/x86_64/kernel/irq.c
--- a/arch/x86_64/kernel/irq.c~x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs-v2
+++ a/arch/x86_64/kernel/irq.c
@@ -144,17 +144,43 @@ void fixup_irqs(cpumask_t map)
 
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
+		if (irq_desc[irq].chip->mask)
+			irq_desc[irq].chip->mask(irq);
+
 		if (irq_desc[irq].chip->set_affinity)
 			irq_desc[irq].chip->set_affinity(irq, mask);
-		else if (irq_desc[irq].action && !(warned++))
+		else if (!(warned++))
+			set_affinity = 0;
+
+		if (irq_desc[irq].chip->unmask)
+			irq_desc[irq].chip->unmask(irq);
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

x86_64-set-the-irq_chip-name-for-lapic.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs-v2.patch
x86_64-irq-use-mask-unmask-and-proper-locking-in-fixup_irqs-v2-fix.patch
