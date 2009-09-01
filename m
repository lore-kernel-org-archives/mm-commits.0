From: akpm@linux-foundation.org
Subject: + genirq-switch-proc-irq-spurious-to-seq_file.patch added to -mm tree
Date: Tue, 01 Sep 2009 15:42:50 -0700
Message-ID: <200909012242.n81Mgoj6012079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755253AbZIAWnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Sep 2009 18:43:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     genirq: switch /proc/irq/*/spurious to seq_file
has been added to the -mm tree.  Its filename is
     genirq-switch-proc-irq-spurious-to-seq_file.patch

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
Subject: genirq: switch /proc/irq/*/spurious to seq_file
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/irq/proc.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN kernel/irq/proc.c~genirq-switch-proc-irq-spurious-to-seq_file kernel/irq/proc.c
--- a/kernel/irq/proc.c~genirq-switch-proc-irq-spurious-to-seq_file
+++ a/kernel/irq/proc.c
@@ -148,18 +148,30 @@ static const struct file_operations defa
 };
 #endif
 
-static int irq_spurious_read(char *page, char **start, off_t off,
-				  int count, int *eof, void *data)
+static int irq_spurious_proc_show(struct seq_file *m, void *v)
 {
-	struct irq_desc *desc = irq_to_desc((long) data);
-	return sprintf(page, "count %u\n"
+	struct irq_desc *desc = irq_to_desc((long) m->private);
+	seq_printf(m, "count %u\n"
 			     "unhandled %u\n"
 			     "last_unhandled %u ms\n",
 			desc->irq_count,
 			desc->irqs_unhandled,
 			jiffies_to_msecs(desc->last_unhandled));
+	return 0;
 }
 
+static int irq_spurious_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_spurious_proc_show, NULL);
+}
+
+static const struct file_operations irq_spurious_proc_fops = {
+	.open		= irq_spurious_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 #define MAX_NAMELEN 128
 
 static int name_unique(unsigned int irq, struct irqaction *new_action)
@@ -204,7 +216,6 @@ void register_handler_proc(unsigned int 
 void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 {
 	char name [MAX_NAMELEN];
-	struct proc_dir_entry *entry;
 
 	if (!root_irq_dir || (desc->chip == &no_irq_chip) || desc->dir)
 		return;
@@ -221,11 +232,8 @@ void register_irq_proc(unsigned int irq,
 			 &irq_affinity_proc_fops, (void *)(long)irq);
 #endif
 
-	entry = create_proc_entry("spurious", 0444, desc->dir);
-	if (entry) {
-		entry->data = (void *)(long)irq;
-		entry->read_proc = irq_spurious_read;
-	}
+	proc_create_data("spurious", 0444, desc->dir,
+			 &irq_spurious_proc_fops, (void *)(long)irq);
 }
 
 #undef MAX_NAMELEN
_

Patches currently in -mm which might be from adobriyan@gmail.com are

linux-next.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
scripts-get_maintainerpl-add-remove-duplicates.patch
proc_flush_task-flush-proc-tid-task-pid-when-a-sub-thread-exits.patch
procfs-provide-stack-information-for-threads-v08.patch
procfs-provide-stack-information-for-threads-v011.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch
sysctl-remove-struct-file-argument-of-proc_handler.patch
aio-ifdef-fields-in-mm_struct.patch

