From: akpm@linux-foundation.org
Subject: + mm-page_isolation-use-micro-to-judge-the-alignment.patch added
 to -mm tree
Date: Mon, 04 Jan 2016 14:17:10 -0800
Message-ID: <568aef66.zAEJRam/beuqoC4N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbcADWRL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2016 17:17:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, wangxq10@lzu.edu.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_isolation: use macro to judge the alignment
has been added to the -mm tree.  Its filename is
     mm-page_isolation-use-micro-to-judge-the-alignment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_isolation-use-micro-to-judge-the-alignment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_isolation-use-micro-to-judge-the-alignment.patch

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

mm-zonelist-enumerate-zonelists-array-index-fix-fix.patch
mm-zonelist-enumerate-zonelists-array-index-fix-fix-fix.patch
mm-page_isolation-use-micro-to-judge-the-alignment.patch
rmap-add-argument-to-charge-compound-page-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting.patch

