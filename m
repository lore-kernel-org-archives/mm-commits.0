From: akpm@linux-foundation.org
Subject: - kprobes-the-on-off-knob-thru-debugfs-updated.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:51 -0700
Message-ID: <200705090254.l492spQq009854@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032291AbXEICzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ananth@in.ibm.com, cornelia.huck@de.ibm.com, srinivasa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Kprobes: The ON/OFF knob thru debugfs
has been removed from the -mm tree.  Its filename was
     kprobes-the-on-off-knob-thru-debugfs-updated.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Kprobes: The ON/OFF knob thru debugfs
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

This patch provides a debugfs knob to turn kprobes on/off

o A new file /debug/kprobes/enabled indicates if kprobes is enabled or
  not (default enabled)
o Echoing 0 to this file will disarm all installed probes
o Any new probe registration when disabled will register the probe but
  not arm it. A message will be printed out in such a case.
o When a value 1 is echoed to the file, all probes (including ones
  registered in the intervening period) will be enabled
o Unregistration will happen irrespective of whether probes are globally
  enabled or not.
o Update Documentation/kprobes.txt to reflect these changes. While there
  also update the doc to make it current.

We are also looking at providing sysrq key support to tie to the disabling
feature provided by this patch.

[akpm@linux-foundation.org: Use bool like a bool!]
[akpm@linux-foundation.org: add printk facility levels]
[cornelia.huck@de.ibm.com: Add the missing arch_trampoline_kprobe() for s390]
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kprobes.txt     |   34 ++++++
 arch/i386/kernel/kprobes.c    |    5 +
 arch/ia64/kernel/kprobes.c    |    9 +
 arch/powerpc/kernel/kprobes.c |    8 +
 arch/s390/kernel/kprobes.c    |    7 +
 arch/x86_64/kernel/kprobes.c  |    8 +
 include/linux/kprobes.h       |    5 +
 kernel/kprobes.c              |  156 ++++++++++++++++++++++++++++++--
 8 files changed, 222 insertions(+), 10 deletions(-)

diff -puN Documentation/kprobes.txt~kprobes-the-on-off-knob-thru-debugfs-updated Documentation/kprobes.txt
--- a/Documentation/kprobes.txt~kprobes-the-on-off-knob-thru-debugfs-updated
+++ a/Documentation/kprobes.txt
@@ -14,6 +14,7 @@ CONTENTS
 8. Kprobes Example
 9. Jprobes Example
 10. Kretprobes Example
+Appendix A: The kprobes debugfs interface
 
 1. Concepts: Kprobes, Jprobes, Return Probes
 
@@ -349,9 +350,12 @@ for instrumentation and error reporting.
 
 If the number of times a function is called does not match the number
 of times it returns, registering a return probe on that function may
-produce undesirable results.  We have the do_exit() case covered.
-do_execve() and do_fork() are not an issue.  We're unaware of other
-specific cases where this could be a problem.
+produce undesirable results. In such a case, a line:
+kretprobe BUG!: Processing kretprobe d000000000041aa8 @ c00000000004f48c
+gets printed. With this information, one will be able to correlate the
+exact instance of the kretprobe that caused the problem. We have the
+do_exit() case covered. do_execve() and do_fork() are not an issue.
+We're unaware of other specific cases where this could be a problem.
 
 If, upon entry to or exit from a function, the CPU is running on
 a stack other than that of the current task, registering a return
@@ -614,3 +618,27 @@ http://www-106.ibm.com/developerworks/li
 http://www.redhat.com/magazine/005mar05/features/kprobes/
 http://www-users.cs.umn.edu/~boutcher/kprobes/
 http://www.linuxsymposium.org/2006/linuxsymposium_procv2.pdf (pages 101-115)
+
+
+Appendix A: The kprobes debugfs interface
+
+With recent kernels (> 2.6.20) the list of registered kprobes is visible
+under the /debug/kprobes/ directory (assuming debugfs is mounted at /debug).
+
+/debug/kprobes/list: Lists all registered probes on the system
+
+c015d71a  k  vfs_read+0x0
+c011a316  j  do_fork+0x0
+c03dedc5  r  tcp_v4_rcv+0x0
+
+The first column provides the kernel address where the probe is inserted.
+The second column identifies the type of probe (k - kprobe, r - kretprobe
+and j - jprobe), while the third column specifies the symbol+offset of
+the probe. If the probed function belongs to a module, the module name
+is also specified.
+
+/debug/kprobes/enabled: Turn kprobes ON/OFF
+
+Provides a knob to globally turn registered kprobes ON or OFF. By default,
+all kprobes are enabled. By echoing "0" to this file, all registered probes
+will be disarmed, till such time a "1" is echoed to this file.
diff -puN arch/i386/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated arch/i386/kernel/kprobes.c
--- a/arch/i386/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated
+++ a/arch/i386/kernel/kprobes.c
@@ -743,6 +743,11 @@ int __kprobes longjmp_break_handler(stru
 	return 0;
 }
 
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	return 0;
+}
+
 int __init arch_init_kprobes(void)
 {
 	return 0;
diff -puN arch/ia64/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated arch/ia64/kernel/kprobes.c
--- a/arch/ia64/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated
+++ a/arch/ia64/kernel/kprobes.c
@@ -1012,3 +1012,12 @@ int __init arch_init_kprobes(void)
 		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip;
 	return register_kprobe(&trampoline_p);
 }
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr ==
+		(kprobe_opcode_t *)((struct fnptr *)kretprobe_trampoline)->ip)
+		return 1;
+
+	return 0;
+}
diff -puN arch/powerpc/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated arch/powerpc/kernel/kprobes.c
--- a/arch/powerpc/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated
+++ a/arch/powerpc/kernel/kprobes.c
@@ -550,3 +550,11 @@ int __init arch_init_kprobes(void)
 {
 	return register_kprobe(&trampoline_p);
 }
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
+		return 1;
+
+	return 0;
+}
diff -puN arch/s390/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated
+++ a/arch/s390/kernel/kprobes.c
@@ -661,3 +661,10 @@ int __init arch_init_kprobes(void)
 {
 	return register_kprobe(&trampoline_p);
 }
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr == (kprobe_opcode_t *) & kretprobe_trampoline)
+		return 1;
+	return 0;
+}
diff -puN arch/x86_64/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated arch/x86_64/kernel/kprobes.c
--- a/arch/x86_64/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated
+++ a/arch/x86_64/kernel/kprobes.c
@@ -743,3 +743,11 @@ int __init arch_init_kprobes(void)
 {
 	return register_kprobe(&trampoline_p);
 }
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
+		return 1;
+
+	return 0;
+}
diff -puN include/linux/kprobes.h~kprobes-the-on-off-knob-thru-debugfs-updated include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-the-on-off-knob-thru-debugfs-updated
+++ a/include/linux/kprobes.h
@@ -125,11 +125,16 @@ DECLARE_PER_CPU(struct kprobe_ctlblk, kp
 #ifdef ARCH_SUPPORTS_KRETPROBES
 extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				   struct pt_regs *regs);
+extern int arch_trampoline_kprobe(struct kprobe *p);
 #else /* ARCH_SUPPORTS_KRETPROBES */
 static inline void arch_prepare_kretprobe(struct kretprobe *rp,
 					struct pt_regs *regs)
 {
 }
+static inline int arch_trampoline_kprobe(struct kprobe *p)
+{
+	return 0;
+}
 #endif /* ARCH_SUPPORTS_KRETPROBES */
 /*
  * Function-return probe -
diff -puN kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-the-on-off-knob-thru-debugfs-updated
+++ a/kernel/kprobes.c
@@ -43,9 +43,11 @@
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
 #include <linux/kdebug.h>
+
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
 #include <asm/errno.h>
+#include <asm/uaccess.h>
 
 #define KPROBE_HASH_BITS 6
 #define KPROBE_TABLE_SIZE (1 << KPROBE_HASH_BITS)
@@ -64,6 +66,9 @@ static struct hlist_head kprobe_table[KP
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 static atomic_t kprobe_count;
 
+/* NOTE: change this value only with kprobe_mutex held */
+static bool kprobe_enabled;
+
 DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
 DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
@@ -564,12 +569,13 @@ static int __kprobes __register_kprobe(s
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
 
-	if (atomic_add_return(1, &kprobe_count) == \
+	if (kprobe_enabled) {
+		if (atomic_add_return(1, &kprobe_count) == \
 				(ARCH_INACTIVE_KPROBE_COUNT + 1))
-		register_page_fault_notifier(&kprobe_page_fault_nb);
-
-	arch_arm_kprobe(p);
+			register_page_fault_notifier(&kprobe_page_fault_nb);
 
+		arch_arm_kprobe(p);
+	}
 out:
 	mutex_unlock(&kprobe_mutex);
 
@@ -607,8 +613,13 @@ valid_p:
 	if (old_p == p ||
 	    (old_p->pre_handler == aggr_pre_handler &&
 	     p->list.next == &old_p->list && p->list.prev == &old_p->list)) {
-		/* Only probe on the hash list */
-		arch_disarm_kprobe(p);
+		/*
+		 * Only probe on the hash list. Disarm only if kprobes are
+		 * enabled - otherwise, the breakpoint would already have
+		 * been removed. We save on flushing icache.
+		 */
+		if (kprobe_enabled)
+			arch_disarm_kprobe(p);
 		hlist_del_rcu(&old_p->hlist);
 		cleanup_p = 1;
 	} else {
@@ -797,6 +808,9 @@ static int __init init_kprobes(void)
 	}
 	atomic_set(&kprobe_count, 0);
 
+	/* By default, kprobes are enabled */
+	kprobe_enabled = true;
+
 	err = arch_init_kprobes();
 	if (!err)
 		err = register_die_notifier(&kprobe_exceptions_nb);
@@ -806,7 +820,7 @@ static int __init init_kprobes(void)
 
 #ifdef CONFIG_DEBUG_FS
 static void __kprobes report_probe(struct seq_file *pi, struct kprobe *p,
-               const char *sym, int offset,char *modname)
+		const char *sym, int offset,char *modname)
 {
 	char *kprobe_type;
 
@@ -885,9 +899,130 @@ static struct file_operations debugfs_kp
 	.release        = seq_release,
 };
 
+static void __kprobes enable_all_kprobes(void)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p;
+	unsigned int i;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* If kprobes are already enabled, just return */
+	if (kprobe_enabled)
+		goto already_enabled;
+
+	/*
+	 * Re-register the page fault notifier only if there are any
+	 * active probes at the time of enabling kprobes globally
+	 */
+	if (atomic_read(&kprobe_count) > ARCH_INACTIVE_KPROBE_COUNT)
+		register_page_fault_notifier(&kprobe_page_fault_nb);
+
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist)
+			arch_arm_kprobe(p);
+	}
+
+	kprobe_enabled = true;
+	printk(KERN_INFO "Kprobes globally enabled\n");
+
+already_enabled:
+	mutex_unlock(&kprobe_mutex);
+	return;
+}
+
+static void __kprobes disable_all_kprobes(void)
+{
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p;
+	unsigned int i;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* If kprobes are already disabled, just return */
+	if (!kprobe_enabled)
+		goto already_disabled;
+
+	kprobe_enabled = false;
+	printk(KERN_INFO "Kprobes globally disabled\n");
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist) {
+			if (!arch_trampoline_kprobe(p))
+				arch_disarm_kprobe(p);
+		}
+	}
+
+	mutex_unlock(&kprobe_mutex);
+	/* Allow all currently running kprobes to complete */
+	synchronize_sched();
+
+	mutex_lock(&kprobe_mutex);
+	/* Unconditionally unregister the page_fault notifier */
+	unregister_page_fault_notifier(&kprobe_page_fault_nb);
+
+already_disabled:
+	mutex_unlock(&kprobe_mutex);
+	return;
+}
+
+/*
+ * XXX: The debugfs bool file interface doesn't allow for callbacks
+ * when the bool state is switched. We can reuse that facility when
+ * available
+ */
+static ssize_t read_enabled_file_bool(struct file *file,
+	       char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[3];
+
+	if (kprobe_enabled)
+		buf[0] = '1';
+	else
+		buf[0] = '0';
+	buf[1] = '\n';
+	buf[2] = 0x00;
+	return simple_read_from_buffer(user_buf, count, ppos, buf, 2);
+}
+
+static ssize_t write_enabled_file_bool(struct file *file,
+	       const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	char buf[32];
+	int buf_size;
+
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	switch (buf[0]) {
+	case 'y':
+	case 'Y':
+	case '1':
+		enable_all_kprobes();
+		break;
+	case 'n':
+	case 'N':
+	case '0':
+		disable_all_kprobes();
+		break;
+	}
+
+	return count;
+}
+
+static struct file_operations fops_kp = {
+	.read =         read_enabled_file_bool,
+	.write =        write_enabled_file_bool,
+};
+
 static int __kprobes debugfs_kprobe_init(void)
 {
 	struct dentry *dir, *file;
+	unsigned int value = 1;
 
 	dir = debugfs_create_dir("kprobes", NULL);
 	if (!dir)
@@ -900,6 +1035,13 @@ static int __kprobes debugfs_kprobe_init
 		return -ENOMEM;
 	}
 
+	file = debugfs_create_file("enabled", 0600, dir,
+					&value, &fops_kp);
+	if (!file) {
+		debugfs_remove(dir);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from ananth@in.ibm.com are

origin.patch
