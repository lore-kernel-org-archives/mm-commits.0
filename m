From: akpm@linux-foundation.org
Subject: [merged] kprobes-cleanup-aggr_kprobe-related-code.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:15 -0700
Message-ID: <200904071907.n37J7FHM011201@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758830AbZDGTss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:48:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     kprobes: cleanup aggr_kprobe related code
has been removed from the -mm tree.  Its filename was
     kprobes-cleanup-aggr_kprobe-related-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: cleanup aggr_kprobe related code
From: Masami Hiramatsu <mhiramat@redhat.com>

Currently, kprobes can disable all probes at once, but can't disable it
individually (not unregister, just disable an kprobe, because
unregistering needs to wait for scheduler synchronization).  These patches
introduce APIs for on-the-fly per-probe disabling and re-enabling by
dis-arming/re-arming its breakpoint instruction.


This patch:

Change old_p to ap in add_new_kprobe() for readability, copy flags member
in add_aggr_kprobe(), and simplify the code flow of
register_aggr_kprobe().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   60 ++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

diff -puN kernel/kprobes.c~kprobes-cleanup-aggr_kprobe-related-code kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-cleanup-aggr_kprobe-related-code
+++ a/kernel/kprobes.c
@@ -518,20 +518,20 @@ static inline void copy_kprobe(struct kp
 }
 
 /*
-* Add the new probe to old_p->list. Fail if this is the
+* Add the new probe to ap->list. Fail if this is the
 * second jprobe at the address - two jprobes can't coexist
 */
-static int __kprobes add_new_kprobe(struct kprobe *old_p, struct kprobe *p)
+static int __kprobes add_new_kprobe(struct kprobe *ap, struct kprobe *p)
 {
 	if (p->break_handler) {
-		if (old_p->break_handler)
+		if (ap->break_handler)
 			return -EEXIST;
-		list_add_tail_rcu(&p->list, &old_p->list);
-		old_p->break_handler = aggr_break_handler;
+		list_add_tail_rcu(&p->list, &ap->list);
+		ap->break_handler = aggr_break_handler;
 	} else
-		list_add_rcu(&p->list, &old_p->list);
-	if (p->post_handler && !old_p->post_handler)
-		old_p->post_handler = aggr_post_handler;
+		list_add_rcu(&p->list, &ap->list);
+	if (p->post_handler && !ap->post_handler)
+		ap->post_handler = aggr_post_handler;
 	return 0;
 }
 
@@ -544,6 +544,7 @@ static inline void add_aggr_kprobe(struc
 	copy_kprobe(p, ap);
 	flush_insn_slot(ap);
 	ap->addr = p->addr;
+	ap->flags = p->flags;
 	ap->pre_handler = aggr_pre_handler;
 	ap->fault_handler = aggr_fault_handler;
 	/* We don't care the kprobe which has gone. */
@@ -566,44 +567,43 @@ static int __kprobes register_aggr_kprob
 					  struct kprobe *p)
 {
 	int ret = 0;
-	struct kprobe *ap;
+	struct kprobe *ap = old_p;
 
-	if (kprobe_gone(old_p)) {
+	if (old_p->pre_handler != aggr_pre_handler) {
+		/* If old_p is not an aggr_probe, create new aggr_kprobe. */
+		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
+		if (!ap)
+			return -ENOMEM;
+		add_aggr_kprobe(ap, old_p);
+	}
+
+	if (kprobe_gone(ap)) {
 		/*
 		 * Attempting to insert new probe at the same location that
 		 * had a probe in the module vaddr area which already
 		 * freed. So, the instruction slot has already been
 		 * released. We need a new slot for the new probe.
 		 */
-		ret = arch_prepare_kprobe(old_p);
+		ret = arch_prepare_kprobe(ap);
 		if (ret)
+			/*
+			 * Even if fail to allocate new slot, don't need to
+			 * free aggr_probe. It will be used next time, or
+			 * freed by unregister_kprobe.
+			 */
 			return ret;
-	}
-	if (old_p->pre_handler == aggr_pre_handler) {
-		copy_kprobe(old_p, p);
-		ret = add_new_kprobe(old_p, p);
-		ap = old_p;
-	} else {
-		ap = kzalloc(sizeof(struct kprobe), GFP_KERNEL);
-		if (!ap) {
-			if (kprobe_gone(old_p))
-				arch_remove_kprobe(old_p);
-			return -ENOMEM;
-		}
-		add_aggr_kprobe(ap, old_p);
-		copy_kprobe(ap, p);
-		ret = add_new_kprobe(ap, p);
-	}
-	if (kprobe_gone(old_p)) {
+		/* Clear gone flag to prevent allocating new slot again. */
+		ap->flags &= ~KPROBE_FLAG_GONE;
 		/*
 		 * If the old_p has gone, its breakpoint has been disarmed.
 		 * We have to arm it again after preparing real kprobes.
 		 */
-		ap->flags &= ~KPROBE_FLAG_GONE;
 		if (kprobe_enabled)
 			arch_arm_kprobe(ap);
 	}
-	return ret;
+
+	copy_kprobe(ap, p);
+	return add_new_kprobe(ap, p);
 }
 
 static int __kprobes in_kprobes_functions(unsigned long addr)
_

Patches currently in -mm which might be from mhiramat@redhat.com are

origin.patch

