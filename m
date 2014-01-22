From: akpm@linux-foundation.org
Subject: [merged] mm-rmap-use-rmap_walk-in-try_to_unmap.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:13:28 -0800
Message-ID: <52e02668.I2aPsM8QUb20HvLZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbaAVUN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mingo@kernel.org, mgorman@suse.de, hughd@google.com, dhillf@gmail.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-rmap-use-rmap_walk-in-try_to_unmap.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,dhillf@gmail.com,hughd@google.com,mgorman@suse.de,mingo@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:28 -0800


The patch titled
     Subject: mm/rmap: use rmap_walk() in try_to_unmap()
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-rmap_walk-in-try_to_unmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/rmap: use rmap_walk() in try_to_unmap()

Now, we have an infrastructure in rmap_walk() to handle difference from
variants of rmap traversing functions.

So, just use it in try_to_unmap().

In this patch, I change following things.

1. enable rmap_walk() if !CONFIG_MIGRATION.
2. mechanical change to use rmap_walk() in try_to_unmap().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    5 ----
 mm/ksm.c             |    4 +--
 mm/rmap.c            |   48 ++++++++++++++++++++++++++++++-----------
 3 files changed, 39 insertions(+), 18 deletions(-)

diff -puN include/linux/rmap.h~mm-rmap-use-rmap_walk-in-try_to_unmap include/linux/rmap.h
--- a/include/linux/rmap.h~mm-rmap-use-rmap_walk-in-try_to_unmap
+++ a/include/linux/rmap.h
@@ -190,7 +190,7 @@ int page_referenced_one(struct page *, s
 
 int try_to_unmap(struct page *, enum ttu_flags flags);
 int try_to_unmap_one(struct page *, struct vm_area_struct *,
-			unsigned long address, enum ttu_flags flags);
+			unsigned long address, void *arg);
 
 /*
  * Called from mm/filemap_xip.c to unmap empty zero page
@@ -256,9 +256,6 @@ struct rmap_walk_control {
 	bool (*invalid_vma)(struct vm_area_struct *vma, void *arg);
 };
 
-/*
- * Called by migrate.c to remove migration ptes, but might be used more later.
- */
 int rmap_walk(struct page *page, struct rmap_walk_control *rwc);
 
 #else	/* !CONFIG_MMU */
diff -puN mm/ksm.c~mm-rmap-use-rmap_walk-in-try_to_unmap mm/ksm.c
--- a/mm/ksm.c~mm-rmap-use-rmap_walk-in-try_to_unmap
+++ a/mm/ksm.c
@@ -1982,7 +1982,7 @@ again:
 				continue;
 
 			ret = try_to_unmap_one(page, vma,
-					rmap_item->address, flags);
+					rmap_item->address, (void *)flags);
 			if (ret != SWAP_AGAIN || !page_mapped(page)) {
 				anon_vma_unlock_read(anon_vma);
 				goto out;
@@ -1996,7 +1996,6 @@ out:
 	return ret;
 }
 
-#ifdef CONFIG_MIGRATION
 int rmap_walk_ksm(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct stable_node *stable_node;
@@ -2054,6 +2053,7 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_MIGRATION
 void ksm_migrate_page(struct page *newpage, struct page *oldpage)
 {
 	struct stable_node *stable_node;
diff -puN mm/rmap.c~mm-rmap-use-rmap_walk-in-try_to_unmap mm/rmap.c
--- a/mm/rmap.c~mm-rmap-use-rmap_walk-in-try_to_unmap
+++ a/mm/rmap.c
@@ -1179,15 +1179,18 @@ out:
 /*
  * Subfunctions of try_to_unmap: try_to_unmap_one called
  * repeatedly from try_to_unmap_ksm, try_to_unmap_anon or try_to_unmap_file.
+ *
+ * @arg: enum ttu_flags will be passed to this argument
  */
 int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
-		     unsigned long address, enum ttu_flags flags)
+		     unsigned long address, void *arg)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *pte;
 	pte_t pteval;
 	spinlock_t *ptl;
 	int ret = SWAP_AGAIN;
+	enum ttu_flags flags = (enum ttu_flags)arg;
 
 	pte = page_check_address(page, mm, address, &ptl, 0);
 	if (!pte)
@@ -1513,6 +1516,11 @@ bool is_vma_temporary_stack(struct vm_ar
 	return false;
 }
 
+static bool invalid_migration_vma(struct vm_area_struct *vma, void *arg)
+{
+	return is_vma_temporary_stack(vma);
+}
+
 /**
  * try_to_unmap_anon - unmap or unlock anonymous page using the object-based
  * rmap method
@@ -1558,7 +1566,7 @@ static int try_to_unmap_anon(struct page
 			continue;
 
 		address = vma_address(page, vma);
-		ret = try_to_unmap_one(page, vma, address, flags);
+		ret = try_to_unmap_one(page, vma, address, (void *)flags);
 		if (ret != SWAP_AGAIN || !page_mapped(page))
 			break;
 	}
@@ -1592,7 +1600,7 @@ static int try_to_unmap_file(struct page
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
-		ret = try_to_unmap_one(page, vma, address, flags);
+		ret = try_to_unmap_one(page, vma, address, (void *)flags);
 		if (ret != SWAP_AGAIN || !page_mapped(page))
 			goto out;
 	}
@@ -1614,6 +1622,11 @@ out:
 	return ret;
 }
 
+static int page_not_mapped(struct page *page)
+{
+	return !page_mapped(page);
+};
+
 /**
  * try_to_unmap - try to remove all page table mappings to a page
  * @page: the page to get unmapped
@@ -1631,16 +1644,29 @@ out:
 int try_to_unmap(struct page *page, enum ttu_flags flags)
 {
 	int ret;
+	struct rmap_walk_control rwc = {
+		.rmap_one = try_to_unmap_one,
+		.arg = (void *)flags,
+		.done = page_not_mapped,
+		.file_nonlinear = try_to_unmap_nonlinear,
+		.anon_lock = page_lock_anon_vma_read,
+	};
 
-	BUG_ON(!PageLocked(page));
 	VM_BUG_ON(!PageHuge(page) && PageTransHuge(page));
 
-	if (unlikely(PageKsm(page)))
-		ret = try_to_unmap_ksm(page, flags);
-	else if (PageAnon(page))
-		ret = try_to_unmap_anon(page, flags);
-	else
-		ret = try_to_unmap_file(page, flags);
+	/*
+	 * During exec, a temporary VMA is setup and later moved.
+	 * The VMA is moved under the anon_vma lock but not the
+	 * page tables leading to a race where migration cannot
+	 * find the migration ptes. Rather than increasing the
+	 * locking requirements of exec(), migration skips
+	 * temporary VMAs until after exec() completes.
+	 */
+	if (flags & TTU_MIGRATION && !PageKsm(page) && PageAnon(page))
+		rwc.invalid_vma = invalid_migration_vma;
+
+	ret = rmap_walk(page, &rwc);
+
 	if (ret != SWAP_MLOCK && !page_mapped(page))
 		ret = SWAP_SUCCESS;
 	return ret;
@@ -1683,7 +1709,6 @@ void __put_anon_vma(struct anon_vma *ano
 	anon_vma_free(anon_vma);
 }
 
-#ifdef CONFIG_MIGRATION
 static struct anon_vma *rmap_walk_anon_lock(struct page *page,
 					struct rmap_walk_control *rwc)
 {
@@ -1785,7 +1810,6 @@ int rmap_walk(struct page *page, struct
 	else
 		return rmap_walk_file(page, rwc);
 }
-#endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_HUGETLB_PAGE
 /*
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
mm-free-memblockmemory-in-free_all_bootmem.patch
mm-free-memblockmemory-in-free_all_bootmem-fix.patch

