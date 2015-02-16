From: akpm@linux-foundation.org
Subject: [merged]
 irq-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch removed from -mm tree
Date: Mon, 16 Feb 2015 12:16:55 -0800
Message-ID: <54e25037.1IWoms4oQOBFgBtw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbbBPURb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Feb 2015 15:17:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: irq: use %*pb[l] to print bitmaps including cpumasks and nodemasks
has been removed from the -mm tree.  Its filename was
     irq-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: irq: use %*pb[l] to print bitmaps including cpumasks and nodemasks

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/proc.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN kernel/irq/proc.c~irq-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks kernel/irq/proc.c
--- a/kernel/irq/proc.c~irq-use-%pb-to-print-bitmaps-including-cpumasks-and-nodemasks
+++ a/kernel/irq/proc.c
@@ -46,10 +46,9 @@ static int show_irq_affinity(int type, s
 		mask = desc->pending_mask;
 #endif
 	if (type)
-		seq_cpumask_list(m, mask);
+		seq_printf(m, "%*pbl\n", cpumask_pr_args(mask));
 	else
-		seq_cpumask(m, mask);
-	seq_putc(m, '\n');
+		seq_printf(m, "%*pb\n", cpumask_pr_args(mask));
 	return 0;
 }
 
@@ -67,8 +66,7 @@ static int irq_affinity_hint_proc_show(s
 		cpumask_copy(mask, desc->affinity_hint);
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
-	seq_cpumask(m, mask);
-	seq_putc(m, '\n');
+	seq_printf(m, "%*pb\n", cpumask_pr_args(mask));
 	free_cpumask_var(mask);
 
 	return 0;
@@ -186,8 +184,7 @@ static const struct file_operations irq_
 
 static int default_affinity_show(struct seq_file *m, void *v)
 {
-	seq_cpumask(m, irq_default_affinity);
-	seq_putc(m, '\n');
+	seq_printf(m, "%*pb\n", cpumask_pr_args(irq_default_affinity));
 	return 0;
 }
 
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

