From: akpm@linux-foundation.org
Subject: + ksm-rmap_walk-to-remove_migation_ptes.patch added to -mm tree
Date: Tue, 24 Nov 2009 11:35:41 -0800
Message-ID: <200911241935.nAOJZfp1028612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932297AbZKXTft (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Nov 2009 14:35:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, chrisw@redhat.com, ieidus@redhat.com


The patch titled
     ksm: rmap_walk to remove_migation_ptes
has been added to the -mm tree.  Its filename is
     ksm-rmap_walk-to-remove_migation_ptes.patch

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
Subject: ksm: rmap_walk to remove_migation_ptes
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

A side-effect of making ksm pages swappable is that they have to be placed
on the LRUs: which then exposes them to isolate_lru_page() and hence to
page migration.

Add rmap_walk() for remove_migration_ptes() to use: rmap_walk_anon() and
rmap_walk_file() in rmap.c, but rmap_walk_ksm() in ksm.c.  Perhaps some
consolidation with existing code is possible, but don't attempt that yet
(try_to_unmap needs to handle nonlinears, but migration pte removal does
not).

rmap_walk() is sadly less general than it appears: rmap_walk_anon(), like
remove_anon_migration_ptes() which it replaces, avoids calling
page_lock_anon_vma(), because that includes a page_mapped() test which
fails when all migration ptes are in place.  That was valid when NUMA page
migration was introduced (holding mmap_sem provided the missing guarantee
that anon_vma's slab had not already been destroyed), but I believe not
valid in the memory hotremove case added since.

For now do the same as before, and consider the best way to fix that
unlikely race later on.  When fixed, we can probably use rmap_walk() on
hwpoisoned ksm pages too: for now, they remain among hwpoison's various
exceptions (its PageKsm test comes before the page is locked, but its
page_lock_anon_vma fails safely if an anon gets upgraded).

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Wright <chrisw@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h  |   13 ++++++
 include/linux/rmap.h |    6 ++
 mm/ksm.c             |   65 +++++++++++++++++++++++++++++++
 mm/migrate.c         |   85 ++++++++---------------------------------
 mm/rmap.c            |   79 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 181 insertions(+), 67 deletions(-)

diff -puN include/linux/ksm.h~ksm-rmap_walk-to-remove_migation_ptes include/linux/ksm.h
--- a/include/linux/ksm.h~ksm-rmap_walk-to-remove_migation_ptes
+++ a/include/linux/ksm.h
@@ -88,6 +88,9 @@ static inline struct page *ksm_might_nee
 int page_referenced_ksm(struct page *page,
 			struct mem_cgroup *memcg, unsigned long *vm_flags);
 int try_to_unmap_ksm(struct page *page, enum ttu_flags flags);
+int rmap_walk_ksm(struct page *page, int (*rmap_one)(struct page *,
+		  struct vm_area_struct *, unsigned long, void *), void *arg);
+void ksm_migrate_page(struct page *newpage, struct page *oldpage);
 
 #else  /* !CONFIG_KSM */
 
@@ -127,6 +130,16 @@ static inline int try_to_unmap_ksm(struc
 {
 	return 0;
 }
+
+static inline int rmap_walk_ksm(struct page *page, int (*rmap_one)(struct page*,
+		struct vm_area_struct *, unsigned long, void *), void *arg)
+{
+	return 0;
+}
+
+static inline void ksm_migrate_page(struct page *newpage, struct page *oldpage)
+{
+}
 #endif /* !CONFIG_KSM */
 
 #endif /* __LINUX_KSM_H */
diff -puN include/linux/rmap.h~ksm-rmap_walk-to-remove_migation_ptes include/linux/rmap.h
--- a/include/linux/rmap.h~ksm-rmap_walk-to-remove_migation_ptes
+++ a/include/linux/rmap.h
@@ -164,6 +164,12 @@ struct anon_vma *page_lock_anon_vma(stru
 void page_unlock_anon_vma(struct anon_vma *anon_vma);
 int page_mapped_in_vma(struct page *page, struct vm_area_struct *vma);
 
+/*
+ * Called by migrate.c to remove migration ptes, but might be used more later.
+ */
+int rmap_walk(struct page *page, int (*rmap_one)(struct page *,
+		struct vm_area_struct *, unsigned long, void *), void *arg);
+
 #else	/* !CONFIG_MMU */
 
 #define anon_vma_init()		do {} while (0)
diff -puN mm/ksm.c~ksm-rmap_walk-to-remove_migation_ptes mm/ksm.c
--- a/mm/ksm.c~ksm-rmap_walk-to-remove_migation_ptes
+++ a/mm/ksm.c
@@ -1656,6 +1656,71 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_MIGRATION
+int rmap_walk_ksm(struct page *page, int (*rmap_one)(struct page *,
+		  struct vm_area_struct *, unsigned long, void *), void *arg)
+{
+	struct stable_node *stable_node;
+	struct hlist_node *hlist;
+	struct rmap_item *rmap_item;
+	int ret = SWAP_AGAIN;
+	int search_new_forks = 0;
+
+	VM_BUG_ON(!PageKsm(page));
+	VM_BUG_ON(!PageLocked(page));
+
+	stable_node = page_stable_node(page);
+	if (!stable_node)
+		return ret;
+again:
+	hlist_for_each_entry(rmap_item, hlist, &stable_node->hlist, hlist) {
+		struct anon_vma *anon_vma = rmap_item->anon_vma;
+		struct vm_area_struct *vma;
+
+		spin_lock(&anon_vma->lock);
+		list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
+			if (rmap_item->address < vma->vm_start ||
+			    rmap_item->address >= vma->vm_end)
+				continue;
+			/*
+			 * Initially we examine only the vma which covers this
+			 * rmap_item; but later, if there is still work to do,
+			 * we examine covering vmas in other mms: in case they
+			 * were forked from the original since ksmd passed.
+			 */
+			if ((rmap_item->mm == vma->vm_mm) == search_new_forks)
+				continue;
+
+			ret = rmap_one(page, vma, rmap_item->address, arg);
+			if (ret != SWAP_AGAIN) {
+				spin_unlock(&anon_vma->lock);
+				goto out;
+			}
+		}
+		spin_unlock(&anon_vma->lock);
+	}
+	if (!search_new_forks++)
+		goto again;
+out:
+	return ret;
+}
+
+void ksm_migrate_page(struct page *newpage, struct page *oldpage)
+{
+	struct stable_node *stable_node;
+
+	VM_BUG_ON(!PageLocked(oldpage));
+	VM_BUG_ON(!PageLocked(newpage));
+	VM_BUG_ON(newpage->mapping != oldpage->mapping);
+
+	stable_node = page_stable_node(newpage);
+	if (stable_node) {
+		VM_BUG_ON(stable_node->page != oldpage);
+		stable_node->page = newpage;
+	}
+}
+#endif /* CONFIG_MIGRATION */
+
 #ifdef CONFIG_SYSFS
 /*
  * This all compiles without CONFIG_SYSFS, but is a waste of space.
diff -puN mm/migrate.c~ksm-rmap_walk-to-remove_migation_ptes mm/migrate.c
--- a/mm/migrate.c~ksm-rmap_walk-to-remove_migation_ptes
+++ a/mm/migrate.c
@@ -21,6 +21,7 @@
 #include <linux/mm_inline.h>
 #include <linux/nsproxy.h>
 #include <linux/pagevec.h>
+#include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/topology.h>
 #include <linux/cpu.h>
@@ -78,8 +79,8 @@ int putback_lru_pages(struct list_head *
 /*
  * Restore a potential migration pte to a working pte entry
  */
-static void remove_migration_pte(struct vm_area_struct *vma,
-		struct page *old, struct page *new)
+static int remove_migration_pte(struct page *new, struct vm_area_struct *vma,
+				 unsigned long addr, void *old)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	swp_entry_t entry;
@@ -88,40 +89,37 @@ static void remove_migration_pte(struct 
  	pmd_t *pmd;
 	pte_t *ptep, pte;
  	spinlock_t *ptl;
-	unsigned long addr = page_address_in_vma(new, vma);
-
-	if (addr == -EFAULT)
-		return;
 
  	pgd = pgd_offset(mm, addr);
 	if (!pgd_present(*pgd))
-                return;
+		goto out;
 
 	pud = pud_offset(pgd, addr);
 	if (!pud_present(*pud))
-                return;
+		goto out;
 
 	pmd = pmd_offset(pud, addr);
 	if (!pmd_present(*pmd))
-		return;
+		goto out;
 
 	ptep = pte_offset_map(pmd, addr);
 
 	if (!is_swap_pte(*ptep)) {
 		pte_unmap(ptep);
- 		return;
+		goto out;
  	}
 
  	ptl = pte_lockptr(mm, pmd);
  	spin_lock(ptl);
 	pte = *ptep;
 	if (!is_swap_pte(pte))
-		goto out;
+		goto unlock;
 
 	entry = pte_to_swp_entry(pte);
 
-	if (!is_migration_entry(entry) || migration_entry_to_page(entry) != old)
-		goto out;
+	if (!is_migration_entry(entry) ||
+	    migration_entry_to_page(entry) != old)
+		goto unlock;
 
 	get_page(new);
 	pte = pte_mkold(mk_pte(new, vma->vm_page_prot));
@@ -137,55 +135,10 @@ static void remove_migration_pte(struct 
 
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(vma, addr, pte);
-
-out:
+unlock:
 	pte_unmap_unlock(ptep, ptl);
-}
-
-/*
- * Note that remove_file_migration_ptes will only work on regular mappings,
- * Nonlinear mappings do not use migration entries.
- */
-static void remove_file_migration_ptes(struct page *old, struct page *new)
-{
-	struct vm_area_struct *vma;
-	struct address_space *mapping = new->mapping;
-	struct prio_tree_iter iter;
-	pgoff_t pgoff = new->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-
-	if (!mapping)
-		return;
-
-	spin_lock(&mapping->i_mmap_lock);
-
-	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff)
-		remove_migration_pte(vma, old, new);
-
-	spin_unlock(&mapping->i_mmap_lock);
-}
-
-/*
- * Must hold mmap_sem lock on at least one of the vmas containing
- * the page so that the anon_vma cannot vanish.
- */
-static void remove_anon_migration_ptes(struct page *old, struct page *new)
-{
-	struct anon_vma *anon_vma;
-	struct vm_area_struct *vma;
-
-	/*
-	 * We hold the mmap_sem lock. So no need to call page_lock_anon_vma.
-	 */
-	anon_vma = page_anon_vma(new);
-	if (!anon_vma)
-		return;
-
-	spin_lock(&anon_vma->lock);
-
-	list_for_each_entry(vma, &anon_vma->head, anon_vma_node)
-		remove_migration_pte(vma, old, new);
-
-	spin_unlock(&anon_vma->lock);
+out:
+	return SWAP_AGAIN;
 }
 
 /*
@@ -194,10 +147,7 @@ static void remove_anon_migration_ptes(s
  */
 static void remove_migration_ptes(struct page *old, struct page *new)
 {
-	if (PageAnon(new))
-		remove_anon_migration_ptes(old, new);
-	else
-		remove_file_migration_ptes(old, new);
+	rmap_walk(new, remove_migration_pte, old);
 }
 
 /*
@@ -358,6 +308,7 @@ static void migrate_page_copy(struct pag
  	}
 
 	mlock_migrate_page(newpage, page);
+	ksm_migrate_page(newpage, page);
 
 	ClearPageSwapCache(page);
 	ClearPagePrivate(page);
@@ -577,9 +528,9 @@ static int move_to_new_page(struct page 
 	else
 		rc = fallback_migrate_page(mapping, newpage, page);
 
-	if (!rc) {
+	if (!rc)
 		remove_migration_ptes(page, newpage);
-	} else
+	else
 		newpage->mapping = NULL;
 
 	unlock_page(newpage);
diff -puN mm/rmap.c~ksm-rmap_walk-to-remove_migation_ptes mm/rmap.c
--- a/mm/rmap.c~ksm-rmap_walk-to-remove_migation_ptes
+++ a/mm/rmap.c
@@ -1203,3 +1203,82 @@ int try_to_munlock(struct page *page)
 	else
 		return try_to_unmap_file(page, TTU_MUNLOCK);
 }
+
+#ifdef CONFIG_MIGRATION
+/*
+ * rmap_walk() and its helpers rmap_walk_anon() and rmap_walk_file():
+ * Called by migrate.c to remove migration ptes, but might be used more later.
+ */
+static int rmap_walk_anon(struct page *page, int (*rmap_one)(struct page *,
+		struct vm_area_struct *, unsigned long, void *), void *arg)
+{
+	struct anon_vma *anon_vma;
+	struct vm_area_struct *vma;
+	int ret = SWAP_AGAIN;
+
+	/*
+	 * Note: remove_migration_ptes() cannot use page_lock_anon_vma()
+	 * because that depends on page_mapped(); but not all its usages
+	 * are holding mmap_sem, which also gave the necessary guarantee
+	 * (that this anon_vma's slab has not already been destroyed).
+	 * This needs to be reviewed later: avoiding page_lock_anon_vma()
+	 * is risky, and currently limits the usefulness of rmap_walk().
+	 */
+	anon_vma = page_anon_vma(page);
+	if (!anon_vma)
+		return ret;
+	spin_lock(&anon_vma->lock);
+	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
+		unsigned long address = vma_address(page, vma);
+		if (address == -EFAULT)
+			continue;
+		ret = rmap_one(page, vma, address, arg);
+		if (ret != SWAP_AGAIN)
+			break;
+	}
+	spin_unlock(&anon_vma->lock);
+	return ret;
+}
+
+static int rmap_walk_file(struct page *page, int (*rmap_one)(struct page *,
+		struct vm_area_struct *, unsigned long, void *), void *arg)
+{
+	struct address_space *mapping = page->mapping;
+	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	struct vm_area_struct *vma;
+	struct prio_tree_iter iter;
+	int ret = SWAP_AGAIN;
+
+	if (!mapping)
+		return ret;
+	spin_lock(&mapping->i_mmap_lock);
+	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
+		unsigned long address = vma_address(page, vma);
+		if (address == -EFAULT)
+			continue;
+		ret = rmap_one(page, vma, address, arg);
+		if (ret != SWAP_AGAIN)
+			break;
+	}
+	/*
+	 * No nonlinear handling: being always shared, nonlinear vmas
+	 * never contain migration ptes.  Decide what to do about this
+	 * limitation to linear when we need rmap_walk() on nonlinear.
+	 */
+	spin_unlock(&mapping->i_mmap_lock);
+	return ret;
+}
+
+int rmap_walk(struct page *page, int (*rmap_one)(struct page *,
+		struct vm_area_struct *, unsigned long, void *), void *arg)
+{
+	VM_BUG_ON(!PageLocked(page));
+
+	if (unlikely(PageKsm(page)))
+		return rmap_walk_ksm(page, rmap_one, arg);
+	else if (PageAnon(page))
+		return rmap_walk_anon(page, rmap_one, arg);
+	else
+		return rmap_walk_file(page, rmap_one, arg);
+}
+#endif /* CONFIG_MIGRATION */
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-include-first_swap_extent-fix.patch
swap_info-include-first_swap_extent-fix-fix.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
rmap-fix-the-comment-for-try_to_unmap_anon.patch
oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
mm-define-page_mapping_flags.patch
mm-mlocking-in-try_to_unmap_one.patch
mm-mlocking-in-try_to_unmap_one-fix.patch
mm-mlocking-in-try_to_unmap_one-fix-fix.patch
mm-config_mmu-for-pg_mlocked.patch
mm-pass-address-down-to-rmap-ones.patch
mm-stop-ptlock-enlarging-struct-page.patch
mm-sigbus-instead-of-abusing-oom.patch
ksm-three-remove_rmap_item_from_tree-cleanups.patch
ksm-remove-redundancies-when-merging-page.patch
ksm-cleanup-some-function-arguments.patch
ksm-singly-linked-rmap_list.patch
ksm-separate-stable_node.patch
ksm-stable_node-point-to-page-and-back.patch
ksm-fix-mlockfreed-to-munlocked.patch
ksm-let-shared-pages-be-swappable.patch
ksm-hold-anon_vma-in-rmap_item.patch
ksm-take-keyhole-reference-to-page.patch
ksm-share-anon-page-without-allocating.patch
ksm-mem-cgroup-charge-swapin-copy.patch
ksm-rmap_walk-to-remove_migation_ptes.patch
ksm-memory-hotremove-migration-only.patch
ksm-remove-unswappable-max_kernel_pages.patch
hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2.patch
mm-simplify-try_to_unmap_one.patch
mm-simplify-try_to_unmap_one-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

