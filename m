From: akpm@linux-foundation.org
Subject: + mm-introduce-follow_pfn.patch added to -mm tree
Date: Tue, 05 May 2009 12:24:53 -0700
Message-ID: <200905051924.n45JOrE5005826@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57261 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758386AbZEET3x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 15:29:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, hch@infradead.org, hugh@veritas.com, hverkuil@xs4all.nl, lethal@linux-sh.org, magnus.damm@gmail.com


The patch titled
     mm: introduce follow_pfn()
has been added to the -mm tree.  Its filename is
     mm-introduce-follow_pfn.patch

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
Subject: mm: introduce follow_pfn()
From: Johannes Weiner <hannes@cmpxchg.org>

Analoguous to follow_phys(), add a helper that looks up the PFN at a
user virtual address in an IO mapping or a raw PFN mapping.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/memory.c        |   29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff -puN include/linux/mm.h~mm-introduce-follow_pfn include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-follow_pfn
+++ a/include/linux/mm.h
@@ -817,6 +817,8 @@ int copy_page_range(struct mm_struct *ds
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
@@ -3228,6 +3228,35 @@ out:
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
linux-next.patch
eliminate-thousands-of-warnings-with-gcc-32-build.patch
eliminate-thousands-of-warnings-with-gcc-32-build-cleanup.patch
mm-page-writebackc-dirty-limit-type-should-be-unsigned-long.patch
vmscan-evict-use-once-pages-first-v3.patch
mm-introduce-follow_pte.patch
mm-use-generic-follow_pte-in-follow_phys.patch
mm-introduce-follow_pfn.patch

