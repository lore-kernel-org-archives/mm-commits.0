From: akpm@linux-foundation.org
Subject: + intel-iommu-iova-allocation-and-management-routines.patch added to -mm tree
Date: Mon, 25 Jun 2007 23:42:52 -0700
Message-ID: <200706260642.l5Q6gq6g020220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48921 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881AbXFZGnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 02:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, muli@il.ibm.com, suresh.b.siddha@intel.com


The patch titled
     Intel IOMMU: IOVA allocation and management routines
has been added to the -mm tree.  Its filename is
     intel-iommu-iova-allocation-and-management-routines.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Intel IOMMU: IOVA allocation and management routines
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

This code implements a generic IOVA allocation and management.  As per Dave's
suggestion we are now allocating IO virtual address from Higher DMA limit
address rather than lower end address and this eliminated the need to preserve
the IO virtual address for multiple devices sharing the same domain virtual
address.

Also this code uses red black trees to store the allocated and reserved iova
nodes.  This showed a good performance improvements over previous linear
linked list.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/iova.c |  351 +++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/iova.h |   62 +++++++
 2 files changed, 413 insertions(+)

diff -puN /dev/null drivers/pci/iova.c
--- /dev/null
+++ a/drivers/pci/iova.c
@@ -0,0 +1,351 @@
+/*
+ * Copyright (c) 2006, Intel Corporation.
+ *
+ * This file is released under the GPLv2.
+ *
+ * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ */
+
+#include "iova.h"
+
+void
+init_iova_domain(struct iova_domain *iovad)
+{
+	spin_lock_init(&iovad->iova_alloc_lock);
+	spin_lock_init(&iovad->iova_rbtree_lock);
+	iovad->rbroot = RB_ROOT;
+	iovad->cached32_node = NULL;
+
+}
+
+static struct rb_node *
+__get_cached_rbnode(struct iova_domain *iovad, unsigned long *limit_pfn)
+{
+	if ((*limit_pfn != DMA_32BIT_PFN) ||
+		(iovad->cached32_node == NULL))
+		return rb_last(&iovad->rbroot);
+	else {
+		struct rb_node *prev_node = rb_prev(iovad->cached32_node);
+		struct iova *curr_iova =
+			container_of(iovad->cached32_node, struct iova, node);
+		*limit_pfn = curr_iova->pfn_lo - 1;
+		return prev_node;
+	}
+}
+
+static inline void
+__cached_rbnode_insert_update(struct iova_domain *iovad,
+	unsigned long limit_pfn, struct iova *new)
+{
+	if (limit_pfn != DMA_32BIT_PFN)
+		return;
+	iovad->cached32_node = &new->node;
+}
+
+static inline void
+__cached_rbnode_delete_update(struct iova_domain *iovad, struct iova *free)
+{
+	struct iova *cached_iova;
+	struct rb_node *curr;
+
+	if (!iovad->cached32_node)
+		return;
+	curr = iovad->cached32_node;
+	cached_iova = container_of(curr, struct iova, node);
+
+	if (free->pfn_lo >= cached_iova->pfn_lo)
+		iovad->cached32_node = rb_next(&free->node);
+}
+
+static inline int __alloc_iova_range(struct iova_domain *iovad,
+	unsigned long size, unsigned long limit_pfn, struct iova *new)
+{
+	struct rb_node *curr = NULL;
+	unsigned long flags;
+	unsigned long saved_pfn;
+
+	/* Walk the tree backwards */
+	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	saved_pfn = limit_pfn;
+	curr = __get_cached_rbnode(iovad, &limit_pfn);
+	while (curr) {
+		struct iova *curr_iova = container_of(curr, struct iova, node);
+		if (limit_pfn < curr_iova->pfn_lo)
+			goto move_left;
+		if (limit_pfn < curr_iova->pfn_hi)
+			goto adjust_limit_pfn;
+		if ((curr_iova->pfn_hi + size) <= limit_pfn)
+			break;	/* found a free slot */
+adjust_limit_pfn:
+		limit_pfn = curr_iova->pfn_lo - 1;
+move_left:
+		curr = rb_prev(curr);
+	}
+
+	if ((!curr) && !(IOVA_START_PFN + size <= limit_pfn)) {
+		spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+		return -ENOMEM;
+	}
+	new->pfn_hi = limit_pfn;
+	new->pfn_lo = limit_pfn - size + 1;
+
+	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+	return 0;
+}
+
+static void
+iova_insert_rbtree(struct rb_root *root, struct iova *iova)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+	/* Figure out where to put new node */
+	while (*new) {
+		struct iova *this = container_of(*new, struct iova, node);
+		parent = *new;
+
+		if (iova->pfn_lo < this->pfn_lo)
+			new = &((*new)->rb_left);
+		else if (iova->pfn_lo > this->pfn_lo)
+			new = &((*new)->rb_right);
+		else
+			BUG(); /* this should not happen */
+	}
+	/* Add new node and rebalance tree. */
+	rb_link_node(&iova->node, parent, new);
+	rb_insert_color(&iova->node, root);
+}
+
+/**
+ * alloc_iova - allocates an iova
+ * @iovad - iova domain in question
+ * @size - size of page frames to allocate
+ * @limit_pfn - max limit address
+ * This function allocates an iova in the range limit_pfn to IOVA_START_PFN
+ * looking from limit_pfn instead from IOVA_START_PFN.
+ */
+struct iova *
+alloc_iova(struct iova_domain *iovad, unsigned long size,
+	unsigned long limit_pfn)
+{
+	unsigned long flags;
+	struct iova *new_iova;
+	int ret;
+
+	new_iova = alloc_iova_mem();
+	if (!new_iova)
+		return NULL;
+
+	spin_lock_irqsave(&iovad->iova_alloc_lock, flags);
+	ret = __alloc_iova_range(iovad, size, limit_pfn, new_iova);
+
+	if (ret) {
+		spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
+		free_iova_mem(new_iova);
+		return NULL;
+	}
+
+	/* Insert the new_iova into domain rbtree by holding writer lock */
+	spin_lock(&iovad->iova_rbtree_lock);
+	iova_insert_rbtree(&iovad->rbroot, new_iova);
+	__cached_rbnode_insert_update(iovad, limit_pfn, new_iova);
+	spin_unlock(&iovad->iova_rbtree_lock);
+
+	spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
+
+	return new_iova;
+}
+
+/**
+ * find_iova - find's an iova for a given pfn
+ * @iovad - iova domain in question.
+ * pfn - page frame number
+ * This function finds and returns an iova belonging to the
+ * given doamin which matches the given pfn.
+ */
+struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn)
+{
+	unsigned long flags;
+	struct rb_node *node;
+
+	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	node = iovad->rbroot.rb_node;
+	while (node) {
+		struct iova *iova = container_of(node, struct iova, node);
+
+		/* If pfn falls within iova's range, return iova */
+		if ((pfn >= iova->pfn_lo) && (pfn <= iova->pfn_hi)) {
+			spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+			return iova;
+		}
+
+		if (pfn < iova->pfn_lo)
+			node = node->rb_left;
+		else if (pfn > iova->pfn_lo)
+			node = node->rb_right;
+	}
+
+	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+	return NULL;
+}
+
+/**
+ * __free_iova - frees the given iova
+ * @iovad: iova domain in question.
+ * @iova: iova in question.
+ * Frees the given iova belonging to the giving domain
+ */
+void
+__free_iova(struct iova_domain *iovad, struct iova *iova)
+{
+	unsigned long flags;
+
+	if (iova) {
+		spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+		__cached_rbnode_delete_update(iovad, iova);
+		rb_erase(&iova->node, &iovad->rbroot);
+		spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+		free_iova_mem(iova);
+	}
+}
+
+/**
+ * free_iova - finds and frees the iova for a given pfn
+ * @iovad: - iova domain in question.
+ * @pfn: - pfn that is allocated previously
+ * This functions finds an iova for a given pfn and then
+ * frees the iova from that domain.
+ */
+void
+free_iova(struct iova_domain *iovad, unsigned long pfn)
+{
+	struct iova *iova = find_iova(iovad, pfn);
+	__free_iova(iovad, iova);
+
+}
+
+/**
+ * put_iova_domain - destroys the iova doamin
+ * @iovad: - iova domain in question.
+ * All the iova's in that domain are destroyed.
+ */
+void put_iova_domain(struct iova_domain *iovad)
+{
+	struct rb_node *node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	node = rb_first(&iovad->rbroot);
+	while (node) {
+		struct iova *iova = container_of(node, struct iova, node);
+		rb_erase(node, &iovad->rbroot);
+		free_iova_mem(iova);
+		node = rb_first(&iovad->rbroot);
+	}
+	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+}
+
+static inline int
+__is_range_overlap(struct rb_node *node,
+	unsigned long pfn_lo, unsigned long pfn_hi)
+{
+	struct iova * iova = container_of(node, struct iova, node);
+
+	if ((pfn_lo <= iova->pfn_hi) && (pfn_hi >= iova->pfn_lo))
+		return 1;
+	return 0;
+}
+
+static inline struct iova *
+__insert_new_range(struct iova_domain *iovad,
+	unsigned long pfn_lo, unsigned long pfn_hi)
+{
+	struct iova *iova;
+
+	iova = alloc_iova_mem();
+	if (!iova)
+		return iova;
+
+	iova->pfn_hi = pfn_hi;
+	iova->pfn_lo = pfn_lo;
+	iova_insert_rbtree(&iovad->rbroot, iova);
+	return iova;
+}
+
+static inline void
+__adjust_overlap_range(struct iova *iova,
+	unsigned long *pfn_lo, unsigned long *pfn_hi)
+{
+	if (*pfn_lo < iova->pfn_lo)
+		iova->pfn_lo = *pfn_lo;
+	if (*pfn_hi > iova->pfn_hi)
+		*pfn_lo = iova->pfn_hi + 1;
+}
+
+/**
+ * reserve_iova - reserves an iova in the given range
+ * @iovad: - iova domain pointer
+ * @pfn_lo: - lower page frame address
+ * @pfn_hi:- higher pfn adderss
+ * This function allocates reserves the address range from pfn_lo to pfn_hi so
+ * that this address is not dished out as part of alloc_iova.
+ */
+struct iova *
+reserve_iova(struct iova_domain *iovad,
+	unsigned long pfn_lo, unsigned long pfn_hi)
+{
+	struct rb_node *node;
+	unsigned long flags;
+	struct iova *iova;
+	unsigned int overlap = 0;
+
+	spin_lock_irqsave(&iovad->iova_alloc_lock, flags);
+	spin_lock(&iovad->iova_rbtree_lock);
+	for (node = rb_first(&iovad->rbroot); node; node = rb_next(node)) {
+		if (__is_range_overlap(node, pfn_lo, pfn_hi)) {
+			iova = container_of(node, struct iova, node);
+			__adjust_overlap_range(iova, &pfn_lo, &pfn_hi);
+			if ((pfn_lo >= iova->pfn_lo) &&
+				(pfn_hi <= iova->pfn_hi))
+				goto finish;
+			overlap = 1;
+
+		} else if (overlap)
+				break;
+	}
+
+	/* We are here either becasue this is the first reserver node
+	 * or need to insert remaining non overlap addr range
+	 */
+	iova = __insert_new_range(iovad, pfn_lo, pfn_hi);
+finish:
+
+	spin_unlock(&iovad->iova_rbtree_lock);
+	spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
+	return iova;
+}
+
+/**
+ * copy_reserved_iova - copies the reserved between domains
+ * @from: - source doamin from where to copy
+ * @to: - destination domin where to copy
+ * This function copies reserved iova's from one doamin to
+ * other.
+ */
+void
+copy_reserved_iova(struct iova_domain *from, struct iova_domain *to)
+{
+	unsigned long flags;
+	struct rb_node *node;
+
+	spin_lock_irqsave(&from->iova_alloc_lock, flags);
+	spin_lock(&from->iova_rbtree_lock);
+	for (node = rb_first(&from->rbroot); node; node = rb_next(node)) {
+		struct iova *iova = container_of(node, struct iova, node);
+		struct iova *new_iova;
+		new_iova = reserve_iova(to, iova->pfn_lo, iova->pfn_hi);
+		if (!new_iova)
+			printk(KERN_ERR "Reserve iova range %lx@%lx failed\n",
+				iova->pfn_lo, iova->pfn_lo);
+	}
+	spin_unlock(&from->iova_rbtree_lock);
+	spin_unlock_irqrestore(&from->iova_alloc_lock, flags);
+}
diff -puN /dev/null drivers/pci/iova.h
--- /dev/null
+++ a/drivers/pci/iova.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright (c) 2006, Intel Corporation.
+ *
+ * This file is released under the GPLv2.
+ *
+ * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
+ *
+ */
+
+#ifndef _IOVA_H_
+#define _IOVA_H_
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/rbtree.h>
+#include <linux/dma-mapping.h>
+
+/*
+ * We need a fixed PAGE_SIZE of 4K irrespective of
+ * arch PAGE_SIZE for IOMMU page tables.
+ */
+#define PAGE_SHIFT_4K		(12)
+#define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
+#define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
+#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
+
+#define IOVA_START_ADDR		(0x1000)
+#define IOVA_START_PFN		(IOVA_START_ADDR >> PAGE_SHIFT_4K)
+
+#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)
+#define DMA_32BIT_PFN	IOVA_PFN(DMA_32BIT_MASK)
+#define DMA_64BIT_PFN	IOVA_PFN(DMA_64BIT_MASK)
+
+/* iova structure */
+struct iova {
+	struct rb_node	node;
+	unsigned long	pfn_hi; /* IOMMU dish out addr hi */
+	unsigned long	pfn_lo; /* IOMMU dish out addr lo */
+};
+
+/* holds all the iova translations for a domain */
+struct iova_domain {
+	spinlock_t	iova_alloc_lock;/* Lock to protect iova  allocation */
+	spinlock_t	iova_rbtree_lock; /* Lock to protect update of rbtree */
+	struct rb_root	rbroot;		/* iova domain rbtree root */
+	struct rb_node	*cached32_node; /* Save last alloced node */
+};
+
+struct iova *alloc_iova_mem(void);
+void free_iova_mem(struct iova *iova);
+void free_iova(struct iova_domain *iovad, unsigned long pfn);
+void __free_iova(struct iova_domain *iovad, struct iova *iova);
+struct iova * alloc_iova(struct iova_domain *iovad, unsigned long size,
+	unsigned long limit_pfn);
+struct iova * reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo,
+	unsigned long pfn_hi);
+void copy_reserved_iova(struct iova_domain *from, struct iova_domain *to);
+void init_iova_domain(struct iova_domain *iovad);
+struct iova * find_iova(struct iova_domain *iovad, unsigned long pfn);
+void put_iova_domain(struct iova_domain *iovad);
+
+#endif
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
jprobes-make-jprobes-a-little-safer-for-users-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
