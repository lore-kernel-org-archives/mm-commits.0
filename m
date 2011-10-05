From: akpm@google.com
Subject: [merged] kernel-irq_workc-use-llist.patch removed from -mm tree
Date: Wed, 05 Oct 2011 12:12:59 -0700
Message-ID: <201110051913.p95JCxdd020849@hpaq7.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15278 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236Ab1JETNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Oct 2011 15:13:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/irq_work.c: use llist
has been removed from the -mm tree.  Its filename was
     kernel-irq_workc-use-llist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: kernel/irq_work.c: use llist

Use llist in irq_work instead of the private lockless linked list
implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq_work.h |   15 +++---
 kernel/irq_work.c        |   92 +++++++++++++------------------------
 2 files changed, 42 insertions(+), 65 deletions(-)

diff -puN include/linux/irq_work.h~kernel-irq_workc-use-llist include/linux/irq_work.h
--- a/include/linux/irq_work.h~kernel-irq_workc-use-llist
+++ a/include/linux/irq_work.h
@@ -1,20 +1,23 @@
 #ifndef _LINUX_IRQ_WORK_H
 #define _LINUX_IRQ_WORK_H
 
+#include <linux/llist.h>
+
 struct irq_work {
-	struct irq_work *next;
+	unsigned long flags;
+	struct llist_node llnode;
 	void (*func)(struct irq_work *);
 };
 
 static inline
-void init_irq_work(struct irq_work *entry, void (*func)(struct irq_work *))
+void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 {
-	entry->next = NULL;
-	entry->func = func;
+	work->flags = 0;
+	work->func = func;
 }
 
-bool irq_work_queue(struct irq_work *entry);
+bool irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
-void irq_work_sync(struct irq_work *entry);
+void irq_work_sync(struct irq_work *work);
 
 #endif /* _LINUX_IRQ_WORK_H */
diff -puN kernel/irq_work.c~kernel-irq_workc-use-llist kernel/irq_work.c
--- a/kernel/irq_work.c~kernel-irq_workc-use-llist
+++ a/kernel/irq_work.c
@@ -10,7 +10,6 @@
 #include <linux/irq_work.h>
 #include <linux/percpu.h>
 #include <linux/hardirq.h>
-#include <asm/processor.h>
 
 /*
  * An entry can be in one of four states:
@@ -19,54 +18,34 @@
  * claimed   NULL, 3 -> {pending}       : claimed to be enqueued
  * pending   next, 3 -> {busy}          : queued, pending callback
  * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
- *
- * We use the lower two bits of the next pointer to keep PENDING and BUSY
- * flags.
  */
 
 #define IRQ_WORK_PENDING	1UL
 #define IRQ_WORK_BUSY		2UL
 #define IRQ_WORK_FLAGS		3UL
 
-static inline bool irq_work_is_set(struct irq_work *entry, int flags)
-{
-	return (unsigned long)entry->next & flags;
-}
-
-static inline struct irq_work *irq_work_next(struct irq_work *entry)
-{
-	unsigned long next = (unsigned long)entry->next;
-	next &= ~IRQ_WORK_FLAGS;
-	return (struct irq_work *)next;
-}
-
-static inline struct irq_work *next_flags(struct irq_work *entry, int flags)
-{
-	unsigned long next = (unsigned long)entry;
-	next |= flags;
-	return (struct irq_work *)next;
-}
-
-static DEFINE_PER_CPU(struct irq_work *, irq_work_list);
+static DEFINE_PER_CPU(struct llist_head, irq_work_list);
 
 /*
  * Claim the entry so that no one else will poke at it.
  */
-static bool irq_work_claim(struct irq_work *entry)
+static bool irq_work_claim(struct irq_work *work)
 {
-	struct irq_work *next, *nflags;
+	unsigned long flags, nflags;
 
-	do {
-		next = entry->next;
-		if ((unsigned long)next & IRQ_WORK_PENDING)
+	for (;;) {
+		flags = work->flags;
+		if (flags & IRQ_WORK_PENDING)
 			return false;
-		nflags = next_flags(next, IRQ_WORK_FLAGS);
-	} while (cmpxchg(&entry->next, next, nflags) != next);
+		nflags = flags | IRQ_WORK_FLAGS;
+		if (cmpxchg(&work->flags, flags, nflags) == flags)
+			break;
+		cpu_relax();
+	}
 
 	return true;
 }
 
-
 void __weak arch_irq_work_raise(void)
 {
 	/*
@@ -77,20 +56,15 @@ void __weak arch_irq_work_raise(void)
 /*
  * Queue the entry and raise the IPI if needed.
  */
-static void __irq_work_queue(struct irq_work *entry)
+static void __irq_work_queue(struct irq_work *work)
 {
-	struct irq_work *next;
+	bool empty;
 
 	preempt_disable();
 
-	do {
-		next = __this_cpu_read(irq_work_list);
-		/* Can assign non-atomic because we keep the flags set. */
-		entry->next = next_flags(next, IRQ_WORK_FLAGS);
-	} while (this_cpu_cmpxchg(irq_work_list, next, entry) != next);
-
+	empty = llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
 	/* The list was empty, raise self-interrupt to start processing. */
-	if (!irq_work_next(entry))
+	if (empty)
 		arch_irq_work_raise();
 
 	preempt_enable();
@@ -102,16 +76,16 @@ static void __irq_work_queue(struct irq_
  *
  * Can be re-enqueued while the callback is still in progress.
  */
-bool irq_work_queue(struct irq_work *entry)
+bool irq_work_queue(struct irq_work *work)
 {
-	if (!irq_work_claim(entry)) {
+	if (!irq_work_claim(work)) {
 		/*
 		 * Already enqueued, can't do!
 		 */
 		return false;
 	}
 
-	__irq_work_queue(entry);
+	__irq_work_queue(work);
 	return true;
 }
 EXPORT_SYMBOL_GPL(irq_work_queue);
@@ -122,34 +96,34 @@ EXPORT_SYMBOL_GPL(irq_work_queue);
  */
 void irq_work_run(void)
 {
-	struct irq_work *list;
+	struct irq_work *work;
+	struct llist_head *this_list;
+	struct llist_node *llnode;
 
-	if (this_cpu_read(irq_work_list) == NULL)
+	this_list = &__get_cpu_var(irq_work_list);
+	if (llist_empty(this_list))
 		return;
 
 	BUG_ON(!in_irq());
 	BUG_ON(!irqs_disabled());
 
-	list = this_cpu_xchg(irq_work_list, NULL);
-
-	while (list != NULL) {
-		struct irq_work *entry = list;
+	llnode = llist_del_all(this_list);
+	while (llnode != NULL) {
+		work = llist_entry(llnode, struct irq_work, llnode);
 
-		list = irq_work_next(list);
+		llnode = llnode->next;
 
 		/*
-		 * Clear the PENDING bit, after this point the @entry
+		 * Clear the PENDING bit, after this point the @work
 		 * can be re-used.
 		 */
-		entry->next = next_flags(NULL, IRQ_WORK_BUSY);
-		entry->func(entry);
+		work->flags = IRQ_WORK_BUSY;
+		work->func(work);
 		/*
 		 * Clear the BUSY bit and return to the free state if
 		 * no-one else claimed it meanwhile.
 		 */
-		(void)cmpxchg(&entry->next,
-			      next_flags(NULL, IRQ_WORK_BUSY),
-			      NULL);
+		(void)cmpxchg(&work->flags, IRQ_WORK_BUSY, 0);
 	}
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
@@ -158,11 +132,11 @@ EXPORT_SYMBOL_GPL(irq_work_run);
  * Synchronize against the irq_work @entry, ensures the entry is not
  * currently in use.
  */
-void irq_work_sync(struct irq_work *entry)
+void irq_work_sync(struct irq_work *work)
 {
 	WARN_ON_ONCE(irqs_disabled());
 
-	while (irq_work_is_set(entry, IRQ_WORK_BUSY))
+	while (work->flags & IRQ_WORK_BUSY)
 		cpu_relax();
 }
 EXPORT_SYMBOL_GPL(irq_work_sync);
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch
lib-bitmapc-quiet-sparse-noise-about-address-space.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch

