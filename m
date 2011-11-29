From: akpm@linux-foundation.org
Subject: + mm-migratec-pair-unlock_page-and-lock_page-when-migrating-huge-pages.patch added to -mm tree
Date: Mon, 28 Nov 2011 16:36:05 -0800
Message-ID: <201111290036.pAT0a51T023820@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:37442 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1K2AgJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 19:36:09 -0500
Received: by ghrr18 with SMTP id r18so251547ghr.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 16:36:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhillf@gmail.com, aarcange@redhat.com, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: mm/migrate.c: pair unlock_page() and lock_page() when migrating huge pages
has been added to the -mm tree.  Its filename is
     mm-migratec-pair-unlock_page-and-lock_page-when-migrating-huge-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: mm/migrate.c: pair unlock_page() and lock_page() when migrating huge pages

Patches currently in -mm which might be from dhillf@gmail.com are

linux-next.patch
mm-migratec-pair-unlock_page-and-lock_page-when-migrating-huge-pages.patch
hugetlb-detect-race-upon-page-allocation-failure-during-cow.patch
hugetlb-clarify-hugetlb_instantiation_mutex-usage.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch

