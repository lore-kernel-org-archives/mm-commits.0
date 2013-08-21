From: akpm@linux-foundation.org
Subject: + kprobes-unify-insn-caches.patch added to -mm tree
Date: Wed, 21 Aug 2013 13:28:17 -0700
Message-ID: <521522e1.jFdyzD6DPgnvlqt4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3HUU2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Aug 2013 16:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, schwidefsky@de.ibm.com, mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, ananth@in.ibm.com, heiko.carstens@de.ibm.com

Subject: + kprobes-unify-insn-caches.patch added to -mm tree
To: heiko.carstens@de.ibm.com,ananth@in.ibm.com,masami.hiramatsu.pt@hitachi.com,mingo@kernel.org,schwidefsky@de.ibm.com
From: akpm@linux-foundation.org
Date: Wed, 21 Aug 2013 13:28:17 -0700


The patch titled
     Subject: kprobes: unify insn caches
has been added to the -mm tree.  Its filename is
     kprobes-unify-insn-caches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-unify-insn-caches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-unify-insn-caches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: kprobes: unify insn caches

The current kpropes insn caches allocate memory areas for insn slots with
module_alloc().  The assumption is that the kernel image and module area
are both within the same +/- 2GB memory area.

This however is not true for s390 where the kernel image resides within
the first 2GB (DMA memory area), but the module area is far away in the
vmalloc area, usually somewhere close below the 4TB area.

For new pc relative instructions s390 needs insn slots that are within +/-
2GB of each area.  That way we can patch displacements of pc-relative
instructions within the insn slots just like x86 and powerpc.

The module area works already with the normal insn slot allocator, however
there is currently no way to get insn slots that are within the first 2GB
on s390 (aka DMA area).

Therefore this patch set introduces a third insn slot cache besides the
normal insn and optinsn slot caches: the dmainsn slot cache.  Slots can be
allocated and freed with get_dmainsn_slot() and free_dmainsn_slot().

Patch 1 unifies the current insn and optinsn caches implementation so we
don't end up with a lot of code duplication when adding a third cache.

Patch 2 simply adds the new dmainsn slot cache.

Patch 3 is the s390 usage of the new cache.


This patch (of 3):

The two insn caches (insn, and optinsn) each have an own mutex and
alloc/free functions (get_[opt]insn_slot() / free_[opt]insn_slot()).

Since I need yet another insn cache which satifies dma allocations, unify
and simplify the current implementation:

- Move the per insn cache mutex into struct kprobe_insn_cache.
- Move the alloc/free functions to kprobe.h so they are simply
  wrappers for the generic __get_insn_slot/__free_insn_slot.
  The implementation is done with a DEFINE_INSN_CACHE_OPS() macro
  which provides the alloc/free functions for each cache if needed.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kprobes.h |   26 +++++++++++---
 kernel/kprobes.c        |   70 +++++++++++---------------------------
 2 files changed, 44 insertions(+), 52 deletions(-)

diff -puN include/linux/kprobes.h~kprobes-unify-insn-caches include/linux/kprobes.h
--- a/include/linux/kprobes.h~kprobes-unify-insn-caches
+++ a/include/linux/kprobes.h
@@ -264,10 +264,28 @@ extern void arch_arm_kprobe(struct kprob
 extern void arch_disarm_kprobe(struct kprobe *p);
 extern int arch_init_kprobes(void);
 extern void show_registers(struct pt_regs *regs);
-extern kprobe_opcode_t *get_insn_slot(void);
-extern void free_insn_slot(kprobe_opcode_t *slot, int dirty);
 extern void kprobes_inc_nmissed_count(struct kprobe *p);
 
+struct kprobe_insn_cache;
+extern kprobe_opcode_t *__get_insn_slot(struct kprobe_insn_cache *c);
+extern void __free_insn_slot(struct kprobe_insn_cache *c,
+			     kprobe_opcode_t *slot, int dirty);
+
+#define DEFINE_INSN_CACHE_OPS(__name)					\
+extern struct kprobe_insn_cache kprobe_##__name##_slots;		\
+									\
+static inline kprobe_opcode_t *get_##__name##_slot(void)		\
+{									\
+	return __get_insn_slot(&kprobe_##__name##_slots);		\
+}									\
+									\
+static inline void free_##__name##_slot(kprobe_opcode_t *slot, int dirty)\
+{									\
+	__free_insn_slot(&kprobe_##__name##_slots, slot, dirty);	\
+}									\
+
+DEFINE_INSN_CACHE_OPS(insn);
+
 #ifdef CONFIG_OPTPROBES
 /*
  * Internal structure for direct jump optimized probe
@@ -287,13 +305,13 @@ extern void arch_optimize_kprobes(struct
 extern void arch_unoptimize_kprobes(struct list_head *oplist,
 				    struct list_head *done_list);
 extern void arch_unoptimize_kprobe(struct optimized_kprobe *op);
-extern kprobe_opcode_t *get_optinsn_slot(void);
-extern void free_optinsn_slot(kprobe_opcode_t *slot, int dirty);
 extern int arch_within_optimized_kprobe(struct optimized_kprobe *op,
 					unsigned long addr);
 
 extern void opt_pre_handler(struct kprobe *p, struct pt_regs *regs);
 
+DEFINE_INSN_CACHE_OPS(optinsn);
+
 #ifdef CONFIG_SYSCTL
 extern int sysctl_kprobes_optimization;
 extern int proc_kprobes_optimization_handler(struct ctl_table *table,
diff -puN kernel/kprobes.c~kprobes-unify-insn-caches kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-unify-insn-caches
+++ a/kernel/kprobes.c
@@ -122,6 +122,7 @@ struct kprobe_insn_page {
 	 (sizeof(char) * (slots)))
 
 struct kprobe_insn_cache {
+	struct mutex mutex;
 	struct list_head pages;	/* list of kprobe_insn_page */
 	size_t insn_size;	/* size of instruction slot */
 	int nr_garbage;
@@ -138,8 +139,8 @@ enum kprobe_slot_state {
 	SLOT_USED = 2,
 };
 
-static DEFINE_MUTEX(kprobe_insn_mutex);	/* Protects kprobe_insn_slots */
-static struct kprobe_insn_cache kprobe_insn_slots = {
+struct kprobe_insn_cache kprobe_insn_slots = {
+	.mutex = __MUTEX_INITIALIZER(kprobe_insn_slots.mutex),
 	.pages = LIST_HEAD_INIT(kprobe_insn_slots.pages),
 	.insn_size = MAX_INSN_SIZE,
 	.nr_garbage = 0,
@@ -150,10 +151,12 @@ static int __kprobes collect_garbage_slo
  * __get_insn_slot() - Find a slot on an executable page for an instruction.
  * We allocate an executable page if there's no room on existing ones.
  */
-static kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
+kprobe_opcode_t __kprobes *__get_insn_slot(struct kprobe_insn_cache *c)
 {
 	struct kprobe_insn_page *kip;
+	kprobe_opcode_t *slot = NULL;
 
+	mutex_lock(&c->mutex);
  retry:
 	list_for_each_entry(kip, &c->pages, list) {
 		if (kip->nused < slots_per_page(c)) {
@@ -162,7 +165,8 @@ static kprobe_opcode_t __kprobes *__get_
 				if (kip->slot_used[i] == SLOT_CLEAN) {
 					kip->slot_used[i] = SLOT_USED;
 					kip->nused++;
-					return kip->insns + (i * c->insn_size);
+					slot = kip->insns + (i * c->insn_size);
+					goto out;
 				}
 			}
 			/* kip->nused is broken. Fix it. */
@@ -178,7 +182,7 @@ static kprobe_opcode_t __kprobes *__get_
 	/* All out of space.  Need to allocate a new page. */
 	kip = kmalloc(KPROBE_INSN_PAGE_SIZE(slots_per_page(c)), GFP_KERNEL);
 	if (!kip)
-		return NULL;
+		goto out;
 
 	/*
 	 * Use module_alloc so this page is within +/- 2GB of where the
@@ -188,7 +192,7 @@ static kprobe_opcode_t __kprobes *__get_
 	kip->insns = module_alloc(PAGE_SIZE);
 	if (!kip->insns) {
 		kfree(kip);
-		return NULL;
+		goto out;
 	}
 	INIT_LIST_HEAD(&kip->list);
 	memset(kip->slot_used, SLOT_CLEAN, slots_per_page(c));
@@ -196,19 +200,10 @@ static kprobe_opcode_t __kprobes *__get_
 	kip->nused = 1;
 	kip->ngarbage = 0;
 	list_add(&kip->list, &c->pages);
-	return kip->insns;
-}
-
-
-kprobe_opcode_t __kprobes *get_insn_slot(void)
-{
-	kprobe_opcode_t *ret = NULL;
-
-	mutex_lock(&kprobe_insn_mutex);
-	ret = __get_insn_slot(&kprobe_insn_slots);
-	mutex_unlock(&kprobe_insn_mutex);
-
-	return ret;
+	slot = kip->insns;
+out:
+	mutex_unlock(&c->mutex);
+	return slot;
 }
 
 /* Return 1 if all garbages are collected, otherwise 0. */
@@ -255,11 +250,12 @@ static int __kprobes collect_garbage_slo
 	return 0;
 }
 
-static void __kprobes __free_insn_slot(struct kprobe_insn_cache *c,
-				       kprobe_opcode_t *slot, int dirty)
+void __kprobes __free_insn_slot(struct kprobe_insn_cache *c,
+				kprobe_opcode_t *slot, int dirty)
 {
 	struct kprobe_insn_page *kip;
 
+	mutex_lock(&c->mutex);
 	list_for_each_entry(kip, &c->pages, list) {
 		long idx = ((long)slot - (long)kip->insns) /
 				(c->insn_size * sizeof(kprobe_opcode_t));
@@ -272,45 +268,23 @@ static void __kprobes __free_insn_slot(s
 					collect_garbage_slots(c);
 			} else
 				collect_one_slot(kip, idx);
-			return;
+			goto out;
 		}
 	}
 	/* Could not free this slot. */
 	WARN_ON(1);
+out:
+	mutex_unlock(&c->mutex);
 }
 
-void __kprobes free_insn_slot(kprobe_opcode_t * slot, int dirty)
-{
-	mutex_lock(&kprobe_insn_mutex);
-	__free_insn_slot(&kprobe_insn_slots, slot, dirty);
-	mutex_unlock(&kprobe_insn_mutex);
-}
 #ifdef CONFIG_OPTPROBES
 /* For optimized_kprobe buffer */
-static DEFINE_MUTEX(kprobe_optinsn_mutex); /* Protects kprobe_optinsn_slots */
-static struct kprobe_insn_cache kprobe_optinsn_slots = {
+struct kprobe_insn_cache kprobe_optinsn_slots = {
+	.mutex = __MUTEX_INITIALIZER(kprobe_optinsn_slots.mutex),
 	.pages = LIST_HEAD_INIT(kprobe_optinsn_slots.pages),
 	/* .insn_size is initialized later */
 	.nr_garbage = 0,
 };
-/* Get a slot for optimized_kprobe buffer */
-kprobe_opcode_t __kprobes *get_optinsn_slot(void)
-{
-	kprobe_opcode_t *ret = NULL;
-
-	mutex_lock(&kprobe_optinsn_mutex);
-	ret = __get_insn_slot(&kprobe_optinsn_slots);
-	mutex_unlock(&kprobe_optinsn_mutex);
-
-	return ret;
-}
