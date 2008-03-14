From: akpm@linux-foundation.org
Subject: + kprobes-add-unregister_jprobes-for-batch-registration.patch added to -mm tree
Date: Fri, 14 Mar 2008 14:06:39 -0700
Message-ID: <200803142106.m2EL6dUx019383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753590AbYCNVSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 17:18:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, davem@davemloft.net, fche@redhat.com, jkenisto@us.ibm.com, prasanna@in.ibm.com, shaohua.li@intel.com


The patch titled
     kprobes: add (un)register_jprobes for batch registration
has been added to the -mm tree.  Its filename is
     kprobes-add-unregister_jprobes-for-batch-registration.patch

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
Subject: kprobes: add (un)register_jprobes for batch registration
From: Masami Hiramatsu <mhiramat@redhat.com>

Introduce unregister_/register_jprobes() for jprobe batch registration.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: David Miller <davem@davemloft.net>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |    9 +++++
 kernel/kprobes.c        |   65 ++++++++++++++++++++++++++++++++------
 2 files changed, 65 insertions(+), 9 deletions(-)

diff -puN include/linux/kprobes.h~kprobes-add-unregister_jprobes-for-batch-registration include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-add-unregister_jprobes-for-batch-registration
+++ a/include/linux/kprobes.h
@@ -240,6 +240,8 @@ int setjmp_pre_handler(struct kprobe *, 
 int longjmp_break_handler(struct kprobe *, struct pt_regs *);
 int register_jprobe(struct jprobe *p);
 void unregister_jprobe(struct jprobe *p);
+int register_jprobes(struct jprobe **jps, int num);
+void unregister_jprobes(struct jprobe **jps, int num);
 void jprobe_return(void);
 unsigned long arch_deref_entry_point(void *);
 
@@ -279,9 +281,16 @@ static inline int register_jprobe(struct
 {
 	return -ENOSYS;
 }
+static inline int register_jprobes(struct jprobe **jps, int num)
+{
+	return -ENOSYS;
+}
 static inline void unregister_jprobe(struct jprobe *p)
 {
 }
+static inline void unregister_jprobes(struct jprobe **jps, int num)
+{
+}
 static inline void jprobe_return(void)
 {
 }
diff -puN kernel/kprobes.c~kprobes-add-unregister_jprobes-for-batch-registration kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-add-unregister_jprobes-for-batch-registration
+++ a/kernel/kprobes.c
@@ -755,24 +755,69 @@ unsigned long __weak arch_deref_entry_po
 	return (unsigned long)entry;
 }
 
-int __kprobes register_jprobe(struct jprobe *jp)
+static int __register_jprobes(struct jprobe **jps, int num,
+	unsigned long called_from)
 {
-	unsigned long addr = arch_deref_entry_point(jp->entry);
+	struct jprobe *jp;
+	int ret = 0, i;
 
-	if (!kernel_text_address(addr))
+	if (num <= 0)
 		return -EINVAL;
+	for (i = 0; i < num; i++) {
+		unsigned long addr;
+		jp = jps[i];
+		addr = arch_deref_entry_point(jp->entry);
+
+		if (!kernel_text_address(addr))
+			ret = -EINVAL;
+		else {
+			/* Todo: Verify probepoint is a function entry point */
+			jp->kp.pre_handler = setjmp_pre_handler;
+			jp->kp.break_handler = longjmp_break_handler;
+			ret = __register_kprobe(&jp->kp, called_from);
+		}
+		if (ret < 0 && i > 0) {
+			unregister_jprobes(jps, i);
+			break;
+		}
+	}
+	return ret;
+}
 
-	/* Todo: Verify probepoint is a function entry point */
-	jp->kp.pre_handler = setjmp_pre_handler;
-	jp->kp.break_handler = longjmp_break_handler;
-
-	return __register_kprobe(&jp->kp,
+int __kprobes register_jprobe(struct jprobe *jp)
+{
+	return __register_jprobes(&jp, 1,
 		(unsigned long)__builtin_return_address(0));
 }
 
 void __kprobes unregister_jprobe(struct jprobe *jp)
 {
-	unregister_kprobe(&jp->kp);
+	unregister_jprobes(&jp, 1);
+}
+
+int __kprobes register_jprobes(struct jprobe **jps, int num)
+{
+	return __register_jprobes(jps, num,
+		(unsigned long)__builtin_return_address(0));
+}
+
+void __kprobes unregister_jprobes(struct jprobe **jps, int num)
+{
+	int i;
+
+	if (num <= 0)
+		return;
+	mutex_lock(&kprobe_mutex);
+	for (i = 0; i < num; i++)
+		if (__unregister_kprobe_top(&jps[i]->kp) < 0)
+			jps[i]->kp.addr = NULL;
+	mutex_unlock(&kprobe_mutex);
+
+	synchronize_sched();
+	for (i = 0; i < num; i++) {
+		if (jps[i]->kp.addr)
+			__unregister_kprobe_bottom(&jps[i]->kp);
+	}
 }
 
 #ifdef CONFIG_KRETPROBES
@@ -1236,6 +1281,8 @@ EXPORT_SYMBOL_GPL(register_kprobes);
 EXPORT_SYMBOL_GPL(unregister_kprobes);
 EXPORT_SYMBOL_GPL(register_jprobe);
 EXPORT_SYMBOL_GPL(unregister_jprobe);
+EXPORT_SYMBOL_GPL(register_jprobes);
+EXPORT_SYMBOL_GPL(unregister_jprobes);
 #ifdef CONFIG_KPROBES
 EXPORT_SYMBOL_GPL(jprobe_return);
 #endif
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-kprobe-booster-for-ia64.patch
kprobes-kprobe-booster-for-ia64-fix.patch
listh-add-list_singleton.patch
kprobes-add-unregister_kprobes-for-batch-registration.patch
kprobes-add-unregister_kretprobes-for-batch-registration.patch
kprobes-add-unregister_jprobes-for-batch-registration.patch
kprobes-update-document-about-batch-registration.patch

