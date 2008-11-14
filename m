From: akpm@linux-foundation.org
Subject: + kprobes-add-__kprobes-to-kprobe-internal-functions.patch added to -mm tree
Date: Thu, 13 Nov 2008 16:28:48 -0800
Message-ID: <200811140028.mAE0SmVc021440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755261AbYKNA32 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 19:29:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com


The patch titled
     kprobes: add __kprobes to kprobe internal functions
has been added to the -mm tree.  Its filename is
     kprobes-add-__kprobes-to-kprobe-internal-functions.patch

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
Subject: kprobes: add __kprobes to kprobe internal functions
From: Masami Hiramatsu <mhiramat@redhat.com>

Add __kprobes to kprobes internal functions for protecting from probing by
kprobes itself.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN kernel/kprobes.c~kprobes-add-__kprobes-to-kprobe-internal-functions kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-add-__kprobes-to-kprobe-internal-functions
+++ a/kernel/kprobes.c
@@ -410,7 +410,7 @@ void __kprobes recycle_rp_inst(struct kr
 		hlist_add_head(&ri->hlist, head);
 }
 
-void kretprobe_hash_lock(struct task_struct *tsk,
+void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
 			 struct hlist_head **head, unsigned long *flags)
 {
 	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
@@ -421,13 +421,15 @@ void kretprobe_hash_lock(struct task_str
 	spin_lock_irqsave(hlist_lock, *flags);
 }
 
-static void kretprobe_table_lock(unsigned long hash, unsigned long *flags)
+static void __kprobes kretprobe_table_lock(unsigned long hash,
+	unsigned long *flags)
 {
 	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	spin_lock_irqsave(hlist_lock, *flags);
 }
 
-void kretprobe_hash_unlock(struct task_struct *tsk, unsigned long *flags)
+void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
+	unsigned long *flags)
 {
 	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
 	spinlock_t *hlist_lock;
@@ -436,7 +438,7 @@ void kretprobe_hash_unlock(struct task_s
 	spin_unlock_irqrestore(hlist_lock, *flags);
 }
 
-void kretprobe_table_unlock(unsigned long hash, unsigned long *flags)
+void __kprobes kretprobe_table_unlock(unsigned long hash, unsigned long *flags)
 {
 	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	spin_unlock_irqrestore(hlist_lock, *flags);
@@ -762,7 +764,7 @@ static void __kprobes __unregister_kprob
 	}
 }
 
-static int __register_kprobes(struct kprobe **kps, int num,
+static int __kprobes __register_kprobes(struct kprobe **kps, int num,
 	unsigned long called_from)
 {
 	int i, ret = 0;
@@ -828,7 +830,7 @@ unsigned long __weak arch_deref_entry_po
 	return (unsigned long)entry;
 }
 
-static int __register_jprobes(struct jprobe **jps, int num,
+static int __kprobes __register_jprobes(struct jprobe **jps, int num,
 	unsigned long called_from)
 {
 	struct jprobe *jp;
@@ -990,7 +992,7 @@ static int __kprobes __register_kretprob
 	return ret;
 }
 
-static int __register_kretprobes(struct kretprobe **rps, int num,
+static int __kprobes __register_kretprobes(struct kretprobe **rps, int num,
 	unsigned long called_from)
 {
 	int ret = 0, i;
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

