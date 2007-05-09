From: akpm@linux-foundation.org
Subject: - kprobes-codingstyle-cleanups.patch removed from -mm tree
Date: Tue, 08 May 2007 19:54:47 -0700
Message-ID: <200705090254.l492slqS009841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032289AbXEICzD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:55:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, prasanna@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: codingstyle cleanups
has been removed from the -mm tree.  Its filename was
     kprobes-codingstyle-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kprobes: codingstyle cleanups
From: Christoph Hellwig <hch@lst.de>

Remove superflous braces and fix indentation aswell as comments.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kprobes.c |   55 ++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff -puN kernel/kprobes.c~kprobes-codingstyle-cleanups kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-codingstyle-cleanups
+++ a/kernel/kprobes.c
@@ -133,7 +133,7 @@ kprobe_opcode_t __kprobes *get_insn_slot
 	struct kprobe_insn_page *kip;
 	struct hlist_node *pos;
 
-      retry:
+ retry:
 	hlist_for_each_entry(kip, pos, &kprobe_insn_pages, hlist) {
 		if (kip->nused < INSNS_PER_PAGE) {
 			int i;
@@ -155,9 +155,8 @@ kprobe_opcode_t __kprobes *get_insn_slot
 	}
 	/* All out of space.  Need to allocate a new page. Use slot 0. */
 	kip = kmalloc(sizeof(struct kprobe_insn_page), GFP_KERNEL);
-	if (!kip) {
+	if (!kip)
 		return NULL;
-	}
 
 	/*
 	 * Use module_alloc so this page is within +/- 2GB of where the
@@ -246,9 +245,9 @@ void __kprobes free_insn_slot(kprobe_opc
 			break;
 		}
 	}
-	if (dirty && (++kprobe_garbage_slots > INSNS_PER_PAGE)) {
+
+	if (dirty && ++kprobe_garbage_slots > INSNS_PER_PAGE)
 		collect_garbage_slots();
-	}
 }
 #endif
 
@@ -314,7 +313,6 @@ static void __kprobes aggr_post_handler(
 			reset_kprobe_instance();
 		}
 	}
-	return;
 }
 
 static int __kprobes aggr_fault_handler(struct kprobe *p, struct pt_regs *regs,
@@ -533,8 +531,8 @@ static int __kprobes register_aggr_kprob
 
 static int __kprobes in_kprobes_functions(unsigned long addr)
 {
-	if (addr >= (unsigned long)__kprobes_text_start
-		&& addr < (unsigned long)__kprobes_text_end)
+	if (addr >= (unsigned long)__kprobes_text_start &&
+	    addr < (unsigned long)__kprobes_text_end)
 		return -EINVAL;
 	return 0;
 }
@@ -561,19 +559,24 @@ static int __kprobes __register_kprobe(s
 		return -EINVAL;
 	p->addr = (kprobe_opcode_t *)(((char *)p->addr)+ p->offset);
 
-	if ((!kernel_text_address((unsigned long) p->addr)) ||
-		in_kprobes_functions((unsigned long) p->addr))
+	if (!kernel_text_address((unsigned long) p->addr) ||
+	    in_kprobes_functions((unsigned long) p->addr))
 		return -EINVAL;
 
 	p->mod_refcounted = 0;
-	/* Check are we probing a module */
-	if ((probed_mod = module_text_address((unsigned long) p->addr))) {
+
+	/*
+	 * Check if are we probing a module.
+	 */
+	probed_mod = module_text_address((unsigned long) p->addr);
+	if (probed_mod) {
 		struct module *calling_mod = module_text_address(called_from);
-		/* We must allow modules to probe themself and
-		 * in this case avoid incrementing the module refcount,
-		 * so as to allow unloading of self probing modules.
+		/*
+		 * We must allow modules to probe themself and in this case
+		 * avoid incrementing the module refcount, so as to allow
+		 * unloading of self probing modules.
 		 */
-		if (calling_mod && (calling_mod != probed_mod)) {
+		if (calling_mod && calling_mod != probed_mod) {
 			if (unlikely(!try_module_get(probed_mod)))
 				return -EINVAL;
 			p->mod_refcounted = 1;
@@ -591,7 +594,8 @@ static int __kprobes __register_kprobe(s
 		goto out;
 	}
 
-	if ((ret = arch_prepare_kprobe(p)) != 0)
+	ret = arch_prepare_kprobe(p);
+	if (ret)
 		goto out;
 
 	INIT_HLIST_NODE(&p->hlist);
@@ -614,8 +618,7 @@ out:
 
 int __kprobes register_kprobe(struct kprobe *p)
 {
-	return __register_kprobe(p,
-		(unsigned long)__builtin_return_address(0));
+	return __register_kprobe(p, (unsigned long)__builtin_return_address(0));
 }
 
 void __kprobes unregister_kprobe(struct kprobe *p)
@@ -639,9 +642,9 @@ void __kprobes unregister_kprobe(struct 
 		return;
 	}
 valid_p:
-	if ((old_p == p) || ((old_p->pre_handler == aggr_pre_handler) &&
-		(p->list.next == &old_p->list) &&
-		(p->list.prev == &old_p->list))) {
+	if (old_p == p ||
+	    (old_p->pre_handler == aggr_pre_handler &&
+	     p->list.next == &old_p->list && p->list.prev == &old_p->list)) {
 		/* Only probe on the hash list */
 		arch_disarm_kprobe(p);
 		hlist_del_rcu(&old_p->hlist);
@@ -654,9 +657,11 @@ valid_p:
 	mutex_unlock(&kprobe_mutex);
 
 	synchronize_sched();
-	if (p->mod_refcounted &&
-	    (mod = module_text_address((unsigned long)p->addr)))
-		module_put(mod);
+	if (p->mod_refcounted) {
+		mod = module_text_address((unsigned long)p->addr);
+		if (mod)
+			module_put(mod);
+	}
 
 	if (cleanup_p) {
 		if (p != old_p) {
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
