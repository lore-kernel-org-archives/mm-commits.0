From: akpm@linux-foundation.org
Subject: [merged] mm-page_isolation-use-micro-to-judge-the-alignment.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:00:20 -0800
Message-ID: <569e95d4.+RZv880ndjfTvqSO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42313 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbcASUAU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:00:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, wangxq10@lzu.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: use macro to judge the alignment
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-use-micro-to-judge-the-alignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm/page_isolation: use macro to judge the alignment

Signed-off-by: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_isolation.c~mm-page_isolation-use-micro-to-judge-the-alignment mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-use-micro-to-judge-the-alignment
+++ a/mm/page_isolation.c
@@ -165,8 +165,8 @@ int start_isolate_page_range(unsigned lo
 	unsigned long undo_pfn;
 	struct page *page;
 
-	BUG_ON((start_pfn) & (pageblock_nr_pages - 1));
-	BUG_ON((end_pfn) & (pageblock_nr_pages - 1));
+	BUG_ON(!IS_ALIGNED(start_pfn, pageblock_nr_pages));
+	BUG_ON(!IS_ALIGNED(end_pfn, pageblock_nr_pages));
 
 	for (pfn = start_pfn;
 	     pfn < end_pfn;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-soft-offline-clean-up-soft_offline_page.patch
mm-soft-offline-exit-with-failure-for-non-anonymous-thp.patch

