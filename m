From: akpm@linux-foundation.org
Subject: - kprobes-remove-called_from-argument.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:18:08 -0800
Message-ID: <200901072218.n07MI8dO017625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755718AbZAGWTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:19:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: remove called_from argument
has been removed from the -mm tree.  Its filename was
     kprobes-remove-called_from-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: remove called_from argument
From: Masami Hiramatsu <mhiramat@redhat.com>

Remove called_from argument from kprobes which had been used for
preventing self-refering of kernel module.  However, since we don't keep
module's refcount after registering kprobe any more, there is no reason to
check that.

This patch also simplifies registering/unregistering functions because we
don't need to use __builtin_return_address(0) which was passed to
called_from.

[ananth@in.ibm.com: build fix]
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   72 ++++++++-------------------------------------
 1 file changed, 14 insertions(+), 58 deletions(-)

diff -puN kernel/kprobes.c~kprobes-remove-called_from-argument kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-remove-called_from-argument
+++ a/kernel/kprobes.c
@@ -644,8 +644,7 @@ static kprobe_opcode_t __kprobes *kprobe
 	return (kprobe_opcode_t *)(((char *)addr) + p->offset);
 }
 
-static int __kprobes __register_kprobe(struct kprobe *p,
-	unsigned long called_from)
+int __kprobes register_kprobe(struct kprobe *p)
 {
 	int ret = 0;
 	struct kprobe *old_p;
@@ -670,19 +669,14 @@ static int __kprobes __register_kprobe(s
 	 */
 	probed_mod = __module_text_address((unsigned long) p->addr);
 	if (probed_mod) {
-		struct module *calling_mod;
-		calling_mod = __module_text_address(called_from);
 		/*
 		 * We must hold a refcount of the probed module while updating
 		 * its code to prohibit unexpected unloading.
 		 */
-		if (calling_mod != probed_mod) {
-			if (unlikely(!try_module_get(probed_mod))) {
-				preempt_enable();
-				return -EINVAL;
-			}
-		} else
-			probed_mod = NULL;
+		if (unlikely(!try_module_get(probed_mod))) {
+			preempt_enable();
+			return -EINVAL;
+		}
 	}
 	preempt_enable();
 
@@ -776,15 +770,14 @@ static void __kprobes __unregister_kprob
 	}
 }
 
-static int __kprobes __register_kprobes(struct kprobe **kps, int num,
-	unsigned long called_from)
+int __kprobes register_kprobes(struct kprobe **kps, int num)
 {
 	int i, ret = 0;
 
 	if (num <= 0)
 		return -EINVAL;
 	for (i = 0; i < num; i++) {
-		ret = __register_kprobe(kps[i], called_from);
+		ret = register_kprobe(kps[i]);
 		if (ret < 0) {
 			if (i > 0)
 				unregister_kprobes(kps, i);
@@ -794,26 +787,11 @@ static int __kprobes __register_kprobes(
 	return ret;
 }
 
-/*
- * Registration and unregistration functions for kprobe.
- */
-int __kprobes register_kprobe(struct kprobe *p)
-{
-	return __register_kprobes(&p, 1,
-				  (unsigned long)__builtin_return_address(0));
-}
-
 void __kprobes unregister_kprobe(struct kprobe *p)
 {
 	unregister_kprobes(&p, 1);
 }
 
-int __kprobes register_kprobes(struct kprobe **kps, int num)
-{
-	return __register_kprobes(kps, num,
-				  (unsigned long)__builtin_return_address(0));
-}
-
 void __kprobes unregister_kprobes(struct kprobe **kps, int num)
 {
 	int i;
@@ -842,8 +820,7 @@ unsigned long __weak arch_deref_entry_po
 	return (unsigned long)entry;
 }
 
-static int __kprobes __register_jprobes(struct jprobe **jps, int num,
-	unsigned long called_from)
+int __kprobes register_jprobes(struct jprobe **jps, int num)
 {
 	struct jprobe *jp;
 	int ret = 0, i;
@@ -861,7 +838,7 @@ static int __kprobes __register_jprobes(
 			/* Todo: Verify probepoint is a function entry point */
 			jp->kp.pre_handler = setjmp_pre_handler;
 			jp->kp.break_handler = longjmp_break_handler;
-			ret = __register_kprobe(&jp->kp, called_from);
+			ret = register_kprobe(&jp->kp);
 		}
 		if (ret < 0) {
 			if (i > 0)
@@ -874,8 +851,7 @@ static int __kprobes __register_jprobes(
 
 int __kprobes register_jprobe(struct jprobe *jp)
 {
-	return __register_jprobes(&jp, 1,
-		(unsigned long)__builtin_return_address(0));
+	return register_jprobes(&jp, 1);
 }
 
 void __kprobes unregister_jprobe(struct jprobe *jp)
@@ -883,12 +859,6 @@ void __kprobes unregister_jprobe(struct 
 	unregister_jprobes(&jp, 1);
 }
 
-int __kprobes register_jprobes(struct jprobe **jps, int num)
-{
-	return __register_jprobes(jps, num,
-		(unsigned long)__builtin_return_address(0));
-}
-
 void __kprobes unregister_jprobes(struct jprobe **jps, int num)
 {
 	int i;
@@ -951,8 +921,7 @@ static int __kprobes pre_handler_kretpro
 	return 0;
 }
 
-static int __kprobes __register_kretprobe(struct kretprobe *rp,
-					  unsigned long called_from)
+int __kprobes register_kretprobe(struct kretprobe *rp)
 {
 	int ret = 0;
 	struct kretprobe_instance *inst;
@@ -998,21 +967,20 @@ static int __kprobes __register_kretprob
 
 	rp->nmissed = 0;
 	/* Establish function entry probe point */
-	ret = __register_kprobe(&rp->kp, called_from);
+	ret = register_kprobe(&rp->kp);
 	if (ret != 0)
 		free_rp_inst(rp);
 	return ret;
 }
 
-static int __kprobes __register_kretprobes(struct kretprobe **rps, int num,
-	unsigned long called_from)
+int __kprobes register_kretprobes(struct kretprobe **rps, int num)
 {
 	int ret = 0, i;
 
 	if (num <= 0)
 		return -EINVAL;
 	for (i = 0; i < num; i++) {
-		ret = __register_kretprobe(rps[i], called_from);
+		ret = register_kretprobe(rps[i]);
 		if (ret < 0) {
 			if (i > 0)
 				unregister_kretprobes(rps, i);
@@ -1022,23 +990,11 @@ static int __kprobes __register_kretprob
 	return ret;
 }
 
-int __kprobes register_kretprobe(struct kretprobe *rp)
-{
-	return __register_kretprobes(&rp, 1,
-			(unsigned long)__builtin_return_address(0));
-}
-
 void __kprobes unregister_kretprobe(struct kretprobe *rp)
 {
 	unregister_kretprobes(&rp, 1);
 }
 
-int __kprobes register_kretprobes(struct kretprobe **rps, int num)
-{
-	return __register_kretprobes(rps, num,
-			(unsigned long)__builtin_return_address(0));
-}
