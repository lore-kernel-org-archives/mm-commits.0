From: akpm@linux-foundation.org
Subject: [merged] mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:06:28 -0700
Message-ID: <20121009180629.392D25C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:33588 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISGb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:06:31 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so365043wey.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:06:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sanbai@taobao.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kosaki.motohiro@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix nonuniform page status when writing new file with small buffer
has been removed from the -mm tree.  Its filename was
     mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Robin Dong <sanbai@taobao.com>
Subject: mm: fix nonuniform page status when writing new file with small buffer

When writing a new file with 2048 bytes buffer, such as write(fd, buffer,
2048), it will call generic_perform_write() twice for every page:

	write_begin
	mark_page_accessed(page)
	write_end

	write_begin
	mark_page_accessed(page)
	write_end

Pages 1-13 will be added to lru-pvecs in write_begin() and will *NOT* be
added to active_list even they have be accessed twice because they are not
PageLRU(page).  But when page 14th comes, all pages in lru-pvecs will be
moved to inactive_list (by __lru_cache_add() ) in first write_begin(), now
page 14th *is* PageLRU(page).  And after second write_end() only page 14th
will be in active_list.

In Hadoop environment, we do comes to this situation: after writing a
file, we find out that only 14th, 28th, 42th...  page are in active_list
and others in inactive_list.  Now kswapd works, shrinks the inactive_list,
the file only have 14th, 28th...pages in memory, the readahead request
size will be broken to only 52k (13*4k), system's performance falls
dramatically.

This problem can also replay by below steps (the machine has 8G memory):

	1. dd if=/dev/zero of=/test/file.out bs=1024 count=1048576
	2. cat another 7.5G file to /dev/null
	3. vmtouch -m 1G -v /test/file.out, it will show:

	/test/file.out
	[oooooooooooooooooooOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO] 187847/262144

	the 'o' means same pages are in memory but same are not.

The solution for this problem is simple: the 14th page should be added to
lru_add_pvecs before mark_page_accessed() just as other pages.

[akpm@linux-foundation.org: tweak comment]
[akpm@linux-foundation.org: grab better comment from the v3 patch]
Signed-off-by: Robin Dong <sanbai@taobao.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN mm/swap.c~mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer mm/swap.c
--- a/mm/swap.c~mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer
+++ a/mm/swap.c
@@ -446,13 +446,22 @@ void mark_page_accessed(struct page *pag
 }
 EXPORT_SYMBOL(mark_page_accessed);
 
+/*
+ * Order of operations is important: flush the pagevec when it's already
+ * full, not when adding the last page, to make sure that last page is
+ * not added to the LRU directly when passed to this function. Because
+ * mark_page_accessed() (called after this when writing) only activates
+ * pages that are on the LRU, linear writes in subpage chunks would see
+ * every PAGEVEC_SIZE page activated, which is unexpected.
+ */
 void __lru_cache_add(struct page *page, enum lru_list lru)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvecs)[lru];
 
 	page_cache_get(page);
-	if (!pagevec_add(pvec, page))
+	if (!pagevec_space(pvec))
 		__pagevec_lru_add(pvec, lru);
+	pagevec_add(pvec, page);
 	put_cpu_var(lru_add_pvecs);
 }
 EXPORT_SYMBOL(__lru_cache_add);
_

Patches currently in -mm which might be from sanbai@taobao.com are

origin.patch
linux-next.patch

