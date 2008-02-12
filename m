From: akpm@linux-foundation.org
Subject: + pci-iova-rb-tree-setup-tweak.patch added to -mm tree
Date: Tue, 12 Feb 2008 11:49:33 -0800
Message-ID: <200802121949.m1CJnXZt019198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38370 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299AbYBLTtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Feb 2008 14:49:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgross@linux.intel.com, greg@kroah.com


The patch titled
     pci: iova RB tree setup tweak
has been added to the -mm tree.  Its filename is
     pci-iova-rb-tree-setup-tweak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci: iova RB tree setup tweak
From: mark gross <mgross@linux.intel.com>

The following patch merges two functions into one allowing for a 3%
reduction in overhead in locating, allocating and inserting pages for
use in IOMMU operations.

Its a bit of a eye-crosser so I welcome any RB-tree / MM experts to take
a look.  It works by re-using some of the information gathered in the
search for the pages to use in setting up the IOTLB's in the insertion
of the iova structure into the RB tree.

Signed-off-by: <mgross@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/iova.c |   50 ++++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 14 deletions(-)

diff -puN drivers/pci/iova.c~pci-iova-rb-tree-setup-tweak drivers/pci/iova.c
--- a/drivers/pci/iova.c~pci-iova-rb-tree-setup-tweak
+++ a/drivers/pci/iova.c
@@ -72,10 +72,11 @@ iova_get_pad_size(int size, unsigned int
 	return pad_size;
 }
 
-static int __alloc_iova_range(struct iova_domain *iovad, unsigned long size,
-		unsigned long limit_pfn, struct iova *new, bool size_aligned)
+static int __alloc_and_insert_iova_range(struct iova_domain *iovad,
+		unsigned long size, unsigned long limit_pfn,
+			struct iova *new, bool size_aligned)
 {
-	struct rb_node *curr = NULL;
+	struct rb_node *prev, *curr = NULL;
 	unsigned long flags;
 	unsigned long saved_pfn;
 	unsigned int pad_size = 0;
@@ -84,8 +85,10 @@ static int __alloc_iova_range(struct iov
 	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
 	saved_pfn = limit_pfn;
 	curr = __get_cached_rbnode(iovad, &limit_pfn);
+	prev = curr;
 	while (curr) {
 		struct iova *curr_iova = container_of(curr, struct iova, node);
+
 		if (limit_pfn < curr_iova->pfn_lo)
 			goto move_left;
 		else if (limit_pfn < curr_iova->pfn_hi)
@@ -99,6 +102,7 @@ static int __alloc_iova_range(struct iov
 adjust_limit_pfn:
 		limit_pfn = curr_iova->pfn_lo - 1;
 move_left:
+		prev = curr;
 		curr = rb_prev(curr);
 	}
 
@@ -115,7 +119,33 @@ move_left:
 	new->pfn_lo = limit_pfn - (size + pad_size) + 1;
 	new->pfn_hi = new->pfn_lo + size - 1;
 
+	/* Insert the new_iova into domain rbtree by holding writer lock */
+	/* Add new node and rebalance tree. */
+	{
+		struct rb_node **entry = &((prev)), *parent = NULL;
+		/* Figure out where to put new node */
+		while (*entry) {
+			struct iova *this = container_of(*entry,
+							struct iova, node);
+			parent = *entry;
+
+			if (new->pfn_lo < this->pfn_lo)
+				entry = &((*entry)->rb_left);
+			else if (new->pfn_lo > this->pfn_lo)
+				entry = &((*entry)->rb_right);
+			else
+				BUG(); /* this should not happen */
+		}
+
+		/* Add new node and rebalance tree. */
+		rb_link_node(&new->node, parent, entry);
+		rb_insert_color(&new->node, &iovad->rbroot);
+	}
+	__cached_rbnode_insert_update(iovad, saved_pfn, new);
+
 	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+
+
 	return 0;
 }
 
@@ -171,23 +201,15 @@ alloc_iova(struct iova_domain *iovad, un
 		size = __roundup_pow_of_two(size);
 
 	spin_lock_irqsave(&iovad->iova_alloc_lock, flags);
-	ret = __alloc_iova_range(iovad, size, limit_pfn, new_iova,
-			size_aligned);
+	ret = __alloc_and_insert_iova_range(iovad, size, limit_pfn,
+			new_iova, size_aligned);
 
+	spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
 	if (ret) {
-		spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
 		free_iova_mem(new_iova);
 		return NULL;
 	}
 
-	/* Insert the new_iova into domain rbtree by holding writer lock */
-	spin_lock(&iovad->iova_rbtree_lock);
-	iova_insert_rbtree(&iovad->rbroot, new_iova);
-	__cached_rbnode_insert_update(iovad, limit_pfn, new_iova);
-	spin_unlock(&iovad->iova_rbtree_lock);
-
-	spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);
-
 	return new_iova;
 }
 
_

Patches currently in -mm which might be from mgross@linux.intel.com are

origin.patch
pci-iova-rb-tree-setup-tweak.patch
