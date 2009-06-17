From: akpm@linux-foundation.org
Subject: [merged] mm-introduce-follow_pfn.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:12 -0700
Message-ID: <200906171835.n5HIZCrw001262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760240AbZFQSgM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:36:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hch@infradead.org, hugh.dickins@tiscali.co.uk, hverkuil@xs4all.nl, lethal@linux-sh.org, magnus.damm@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: introduce follow_pfn()
has been removed from the -mm tree.  Its filename was
     mm-introduce-follow_pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce follow_pfn()
From: Johannes Weiner <hannes@cmpxchg.org>

Analoguous to follow_phys(), add a helper that looks up the PFN at a
user virtual address in an IO mapping or a raw PFN mapping.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>
Acked-by: Magnus Damm <magnus.damm@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/memory.c        |   29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff -puN include/linux/mm.h~mm-introduce-follow_pfn include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-follow_pfn
+++ a/include/linux/mm.h
@@ -792,6 +792,8 @@ int copy_page_range(struct mm_struct *ds
 			struct vm_area_struct *vma);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows);
+int follow_pfn(struct vm_area_struct *vma, unsigned long address,
+	unsigned long *pfn);
 int follow_phys(struct vm_area_struct *vma, unsigned long address,
 		unsigned int flags, unsigned long *prot, resource_size_t *phys);
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
diff -puN mm/memory.c~mm-introduce-follow_pfn mm/memory.c
--- a/mm/memory.c~mm-introduce-follow_pfn
+++ a/mm/memory.c
@@ -3140,6 +3140,35 @@ out:
 	return -EINVAL;
 }
 
+/**
+ * follow_pfn - look up PFN at a user virtual address
+ * @vma: memory mapping
+ * @address: user virtual address
+ * @pfn: location to store found PFN
+ *
+ * Only IO mappings and raw PFN mappings are allowed.
+ *
+ * Returns zero and the pfn at @pfn on success, -ve otherwise.
+ */
+int follow_pfn(struct vm_area_struct *vma, unsigned long address,
+	unsigned long *pfn)
+{
+	int ret = -EINVAL;
+	spinlock_t *ptl;
+	pte_t *ptep;
+
+	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+		return ret;
+
+	ret = follow_pte(vma->vm_mm, address, &ptep, &ptl);
+	if (ret)
+		return ret;
+	*pfn = pte_pfn(*ptep);
+	pte_unmap_unlock(ptep, ptl);
+	return 0;
+}
+EXPORT_SYMBOL(follow_pfn);
+
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 int follow_phys(struct vm_area_struct *vma,
 		unsigned long address, unsigned int flags,
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-fix-swap-accounting.patch
memcg-fix-swap-accounting-update.patch

