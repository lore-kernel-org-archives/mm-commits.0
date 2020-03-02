From: akpm@linux-foundation.org
Subject: + mm-thp-clean-up-lru_add_page_tail.patch added to -mm
 tree
Date: Mon, 02 Mar 2020 14:14:12 -0800
Message-ID: <20200302221412.vKQoS44p5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgCBWOO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 17:14:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alex.shi@linux.alibaba.com, daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com, khlebnikov@yandex-team.ru, kirill@shutemov.name, kravetz@us.ibm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org, vdavydov.dev@gmail.com, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/thp: clean up lru_add_page_tail
has been added to the -mm tree.  Its filename is
     mm-thp-clean-up-lru_add_page_tail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-clean-up-lru_add_page_tail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-clean-up-lru_add_page_tail.patch

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
Subject: mm/thp: clean up lru_add_page_tail

Since the first parameter is only used on a head page, it's better to make
this clear with the namin.  And there is no need to keep checking
PageHead():

	VM_BUG_ON_PAGE(!PageHead(page), page);

Link: http://lkml.kernel.org/r/1583146830-169516-6-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-thp-clean-up-lru_add_page_tail
+++ a/mm/huge_memory.c
@@ -2462,21 +2462,20 @@ static void remap_page(struct page *page
 	}
 }
 
-void lru_add_page_tail(struct page *page, struct page *page_tail,
+void lru_add_page_tail(struct page *head, struct page *page_tail,
 		       struct lruvec *lruvec, struct list_head *list)
 {
 	const int file = 0;
 
-	VM_BUG_ON_PAGE(!PageHead(page), page);
-	VM_BUG_ON_PAGE(PageCompound(page_tail), page);
-	VM_BUG_ON_PAGE(PageLRU(page_tail), page);
+	VM_BUG_ON_PAGE(PageCompound(page_tail), head);
+	VM_BUG_ON_PAGE(PageLRU(page_tail), head);
 	lockdep_assert_held(&lruvec_pgdat(lruvec)->lru_lock);
 
 	if (!list)
 		SetPageLRU(page_tail);
 
-	if (likely(PageLRU(page)))
-		list_add_tail(&page_tail->lru, &page->lru);
+	if (likely(PageLRU(head)))
+		list_add_tail(&page_tail->lru, &head->lru);
 	else if (list) {
 		/* page reclaim is reclaiming a huge page */
 		get_page(page_tail);
@@ -2493,7 +2492,7 @@ void lru_add_page_tail(struct page *page
 					  page_lru(page_tail));
 	}
 
-	if (!PageUnevictable(page))
+	if (!PageUnevictable(head))
 		update_page_reclaim_stat(lruvec, file, PageActive(page_tail));
 }
 
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
