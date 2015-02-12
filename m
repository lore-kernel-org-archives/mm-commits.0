From: akpm@linux-foundation.org
Subject: [merged]
 kmemcheck-move-hook-into-__alloc_pages_nodemask-for-the-page-allocator.patch removed from -mm tree
Date: Thu, 12 Feb 2015 11:36:09 -0800
Message-ID: <54dd00a9.jWpmKR8mvu5D9CR1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbbBLTgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, lizefan@huawei.com, penberg@kernel.org, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kmemcheck: move hook into __alloc_pages_nodemask() for the page allocator
has been removed from the -mm tree.  Its filename was
     kmemcheck-move-hook-into-__alloc_pages_nodemask-for-the-page-allocator.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: kmemcheck: move hook into __alloc_pages_nodemask() for the page allocator

Now kmemcheck_pagealloc_alloc() is only called by __alloc_pages_slowpath().
__alloc_pages_nodemask()
	__alloc_pages_slowpath()
		kmemcheck_pagealloc_alloc()

And the page will not be tracked by kmemcheck in the following path.
__alloc_pages_nodemask()
	get_page_from_freelist()

So move kmemcheck_pagealloc_alloc() into __alloc_pages_nodemask(),
like this:
__alloc_pages_nodemask()
	...
	get_page_from_freelist()
	if (!page)
		__alloc_pages_slowpath()
	kmemcheck_pagealloc_alloc()
	...

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~kmemcheck-move-hook-into-__alloc_pages_nodemask-for-the-page-allocator mm/page_alloc.c
--- a/mm/page_alloc.c~kmemcheck-move-hook-into-__alloc_pages_nodemask-for-the-page-allocator
+++ a/mm/page_alloc.c
@@ -2842,11 +2842,7 @@ retry:
 
 nopage:
 	warn_alloc_failed(gfp_mask, order, NULL);
-	return page;
 got_pg:
-	if (kmemcheck_enabled)
-		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
