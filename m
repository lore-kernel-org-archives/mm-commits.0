From: akpm@linux-foundation.org
Subject: + kprobes-add-unregister_kprobes-for-batch-registration.patch added to -mm tree
Date: Fri, 14 Mar 2008 14:06:19 -0700
Message-ID: <200803142106.m2EL6KK3019377@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754673AbYCNVIZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 17:08:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, davem@davemloft.net, fche@redhat.com, jkenisto@us.ibm.com, prasanna@in.ibm.com, shaohua.li@intel.com


The patch titled
     kprobes: add (un)register_kprobes for batch registration
has been added to the -mm tree.  Its filename is
     kprobes-add-unregister_kprobes-for-batch-registration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: add (un)register_kprobes for batch registration
From: Masami Hiramatsu <mhiramat@redhat.com>

Introduce unregister_/register_kprobes() for kprobe batch registration.  This
can reduce waiting time for synchronized_sched() when a lot of probes have to
be unregistered at once.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: David Miller <davem@davemloft.net>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |    9 ++
 kernel/kprobes.c        |  124 ++++++++++++++++++++++++++------------
 2 files changed, 96 insertions(+), 37 deletions(-)

diff -puN include/linux/kprobes.h~kprobes-add-unregister_kprobes-for-batch-registration include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-add-unregister_kprobes-for-batch-registration
+++ a/include/linux/kprobes.h
@@ -234,6 +234,8 @@ static inline struct kprobe_ctlblk *get_
 
 int register_kprobe(struct kprobe *p);
 void unregister_kprobe(struct kprobe *p);
+int register_kprobes(struct kprobe **kps, int num);
+void unregister_kprobes(struct kprobe **kps, int num);
 int setjmp_pre_handler(struct kprobe *, struct pt_regs *);
 int longjmp_break_handler(struct kprobe *, struct pt_regs *);
 int register_jprobe(struct jprobe *p);
@@ -261,9 +263,16 @@ static inline int register_kprobe(struct
 {
 	return -ENOSYS;
 }
+static inline int register_kprobes(struct kprobe **kps, int num)
+{
+	return -ENOSYS;
+}
 static inline void unregister_kprobe(struct kprobe *p)
 {
 }
+static inline void unregister_kprobes(struct kprobe **kps, int num)
+{
+}
 static inline int register_jprobe(struct jprobe *p)
 {
 	return -ENOSYS;
diff -puN kernel/kprobes.c~kprobes-add-unregister_kprobes-for-batch-registration kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-add-unregister_kprobes-for-batch-registration
+++ a/kernel/kprobes.c
@@ -580,6 +580,7 @@ static int __kprobes __register_kprobe(s
 	}
 
 	p->nmissed = 0;
+	INIT_LIST_HEAD(&p->list);
 	mutex_lock(&kprobe_mutex);
 	old_p = get_kprobe(p->addr);
 	if (old_p) {
@@ -606,35 +607,28 @@ out:
 	return ret;
 }
 
-int __kprobes register_kprobe(struct kprobe *p)
-{
-	return __register_kprobe(p, (unsigned long)__builtin_return_address(0));
-}
-
-void __kprobes unregister_kprobe(struct kprobe *p)
+/*
+ * Unregister a kprobe without a scheduler synchronization.
+ */
+static int __kprobes __unregister_kprobe_top(struct kprobe *p)
 {
-	struct module *mod;
 	struct kprobe *old_p, *list_p;
-	int cleanup_p;
 
-	mutex_lock(&kprobe_mutex);
 	old_p = get_kprobe(p->addr);
-	if (unlikely(!old_p)) {
-		mutex_unlock(&kprobe_mutex);
-		return;
-	}
+	if (unlikely(!old_p))
+		return -EINVAL;
+
 	if (p != old_p) {
 		list_for_each_entry_rcu(list_p, &old_p->list, list)
 			if (list_p == p)
 			/* kprobe p is a valid probe */
 				goto valid_p;
-		mutex_unlock(&kprobe_mutex);
-		return;
+		return -EINVAL;
 	}
 valid_p:
 	if (old_p == p ||
 	    (old_p->pre_handler == aggr_pre_handler &&
-	     p->list.next == &old_p->list && p->list.prev == &old_p->list)) {
+	     list_singleton(&old_p->list))) {
 		/*
 		 * Only probe on the hash list. Disarm only if kprobes are
 		 * enabled - otherwise, the breakpoint would already have
@@ -643,43 +637,97 @@ valid_p:
 		if (kprobe_enabled)
 			arch_disarm_kprobe(p);
 		hlist_del_rcu(&old_p->hlist);
-		cleanup_p = 1;
 	} else {
+		if (p->break_handler)
+			old_p->break_handler = NULL;
+		if (p->post_handler) {
+			list_for_each_entry_rcu(list_p, &old_p->list, list) {
+				if ((list_p != p) && (list_p->post_handler))
+					goto noclean;
+			}
+			old_p->post_handler = NULL;
+		}
+noclean:
 		list_del_rcu(&p->list);
-		cleanup_p = 0;
 	}
+	return 0;
+}
 
-	mutex_unlock(&kprobe_mutex);
+static void __kprobes __unregister_kprobe_bottom(struct kprobe *p)
+{
+	struct module *mod;
+	struct kprobe *old_p;
 
-	synchronize_sched();
 	if (p->mod_refcounted) {
 		mod = module_text_address((unsigned long)p->addr);
 		if (mod)
 			module_put(mod);
 	}
 
-	if (cleanup_p) {
-		if (p != old_p) {
-			list_del_rcu(&p->list);
+	if (list_empty(&p->list) || list_singleton(&p->list)) {
+		if (!list_empty(&p->list)) {
+			/* "p" is the last child of an aggr_kprobe */
+			old_p = list_entry(p->list.next, struct kprobe, list);
+			list_del(&p->list);
 			kfree(old_p);
 		}
 		arch_remove_kprobe(p);
-	} else {
-		mutex_lock(&kprobe_mutex);
-		if (p->break_handler)
-			old_p->break_handler = NULL;
-		if (p->post_handler){
-			list_for_each_entry_rcu(list_p, &old_p->list, list){
-				if (list_p->post_handler){
-					cleanup_p = 2;
-					break;
-				}
-			}
-			if (cleanup_p == 0)
-				old_p->post_handler = NULL;
+	}
+}
+
+static int __register_kprobes(struct kprobe **kps, int num,
+	unsigned long called_from)
+{
+	int i, ret = 0;
+
+	if (num <= 0)
+		return -EINVAL;
+	for (i = 0; i < num; i++) {
+		ret = __register_kprobe(kps[i], called_from);
+		if (ret < 0 && i > 0) {
+			unregister_kprobes(kps, i);
+			break;
 		}
-		mutex_unlock(&kprobe_mutex);
 	}
+	return ret;
+}
+
+/*
+ * Registration and unregistration functions for kprobe.
+ */
+int __kprobes register_kprobe(struct kprobe *p)
+{
+	return __register_kprobes(&p, 1,
+				  (unsigned long)__builtin_return_address(0));
+}
+
+void __kprobes unregister_kprobe(struct kprobe *p)
+{
+	unregister_kprobes(&p, 1);
+}
+
+int __kprobes register_kprobes(struct kprobe **kps, int num)
+{
+	return __register_kprobes(kps, num,
+				  (unsigned long)__builtin_return_address(0));
+}
+
+void __kprobes unregister_kprobes(struct kprobe **kps, int num)
+{
+	int i;
+
+	if (num <= 0)
+		return;
+	mutex_lock(&kprobe_mutex);
+	for (i = 0; i < num; i++)
+		if (__unregister_kprobe_top(kps[i]) < 0)
+			kps[i]->addr = NULL;
+	mutex_unlock(&kprobe_mutex);
+
+	synchronize_sched();
+	for (i = 0; i < num; i++)
+		if (kps[i]->addr)
+			__unregister_kprobe_bottom(kps[i]);
 }
 
 static struct notifier_block kprobe_exceptions_nb = {
@@ -1118,6 +1166,8 @@ module_init(init_kprobes);
 
 EXPORT_SYMBOL_GPL(register_kprobe);
 EXPORT_SYMBOL_GPL(unregister_kprobe);
+EXPORT_SYMBOL_GPL(register_kprobes);
+EXPORT_SYMBOL_GPL(unregister_kprobes);
 EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
 #ifdef CONFIG_KPROBES
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-kprobe-booster-for-ia64.patch
kprobes-kprobe-booster-for-ia64-fix.patch
listh-add-list_singleton.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch

