From: akpm@linux-foundation.org
Subject: [merged] mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:53:02 -0800
Message-ID: <20130225205302.9865D31C26E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:47721 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759714Ab3BYUxF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:53:05 -0500
Received: by mail-qe0-f73.google.com with SMTP id 3so70512qea.0
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:53:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, mingo@kernel.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rmap: rename anon_vma_unlock() => anon_vma_unlock_write()
has been removed from the -mm tree.  Its filename was
     mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/rmap: rename anon_vma_unlock() => anon_vma_unlock_write()

comment in 4fc3f1d66b1ef0d ("mm/rmap, migration: Make rmap_walk_anon() and
try_to_unmap_anon() more scalable") says:

| Rename anon_vma_[un]lock() => anon_vma_[un]lock_write(),
| to make it clearer that it's an exclusive write-lock in
| that case - suggested by Rik van Riel.

But that commit renames only anon_vma_lock()

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 +-
 include/linux/rmap.h    |    2 +-
 mm/huge_memory.c        |    6 +++---
 mm/mmap.c               |    4 ++--
 mm/mremap.c             |    2 +-
 mm/rmap.c               |    6 +++---
 6 files changed, 11 insertions(+), 11 deletions(-)

diff -puN include/linux/huge_mm.h~mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write
+++ a/include/linux/huge_mm.h
@@ -113,7 +113,7 @@ extern void __split_huge_page_pmd(struct
 	do {								\
 		pmd_t *____pmd = (__pmd);				\
 		anon_vma_lock_write(__anon_vma);			\
-		anon_vma_unlock(__anon_vma);				\
+		anon_vma_unlock_write(__anon_vma);			\
 		BUG_ON(pmd_trans_splitting(*____pmd) ||			\
 		       pmd_trans_huge(*____pmd));			\
 	} while (0)
diff -puN include/linux/rmap.h~mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write include/linux/rmap.h
--- a/include/linux/rmap.h~mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write
+++ a/include/linux/rmap.h
@@ -123,7 +123,7 @@ static inline void anon_vma_lock_write(s
 	down_write(&anon_vma->root->rwsem);
 }
 
-static inline void anon_vma_unlock(struct anon_vma *anon_vma)
+static inline void anon_vma_unlock_write(struct anon_vma *anon_vma)
 {
 	up_write(&anon_vma->root->rwsem);
 }
diff -puN mm/huge_memory.c~mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write mm/huge_memory.c
--- a/mm/huge_memory.c~mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write
+++ a/mm/huge_memory.c
@@ -1830,7 +1830,7 @@ int split_huge_page(struct page *page)
 
 	BUG_ON(PageCompound(page));
 out_unlock:
-	anon_vma_unlock(anon_vma);
+	anon_vma_unlock_write(anon_vma);
 	put_anon_vma(anon_vma);
 out:
 	return ret;
@@ -2322,7 +2322,7 @@ static void collapse_huge_page(struct mm
 		BUG_ON(!pmd_none(*pmd));
 		set_pmd_at(mm, address, pmd, _pmd);
 		spin_unlock(&mm->page_table_lock);
-		anon_vma_unlock(vma->anon_vma);
+		anon_vma_unlock_write(vma->anon_vma);
 		goto out;
 	}
 
@@ -2330,7 +2330,7 @@ static void collapse_huge_page(struct mm
 	 * All pages are isolated and locked so anon_vma rmap
 	 * can't run anymore.
 	 */
-	anon_vma_unlock(vma->anon_vma);
+	anon_vma_unlock_write(vma->anon_vma);
 
 	__collapse_huge_page_copy(pte, new_page, vma, address, ptl);
 	pte_unmap(pte);
diff -puN mm/mmap.c~mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write mm/mmap.c
--- a/mm/mmap.c~mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write
+++ a/mm/mmap.c
@@ -809,7 +809,7 @@ again:			remove_next = 1 + (end > next->
 		anon_vma_interval_tree_post_update_vma(vma);
 		if (adjust_next)
 			anon_vma_interval_tree_post_update_vma(next);
-		anon_vma_unlock(anon_vma);
+		anon_vma_unlock_write(anon_vma);
 	}
 	if (mapping)
 		mutex_unlock(&mapping->i_mmap_mutex);
@@ -3017,7 +3017,7 @@ static void vm_unlock_anon_vma(struct an
 		if (!__test_and_clear_bit(0, (unsigned long *)
 					  &anon_vma->root->rb_root.rb_node))
 			BUG();
-		anon_vma_unlock(anon_vma);
+		anon_vma_unlock_write(anon_vma);
 	}
 }
 
diff -puN mm/mremap.c~mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write mm/mremap.c
--- a/mm/mremap.c~mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write
+++ a/mm/mremap.c
@@ -135,7 +135,7 @@ static void move_ptes(struct vm_area_str
 	pte_unmap(new_pte - 1);
 	pte_unmap_unlock(old_pte - 1, old_ptl);
 	if (anon_vma)
-		anon_vma_unlock(anon_vma);
+		anon_vma_unlock_write(anon_vma);
 	if (mapping)
 		mutex_unlock(&mapping->i_mmap_mutex);
 }
diff -puN mm/rmap.c~mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write mm/rmap.c
--- a/mm/rmap.c~mm-rmap-rename-anon_vma_unlock-=-anon_vma_unlock_write
+++ a/mm/rmap.c
@@ -105,7 +105,7 @@ static inline void anon_vma_free(struct 
 	 */
 	if (rwsem_is_locked(&anon_vma->root->rwsem)) {
 		anon_vma_lock_write(anon_vma);
-		anon_vma_unlock(anon_vma);
+		anon_vma_unlock_write(anon_vma);
 	}
 
 	kmem_cache_free(anon_vma_cachep, anon_vma);
@@ -191,7 +191,7 @@ int anon_vma_prepare(struct vm_area_stru
 			avc = NULL;
 		}
 		spin_unlock(&mm->page_table_lock);
-		anon_vma_unlock(anon_vma);
+		anon_vma_unlock_write(anon_vma);
 
 		if (unlikely(allocated))
 			put_anon_vma(allocated);
@@ -308,7 +308,7 @@ int anon_vma_fork(struct vm_area_struct 
 	vma->anon_vma = anon_vma;
 	anon_vma_lock_write(anon_vma);
 	anon_vma_chain_link(vma, avc, anon_vma);
-	anon_vma_unlock(anon_vma);
+	anon_vma_unlock_write(anon_vma);
 
 	return 0;
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
drm-fb-helper-dont-sleep-for-screen-unblank-when-an-oopps-is-in-progress.patch

