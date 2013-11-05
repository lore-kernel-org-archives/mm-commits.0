From: akpm@linux-foundation.org
Subject: +
 mm-cma-free-cma-page-to-buddy-instead-of-being-cpu-hot-page.patch added to
 -mm tree
Date: Tue, 05 Nov 2013 13:46:47 -0800
Message-ID: <52796747.BpOPCsA996uiyLq0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3KEVqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 16:46:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, mgorman@suse.de, lauraa@codeaurora.org, kosaki.motohiro@jp.fujitsu.com, troy.zhangmingjun@linaro.org

Subject: + mm-cma-free-cma-page-to-buddy-instead-of-being-cpu-hot-page.patch added to -mm tree
To: troy.zhangmingjun@linaro.org,kosaki.motohiro@jp.fujitsu.com,lauraa@codeaurora.org,mgorman@suse.de,minchan@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 13:46:47 -0800


The patch titled
     Subject: mm: cma: free cma page to buddy instead of being cpu hot  page
has been added to the -mm tree.  Its filename is
     mm-cma-free-cma-page-to-buddy-instead-of-being-cpu-hot-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-free-cma-page-to-buddy-instead-of-being-cpu-hot-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-free-cma-page-to-buddy-instead-of-being-cpu-hot-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-cma-free-cma-page-to-buddy-instead-of-being-cpu-hot-page.patch

