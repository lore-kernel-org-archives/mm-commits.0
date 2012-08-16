From: akpm@linux-foundation.org
Subject: + mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch added to -mm tree
Date: Thu, 16 Aug 2012 11:13:02 -0700
Message-ID: <20120816181303.1FC79200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:61354 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab2HPSNF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Aug 2012 14:13:05 -0400
Received: by eaac1 with SMTP id c1so146892eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 16 Aug 2012 11:13:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sanbai@taobao.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kosaki.motohiro@gmail.com, minchan@kernel.org


The patch titled
     Subject: mm: fix nonuniform page status when writing new file with small buffer
has been added to the -mm tree.  Its filename is
     mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Robin Dong <sanbai@taobao.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN mm/swap.c~mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer mm/swap.c
--- a/mm/swap.c~mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer
+++ a/mm/swap.c
@@ -446,13 +446,19 @@ void mark_page_accessed(struct page *pag
 }
 EXPORT_SYMBOL(mark_page_accessed);
 
+/*
+ * Check pagevec space before adding new page into as
+ * it will prevent ununiform page status in
+ * mark_page_accessed() after __lru_cache_add()
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

mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch

