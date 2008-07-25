From: akpm@linux-foundation.org
Subject: - kprobes-improve-kretprobe-scalability-with-hashed-locking.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:55:50 -0700
Message-ID: <200807252255.m6PMto4h003012@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbYGYXBy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:01:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: srinivasa@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, jkenisto@us.ibm.com, mhiramat@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: improve kretprobe scalability with hashed locking
has been removed from the -mm tree.  Its filename was
     kprobes-improve-kretprobe-scalability-with-hashed-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: improve kretprobe scalability with hashed locking
From: Srinivasa D S <srinivasa@in.ibm.com>

Currently list of kretprobe instances are stored in kretprobe object (as
used_instances,free_instances) and in kretprobe hash table.  We have one
global kretprobe lock to serialise the access to these lists.  This causes
only one kretprobe handler to execute at a time.  Hence affects system
performance, particularly on SMP systems and when return probe is set on
lot of functions (like on all systemcalls).

Solution proposed here gives fine-grain locks that performs better on SMP
system compared to present kretprobe implementation.

Solution:

 1) Instead of having one global lock to protect kretprobe instances
    present in kretprobe object and kretprobe hash table.  We will have
    two locks, one lock for protecting kretprobe hash table and another
    lock for kretporbe object.

 2) We hold lock present in kretprobe object while we modify kretprobe
    instance in kretprobe object and we hold per-hash-list lock while
    modifying kretprobe instances present in that hash list.  To prevent
    deadlock, we never grab a per-hash-list lock while holding a kretprobe
    lock.

 3) We can remove used_instances from struct kretprobe, as we can
    track used instances of kretprobe instances using kretprobe hash
    table.

Time duration for kernel compilation ("make -j 8") on a 8-way ppc64 system
with return probes set on all systemcalls looks like this.

cacheline              non-cacheline             Un-patched kernel
aligned patch 	       aligned patch
===============================================================================
real    9m46.784s       9m54.412s                  10m2.450s
user    40m5.715s       40m7.142s                  40m4.273s
sys     2m57.754s       2m58.583s                  3m17.430s
===========================================================

Time duration for kernel compilation ("make -j 8) on the same system, when
kernel is not probed.
=========================
real    9m26.389s
user    40m8.775s
sys     2m7.283s
=========================

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>
Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/kprobes.c     |    6 -
 arch/ia64/kernel/kprobes.c    |    6 -
 arch/powerpc/kernel/kprobes.c |    6 -
 arch/s390/kernel/kprobes.c    |    6 -
 arch/sparc64/kernel/kprobes.c |   11 +-
 arch/x86/kernel/kprobes.c     |    6 -
 include/linux/kprobes.h       |    7 +
 kernel/kprobes.c              |  127 ++++++++++++++++++++++----------
 8 files changed, 108 insertions(+), 67 deletions(-)

diff -puN arch/arm/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking arch/arm/kernel/kprobes.c
--- a/arch/arm/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking
+++ a/arch/arm/kernel/kprobes.c
@@ -296,8 +296,7 @@ static __used __kprobes void *trampoline
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
+	kretprobe_hash_lock(current, &head, &flags);
 
 	/*
 	 * It is possible to have multiple instances associated with a given
@@ -337,7 +336,7 @@ static __used __kprobes void *trampoline
 	}
 
 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	kretprobe_hash_unlock(current, &flags);
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
@@ -347,7 +346,6 @@ static __used __kprobes void *trampoline
 	return (void *)orig_ret_address;
 }
 
-/* Called with kretprobe_lock held. */
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
diff -puN arch/ia64/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking arch/ia64/kernel/kprobes.c
--- a/arch/ia64/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking
+++ a/arch/ia64/kernel/kprobes.c
@@ -429,8 +429,7 @@ int __kprobes trampoline_probe_handler(s
 		((struct fnptr *)kretprobe_trampoline)->ip;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
+	kretprobe_hash_lock(current, &head, &flags);
 
 	/*
 	 * It is possible to have multiple instances associated with a given
@@ -485,7 +484,7 @@ int __kprobes trampoline_probe_handler(s
 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 
 	reset_current_kprobe();
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
@@ -500,7 +499,6 @@ int __kprobes trampoline_probe_handler(s
 	return 1;
 }
 
-/* Called with kretprobe_lock held */
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
diff -puN arch/powerpc/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking arch/powerpc/kernel/kprobes.c
--- a/arch/powerpc/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking
+++ a/arch/powerpc/kernel/kprobes.c
@@ -144,7 +144,6 @@ static void __kprobes set_current_kprobe
 	kcb->kprobe_saved_msr = regs->msr;
 }
 
-/* Called with kretprobe_lock held */
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
@@ -312,8 +311,7 @@ static int __kprobes trampoline_probe_ha
 	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
+	kretprobe_hash_lock(current, &head, &flags);
 
 	/*
 	 * It is possible to have multiple instances associated with a given
@@ -352,7 +350,7 @@ static int __kprobes trampoline_probe_ha
 	regs->nip = orig_ret_address;
 
 	reset_current_kprobe();
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
diff -puN arch/s390/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking arch/s390/kernel/kprobes.c
--- a/arch/s390/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking
+++ a/arch/s390/kernel/kprobes.c
@@ -270,7 +270,6 @@ static void __kprobes set_current_kprobe
 	__ctl_store(kcb->kprobe_saved_ctl, 9, 11);
 }
 
-/* Called with kretprobe_lock held */
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 					struct pt_regs *regs)
 {
@@ -377,8 +376,7 @@ static int __kprobes trampoline_probe_ha
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
+	kretprobe_hash_lock(current, &head, &flags);
 
 	/*
 	 * It is possible to have multiple instances associated with a given
@@ -417,7 +415,7 @@ static int __kprobes trampoline_probe_ha
 	regs->psw.addr = orig_ret_address | PSW_ADDR_AMODE;
 
 	reset_current_kprobe();
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
diff -puN arch/sparc64/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking arch/sparc64/kernel/kprobes.c
--- a/arch/sparc64/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking
+++ a/arch/sparc64/kernel/kprobes.c
@@ -478,9 +478,9 @@ int __kprobes longjmp_break_handler(stru
 	return 0;
 }
 
-/* Called with kretprobe_lock held.  The value stored in the return
- * address register is actually 2 instructions before where the
- * callee will return to.  Sequences usually look something like this
+/* The value stored in the return address register is actually 2
+ * instructions before where the callee will return to.
+ * Sequences usually look something like this
  *
  *		call	some_function	<--- return register points here
  *		 nop			<--- call delay slot
@@ -512,8 +512,7 @@ int __kprobes trampoline_probe_handler(s
 	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
+	kretprobe_hash_lock(current, &head, &flags);
 
 	/*
 	 * It is possible to have multiple instances associated with a given
@@ -553,7 +552,7 @@ int __kprobes trampoline_probe_handler(s
 	regs->tnpc = orig_ret_address + 4;
 
 	reset_current_kprobe();
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	kretprobe_hash_unlock(current, &flags);
 	preempt_enable_no_resched();
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
diff -puN arch/x86/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking arch/x86/kernel/kprobes.c
--- a/arch/x86/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking
+++ a/arch/x86/kernel/kprobes.c
@@ -431,7 +431,6 @@ static void __kprobes prepare_singlestep
 		regs->ip = (unsigned long)p->ainsn.insn;
 }
 
-/* Called with kretprobe_lock held */
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
@@ -682,8 +681,7 @@ static __used __kprobes void *trampoline
 	unsigned long trampoline_address = (unsigned long)&kretprobe_trampoline;
 
 	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
+	kretprobe_hash_lock(current, &head, &flags);
 	/* fixup registers */
 #ifdef CONFIG_X86_64
 	regs->cs = __KERNEL_CS;
@@ -732,7 +730,7 @@ static __used __kprobes void *trampoline
 
 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
 
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+	kretprobe_hash_unlock(current, &flags);
 
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
diff -puN include/linux/kprobes.h~kprobes-improve-kretprobe-scalability-with-hashed-locking include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-improve-kretprobe-scalability-with-hashed-locking
+++ a/include/linux/kprobes.h
@@ -157,11 +157,10 @@ struct kretprobe {
 	int nmissed;
 	size_t data_size;
 	struct hlist_head free_instances;
-	struct hlist_head used_instances;
+	spinlock_t lock;
 };
 
 struct kretprobe_instance {
-	struct hlist_node uflist; /* either on free list or used list */
 	struct hlist_node hlist;
 	struct kretprobe *rp;
 	kprobe_opcode_t *ret_addr;
@@ -201,7 +200,6 @@ static inline int init_test_probes(void)
 }
 #endif /* CONFIG_KPROBES_SANITY_TEST */
 
-extern spinlock_t kretprobe_lock;
 extern struct mutex kprobe_mutex;
 extern int arch_prepare_kprobe(struct kprobe *p);
 extern void arch_arm_kprobe(struct kprobe *p);
@@ -214,6 +212,9 @@ extern void kprobes_inc_nmissed_count(st
 
 /* Get the kprobe at this addr (if any) - called with preemption disabled */
 struct kprobe *get_kprobe(void *addr);
+void kretprobe_hash_lock(struct task_struct *tsk,
+			 struct hlist_head **head, unsigned long *flags);
+void kretprobe_hash_unlock(struct task_struct *tsk, unsigned long *flags);
 struct hlist_head * kretprobe_inst_table_head(struct task_struct *tsk);
 
 /* kprobe_running() will just return the current_kprobe on this CPU */
diff -puN kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-improve-kretprobe-scalability-with-hashed-locking
+++ a/kernel/kprobes.c
@@ -62,6 +62,7 @@
 	addr = ((kprobe_opcode_t *)(kallsyms_lookup_name(name)))
 #endif
 
+static int kprobes_initialized;
 static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
 static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
 
@@ -69,8 +70,15 @@ static struct hlist_head kretprobe_inst_
 static bool kprobe_enabled;
 
 DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
-DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
 static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
+static struct {
+	spinlock_t lock ____cacheline_aligned;
+} kretprobe_table_locks[KPROBE_TABLE_SIZE];
+
+static spinlock_t *kretprobe_table_lock_ptr(unsigned long hash)
+{
+	return &(kretprobe_table_locks[hash].lock);
+}
 
 /*
  * Normally, functions that we'd want to prohibit kprobes in, are marked
@@ -368,26 +376,53 @@ void __kprobes kprobes_inc_nmissed_count
 	return;
 }
 
-/* Called with kretprobe_lock held */
 void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
 				struct hlist_head *head)
 {
+	struct kretprobe *rp = ri->rp;
+
 	/* remove rp inst off the rprobe_inst_table */
 	hlist_del(&ri->hlist);
-	if (ri->rp) {
-		/* remove rp inst off the used list */
-		hlist_del(&ri->uflist);
-		/* put rp inst back onto the free list */
-		INIT_HLIST_NODE(&ri->uflist);
-		hlist_add_head(&ri->uflist, &ri->rp->free_instances);
+	INIT_HLIST_NODE(&ri->hlist);
+	if (likely(rp)) {
+		spin_lock(&rp->lock);
+		hlist_add_head(&ri->hlist, &rp->free_instances);
+		spin_unlock(&rp->lock);
 	} else
 		/* Unregistering */
 		hlist_add_head(&ri->hlist, head);
 }
 
-struct hlist_head __kprobes *kretprobe_inst_table_head(struct task_struct *tsk)
+void kretprobe_hash_lock(struct task_struct *tsk,
+			 struct hlist_head **head, unsigned long *flags)
+{
+	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
+	spinlock_t *hlist_lock;
+
+	*head = &kretprobe_inst_table[hash];
+	hlist_lock = kretprobe_table_lock_ptr(hash);
+	spin_lock_irqsave(hlist_lock, *flags);
+}
+
+void kretprobe_table_lock(unsigned long hash, unsigned long *flags)
 {
-	return &kretprobe_inst_table[hash_ptr(tsk, KPROBE_HASH_BITS)];
+	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
+	spin_lock_irqsave(hlist_lock, *flags);
+}
+
+void kretprobe_hash_unlock(struct task_struct *tsk, unsigned long *flags)
+{
+	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
+	spinlock_t *hlist_lock;
+
+	hlist_lock = kretprobe_table_lock_ptr(hash);
+	spin_unlock_irqrestore(hlist_lock, *flags);
+}
+
+void kretprobe_table_unlock(unsigned long hash, unsigned long *flags)
+{
+	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
+	spin_unlock_irqrestore(hlist_lock, *flags);
 }
 
 /*
@@ -401,17 +436,21 @@ void __kprobes kprobe_flush_task(struct 
 	struct kretprobe_instance *ri;
 	struct hlist_head *head, empty_rp;
 	struct hlist_node *node, *tmp;
-	unsigned long flags = 0;
+	unsigned long hash, flags = 0;
 
-	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(tk);
+	if (unlikely(!kprobes_initialized))
+		/* Early boot.  kretprobe_table_locks not yet initialized. */
+		return;
+
+	hash = hash_ptr(tk, KPROBE_HASH_BITS);
+	head = &kretprobe_inst_table[hash];
+	kretprobe_table_lock(hash, &flags);
 	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
 		if (ri->task == tk)
 			recycle_rp_inst(ri, &empty_rp);
 	}
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-
+	kretprobe_table_unlock(hash, &flags);
+	INIT_HLIST_HEAD(&empty_rp);
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
@@ -423,24 +462,29 @@ static inline void free_rp_inst(struct k
 	struct kretprobe_instance *ri;
 	struct hlist_node *pos, *next;
 
-	hlist_for_each_entry_safe(ri, pos, next, &rp->free_instances, uflist) {
-		hlist_del(&ri->uflist);
+	hlist_for_each_entry_safe(ri, pos, next, &rp->free_instances, hlist) {
+		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
 }
 
 static void __kprobes cleanup_rp_inst(struct kretprobe *rp)
 {
-	unsigned long flags;
+	unsigned long flags, hash;
 	struct kretprobe_instance *ri;
 	struct hlist_node *pos, *next;
+	struct hlist_head *head;
+
 	/* No race here */
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	hlist_for_each_entry_safe(ri, pos, next, &rp->used_instances, uflist) {
-		ri->rp = NULL;
-		hlist_del(&ri->uflist);
+	for (hash = 0; hash < KPROBE_TABLE_SIZE; hash++) {
+		kretprobe_table_lock(hash, &flags);
+		head = &kretprobe_inst_table[hash];
+		hlist_for_each_entry_safe(ri, pos, next, head, hlist) {
+			if (ri->rp == rp)
+				ri->rp = NULL;
+		}
+		kretprobe_table_unlock(hash, &flags);
 	}
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
 	free_rp_inst(rp);
 }
 
@@ -831,32 +875,37 @@ static int __kprobes pre_handler_kretpro
 					   struct pt_regs *regs)
 {
 	struct kretprobe *rp = container_of(p, struct kretprobe, kp);
-	unsigned long flags = 0;
+	unsigned long hash, flags = 0;
+	struct kretprobe_instance *ri;
 
 	/*TODO: consider to only swap the RA after the last pre_handler fired */
-	spin_lock_irqsave(&kretprobe_lock, flags);
+	hash = hash_ptr(current, KPROBE_HASH_BITS);
+	spin_lock_irqsave(&rp->lock, flags);
 	if (!hlist_empty(&rp->free_instances)) {
-		struct kretprobe_instance *ri;
-
 		ri = hlist_entry(rp->free_instances.first,
-				 struct kretprobe_instance, uflist);
+				struct kretprobe_instance, hlist);
+		hlist_del(&ri->hlist);
+		spin_unlock_irqrestore(&rp->lock, flags);
+
 		ri->rp = rp;
 		ri->task = current;
 
 		if (rp->entry_handler && rp->entry_handler(ri, regs)) {
-			spin_unlock_irqrestore(&kretprobe_lock, flags);
+			spin_unlock_irqrestore(&rp->lock, flags);
 			return 0;
 		}
 
 		arch_prepare_kretprobe(ri, regs);
 
 		/* XXX(hch): why is there no hlist_move_head? */
-		hlist_del(&ri->uflist);
-		hlist_add_head(&ri->uflist, &ri->rp->used_instances);
-		hlist_add_head(&ri->hlist, kretprobe_inst_table_head(ri->task));
-	} else
+		INIT_HLIST_NODE(&ri->hlist);
+		kretprobe_table_lock(hash, &flags);
+		hlist_add_head(&ri->hlist, &kretprobe_inst_table[hash]);
+		kretprobe_table_unlock(hash, &flags);
+	} else {
 		rp->nmissed++;
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
+		spin_unlock_irqrestore(&rp->lock, flags);
+	}
 	return 0;
 }
 
@@ -892,7 +941,7 @@ static int __kprobes __register_kretprob
 		rp->maxactive = NR_CPUS;
 #endif
 	}
-	INIT_HLIST_HEAD(&rp->used_instances);
+	spin_lock_init(&rp->lock);
 	INIT_HLIST_HEAD(&rp->free_instances);
 	for (i = 0; i < rp->maxactive; i++) {
 		inst = kmalloc(sizeof(struct kretprobe_instance) +
@@ -901,8 +950,8 @@ static int __kprobes __register_kretprob
 			free_rp_inst(rp);
 			return -ENOMEM;
 		}
-		INIT_HLIST_NODE(&inst->uflist);
-		hlist_add_head(&inst->uflist, &rp->free_instances);
+		INIT_HLIST_NODE(&inst->hlist);
+		hlist_add_head(&inst->hlist, &rp->free_instances);
 	}
 
 	rp->nmissed = 0;
@@ -1009,6 +1058,7 @@ static int __init init_kprobes(void)
 	for (i = 0; i < KPROBE_TABLE_SIZE; i++) {
 		INIT_HLIST_HEAD(&kprobe_table[i]);
 		INIT_HLIST_HEAD(&kretprobe_inst_table[i]);
+		spin_lock_init(&(kretprobe_table_locks[i].lock));
 	}
 
 	/*
@@ -1050,6 +1100,7 @@ static int __init init_kprobes(void)
 	err = arch_init_kprobes();
 	if (!err)
 		err = register_die_notifier(&kprobe_exceptions_nb);
+	kprobes_initialized = (err == 0);
 
 	if (!err)
 		init_test_probes();
_

Patches currently in -mm which might be from srinivasa@in.ibm.com are

origin.patch

