From: akpm@linux-foundation.org
Subject: [merged] kprobes-support-per-kprobe-disabling.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:24 -0700
Message-ID: <200904071907.n37J7OZU011281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41507 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760327AbZDGTLy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:11:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     kprobes: support per-kprobe disabling
has been removed from the -mm tree.  Its filename was
     kprobes-support-per-kprobe-disabling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: support per-kprobe disabling
From: Masami Hiramatsu <mhiramat@redhat.com>

Add disable_kprobe() and enable_kprobe() to disable/enable kprobes
temporarily.

disable_kprobe() asynchronously disables probe handlers of specified
kprobe.  So, after calling it, some handlers can be called at a while. 
enable_kprobe() enables specified kprobe.

aggr_pre_handler and aggr_post_handler check disabled probes.  On the
other hand aggr_break_handler and aggr_fault_handler don't check it
because these handlers will be called while executing pre or post handlers
and usually those help error handling.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kprobes.txt |   34 ++++++-
 include/linux/kprobes.h   |   23 ++++
 kernel/kprobes.c          |  167 ++++++++++++++++++++++++++++++------
 3 files changed, 191 insertions(+), 33 deletions(-)

diff -puN Documentation/kprobes.txt~kprobes-support-per-kprobe-disabling Documentation/kprobes.txt
--- a/Documentation/kprobes.txt~kprobes-support-per-kprobe-disabling
+++ a/Documentation/kprobes.txt
@@ -212,7 +212,9 @@ hit, Kprobes calls kp->pre_handler.  Aft
 is single-stepped, Kprobe calls kp->post_handler.  If a fault
 occurs during execution of kp->pre_handler or kp->post_handler,
 or during single-stepping of the probed instruction, Kprobes calls
-kp->fault_handler.  Any or all handlers can be NULL.
+kp->fault_handler.  Any or all handlers can be NULL. If kp->flags
+is set KPROBE_FLAG_DISABLED, that kp will be registered but disabled,
+so, it's handlers aren't hit until calling enable_kprobe(kp).
 
 NOTE:
 1. With the introduction of the "symbol_name" field to struct kprobe,
@@ -363,6 +365,22 @@ probes) in the specified array, they cle
 incorrect probes. However, other probes in the array are
 unregistered correctly.
 
+4.7 disable_kprobe
+
+#include <linux/kprobes.h>
+int disable_kprobe(struct kprobe *kp);
+
+Temporarily disables the specified kprobe. You can enable it again by using
+enable_kprobe(). You must specify the kprobe which has been registered.
+
+4.8 enable_kprobe
+
+#include <linux/kprobes.h>
+int enable_kprobe(struct kprobe *kp);
+
+Enables kprobe which has been disabled by disable_kprobe(). You must specify
+the kprobe which has been registered.
+
 5. Kprobes Features and Limitations
 
 Kprobes allows multiple probes at the same address.  Currently,
@@ -500,10 +518,14 @@ the probe. If the probed function belong
 is also specified. Following columns show probe status. If the probe is on
 a virtual address that is no longer valid (module init sections, module
 virtual addresses that correspond to modules that've been unloaded),
-such probes are marked with [GONE].
+such probes are marked with [GONE]. If the probe is temporarily disabled,
+such probes are marked with [DISABLED].
 
-/debug/kprobes/enabled: Turn kprobes ON/OFF
+/debug/kprobes/enabled: Turn kprobes ON/OFF forcibly.
 
-Provides a knob to globally turn registered kprobes ON or OFF. By default,
-all kprobes are enabled. By echoing "0" to this file, all registered probes
-will be disarmed, till such time a "1" is echoed to this file.
+Provides a knob to globally and forcibly turn registered kprobes ON or OFF.
+By default, all kprobes are enabled. By echoing "0" to this file, all
+registered probes will be disarmed, till such time a "1" is echoed to this
+file. Note that this knob just disarms and arms all kprobes and doesn't
+change each probe's disabling state. This means that disabled kprobes (marked
+[DISABLED]) will be not enabled if you turn ON all kprobes by this knob.
diff -puN include/linux/kprobes.h~kprobes-support-per-kprobe-disabling include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-support-per-kprobe-disabling
+++ a/include/linux/kprobes.h
@@ -112,18 +112,28 @@ struct kprobe {
 	/* copy of the original instruction */
 	struct arch_specific_insn ainsn;
 
-	/* Indicates various status flags.  Protected by kprobe_mutex. */
+	/*
+	 * Indicates various status flags.
+	 * Protected by kprobe_mutex after this kprobe is registered.
+	 */
 	u32 flags;
 };
 
 /* Kprobe status flags */
 #define KPROBE_FLAG_GONE	1 /* breakpoint has already gone */
+#define KPROBE_FLAG_DISABLED	2 /* probe is temporarily disabled */
 
+/* Has this kprobe gone ? */
 static inline int kprobe_gone(struct kprobe *p)
 {
 	return p->flags & KPROBE_FLAG_GONE;
 }
 
+/* Is this kprobe disabled ? */
+static inline int kprobe_disabled(struct kprobe *p)
+{
+	return p->flags & (KPROBE_FLAG_DISABLED | KPROBE_FLAG_GONE);
+}
 /*
  * Special probe type that uses setjmp-longjmp type tricks to resume
  * execution at a specified entry with a matching prototype corresponding
@@ -283,6 +293,9 @@ void unregister_kretprobes(struct kretpr
 void kprobe_flush_task(struct task_struct *tk);
 void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
 
+int disable_kprobe(struct kprobe *kp);
+int enable_kprobe(struct kprobe *kp);
+
 #else /* !CONFIG_KPROBES: */
 
 static inline int kprobes_built_in(void)
@@ -349,5 +362,13 @@ static inline void unregister_kretprobes
 static inline void kprobe_flush_task(struct task_struct *tk)
 {
 }
+static inline int disable_kprobe(struct kprobe *kp)
+{
+	return -ENOSYS;
+}
+static inline int enable_kprobe(struct kprobe *kp)
+{
+	return -ENOSYS;
+}
 #endif /* CONFIG_KPROBES */
 #endif /* _LINUX_KPROBES_H */
diff -puN kernel/kprobes.c~kprobes-support-per-kprobe-disabling kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-support-per-kprobe-disabling
+++ a/kernel/kprobes.c
@@ -328,7 +328,7 @@ static int __kprobes aggr_pre_handler(st
 	struct kprobe *kp;
 
 	list_for_each_entry_rcu(kp, &p->list, list) {
-		if (kp->pre_handler && !kprobe_gone(kp)) {
+		if (kp->pre_handler && likely(!kprobe_disabled(kp))) {
 			set_kprobe_instance(kp);
 			if (kp->pre_handler(kp, regs))
 				return 1;
@@ -344,7 +344,7 @@ static void __kprobes aggr_post_handler(
 	struct kprobe *kp;
 
 	list_for_each_entry_rcu(kp, &p->list, list) {
-		if (kp->post_handler && !kprobe_gone(kp)) {
+		if (kp->post_handler && likely(!kprobe_disabled(kp))) {
 			set_kprobe_instance(kp);
 			kp->post_handler(kp, regs, flags);
 			reset_kprobe_instance();
@@ -523,6 +523,7 @@ static inline void copy_kprobe(struct kp
 */
 static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 {
+	BUG_ON(kprobe_gone(ap) || kprobe_gone(p));
 	if (p->break_handler) {
 		if (ap->break_handler)
 			return -EEXIST;
@@ -532,6 +533,13 @@ static int __kprobes add_new_kprobe(stru
 		list_add_rcu(&p->list, &ap->list);
 	if (p->post_handler && !ap->post_handler)
 		ap->post_handler = aggr_post_handler;
+
+	if (kprobe_disabled(ap) && !kprobe_disabled(p)) {
+		ap->flags &= ~KPROBE_FLAG_DISABLED;
+		if (!kprobes_all_disarmed)
+			/* Arm the breakpoint again. */
+			arch_arm_kprobe(ap);
+	}
 	return 0;
 }
 
@@ -592,20 +600,36 @@ static int __kprobes register_aggr_kprob
 			 * freed by unregister_kprobe.
 			 */
 			return ret;
-		/* Clear gone flag to prevent allocating new slot again. */
-		ap->flags &= ~KPROBE_FLAG_GONE;
+
 		/*
-		 * If the old_p has gone, its breakpoint has been disarmed.
-		 * We have to arm it again after preparing real kprobes.
+		 * Clear gone flag to prevent allocating new slot again, and
+		 * set disabled flag because it is not armed yet.
 		 */
-		if (!kprobes_all_disarmed)
-			arch_arm_kprobe(ap);
+		ap->flags = (ap->flags & ~KPROBE_FLAG_GONE)
+			    | KPROBE_FLAG_DISABLED;
 	}
 
 	copy_kprobe(ap, p);
 	return add_new_kprobe(ap, p);
 }
 
+/* Try to disable aggr_kprobe, and return 1 if succeeded.*/
+static int __kprobes try_to_disable_aggr_kprobe(struct kprobe *p)
+{
+	struct kprobe *kp;
+
+	list_for_each_entry_rcu(kp, &p->list, list) {
+		if (!kprobe_disabled(kp))
+			/*
+			 * There is an active probe on the list.
+			 * We can't disable aggr_kprobe.
+			 */
+			return 0;
+	}
+	p->flags |= KPROBE_FLAG_DISABLED;
+	return 1;
+}
+
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
 	struct kprobe_blackpoint *kb;
@@ -664,7 +688,9 @@ int __kprobes register_kprobe(struct kpr
 		return -EINVAL;
 	}
 
-	p->flags = 0;
+	/* User can pass only KPROBE_FLAG_DISABLED to register_kprobe */
+	p->flags &= KPROBE_FLAG_DISABLED;
+
 	/*
 	 * Check if are we probing a module.
 	 */
@@ -709,7 +735,7 @@ int __kprobes register_kprobe(struct kpr
 	hlist_add_head_rcu(&p->hlist,
 		       &kprobe_table[hash_ptr(p->addr, KPROBE_HASH_BITS)]);
 
-	if (!kprobes_all_disarmed)
+	if (!kprobes_all_disarmed && !kprobe_disabled(p))
 		arch_arm_kprobe(p);
 
 out_unlock_text:
@@ -724,25 +750,37 @@ out:
 }
 EXPORT_SYMBOL_GPL(register_kprobe);
 
-/*
- * Unregister a kprobe without a scheduler synchronization.
- */
-static int __kprobes __unregister_kprobe_top(struct kprobe *p)
+/* Check passed kprobe is valid and return kprobe in kprobe_table. */
+static struct kprobe * __kprobes __get_valid_kprobe(struct kprobe *p)
 {
 	struct kprobe *old_p, *list_p;
 
 	old_p = get_kprobe(p->addr);
 	if (unlikely(!old_p))
-		return -EINVAL;
+		return NULL;
 
 	if (p != old_p) {
 		list_for_each_entry_rcu(list_p, &old_p->list, list)
 			if (list_p == p)
 			/* kprobe p is a valid probe */
-				goto valid_p;
-		return -EINVAL;
+				goto valid;
+		return NULL;
 	}
-valid_p:
+valid:
+	return old_p;
+}
+
+/*
+ * Unregister a kprobe without a scheduler synchronization.
+ */
+static int __kprobes __unregister_kprobe_top(struct kprobe *p)
+{
+	struct kprobe *old_p, *list_p;
+
+	old_p = __get_valid_kprobe(p);
+	if (old_p == NULL)
+		return -EINVAL;
+
 	if (old_p == p ||
 	    (old_p->pre_handler == aggr_pre_handler &&
 	     list_is_singular(&old_p->list))) {
@@ -751,7 +789,7 @@ valid_p:
 		 * enabled and not gone - otherwise, the breakpoint would
 		 * already have been removed. We save on flushing icache.
 		 */
-		if (!kprobes_all_disarmed && !kprobe_gone(old_p)) {
+		if (!kprobes_all_disarmed && !kprobe_disabled(old_p)) {
 			mutex_lock(&text_mutex);
 			arch_disarm_kprobe(p);
 			mutex_unlock(&text_mutex);
@@ -769,6 +807,11 @@ valid_p:
 		}
 noclean:
 		list_del_rcu(&p->list);
+		if (!kprobe_disabled(old_p)) {
+			try_to_disable_aggr_kprobe(old_p);
+			if (!kprobes_all_disarmed && kprobe_disabled(old_p))
+				arch_disarm_kprobe(old_p);
+		}
 	}
 	return 0;
 }
@@ -1078,6 +1121,7 @@ static int __kprobes pre_handler_kretpro
 static void __kprobes kill_kprobe(struct kprobe *p)
 {
 	struct kprobe *kp;
+
 	p->flags |= KPROBE_FLAG_GONE;
 	if (p->pre_handler == aggr_pre_handler) {
 		/*
@@ -1219,12 +1263,18 @@ static void __kprobes report_probe(struc
 	else
 		kprobe_type = "k";
 	if (sym)
-		seq_printf(pi, "%p  %s  %s+0x%x  %s %s\n", p->addr, kprobe_type,
-			sym, offset, (modname ? modname : " "),
-			(kprobe_gone(p) ? "[GONE]" : ""));
+		seq_printf(pi, "%p  %s  %s+0x%x  %s %s%s\n",
+			p->addr, kprobe_type, sym, offset,
+			(modname ? modname : " "),
+			(kprobe_gone(p) ? "[GONE]" : ""),
+			((kprobe_disabled(p) && !kprobe_gone(p)) ?
+			 "[DISABLED]" : ""));
 	else
-		seq_printf(pi, "%p  %s  %p %s\n", p->addr, kprobe_type, p->addr,
-			(kprobe_gone(p) ? "[GONE]" : ""));
+		seq_printf(pi, "%p  %s  %p %s%s\n",
+			p->addr, kprobe_type, p->addr,
+			(kprobe_gone(p) ? "[GONE]" : ""),
+			((kprobe_disabled(p) && !kprobe_gone(p)) ?
+			 "[DISABLED]" : ""));
 }
 
 static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
@@ -1289,6 +1339,71 @@ static struct file_operations debugfs_kp
 	.release        = seq_release,
 };
 
+/* Disable one kprobe */
+int __kprobes disable_kprobe(struct kprobe *kp)
+{
+	int ret = 0;
+	struct kprobe *p;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* Check whether specified probe is valid. */
+	p = __get_valid_kprobe(kp);
+	if (unlikely(p == NULL)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* If the probe is already disabled (or gone), just return */
+	if (kprobe_disabled(kp))
+		goto out;
+
+	kp->flags |= KPROBE_FLAG_DISABLED;
+	if (p != kp)
+		/* When kp != p, p is always enabled. */
+		try_to_disable_aggr_kprobe(p);
+
+	if (!kprobes_all_disarmed && kprobe_disabled(p))
+		arch_disarm_kprobe(p);
+out:
+	mutex_unlock(&kprobe_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(disable_kprobe);
+
+/* Enable one kprobe */
+int __kprobes enable_kprobe(struct kprobe *kp)
+{
+	int ret = 0;
+	struct kprobe *p;
+
+	mutex_lock(&kprobe_mutex);
+
+	/* Check whether specified probe is valid. */
+	p = __get_valid_kprobe(kp);
+	if (unlikely(p == NULL)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (kprobe_gone(kp)) {
+		/* This kprobe has gone, we couldn't enable it. */
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (!kprobes_all_disarmed && kprobe_disabled(p))
+		arch_arm_kprobe(p);
+
+	p->flags &= ~KPROBE_FLAG_DISABLED;
+	if (p != kp)
+		kp->flags &= ~KPROBE_FLAG_DISABLED;
+out:
+	mutex_unlock(&kprobe_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(enable_kprobe);
+
 static void __kprobes arm_all_kprobes(void)
 {
 	struct hlist_head *head;
@@ -1306,7 +1421,7 @@ static void __kprobes arm_all_kprobes(vo
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
-			if (!kprobe_gone(p))
+			if (!kprobe_disabled(p))
 				arch_arm_kprobe(p);
 	}
 	mutex_unlock(&text_mutex);
@@ -1338,7 +1453,7 @@ static void __kprobes disarm_all_kprobes
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
-			if (!arch_trampoline_kprobe(p) && !kprobe_gone(p))
+			if (!arch_trampoline_kprobe(p) && !kprobe_disabled(p))
 				arch_disarm_kprobe(p);
 		}
 	}
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch

