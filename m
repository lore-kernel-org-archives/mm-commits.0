From: akpm@linux-foundation.org
Subject: + kprobes-support-probing-module-__exit-function.patch added to -mm tree
Date: Thu, 13 Nov 2008 16:28:50 -0800
Message-ID: <200811140028.mAE0SppC021444@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48981 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755078AbYKNA3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 19:29:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com


The patch titled
     kprobes: support probing module __exit function
has been added to the -mm tree.  Its filename is
     kprobes-support-probing-module-__exit-function.patch

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
Subject: kprobes: support probing module __exit function
From: Masami Hiramatsu <mhiramat@redhat.com>

Allows kprobes to probe __exit routine.  This adds flags member to struct
kprobe.  When module is freed(kprobes hooks module_notifier to get this
event), kprobes which probe the functions in that module are set to "Gone"
flag to the flags member.  These "Gone" probes are never be enabled. 
Users can check the GONE flag through debugfs.

This also removes mod_refcounted, because we couldn't free a module if
kprobe incremented the refcount of that module.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kprobes.txt |    5 +
 include/linux/kprobes.h   |   14 ++-
 kernel/kprobes.c          |  140 +++++++++++++++++++++++++++---------
 3 files changed, 123 insertions(+), 36 deletions(-)

diff -puN Documentation/kprobes.txt~kprobes-support-probing-module-__exit-function Documentation/kprobes.txt
--- a/Documentation/kprobes.txt~kprobes-support-probing-module-__exit-function
+++ a/Documentation/kprobes.txt
@@ -497,7 +497,10 @@ The first column provides the kernel add
 The second column identifies the type of probe (k - kprobe, r - kretprobe
 and j - jprobe), while the third column specifies the symbol+offset of
 the probe. If the probed function belongs to a module, the module name
-is also specified.
+is also specified. Following columns show probe status. If the probe is on
+a virtual address that is no longer valid (module init sections, module
+virtual addresses that correspond to modules that've been unloaded),
+such probes are marked with [GONE].
 
 /debug/kprobes/enabled: Turn kprobes ON/OFF
 
diff -puN include/linux/kprobes.h~kprobes-support-probing-module-__exit-function include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-support-probing-module-__exit-function
+++ a/include/linux/kprobes.h
@@ -69,9 +69,6 @@ struct kprobe {
 	/* list of kprobes for multi-handler support */
 	struct list_head list;
 
-	/* Indicates that the corresponding module has been ref counted */
-	unsigned int mod_refcounted;
-
 	/*count the number of times this probe was temporarily disarmed */
 	unsigned long nmissed;
 
@@ -103,8 +100,19 @@ struct kprobe {
 
 	/* copy of the original instruction */
 	struct arch_specific_insn ainsn;
+
+	/* Indicates various status flags */
+	u32 flags;
 };
 
+/* Kprobe status flags */
+#define KPROBE_FLAG_GONE	1 /* breakpoint has already gone */
+
+static inline int kprobe_gone(struct kprobe *p)
+{
+	return p->flags & KPROBE_FLAG_GONE;
+}
+
 /*
  * Special probe type that uses setjmp-longjmp type tricks to resume
  * execution at a specified entry with a matching prototype corresponding
diff -puN kernel/kprobes.c~kprobes-support-probing-module-__exit-function kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-support-probing-module-__exit-function
+++ a/kernel/kprobes.c
@@ -327,7 +327,7 @@ static int __kprobes aggr_pre_handler(st
 	struct kprobe *kp;
 
 	list_for_each_entry_rcu(kp, &p->list, list) {
-		if (kp->pre_handler) {
+		if (kp->pre_handler && !kprobe_gone(kp)) {
 			set_kprobe_instance(kp);
 			if (kp->pre_handler(kp, regs))
 				return 1;
@@ -343,7 +343,7 @@ static void __kprobes aggr_post_handler(
 	struct kprobe *kp;
 
 	list_for_each_entry_rcu(kp, &p->list, list) {
-		if (kp->post_handler) {
+		if (kp->post_handler && !kprobe_gone(kp)) {
 			set_kprobe_instance(kp);
 			kp->post_handler(kp, regs, flags);
 			reset_kprobe_instance();
@@ -545,9 +545,10 @@ static inline void add_aggr_kprobe(struc
 	ap->addr = p->addr;
 	ap->pre_handler = aggr_pre_handler;
 	ap->fault_handler = aggr_fault_handler;
-	if (p->post_handler)
+	/* We don't care the kprobe which has gone. */
+	if (p->post_handler && !kprobe_gone(p))
 		ap->post_handler = aggr_post_handler;
-	if (p->break_handler)
+	if (p->break_handler && !kprobe_gone(p))
 		ap->break_handler = aggr_break_handler;
 
 	INIT_LIST_HEAD(&ap->list);
@@ -566,9 +567,21 @@ static int __kprobes register_aggr_kprob
 	int ret = 0;
 	struct kprobe *ap;
 
+	if (kprobe_gone(old_p)) {
+		/*
+		 * Attempting to insert new probe at the same location that
+		 * had a probe in the module vaddr area which already
+		 * freed. So, the instruction slot has already been
+		 * released. We need a new slot for the new probe.
+		 */
+		ret = arch_prepare_kprobe(old_p);
+		if (ret)
+			return ret;
+	}
 	if (old_p->pre_handler == aggr_pre_handler) {
 		copy_kprobe(old_p, p);
 		ret = add_new_kprobe(old_p, p);
+		ap = old_p;
 	} else {
 		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
 		if (!ap)
@@ -577,6 +590,15 @@ static int __kprobes register_aggr_kprob
 		copy_kprobe(ap, p);
 		ret = add_new_kprobe(ap, p);
 	}
+	if (kprobe_gone(old_p)) {
+		/*
+		 * If the old_p has gone, its breakpoint has been disarmed.
+		 * We have to arm it again after preparing real kprobes.
+		 */
+		ap->flags &= ~KPROBE_FLAG_GONE;
+		if (kprobe_enabled)
+			arch_arm_kprobe(ap);
+	}
 	return ret;
 }
 
@@ -639,8 +661,7 @@ static int __kprobes __register_kprobe(s
 		return -EINVAL;
 	}
 
-	p->mod_refcounted = 0;
-
+	p->flags = 0;
 	/*
 	 * Check if are we probing a module.
 	 */
@@ -649,16 +670,14 @@ static int __kprobes __register_kprobe(s
 		struct module *calling_mod;
 		calling_mod = __module_text_address(called_from);
 		/*
-		 * We must allow modules to probe themself and in this case
-		 * avoid incrementing the module refcount, so as to allow
-		 * unloading of self probing modules.
+		 * We must hold a refcount of the probed module while updating
+		 * its code to prohibit unexpected unloading.
 		 */
 		if (calling_mod != probed_mod) {
 			if (unlikely(!try_module_get(probed_mod))) {
 				preempt_enable();
 				return -EINVAL;
 			}
-			p->mod_refcounted = 1;
 		} else
 			probed_mod = NULL;
 	}
@@ -687,8 +706,9 @@ static int __kprobes __register_kprobe(s
 out:
 	mutex_unlock(&kprobe_mutex);
 
-	if (ret && probed_mod)
+	if (probed_mod)
 		module_put(probed_mod);
+
 	return ret;
 }
 
@@ -716,16 +736,16 @@ valid_p:
 	     list_is_singular(&old_p->list))) {
 		/*
 		 * Only probe on the hash list. Disarm only if kprobes are
-		 * enabled - otherwise, the breakpoint would already have
-		 * been removed. We save on flushing icache.
+		 * enabled and not gone - otherwise, the breakpoint would
+		 * already have been removed. We save on flushing icache.
 		 */
-		if (kprobe_enabled)
+		if (kprobe_enabled && !kprobe_gone(old_p))
 			arch_disarm_kprobe(p);
 		hlist_del_rcu(&old_p->hlist);
 	} else {
-		if (p->break_handler)
+		if (p->break_handler && !kprobe_gone(p))
 			old_p->break_handler = NULL;
-		if (p->post_handler) {
+		if (p->post_handler && !kprobe_gone(p)) {
 			list_for_each_entry_rcu(list_p, &old_p->list, list) {
 				if ((list_p != p) && (list_p->post_handler))
 					goto noclean;
@@ -740,19 +760,8 @@ noclean:
 
 static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
 {
-	struct module *mod;
 	struct kprobe *old_p;
 
-	if (p->mod_refcounted) {
-		/*
-		 * Since we've already incremented refcount,
-		 * we don't need to disable preemption.
-		 */
-		mod = module_text_address((unsigned long)p->addr);
-		if (mod)
-			module_put(mod);
-	}
-
 	if (list_empty(&p->list) || list_is_singular(&p->list)) {
 		if (!list_empty(&p->list)) {
 			/* "p" is the last child of an aggr_kprobe */
@@ -1074,6 +1083,67 @@ static int __kprobes pre_handler_kretpro
 
 #endif /* CONFIG_KRETPROBES */
 
+/* Set the kprobe gone and remove its instruction buffer. */
+static void __kprobes kill_kprobe(struct kprobe *p)
+{
+	struct kprobe *kp;
+	p->flags |= KPROBE_FLAG_GONE;
+	if (p->pre_handler == aggr_pre_handler) {
+		/*
+		 * If this is an aggr_kprobe, we have to list all the
+		 * chained probes and mark them GONE.
+		 */
+		list_for_each_entry_rcu(kp, &p->list, list)
+			kp->flags |= KPROBE_FLAG_GONE;
+		p->post_handler = NULL;
+		p->break_handler = NULL;
+	}
+	/*
+	 * Here, we can remove insn_slot safely, because no thread calls
+	 * the original probed function (which will be freed soon) any more.
+	 */
+	arch_remove_kprobe(p);
+}
+
+/* Module notifier call back, checking kprobes on the module */
+static int __kprobes kprobes_module_callback(struct notifier_block *nb,
+					     unsigned long val, void *data)
+{
+	struct module *mod = data;
+	struct hlist_head *head;
+	struct hlist_node *node;
+	struct kprobe *p;
+	unsigned int i;
+
+	if (val != MODULE_STATE_GOING)
+		return NOTIFY_DONE;
+
+	/*
+	 * module .text section will be freed. We need to
+	 * disable kprobes which have been inserted in the section.
+	 */
+	mutex_lock(&kprobe_mutex);
+	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
+		head = &kprobe_table[i];
+		hlist_for_each_entry_rcu(p, node, head, hlist)
+			if (within_module_core((unsigned long)p->addr, mod)) {
+				/*
+				 * The vaddr this probe is installed will soon
+				 * be vfreed buy not synced to disk. Hence,
+				 * disarming the breakpoint isn't needed.
+				 */
+				kill_kprobe(p);
+			}
+	}
+	mutex_unlock(&kprobe_mutex);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block kprobe_module_nb = {
+	.notifier_call = kprobes_module_callback,
+	.priority = 0
+};
+
 static int __init init_kprobes(void)
 {
 	int i, err = 0;
@@ -1130,6 +1200,9 @@ static int __init init_kprobes(void)
 	err = arch_init_kprobes();
 	if (!err)
 		err = register_die_notifier(&kprobe_exceptions_nb);
+	if (!err)
+		err = register_module_notifier(&kprobe_module_nb);
+
 	kprobes_initialized = (err == 0);
 
 	if (!err)
@@ -1150,10 +1223,12 @@ static void __kprobes report_probe(struc
 	else
 		kprobe_type = "k";
 	if (sym)
-		seq_printf(pi, "%p  %s  %s+0x%x  %s\n", p->addr, kprobe_type,
-			sym, offset, (modname ? modname : " "));
+		seq_printf(pi, "%p  %s  %s+0x%x  %s %s\n", p->addr, kprobe_type,
+			sym, offset, (modname ? modname : " "),
+			(kprobe_gone(p) ? "[GONE]" : ""));
 	else
-		seq_printf(pi, "%p  %s  %p\n", p->addr, kprobe_type, p->addr);
+		seq_printf(pi, "%p  %s  %p %s\n", p->addr, kprobe_type, p->addr,
+			(kprobe_gone(p) ? "[GONE]" : ""));
 }
 
 static void __kprobes *kprobe_seq_start(struct seq_file *f, loff_t *pos)
@@ -1234,7 +1309,8 @@ static void __kprobes enable_all_kprobes
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist)
-			arch_arm_kprobe(p);
+			if (!kprobe_gone(p))
+				arch_arm_kprobe(p);
 	}
 
 	kprobe_enabled = true;
@@ -1263,7 +1339,7 @@ static void __kprobes disable_all_kprobe
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		head = &kprobe_table[i];
 		hlist_for_each_entry_rcu(p, node, head, hlist) {
-			if (!arch_trampoline_kprobe(p))
+			if (!arch_trampoline_kprobe(p) && !kprobe_gone(p))
 				arch_disarm_kprobe(p);
 		}
 	}
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch
kprobes-bugfix-try_module_get-even-if-calling_mod-is-null.patch
kprobes-indirectly-call-kprobe_target.patch
kprobes-add-tests-for-register_kprobes.patch
module-add-within_module_core-and-within_module_init.patch
kprobes-add-kprobe_insn_mutex-and-cleanup-arch_remove_kprobe.patch
kprobes-add-__kprobes-to-kprobe-internal-functions.patch
kprobes-support-probing-module-__exit-function.patch
kprobes-support-probing-module-__exit-function-fix.patch
kprobes-remove-called_from-argument.patch
kprobes-remove-called_from-argument-fix.patch
module-add-module_state_live-notify.patch
kprobes-support-probing-module-__init-function.patch

