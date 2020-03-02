From: akpm@linux-foundation.org
Subject: +
 mm-page_idle-no-unlikely-double-check-for-idle-page-counting.patch added to
 -mm tree
Date: Mon, 02 Mar 2020 14:14:06 -0800
Message-ID: <20200302221406.imgu5HpnL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgCBWOI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 17:14:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alex.shi@linux.alibaba.com, daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com, khlebnikov@yandex-team.ru, kirill@shutemov.name, kravetz@us.ibm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org, vdavydov.dev@gmail.com, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/page_idle: no unlikely double check for idle page counting
has been added to the -mm tree.  Its filename is
     mm-page_idle-no-unlikely-double-check-for-idle-page-counting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_idle-no-unlikely-double-check-for-idle-page-counting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_idle-no-unlikely-double-check-for-idle-page-counting.patch

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
Subject: mm/page_idle: no unlikely double check for idle page counting

As func comments mentioned, few isolated page missing be tolerated.  So
why not do further to drop the unlikely double check.  That won't cause
more idle pages, but reduce a lock contention.

This is also a preparation for later new page isolation feature.

Link: http://lkml.kernel.org/r/1583146830-169516-4-git-send-email-alex.shi@linux.alibaba.com
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

 mm/page_idle.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/mm/page_idle.c~mm-page_idle-no-unlikely-double-check-for-idle-page-counting
+++ a/mm/page_idle.c
@@ -31,7 +31,6 @@
 static struct page *page_idle_get_page(unsigned long pfn)
 {
 	struct page *page;
-	pg_data_t *pgdat;
 
 	if (!pfn_valid(pfn))
 		return NULL;
@@ -41,13 +40,6 @@ static struct page *page_idle_get_page(u
 	    !get_page_unless_zero(page))
 		return NULL;
 
-	pgdat = page_pgdat(page);
-	spin_lock_irq(&pgdat->lru_lock);
-	if (unlikely(!PageLRU(page))) {
-		put_page(page);
-		page = NULL;
-	}
-	spin_unlock_irq(&pgdat->lru_lock);
 	return page;
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
