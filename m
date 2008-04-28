From: akpm@linux-foundation.org
Subject: - kprobes-add-unregister_kretprobes-for-batch-registration.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:56:16 -0700
Message-ID: <200804282156.m3SLuG0r018206@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965081AbYD1V5C (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, davem@davemloft.net, fche@redhat.com, jkenisto@us.ibm.com, prasanna@in.ibm.com, shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: add (un)register_kretprobes for batch registration
has been removed from the -mm tree.  Its filename was
     kprobes-add-unregister_kretprobes-for-batch-registration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: add (un)register_kretprobes for batch registration
From: Masami Hiramatsu <mhiramat@redhat.com>

Introduce unregister_/register_kretprobes() for kretprobe batch registration.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: David Miller <davem@davemloft.net>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |    9 +++
 kernel/kprobes.c        |  108 ++++++++++++++++++++++++++++++--------
 2 files changed, 97 insertions(+), 20 deletions(-)

diff -puN include/linux/kprobes.h~kprobes-add-unregister_kretprobes-for-batch-registration include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-add-unregister_kretprobes-for-batch-registration
+++ a/include/linux/kprobes.h
@@ -245,6 +245,8 @@ unsigned long arch_deref_entry_point(voi
 
 int register_kretprobe(struct kretprobe *rp);
 void unregister_kretprobe(struct kretprobe *rp);
+int register_kretprobes(struct kretprobe **rps, int num);
+void unregister_kretprobes(struct kretprobe **rps, int num);
 
 void kprobe_flush_task(struct task_struct *tk);
 void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
@@ -287,9 +289,16 @@ static inline int register_kretprobe(str
 {
 	return -ENOSYS;
 }
+static inline int register_kretprobes(struct kretprobe **rps, int num)
+{
+	return -ENOSYS;
+}
 static inline void unregister_kretprobe(struct kretprobe *rp)
 {
 }
+static inline void unregister_kretprobes(struct kretprobe **rps, int num)
+{
+}
 static inline void kprobe_flush_task(struct task_struct *tk)
 {
 }
diff -puN kernel/kprobes.c~kprobes-add-unregister_kretprobes-for-batch-registration kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-add-unregister_kretprobes-for-batch-registration
+++ a/kernel/kprobes.c
@@ -429,6 +429,21 @@ static inline void free_rp_inst(struct k
 	}
 }
 
+static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
+{
+	unsigned long flags;
+	struct kretprobe_instance *ri;
+	struct hlist_node *pos, *next;
+	/* No race here */
+	spin_lock_irqsave(&kretprobe_lock, flags);
+	hlist_for_each_entry_safe(ri, pos, next, &rp->used_instances, uflist) {
+		ri->rp = NULL;
+		hlist_del(&ri->uflist);
+	}
+	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	free_rp_inst(rp);
+}
+
 /*
  * Keep all fields in the kprobe consistent
  */
@@ -798,7 +813,8 @@ static int __kprobes pre_handler_kretpro
 	return 0;
 }
 
-int __kprobes register_kretprobe(struct kretprobe *rp)
+static int __kprobes __register_kretprobe(struct kretprobe *rp,
+					  unsigned long called_from)
 {
 	int ret = 0;
 	struct kretprobe_instance *inst;
@@ -844,43 +860,93 @@ int __kprobes register_kretprobe(struct 
 
 	rp->nmissed = 0;
 	/* Establish function entry probe point */
-	if ((ret = __register_kprobe(&rp->kp,
-		(unsigned long)__builtin_return_address(0))) != 0)
+	ret = __register_kprobe(&rp->kp, called_from);
+	if (ret != 0)
 		free_rp_inst(rp);
 	return ret;
 }
 
+static int __register_kretprobes(struct kretprobe **rps, int num,
+	unsigned long called_from)
+{
+	int ret = 0, i;
+
+	if (num <= 0)
+		return -EINVAL;
+	for (i = 0; i < num; i++) {
+		ret = __register_kretprobe(rps[i], called_from);
+		if (ret < 0 && i > 0) {
+			unregister_kretprobes(rps, i);
+			break;
+		}
+	}
+	return ret;
+}
+
+int __kprobes register_kretprobe(struct kretprobe *rp)
+{
+	return __register_kretprobes(&rp, 1,
+			(unsigned long)__builtin_return_address(0));
+}
+
+void __kprobes unregister_kretprobe(struct kretprobe *rp)
+{
+	unregister_kretprobes(&rp, 1);
+}
+
+int __kprobes register_kretprobes(struct kretprobe **rps, int num)
+{
+	return __register_kretprobes(rps, num,
+			(unsigned long)__builtin_return_address(0));
+}
+
+void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
+{
+	int i;
+
+	if (num <= 0)
+		return;
+	mutex_lock(&kprobe_mutex);
+	for (i = 0; i < num; i++)
+		if (__unregister_kprobe_top(&rps[i]->kp) < 0)
+			rps[i]->kp.addr = NULL;
+	mutex_unlock(&kprobe_mutex);
+
+	synchronize_sched();
+	for (i = 0; i < num; i++) {
+		if (rps[i]->kp.addr) {
+			__unregister_kprobe_bottom(&rps[i]->kp);
+			cleanup_rp_inst(rps[i]);
+		}
+	}
+}
+
 #else /* CONFIG_KRETPROBES */
 int __kprobes register_kretprobe(struct kretprobe *rp)
 {
 	return -ENOSYS;
 }
 
-static int __kprobes pre_handler_kretprobe(struct kprobe *p,
-					   struct pt_regs *regs)
+int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 {
-	return 0;
+	return -ENOSYS;
 }
-#endif /* CONFIG_KRETPROBES */
-
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
-	unsigned long flags;
-	struct kretprobe_instance *ri;
-	struct hlist_node *pos, *next;
+}
 
-	unregister_kprobe(&rp->kp);
+void __kprobes unregister_kretprobes(struct kretprobe **rps, int num)
+{
+}
 
-	/* No race here */
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	hlist_for_each_entry_safe(ri, pos, next, &rp->used_instances, uflist) {
-		ri->rp = NULL;
-		hlist_del(&ri->uflist);
-	}
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-	free_rp_inst(rp);
+static int __kprobes pre_handler_kretprobe(struct kprobe *p,
+					   struct pt_regs *regs)
+{
+	return 0;
 }
 
+#endif /* CONFIG_KRETPROBES */
+
 static int __init init_kprobes(void)
 {
 	int i, err = 0;
@@ -1177,4 +1243,6 @@ EXPORT_SYMBOL_GPL(jprobe_return);
 #ifdef CONFIG_KPROBES
 EXPORT_SYMBOL_GPL(register_kretprobe);
 EXPORT_SYMBOL_GPL(unregister_kretprobe);
+EXPORT_SYMBOL_GPL(register_kretprobes);
+EXPORT_SYMBOL_GPL(unregister_kretprobes);
 #endif
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch
relayfs-support-larger-relay-buffer-take-3.patch
relayfs-support-larger-relay-buffer-take-3-cleanup.patch

