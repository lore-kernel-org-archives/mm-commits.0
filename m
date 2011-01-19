From: akpm@linux-foundation.org
Subject: + llist-irq_work-use-llist-in-irq_work.patch added to -mm tree
Date: Wed, 19 Jan 2011 14:02:52 -0800
Message-ID: <201101192202.p0JM2qIf005828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753581Ab1ASWFP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 17:05:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ak@linux.intel.com, andy.grover@oracle.com, benh@kernel.crashing.org, chris@zankel.net, cmetcalf@tilera.com, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, hans-christian.egtvedt@atmel.com, kyle@mcmartin.ca, lethal@linux-sh.org, linux@arm.linux.org.uk, liqin.chen@sunplusct.com, mingo@redhat.com, monstr@monstr.eu, peterz@infradead.org, ralf@linux-mips.org, rth@twiddle.net, schwidefsky@de.ibm.com, starvik@axis.com, takata@linux-m32r.org, tony.luck@intel.com, vapier@gentoo.org, ysato@users.sourceforge.jp


The patch titled
     llist: irq_work, Use llist in irq_work
has been added to the -mm tree.  Its filename is
     llist-irq_work-use-llist-in-irq_work.patch

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
Subject: llist: irq_work, Use llist in irq_work
From: Huang Ying <ying.huang@intel.com>

Use llist in irq_work instead of the lock-less linked list implementation
in irq_work to avoid the code duplication.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mikael Starvik <starvik@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Andy Grover <andy.grover@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq_work.h |   15 +++---
 init/Kconfig             |    1 
 kernel/irq_work.c        |   92 ++++++++++++++-----------------------
 3 files changed, 47 insertions(+), 61 deletions(-)

diff -puN include/linux/irq_work.h~llist-irq_work-use-llist-in-irq_work include/linux/irq_work.h
--- a/include/linux/irq_work.h~llist-irq_work-use-llist-in-irq_work
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
diff -puN init/Kconfig~llist-irq_work-use-llist-in-irq_work init/Kconfig
--- a/init/Kconfig~llist-irq_work-use-llist-in-irq_work
+++ a/init/Kconfig
@@ -27,6 +27,7 @@ config HAVE_IRQ_WORK
 config IRQ_WORK
 	bool
 	depends on HAVE_IRQ_WORK
+	select LLIST
 
 menu "General setup"
 
diff -puN kernel/irq_work.c~llist-irq_work-use-llist-in-irq_work kernel/irq_work.c
--- a/kernel/irq_work.c~llist-irq_work-use-llist-in-irq_work
+++ a/kernel/irq_work.c
@@ -17,49 +17,34 @@
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
+#define LIST_NONEMPTY_BIT	0
 
-static inline struct irq_work *next_flags(struct irq_work *entry, int flags)
-{
-	unsigned long next = (unsigned long)entry;
-	next |= flags;
-	return (struct irq_work *)next;
-}
+struct irq_work_list {
+	unsigned long flags;
+	struct llist_head llist;
+};
 
-static DEFINE_PER_CPU(struct irq_work *, irq_work_list);
+static DEFINE_PER_CPU(struct irq_work_list, irq_work_lists);
 
 /*
  * Claim the entry so that no one else will poke at it.
  */
-static bool irq_work_claim(struct irq_work *entry)
+static bool irq_work_claim(struct irq_work *work)
 {
-	struct irq_work *next, *nflags;
+	unsigned long flags, nflags;
 
 	do {
-		next = entry->next;
-		if ((unsigned long)next & IRQ_WORK_PENDING)
+		flags = work->flags;
+		if (flags & IRQ_WORK_PENDING)
 			return false;
-		nflags = next_flags(next, IRQ_WORK_FLAGS);
-	} while (cmpxchg(&entry->next, next, nflags) != next);
+		nflags = flags | IRQ_WORK_FLAGS;
+	} while (cmpxchg(&work->flags, flags, nflags) != flags);
 
 	return true;
 }
@@ -75,23 +60,19 @@ void __weak arch_irq_work_raise(void)
 /*
  * Queue the entry and raise the IPI if needed.
  */
-static void __irq_work_queue(struct irq_work *entry)
+static void __irq_work_queue(struct irq_work *work)
 {
-	struct irq_work *next;
+	struct irq_work_list *irq_work_list;
 
-	preempt_disable();
+	irq_work_list = &get_cpu_var(irq_work_lists);
 
-	do {
-		next = __this_cpu_read(irq_work_list);
-		/* Can assign non-atomic because we keep the flags set. */
-		entry->next = next_flags(next, IRQ_WORK_FLAGS);
-	} while (this_cpu_cmpxchg(irq_work_list, next, entry) != next);
+	llist_add(&work->llnode, &irq_work_list->llist);
 
 	/* The list was empty, raise self-interrupt to start processing. */
-	if (!irq_work_next(entry))
+	if (!test_and_set_bit(LIST_NONEMPTY_BIT, &irq_work_list->flags))
 		arch_irq_work_raise();
 
-	preempt_enable();
+	put_cpu_var(irq_work_list);
 }
 
 /*
@@ -100,16 +81,16 @@ static void __irq_work_queue(struct irq_
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
@@ -120,34 +101,35 @@ EXPORT_SYMBOL_GPL(irq_work_queue);
  */
 void irq_work_run(void)
 {
-	struct irq_work *list;
+	struct irq_work *work;
+	struct irq_work_list *irq_work_list;
+	struct llist_node *llnode;
 
-	if (this_cpu_read(irq_work_list) == NULL)
+	irq_work_list = &__get_cpu_var(irq_work_lists);
+	if (llist_empty(&irq_work_list->llist))
 		return;
 
 	BUG_ON(!in_irq());
 	BUG_ON(!irqs_disabled());
 
-	list = this_cpu_xchg(irq_work_list, NULL);
-
-	while (list != NULL) {
-		struct irq_work *entry = list;
+	clear_bit(LIST_NONEMPTY_BIT, &irq_work_list->flags);
+	llnode = llist_del_all(&irq_work_list->llist);
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
@@ -156,11 +138,11 @@ EXPORT_SYMBOL_GPL(irq_work_run);
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

llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg.patch
llist-lib-add-lock-less-null-terminated-single-list.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

