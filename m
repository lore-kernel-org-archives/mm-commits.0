From: akpm@linux-foundation.org
Subject: [merged] mm-hwpoison-fix-pagehwpoison-test-set-race.patch removed from -mm tree
Date: Wed, 09 Sep 2015 12:47:40 -0700
Message-ID: <55f08cdc.g23mF4YgB9HCCzQD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbbIITrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix PageHWPoison test/set race
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-pagehwpoison-test-set-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


