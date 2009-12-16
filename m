From: akpm@linux-foundation.org
Subject: + kernel-irq-procc-expose-the-irq_desc-node-in-proc-irq.patch added to -mm tree
Date: Wed, 16 Dec 2009 13:45:40 -0800
Message-ID: <200912162145.nBGLjeqE016600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756232AbZLPVqG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 16:46:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sivanich@sgi.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     kernel/irq/proc.c: expose the irq_desc node in proc/irq
has been added to the -mm tree.  Its filename is
     kernel-irq-procc-expose-the-irq_desc-node-in-proc-irq.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -559,6 +559,10 @@ The default_smp_affinity mask applies to
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
@@ -146,6 +146,26 @@ static const struct file_operations defa
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
@@ -230,6 +250,9 @@ void register_irq_proc(unsigned int irq,
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

origin.patch
kernel-irq-procc-expose-the-irq_desc-node-in-proc-irq.patch

