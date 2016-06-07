From: akpm@linux-foundation.org
Subject: + thp-file-pages-support-for-split_huge_page.patch added to -mm
 tree
Date: Tue, 07 Jun 2016 14:04:13 -0700
Message-ID: <575736cd.zwno2aV4cjeRs2aR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161158AbcFGVEP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2016 17:04:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, andreslc@google.com, aneesh.kumar@linux.vnet.ibm.com, cl@gentwo.org, dave.hansen@intel.com, hughd@google.com, jmarchan@redhat.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, quning@gmail.com, sasha.levin@oracle.com, vbabka@suse.cz, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: file pages support for split_huge_page()
has been added to the -mm tree.  Its filename is
     thp-file-pages-support-for-split_huge_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-file-pages-support-for-split_huge_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-file-pages-support-for-split_huge_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: file pages support for split_huge_page()

Basic scheme is the same as for anon THP.

Main differences:

  - File pages are on radix-tree, so we have head->_count offset by
    HPAGE_PMD_NR. The count got distributed to small pages during split.

  - mapping->tree_lock prevents non-lockless access to pages under split
    over radix-tree;

  - Lockless access is prevented by setting the head->_count to 0 during
    split;

  - After split, some pages can be beyond i_size. We drop them from
    radix-tree.

  - We don't setup migration entries. Just unmap pages. It helps
    handling cases when i_size is in the middle of the page: no need
    handle unmap pages beyond i_size manually.

Link: http://lkml.kernel.org/r/1465297246-98985-15-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Ning Qu <quning@gmail.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c         |    2 
 mm/huge_memory.c |  160 ++++++++++++++++++++++++++++++++-------------
 2 files changed, 117 insertions(+), 45 deletions(-)

diff -puN mm/gup.c~thp-file-pages-support-for-split_huge_page mm/gup.c
--- a/mm/gup.c~thp-file-pages-support-for-split_huge_page
+++ a/mm/gup.c
@@ -288,6 +288,8 @@ struct page *follow_page_mask(struct vm_
 			ret = split_huge_page(page);
 			unlock_page(page);
 			put_page(page);
+			if (pmd_none(*pmd))
+				return no_page_table(vma, flags);
 		}
 
 		return ret ? ERR_PTR(ret) :
diff -puN mm/huge_memory.c~thp-file-pages-support-for-split_huge_page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-file-pages-support-for-split_huge_page
+++ a/mm/huge_memory.c
@@ -30,6 +30,7 @@
 #include <linux/hashtable.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/page_idle.h>
+#include <linux/shmem_fs.h>
 
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
@@ -3206,12 +3207,15 @@ void vma_adjust_trans_huge(struct vm_are
 
 static void freeze_page(struct page *page)
 {
-	enum ttu_flags ttu_flags = TTU_MIGRATION | TTU_IGNORE_MLOCK |
-		TTU_IGNORE_ACCESS | TTU_RMAP_LOCKED;
+	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS |
+		TTU_RMAP_LOCKED;
 	int i, ret;
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
+	if (PageAnon(page))
+		ttu_flags |= TTU_MIGRATION;
+
 	/* We only need TTU_SPLIT_HUGE_PMD once */
 	ret = try_to_unmap(page, ttu_flags | TTU_SPLIT_HUGE_PMD);
 	for (i = 1; !ret && i < HPAGE_PMD_NR; i++) {
@@ -3221,7 +3225,7 @@ static void freeze_page(struct page *pag
 
 		ret = try_to_unmap(page + i, ttu_flags);
 	}
-	VM_BUG_ON(ret);
+	VM_BUG_ON_PAGE(ret, page + i - 1);
 }
 
 static void unfreeze_page(struct page *page)
@@ -3243,15 +3247,20 @@ static void __split_huge_page_tail(struc
 	/*
 	 * tail_page->_refcount is zero and not changing from under us. But
 	 * get_page_unless_zero() may be running from under us on the
-	 * tail_page. If we used atomic_set() below instead of atomic_inc(), we
-	 * would then run atomic_set() concurrently with
+	 * tail_page. If we used atomic_set() below instead of atomic_inc() or
+	 * atomic_add(), we would then run atomic_set() concurrently with
 	 * get_page_unless_zero(), and atomic_set() is implemented in C not
 	 * using locked ops. spin_unlock on x86 sometime uses locked ops
 	 * because of PPro errata 66, 92, so unless somebody can guarantee
 	 * atomic_set() here would be safe on all archs (and not only on x86),
-	 * it's safer to use atomic_inc().
+	 * it's safer to use atomic_inc()/atomic_add().
 	 */
-	page_ref_inc(page_tail);
+	if (PageAnon(head)) {
+		page_ref_inc(page_tail);
+	} else {
+		/* Additional pin to radix tree */
+		page_ref_add(page_tail, 2);
+	}
 
 	page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	page_tail->flags |= (head->flags &
@@ -3287,25 +3296,44 @@ static void __split_huge_page_tail(struc
 	lru_add_page_tail(head, page_tail, lruvec, list);
 }
 
-static void __split_huge_page(struct page *page, struct list_head *list)
+static void __split_huge_page(struct page *page, struct list_head *list,
+		unsigned long flags)
 {
 	struct page *head = compound_head(page);
 	struct zone *zone = page_zone(head);
 	struct lruvec *lruvec;
+	pgoff_t end = -1;
 	int i;
 
-	/* prevent PageLRU to go away from under us, and freeze lru stats */
-	spin_lock_irq(&zone->lru_lock);
 	lruvec = mem_cgroup_page_lruvec(head, zone);
 
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(head);
 
-	for (i = HPAGE_PMD_NR - 1; i >= 1; i--)
+	if (!PageAnon(page))
+		end = DIV_ROUND_UP(i_size_read(head->mapping->host), PAGE_SIZE);
+
+	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
+		/* Some pages can be beyond i_size: drop them from page cache */
+		if (head[i].index >= end) {
+			__ClearPageDirty(head + i);
+			__delete_from_page_cache(head + i, NULL);
+			put_page(head + i);
+		}
+	}
 
 	ClearPageCompound(head);
-	spin_unlock_irq(&zone->lru_lock);
+	/* See comment in __split_huge_page_tail() */
+	if (PageAnon(head)) {
+		page_ref_inc(head);
+	} else {
+		/* Additional pin to radix tree */
+		page_ref_add(head, 2);
+		spin_unlock(&head->mapping->tree_lock);
+	}
+
+	spin_unlock_irqrestore(&page_zone(head)->lru_lock, flags);
 
 	unfreeze_page(head);
 
@@ -3430,36 +3458,54 @@ int split_huge_page_to_list(struct page
 {
 	struct page *head = compound_head(page);
 	struct pglist_data *pgdata = NODE_DATA(page_to_nid(head));
-	struct anon_vma *anon_vma;
-	int count, mapcount, ret;
+	struct anon_vma *anon_vma = NULL;
+	struct address_space *mapping = NULL;
+	int count, mapcount, extra_pins, ret;
 	bool mlocked;
 	unsigned long flags;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(page), page);
-	VM_BUG_ON_PAGE(!PageAnon(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
 
-	/*
-	 * The caller does not necessarily hold an mmap_sem that would prevent
-	 * the anon_vma disappearing so we first we take a reference to it
-	 * and then lock the anon_vma for write. This is similar to
-	 * page_lock_anon_vma_read except the write lock is taken to serialise
-	 * against parallel split or collapse operations.
-	 */
-	anon_vma = page_get_anon_vma(head);
-	if (!anon_vma) {
-		ret = -EBUSY;
-		goto out;
+	if (PageAnon(head)) {
+		/*
+		 * The caller does not necessarily hold an mmap_sem that would
+		 * prevent the anon_vma disappearing so we first we take a
+		 * reference to it and then lock the anon_vma for write. This
+		 * is similar to page_lock_anon_vma_read except the write lock
+		 * is taken to serialise against parallel split or collapse
+		 * operations.
+		 */
+		anon_vma = page_get_anon_vma(head);
+		if (!anon_vma) {
+			ret = -EBUSY;
+			goto out;
+		}
+		extra_pins = 0;
+		mapping = NULL;
+		anon_vma_lock_write(anon_vma);
+	} else {
+		mapping = head->mapping;
+
+		/* Truncated ? */
+		if (!mapping) {
+			ret = -EBUSY;
+			goto out;
+		}
+
+		/* Addidional pins from radix tree */
+		extra_pins = HPAGE_PMD_NR;
+		anon_vma = NULL;
+		i_mmap_lock_read(mapping);
 	}
-	anon_vma_lock_write(anon_vma);
 
 	/*
 	 * Racy check if we can split the page, before freeze_page() will
 	 * split PMDs
 	 */
-	if (total_mapcount(head) != page_count(head) - 1) {
+	if (total_mapcount(head) != page_count(head) - extra_pins - 1) {
 		ret = -EBUSY;
 		goto out_unlock;
 	}
@@ -3472,35 +3518,60 @@ int split_huge_page_to_list(struct page
 	if (mlocked)
 		lru_add_drain();
 
+	/* prevent PageLRU to go away from under us, and freeze lru stats */
+	spin_lock_irqsave(&page_zone(head)->lru_lock, flags);
+
+	if (mapping) {
+		void **pslot;
+
+		spin_lock(&mapping->tree_lock);
+		pslot = radix_tree_lookup_slot(&mapping->page_tree,
+				page_index(head));
+		/*
+		 * Check if the head page is present in radix tree.
+		 * We assume all tail are present too, if head is there.
+		 */
+		if (radix_tree_deref_slot_protected(pslot,
+					&mapping->tree_lock) != head)
+			goto fail;
+	}
+
 	/* Prevent deferred_split_scan() touching ->_refcount */
-	spin_lock_irqsave(&pgdata->split_queue_lock, flags);
+	spin_lock(&pgdata->split_queue_lock);
 	count = page_count(head);
 	mapcount = total_mapcount(head);
-	if (!mapcount && count == 1) {
+	if (!mapcount && page_ref_freeze(head, 1 + extra_pins)) {
 		if (!list_empty(page_deferred_list(head))) {
 			pgdata->split_queue_len--;
 			list_del(page_deferred_list(head));
 		}
-		spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
-		__split_huge_page(page, list);
+		spin_unlock(&pgdata->split_queue_lock);
+		__split_huge_page(page, list, flags);
 		ret = 0;
-	} else if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {
-		spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
-		pr_alert("total_mapcount: %u, page_count(): %u\n",
-				mapcount, count);
-		if (PageTail(page))
-			dump_page(head, NULL);
-		dump_page(page, "total_mapcount(head) > 0");
-		BUG();
 	} else {
-		spin_unlock_irqrestore(&pgdata->split_queue_lock, flags);
+		if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {
+			pr_alert("total_mapcount: %u, page_count(): %u\n",
+					mapcount, count);
+			if (PageTail(page))
+				dump_page(head, NULL);
+			dump_page(page, "total_mapcount(head) > 0");
+			BUG();
+		}
+		spin_unlock(&pgdata->split_queue_lock);
+fail:		if (mapping)
+			spin_unlock(&mapping->tree_lock);
+		spin_unlock_irqrestore(&page_zone(head)->lru_lock, flags);
 		unfreeze_page(head);
 		ret = -EBUSY;
 	}
 
 out_unlock:
-	anon_vma_unlock_write(anon_vma);
-	put_anon_vma(anon_vma);
+	if (anon_vma) {
+		anon_vma_unlock_write(anon_vma);
+		put_anon_vma(anon_vma);
+	}
+	if (mapping)
+		i_mmap_unlock_read(mapping);
 out:
 	count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	return ret;
@@ -3623,8 +3694,7 @@ static int split_huge_pages_set(void *da
 			if (zone != page_zone(page))
 				goto next;
 
-			if (!PageHead(page) || !PageAnon(page) ||
-					PageHuge(page))
+			if (!PageHead(page) || PageHuge(page) || !PageLRU(page))
 				goto next;
 
 			total++;
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix.patch
thp-mlock-update-unevictable-lrutxt.patch
mm-do-not-pass-mm_struct-into-handle_mm_fault.patch
mm-introduce-fault_env.patch
mm-postpone-page-table-allocation-until-we-have-page-to-map.patch
rmap-support-file-thp.patch
mm-introduce-do_set_pmd.patch
thp-vmstats-add-counters-for-huge-file-pages.patch
thp-support-file-pages-in-zap_huge_pmd.patch
thp-handle-file-pages-in-split_huge_pmd.patch
thp-handle-file-cow-faults.patch
thp-skip-file-huge-pmd-on-copy_huge_pmd.patch
thp-prepare-change_huge_pmd-for-file-thp.patch
thp-run-vma_adjust_trans_huge-outside-i_mmap_rwsem.patch
thp-file-pages-support-for-split_huge_page.patch
thp-mlock-do-not-mlock-pte-mapped-file-huge-pages.patch
vmscan-split-file-huge-pages-before-paging-them-out.patch
page-flags-relax-policy-for-pg_mappedtodisk-and-pg_reclaim.patch
radix-tree-implement-radix_tree_maybe_preload_order.patch
filemap-prepare-find-and-delete-operations-for-huge-pages.patch
truncate-handle-file-thp.patch
mm-rmap-account-shmem-thp-pages.patch
shmem-prepare-huge=-mount-option-and-sysfs-knob.patch
shmem-add-huge-pages-support.patch
shmem-thp-respect-madv_nohugepage-for-file-mappings.patch
thp-extract-khugepaged-from-mm-huge_memoryc.patch
khugepaged-move-up_readmmap_sem-out-of-khugepaged_alloc_page.patch
shmem-make-shmem_inode_info-lock-irq-safe.patch
khugepaged-add-support-of-collapse-for-tmpfs-shmem-pages.patch
thp-introduce-config_transparent_huge_pagecache.patch
shmem-split-huge-pages-beyond-i_size-under-memory-pressure.patch
thp-update-documentation-vm-transhugefilesystems-proctxt.patch
a.patch

