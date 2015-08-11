From: akpm@linux-foundation.org
Subject: + mm-hwpoison-fix-pagehwpoison-test-set-race.patch added to -mm
 tree
Date: Tue, 11 Aug 2015 16:26:04 -0700
Message-ID: <55ca848c.trZGuqMyjv80is/5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38314 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbbHKX0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Aug 2015 19:26:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix PageHWPoison test/set race
has been added to the -mm tree.  Its filename is
     mm-hwpoison-fix-pagehwpoison-test-set-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-fix-pagehwpoison-test-set-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-fix-pagehwpoison-test-set-race.patch

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
Subject: mm/hwpoison: fix PageHWPoison test/set race

There is a race between madvise_hwpoison path and memory_failure:

 CPU0					CPU1

madvise_hwpoison
get_user_pages_fast
PageHWPoison check (false)
					memory_failure
					TestSetPageHWPoison
soft_offline_page
PageHWPoison check (true)
return -EBUSY (without put_page)

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memory-failure.c~mm-hwpoison-fix-pagehwpoison-test-set-race mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-fix-pagehwpoison-test-set-race
+++ a/mm/memory-failure.c
@@ -1719,6 +1719,8 @@ int soft_offline_page(struct page *page,
 
 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
+		if (flags & MF_COUNT_INCREASED)
+			put_page(page);
 		return -EBUSY;
 	}
 	if (!PageHuge(page) && PageTransHuge(hpage)) {
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

