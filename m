From: akpm@linux-foundation.org
Subject: [merged] ksm-share-anon-page-without-allocating.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:53:43 -0800
Message-ID: <200912152153.nBFLrhtu015296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761357AbZLOWQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:16:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, chrisw@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: share anon page without allocating
has been removed from the -mm tree.  Its filename was
     ksm-share-anon-page-without-allocating.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: share anon page without allocating
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

When ksm pages were unswappable, it made no sense to include them in mem
cgroup accounting; but now that they are swappable (although I see no
strict logical connection) the principle of least surprise implies that
they should be accounted (with the usual dissatisfaction, that a shared
page is accounted to only one of the cgroups using it).

This patch was intended to add mem cgroup accounting where necessary; but
turned inside out, it now avoids allocating a ksm page, instead upgrading
an anon page to ksm - which brings its existing mem cgroup accounting with
it.  Thus mem cgroups don't appear in the patch at all.

This upgrade from PageAnon to PageKsm takes place under page lock (via a
somewhat hacky NULL kpage interface), and audit showed only one place
which needed to cope with the race - page_referenced() is sometimes used
without page lock, so page_lock_anon_vma() needs an ACCESS_ONCE() to be
sure of getting anon_vma and flags together (no problem if the page goes
ksm an instant after, the integrity of that anon_vma list is unaffected).

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c  |   67 ++++++++++++++++------------------------------------
 mm/rmap.c |    6 +++-
 2 files changed, 25 insertions(+), 48 deletions(-)

diff -puN mm/ksm.c~ksm-share-anon-page-without-allocating mm/ksm.c
--- a/mm/ksm.c~ksm-share-anon-page-without-allocating
+++ a/mm/ksm.c
@@ -831,7 +831,8 @@ out:
  * try_to_merge_one_page - take two pages and merge them into one
  * @vma: the vma that holds the pte pointing to page
  * @page: the PageAnon page that we want to replace with kpage
- * @kpage: the PageKsm page that we want to map instead of page
+ * @kpage: the PageKsm page that we want to map instead of page,
+ *         or NULL the first time when we want to use page as kpage.
  *
  * This function returns 0 if the pages were merged, -EFAULT otherwise.
  */
@@ -864,15 +865,24 @@ static int try_to_merge_one_page(struct 
 	 * ptes are necessarily already write-protected.  But in either
 	 * case, we need to lock and check page_count is not raised.
 	 */
-	if (write_protect_page(vma, page, &orig_pte) == 0 &&
-	    pages_identical(page, kpage))
-		err = replace_page(vma, page, kpage, orig_pte);
+	if (write_protect_page(vma, page, &orig_pte) == 0) {
+		if (!kpage) {
+			/*
+			 * While we hold page lock, upgrade page from
+			 * PageAnon+anon_vma to PageKsm+NULL stable_node:
+			 * stable_tree_insert() will update stable_node.
+			 */
+			set_page_stable_node(page, NULL);
+			mark_page_accessed(page);
+			err = 0;
+		} else if (pages_identical(page, kpage))
+			err = replace_page(vma, page, kpage, orig_pte);
+	}
 
-	if ((vma->vm_flags & VM_LOCKED) && !err) {
+	if ((vma->vm_flags & VM_LOCKED) && kpage && !err) {
 		munlock_vma_page(page);
 		if (!PageMlocked(kpage)) {
 			unlock_page(page);
-			lru_add_drain();
 			lock_page(kpage);
 			mlock_vma_page(kpage);
 			page = kpage;		/* for final unlock */
@@ -922,7 +932,7 @@ out:
  * This function returns the kpage if we successfully merged two identical
  * pages into one ksm page, NULL otherwise.
  *
- * Note that this function allocates a new kernel page: if one of the pages
+ * Note that this function upgrades page to ksm page: if one of the pages
  * is already a ksm page, try_to_merge_with_ksm_page should be used.
  */
 static struct page *try_to_merge_two_pages(struct rmap_item *rmap_item,
@@ -930,10 +940,7 @@ static struct page *try_to_merge_two_pag
 					   struct rmap_item *tree_rmap_item,
 					   struct page *tree_page)
 {
-	struct mm_struct *mm = rmap_item->mm;
-	struct vm_area_struct *vma;
-	struct page *kpage;
-	int err = -EFAULT;
+	int err;
 
 	/*
 	 * The number of nodes in the stable tree
@@ -943,37 +950,10 @@ static struct page *try_to_merge_two_pag
 	    ksm_max_kernel_pages <= ksm_pages_shared)
 		return NULL;
 
-	kpage = alloc_page(GFP_HIGHUSER);
-	if (!kpage)
-		return NULL;
-
-	down_read(&mm->mmap_sem);
-	if (ksm_test_exit(mm))
-		goto up;
-	vma = find_vma(mm, rmap_item->address);
-	if (!vma || vma->vm_start > rmap_item->address)
-		goto up;
-
-	copy_user_highpage(kpage, page, rmap_item->address, vma);
-
-	SetPageDirty(kpage);
-	__SetPageUptodate(kpage);
-	SetPageSwapBacked(kpage);
-	set_page_stable_node(kpage, NULL);	/* mark it PageKsm */
-	lru_cache_add_lru(kpage, LRU_ACTIVE_ANON);
-
-	err = try_to_merge_one_page(vma, page, kpage);
-	if (err)
-		goto up;
-
-	/* Must get reference to anon_vma while still holding mmap_sem */
-	hold_anon_vma(rmap_item, vma->anon_vma);
-up:
-	up_read(&mm->mmap_sem);
-
+	err = try_to_merge_with_ksm_page(rmap_item, page, NULL);
 	if (!err) {
 		err = try_to_merge_with_ksm_page(tree_rmap_item,
-							tree_page, kpage);
+							tree_page, page);
 		/*
 		 * If that fails, we have a ksm page with only one pte
 		 * pointing to it: so break it.
@@ -981,11 +961,7 @@ up:
 		if (err)
 			break_cow(rmap_item);
 	}
-	if (err) {
-		put_page(kpage);
-		kpage = NULL;
-	}
-	return kpage;
+	return err ? NULL : page;
 }
 
 /*
@@ -1244,7 +1220,6 @@ static void cmp_and_merge_page(struct pa
 				stable_tree_append(rmap_item, stable_node);
 			}
 			unlock_page(kpage);
-			put_page(kpage);
 
 			/*
 			 * If we fail to insert the page into the stable tree,
diff -puN mm/rmap.c~ksm-share-anon-page-without-allocating mm/rmap.c
--- a/mm/rmap.c~ksm-share-anon-page-without-allocating
+++ a/mm/rmap.c
@@ -204,7 +204,7 @@ struct anon_vma *page_lock_anon_vma(stru
 	unsigned long anon_mapping;
 
 	rcu_read_lock();
-	anon_mapping = (unsigned long) page->mapping;
+	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
 	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
 		goto out;
 	if (!page_mapped(page))
@@ -666,7 +666,9 @@ static void __page_check_anon_rmap(struc
  * @address:	the user virtual address mapped
  *
  * The caller needs to hold the pte lock, and the page must be locked in
- * the anon_vma case: to serialize mapping,index checking after setting.
+ * the anon_vma case: to serialize mapping,index checking after setting,
+ * and to ensure that PageAnon is not being upgraded racily to PageKsm
+ * (but PageKsm is never downgraded to PageAnon).
  */
 void page_add_anon_rmap(struct page *page,
 	struct vm_area_struct *vma, unsigned long address)
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch
ksm-memory-hotremove-migration-only-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

