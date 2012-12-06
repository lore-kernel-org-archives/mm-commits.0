From: akpm@linux-foundation.org
Subject: + hwpoison-hugetlbfs-fix-rss-counter-warning.patch added to -mm tree
Date: Thu, 06 Dec 2012 14:40:24 -0800
Message-ID: <20121206224025.13C8B100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:33106 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab2LFWk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Dec 2012 17:40:26 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so700796vbi.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Dec 2012 14:40:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, andi.kleen@intel.com, aneesh.kumar@linux.vnet.ibm.com, fengguang.wu@intel.com, tony.luck@intel.com


The patch titled
     Subject: hwpoison, hugetlbfs: fix RSS-counter warning
has been added to the -mm tree.  Its filename is
     hwpoison-hugetlbfs-fix-rss-counter-warning.patch

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
Subject: hwpoison, hugetlbfs: fix RSS-counter warning

Memory error handling on hugepages can break a RSS counter, which emits a
message like "Bad rss-counter state mm:ffff88040abecac0 idx:1 val:-1". 
This is because PageAnon returns true for hugepage (this behavior is
necessary for reverse mapping to work on hugetlbfs).

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi.kleen@intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/rmap.c~hwpoison-hugetlbfs-fix-rss-counter-warning mm/rmap.c
--- a/mm/rmap.c~hwpoison-hugetlbfs-fix-rss-counter-warning
+++ a/mm/rmap.c
@@ -1249,7 +1249,9 @@ int try_to_unmap_one(struct page *page, 
 	update_hiwater_rss(mm);
 
 	if (PageHWPoison(page) && !(flags & TTU_IGNORE_HWPOISON)) {
-		if (PageAnon(page))
+		if (PageHuge(page))
+			;
+		else if (PageAnon(page))
 			dec_mm_counter(mm, MM_ANONPAGES);
 		else
 			dec_mm_counter(mm, MM_FILEPAGES);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-fix-action_result-to-print-out-dirty-clean.patch
mm-print-out-information-of-file-affected-by-memory-error.patch
hwpoison-hugetlbfs-fix-warning-on-freeing-hwpoisoned-hugepage.patch
hwpoison-hugetlbfs-fix-bad-pmd-warning-in-unmapping-hwpoisoned-hugepage.patch
hwpoison-hugetlbfs-fix-rss-counter-warning.patch
hwpoison-hugetlbfs-fix-rss-counter-warning-fix.patch

