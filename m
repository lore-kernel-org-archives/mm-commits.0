From: akpm@linux-foundation.org
Subject: [merged] thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:15 -0800
Message-ID: <201101142249.p0EMn5p2005263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755Ab1ANWtS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: fix bad_page to show the real reason the page is bad
has been removed from the -mm tree.  Its filename was
     thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: fix bad_page to show the real reason the page is bad
From: Andrea Arcangeli <aarcange@redhat.com>

page_count shows the count of the head page, but the actual check is done
on the tail page, so show what is really being checked.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad mm/page_alloc.c
--- a/mm/page_alloc.c~thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad
+++ a/mm/page_alloc.c
@@ -5618,7 +5618,7 @@ void dump_page(struct page *page)
 {
 	printk(KERN_ALERT
 	       "page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
-		page, page_count(page), page_mapcount(page),
+		page, atomic_read(&page->_count), page_mapcount(page),
 		page->mapping, page->index);
 	dump_page_flags(page->flags);
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

