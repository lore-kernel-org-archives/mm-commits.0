From: akpm@linux-foundation.org
Subject: [merged]
 mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch removed from
 -mm tree
Date: Tue, 19 Jan 2016 12:14:27 -0800
Message-ID: <569e9923.ZqPanwImZxBXxhXR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: soft-offline: exit with failure for non anonymous thp
has been removed from the -mm tree.  Its filename was
     mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: soft-offline: exit with failure for non anonymous thp

Currently memory_failure() doesn't handle non anonymous thp case, because
we can hardly expect the error handling to be successful, and it can just
hit some corner case which results in BUG_ON or something severe like
that.  This is also the case for soft offline code, so let's make it in
the same way.

Orignal code has a MF_COUNT_INCREASED check before put_hwpoison_page(),
but it's unnecessary because get_any_page() is already called when running
on this code, which takes a refcount of the target page regardress of the
flag.  So this patch also removes it.

[akpm@linux-foundation.org: fix build]
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/memory-failure.c~mm-soft-offline-exit-with-failure-for-non-anonymous-thp mm/memory-failure.c
--- a/mm/memory-failure.c~mm-soft-offline-exit-with-failure-for-non-anonymous-thp
+++ a/mm/memory-failure.c
@@ -1691,16 +1691,16 @@ static int soft_offline_in_use_page(stru
 
 	if (!PageHuge(page) && PageTransHuge(hpage)) {
 		lock_page(hpage);
-		ret = split_huge_page(hpage);
-		unlock_page(hpage);
-		if (unlikely(ret || PageTransCompound(page) ||
-			     !PageAnon(page))) {
-			pr_info("soft offline: %#lx: failed to split THP\n",
-				page_to_pfn(page));
-			if (flags & MF_COUNT_INCREASED)
-				put_hwpoison_page(hpage);
+		if (!PageAnon(hpage) || unlikely(split_huge_page(hpage))) {
+			unlock_page(hpage);
+			if (!PageAnon(hpage))
+				pr_info("soft offline: %#lx: non anonymous thp\n", page_to_pfn(page));
+			else
+				pr_info("soft offline: %#lx: thp split failed\n", page_to_pfn(page));
+			put_hwpoison_page(hpage);
 			return -EBUSY;
 		}
+		unlock_page(hpage);
 		get_hwpoison_page(page);
 		put_hwpoison_page(hpage);
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are


