From: akpm@linux-foundation.org
Subject: [merged] mm-rmap-use-rmap_walk-in-page_referenced.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:13:32 -0800
Message-ID: <52e0266c.xTyQ82IuW1wIGjSd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54594 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbaAVUNd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:13:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mingo@kernel.org, mgorman@suse.de, liwanp@linux.vnet.ibm.com, hughd@google.com, dhillf@gmail.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-rmap-use-rmap_walk-in-page_referenced.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,dhillf@gmail.com,hughd@google.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mingo@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:13:32 -0800


The patch titled
     Subject: mm/rmap: use rmap_walk() in page_referenced()
has been removed from the -mm tree.  Its filename was
     mm-rmap-use-rmap_walk-in-page_referenced.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/rmap: use rmap_walk() in page_referenced()

Now, we have an infrastructure in rmap_walk() to handle difference from
variants of rmap traversing functions.

So, just use it in page_referenced().

In this patch, I change following things.

1. remove some variants of rmap traversing functions.
	cf> page_referenced_ksm, page_referenced_anon,
	page_referenced_file

2. introduce new struct page_referenced_arg and pass it to
   page_referenced_one(), main function of rmap_walk, in order to count
   reference, to store vm_flags and to check finish condition.

3. mechanical change to use rmap_walk() in page_referenced().

[liwanp@linux.vnet.ibm.com: fix BUG at rmap_walk]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h  |    2 
 include/linux/rmap.h |    2 
 mm/ksm.c             |   60 -----------
 mm/rmap.c            |  210 ++++++++++++++---------------------------
 4 files changed, 80 insertions(+), 194 deletions(-)

diff -puN include/linux/ksm.h~mm-rmap-use-rmap_walk-in-page_referenced include/linux/ksm.h
--- a/include/linux/ksm.h~mm-rmap-use-rmap_walk-in-page_referenced
+++ a/include/linux/ksm.h
@@ -73,8 +73,6 @@ static inline void set_page_stable_node(
 struct page *ksm_might_need_to_copy(struct page *page,
 			struct vm_area_struct *vma, unsigned long address);
 
-int page_referenced_ksm(struct page *page,
-			struct mem_cgroup *memcg, unsigned long *vm_flags);
 int rmap_walk_ksm(struct page *page, struct rmap_walk_control *rwc);
 void ksm_migrate_page(struct page *newpage, struct page *oldpage);
 
diff -puN include/linux/rmap.h~mm-rmap-use-rmap_walk-in-page_referenced include/linux/rmap.h
--- a/include/linux/rmap.h~mm-rmap-use-rmap_walk-in-page_referenced
+++ a/include/linux/rmap.h
@@ -184,7 +184,7 @@ static inline void page_dup_rmap(struct
 int page_referenced(struct page *, int is_locked,
 			struct mem_cgroup *memcg, unsigned long *vm_flags);
 int page_referenced_one(struct page *, struct vm_area_struct *,
-	unsigned long address, unsigned int *mapcount, unsigned long *vm_flags);
+	unsigned long address, void *arg);
 
 #define TTU_ACTION(x) ((x) & TTU_ACTION_MASK)
 
diff -puN mm/ksm.c~mm-rmap-use-rmap_walk-in-page_referenced mm/ksm.c
--- a/mm/ksm.c~mm-rmap-use-rmap_walk-in-page_referenced
+++ a/mm/ksm.c
@@ -1891,61 +1891,6 @@ struct page *ksm_might_need_to_copy(stru
 	return new_page;
 }
 
-int page_referenced_ksm(struct page *page, struct mem_cgroup *memcg,
-			unsigned long *vm_flags)
-{
-	struct stable_node *stable_node;
-	struct rmap_item *rmap_item;
-	unsigned int mapcount = page_mapcount(page);
-	int referenced = 0;
-	int search_new_forks = 0;
-
-	VM_BUG_ON(!PageKsm(page));
-	VM_BUG_ON(!PageLocked(page));
-
-	stable_node = page_stable_node(page);
-	if (!stable_node)
-		return 0;
-again:
-	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
-		struct anon_vma *anon_vma = rmap_item->anon_vma;
-		struct anon_vma_chain *vmac;
-		struct vm_area_struct *vma;
-
-		anon_vma_lock_read(anon_vma);
-		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
-					       0, ULONG_MAX) {
-			vma = vmac->vma;
-			if (rmap_item->address < vma->vm_start ||
-			    rmap_item->address >= vma->vm_end)
-				continue;
-			/*
-			 * Initially we examine only the vma which covers this
-			 * rmap_item; but later, if there is still work to do,
-			 * we examine covering vmas in other mms: in case they
-			 * were forked from the original since ksmd passed.
-			 */
-			if ((rmap_item->mm == vma->vm_mm) == search_new_forks)
-				continue;
-
-			if (memcg && !mm_match_cgroup(vma->vm_mm, memcg))
-				continue;
-
-			referenced += page_referenced_one(page, vma,
-				rmap_item->address, &mapcount, vm_flags);
-			if (!search_new_forks || !mapcount)
-				break;
-		}
-		anon_vma_unlock_read(anon_vma);
-		if (!mapcount)
-			goto out;
-	}
-	if (!search_new_forks++)
-		goto again;
-out:
-	return referenced;
-}
-
 int rmap_walk_ksm(struct page *page, struct rmap_walk_control *rwc)
 {
 	struct stable_node *stable_node;
@@ -1954,6 +1899,11 @@ int rmap_walk_ksm(struct page *page, str
 	int search_new_forks = 0;
 
 	VM_BUG_ON(!PageKsm(page));
+
+	/*
+	 * Rely on the page lock to protect against concurrent modifications
+	 * to that page's node of the stable tree.
+	 */
 	VM_BUG_ON(!PageLocked(page));
 
 	stable_node = page_stable_node(page);
diff -puN mm/rmap.c~mm-rmap-use-rmap_walk-in-page_referenced mm/rmap.c
--- a/mm/rmap.c~mm-rmap-use-rmap_walk-in-page_referenced
+++ a/mm/rmap.c
@@ -660,17 +660,22 @@ int page_mapped_in_vma(struct page *page
 	return 1;
 }
 
+struct page_referenced_arg {
+	int mapcount;
+	int referenced;
+	unsigned long vm_flags;
+	struct mem_cgroup *memcg;
+};
 /*
- * Subfunctions of page_referenced: page_referenced_one called
- * repeatedly from either page_referenced_anon or page_referenced_file.
+ * arg: page_referenced_arg will be passed
  */
 int page_referenced_one(struct page *page, struct vm_area_struct *vma,
-			unsigned long address, unsigned int *mapcount,
-			unsigned long *vm_flags)
+			unsigned long address, void *arg)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
 	int referenced = 0;
+	struct page_referenced_arg *pra = arg;
 
 	if (unlikely(PageTransHuge(page))) {
 		pmd_t *pmd;
@@ -682,13 +687,12 @@ int page_referenced_one(struct page *pag
 		pmd = page_check_address_pmd(page, mm, address,
 					     PAGE_CHECK_ADDRESS_PMD_FLAG, &ptl);
 		if (!pmd)
-			goto out;
+			return SWAP_AGAIN;
 
 		if (vma->vm_flags & VM_LOCKED) {
 			spin_unlock(ptl);
-			*mapcount = 0;	/* break early from loop */
-			*vm_flags |= VM_LOCKED;
-			goto out;
+			pra->vm_flags |= VM_LOCKED;
+			return SWAP_FAIL; /* To break the loop */
 		}
 
 		/* go ahead even if the pmd is pmd_trans_splitting() */
@@ -704,13 +708,12 @@ int page_referenced_one(struct page *pag
 		 */
 		pte = page_check_address(page, mm, address, &ptl, 0);
 		if (!pte)
-			goto out;
+			return SWAP_AGAIN;
 
 		if (vma->vm_flags & VM_LOCKED) {
 			pte_unmap_unlock(pte, ptl);
-			*mapcount = 0;	/* break early from loop */
-			*vm_flags |= VM_LOCKED;
-			goto out;
+			pra->vm_flags |= VM_LOCKED;
+			return SWAP_FAIL; /* To break the loop */
 		}
 
 		if (ptep_clear_flush_young_notify(vma, address, pte)) {
@@ -727,113 +730,27 @@ int page_referenced_one(struct page *pag
 		pte_unmap_unlock(pte, ptl);
 	}
 
-	(*mapcount)--;
-
-	if (referenced)
-		*vm_flags |= vma->vm_flags;
-out:
-	return referenced;
-}
-
-static int page_referenced_anon(struct page *page,
-				struct mem_cgroup *memcg,
-				unsigned long *vm_flags)
-{
-	unsigned int mapcount;
-	struct anon_vma *anon_vma;
-	pgoff_t pgoff;
-	struct anon_vma_chain *avc;
-	int referenced = 0;
-
-	anon_vma = page_lock_anon_vma_read(page);
-	if (!anon_vma)
-		return referenced;
-
-	mapcount = page_mapcount(page);
-	pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
-		struct vm_area_struct *vma = avc->vma;
-		unsigned long address = vma_address(page, vma);
-		/*
-		 * If we are reclaiming on behalf of a cgroup, skip
-		 * counting on behalf of references from different
-		 * cgroups
-		 */
-		if (memcg && !mm_match_cgroup(vma->vm_mm, memcg))
-			continue;
-		referenced += page_referenced_one(page, vma, address,
-						  &mapcount, vm_flags);
-		if (!mapcount)
-			break;
+	if (referenced) {
+		pra->referenced++;
+		pra->vm_flags |= vma->vm_flags;
 	}
 
-	page_unlock_anon_vma_read(anon_vma);
-	return referenced;
+	pra->mapcount--;
+	if (!pra->mapcount)
+		return SWAP_SUCCESS; /* To break the loop */
+
+	return SWAP_AGAIN;
 }
 
-/**
- * page_referenced_file - referenced check for object-based rmap
- * @page: the page we're checking references on.
- * @memcg: target memory control group
- * @vm_flags: collect encountered vma->vm_flags who actually referenced the page
- *
- * For an object-based mapped page, find all the places it is mapped and
- * check/clear the referenced flag.  This is done by following the page->mapping
- * pointer, then walking the chain of vmas it holds.  It returns the number
- * of references it found.
- *
- * This function is only called from page_referenced for object-based pages.
- */
-static int page_referenced_file(struct page *page,
-				struct mem_cgroup *memcg,
-				unsigned long *vm_flags)
+static bool invalid_page_referenced_vma(struct vm_area_struct *vma, void *arg)
 {
-	unsigned int mapcount;
-	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-	struct vm_area_struct *vma;
-	int referenced = 0;
-
-	/*
-	 * The caller's checks on page->mapping and !PageAnon have made
-	 * sure that this is a file page: the check for page->mapping
-	 * excludes the case just before it gets set on an anon page.
-	 */
-	BUG_ON(PageAnon(page));
-
-	/*
-	 * The page lock not only makes sure that page->mapping cannot
-	 * suddenly be NULLified by truncation, it makes sure that the
-	 * structure at mapping cannot be freed and reused yet,
-	 * so we can safely take mapping->i_mmap_mutex.
-	 */
-	BUG_ON(!PageLocked(page));
-
-	mutex_lock(&mapping->i_mmap_mutex);
-
-	/*
-	 * i_mmap_mutex does not stabilize mapcount at all, but mapcount
-	 * is more likely to be accurate if we note it after spinning.
-	 */
-	mapcount = page_mapcount(page);
+	struct page_referenced_arg *pra = arg;
+	struct mem_cgroup *memcg = pra->memcg;
 
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
-		unsigned long address = vma_address(page, vma);
-		/*
-		 * If we are reclaiming on behalf of a cgroup, skip
-		 * counting on behalf of references from different
-		 * cgroups
-		 */
-		if (memcg && !mm_match_cgroup(vma->vm_mm, memcg))
-			continue;
-		referenced += page_referenced_one(page, vma, address,
-						  &mapcount, vm_flags);
-		if (!mapcount)
-			break;
-	}
+	if (!mm_match_cgroup(vma->vm_mm, memcg))
+		return true;
 
-	mutex_unlock(&mapping->i_mmap_mutex);
-	return referenced;
+	return false;
 }
 
 /**
@@ -851,32 +768,47 @@ int page_referenced(struct page *page,
 		    struct mem_cgroup *memcg,
 		    unsigned long *vm_flags)
 {
-	int referenced = 0;
+	int ret;
 	int we_locked = 0;
+	struct page_referenced_arg pra = {
+		.mapcount = page_mapcount(page),
+		.memcg = memcg,
+	};
+	struct rmap_walk_control rwc = {
+		.rmap_one = page_referenced_one,
+		.arg = (void *)&pra,
+		.anon_lock = page_lock_anon_vma_read,
+	};
 
 	*vm_flags = 0;
-	if (page_mapped(page) && page_rmapping(page)) {
-		if (!is_locked && (!PageAnon(page) || PageKsm(page))) {
-			we_locked = trylock_page(page);
-			if (!we_locked) {
-				referenced++;
-				goto out;
-			}
-		}
-		if (unlikely(PageKsm(page)))
-			referenced += page_referenced_ksm(page, memcg,
-								vm_flags);
-		else if (PageAnon(page))
-			referenced += page_referenced_anon(page, memcg,
-								vm_flags);
-		else if (page->mapping)
-			referenced += page_referenced_file(page, memcg,
-								vm_flags);
-		if (we_locked)
-			unlock_page(page);
+	if (!page_mapped(page))
+		return 0;
+
+	if (!page_rmapping(page))
+		return 0;
+
+	if (!is_locked && (!PageAnon(page) || PageKsm(page))) {
+		we_locked = trylock_page(page);
+		if (!we_locked)
+			return 1;
 	}
-out:
-	return referenced;
+
+	/*
+	 * If we are reclaiming on behalf of a cgroup, skip
+	 * counting on behalf of references from different
+	 * cgroups
+	 */
+	if (memcg) {
+		rwc.invalid_vma = invalid_page_referenced_vma;
+	}
+
+	ret = rmap_walk(page, &rwc);
+	*vm_flags = pra.vm_flags;
+
+	if (we_locked)
+		unlock_page(page);
+
+	return pra.referenced;
 }
 
 static int page_mkclean_one(struct page *page, struct vm_area_struct *vma,
@@ -1700,6 +1632,14 @@ static int rmap_walk_file(struct page *p
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 
+	/*
+	 * The page lock not only makes sure that page->mapping cannot
+	 * suddenly be NULLified by truncation, it makes sure that the
+	 * structure at mapping cannot be freed and reused yet,
+	 * so we can safely take mapping->i_mmap_mutex.
+	 */
+	VM_BUG_ON(!PageLocked(page));
+
 	if (!mapping)
 		return ret;
 	mutex_lock(&mapping->i_mmap_mutex);
@@ -1731,8 +1671,6 @@ done:
 
 int rmap_walk(struct page *page, struct rmap_walk_control *rwc)
 {
-	VM_BUG_ON(!PageLocked(page));
