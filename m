From: akpm@linux-foundation.org
Subject: [failures]
 mm-cma-free-cma-page-to-buddy-instead-of-being-cpu-hot-page.patch removed
 from -mm tree
Date: Wed, 06 Nov 2013 15:41:34 -0800
Message-ID: <527ad3ae.OW8tkEx3tRqJJwVc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3KFXlf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Nov 2013 18:41:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, mgorman@suse.de, lauraa@codeaurora.org, kosaki.motohiro@jp.fujitsu.com, troy.zhangmingjun@linaro.org

Subject: [failures] mm-cma-free-cma-page-to-buddy-instead-of-being-cpu-hot-page.patch removed from -mm tree
To: troy.zhangmingjun@linaro.org,kosaki.motohiro@jp.fujitsu.com,lauraa@codeaurora.org,mgorman@suse.de,minchan@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 06 Nov 2013 15:41:34 -0800


The patch titled
     Subject: mm: cma: free cma page to buddy instead of being cpu hot  page
has been removed from the -mm tree.  Its filename was
     mm-cma-free-cma-page-to-buddy-instead-of-being-cpu-hot-page.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Mingjun Zhang <troy.zhangmingjun@linaro.org>
Subject: mm: cma: free cma page to buddy instead of being cpu hot  page

free_contig_range() frees cma pages one by one and MIGRATE_CMA pages will
be used as MIGRATE_MOVEABLE pages in the pcp list, it causes unnecessary
migration action when these pages reused by CMA.

Signed-off-by: Mingjun Zhang <troy.zhangmingjun@linaro.org>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-cma-free-cma-page-to-buddy-instead-of-being-cpu-hot-page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-cma-free-cma-page-to-buddy-instead-of-being-cpu-hot-page
+++ a/mm/page_alloc.c
@@ -1356,7 +1356,8 @@ void free_hot_cold_page(struct page *pag
 	 * excessively into the page allocator
 	 */
 	if (migratetype >= MIGRATE_PCPTYPES) {
-		if (unlikely(is_migrate_isolate(migratetype))) {
+		if (unlikely(is_migrate_isolate(migratetype))
+			|| is_migrate_cma(migratetype))
 			free_one_page(zone, page, 0, migratetype);
 			goto out;
 		}
_

Patches currently in -mm which might be from troy.zhangmingjun@linaro.org are


