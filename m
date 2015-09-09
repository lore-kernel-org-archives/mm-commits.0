From: akpm@linux-foundation.org
Subject: [merged] mm-hwpoison-fix-fail-to-split-thp-w-refcount-held.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:47:38 -0700
Message-ID: <55f08cda.CWBpMgfjUOzF6qRf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbbIITri (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:47:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wanpeng.li@hotmail.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: fix failure to split thp w/ refcount held
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-fix-fail-to-split-thp-w-refcount-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wanpeng Li <wanpeng.li@hotmail.com>
Subject: mm/hwpoison: fix failure to split thp w/ refcount held

THP pages will get a refcount in madvise_hwpoison() w/ MF_COUNT_INCREASED
flag, however, the refcount is still held when fail to split THP pages.

Fix it by reducing the refcount of THP pages when fail to split THP.

Signed-off-by: Wanpeng Li <wanpeng.li@hotmail.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memory-failure.c~mm-hwpoison-fix-fail-to-split-thp-w-refcount-held mm/memory-failure.c
--- a/mm/memory-failure.c~mm-hwpoison-fix-fail-to-split-thp-w-refcount-held
+++ a/mm/memory-failure.c
@@ -1725,6 +1725,8 @@ int soft_offline_page(struct page *page,
 		if (PageAnon(hpage) && unlikely(split_huge_page(hpage))) {
 			pr_info("soft offline: %#lx: failed to split THP\n",
 				pfn);
+			if (flags & MF_COUNT_INCREASED)
+				put_page(page);
 			return -EBUSY;
 		}
 	}
_

Patches currently in -mm which might be from wanpeng.li@hotmail.com are


