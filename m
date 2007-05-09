From: akpm@linux-foundation.org
Subject: - kprobes-kretprobes-simplifcations.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:49 -0700
Message-ID: <200705090254.l492snJA009846@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57605 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032298AbXEICzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: kretprobes simplifications
has been removed from the -mm tree.  Its filename was
     kprobes-kretprobes-simplifcations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kprobes: kretprobes simplifications
From: Christoph Hellwig <hch@lst.de>

 - consolidate duplicate code in all arch_prepare_kretprobe instances
   into common code
 - replace various odd helpers that use hlist_for_each_entry to get
   the first elemenet of a list with either a hlist_for_each_entry_save
   or an opencoded access to the first element in the caller
 - inline add_rp_inst into it's only remaining caller
 - use kretprobe_inst_table_head instead of opencoding it

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/kprobes.c    |   17 ++------
 arch/ia64/kernel/kprobes.c    |   18 ++-------
 arch/powerpc/kernel/kprobes.c |   17 ++------
 arch/s390/kernel/kprobes.c    |   18 ++-------
 arch/x86_64/kernel/kprobes.c  |   17 ++------
 include/linux/kprobes.h       |    5 +-
 kernel/kprobes.c              |   64 ++++++++++----------------------
 7 files changed, 43 insertions(+), 113 deletions(-)

diff -puN arch/i386/kernel/kprobes.c~kprobes-kretprobes-simplifcations arch/i386/kernel/kprobes.c
--- a/arch/i386/kernel/kprobes.c~kprobes-kretprobes-simplifcations
+++ a/arch/i386/kernel/kprobes.c
@@ -226,24 +226,15 @@ static void __kprobes prepare_singlestep
 }
 
 /* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe *rp,
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
 	unsigned long *sara = (unsigned long *)&regs->esp;
 
-	struct kretprobe_instance *ri;
+	ri->ret_addr = (kprobe_opcode_t *) *sara;
 
-	if ((ri = get_free_rp_inst(rp)) != NULL) {
-		ri->rp = rp;
-		ri->task = current;
-		ri->ret_addr = (kprobe_opcode_t *) *sara;
-
-		/* Replace the return addr with trampoline addr */
-		*sara = (unsigned long) &kretprobe_trampoline;
-		add_rp_inst(ri);
-	} else {
-		rp->nmissed++;
-	}
+	/* Replace the return addr with trampoline addr */
+	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
 /*
diff -puN arch/ia64/kernel/kprobes.c~kprobes-kretprobes-simplifcations arch/ia64/kernel/kprobes.c
--- a/arch/ia64/kernel/kprobes.c~kprobes-kretprobes-simplifcations
+++ a/arch/ia64/kernel/kprobes.c
@@ -465,23 +465,13 @@ int __kprobes trampoline_probe_handler(s
 }
 
 /* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe *rp,
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
-	struct kretprobe_instance *ri;
+	ri->ret_addr = (kprobe_opcode_t *)regs->b0;
 
-	if ((ri = get_free_rp_inst(rp)) != NULL) {
-		ri->rp = rp;
-		ri->task = current;
-		ri->ret_addr = (kprobe_opcode_t *)regs->b0;
-
-		/* Replace the return addr with trampoline addr */
-		regs->b0 = ((struct fnptr *)kretprobe_trampoline)->ip;
-
-		add_rp_inst(ri);
-	} else {
-		rp->nmissed++;
-	}
+	/* Replace the return addr with trampoline addr */
+	regs->b0 = ((struct fnptr *)kretprobe_trampoline)->ip;
 }
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
diff -puN arch/powerpc/kernel/kprobes.c~kprobes-kretprobes-simplifcations arch/powerpc/kernel/kprobes.c
--- a/arch/powerpc/kernel/kprobes.c~kprobes-kretprobes-simplifcations
+++ a/arch/powerpc/kernel/kprobes.c
@@ -126,22 +126,13 @@ static void __kprobes set_current_kprobe
 }
 
 /* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe *rp,
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
-	struct kretprobe_instance *ri;
+	ri->ret_addr = (kprobe_opcode_t *)regs->link;
 
-	if ((ri = get_free_rp_inst(rp)) != NULL) {
-		ri->rp = rp;
-		ri->task = current;
-		ri->ret_addr = (kprobe_opcode_t *)regs->link;
-
-		/* Replace the return addr with trampoline addr */
-		regs->link = (unsigned long)kretprobe_trampoline;
-		add_rp_inst(ri);
-	} else {
-		rp->nmissed++;
-	}
+	/* Replace the return addr with trampoline addr */
+	regs->link = (unsigned long)kretprobe_trampoline;
 }
 
 static int __kprobes kprobe_handler(struct pt_regs *regs)
diff -puN arch/s390/kernel/kprobes.c~kprobes-kretprobes-simplifcations arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c~kprobes-kretprobes-simplifcations
+++ a/arch/s390/kernel/kprobes.c
@@ -271,23 +271,13 @@ static void __kprobes set_current_kprobe
 }
 
 /* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe *rp,
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 					struct pt_regs *regs)
 {
-	struct kretprobe_instance *ri;
+	ri->ret_addr = (kprobe_opcode_t *) regs->gprs[14];
 
-	if ((ri = get_free_rp_inst(rp)) != NULL) {
-		ri->rp = rp;
-		ri->task = current;
-		ri->ret_addr = (kprobe_opcode_t *) regs->gprs[14];
-
-		/* Replace the return addr with trampoline addr */
-		regs->gprs[14] = (unsigned long)&kretprobe_trampoline;
-
-		add_rp_inst(ri);
-	} else {
-		rp->nmissed++;
-	}
+	/* Replace the return addr with trampoline addr */
+	regs->gprs[14] = (unsigned long)&kretprobe_trampoline;
 }
 
 static int __kprobes kprobe_handler(struct pt_regs *regs)
diff -puN arch/x86_64/kernel/kprobes.c~kprobes-kretprobes-simplifcations arch/x86_64/kernel/kprobes.c
--- a/arch/x86_64/kernel/kprobes.c~kprobes-kretprobes-simplifcations
+++ a/arch/x86_64/kernel/kprobes.c
@@ -266,23 +266,14 @@ static void __kprobes prepare_singlestep
 }
 
 /* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe *rp,
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
 	unsigned long *sara = (unsigned long *)regs->rsp;
-	struct kretprobe_instance *ri;
 
-	if ((ri = get_free_rp_inst(rp)) != NULL) {
-		ri->rp = rp;
-		ri->task = current;
-		ri->ret_addr = (kprobe_opcode_t *) *sara;
-
-		/* Replace the return addr with trampoline addr */
-		*sara = (unsigned long) &kretprobe_trampoline;
-		add_rp_inst(ri);
-	} else {
-		rp->nmissed++;
-	}
+	ri->ret_addr = (kprobe_opcode_t *) *sara;
+	/* Replace the return addr with trampoline addr */
+	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
 int __kprobes kprobe_handler(struct pt_regs *regs)
diff -puN include/linux/kprobes.h~kprobes-kretprobes-simplifcations include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-kretprobes-simplifcations
+++ a/include/linux/kprobes.h
@@ -123,7 +123,8 @@ DECLARE_PER_CPU(struct kprobe *, current
 DECLARE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 
 #ifdef ARCH_SUPPORTS_KRETPROBES
-extern void arch_prepare_kretprobe(struct kretprobe *rp, struct pt_regs *regs);
+extern void arch_prepare_kretprobe(struct kretprobe_instance *ri,
+				   struct pt_regs *regs);
 #else /* ARCH_SUPPORTS_KRETPROBES */
 static inline void arch_prepare_kretprobe(struct kretprobe *rp,
 					struct pt_regs *regs)
@@ -209,8 +210,6 @@ void jprobe_return(void);
 int register_kretprobe(struct kretprobe *rp);
 void unregister_kretprobe(struct kretprobe *rp);
 
-struct kretprobe_instance *get_free_rp_inst(struct kretprobe *rp);
-void add_rp_inst(struct kretprobe_instance *ri);
 void kprobe_flush_task(struct task_struct *tk);
 void recycle_rp_inst(struct kretprobe_instance *ri, struct hlist_head *head);
 #else /* CONFIG_KPROBES */
diff -puN kernel/kprobes.c~kprobes-kretprobes-simplifcations kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-kretprobes-simplifcations
+++ a/kernel/kprobes.c
@@ -358,46 +358,6 @@ void __kprobes kprobes_inc_nmissed_count
 }
 
 /* Called with kretprobe_lock held */
-struct kretprobe_instance __kprobes *get_free_rp_inst(struct kretprobe *rp)
-{
-	struct hlist_node *node;
-	struct kretprobe_instance *ri;
-	hlist_for_each_entry(ri, node, &rp->free_instances, uflist)
-		return ri;
-	return NULL;
-}
-
-/* Called with kretprobe_lock held */
-static struct kretprobe_instance __kprobes *get_used_rp_inst(struct kretprobe
-							      *rp)
-{
-	struct hlist_node *node;
-	struct kretprobe_instance *ri;
-	hlist_for_each_entry(ri, node, &rp->used_instances, uflist)
-		return ri;
-	return NULL;
-}
-
-/* Called with kretprobe_lock held */
-void __kprobes add_rp_inst(struct kretprobe_instance *ri)
-{
-	/*
-	 * Remove rp inst off the free list -
-	 * Add it back when probed function returns
-	 */
-	hlist_del(&ri->uflist);
-
-	/* Add rp inst onto table */
-	INIT_HLIST_NODE(&ri->hlist);
-	hlist_add_head(&ri->hlist,
-			&kretprobe_inst_table[hash_ptr(ri->task, KPROBE_HASH_BITS)]);
-
-	/* Also add this rp inst to the used list. */
-	INIT_HLIST_NODE(&ri->uflist);
-	hlist_add_head(&ri->uflist, &ri->rp->used_instances);
-}
-
-/* Called with kretprobe_lock held */
 void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
 				struct hlist_head *head)
 {
@@ -450,7 +410,9 @@ void __kprobes kprobe_flush_task(struct 
 static inline void free_rp_inst(struct kretprobe *rp)
 {
 	struct kretprobe_instance *ri;
-	while ((ri = get_free_rp_inst(rp)) != NULL) {
+	struct hlist_node *pos, *next;
+
+	hlist_for_each_entry_safe(ri, pos, next, &rp->free_instances, uflist) {
 		hlist_del(&ri->uflist);
 		kfree(ri);
 	}
@@ -732,7 +694,21 @@ static int __kprobes pre_handler_kretpro
 
 	/*TODO: consider to only swap the RA after the last pre_handler fired */
 	spin_lock_irqsave(&kretprobe_lock, flags);
-	arch_prepare_kretprobe(rp, regs);
+	if (!hlist_empty(&rp->free_instances)) {
+		struct kretprobe_instance *ri;
+
+		ri = hlist_entry(rp->free_instances.first,
+				 struct kretprobe_instance, uflist);
+		ri->rp = rp;
+		ri->task = current;
+		arch_prepare_kretprobe(ri, regs);
+
+		/* XXX(hch): why is there no hlist_move_head? */
+		hlist_del(&ri->uflist);
+		hlist_add_head(&ri->uflist, &ri->rp->used_instances);
+		hlist_add_head(&ri->hlist, kretprobe_inst_table_head(ri->task));
+	} else
+		rp->nmissed++;
 	spin_unlock_irqrestore(&kretprobe_lock, flags);
 	return 0;
 }
@@ -795,11 +771,13 @@ void __kprobes unregister_kretprobe(stru
 {
 	unsigned long flags;
 	struct kretprobe_instance *ri;
+	struct hlist_node *pos, *next;
 
 	unregister_kprobe(&rp->kp);
+
 	/* No race here */
 	spin_lock_irqsave(&kretprobe_lock, flags);
-	while ((ri = get_used_rp_inst(rp)) != NULL) {
+	hlist_for_each_entry_safe(ri, pos, next, &rp->used_instances, uflist) {
 		ri->rp = NULL;
 		hlist_del(&ri->uflist);
 	}
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
dont-force-uclinux-mtd-map-to-be-root-dev.patch
git-scsi-misc.patch
knfsd-trivial-makefile-cleanup.patch
aio-is-unlikely.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
