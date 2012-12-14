From: akpm@linux-foundation.org
Subject: [merged] hwpoison-hugetlbfs-fix-rss-counter-warning.patch removed from -mm tree
Date: Fri, 14 Dec 2012 15:30:11 -0800
Message-ID: <20121214233012.45B3620005C@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:52455 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab2LNXaO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Dec 2012 18:30:14 -0500
Received: by mail-ea0-f202.google.com with SMTP id j12so208227eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Dec 2012 15:30:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi.kleen@intel.com, aneesh.kumar@linux.vnet.ibm.com, fengguang.wu@intel.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hwpoison, hugetlbfs: fix RSS-counter warning
has been removed from the -mm tree.  Its filename was
     hwpoison-hugetlbfs-fix-rss-counter-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hwpoison, hugetlbfs: fix RSS-counter warning

Memory error handling on hugepages can break a RSS counter, which emits a
message like "Bad rss-counter state mm:ffff88040abecac0 idx:1 val:-1". 
This is because PageAnon returns true for hugepage (this behavior is
necessary for reverse mapping to work on hugetlbfs).

[akpm@linux-foundation.org: clean up code layout]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/rmap.c~hwpoison-hugetlbfs-fix-rss-counter-warning mm/rmap.c
--- a/mm/rmap.c~hwpoison-hugetlbfs-fix-rss-counter-warning
+++ a/mm/rmap.c
@@ -1249,12 +1249,14 @@ int try_to_unmap_one(struct page *page, 
 	update_hiwater_rss(mm);
 
 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
-		if (PageAnon(page))
-			dec_mm_counter(mm, MM_ANONPAGES);
-		else
-			dec_mm_counter(mm, MM_FILEPAGES);
+		if (!PageHuge(page)) {
+			if (PageAnon(page))
+				dec_mm_counter(mm, MM_ANONPAGES);
+			else
+				dec_mm_counter(mm, MM_FILEPAGES);
+		}
 		set_pte_at(mm, address, pte,
-				swp_entry_to_pte(make_hwpoison_entry(page)));
+			   swp_entry_to_pte(make_hwpoison_entry(page)));
 	} else if (PageAnon(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-print-out-information-of-file-affected-by-memory-error.patch

