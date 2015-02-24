From: akpm@linux-foundation.org
Subject: + mm-refactor-do_wp_page-extract-the-page-copy-flow.patch added
 to -mm tree
Date: Mon, 23 Feb 2015 16:20:25 -0800
Message-ID: <54ebc3c9.RtQhoaj2kpRdw3bM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48546 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbBXAU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 19:20:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raindel@mellanox.com, aarcange@redhat.com, ak@linux.intel.com, dave.hansen@intel.com, haggaie@mellanox.com, hannes@cmpxchg.org, kirill.shutemov@linux.intel.com, matthew.r.wilcox@intel.com, mgorman@suse.de, n-horiguchi@ah.jp.nec.com, pfeiner@google.com, riel@redhat.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: refactor do_wp_page, extract the page copy flow
has been added to the -mm tree.  Its filename is
     mm-refactor-do_wp_page-extract-the-page-copy-flow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-refactor-do_wp_page-extract-the-page-copy-flow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shachar Raindel <raindel@mellanox.com>
Subject: mm: refactor do_wp_page, extract the page copy flow

In some cases, do_wp_page had to copy the page suffering a write fault to
a new location.  If the function logic decided that to do this, it was
done by jumping with a "goto" operation to the relevant code block.  This
made the code really hard to understand.  It is also against the kernel
coding style guidelines.

This patch extracts the page copy and page table update logic to a
separate function.  It also clean up the naming, from "gotten" to
"wp_page_copy", and adds few comments.

Signed-off-by: Shachar Raindel <raindel@mellanox.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Haggai Eran <haggaie@mellanox.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Peter Feiner <pfeiner@google.com>
Cc: Michel Lespinasse <walken@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |  265 +++++++++++++++++++++++++++-----------------------
 1 file changed, 147 insertions(+), 118 deletions(-)

diff -puN mm/memory.c~mm-refactor-do_wp_page-extract-the-page-copy-flow mm/memory.c
--- a/mm/memory.c~mm-refactor-do_wp_page-extract-the-page-copy-flow
+++ a/mm/memory.c
@@ -2042,6 +2042,146 @@ static int wp_page_reuse(struct mm_struc
 }
 
 /*
+ * Handle the case of a page which we actually need to copy to a new page.
+ *
+ * Called with mmap_sem locked and the old page referenced, but
+ * without the ptl held.
+ *
+ * High level logic flow:
+ *
+ * - Allocate a page, copy the content of the old page to the new one.
+ * - Handle book keeping and accounting - cgroups, mmu-notifiers, etc.
+ * - Take the PTL. If the pte changed, bail out and release the allocated page
+ * - If the pte is still the way we remember it, update the page table and all
+ *   relevant references. This includes dropping the reference the page-table
+ *   held to the old page, as well as updating the rmap.
+ * - In any case, unlock the PTL and drop the reference we took to the old page.
+ */
+static int wp_page_copy(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address, pte_t *page_table, pmd_t *pmd,
+			pte_t orig_pte, struct page *old_page)
+{
+	struct page *new_page = NULL;
+	spinlock_t *ptl = NULL;
+	pte_t entry;
+	int page_copied = 0;
+	const unsigned long mmun_start = address & PAGE_MASK;	/* For mmu_notifiers */
+	const unsigned long mmun_end = mmun_start + PAGE_SIZE;	/* For mmu_notifiers */
+	struct mem_cgroup *memcg;
+
+	if (unlikely(anon_vma_prepare(vma)))
+		goto oom;
+
+	if (is_zero_pfn(pte_pfn(orig_pte))) {
+		new_page = alloc_zeroed_user_highpage_movable(vma, address);
+		if (!new_page)
+			goto oom;
+	} else {
+		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
+		if (!new_page)
+			goto oom;
+		cow_user_page(new_page, old_page, address, vma);
+	}
+	__SetPageUptodate(new_page);
+
+	if (mem_cgroup_try_charge(new_page, mm, GFP_KERNEL, &memcg))
+		goto oom_free_new;
+
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
+
+	/*
+	 * Re-check the pte - we dropped the lock
+	 */
+	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
+	if (likely(pte_same(*page_table, orig_pte))) {
+		if (old_page) {
+			if (!PageAnon(old_page)) {
+				dec_mm_counter_fast(mm, MM_FILEPAGES);
+				inc_mm_counter_fast(mm, MM_ANONPAGES);
+			}
+		} else {
+			inc_mm_counter_fast(mm, MM_ANONPAGES);
+		}
+		flush_cache_page(vma, address, pte_pfn(orig_pte));
+		entry = mk_pte(new_page, vma->vm_page_prot);
+		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
+		/*
+		 * Clear the pte entry and flush it first, before updating the
+		 * pte with the new entry. This will avoid a race condition
+		 * seen in the presence of one thread doing SMC and another
+		 * thread doing COW.
+		 */
+		ptep_clear_flush_notify(vma, address, page_table);
+		page_add_new_anon_rmap(new_page, vma, address);
+		mem_cgroup_commit_charge(new_page, memcg, false);
+		lru_cache_add_active_or_unevictable(new_page, vma);
+		/*
+		 * We call the notify macro here because, when using secondary
+		 * mmu page tables (such as kvm shadow page tables), we want the
+		 * new page to be mapped directly into the secondary page table.
+		 */
+		set_pte_at_notify(mm, address, page_table, entry);
+		update_mmu_cache(vma, address, page_table);
+		if (old_page) {
+			/*
+			 * Only after switching the pte to the new page may
+			 * we remove the mapcount here. Otherwise another
+			 * process may come and find the rmap count decremented
+			 * before the pte is switched to the new page, and
+			 * "reuse" the old page writing into it while our pte
+			 * here still points into it and can be read by other
+			 * threads.
+			 *
+			 * The critical issue is to order this
+			 * page_remove_rmap with the ptp_clear_flush above.
+			 * Those stores are ordered by (if nothing else,)
+			 * the barrier present in the atomic_add_negative
+			 * in page_remove_rmap.
+			 *
+			 * Then the TLB flush in ptep_clear_flush ensures that
+			 * no process can access the old page before the
+			 * decremented mapcount is visible. And the old page
+			 * cannot be reused until after the decremented
+			 * mapcount is visible. So transitively, TLBs to
+			 * old page will be flushed before it can be reused.
+			 */
+			page_remove_rmap(old_page);
+		}
+
+		/* Free the old page.. */
+		new_page = old_page;
+		page_copied = 1;
+	} else {
+		mem_cgroup_cancel_charge(new_page, memcg);
+	}
+
+	if (new_page)
+		page_cache_release(new_page);
+
+	pte_unmap_unlock(page_table, ptl);
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
+	if (old_page) {
+		/*
+		 * Don't let another task, with possibly unlocked vma,
+		 * keep the mlocked page.
+		 */
+		if (page_copied && (vma->vm_flags & VM_LOCKED)) {
+			lock_page(old_page);	/* LRU manipulation */
+			munlock_vma_page(old_page);
+			unlock_page(old_page);
+		}
+		page_cache_release(old_page);
+	}
+	return page_copied ? VM_FAULT_WRITE : 0;
+oom_free_new:
+	page_cache_release(new_page);
+oom:
+	if (old_page)
+		page_cache_release(old_page);
+	return VM_FAULT_OOM;
+}
+
+/*
  * This routine handles present pages, when users try to write
  * to a shared page. It is done by copying the page to a new address
  * and decrementing the shared-page counter for the old page.
@@ -2064,12 +2204,7 @@ static int do_wp_page(struct mm_struct *
 		spinlock_t *ptl, pte_t orig_pte)
 	__releases(ptl)
 {
-	struct page *old_page, *new_page = NULL;
-	pte_t entry;
-	int page_copied = 0;
-	unsigned long mmun_start = 0;	/* For mmu_notifiers */
-	unsigned long mmun_end = 0;	/* For mmu_notifiers */
-	struct mem_cgroup *memcg;
+	struct page *old_page;
 
 	old_page = vm_normal_page(vma, address, orig_pte);
 	if (!old_page) {
@@ -2085,7 +2220,10 @@ static int do_wp_page(struct mm_struct *
 				     (VM_WRITE|VM_SHARED))
 			return wp_page_reuse(mm, vma, address, page_table, ptl,
 					     orig_pte, old_page, 0, 0);
-		goto gotten;
+
+		pte_unmap_unlock(page_table, ptl);
+		return wp_page_copy(mm, vma, address, page_table, pmd,
+				    orig_pte, old_page);
 	}
 
 	/*
@@ -2165,119 +2303,10 @@ static int do_wp_page(struct mm_struct *
 	 * Ok, we need to copy. Oh, well..
 	 */
 	page_cache_get(old_page);
-gotten:
-	pte_unmap_unlock(page_table, ptl);
-
-	if (unlikely(anon_vma_prepare(vma)))
-		goto oom;
-
-	if (is_zero_pfn(pte_pfn(orig_pte))) {
-		new_page = alloc_zeroed_user_highpage_movable(vma, address);
-		if (!new_page)
-			goto oom;
-	} else {
-		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
-		if (!new_page)
-			goto oom;
-		cow_user_page(new_page, old_page, address, vma);
-	}
-	__SetPageUptodate(new_page);
-
-	if (mem_cgroup_try_charge(new_page, mm, GFP_KERNEL, &memcg))
-		goto oom_free_new;
-
-	mmun_start  = address & PAGE_MASK;
-	mmun_end    = mmun_start + PAGE_SIZE;
-	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
-
-	/*
-	 * Re-check the pte - we dropped the lock
-	 */
-	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (likely(pte_same(*page_table, orig_pte))) {
-		if (old_page) {
-			if (!PageAnon(old_page)) {
-				dec_mm_counter_fast(mm, MM_FILEPAGES);
-				inc_mm_counter_fast(mm, MM_ANONPAGES);
-			}
-		} else
-			inc_mm_counter_fast(mm, MM_ANONPAGES);
-		flush_cache_page(vma, address, pte_pfn(orig_pte));
-		entry = mk_pte(new_page, vma->vm_page_prot);
-		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-		/*
-		 * Clear the pte entry and flush it first, before updating the
-		 * pte with the new entry. This will avoid a race condition
-		 * seen in the presence of one thread doing SMC and another
-		 * thread doing COW.
-		 */
-		ptep_clear_flush_notify(vma, address, page_table);
-		page_add_new_anon_rmap(new_page, vma, address);
-		mem_cgroup_commit_charge(new_page, memcg, false);
-		lru_cache_add_active_or_unevictable(new_page, vma);
-		/*
-		 * We call the notify macro here because, when using secondary
-		 * mmu page tables (such as kvm shadow page tables), we want the
-		 * new page to be mapped directly into the secondary page table.
-		 */
-		set_pte_at_notify(mm, address, page_table, entry);
-		update_mmu_cache(vma, address, page_table);
-		if (old_page) {
-			/*
-			 * Only after switching the pte to the new page may
-			 * we remove the mapcount here. Otherwise another
-			 * process may come and find the rmap count decremented
-			 * before the pte is switched to the new page, and
-			 * "reuse" the old page writing into it while our pte
-			 * here still points into it and can be read by other
-			 * threads.
-			 *
-			 * The critical issue is to order this
-			 * page_remove_rmap with the ptp_clear_flush above.
-			 * Those stores are ordered by (if nothing else,)
-			 * the barrier present in the atomic_add_negative
-			 * in page_remove_rmap.
-			 *
-			 * Then the TLB flush in ptep_clear_flush ensures that
-			 * no process can access the old page before the
-			 * decremented mapcount is visible. And the old page
-			 * cannot be reused until after the decremented
-			 * mapcount is visible. So transitively, TLBs to
-			 * old page will be flushed before it can be reused.
-			 */
-			page_remove_rmap(old_page);
-		}
-
-		/* Free the old page.. */
-		new_page = old_page;
-		page_copied = 1;
-	} else
-		mem_cgroup_cancel_charge(new_page, memcg);
-
-	if (new_page)
-		page_cache_release(new_page);
 
 	pte_unmap_unlock(page_table, ptl);
-	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
-	if (old_page) {
-		/*
-		 * Don't let another task, with possibly unlocked vma,
-		 * keep the mlocked page.
-		 */
-		if (page_copied && (vma->vm_flags & VM_LOCKED)) {
-			lock_page(old_page);	/* LRU manipulation */
-			munlock_vma_page(old_page);
-			unlock_page(old_page);
-		}
-		page_cache_release(old_page);
-	}
-	return page_copied ? VM_FAULT_WRITE : 0;
-oom_free_new:
-	page_cache_release(new_page);
-oom:
-	if (old_page)
-		page_cache_release(old_page);
-	return VM_FAULT_OOM;
+	return wp_page_copy(mm, vma, address, page_table, pmd,
+			    orig_pte, old_page);
 }
 
 static void unmap_mapping_range_vma(struct vm_area_struct *vma,
_

Patches currently in -mm which might be from raindel@mellanox.com are

mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch

