From: akpm@linux-foundation.org
Subject: + mm-memcg-fold-lock_page_lru-into-commit_charge.patch
 added to -mm tree
Date: Mon, 02 Mar 2020 14:14:02 -0800
Message-ID: <20200302221402.wwpwEPhV4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgCBWOF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 17:14:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alex.shi@linux.alibaba.com, daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com, khlebnikov@yandex-team.ru, kirill@shutemov.name, kravetz@us.ibm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org, vdavydov.dev@gmail.com, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/memcg: fold lock_page_lru into commit_charge
has been added to the -mm tree.  Its filename is
     mm-memcg-fold-lock_page_lru-into-commit_charge.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fold-lock_page_lru-into-commit_charge.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fold-lock_page_lru-into-commit_charge.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: fold lock_page_lru into commit_charge

As Konstantin Khlebnikov mentioned:

	Also I don't like these functions:
	- called lock/unlock but actually also isolates
	- used just once
	- pgdat evaluated twice

Cleanup and fold these functions into commit_charge.  It also reduces lock
time while lrucare && !PageLRU.

Link: http://lkml.kernel.org/r/1583146830-169516-3-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   57 ++++++++++++++++------------------------------
 1 file changed, 20 insertions(+), 37 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-fold-lock_page_lru-into-commit_charge
+++ a/mm/memcontrol.c
@@ -2575,41 +2575,11 @@ static void cancel_charge(struct mem_cgr
 	css_put_many(&memcg->css, nr_pages);
 }
 
-static void lock_page_lru(struct page *page, int *isolated)
-{
-	pg_data_t *pgdat = page_pgdat(page);
-
-	spin_lock_irq(&pgdat->lru_lock);
-	if (PageLRU(page)) {
-		struct lruvec *lruvec;
-
-		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		ClearPageLRU(page);
-		del_page_from_lru_list(page, lruvec, page_lru(page));
-		*isolated = 1;
-	} else
-		*isolated = 0;
-}
-
-static void unlock_page_lru(struct page *page, int isolated)
-{
-	pg_data_t *pgdat = page_pgdat(page);
-
-	if (isolated) {
-		struct lruvec *lruvec;
-
-		lruvec = mem_cgroup_page_lruvec(page, pgdat);
-		VM_BUG_ON_PAGE(PageLRU(page), page);
-		SetPageLRU(page);
-		add_page_to_lru_list(page, lruvec, page_lru(page));
-	}
-	spin_unlock_irq(&pgdat->lru_lock);
-}
-
 static void commit_charge(struct page *page, struct mem_cgroup *memcg,
 			  bool lrucare)
 {
-	int isolated;
+	struct lruvec *lruvec = NULL;
+	pg_data_t *pgdat;
 
 	VM_BUG_ON_PAGE(page->mem_cgroup, page);
 
@@ -2617,9 +2587,17 @@ static void commit_charge(struct page *p
 	 * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
 	 * may already be on some other mem_cgroup's LRU.  Take care of it.
 	 */
-	if (lrucare)
-		lock_page_lru(page, &isolated);
-
+	if (lrucare) {
+		pgdat = page_pgdat(page);
+		spin_lock_irq(&pgdat->lru_lock);
+
+		if (PageLRU(page)) {
+			lruvec = mem_cgroup_page_lruvec(page, pgdat);
+			ClearPageLRU(page);
+			del_page_from_lru_list(page, lruvec, page_lru(page));
+		} else
+			spin_unlock_irq(&pgdat->lru_lock);
+	}
 	/*
 	 * Nobody should be changing or seriously looking at
 	 * page->mem_cgroup at this point:
@@ -2636,8 +2614,13 @@ static void commit_charge(struct page *p
 	 */
 	page->mem_cgroup = memcg;
 
-	if (lrucare)
-		unlock_page_lru(page, isolated);
+	if (lrucare && lruvec) {
+		lruvec = mem_cgroup_page_lruvec(page, pgdat);
+		VM_BUG_ON_PAGE(PageLRU(page), page);
+		SetPageLRU(page);
+		add_page_to_lru_list(page, lruvec, page_lru(page));
+		spin_unlock_irq(&pgdat->lru_lock);
+	}
 }
 
 #ifdef CONFIG_MEMCG_KMEM
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

ocfs2-remove-fs_ocfs2_nm.patch
ocfs2-remove-unused-macros.patch
ocfs2-use-ocfs2_sec_bits-in-macro.patch
ocfs2-remove-dlm_lock_is_remote.patch
ocfs2-remove-useless-err.patch
mm-vmscan-remove-unnecessary-lruvec-adding.patch
mm-memcg-fold-lock_page_lru-into-commit_charge.patch
mm-page_idle-no-unlikely-double-check-for-idle-page-counting.patch
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-clean-up-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
