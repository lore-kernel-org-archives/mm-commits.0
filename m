From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-race-when-migrate-pages.patch added to -mm tree
Date: Tue, 19 Jul 2016 16:06:51 -0700
Message-ID: <578eb28b.YbRUDGz5RloTVlrE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbcGSXGw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jul 2016 19:06:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, mhocko@suse.cz, qiuxishi@huawei.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: fix race when migrating pages
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-race-when-migrate-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-fix-race-when-migrate-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-fix-race-when-migrate-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: mm/hugetlb.c: fix race when migrating pages

I hit the following code in huge_pte_alloc when run the database and
online-offline memory in the system.

BUG_ON(pte && !pte_none(*pte) && !pte_huge(*pte));

when pmd share function enable, we may be obtain a shared pmd entry.  due
to ongoing offline memory , the pmd entry points to the page will turn
into migrate condition.  therefore, the bug will come up.

The patch fixes it by checking the pmd entry when we obtain the lock.  if
the shared pmd entry points to page is under migration.  we should
allocate a new pmd entry.

Link: http://lkml.kernel.org/r/1468935958-21810-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-race-when-migrate-pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-race-when-migrate-pages
+++ a/mm/hugetlb.c
@@ -4214,7 +4214,7 @@ pte_t *huge_pmd_share(struct mm_struct *
 	struct vm_area_struct *svma;
 	unsigned long saddr;
 	pte_t *spte = NULL;
-	pte_t *pte;
+	pte_t *pte, entry;
 	spinlock_t *ptl;
 
 	if (!vma_shareable(vma, addr))
@@ -4240,6 +4240,11 @@ pte_t *huge_pmd_share(struct mm_struct *
 
 	ptl = huge_pte_lockptr(hstate_vma(vma), mm, spte);
 	spin_lock(ptl);
+	entry = huge_ptep_get(spte);
+	if (is_hugetlb_entry_migration(entry) ||
+			is_hugetlb_entry_hwpoisoned(entry)) {
+		goto out_unlock;
+	}
 	if (pud_none(*pud)) {
 		pud_populate(mm, pud,
 				(pmd_t *)((unsigned long)spte & PAGE_MASK));
@@ -4247,6 +4252,8 @@ pte_t *huge_pmd_share(struct mm_struct *
 	} else {
 		put_page(virt_to_page(spte));
 	}
+
+out_unlock:
 	spin_unlock(ptl);
 out:
 	pte = (pte_t *)pmd_alloc(mm, pud, addr);
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-hugetlb-fix-race-when-migrate-pages.patch
mm-update-the-comment-in-__isolate_free_page.patch
mm-page_owner-align-with-pageblock_nr-pages.patch

