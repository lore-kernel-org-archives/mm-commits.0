From: akpm@linux-foundation.org
Subject: [merged] kernel-irq-procc-expose-the-irq_desc-node-in-proc-irq.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:38:57 -0400
Message-ID: <201004151840.o3FIeZYX024437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755550Ab0DOSlW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:41:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sivanich@sgi.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     kernel/irq/proc.c: expose the irq_desc node in proc/irq
has been removed from the -mm tree.  Its filename was
     kernel-irq-procc-expose-the-irq_desc-node-in-proc-irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/irq/proc.c: expose the irq_desc node in proc/irq
From: Dimitri Sivanich <sivanich@sgi.com>

Expose the irq_desc node as /proc/irq/*/node.

This file provides device hardware locality information for apps desiring
to include hardware locality in irq mapping decisions.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    4 ++++
 kernel/irq/proc.c                  |   23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff -puN Documentation/filesystems/proc.txt~kernel-irq-procc-expose-the-irq_desc-node-in-proc-irq Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~kernel-irq-procc-expose-the-irq_desc-node-in-proc-irq
+++ a/Documentation/filesystems/proc.txt
@@ -567,6 +567,10 @@ The default_smp_affinity mask applies to
 IRQs which have not yet been allocated/activated, and hence which lack a
 /proc/irq/[0-9]* directory.
 
+The node file on an SMP system shows the node to which the device using the IRQ
+reports itself as being attached.  This hardware locality information does not
+include information about any possible driver locality preference.
+
 prof_cpu_mask specifies which CPUs are to be profiled by the system wide
 profiler. Default value is ffffffff (all cpus).
 
diff -puN kernel/irq/proc.c~kernel-irq-procc-expose-the-irq_desc-node-in-proc-irq kernel/irq/proc.c
--- a/kernel/irq/proc.c~kernel-irq-procc-expose-the-irq_desc-node-in-proc-irq
+++ a/kernel/irq/proc.c
@@ -147,6 +147,26 @@ static const struct file_operations defa
 	.release	= single_release,
 	.write		= default_affinity_write,
 };
+
+static int irq_node_proc_show(struct seq_file *m, void *v)
+{
+	struct irq_desc *desc = irq_to_desc((long) m->private);
+
+	seq_printf(m, "%d\n", desc->node);
+	return 0;
+}
+
+static int irq_node_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_node_proc_show, PDE(inode)->data);
+}
+
+static const struct file_operations irq_node_proc_fops = {
+	.open		= irq_node_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif
 
 static int irq_spurious_proc_show(struct seq_file *m, void *v)
@@ -231,6 +251,9 @@ void register_irq_proc(unsigned int irq,
 	/* create /proc/irq/<irq>/smp_affinity */
 	proc_create_data("smp_affinity", 0600, desc->dir,
 			 &irq_affinity_proc_fops, (void *)(long)irq);
+
+	proc_create_data("node", 0444, desc->dir,
+			 &irq_node_proc_fops, (void *)(long)irq);
 #endif
 
 	proc_create_data("spurious", 0444, desc->dir,
_

Patches currently in -mm which might be from sivanich@sgi.com are

linux-next.patch

