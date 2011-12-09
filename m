From: akpm@linux-foundation.org
Subject: [merged] mm-migratec-pair-unlock_page-and-lock_page-when-migrating-huge-pages.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:08:29 -0800
Message-ID: <201112092008.pB9K8Ta4027831@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:59972 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab1LIUIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:08:31 -0500
Received: by ggnv2 with SMTP id v2so67371ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 09 Dec 2011 12:08:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhillf@gmail.com, aarcange@redhat.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate.c: pair unlock_page() and lock_page() when migrating huge pages
has been removed from the -mm tree.  Its filename was
     mm-migratec-pair-unlock_page-and-lock_page-when-migrating-huge-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hillf Danton <dhillf@gmail.com>
Subject: mm/migrate.c: pair unlock_page() and lock_page() when migrating huge pages

Avoid unlocking and unlocked page if we failed to lock it.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-migratec-pair-unlock_page-and-lock_page-when-migrating-huge-pages mm/migrate.c
--- a/mm/migrate.c~mm-migratec-pair-unlock_page-and-lock_page-when-migrating-huge-pages
+++ a/mm/migrate.c
@@ -871,9 +871,9 @@ static int unmap_and_move_huge_page(new_
 
 	if (anon_vma)
 		put_anon_vma(anon_vma);
-out:
 	unlock_page(hpage);
 
+out:
 	if (rc != -EAGAIN) {
 		list_del(&hpage->lru);
 		put_page(hpage);
_

Patches currently in -mm which might be from dhillf@gmail.com are

origin.patch
linux-next.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch

