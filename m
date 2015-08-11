From: akpm@linux-foundation.org
Subject: +
 mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case.patch added
 to -mm tree
Date: Tue, 11 Aug 2015 16:26:10 -0700
Message-ID: <55ca8492.YpVrb4YvZor/Di/f%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbbHKX0L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Aug 2015 19:26:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix refcount of THP head page in no-injection case
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wanpeng Li <wanpeng.li@hotmail.com>
Subject: mm/hwpoison: fix refcount of THP head page in no-injection case

Hwpoison injection takes a refcount of target page and another refcount of
head page of THP if the target page is the tail page of a THP.  However,
current code doesn't release the refcount of head page if the THP is not
supported to be injected wrt hwpoison filter.

Fix it by reducing the refcount of head page if the target page is the
tail page of a THP and it is not supported to be injected.

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hwpoison-inject.c~mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case mm/hwpoison-inject.c
--- a/mm/hwpoison-inject.c~mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case
+++ a/mm/hwpoison-inject.c
@@ -58,7 +58,7 @@ inject:
 	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
 	return memory_failure(pfn, 18, MF_COUNT_INCREASED);
 put_out:
-	put_page(p);
+	put_hwpoison_page(p);
 	return 0;
 }
 
_

Patches currently in -mm which might be from wanpeng.li@hotmail.com are

mm-hwpoison-fix-page-refcount-of-unkown-non-lru-page.patch
mm-hwpoison-fix-fail-isolate-hugetlbfs-page-w-refcount-held.patch
mm-hwpoison-fix-panic-due-to-split-huge-zero-page.patch
mm-hwpoison-fix-fail-to-split-thp-w-refcount-held.patch
mm-hwpoison-fix-pagehwpoison-test-set-race.patch
mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling.patch
mm-hwpoison-introduce-put_hwpoison_page-to-put-refcount-for-memory-error-handling-fix.patch
mm-hwpoison-fix-refcount-of-thp-head-page-in-no-injection-case.patch
mm-hwpoison-replace-most-of-put_page-in-memory-error-handling-by-put_hwpoison_page.patch

