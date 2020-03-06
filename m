From: akpm@linux-foundation.org
Subject: [failures] mm-thp-narrow-lru-locking.patch removed from
 -mm tree
Date: Thu, 05 Mar 2020 18:50:57 -0800
Message-ID: <20200306025057.uXeiwAG1U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgCFCu6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Mar 2020 21:50:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alex.shi@linux.alibaba.com, daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com, khlebnikov@yandex-team.ru, kirill@shutemov.name, kravetz@us.ibm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org, vdavydov.dev@gmail.com, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/thp: narrow lru locking
has been removed from the -mm tree.  Its filename was
     mm-thp-narrow-lru-locking.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/thp: narrow lru locking

Lru locking just guards the lru list and subpage's Mlocked.  Including
other things can't give help just delay the locking release.  So narrow
the locking for early lock release and better code meaning.

Link: http://lkml.kernel.org/r/1583146830-169516-7-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/huge_memory.c~mm-thp-narrow-lru-locking
+++ a/mm/huge_memory.c
@@ -2559,13 +2559,14 @@ static void __split_huge_page_tail(struc
 }
 
 static void __split_huge_page(struct page *page, struct list_head *list,
-		pgoff_t end, unsigned long flags)
+				pgoff_t end)
 {
 	struct page *head = compound_head(page);
 	pg_data_t *pgdat = page_pgdat(head);
 	struct lruvec *lruvec;
 	struct address_space *swap_cache = NULL;
 	unsigned long offset = 0;
+	unsigned long flags;
 	int i;
 
 	lruvec = mem_cgroup_page_lruvec(head, pgdat);
@@ -2581,6 +2582,9 @@ static void __split_huge_page(struct pag
 		xa_lock(&swap_cache->i_pages);
 	}
 
+	/* Lru list would be changed, don't care head's LRU bit. */
+	spin_lock_irqsave(&pgdat->lru_lock, flags);
+
 	for (i = HPAGE_PMD_NR - 1; i >= 1; i--) {
 		__split_huge_page_tail(head, i, lruvec, list);
 		/* Some pages can be beyond i_size: drop them from page cache */
@@ -2598,6 +2602,7 @@ static void __split_huge_page(struct pag
 					head + i, 0);
 		}
 	}
+	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
 
 	ClearPageCompound(head);
 
@@ -2618,8 +2623,6 @@ static void __split_huge_page(struct pag
 		xa_unlock(&head->mapping->i_pages);
 	}
 
-	spin_unlock_irqrestore(&pgdat->lru_lock, flags);
-
 	remap_page(head);
 
 	for (i = 0; i < HPAGE_PMD_NR; i++) {
@@ -2757,13 +2760,11 @@ bool can_split_huge_page(struct page *pa
 int split_huge_page_to_list(struct page *page, struct list_head *list)
 {
 	struct page *head = compound_head(page);
-	struct pglist_data *pgdata = NODE_DATA(page_to_nid(head));
 	struct deferred_split *ds_queue = get_deferred_split_queue(head);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
 	int count, mapcount, extra_pins, ret;
 	bool mlocked;
-	unsigned long flags;
 	pgoff_t end;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
@@ -2829,9 +2830,6 @@ int split_huge_page_to_list(struct page
 	if (mlocked)
 		lru_add_drain();
 
-	/* prevent PageLRU to go away from under us, and freeze lru stats */
-	spin_lock_irqsave(&pgdata->lru_lock, flags);
-
 	if (mapping) {
 		XA_STATE(xas, &mapping->i_pages, page_index(head));
 
@@ -2861,7 +2859,7 @@ int split_huge_page_to_list(struct page
 				__dec_node_page_state(head, NR_FILE_THPS);
 		}
 
-		__split_huge_page(page, list, end, flags);
+		__split_huge_page(page, list, end);
 		if (PageSwapCache(head)) {
 			swp_entry_t entry = { .val = page_private(head) };
 
@@ -2880,7 +2878,6 @@ int split_huge_page_to_list(struct page
 		spin_unlock(&ds_queue->split_queue_lock);
 fail:		if (mapping)
 			xa_unlock(&mapping->i_pages);
-		spin_unlock_irqrestore(&pgdata->lru_lock, flags);
 		remap_page(head);
 		ret = -EBUSY;
 	}
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

ocfs2-remove-fs_ocfs2_nm.patch
ocfs2-remove-unused-macros.patch
ocfs2-use-ocfs2_sec_bits-in-macro.patch
ocfs2-remove-dlm_lock_is_remote.patch
ocfs2-remove-useless-err.patch
