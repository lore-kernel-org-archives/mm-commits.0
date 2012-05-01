From: akpm@linux-foundation.org
Subject: [withdrawn] irqdesc-add-reference-counting.patch removed from -mm tree
Date: Tue, 01 May 2012 15:30:31 -0700
Message-ID: <20120501223032.19756A0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:50391 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2EAWae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 May 2012 18:30:34 -0400
Received: by bkty5 with SMTP id y5so517bkt.1
        for <mm-commits@vger.kernel.org>; Tue, 01 May 2012 15:30:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: grant.likely@secretlab.ca, benh@kernel.crashing.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: irqdesc: add reference counting
has been removed from the -mm tree.  Its filename was
     irqdesc-add-reference-counting.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Grant Likely <grant.likely@secretlab.ca>
Subject: irqdesc: add reference counting

The irq_domain subsystem is currently buggy where if two devices map the
same irq and then one of them then disposes of the mapping, then the
mapping will get deleted for the first device too and interrupts will stop
working for it.

This patch solves the problem by adding a reference count to each
irq_desc.  When an irq_desc is allocated, the reference count is set to 1.
 Drivers (ie.  an irq_domain) can get and put an irq to ensure an
allocation will not be removed until the last user releases it.  When the
reference count reaches zero, then any irq_domain mappings get released,
and the irq_desc is freed.

irq_domain is the only real user of the reference counting at the moment,
but it should work equally well for any interrupt controller that directly
manages irq_desc allocations and needs to keep track of how many users
each irq has.

This implementation preserves the behaviour of irq_free_descs() instead of
requiring all users to 'put' the irq.  However, it complains loudly if the
reference count is non-zero when called.

This patch is almost certainly buggy, but I want to get it out there for
comments.  Thomas/Ben, what do you think of this approach?

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/irq.h     |    3 +
 include/linux/irqdesc.h |    3 +
 kernel/irq/irqdesc.c    |   64 +++++++++++++++++++++++++++++++-------
 kernel/irq/irqdomain.c  |   20 ++++++++++-
 4 files changed, 76 insertions(+), 14 deletions(-)

diff -puN include/linux/irq.h~irqdesc-add-reference-counting include/linux/irq.h
--- a/include/linux/irq.h~irqdesc-add-reference-counting
+++ a/include/linux/irq.h
@@ -594,6 +594,9 @@ int __irq_alloc_descs(int irq, unsigned 
 
 void irq_free_descs(unsigned int irq, unsigned int cnt);
 int irq_reserve_irqs(unsigned int from, unsigned int cnt);
+void irq_get_desc(unsigned int irq);
+int irq_put_desc(unsigned int irq);
+void irq_domain_release(unsigned int irq);
 
 static inline void irq_free_desc(unsigned int irq)
 {
diff -puN include/linux/irqdesc.h~irqdesc-add-reference-counting include/linux/irqdesc.h
--- a/include/linux/irqdesc.h~irqdesc-add-reference-counting
+++ a/include/linux/irqdesc.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_IRQDESC_H
 #define _LINUX_IRQDESC_H
 
+#include <linux/kref.h>
+
 /*
  * Core internal functions to deal with irq descriptors
  *
@@ -42,6 +44,7 @@ struct irq_desc {
 	struct timer_rand_state *timer_rand_state;
 	unsigned int __percpu	*kstat_irqs;
 	irq_flow_handler_t	handle_irq;
+	struct kref		kref;
 #ifdef CONFIG_IRQ_PREFLOW_FASTEOI
 	irq_preflow_handler_t	preflow_handler;
 #endif
diff -puN kernel/irq/irqdesc.c~irqdesc-add-reference-counting kernel/irq/irqdesc.c
--- a/kernel/irq/irqdesc.c~irqdesc-add-reference-counting
+++ a/kernel/irq/irqdesc.c
@@ -147,6 +147,7 @@ static struct irq_desc *alloc_desc(int i
 		goto err_kstat;
 
 	raw_spin_lock_init(&desc->lock);
+	kref_init(&desc->kref);
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 
 	desc_set_defaults(irq, desc, node, owner);
@@ -193,11 +194,8 @@ static int alloc_descs(unsigned int star
 
 err:
 	for (i--; i >= 0; i--)
-		free_desc(start + i);
+		irq_desc_put(start + i);
 
-	mutex_lock(&sparse_irq_lock);
-	bitmap_clear(allocated_irqs, start, cnt);
-	mutex_unlock(&sparse_irq_lock);
 	return -ENOMEM;
 }
 
@@ -263,6 +261,7 @@ int __init early_irq_init(void)
 		desc[i].kstat_irqs = alloc_percpu(unsigned int);
 		alloc_masks(&desc[i], GFP_KERNEL, node);
 		raw_spin_lock_init(&desc[i].lock);
+		kref_init(&desc[i].kref);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
 		desc_set_defaults(i, &desc[i], node, NULL);
 	}
@@ -288,6 +287,7 @@ static inline int alloc_descs(unsigned i
 		struct irq_desc *desc = irq_to_desc(start + i);
 
 		desc->owner = owner;
+		kref_init(&desc->kref);
 	}
 	return start;
 }
@@ -322,22 +322,64 @@ EXPORT_SYMBOL_GPL(generic_handle_irq);
  * @from:	Start of descriptor range
  * @cnt:	Number of consecutive irqs to free
  */
+static void __irq_free_desc(unsigned int irq)
+{
+	free_desc(irq);
+
+	mutex_lock(&sparse_irq_lock);
+	bitmap_clear(allocated_irqs, irq, 1);
+	mutex_unlock(&sparse_irq_lock);
+}
+
+static void irq_release_desc(struct kref *kref)
+{
+	struct irq_desc *desc = container_of(kref, struct irq_desc, kref);
+	irq_domain_release(desc->irq_data.irq);
+	__irq_free_desc(desc->irq_data.irq);
+}
+
+/**
+ * irq_get_desc() - Increment reference count on irq desc
+ * @desc:	irq_desc instance to get
+ */
+void irq_get_desc(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	if (desc)
+		kref_get(&desc->kref);
+}
+EXPORT_SYMBOL_GPL(irq_get_desc);
+
+/**
+ * irq_put_desc() - Decrement reference count and conditionally release irq_desc
+ * @desc:	irq_desc instance to put
+ *
+ * When reference count reaches zero, the irq_desc gets freed/released.
+ */
+int irq_put_desc(unsigned int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	if (desc)
+		return kref_put(&desc->kref, irq_release_desc);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_put_desc);
+
 void irq_free_descs(unsigned int from, unsigned int cnt)
 {
 	int i;
 
-	if (from >= nr_irqs || (from + cnt) > nr_irqs)
-		return;
+	WARN(from >= nr_irqs || (from + cnt) > nr_irqs,
+	     "ERROR: irq_free_descs(from=%i, cnt=%i) is out of range; "
+	     "nr_irqs=%i\n", from, cnt, nr_irqs);
 
 	for (i = 0; i < cnt; i++)
-		free_desc(from + i);
-
-	mutex_lock(&sparse_irq_lock);
-	bitmap_clear(allocated_irqs, from, cnt);
-	mutex_unlock(&sparse_irq_lock);
+		WARN(irq_put_desc(from + i) == 0,
+		     "ERROR: nonzero refcount when freeing irq%i\n", from + i);
 }
 EXPORT_SYMBOL_GPL(irq_free_descs);
 
+
 /**
  * irq_alloc_descs - allocate and initialize a range of irq descriptors
  * @irq:	Allocate for specific irq number if irq >= 0
diff -puN kernel/irq/irqdomain.c~irqdesc-add-reference-counting kernel/irq/irqdomain.c
--- a/kernel/irq/irqdomain.c~irqdesc-add-reference-counting
+++ a/kernel/irq/irqdomain.c
@@ -354,6 +354,7 @@ unsigned int irq_create_mapping(struct i
 	/* Check if mapping already exists */
 	virq = irq_find_mapping(domain, hwirq);
 	if (virq) {
+		irq_get_desc(virq);
 		pr_debug("irq: -> existing mapping on virq %d\n", virq);
 		return virq;
 	}
@@ -444,6 +445,22 @@ void irq_dispose_mapping(unsigned int vi
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
 	struct irq_domain *domain;
+
+	if (!virq || !irq_data)
+		return;
+
+	domain = irq_data->domain;
+	if (WARN_ON(domain == NULL))
+		return;
+
+	irq_put_desc(virq);
+}
+EXPORT_SYMBOL_GPL(irq_dispose_mapping);
+
+void irq_domain_release(unsigned int virq)
+{
+	struct irq_data *irq_data = irq_get_irq_data(virq);
+	struct irq_domain *domain;
 	irq_hw_number_t hwirq;
 
 	if (!virq || !irq_data)
@@ -483,10 +500,7 @@ void irq_dispose_mapping(unsigned int vi
 		mutex_unlock(&revmap_trees_mutex);
 		break;
 	}
