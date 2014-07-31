From: akpm@linux-foundation.org
Subject: [merged]
 hwpoison-fix-hugetlbfs-thp-precheck-in-hwpoison_user_mappings.patch removed from -mm tree
Date: Thu, 31 Jul 2014 13:22:08 -0700
Message-ID: <53daa570./INYpdwensNJHQx9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:39238 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaGaUWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jul 2014 16:22:09 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so936896oac.3
        for <mm-commits@vger.kernel.org>; Thu, 31 Jul 2014 13:22:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, slaoub@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison: fix hugetlbfs/thp precheck in hwpoison_user_mappings()
has been removed from the -mm tree.  Its filename was
     hwpoison-fix-hugetlbfs-thp-precheck-in-hwpoison_user_mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hwpoison: fix hugetlbfs/thp precheck in hwpoison_user_mappings()

A recent fix from Chen Yucong 0bc1f8b0682c ("hwpoison: fix the handling
path of the victimized page frame that belong to non-LRU") rejects going
into unmapping operation for hugetlbfs/thp pages, which results in failing
error containing on such pages.  This patch fixes it.

With this patch, hwpoison functional tests in mce-test testsuite pass.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Chen Yucong <slaoub@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/memory-failure.c~hwpoison-fix-hugetlbfs-thp-precheck-in-hwpoison_user_mappings mm/memory-failure.c
--- a/mm/memory-failure.c~hwpoison-fix-hugetlbfs-thp-precheck-in-hwpoison_user_mappings
+++ a/mm/memory-failure.c
@@ -895,7 +895,13 @@ static int hwpoison_user_mappings(struct
 	struct page *hpage = *hpagep;
 	struct page *ppage;
 
-	if (PageReserved(p) || PageSlab(p) || !PageLRU(p))
+	/*
+	 * Here we are interested only in user-mapped pages, so skip any
+	 * other types of pages.
+	 */
+	if (PageReserved(p) || PageSlab(p))
+		return SWAP_SUCCESS;
+	if (!(PageLRU(hpage) || PageHuge(p)))
 		return SWAP_SUCCESS;
 
 	/*
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
mm-update-the-description-for-madvise_remove.patch
mm-hwpoison-injectc-remove-unnecessary-null-test-before-debugfs_remove_recursive.patch
hwpoison-fix-race-with-changing-page-during-offlining-v2.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-hugetlb-remove-hugetlb_zero-and-hugetlb_infinity.patch
mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages.patch
mm-fix-potential-infinite-loop-in-dissolve_free_huge_pages-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

