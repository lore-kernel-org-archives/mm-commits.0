From: akpm@linux-foundation.org
Subject: + pagewalk-update-page-table-walker-core-fix-4.patch added to -mm tree
Date: Fri, 04 Apr 2014 14:33:22 -0700
Message-ID: <533f2522.sYlugGgcUpKhaJ5b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaDDVdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 17:33:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, n-horiguchi@ah.jp.nec.com

Subject: + pagewalk-update-page-table-walker-core-fix-4.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 14:33:22 -0700


The patch titled
     Subject: mm/pagewalk.c: move pte null check
has been added to the -mm tree.  Its filename is
     pagewalk-update-page-table-walker-core-fix-4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pagewalk-update-page-table-walker-core-fix-4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pagewalk-update-page-table-walker-core-fix-4.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/pagewalk.c: move pte null check

huge_pte_offset() can return NULL, so we need check it before trying to
take page table lock to avoid a crash.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/pagewalk.c~pagewalk-update-page-table-walker-core-fix-4 mm/pagewalk.c
--- a/mm/pagewalk.c~pagewalk-update-page-table-walker-core-fix-4
+++ a/mm/pagewalk.c
@@ -193,12 +193,14 @@ static int walk_hugetlb_range(unsigned l
 	do {
 		next = hugetlb_entry_end(h, addr, end);
 		pte = huge_pte_offset(walk->mm, addr & hmask);
+		if (!pte)
+			continue;
 		ptl = huge_pte_lock(h, mm, pte);
 		/*
 		 * Callers should have their own way to handle swap entries
 		 * in walk->hugetlb_entry().
 		 */
-		if (pte && walk->hugetlb_entry)
+		if (walk->hugetlb_entry)
 			err = walk->hugetlb_entry(pte, addr, next, walk);
 		spin_unlock(ptl);
 		if (err)
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
pagewalk-update-page-table-walker-core-fix-4.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-hugetlb-fix-softlockup-when-a-large-number-of-hugepages-are-freed.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

