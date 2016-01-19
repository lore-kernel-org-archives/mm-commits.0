From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_isolation-do-some-cleanup-in-undo_isolate_page_range.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:14:03 -0800
Message-ID: <569e990b.ItNX+wq3/ftuNfiA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44417 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbcASUOD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangxq10@lzu.edu.cn, n-horiguchi@ah.jp.nec.com, wang_xiaoq@126.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: do some cleanup in "undo_isolate_page_range"
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-do-some-cleanup-in-undo_isolate_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Xiaoqiang <wangxq10@lzu.edu.cn>
Subject: mm/page_isolation: do some cleanup in "undo_isolate_page_range"

Use "IS_ALIGNED" to judge the alignment, rather than directly judging.

Signed-off-by: Wang Xiaoqiang <wang_xiaoq@126.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/page_isolation.c~mm-page_isolation-do-some-cleanup-in-undo_isolate_page_range mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_isolation-do-some-cleanup-in-undo_isolate_page_range
+++ a/mm/page_isolation.c
@@ -196,8 +196,10 @@ int undo_isolate_page_range(unsigned lon
 {
 	unsigned long pfn;
 	struct page *page;
-	BUG_ON((start_pfn) & (pageblock_nr_pages - 1));
-	BUG_ON((end_pfn) & (pageblock_nr_pages - 1));
+
+	BUG_ON(!IS_ALIGNED(start_pfn, pageblock_nr_pages));
+	BUG_ON(!IS_ALIGNED(end_pfn, pageblock_nr_pages));
+
 	for (pfn = start_pfn;
 	     pfn < end_pfn;
 	     pfn += pageblock_nr_pages) {
_

Patches currently in -mm which might be from wangxq10@lzu.edu.cn are


