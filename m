From: akpm@linux-foundation.org
Subject: - introduce-__get_user_pages.patch removed from -mm tree
Date: Mon, 28 Jul 2008 17:57:36 -0700
Message-ID: <200807290057.m6T0vaGh005580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbYG2A6f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 20:58:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, hugh@veritas.com, lizf@cn.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     splitlru: introduce __get_user_pages()
has been removed from the -mm tree.  Its filename was
     introduce-__get_user_pages.patch

This patch was dropped because it was folded into mlock-mlocked-pages-are-unevictable.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: splitlru: introduce __get_user_pages()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

New munlock processing need to GUP_FLAGS_IGNORE_VMA_PERMISSIONS.  because
current get_user_pages() can't grab PROT_NONE pages theresore it cause
PROT_NONE pages can't munlock.

[akpm@linux-foundation.org: build fix]
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    8 ++++++++
 mm/memory.c   |   37 +++++++++++++++++++++++++++++++------
 mm/nommu.c    |   44 +++++++++++++++++++++++++++++++++-----------
 3 files changed, 72 insertions(+), 17 deletions(-)

diff -puN mm/internal.h~introduce-__get_user_pages mm/internal.h
--- a/mm/internal.h~introduce-__get_user_pages
+++ a/mm/internal.h
@@ -211,4 +211,12 @@ static inline void mminit_validate_memmo
 }
 #endif /* CONFIG_SPARSEMEM */
 
+#define GUP_FLAGS_WRITE                  0x1
+#define GUP_FLAGS_FORCE                  0x2
+#define GUP_FLAGS_IGNORE_VMA_PERMISSIONS 0x4
+
+int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		     unsigned long start, int len, int flags,
+		     struct page **pages, struct vm_area_struct **vmas);
+
 #endif
diff -puN mm/memory.c~introduce-__get_user_pages mm/memory.c
--- a/mm/memory.c~introduce-__get_user_pages
+++ a/mm/memory.c
@@ -1108,12 +1108,17 @@ static inline int use_zero_page(struct v
 	return !vma->vm_ops || !vma->vm_ops->fault;
 }
 
-int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long start, int len, int write, int force,
+
+
+int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		     unsigned long start, int len, int flags,
 		struct page **pages, struct vm_area_struct **vmas)
 {
 	int i;
-	unsigned int vm_flags;
+	unsigned int vm_flags = 0;
+	int write = !!(flags & GUP_FLAGS_WRITE);
+	int force = !!(flags & GUP_FLAGS_FORCE);
+	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
 
 	if (len <= 0)
 		return 0;
@@ -1137,7 +1142,9 @@ int get_user_pages(struct task_struct *t
 			pud_t *pud;
 			pmd_t *pmd;
 			pte_t *pte;
-			if (write) /* user gate pages are read-only */
+
+			/* user gate pages are read-only */
+			if (!ignore && write)
 				return i ? : -EFAULT;
 			if (pg > TASK_SIZE)
 				pgd = pgd_offset_k(pg);
@@ -1169,8 +1176,9 @@ int get_user_pages(struct task_struct *t
 			continue;
 		}
 
-		if (!vma || (vma->vm_flags & (VM_IO | VM_PFNMAP))
-				|| !(vm_flags & vma->vm_flags))
+		if (!vma ||
+		    (vma->vm_flags & (VM_IO | VM_PFNMAP)) ||
+		    (!ignore && !(vm_flags & vma->vm_flags)))
 			return i ? : -EFAULT;
 
 		if (is_vm_hugetlb_page(vma)) {
@@ -1245,6 +1253,23 @@ int get_user_pages(struct task_struct *t
 	} while (len);
 	return i;
 }
+
+int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		unsigned long start, int len, int write, int force,
+		struct page **pages, struct vm_area_struct **vmas)
+{
+	int flags = 0;
+
+	if (write)
+		flags |= GUP_FLAGS_WRITE;
+	if (force)
+		flags |= GUP_FLAGS_FORCE;
+
+	return __get_user_pages(tsk, mm,
+				start, len, flags,
+				pages, vmas);
+}
+
 EXPORT_SYMBOL(get_user_pages);
 
 pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
diff -puN mm/nommu.c~introduce-__get_user_pages mm/nommu.c
--- a/mm/nommu.c~introduce-__get_user_pages
+++ a/mm/nommu.c
@@ -34,6 +34,8 @@
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
 
+#include "internal.h"
+
 void *high_memory;
 struct page *mem_map;
 unsigned long max_mapnr;
@@ -128,20 +130,16 @@ unsigned int kobjsize(const void *objp)
 	return PAGE_SIZE << compound_order(page);
 }
 
-/*
- * get a list of pages in an address range belonging to the specified process
- * and indicate the VMA that covers each page
- * - this is potentially dodgy as we may end incrementing the page count of a
- *   slab page or a secondary page from a compound page
- * - don't permit access to VMAs that don't support it, such as I/O mappings
- */
-int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-	unsigned long start, int len, int write, int force,
-	struct page **pages, struct vm_area_struct **vmas)
+int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		     unsigned long start, int len, int flags,
+		struct page **pages, struct vm_area_struct **vmas)
 {
 	struct vm_area_struct *vma;
 	unsigned long vm_flags;
 	int i;
+	int write = !!(flags & GUP_FLAGS_WRITE);
+	int force = !!(flags & GUP_FLAGS_FORCE);
+	int ignore = !!(flags & GUP_FLAGS_IGNORE_VMA_PERMISSIONS);
 
 	/* calculate required read or write permissions.
 	 * - if 'force' is set, we only require the "MAY" flags.
@@ -156,7 +154,7 @@ int get_user_pages(struct task_struct *t
 
 		/* protect what we can, including chardevs */
 		if (vma->vm_flags & (VM_IO | VM_PFNMAP) ||
-		    !(vm_flags & vma->vm_flags))
+		    (!ignore && !(vm_flags & vma->vm_flags)))
 			goto finish_or_fault;
 
 		if (pages) {
@@ -174,6 +172,30 @@ int get_user_pages(struct task_struct *t
 finish_or_fault:
 	return i ? : -EFAULT;
 }
+
+
+/*
+ * get a list of pages in an address range belonging to the specified process
+ * and indicate the VMA that covers each page
+ * - this is potentially dodgy as we may end incrementing the page count of a
+ *   slab page or a secondary page from a compound page
+ * - don't permit access to VMAs that don't support it, such as I/O mappings
+ */
+int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+	unsigned long start, int len, int write, int force,
+	struct page **pages, struct vm_area_struct **vmas)
+{
+	int flags = 0;
+
+	if (write)
+		flags |= GUP_FLAGS_WRITE;
+	if (force)
+		flags |= GUP_FLAGS_FORCE;
+
+	return __get_user_pages(tsk, mm,
+				start, len, flags,
+				pages, vmas);
+}
 EXPORT_SYMBOL(get_user_pages);
 
 DEFINE_RWLOCK(vmlist_lock);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
shm_locked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable.patch
introduce-__get_user_pages.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmstat-mlocked-pages-statistics.patch
swap-cull-unevictable-pages-in-fault-path.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-rmapc-anon_vma_cachep-static.patch

