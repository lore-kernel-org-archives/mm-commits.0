From: akpm@linux-foundation.org
Subject: [failures]
 mm-page_idle-no-unlikely-double-check-for-idle-page-counting.patch removed
 from -mm tree
Date: Thu, 05 Mar 2020 18:50:48 -0800
Message-ID: <20200306025048.DRH1DC7nZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726162AbgCFCut (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 5 Mar 2020 21:50:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, alex.shi@linux.alibaba.com, daniel.m.jordan@oracle.com, hannes@cmpxchg.org, hughd@google.com, khlebnikov@yandex-team.ru, kirill@shutemov.name, kravetz@us.ibm.com, mhocko@kernel.org, mm-commits@vger.kernel.org, tj@kernel.org, vdavydov.dev@gmail.com, willy@infradead.org, yang.shi@linux.alibaba.com


The patch titled
     Subject: mm/page_idle: no unlikely double check for idle page counting
has been removed from the -mm tree.  Its filename was
     mm-page_idle-no-unlikely-double-check-for-idle-page-counting.patch

This patch was dropped because it had testing failures

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
mm-thp-move-lru_add_page_tail-func-to-huge_memoryc.patch
mm-thp-clean-up-lru_add_page_tail.patch
mm-thp-narrow-lru-locking.patch
