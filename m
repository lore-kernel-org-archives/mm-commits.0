From: akpm@linux-foundation.org
Subject: + mm-fix-overflow-in-find_zone_movable_pfns_for_nodes.patch added to -mm tree
Date: Wed, 30 Sep 2015 14:47:15 -0700
Message-ID: <560c5863.PR1BnEnruINLs0T9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbbI3VrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:47:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qiuxishi@huawei.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, rientjes@google.com, tangchen@cn.fujitsu.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix overflow in find_zone_movable_pfns_for_nodes()
has been added to the -mm tree.  Its filename is
     mm-fix-overflow-in-find_zone_movable_pfns_for_nodes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-overflow-in-find_zone_movable_pfns_for_nodes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-overflow-in-find_zone_movable_pfns_for_nodes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: fix overflow in find_zone_movable_pfns_for_nodes()

If the user set "movablecore=xx" to a large number, corepages will
overflow.  Fix the problem.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Acked-by: Tang Chen <tangchen@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/page_alloc.c~mm-fix-overflow-in-find_zone_movable_pfns_for_nodes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-overflow-in-find_zone_movable_pfns_for_nodes
+++ a/mm/page_alloc.c
@@ -5485,6 +5485,7 @@ static void __init find_zone_movable_pfn
 		 */
 		required_movablecore =
 			roundup(required_movablecore, MAX_ORDER_NR_PAGES);
+		required_movablecore = min(totalpages, required_movablecore);
 		corepages = totalpages - required_movablecore;
 
 		required_kernelcore = max(required_kernelcore, corepages);
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

mm-fix-overflow-in-find_zone_movable_pfns_for_nodes.patch
kasan-use-is_aligned-in-memory_is_poisoned_8.patch

