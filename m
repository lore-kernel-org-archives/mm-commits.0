From: akpm@linux-foundation.org
Subject: + mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch
 added to -mm tree
Date: Tue, 12 Jan 2016 15:19:18 -0800
Message-ID: <569589f6.ajNJcvReUZ0EBR8t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbcALXTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jan 2016 18:19:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, andi@firstfloor.org, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: soft-offline: exit with failure for non anonymous thp
has been added to the -mm tree.  Its filename is
     mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch

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
+				pr_info("soft offline: %#lx: non anonymous thp\n", pfn);
+			else
+				pr_info("soft offline: %#lx: thp split failed\n", pfn);
+			put_hwpoison_page(hpage);
 			return -EBUSY;
 		}
+		unlock_page(hpage);
 		get_hwpoison_page(page);
 		put_hwpoison_page(hpage);
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-zonelist-enumerate-zonelists-array-index-fix-fix.patch
mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix.patch
mm-page_isolation-use-micro-to-judge-the-alignment.patch
rmap-add-argument-to-charge-compound-page-fix.patch
mm-soft-offline-check-return-value-in-second-__get_any_page-call.patch
mm-hwpoison-adjust-for-new-thp-refcounting.patch
mm-soft-offline-clean-up-soft_offline_page.patch
mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch

