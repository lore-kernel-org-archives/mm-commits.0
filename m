From: akpm@linux-foundation.org
Subject: + kprobes-list-all-active-probes-in-the-system.patch added to -mm tree
Date: Fri, 09 Feb 2007 00:11:13 -0800
Message-ID: <200702090811.l198BD76008019@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34587 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946192AbXBIILX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 03:11:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: srinivasa@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com


The patch titled
     kprobes: list all active probes in the system
has been added to the -mm tree.  Its filename is
     kprobes-list-all-active-probes-in-the-system.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kprobes: list all active probes in the system
From: Srinivasa Ds <srinivasa@in.ibm.com>

This patch lists all active probes in the system by scanning through
kprobe_table[].  It takes care of aggregate handlers and prints the type of
the probe.  Letter "k" for kprobes, "j" for jprobes, "r" for kretprobes. 
It also lists address of the instruction,its symbolic name(function name +
offset) and the module name.  One can access this file through
/sys/kernel/debug/kprobes/list.

Output looks like this
=====================
llm40:~/a # cat /sys/kernel/debug/kprobes/list
c0169ae3  r  sys_read+0x0
c0169ae3  k  sys_read+0x0
c01694c8  k  vfs_write+0x0
c0167d20  r  sys_open+0x0
f8e658a6  k  reiserfs_delete_inode+0x0  reiserfs
c0120f4a  k  do_fork+0x0
c0120f4a  j  do_fork+0x0
c0169b4a  r  sys_write+0x0
c0169b4a  k  sys_write+0x0
c0169622  r  vfs_read+0x0
=================================

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |  104 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff -puN kernel/kprobes.c~kprobes-list-all-active-probes-in-the-system kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-list-all-active-probes-in-the-system
+++ a/kernel/kprobes.c
@@ -39,6 +39,8 @@
 #include <linux/moduleloader.h>
 #include <linux/kallsyms.h>
 #include <linux/freezer.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
 #include <asm/errno.h>
@@ -815,6 +817,108 @@ static int __init init_kprobes(void)
 	return err;
 }
 
+#ifdef CONFIG_DEBUG_FS
+static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
+               const char *sym, int offset,char *modname)
+{
+	char *kprobe_type;
+
+	if (p->pre_handler == pre_handler_kretprobe)
+		kprobe_type = "r";
+	else if (p->pre_handler == setjmp_pre_handler)
+		kprobe_type = "j";
+	else
+		kprobe_type = "k";
+	if (sym)
+		seq_printf(pi, "%p  %s  %s+0x%x  %s\n", p->addr, kprobe_type,
+			sym, offset, (modname ? modname : " "));
+	else
+		seq_printf(pi, "%p  %s  %p\n", p->addr, kprobe_type, p->addr);
+}
+
+void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
+{
+	return (*pos < KPROBE_TABLE_SIZE) ? pos : NULL;
+}
+
+void __kprobes *kprobe_seq_next(struct seq_file *f, void *v, loff_t *pos)
+{
+	(*pos)++;
+	if (*pos >= KPROBE_TABLE_SIZE)
+		return NULL;
+	return pos;
+}
+
+void __kprobes kprobe_seq_stop(struct seq_file *f, void *v)
+{
+	/* Nothing to do */
+}
+
+int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p, *kp;
+	const char *sym = NULL;
+	unsigned int i = *(loff_t *) v;
+	unsigned long size, offset = 0;
+	char *modname, namebuf[128];
+
+	head = &kprobe_table[i];
+	preempt_disable();
+	hlist_for_each_entry_rcu(p, node, head, hlist) {
+		sym = kallsyms_lookup((unsigned long)p->addr, &size,
+					&offset, &modname, namebuf);
+		if (p->pre_handler == aggr_pre_handler) {
+			list_for_each_entry_rcu(kp, &p->list, list)
+				report_probe(pi, kp, sym, offset, modname);
+		} else
+			report_probe(pi, p, sym, offset, modname);
+	}
+	preempt_enable();
+	return 0;
+}
+
+struct seq_operations kprobes_seq_ops = {
+	.start = kprobe_seq_start,
+	.next  = kprobe_seq_next,
+	.stop  = kprobe_seq_stop,
+	.show  = show_kprobe_addr
+};
+
+static int __kprobes kprobes_open(struct inode *inode, struct file *filp)
+{
+	return seq_open(filp, &kprobes_seq_ops);
+}
+
+static struct file_operations debugfs_kprobes_operations = {
+	.open           = kprobes_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
+static int __kprobes debugfs_kprobe_init(void)
+{
+	struct dentry *dir, *file;
+
+	dir = debugfs_create_dir("kprobes", NULL);
+	if (!dir)
+		return -ENOMEM;
+
+	file = debugfs_create_file("list", 0444, dir , 0 ,
+				&debugfs_kprobes_operations);
+	if (!file) {
+		debugfs_remove(dir);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+module_init(debugfs_kprobe_init);
+#endif /* CONFIG_DEBUG_FS */
+
 __initcall(init_kprobes);
 
 EXPORT_SYMBOL_GPL(register_kprobe);
_

Patches currently in -mm which might be from srinivasa@in.ibm.com are

kprobes-list-all-active-probes-in-the-system.patch
kprobes-list-all-active-probes-in-the-system-tidy.patch
