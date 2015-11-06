From: akpm@linux-foundation.org
Subject: [merged] mm-do-not-inc-nr_pagetable-if-ptlock_init-failed.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:16:23 -0800
Message-ID: <563d0a97.4rGF2lFgHCj/Cif1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161793AbbKFUQX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: do not inc NR_PAGETABLE if ptlock_init failed
has been removed from the -mm tree.  Its filename was
     mm-do-not-inc-nr_pagetable-if-ptlock_init-failed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: mm: do not inc NR_PAGETABLE if ptlock_init failed

If ALLOC_SPLIT_PTLOCKS is defined, ptlock_init may fail, in which case we
shouldn't increment NR_PAGETABLE.

Since small allocations, such as ptlock, normally do not fail (currently
they can fail if kmemcg is used though), this patch does not really fix
anything and should be considered as a code cleanup.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-do-not-inc-nr_pagetable-if-ptlock_init-failed include/linux/mm.h
--- a/include/linux/mm.h~mm-do-not-inc-nr_pagetable-if-ptlock_init-failed
+++ a/include/linux/mm.h
@@ -1606,8 +1606,10 @@ static inline void pgtable_init(void)
 
 static inline bool pgtable_page_ctor(struct page *page)
 {
+	if (!ptlock_init(page))
+		return false;
 	inc_zone_page_state(page, NR_PAGETABLE);
-	return ptlock_init(page);
+	return true;
 }
 
 static inline void pgtable_page_dtor(struct page *page)
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are


